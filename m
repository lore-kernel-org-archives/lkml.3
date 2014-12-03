Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaLCCFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:05:40 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41730 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaLCCET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:04:19 -0500
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, peterz@infradead.org, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 3/6] powerpc/perf/hv-24x7: parse catalog and populate sysfs with events
Date: Tue,  2 Dec 2014 18:03:52 -0800
Message-Id: <1417572235-8197-4-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417572235-8197-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1417572235-8197-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120302-0025-0000-0000-0000069349C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

Retrieves and parses the 24x7 catalog on POWER systems that supply it
(right now, only POWER 8). Events are exposed via sysfs in the standard
fashion, and are all parameterized.

	$ cd /sys/bus/event_source/devices/hv_24x7/events

	$ cat HPM_CS_FROM_L4_LDATA__PHYS_CORE
	domain=0x2,offset=0xd58,starting_index=$core,lpar=0x0

	$ cat HPM_TLBIE__VCPU_HOME_CHIP
	domain=0x4,offset=0x358,starting_index=$vcpu,lpar=$sibling_guest_id

where user has to specify values for $core when specifying the first event
and $vcpu and $sibling_guest_id when specifying the second event with the
perf tool.

Catalog is (at the moment) only parsed on boot. It needs re-parsing
when a some hypervisor events occur. At that point we'll also need to
prevent old events from continuing to function (counter that is passed
in via spare space in the config values?).

Changelog[v5]
	[Jiri Olsa, Peter Zijlstra] Prefix required parameters with '$'
	to make it easy for user to recognize.

Changelog[v4]
	[Sukadev Bhattiprolu] Use PHYS and VCPU in place of PHYSICAL and
	VIRTUAL_PROCESSOR to shorten the names of the domains and hence,
	events;

Changelog[v2]
	[Joe Perches, David Laight] Use beNN_to_cpu() instead of guessing
		the size from type.
	Use kmem_cache_free() to free page allocated with kmem_cache_alloc().

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Haren Myneni <hbabu@us.ibm.com>
CC: Cody P Schafer <dev@codyps.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/perf/hv-24x7-catalog.h |  25 ++
 arch/powerpc/perf/hv-24x7-domains.h |  28 ++
 arch/powerpc/perf/hv-24x7.c         | 787 +++++++++++++++++++++++++++++++++++-
 arch/powerpc/perf/hv-24x7.h         |  12 +-
 4 files changed, 838 insertions(+), 14 deletions(-)
 create mode 100644 arch/powerpc/perf/hv-24x7-domains.h

diff --git a/arch/powerpc/perf/hv-24x7-catalog.h b/arch/powerpc/perf/hv-24x7-catalog.h
index 21b19dd..69e2e1f 100644
--- a/arch/powerpc/perf/hv-24x7-catalog.h
+++ b/arch/powerpc/perf/hv-24x7-catalog.h
@@ -30,4 +30,29 @@ struct hv_24x7_catalog_page_0 {
 	__u8 reserved6[2];
 } __packed;
 
+struct hv_24x7_event_data {
+	__be16 length; /* in bytes, must be a multiple of 16 */
+	__u8 reserved1[2];
+	__u8 domain; /* Chip = 1, Core = 2 */
+	__u8 reserved2[1];
+	__be16 event_group_record_offs; /* in bytes, must be 8 byte aligned */
+	__be16 event_group_record_len; /* in bytes */
+
+	/* in bytes, offset from event_group_record */
+	__be16 event_counter_offs;
+
+	/* verified_state, unverified_state, caveat_state, broken_state, ... */
+	__be32 flags;
+
+	__be16 primary_group_ix;
+	__be16 group_count;
+	__be16 event_name_len;
+	__u8 remainder[];
+	/* __u8 event_name[event_name_len - 2]; */
+	/* __be16 event_description_len; */
+	/* __u8 event_desc[event_description_len - 2]; */
+	/* __be16 detailed_desc_len; */
+	/* __u8 detailed_desc[detailed_desc_len - 2]; */
+} __packed;
+
 #endif
diff --git a/arch/powerpc/perf/hv-24x7-domains.h b/arch/powerpc/perf/hv-24x7-domains.h
new file mode 100644
index 0000000..49c1efd
--- /dev/null
+++ b/arch/powerpc/perf/hv-24x7-domains.h
@@ -0,0 +1,28 @@
+
+/*
+ * DOMAIN(name, num, index_kind, is_physical)
+ *
+ * @name:	An all caps token, suitable for use in generating an enum
+ *		member and appending to an event name in sysfs.
+ *
+ * @num:	The number corresponding to the domain as given in
+ *		documentation. We assume the catalog domain and the hcall
+ *		domain have the same numbering (so far they do), but this
+ *		may need to be changed in the future.
+ *
+ * @index_kind: A stringifiable token describing the meaning of the index
+ *		within the given domain. Must fit the parsing rules of the
+ *		perf sysfs api.
+ *
+ * @is_physical: True if the domain is physical, false otherwise (if virtual).
+ *
+ * Note: The terms PHYS_CHIP, PHYS_CORE, VCPU correspond to physical chip,
+ *	 physical core and virtual processor in 24x7 Counters specifications.
+ */
+
+DOMAIN(PHYS_CHIP, 0x01, chip, true)
+DOMAIN(PHYS_CORE, 0x02, core, true)
+DOMAIN(VCPU_HOME_CORE, 0x03, vcpu, false)
+DOMAIN(VCPU_HOME_CHIP, 0x04, vcpu, false)
+DOMAIN(VCPU_HOME_NODE, 0x05, vcpu, false)
+DOMAIN(VCPU_REMOTE_NODE, 0x06, vcpu, false)
diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index dba3408..73d5bfc 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -13,16 +13,80 @@
 #define pr_fmt(fmt) "hv-24x7: " fmt
 
 #include <linux/perf_event.h>
+#include <linux/rbtree.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
+
 #include <asm/firmware.h>
 #include <asm/hvcall.h>
 #include <asm/io.h>
+#include <linux/byteorder/generic.h>
 
 #include "hv-24x7.h"
 #include "hv-24x7-catalog.h"
 #include "hv-common.h"
 
+static const char *domain_to_index_string(unsigned domain)
+{
+	switch (domain) {
+#define DOMAIN(n, v, x, c)		\
+	case HV_PERF_DOMAIN_##n:	\
+		return "$"#x;
+#include "hv-24x7-domains.h"
+#undef DOMAIN
+	default:
+		WARN(1, "unknown domain %d\n", domain);
+		return "UNKNOWN_DOMAIN_INDEX_STRING";
+	}
+}
+
+static const char *event_domain_suffix(unsigned domain)
+{
+	switch (domain) {
+#define DOMAIN(n, v, x, c)		\
+	case HV_PERF_DOMAIN_##n:	\
+		return "__" #n;
+#include "hv-24x7-domains.h"
+#undef DOMAIN
+	default:
+		WARN(1, "unknown domain %d\n", domain);
+		return "__UNKNOWN_DOMAIN_SUFFIX";
+	}
+}
+
+static bool domain_is_valid(unsigned domain)
+{
+	switch (domain) {
+#define DOMAIN(n, v, x, c)		\
+	case HV_PERF_DOMAIN_##n:	\
+		/* fall through */
+#include "hv-24x7-domains.h"
+#undef DOMAIN
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool is_physical_domain(unsigned domain)
+{
+	switch (domain) {
+#define DOMAIN(n, v, x, c)		\
+	case HV_PERF_DOMAIN_##n:	\
+		return c;
+#include "hv-24x7-domains.h"
+#undef DOMAIN
+	default:
+		return false;
+	}
+}
+
+static bool catalog_entry_domain_is_valid(unsigned domain)
+{
+	return is_physical_domain(domain);
+}
+
 /*
  * TODO: Merging events:
  * - Think of the hcall as an interface to a 4d array of counters:
@@ -73,8 +137,115 @@ static struct attribute_group format_group = {
 	.attrs = format_attrs,
 };
 
+static struct attribute_group event_group = {
+	.name = "events",
+	/* .attrs is set in init */
+};
+
+static struct attribute_group event_desc_group = {
+	.name = "event_descs",
+	/* .attrs is set in init */
+};
+
+static struct attribute_group event_long_desc_group = {
+	.name = "event_long_descs",
+	/* .attrs is set in init */
+};
+
 static struct kmem_cache *hv_page_cache;
 
+static char *event_name(struct hv_24x7_event_data *ev, int *len)
+{
+	*len = be16_to_cpu(ev->event_name_len) - 2;
+	return (char *)ev->remainder;
+}
+
+static char *event_desc(struct hv_24x7_event_data *ev, int *len)
+{
+	unsigned nl = be16_to_cpu(ev->event_name_len);
+	__be16 *desc_len = (__be16 *)(ev->remainder + nl - 2);
+	*len = be16_to_cpu(*desc_len) - 2;
+	return (char *)ev->remainder + nl;
+}
+
+static char *event_long_desc(struct hv_24x7_event_data *ev, int *len)
+{
+	unsigned nl = be16_to_cpu(ev->event_name_len);
+	__be16 *desc_len_ = (__be16 *)(ev->remainder + nl - 2);
+	unsigned desc_len = be16_to_cpu(*desc_len_);
+	__be16 *long_desc_len = (__be16 *)(ev->remainder + nl + desc_len - 2);
+	*len = be16_to_cpu(*long_desc_len) - 2;
+	return (char *)ev->remainder + nl + desc_len;
+}
+
+static bool event_fixed_portion_is_within(struct hv_24x7_event_data *ev,
+					  void *end)
+{
+	void *start = ev;
+
+	return (start + offsetof(struct hv_24x7_event_data, remainder)) < end;
+}
+
+/*
+ * Things we don't check:
+ *  - padding for desc, name, and long/detailed desc is required to be '\0'
+ *    bytes.
+ *
+ *  Return NULL if we pass end,
+ *  Otherwise return the address of the byte just following the event.
+ */
+static void *event_end(struct hv_24x7_event_data *ev, void *end)
+{
+	void *start = ev;
+	__be16 *dl_, *ldl_;
+	unsigned dl, ldl;
+	unsigned nl = be16_to_cpu(ev->event_name_len);
+
+	if (nl < 2) {
+		pr_debug("%s: name length too short: %d", __func__, nl);
+		return NULL;
+	}
+
+	if (start + nl > end) {
+		pr_debug("%s: start=%p + nl=%u > end=%p",
+				__func__, start, nl, end);
+		return NULL;
+	}
+
+	dl_ = (__be16 *)(ev->remainder + nl - 2);
+	if (!IS_ALIGNED((uintptr_t)dl_, 2))
+		pr_warn("desc len not aligned %p", dl_);
+	dl = be16_to_cpu(*dl_);
+	if (dl < 2) {
+		pr_debug("%s: desc len too short: %d", __func__, dl);
+		return NULL;
+	}
+
+	if (start + nl + dl > end) {
+		pr_debug("%s: (start=%p + nl=%u + dl=%u)=%p > end=%p",
+				__func__, start, nl, dl, start + nl + dl, end);
+		return NULL;
+	}
+
+	ldl_ = (__be16 *)(ev->remainder + nl + dl - 2);
+	if (!IS_ALIGNED((uintptr_t)ldl_, 2))
+		pr_warn("long desc len not aligned %p", ldl_);
+	ldl = be16_to_cpu(*ldl_);
+	if (ldl < 2) {
+		pr_debug("%s: long desc len too short (ldl=%u)",
+				__func__, ldl);
+		return NULL;
+	}
+
+	if (start + nl + dl + ldl > end) {
+		pr_debug("%s: start=%p + nl=%u + dl=%u + ldl=%u > end=%p",
+				__func__, start, nl, dl, ldl, end);
+		return NULL;
+	}
+
+	return start + nl + dl + ldl;
+}
+
 static unsigned long h_get_24x7_catalog_page_(unsigned long phys_4096,
 					      unsigned long version,
 					      unsigned long index)
@@ -97,6 +268,605 @@ static unsigned long h_get_24x7_catalog_page(char page[],
 					version, index);
 }
 
+static unsigned core_domains[] = {
+	HV_PERF_DOMAIN_PHYS_CORE,
+	HV_PERF_DOMAIN_VCPU_HOME_CORE,
+	HV_PERF_DOMAIN_VCPU_HOME_CHIP,
+	HV_PERF_DOMAIN_VCPU_HOME_NODE,
+	HV_PERF_DOMAIN_VCPU_REMOTE_NODE,
+};
+/* chip event data always yeilds a single event, core yeilds multiple */
+#define MAX_EVENTS_PER_EVENT_DATA ARRAY_SIZE(core_domains)
+
+static char *event_fmt(struct hv_24x7_event_data *event, unsigned domain)
+{
+	const char *lpar;
+
+	if (is_physical_domain(domain))
+		lpar = "0x0";
+	else
+		lpar = "$sibling_guest_id";
+
+	return kasprintf(GFP_KERNEL,
+			"domain=0x%x,offset=0x%x,starting_index=%s,lpar=%s",
+			domain,
+			be16_to_cpu(event->event_counter_offs) +
+				be16_to_cpu(event->event_group_record_offs),
+			domain_to_index_string(domain),
+			lpar);
+}
+
+/* Avoid trusting fw to NUL terminate strings */
+static char *memdup_to_str(char *maybe_str, int max_len, gfp_t gfp)
+{
+	return kasprintf(gfp, "%.*s", max_len, maybe_str);
+}
+
+static ssize_t device_show_string(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dev_ext_attribute *d;
+
+	d = container_of(attr, struct dev_ext_attribute, attr);
+	return sprintf(buf, "%s\n", (char *)d->var);
+}
+
+static struct attribute *device_str_attr_create_(char *name, char *str)
+{
+	struct dev_ext_attribute *attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+
+	if (!attr)
+		return NULL;
+
+	attr->var = str;
+	attr->attr.attr.name = name;
+	attr->attr.attr.mode = 0444;
+	attr->attr.show = device_show_string;
+	return &attr->attr.attr;
+}
+
+static struct attribute *device_str_attr_create(char *name, int name_max,
+						int name_nonce,
+						char *str, size_t str_max)
+{
+	char *n;
+	char *s = memdup_to_str(str, str_max, GFP_KERNEL);
+	struct attribute *a;
+
+	if (!s)
+		return NULL;
+
+	if (!name_nonce)
+		n = kasprintf(GFP_KERNEL, "%.*s", name_max, name);
+	else
+		n = kasprintf(GFP_KERNEL, "%.*s__%d", name_max, name,
+					name_nonce);
+	if (!n)
+		goto out_s;
+
+	a = device_str_attr_create_(n, s);
+	if (!a)
+		goto out_n;
+
+	return a;
+out_n:
+	kfree(n);
+out_s:
+	kfree(s);
+	return NULL;
+}
+
+static void device_str_attr_destroy(struct attribute *attr)
+{
+	struct dev_ext_attribute *d;
+
+	d = container_of(attr, struct dev_ext_attribute, attr.attr);
+	kfree(d->var);
+	kfree(d->attr.attr.name);
+	kfree(d);
+}
+
+static struct attribute *event_to_attr(unsigned ix,
+				       struct hv_24x7_event_data *event,
+				       unsigned domain,
+				       int nonce)
+{
+	int event_name_len;
+	char *ev_name, *a_ev_name, *val;
+	const char *ev_suffix;
+	struct attribute *attr;
+
+	if (!domain_is_valid(domain)) {
+		pr_warn("catalog event %u has invalid domain %u\n",
+				ix, domain);
+		return NULL;
+	}
+
+	val = event_fmt(event, domain);
+	if (!val)
+		return NULL;
+
+	ev_suffix = event_domain_suffix(domain);
+	ev_name = event_name(event, &event_name_len);
+	if (!nonce)
+		a_ev_name = kasprintf(GFP_KERNEL, "%.*s%s",
+				(int)event_name_len, ev_name, ev_suffix);
+	else
+		a_ev_name = kasprintf(GFP_KERNEL, "%.*s%s__%d",
+				(int)event_name_len, ev_name, ev_suffix, nonce);
+
+
+	if (!a_ev_name)
+		goto out_val;
+
+	attr = device_str_attr_create_(a_ev_name, val);
+	if (!attr)
+		goto out_name;
+
+	return attr;
+out_name:
+	kfree(a_ev_name);
+out_val:
+	kfree(val);
+	return NULL;
+}
+
+static struct attribute *event_to_desc_attr(struct hv_24x7_event_data *event,
+				int nonce)
+{
+	int nl, dl;
+	char *name = event_name(event, &nl);
+	char *desc = event_desc(event, &dl);
+
+	/* If there isn't a description, don't create the sysfs file */
+	if (!dl)
+		return NULL;
+
+	return device_str_attr_create(name, nl, nonce, desc, dl);
+}
+
+static struct attribute *
+event_to_long_desc_attr(struct hv_24x7_event_data *event, int nonce)
+{
+	int nl, dl;
+	char *name = event_name(event, &nl);
+	char *desc = event_long_desc(event, &dl);
+
+	/* If there isn't a description, don't create the sysfs file */
+	if (!dl)
+		return NULL;
+
+	return device_str_attr_create(name, nl, nonce, desc, dl);
+}
+
+static ssize_t event_data_to_attrs(unsigned ix, struct attribute **attrs,
+		struct hv_24x7_event_data *event, int nonce)
+{
+	unsigned i;
+
+	switch (event->domain) {
+	case HV_PERF_DOMAIN_PHYS_CHIP:
+		*attrs = event_to_attr(ix, event, event->domain, nonce);
+		return 1;
+	case HV_PERF_DOMAIN_PHYS_CORE:
+		for (i = 0; i < ARRAY_SIZE(core_domains); i++) {
+			attrs[i] = event_to_attr(ix, event, core_domains[i],
+						nonce);
+			if (!attrs[i]) {
+				pr_warn("catalog event %u: individual attr %u "
+					"creation failure\n", ix, i);
+				for (; i; i--)
+					device_str_attr_destroy(attrs[i - 1]);
+				return -1;
+			}
+		}
+		return i;
+	default:
+		pr_warn("catalog event %u: domain %u is not allowed in the "
+				"catalog\n", ix, event->domain);
+		return -1;
+	}
+}
+
+static size_t event_to_attr_ct(struct hv_24x7_event_data *event)
+{
+	switch (event->domain) {
+	case HV_PERF_DOMAIN_PHYS_CHIP:
+		return 1;
+	case HV_PERF_DOMAIN_PHYS_CORE:
+		return ARRAY_SIZE(core_domains);
+	default:
+		return 0;
+	}
+}
+
+static unsigned long vmalloc_to_phys(void *v)
+{
+	struct page *p = vmalloc_to_page(v);
+
+	BUG_ON(!p);
+	return page_to_phys(p) + offset_in_page(v);
+}
+
+/* */
+struct event_uniq {
+	struct rb_node node;
+	const char *name;
+	int nl;
+	unsigned ct;
+	unsigned domain;
+};
+
+static int memord(const void *d1, size_t s1, const void *d2, size_t s2)
+{
+	if (s1 < s2)
+		return 1;
+	if (s2 > s1)
+		return -1;
+
+	return memcmp(d1, d2, s1);
+}
+
+static int ev_uniq_ord(const void *v1, size_t s1, unsigned d1, const void *v2,
+					size_t s2, unsigned d2)
+{
+	int r = memord(v1, s1, v2, s2);
+
+	if (r)
+		return r;
+	if (d1 > d2)
+		return 1;
+	if (d2 > d1)
+		return -1;
+	return 0;
+}
+
+static int event_uniq_add(struct rb_root *root, const char *name, int nl,
+				unsigned domain)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	struct event_uniq *data;
+
+	/* Figure out where to put new node */
+	while (*new) {
+		struct event_uniq *it;
+		int result;
+
+		it = container_of(*new, struct event_uniq, node);
+		result = ev_uniq_ord(name, nl, domain, it->name, it->nl,
+					it->domain);
+
+		parent = *new;
+		if (result < 0)
+			new = &((*new)->rb_left);
+		else if (result > 0)
+			new = &((*new)->rb_right);
+		else {
+			it->ct++;
+			pr_info("found a duplicate event %.*s, ct=%u\n", nl,
+						name, it->ct);
+			return it->ct;
+		}
+	}
+
+	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	*data = (struct event_uniq) {
+		.name = name,
+		.nl = nl,
+		.ct = 0,
+		.domain = domain,
+	};
+
+	/* Add new node and rebalance tree. */
+	rb_link_node(&data->node, parent, new);
+	rb_insert_color(&data->node, root);
+
+	/* data->ct */
+	return 0;
+}
+
+static void event_uniq_destroy(struct rb_root *root)
+{
+	/*
+	 * the strings we point to are in the giant block of memory filled by
+	 * the catalog, and are freed separately.
+	 */
+	struct event_uniq *pos, *n;
+
+	rbtree_postorder_for_each_entry_safe(pos, n, root, node)
+		kfree(pos);
+}
+
+
+/*
+ * ensure the event structure's sizes are self consistent and don't cause us to
+ * read outside of the event
+ *
+ * On success, return the event length in bytes.
+ * Otherwise, return -1 (and print as appropriate).
+ */
+static ssize_t catalog_event_len_validate(struct hv_24x7_event_data *event,
+					  size_t event_idx,
+					  size_t event_data_bytes,
+					  size_t event_entry_count,
+					  size_t offset, void *end)
+{
+	ssize_t ev_len;
+	void *ev_end, *calc_ev_end;
+
+	if (offset >= event_data_bytes)
+		return -1;
+
+	if (event_idx >= event_entry_count) {
+		pr_devel("catalog event data has %zu bytes of padding after last event\n",
+				event_data_bytes - offset);
+		return -1;
+	}
+
+	if (!event_fixed_portion_is_within(event, end)) {
+		pr_warn("event %zu fixed portion is not within range\n",
+				event_idx);
+		return -1;
+	}
+
+	ev_len = be16_to_cpu(event->length);
+
+	if (ev_len % 16)
+		pr_info("event %zu has length %zu not divisible by 16: event=%pK\n",
+				event_idx, ev_len, event);
+
+	ev_end = (__u8 *)event + ev_len;
+	if (ev_end > end) {
+		pr_warn("event %zu has .length=%zu, ends after buffer end: ev_end=%pK > end=%pK, offset=%zu\n",
+				event_idx, ev_len, ev_end, end,
+				offset);
+		return -1;
+	}
+
+	calc_ev_end = event_end(event, end);
+	if (!calc_ev_end) {
+		pr_warn("event %zu has a calculated length which exceeds buffer length %zu: event=%pK end=%pK, offset=%zu\n",
+			event_idx, event_data_bytes, event, end,
+			offset);
+		return -1;
+	}
+
+	if (calc_ev_end > ev_end) {
+		pr_warn("event %zu exceeds it's own length: event=%pK, end=%pK, offset=%zu, calc_ev_end=%pK\n",
+			event_idx, event, ev_end, offset, calc_ev_end);
+		return -1;
+	}
+
+	return ev_len;
+}
+
+#define MAX_4K (SIZE_MAX / 4096)
+
+static void create_events_from_catalog(struct attribute ***events_,
+		struct attribute ***event_descs_,
+		struct attribute ***event_long_descs_)
+{
+	unsigned long hret;
+	size_t catalog_len, catalog_page_len, event_entry_count,
+	       event_data_len, event_data_offs,
+	       event_data_bytes, junk_events, event_idx, event_attr_ct, i,
+	       attr_max, event_idx_last, desc_ct, long_desc_ct;
+	ssize_t ct, ev_len;
+	uint32_t catalog_version_num;
+	struct attribute **events, **event_descs, **event_long_descs;
+	struct hv_24x7_catalog_page_0 *page_0 =
+		kmem_cache_alloc(hv_page_cache, GFP_KERNEL);
+	void *page = page_0;
+	void *event_data, *end;
+	struct hv_24x7_event_data *event;
+	struct rb_root ev_uniq = RB_ROOT;
+
+	if (!page)
+		goto e_out;
+
+	hret = h_get_24x7_catalog_page(page, 0, 0);
+	if (hret)
+		goto e_free;
+
+	catalog_version_num = be64_to_cpu(page_0->version);
+	catalog_page_len = be32_to_cpu(page_0->length);
+
+	if (MAX_4K < catalog_page_len) {
+		pr_err("invalid page count: %zu\n", catalog_page_len);
+		goto e_free;
+	}
+
+	catalog_len = catalog_page_len * 4096;
+
+	event_entry_count = be16_to_cpu(page_0->event_entry_count);
+	event_data_offs   = be16_to_cpu(page_0->event_data_offs);
+	event_data_len    = be16_to_cpu(page_0->event_data_len);
+
+	pr_devel("cv %zu cl %zu eec %zu edo %zu edl %zu\n",
+			(size_t)catalog_version_num, catalog_len,
+			event_entry_count, event_data_offs, event_data_len);
+
+	if ((MAX_4K < event_data_len)
+			|| (MAX_4K < event_data_offs)
+			|| (MAX_4K - event_data_offs < event_data_len)) {
+		pr_err("invalid event data offs %zu and/or len %zu\n",
+				event_data_offs, event_data_len);
+		goto e_free;
+	}
+
+	if ((event_data_offs + event_data_len) > catalog_page_len) {
+		pr_err("event data %zu-%zu does not fit inside catalog 0-%zu\n",
+				event_data_offs,
+				event_data_offs + event_data_len,
+				catalog_page_len);
+		goto e_free;
+	}
+
+	if (SIZE_MAX / MAX_EVENTS_PER_EVENT_DATA - 1 < event_entry_count) {
+		pr_err("event_entry_count %zu is invalid\n",
+				event_entry_count);
+		goto e_free;
+	}
+
+	event_data_bytes = event_data_len * 4096;
+
+	/*
+	 * event data can span several pages, events can cross between these
+	 * pages. Use vmalloc to make this easier.
+	 */
+	event_data = vmalloc(event_data_bytes);
+	if (!event_data) {
+		pr_err("could not allocate event data\n");
+		goto e_free;
+	}
+
+	end = event_data + event_data_bytes;
+
+	/*
+	 * using vmalloc_to_phys() like this only works if PAGE_SIZE is
+	 * divisible by 4096
+	 */
+	BUILD_BUG_ON(PAGE_SIZE % 4096);
+
+	for (i = 0; i < event_data_len; i++) {
+		hret = h_get_24x7_catalog_page_(
+				vmalloc_to_phys(event_data + i * 4096),
+				catalog_version_num,
+				i + event_data_offs);
+		if (hret) {
+			pr_err("failed to get event data in page %zu\n",
+					i + event_data_offs);
+			goto e_event_data;
+		}
+	}
+
+	/*
+	 * scan the catalog to determine the number of attributes we need, and
+	 * verify it at the same time.
+	 */
+	for (junk_events = 0, event = event_data, event_idx = 0, attr_max = 0;
+	     ;
+	     event_idx++, event = (void *)event + ev_len) {
+		size_t offset = (void *)event - (void *)event_data;
+		char *name;
+		int nl;
+
+		ev_len = catalog_event_len_validate(event, event_idx,
+						    event_data_bytes,
+						    event_entry_count,
+						    offset, end);
+		if (ev_len < 0)
+			break;
+
+		name = event_name(event, &nl);
+
+		if (event->event_group_record_len == 0) {
+			pr_devel("invalid event %zu (%.*s): group_record_len == 0, skipping\n",
+					event_idx, nl, name);
+			junk_events++;
+			continue;
+		}
+
+		if (!catalog_entry_domain_is_valid(event->domain)) {
+			pr_info("event %zu (%.*s) has invalid domain %d\n",
+					event_idx, nl, name, event->domain);
+			junk_events++;
+			continue;
+		}
+
+		attr_max += event_to_attr_ct(event);
+	}
+
+	event_idx_last = event_idx;
+	if (event_idx_last != event_entry_count)
+		pr_warn("event buffer ended before listed # of events were parsed (got %zu, wanted %zu, junk %zu)\n",
+				event_idx_last, event_entry_count, junk_events);
+
+	events = kmalloc_array(attr_max + 1, sizeof(*events), GFP_KERNEL);
+	if (!events)
+		goto e_event_data;
+
+	event_descs = kmalloc_array(event_idx + 1, sizeof(*event_descs),
+				GFP_KERNEL);
+	if (!event_descs)
+		goto e_event_attrs;
+
+	event_long_descs = kmalloc_array(event_idx + 1,
+			sizeof(*event_long_descs), GFP_KERNEL);
+	if (!event_long_descs)
+		goto e_event_descs;
+
+	/* Iterate over the catalog filling in the attribute vector */
+	for (junk_events = 0, event_attr_ct = 0, desc_ct = 0, long_desc_ct = 0,
+				event = event_data, event_idx = 0;
+			event_idx < event_idx_last;
+			event_idx++, ev_len = be16_to_cpu(event->length),
+				event = (void *)event + ev_len) {
+		char *name;
+		int nl;
+		int nonce;
+		/*
+		 * these are the only "bad" events that are intermixed and that
+		 * we can ignore without issue. make sure to skip them here
+		 */
+		if (event->event_group_record_len == 0)
+			continue;
+		if (!catalog_entry_domain_is_valid(event->domain))
+			continue;
+
+		name  = event_name(event, &nl);
+		nonce = event_uniq_add(&ev_uniq, name, nl, event->domain);
+		ct    = event_data_to_attrs(event_idx, events + event_attr_ct,
+					    event, nonce);
+		if (ct <= 0) {
+			pr_warn("event %zu (%.*s) creation failure, skipping\n",
+				event_idx, nl, name);
+			junk_events++;
+		} else {
+			event_attr_ct += ct;
+			event_descs[desc_ct] = event_to_desc_attr(event, nonce);
+			if (event_descs[desc_ct])
+				desc_ct++;
+			event_long_descs[long_desc_ct] =
+					event_to_long_desc_attr(event, nonce);
+			if (event_long_descs[long_desc_ct])
+				long_desc_ct++;
+		}
+	}
+
+	pr_info("read %zu catalog entries, created %zu event attrs (%zu failures), %zu descs\n",
+			event_idx, event_attr_ct, junk_events, desc_ct);
+
+	events[event_attr_ct] = NULL;
+	event_descs[desc_ct] = NULL;
+	event_long_descs[long_desc_ct] = NULL;
+
+	event_uniq_destroy(&ev_uniq);
+	vfree(event_data);
+	kmem_cache_free(hv_page_cache, page);
+
+	*events_ = events;
+	*event_descs_ = event_descs;
+	*event_long_descs_ = event_long_descs;
+	return;
+
+e_event_descs:
+	kfree(event_descs);
+e_event_attrs:
+	kfree(events);
+e_event_data:
+	vfree(event_data);
+e_free:
+	kmem_cache_free(hv_page_cache, page);
+e_out:
+	*events_ = NULL;
+	*event_descs_ = NULL;
+	*event_long_descs_ = NULL;
+}
+
 static ssize_t catalog_read(struct file *filp, struct kobject *kobj,
 			    struct bin_attribute *bin_attr, char *buf,
 			    loff_t offset, size_t count)
@@ -177,7 +947,7 @@ static ssize_t _name##_show(struct device *dev,			\
 	}							\
 	ret = sprintf(buf, _fmt, _expr);			\
 e_free:								\
-	kfree(page);						\
+	kmem_cache_free(hv_page_cache, page);			\
 	return ret;						\
 }								\
 static DEVICE_ATTR_RO(_name)
@@ -207,16 +977,13 @@ static struct attribute_group if_group = {
 
 static const struct attribute_group *attr_groups[] = {
 	&format_group,
+	&event_group,
+	&event_desc_group,
+	&event_long_desc_group,
 	&if_group,
 	NULL,
 };
 
-static bool is_physical_domain(int domain)
-{
-	return  domain == HV_24X7_PERF_DOMAIN_PHYSICAL_CHIP ||
-		domain == HV_24X7_PERF_DOMAIN_PHYSICAL_CORE;
-}
-
 static unsigned long single_24x7_request(u8 domain, u32 offset, u16 ix,
 					 u16 lpar, u64 *res,
 					 bool success_expected)
@@ -359,7 +1126,7 @@ static int h_24x7_event_init(struct perf_event *event)
 		return -EIO;
 	}
 
-	/* PHYSICAL domains & other lpars require extra capabilities */
+	/* Physical domains & other lpars require extra capabilities */
 	if (!caps.collect_privileged && (is_physical_domain(domain) ||
 		(event_get_lpar(event) != event_get_lpar_max()))) {
 		pr_devel("hv permisions disallow: is_physical_domain:%d, lpar=0x%llx\n",
@@ -455,6 +1222,10 @@ static int hv_24x7_init(void)
 	/* sampling not supported */
 	h_24x7_pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
 
+	create_events_from_catalog(&event_group.attrs,
+				   &event_desc_group.attrs,
+				   &event_long_desc_group.attrs);
+
 	r = perf_pmu_register(&h_24x7_pmu, h_24x7_pmu.name, -1);
 	if (r)
 		return r;
diff --git a/arch/powerpc/perf/hv-24x7.h b/arch/powerpc/perf/hv-24x7.h
index 720ebce..69cd4e6 100644
--- a/arch/powerpc/perf/hv-24x7.h
+++ b/arch/powerpc/perf/hv-24x7.h
@@ -3,14 +3,14 @@
 
 #include <linux/types.h>
 
+enum hv_perf_domains {
+#define DOMAIN(n, v, x, c) HV_PERF_DOMAIN_##n = v,
+#include "hv-24x7-domains.h"
+#undef DOMAIN
+};
+
 struct hv_24x7_request {
 	/* PHYSICAL domains require enabling via phyp/hmc. */
-#define HV_24X7_PERF_DOMAIN_PHYSICAL_CHIP 0x01
-#define HV_24X7_PERF_DOMAIN_PHYSICAL_CORE 0x02
-#define HV_24X7_PERF_DOMAIN_VIRTUAL_PROCESSOR_HOME_CORE   0x03
-#define HV_24X7_PERF_DOMAIN_VIRTUAL_PROCESSOR_HOME_CHIP   0x04
-#define HV_24X7_PERF_DOMAIN_VIRTUAL_PROCESSOR_HOME_NODE   0x05
-#define HV_24X7_PERF_DOMAIN_VIRTUAL_PROCESSOR_REMOTE_NODE 0x06
 	__u8 performance_domain;
 	__u8 reserved[0x1];
 
-- 
1.8.3.1

