Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaBMQ00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:26:26 -0500
Received: from top.free-electrons.com ([176.31.233.9]:51531 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751516AbaBMQ0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:26:24 -0500
Date: Thu, 13 Feb 2014 17:26:20 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/13] pinctrl: mvebu: restructure resource
 allocation
Message-ID: <20140213172620.76e760ba@skate>
In-Reply-To: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/QCDS/7PET.ceInuxFmlCq=N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/QCDS/7PET.ceInuxFmlCq=N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Dear Sebastian Hesselbarth,

Thanks again for working on this! I have boot tested this successfully
on an Armada XP platform, and it seems to behave normally, the debugfs
pinctrl contents make sense.

I have a few comments below, though.

On Wed, 12 Feb 2014 16:59:23 +0100, Sebastian Hesselbarth wrote:

> Also, in the meantime, pinctrl driver stubs for new Armada 375/28x have
> been posted [3]. Before any of this patches move to a stable branch, I
> plan to send an updated version comprising the required patches for the
> new SoCs. As the new driver stubs are very much like what we already have
> for Armada 370/XP, let's only discuss the general approach now and add
> the branch dependency and patches later.

I am not sure what you mean here in terms of the ordering for the
patches. I'm attaching several patches, and the first three patches
adapt your patch series to also cover 375 and 38x, assuming the pinctrl
support for 375 and 38x is merged before your patch series.

With these patches, I have 


> Patches 1-3 first deal with the way we handle unnamed "generic" mpp
> controls. Patch 1 consolidates the per-control allocation of name buffers
> to counting unnamed controls first and then allocate a global name buffer
> for all those controls. Patch 2 then removes the now obsolete per-control
> allocation of name buffers. Patch 3 then makes the common driver to
> identify "generic" mpp controls by an empty name and adds some valuable
> comments about that special treatment.

I must say I dislike quite a bit this unnamed mpp controls mechanism.
Why isn't the name statically defined in the source code by the
MPP_MODE macro, which already takes as first argument the pin number?

All the calculation of the buffer size, generating the names and so on,
looks like a lot of unnecessary code to me. But well, this unnamed
thing was already here, so I'm not saying your patch series should do
anything about it.

> Patch 4 removes passing struct mvebu_mpp_ctrl to the special callback
> as the only relevant information in that struct for the callback is the
> pin number which is passed directly instead.
> 
> Patches 5-9 then add some global defines and provide SoC specific
> callbacks even for the "generic" mpp controls. This allows Patch 10 to
> move resource allocation to SoC specific drivers and remove the common
> generic callbacks in Patch 11.

This is definitely good, but I'm wondering why the core cannot provide
helper functions for the generic case where we have 4 bits per pin in
contiguous registers. This would avoid duplicating the helper function
six times (you have four in your patch series, and we'll need two more
for A375 and A38x).

I've also attached other patches:

 * One patch that fixes your Armada XP handling, which missed the
   mv78230 and mv78260 cases (PATCH 4)

 * One patch that removes MPP_REG_CTRL (PATCH 5)

 * One patch that adjusts a comment in the code that was no longer true
   (PATCH 6)

Feel free to squash these patches into the appropriate patches.

Thanks!

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--MP_/QCDS/7PET.ceInuxFmlCq=N
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-pinctrl-mvebu-armada-375-provide-generic-mpp-callbac.patch

>From 681072596a94a293bbd7683f38fb2ef125003fcc Mon Sep 17 00:00:00 2001
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date: Thu, 13 Feb 2014 17:08:35 +0100
Subject: [PATCH 1/6] pinctrl: mvebu: armada-375: provide generic mpp callbacks

We want to get rid of passing register addresses to common pinctrl
driver, so provide set/get callbacks for generic mpp pins that will
be used later.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/pinctrl/mvebu/pinctrl-armada-375.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-375.c b/drivers/pinctrl/mvebu/pinctrl-armada-375.c
index c741a34..459ca5d 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-375.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-375.c
@@ -23,6 +23,30 @@
 
 #include "pinctrl-mvebu.h"
 
+static void __iomem *mpp_base;
+
+static int armada_375_mpp_ctrl_get(unsigned pid, unsigned long *config)
+{
+	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+
+	*config = (readl(mpp_base + off) >> shift) & MVEBU_MPP_MASK;
+
+	return 0;
+}
+
+static int armada_375_mpp_ctrl_set(unsigned pid, unsigned long config)
+{
+	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned long reg;
+
+	reg = readl(mpp_base + off) & ~(MVEBU_MPP_MASK << shift);
+	writel(reg | (config << shift), mpp_base + off);
+
+	return 0;
+}
+
 static struct mvebu_mpp_mode mv88f6720_mpp_modes[] = {
 	MPP_MODE(0,
 		 MPP_FUNCTION(0x0, "gpio", NULL),
-- 
1.8.3.2


--MP_/QCDS/7PET.ceInuxFmlCq=N
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0002-pinctrl-mvebu-armada-38x-provide-generic-mpp-callbac.patch

>From 869c02cb4040424b3817fcb0ef22780bdb8c8671 Mon Sep 17 00:00:00 2001
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date: Thu, 13 Feb 2014 17:09:12 +0100
Subject: [PATCH 2/6] pinctrl: mvebu: armada-38x: provide generic mpp callbacks

We want to get rid of passing register addresses to common pinctrl
driver, so provide set/get callbacks for generic mpp pins that will
be used later.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/pinctrl/mvebu/pinctrl-armada-38x.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-38x.c b/drivers/pinctrl/mvebu/pinctrl-armada-38x.c
index b3aa85e..9265f17 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-38x.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-38x.c
@@ -22,6 +22,30 @@
 
 #include "pinctrl-mvebu.h"
 
+static void __iomem *mpp_base;
+
+static int armada_38x_mpp_ctrl_get(unsigned pid, unsigned long *config)
+{
+	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+
+	*config = (readl(mpp_base + off) >> shift) & MVEBU_MPP_MASK;
+
+	return 0;
+}
+
+static int armada_38x_mpp_ctrl_set(unsigned pid, unsigned long config)
+{
+	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned long reg;
+
+	reg = readl(mpp_base + off) & ~(MVEBU_MPP_MASK << shift);
+	writel(reg | (config << shift), mpp_base + off);
+
+	return 0;
+}
+
 enum {
 	V_88F6810 = BIT(0),
 	V_88F6820 = BIT(1),
-- 
1.8.3.2


--MP_/QCDS/7PET.ceInuxFmlCq=N
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0003-fixup-pinctrl-mvebu-move-resource-allocation-to-SoC-.patch

>From 9357d576557727ff9f2d6c214690f61dc1e578b5 Mon Sep 17 00:00:00 2001
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date: Thu, 13 Feb 2014 17:09:49 +0100
Subject: [PATCH 3/6] fixup! pinctrl: mvebu: move resource allocation to SoC
 specific drivers

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/pinctrl/mvebu/pinctrl-armada-375.c | 8 +++++++-
 drivers/pinctrl/mvebu/pinctrl-armada-38x.c | 8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-375.c b/drivers/pinctrl/mvebu/pinctrl-armada-375.c
index 459ca5d..50d0df05 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-375.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-375.c
@@ -417,7 +417,7 @@ static struct of_device_id armada_375_pinctrl_of_match[] = {
 };
 
 static struct mvebu_mpp_ctrl mv88f6720_mpp_controls[] = {
-	MPP_REG_CTRL(0, 69),
+	MPP_FUNC_CTRL(0, 69, NULL, armada_375_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv88f6720_mpp_gpio_ranges[] = {
@@ -429,6 +429,12 @@ static struct pinctrl_gpio_range mv88f6720_mpp_gpio_ranges[] = {
 static int armada_375_pinctrl_probe(struct platform_device *pdev)
 {
 	struct mvebu_pinctrl_soc_info *soc = &armada_375_pinctrl_info;
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mpp_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mpp_base))
+		return PTR_ERR(mpp_base);
 
 	soc->variant = 0; /* no variants for Armada 375 */
 	soc->controls = mv88f6720_mpp_controls;
diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-38x.c b/drivers/pinctrl/mvebu/pinctrl-armada-38x.c
index 9265f17..b9e2b11 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-38x.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-38x.c
@@ -416,7 +416,7 @@ static struct of_device_id armada_38x_pinctrl_of_match[] = {
 };
 
 static struct mvebu_mpp_ctrl armada_38x_mpp_controls[] = {
-	MPP_REG_CTRL(0, 59),
+	MPP_FUNC_CTRL(0, 59, NULL, armada_38x_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range armada_38x_mpp_gpio_ranges[] = {
@@ -429,10 +429,16 @@ static int armada_38x_pinctrl_probe(struct platform_device *pdev)
 	struct mvebu_pinctrl_soc_info *soc = &armada_38x_pinctrl_info;
 	const struct of_device_id *match =
 		of_match_device(armada_38x_pinctrl_of_match, &pdev->dev);
+	struct resource *res;
 
 	if (!match)
 		return -ENODEV;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mpp_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mpp_base))
+		return PTR_ERR(mpp_base);
+
 	soc->variant = (unsigned) match->data & 0xff;
 
 	soc->controls = armada_38x_mpp_controls;
-- 
1.8.3.2


--MP_/QCDS/7PET.ceInuxFmlCq=N
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0004-fixup-pinctrl-mvebu-move-resource-allocation-to-SoC-.patch

>From 25052721133e44582462618015ea4594fdb90858 Mon Sep 17 00:00:00 2001
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date: Thu, 13 Feb 2014 17:11:07 +0100
Subject: [PATCH 4/6] fixup! pinctrl: mvebu: move resource allocation to SoC
 specific drivers

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
index 6acea00..be3b913 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
@@ -390,7 +390,7 @@ static struct of_device_id armada_xp_pinctrl_of_match[] = {
 };
 
 static struct mvebu_mpp_ctrl mv78230_mpp_controls[] = {
-	MPP_REG_CTRL(0, 48),
+	MPP_FUNC_CTRL(0, 48, NULL, armada_xp_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv78230_mpp_gpio_ranges[] = {
@@ -399,7 +399,7 @@ static struct pinctrl_gpio_range mv78230_mpp_gpio_ranges[] = {
 };
 
 static struct mvebu_mpp_ctrl mv78260_mpp_controls[] = {
-	MPP_REG_CTRL(0, 66),
+	MPP_FUNC_CTRL(0, 66, NULL, armada_xp_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv78260_mpp_gpio_ranges[] = {
-- 
1.8.3.2


--MP_/QCDS/7PET.ceInuxFmlCq=N
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0005-pinctrl-mvebu-remove-MPP_REG_CTRL-macro.patch

>From 9b3c22a3de0fb8a61ec48a7d762ba2492233d5f5 Mon Sep 17 00:00:00 2001
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date: Thu, 13 Feb 2014 17:11:27 +0100
Subject: [PATCH 5/6] pinctrl: mvebu: remove MPP_REG_CTRL macro

Now that each per-SoC pinctrl driver must implement its own get/set
functions, there is no point in keeping the MPP_REG_CTRL macro, whose
purpose was to let the core pinctrl mvebu driver use default get/set
functions.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/pinctrl/mvebu/pinctrl-mvebu.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.h b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
index 41feceb..f8dc035 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.h
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
@@ -114,18 +114,6 @@ struct mvebu_pinctrl_soc_info {
 	int ngpioranges;
 };
 
-#define MPP_REG_CTRL(_idl, _idh)				\
-	{							\
-		.name = NULL,					\
-		.pid = _idl,					\
-		.npins = _idh - _idl + 1,			\
-		.pins = (unsigned[_idh - _idl + 1]) { },	\
-		.mpp_get = NULL,				\
-		.mpp_set = NULL,				\
-		.mpp_gpio_req = NULL,				\
-		.mpp_gpio_dir = NULL,				\
-	}
-
 #define MPP_FUNC_CTRL(_idl, _idh, _name, _func)			\
 	{							\
 		.name = _name,					\
-- 
1.8.3.2


--MP_/QCDS/7PET.ceInuxFmlCq=N
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0006-pinctrl-mvebu-update-comment-about-mvebu_mpp_ctrl.patch

>From cb3c50109c1553070843029a256052667c32136f Mon Sep 17 00:00:00 2001
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Date: Thu, 13 Feb 2014 17:23:49 +0100
Subject: [PATCH 6/6] pinctrl: mvebu: update comment about mvebu_mpp_ctrl

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/pinctrl/mvebu/pinctrl-mvebu.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.h b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
index f8dc035..58e973e 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.h
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
@@ -28,10 +28,9 @@
  * between two or more different settings, e.g. assign mpp pin 13 to
  * uart1 or sata.
  *
- * If optional mpp_get/_set functions are set these are used to get/set
- * a specific mode. Otherwise it is assumed that the mpp control is based
- * on 4-bit groups in subsequent registers. The optional mpp_gpio_req/_dir
- * functions can be used to allow pin settings with varying gpio pins.
+ * The mpp_get/_set functions are mandatory and are used to get/set a
+ * specific mode. The optional mpp_gpio_req/_dir functions can be used
+ * to allow pin settings with varying gpio pins.
  */
 struct mvebu_mpp_ctrl {
 	const char *name;
-- 
1.8.3.2


--MP_/QCDS/7PET.ceInuxFmlCq=N--
