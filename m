Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3K2LrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:47:03 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9983 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3K2Lq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:46:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 29 Nov 2013 03:44:19 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Stephen Warren <swarren@nvidia.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 29 Nov 2013 12:46:25 +0100
Subject: [RFC][PATCHv6+++ 01/13] of: introduce
 of_property_for_earch_phandle_with_args()
Thread-Topic: [RFC][PATCHv6+++ 01/13] of: introduce
 of_property_for_earch_phandle_with_args()
Thread-Index: Ac7s+KN6HE+LfMgwRGehhMjBAMvnBg==
Message-ID: <20131129.134625.431945240074254704.hdoyu@nvidia.com>
References: <20131121.191720.1487772262083864095.hdoyu@nvidia.com><528E577C.2050506@wwwdotorg.org><20131128.145818.1345100874304396564.hdoyu@nvidia.com>
In-Reply-To: <20131128.145818.1345100874304396564.hdoyu@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Doyu <hdoyu@nvidia.com> wrote @ Thu, 28 Nov 2013 14:58:18 +0200 (EET):
....
> > In other words, an implementation more along the lines of
> > include/linux/of.h's:
> > 
> > #define of_property_for_each_u32(np, propname, prop, p, u)      \
> >         for (prop = of_find_property(np, propname, NULL),       \
> >                 p = of_prop_next_u32(prop, NULL, &u);           \
> >                 p;                                              \
> >                 p = of_prop_next_u32(prop, p, &u))
> > 
> > ... so you'd need functions like of_prop_first_specifier() and
> > of_prop_next_specifier(), and perhaps some associated set of state
> > variables, perhaps with all the state wrapped into a single struct for
> > simplicity.
> 
> Although I couldn't invent any struct to hold params and state here,
> I'd like you to review the following interface is ok or not.

Tried again to introduce a new struct to keep track of iteration state
as below:

----8<---------8<---------8<---------8<---------8<---------8<--
From: Hiroshi Doyu <hdoyu@nvidia.com>

Iterating over a property containing a list of phandles with arguments
is a common operation for device drivers. This patch adds a new
of_property_for_each_phandle_with_args() macro to make the iteration
simpler.

Introduced a new struct "of_phandle_iter" to keep the state when
iterating over the list.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
v6+++:
Introduced a new struct "of_phandle_iter" to keep the state when
iterating over the list.

v6++:
Optimized to avoid O(n^2), suggested by Stephen Warren.
http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007066.html

I didn't introduce any struct to hold params and state here.

v6+:
Use the description, which Grant Likely proposed, to be full enough
that a future reader can figure out why a patch was written.

v5:
New patch for v5.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/of/base.c  | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of.h | 45 ++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index f807d0e..16fb2d9 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1201,6 +1201,77 @@ void of_print_phandle_args(const char *msg, const struct of_phandle_args *args)
 	printk("\n");
 }
 
+void of_phandle_iter_next(struct of_phandle_iter *iter,
+			  struct of_phandle_args *out_args)
+{
+	phandle phandle;
+	struct device_node *dn;
+	int i, count = iter->cell_count;
+
+	iter->err = -EINVAL;
+	if (!iter->cells_name && !iter->cell_count)
+		return;
+
+	phandle = be32_to_cpup(iter->cur++);
+	if (!phandle)
+		return;
+
+	dn = of_find_node_by_phandle(phandle);
+	if (!dn)
+		return;
+
+	if (iter->cells_name)
+		if (of_property_read_u32(dn, iter->cells_name, &count))
+			return;
+
+	out_args->np = dn;
+	out_args->args_count = count;
+	for (i = 0; i < count; i++)
+		out_args->args[i] = be32_to_cpup(iter->cur++);
+
+	iter->err = 0;
+}
+EXPORT_SYMBOL_GPL(of_phandle_iter_next);
+
+static void __of_phandle_iter_set(struct of_phandle_iter *iter,
+				  const struct device_node *np,
+				  const char *list_name)
+{
+	size_t bytes;
+	const __be32 *prop;
+
+	prop = of_get_property(np, list_name, &bytes);
+	if (!prop) {
+		iter->err = -EINVAL;
+		return;
+	}
+
+	iter->cur = prop;
+	iter->end = prop + bytes / sizeof(*prop);
+	iter->err = 0;
+}
+
+void of_phandle_iter_start(struct of_phandle_iter *iter,
+			   const struct device_node *np,
+			   const char *list_name,
+			   const char *cells_name,
+			   int cell_count,
+			   struct of_phandle_args *out_args)
+{
+	iter->err = -EINVAL;
+	if (!cells_name && !cell_count)
+		return;
+
+	iter->cells_name = cells_name;
+	iter->cell_count = cell_count;
+	__of_phandle_iter_set(iter, np, list_name);
+	if (iter->err)
+		return;
+
+	of_phandle_iter_next(iter, out_args);
+}
+EXPORT_SYMBOL_GPL(of_phandle_iter_start);
+
 static int __of_parse_phandle_with_args(const struct device_node *np,
 					const char *list_name,
 					const char *cells_name,
diff --git a/include/linux/of.h b/include/linux/of.h
index 276c546..1132b49 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -74,6 +74,18 @@ struct of_phandle_args {
 	uint32_t args[MAX_PHANDLE_ARGS];
 };
 
+/*
+ * keep the state at iterating a list of phandles with variable number
+ * of args
+ */
+struct of_phandle_iter {
+	int		err;
+	const __be32	*cur;		/* current phandle */
+	const __be32	*end;		/* end of the last phandle */
+	const char	*cells_name;
+	int		cell_count;
+};
+
 #ifdef CONFIG_OF_DYNAMIC
 extern struct device_node *of_node_get(struct device_node *node);
 extern void of_node_put(struct device_node *node);
@@ -303,6 +315,16 @@ extern int of_parse_phandle_with_fixed_args(const struct device_node *np,
 extern int of_count_phandle_with_args(const struct device_node *np,
 	const char *list_name, const char *cells_name);
 
+extern void of_phandle_iter_start(struct of_phandle_iter *iter,
+				  const struct device_node *np,
+				  const char *list_name,
+				  const char *cells_name,
+				  int cell_count,
+				  struct of_phandle_args *out_args);
+
+extern void of_phandle_iter_next(struct of_phandle_iter *iter,
+				 struct of_phandle_args *out_args);
+
 extern void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align));
 extern int of_alias_get_id(struct device_node *np, const char *stem);
 
@@ -527,6 +549,22 @@ static inline int of_count_phandle_with_args(struct device_node *np,
 	return -ENOSYS;
 }
 
+static inline void of_phandle_iter_start(struct of_phandle_iter *iter,
+					 const struct device_node *np,
+					 const char *list_name,
+					 const char *cells_name,
+					 const int cell_count,
+					 struct of_phandle_args *out_args)
+{
+	iter->err = -ENOSYS;
+}
+
+static inline void of_phandle_iter_next(struct of_phandle_iter *iter,
+					struct of_phandle_args *out_args)
+{
+	iter->err = -ENOSYS;
+}
+
 static inline int of_alias_get_id(struct device_node *np, const char *stem)
 {
 	return -ENOSYS;
@@ -613,6 +651,13 @@ static inline int of_property_read_u32(const struct device_node *np,
 		s;						\
 		s = of_prop_next_string(prop, s))
 
+#define of_property_for_each_phandle_with_args(iter, node, list_name,	\
+					       cells_name, cell_count, out_args) \
+	for (of_phandle_iter_start(&iter, node, list_name,		\
+				   cells_name, cell_count, &out_args);	\
+	     !iter.err && iter.end - iter.cur >= 0 ;			\
+	     of_phandle_iter_next(&iter, &out_args))
+
 #if defined(CONFIG_PROC_FS) && defined(CONFIG_PROC_DEVICETREE)
 extern void proc_device_tree_add_node(struct device_node *, struct proc_dir_entry *);
 extern void proc_device_tree_add_prop(struct proc_dir_entry *pde, struct property *prop);
-- 
1.8.1.5

