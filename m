Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3EHOV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:21:59 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:38870 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755188Ab3EHOVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:21:55 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: dong.aisheng@linaro.org, sameo@linux.intel.com
Cc: Rob Landley <rob@landley.net>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: [RFC 3/8] mfd:syscon: Introduce claim/read/write/release APIs
Date: Wed,  8 May 2013 15:11:12 +0100
Message-Id: <1368022272-2241-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch introduces syscon_claim, syscon_read, syscon_write,
syscon_release APIs to help drivers to use syscon registers in much more
flexible way.

With this patch, a driver can claim few/all bits in the syscon registers
and do read/write and then release them when its totally finished with
them, in the mean time if another driver requests same bits or registers
the API will detect conflit and return error to the second request.

Reason to introduce this API.
System configuration/control registers are very basic configuration
registers arranged in groups across ST Settop Box parts. These registers
are independent of IP itself. Many IPs, clock, pad and other functions
are wired up to these registers.

In many cases a single syconf register contains bits related to multiple
devices, and therefore it need to be shared across multiple drivers at
bit level. The same IP block can have different syscon mappings on
different SOCs.

Typically in a SOC there will be more than hundreds of these registers,
which are again divided into groups.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
CC: Stuart Menefy <stuart.menefy@st.com>
---
 drivers/mfd/syscon.c       |  199 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/syscon.h |   43 ++++++++++
 2 files changed, 242 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 61aea63..fab85da 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/slab.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
@@ -28,8 +29,23 @@ struct syscon {
 	struct device *dev;
 	void __iomem *base;
 	struct regmap *regmap;
+	struct device_node *of_node;
+	struct list_head list;
+	struct list_head fields;
+	spinlock_t fields_lock;
 };
 
+struct syscon_field {
+	struct syscon *syscon;
+	u16 num;
+	u8 lsb, msb;
+	unsigned int offset;
+	const char *owner;
+	struct list_head list;
+};
+
+static LIST_HEAD(syscons);
+
 static int syscon_match(struct device *dev, void *data)
 {
 	struct syscon *syscon = dev_get_drvdata(dev);
@@ -87,6 +103,185 @@ struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
 }
 EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_phandle);
 
+static int syscon_add_field(struct syscon_field *field)
+{
+	struct syscon_field *entry;
+	enum {
+		status_not_found,
+		status_found_register,
+		status_add_field_here,
+	} status = status_not_found;
+	int bit_avail = 0;
+	struct syscon *syscon = field->syscon;
+	int rval = 0;
+	int num = field->num;
+	int lsb = field->lsb;
+	int msb = field->msb;
+
+	spin_lock(&syscon->fields_lock);
+	/*
+	 * The list is always in syscon->num->lsb/msb order, so it's easy to
+	 * find a place to insert a new field (and to detect conflicts)
+	 */
+	list_for_each_entry(entry, &syscon->fields, list) {
+		if (entry->num == num) {
+			status = status_found_register;
+			/*
+			 * Someone already claimed a field from this
+			 * register - let's try to find some space for
+			 * requested bits...
+			 */
+			if (bit_avail <= lsb && msb < entry->lsb) {
+				status = status_add_field_here;
+				break;
+			}
+			bit_avail = entry->msb + 1;
+		} else if (entry->num > num) {
+			/*
+			 * There is no point of looking further -
+			 * the num values are bigger then
+			 * the ones we are looking for
+			 */
+			if ((status == status_found_register &&
+					bit_avail <= lsb) ||
+					status == status_not_found)
+				/*
+				 * A remainder of the given register is not
+				 * used or the register wasn't used at all
+				 */
+				status = status_add_field_here;
+			else
+				/*
+				 * Apparently some bits of the claimed field
+				 * are already in use...
+				 */
+				rval = -EBUSY;
+			break;
+		}
+	}
+
+	if ((status == status_not_found) || (status == status_found_register))
+		list_add_tail(&field->list, &syscon->fields);
+	else if (status == status_add_field_here)
+		list_add(&field->list, entry->list.prev);
+
+	spin_unlock(&syscon->fields_lock);
+	return rval;
+}
+
+static struct syscon *find_syscon(struct device_node *np)
+{
+	struct syscon *syscon;
+
+	list_for_each_entry(syscon, &syscons, list) {
+		if (syscon->of_node == np)
+			return syscon;
+	}
+	return NULL;
+}
+
+#define MIN_SYSCON_CELLS	(4)
+
+struct syscon_field *syscon_claim(struct device_node *np,
+				const char *prop)
+{
+	const __be32 *list;
+	const struct property *pp;
+	struct syscon_field *field;
+	phandle phandle;
+	struct device_node *syscon_np;
+	u32 syscon_num;
+
+	pp = of_find_property(np, prop, NULL);
+	if (!pp)
+		return NULL;
+
+	if (pp->length < ((MIN_SYSCON_CELLS) * sizeof(*list)))
+		return NULL;
+
+	list = pp->value;
+
+	/* syscon */
+	phandle = be32_to_cpup(list++);
+	syscon_np = of_find_node_by_phandle(phandle);
+	if (!syscon_np) {
+		pr_warn("No syscon found for %s syscon\n", prop);
+		return NULL;
+	}
+
+	field = kzalloc(sizeof(struct syscon_field), GFP_KERNEL);
+	if (!field)
+		return NULL;
+
+	field->syscon = find_syscon(syscon_np);
+	if (!field->syscon) {
+		pr_warn("No syscon registered for %s syscon\n", prop);
+		goto error;
+	}
+
+	of_node_put(syscon_np);
+	syscon_num = be32_to_cpup(list++);
+	field->offset = (syscon_num) * 4;
+	field->lsb = be32_to_cpup(list++);
+	field->msb = be32_to_cpup(list++);
+	field->num = syscon_num;
+	field->owner = pp->name;
+
+	if (syscon_add_field(field))
+		goto error;
+
+	return field;
+error:
+	kfree(field);
+	return NULL;
+}
+EXPORT_SYMBOL(syscon_claim);
+
+void syscon_release(struct syscon_field *field)
+{
+	struct syscon *syscon;
+	if (field) {
+		syscon = field->syscon;
+		spin_lock(&syscon->fields_lock);
+		list_del(&field->list);
+		spin_unlock(&syscon->fields_lock);
+		kfree(field);
+	}
+}
+EXPORT_SYMBOL(syscon_release);
+
+void syscon_write(struct syscon_field *field, unsigned long value)
+{
+	int field_bits;
+	struct syscon *syscon = field->syscon;
+
+	field_bits = field->msb - field->lsb + 1;
+	if (field_bits == 32) {
+		regmap_write(syscon->regmap, field->offset, value);
+	} else {
+		u32 reg_mask;
+		reg_mask = (((1 << field_bits) - 1) << field->lsb);
+		regmap_update_bits(syscon->regmap, field->offset,
+					reg_mask, value << field->lsb);
+	}
+}
+EXPORT_SYMBOL(syscon_write);
+
+unsigned long syscon_read(struct syscon_field *field)
+{
+	int field_bits;
+	u32 result;
+	struct syscon *syscon = field->syscon;
+
+	regmap_read(syscon->regmap, field->offset, &result);
+	field_bits = field->msb - field->lsb + 1;
+	result >>= field->lsb;
+	result &= (1 << field_bits) - 1;
+
+	return result;
+}
+EXPORT_SYMBOL(syscon_read);
+
 static const struct of_device_id of_syscon_match[] = {
 	{ .compatible = "syscon", },
 	{ },
@@ -122,6 +317,10 @@ static int syscon_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	list_add_tail(&syscon->list, &syscons);
+	INIT_LIST_HEAD(&syscon->fields);
+	syscon->of_node = np;
+
 	syscon_regmap_config.max_register = res.end - res.start - 3;
 	syscon->regmap = devm_regmap_init_mmio(dev, syscon->base,
 					&syscon_regmap_config);
diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
index 6aeb6b8..0de0da5 100644
--- a/include/linux/mfd/syscon.h
+++ b/include/linux/mfd/syscon.h
@@ -15,9 +15,52 @@
 #ifndef __LINUX_MFD_SYSCON_H__
 #define __LINUX_MFD_SYSCON_H__
 
+struct syscon_field;
+
 extern struct regmap *syscon_node_to_regmap(struct device_node *np);
 extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
 extern struct regmap *syscon_regmap_lookup_by_phandle(
 					struct device_node *np,
 					const char *property);
+
+/**
+ * syscon_claim - Claim ownership of a field of a syscon register
+ * @np: parent node pointer.
+ * @prop: name of sysconf to claim.
+ *
+ * This function claims ownership of a field from a syscon register.
+ * It returns a &struct syscon_field which can be used in subsequent
+ * operations on this field.
+ */
+struct syscon_field *syscon_claim(struct device_node *np,
+			const char *prop);
+
+/**
+ * syscon_release - Release ownership of a field of a syscon register
+ * @field: the syscon field to write to
+ *
+ * Release ownership of a field from a syscon register.
+ * @field must have been claimed using syscon_claim().
+ */
+void syscon_release(struct syscon_field *field);
+
+/**
+ * syscon_write - Write a value into a field of a syscon register
+ * @field: the syscon field to write to
+ * @value: the value to write into the field
+ *
+ * This writes @value into the field of the syscon register @field.
+ * @field must have been claimed using syscon_claim().
+ */
+void syscon_write(struct syscon_field *field, unsigned long value);
+
+/**
+ * syscon_read - Read a field of a syscon register
+ * @field: the syscon field to read
+ *
+ * This reads a field of the syscon register @field.
+ * @field must have been claimed using syscon_claim().
+ */
+unsigned long syscon_read(struct syscon_field *field);
+
 #endif /* __LINUX_MFD_SYSCON_H__ */
-- 
1.7.6.5

