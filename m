Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaJFN4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:56:54 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:40277 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaJFN4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:56:52 -0400
MIME-Version: 1.0
In-Reply-To: <1412585954-21172-1-git-send-email-grant.likely@linaro.org>
References: <1412585954-21172-1-git-send-email-grant.likely@linaro.org>
From: Rob Herring <robh@kernel.org>
Date: Mon, 6 Oct 2014 08:56:28 -0500
X-Google-Sender-Auth: dZJUAw40EHDssYLYDiOdnIRA5wA
Message-ID: <CAL_JsqJ+TCfeHF=Rzec0=-hM6Y_vbijQBvyyvL58E67WMYTxEg@mail.gmail.com>
Subject: Re: [PATCH] of: Eliminate of_allnodes list
To: Grant Likely <grant.likely@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Gaurav Minocha <gaurav.minocha.os@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 6, 2014 at 3:59 AM, Grant Likely <grant.likely@linaro.org> wrote:
> The device tree structure is composed of two lists; the 'allnodes' list
> which is a singly linked list containing every node in the tree, and the
> child->parent structure where each parent node has a singly linked list
> of children. All of the data in the allnodes list can be easily
> reproduced with the parent-child lists, so of_allnodes is actually
> unnecessary. Remove it entirely which saves a bit of memory and
> simplifies the data structure quite a lot.
>
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Gaurav Minocha <gaurav.minocha.os@gmail.com>
> ---
>
> This applies against my current devicetree/next branch on git.secretlab.ca/git/linux
>
> I'm not going to try and merge this in v3.18. It's too risky a patch and
> I only just wrote it. I'll try to get it in for v3.19.

Looks good. A few minor things below.

[...]

> diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
> index 9e21e4fc9599..8f43ab8fd2d6 100644
> --- a/drivers/mfd/vexpress-sysreg.c
> +++ b/drivers/mfd/vexpress-sysreg.c
> @@ -223,7 +223,7 @@ static int vexpress_sysreg_probe(struct platform_device *pdev)
>         vexpress_config_set_master(vexpress_sysreg_get_master());
>
>         /* Confirm board type against DT property, if available */
> -       if (of_property_read_u32(of_allnodes, "arm,hbi", &dt_hbi) == 0) {
> +       if (of_property_read_u32(of_root, "arm,hbi", &dt_hbi) == 0) {

Given this and selftests are the only users in the whole tree, perhaps
this should just use of_find_node_by_path("/") rather than expose this
global.

>                 u32 id = vexpress_get_procid(VEXPRESS_SITE_MASTER);
>                 u32 hbi = (id >> SYS_PROCIDx_HBI_SHIFT) & SYS_HBI_MASK;
>
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 2305dc0382bc..b86beff7b167 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -32,8 +32,8 @@
>
>  LIST_HEAD(aliases_lookup);
>
> -struct device_node *of_allnodes;
> -EXPORT_SYMBOL(of_allnodes);
> +struct device_node *of_root;
> +EXPORT_SYMBOL(of_root);
>  struct device_node *of_chosen;
>  struct device_node *of_aliases;
>  struct device_node *of_stdout;
> @@ -48,7 +48,7 @@ struct kset *of_kset;
>   */
>  DEFINE_MUTEX(of_mutex);
>
> -/* use when traversing tree through the allnext, child, sibling,
> +/* use when traversing tree through the child, sibling,
>   * or parent members of struct device_node.
>   */
>  DEFINE_RAW_SPINLOCK(devtree_lock);
> @@ -204,7 +204,7 @@ static int __init of_init(void)
>         mutex_unlock(&of_mutex);
>
>         /* Symlink in /proc as required by userspace ABI */
> -       if (of_allnodes)
> +       if (of_root)
>                 proc_symlink("device-tree", NULL, "/sys/firmware/devicetree/base");
>
>         return 0;
> @@ -245,6 +245,23 @@ struct property *of_find_property(const struct device_node *np,
>  }
>  EXPORT_SYMBOL(of_find_property);
>
> +struct device_node *__of_find_all_nodes(struct device_node *prev)
> +{
> +       struct device_node *np;
> +       if (!prev)
> +               np = of_root;
> +       else if (prev->child) {
> +               np = prev->child;
> +       } else {

Your braces are inconsistent.

> +               /* Walk back up looking for a sibling, or the end of the structure */
> +               np = prev;
> +               while (np->parent && !np->sibling)
> +                       np = np->parent;
> +               np = np->sibling; /* Might be null at the end of the tree */
> +       }
> +       return np;

[...]

> diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
> index 4fed34bff5cf..9cc2363a9077 100644
> --- a/drivers/of/selftest.c
> +++ b/drivers/of/selftest.c
> @@ -148,7 +148,7 @@ static void __init of_selftest_dynamic(void)
>
>  static int __init of_selftest_check_node_linkage(struct device_node *np)
>  {
> -       struct device_node *child, *allnext_index = np;
> +       struct device_node *child;
>         int count = 0, rc;
>
>         for_each_child_of_node(np, child) {
> @@ -158,14 +158,6 @@ static int __init of_selftest_check_node_linkage(struct device_node *np)
>                         return -EINVAL;
>                 }
>
> -               while (allnext_index && allnext_index != child)
> -                       allnext_index = allnext_index->allnext;
> -               if (allnext_index != child) {
> -                       pr_err("Node %s is ordered differently in sibling and allnode lists\n",
> -                                child->name);
> -                       return -EINVAL;
> -               }
> -
>                 rc = of_selftest_check_node_linkage(child);
>                 if (rc < 0)
>                         return rc;
> @@ -180,12 +172,12 @@ static void __init of_selftest_check_tree_linkage(void)
>         struct device_node *np;
>         int allnode_count = 0, child_count;
>
> -       if (!of_allnodes)
> +       if (!of_root)

This could be !of_have_populated_dt() instead.

>                 return;
>
>         for_each_of_allnodes(np)
>                 allnode_count++;
> -       child_count = of_selftest_check_node_linkage(of_allnodes);
> +       child_count = of_selftest_check_node_linkage(of_root);
>
>         selftest(child_count > 0, "Device node data structure is corrupted\n");
>         selftest(child_count == allnode_count, "allnodes list size (%i) doesn't match"
> @@ -722,33 +714,29 @@ static void update_node_properties(struct device_node *np,
>   */
>  static int attach_node_and_children(struct device_node *np)
>  {
> -       struct device_node *next, *root = np, *dup;
> +       struct device_node *next, *dup, *child;
>
> -       /* skip root node */
> -       np = np->child;
> -       /* storing a copy in temporary node */
> -       dup = np;
> +       dup = of_find_node_by_path(np->full_name);
> +       if (dup) {
> +               update_node_properties(np, dup);
> +               return 0;
> +       }
>
> -       while (dup) {
> +       /* Children of the root need to be remembered for removal */
> +       if (np->parent == of_root) {
>                 if (WARN_ON(last_node_index >= NO_OF_NODES))
>                         return -EINVAL;
> -               nodes[last_node_index++] = dup;
> -               dup = dup->sibling;
> +               nodes[last_node_index++] = np;
>         }
> -       dup = NULL;
>
> -       while (np) {
> -               next = np->allnext;
> -               dup = of_find_node_by_path(np->full_name);
> -               if (dup)
> -                       update_node_properties(np, dup);
> -               else {
> -                       np->child = NULL;
> -                       if (np->parent == root)
> -                               np->parent = of_allnodes;
> -                       of_attach_node(np);
> -               }
> -               np = next;
> +       child = np->child;
> +       np->child = NULL;
> +       np->sibling = NULL;
> +       of_attach_node(np);
> +       while (child) {
> +               next = child->sibling;
> +               attach_node_and_children(child);
> +               child = next;
>         }
>
>         return 0;
> @@ -793,10 +781,10 @@ static int __init selftest_data_add(void)
>                 return -EINVAL;
>         }
>
> -       if (!of_allnodes) {
> +       if (!of_root) {

This could be !of_have_populated_dt() instead.

>                 /* enabling flag for removing nodes */
>                 selftest_live_tree = true;
> -               of_allnodes = selftest_data_node;
> +               of_root = selftest_data_node;
>
>                 for_each_of_allnodes(np)
>                         __of_attach_node_sysfs(np);
> @@ -806,7 +794,14 @@ static int __init selftest_data_add(void)
>         }
>
>         /* attach the sub-tree to live tree */
> -       return attach_node_and_children(selftest_data_node);
> +       np = selftest_data_node->child;
> +       while (np) {
> +               struct device_node *next = np->sibling;
> +               np->parent = of_root;
> +               attach_node_and_children(np);
> +               np = next;
> +       }

You have the same loop iteration a couple of times like this. You
could define an iterator macro.

Rob
