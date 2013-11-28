Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab3K1M7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 07:59:00 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2162 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3K1M6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:58:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 28 Nov 2013 04:52:33 -0800
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
Date: Thu, 28 Nov 2013 13:58:18 +0100
Subject: [RFC][PATCHv6++ 01/13] of: introduce
 of_property_for_earch_phandle_with_args()
Thread-Topic: [RFC][PATCHv6++ 01/13] of: introduce
 of_property_for_earch_phandle_with_args()
Thread-Index: Ac7sOYNF30nsU5ybQgOlsq+/Wu8t2w==
Message-ID: <20131128.145818.1345100874304396564.hdoyu@nvidia.com>
References: <1385041249-7705-2-git-send-email-hdoyu@nvidia.com><20131121.191720.1487772262083864095.hdoyu@nvidia.com><528E577C.2050506@wwwdotorg.org>
In-Reply-To: <528E577C.2050506@wwwdotorg.org>
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

Stephen Warren <swarren@wwwdotorg.org> wrote @ Thu, 21 Nov 2013 19:57:00 +0100:

> On 11/21/2013 10:17 AM, Hiroshi Doyu wrote:
> > Iterating over a property containing a list of phandles with arguments
> > is a common operation for device drivers. This patch adds a new
> > of_property_for_each_phandle_with_args() macro to make the iteration
> > simpler.
> > 
> > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > ---
> > v6+:
> > Use the description, which Grant Likely proposed, to be full enough
> > that a future reader can figure out why a patch was written.
> >   http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007062.html
> 
> This new version only addresses one of the concerns that Grant had,
> namely the commit message.
> 
> > diff --git a/include/linux/of.h b/include/linux/of.h
> 
> > +#define of_property_for_each_phandle_with_args(np, list, cells, i, args) \
> > +	for (i = 0; !of_parse_phandle_with_args(np, list, cells, i, args); i++)
> > +
> 
> Grant also wanted the actual implementation fixed so that it wasn't so
> inefficient.
> 
> What this current patch does is basically:
> 
> for every entry in the property:
>     for every entry in the property before the current index:
>         parse the phandle+specifier
> 
> That's roughly O(n^2). (n is # entries in the property)
> 
> Instead, what should happen is:
> 
> for every entry in the property:
>     parse the phandle+specifier
>     yield the result
> 
> That's roughly O(n).
> 
> In other words, an implementation more along the lines of
> include/linux/of.h's:
> 
> #define of_property_for_each_u32(np, propname, prop, p, u)      \
>         for (prop = of_find_property(np, propname, NULL),       \
>                 p = of_prop_next_u32(prop, NULL, &u);           \
>                 p;                                              \
>                 p = of_prop_next_u32(prop, p, &u))
> 
> ... so you'd need functions like of_prop_first_specifier() and
> of_prop_next_specifier(), and perhaps some associated set of state
> variables, perhaps with all the state wrapped into a single struct for
> simplicity.

Although I couldn't invent any struct to hold params and state here,
I'd like you to review the following interface is ok or not.

At first, I thought to refactor __of_parse_phandle_with_args() but
it's a bit highly optimized by Stephen and it looked a bit hard to
refactor without perf regressions. Instread, I introduced 2 new
functions "of_parse_{first,next}_phandle_with_args()" to parse
phandles.

If this interface is ok, I'll include this into the next v7 series.

-----8<-----8<-----8<-----8<-----8<-----8<-----8<-----8<-----8<-----
From: Hiroshi Doyu <hdoyu@nvidia.com>

Iterating over a property containing a list of phandles with arguments
is a common operation for device drivers. This patch adds a new
of_property_for_each_phandle_with_args() macro to make the iteration
simpler.

Introduced "of_parse_{first,next}_phandle_with_args()", where "const
__be32 **list" is used to hold the next list to be processed as a
state pramameter, and both "of_parse_{first,next}_phandle_with_args()"
returns the remaining list in the number of cell(4 byte). If any error
happens, "list" is set NULL not to proceed the rest.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
v6++:
Optimized to avoid O(n^2), suggested by Stephen Warren.
http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007066.html

v6+:
Use the description, which Grant Likely proposed, to be full enough
that a future reader can figure out why a patch was written.

v5:
New patch for v5.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/of/base.c  | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of.h | 52 ++++++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index f807d0e..3e29b10 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1201,6 +1201,88 @@ void of_print_phandle_args(const char *msg, const struct of_phandle_args *args)
 	printk("\n");
 }
 
+int __of_parse_next_phandle_with_args(const __be32 **plist,
+				      const char *cells_name, int cell_count,
+				      struct of_phandle_args *out_args)
+{
+	phandle phandle;
+	int i, count = 0, err;
+	struct device_node *dn;
+	const __be32 *list;
+
+	BUG_ON(!out_args);
+	BUG_ON(!cells_name && !cell_count);
+
+	/*
+	 * "*plist" should hold phandle, and it's updated to the next
+	 * phandle at return if no error.
+	 */
+	list = *plist;
+	out_args->np = NULL;
+
+	phandle = be32_to_cpup(list);
+	if (!phandle)
+		goto err_out;
+
+	dn = of_find_node_by_phandle(phandle);
+	if (!dn)
+		goto err_out;
+
+	if (cells_name) {
+		err = of_property_read_u32(dn, cells_name, &count);
+		if (err)
+			goto err_out;
+	} else {
+		count = cell_count;
+	}
+
+	out_args->np = dn;
+	out_args->args_count = count;
+	for (i = 0; i < count; i++)
+		out_args->args[i] = be32_to_cpup(list + 1 + i);
+
+	*plist = list + count + 1; /* update to the next list */
+	return count + 1;
+
+err_out:
+	*plist = NULL;
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(__of_parse_next_phandle_with_args);
+
+int __of_parse_first_phandle_with_args(const struct device_node *np,
+				       const __be32 **out_list,
+				       const char *list_name,
+				       const char *cells_name,
+				       int cell_count,
+				       struct of_phandle_args *out_args)
+{
+	int rem, count;
+	const __be32 *list;
+
+	list = of_get_property(np, list_name, &rem);
+	if (!list)
+		goto err_out;
+
+	rem /= sizeof(*list);
+	if (!rem)
+		goto err_out;
+
+	count = __of_parse_next_phandle_with_args(&list, cells_name,
+						  cell_count, out_args);
+	if (!list)
+		goto err_out;
+
+	rem -= count;
+	*out_list = list; /* update to the next list */
+	return rem;
+
+err_out:
+	*out_list = NULL;
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(__of_parse_first_phandle_with_args);
+
 static int __of_parse_phandle_with_args(const struct device_node *np,
 					const char *list_name,
 					const char *cells_name,
diff --git a/include/linux/of.h b/include/linux/of.h
index 276c546..9f15622 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -303,6 +303,35 @@ extern int of_parse_phandle_with_fixed_args(const struct device_node *np,
 extern int of_count_phandle_with_args(const struct device_node *np,
 	const char *list_name, const char *cells_name);
 
+extern int __of_parse_first_phandle_with_args(const struct device_node *np,
+					    const __be32 **out_list,
+					    const char *list_name,
+					    const char *cells_name,
+					    int cell_count,
+					    struct of_phandle_args *out_args);
+
+extern int __of_parse_next_phandle_with_args(const __be32 **plist,
+					   const char *cells_name,
+					   int cell_count,
+					   struct of_phandle_args *out_args);
+
+static inline int of_parse_first_phandle_with_args(const struct device_node *np,
+						   const __be32 **out_list,
+						   const char *list_name,
+						   const char *cells_name,
+						   struct of_phandle_args *out_args)
+{
+	return __of_parse_first_phandle_with_args(np, out_list, list_name,
+						  cells_name, 0, out_args);
+}
+
+static inline int of_parse_next_phandle_with_args(const __be32 **plist,
+						  const char *cells_name,
+						  struct of_phandle_args *out_args)
+{
+	return __of_parse_next_phandle_with_args(plist, cells_name, 0, out_args);
+}
+
 extern void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align));
 extern int of_alias_get_id(struct device_node *np, const char *stem);
 
@@ -527,6 +556,24 @@ static inline int of_count_phandle_with_args(struct device_node *np,
 	return -ENOSYS;
 }
 
+static inline int __of_parse_first_phandle_with_args(
+	const struct device_node *np, const __be32 **out_list,
+	const char *list_name, const char *cells_name, int cell_count,
+	struct of_phandle_args *out_args)
+{
+	*out_list = NULL;
+	return -ENOSYS;
+}
+
+
+static inline int __of_parse_next_phandle_with_args(
+	const __be32 **plist, const char *cells_name, int cell_count,
+	struct of_phandle_args *out_args)
+{
+	*plist = NULL;
+	return -ENOSYS;
+}
+
 static inline int of_alias_get_id(struct device_node *np, const char *stem)
 {
 	return -ENOSYS;
@@ -613,6 +660,11 @@ static inline int of_property_read_u32(const struct device_node *np,
 		s;						\
 		s = of_prop_next_string(prop, s))
 
+#define of_property_for_each_phandle_with_args(node, list, list_name, cells_name, rem,  args) \
+	for (rem = of_parse_first_phandle_with_args(node, &list, list_name, cells_name, &args); \
+	     list && rem >= 0;						\
+	     rem -= of_parse_next_phandle_with_args(&list, cells_name, &args))
+
 #if defined(CONFIG_PROC_FS) && defined(CONFIG_PROC_DEVICETREE)
 extern void proc_device_tree_add_node(struct device_node *, struct proc_dir_entry *);
 extern void proc_device_tree_add_prop(struct proc_dir_entry *pde, struct property *prop);
-- 
1.8.1.5
