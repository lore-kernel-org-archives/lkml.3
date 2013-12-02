Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3LBOjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:39:32 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:56512 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab3LBOj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:39:26 -0500
MIME-Version: 1.0
In-Reply-To: <20131202.130220.1404999403649937134.hdoyu@nvidia.com>
References: <20131128.145818.1345100874304396564.hdoyu@nvidia.com>
	<20131129.134625.431945240074254704.hdoyu@nvidia.com>
	<529B8739.60701@wwwdotorg.org>
	<20131202.130220.1404999403649937134.hdoyu@nvidia.com>
Date: Mon, 2 Dec 2013 08:39:25 -0600
Message-ID: <CAL_JsqKDokswB1jJN7ZT-Us0h=uTf5qHLZFUJfGFkXBjdO5XjA@mail.gmail.com>
Subject: Re: [RFC][PATCHv6+++ 01/13] of: introduce of_property_for_earch_phandle_with_args()
From: Rob Herring <robherring2@gmail.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 5:02 AM, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
> Stephen Warren <swarren@wwwdotorg.org> wrote @ Sun, 1 Dec 2013 20:00:09 +0100:
>
>> On 11/29/2013 04:46 AM, Hiroshi Doyu wrote:
>> ...
>> > Iterating over a property containing a list of phandles with arguments
>> > is a common operation for device drivers. This patch adds a new
>> > of_property_for_each_phandle_with_args() macro to make the iteration
>> > simpler.
>> >
>> > Introduced a new struct "of_phandle_iter" to keep the state when
>> > iterating over the list.
>> >
>> > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
>> > ---
>> > v6+++:
>>
>> Surely that's v9; "+++" is rather unusual.
>
> My intention was to put this into the next v7 series after I get this
> reviewed as RFC.
> ...
>> Together with removing:
>>
>> > +   const char      *cells_name;
>> > +   int             cell_count;
>>
>> ... then you'd only be left with cur/end, so I think you could get away
>> without a struct at all, but simply "cur" as the iterator variable, plus
>> "end" as the one temp variable.
>
> Although the above proposal would be alsmot same as "[RFC][PATCHv6++
> 01/13]"(*1) where I use *list(cur) and rem as remaining count, here's
> the update. I'll put this into v7 series.
>
> ---8<------8<------8<------8<------8<------8<------8<------8<------8<---
> From: Hiroshi Doyu <hdoyu@nvidia.com>
>
> Iterating over a property containing a list of phandles with arguments
> is a common operation for device drivers. This patch adds a new
> of_property_for_each_phandle_with_args() macro to make the iteration
> simpler.
>
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
> v6++++:
> Iterate without intrducing a new struct.
>
> v6+++:
> Introduced a new struct "of_phandle_iter" to keep the state when
> iterating over the list.
>
> v6++:
> Optimized to avoid O(n^2), suggested by Stephen Warren.
> http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007066.html
>
> I didn't introduce any struct to hold params and state here.
>
> v6+:
> Use the description, which Grant Likely proposed, to be full enough
> that a future reader can figure out why a patch was written.
>
> v5:
> New patch for v5.
>
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
>  drivers/of/base.c  | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of.h | 34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 87 insertions(+)
>
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index f807d0e..7501f24 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1201,6 +1201,59 @@ void of_print_phandle_args(const char *msg, const struct of_phandle_args *args)
>         printk("\n");
>  }
>
> +const __be32 *of_phandle_iter_next(const char *cells_name, int cell_count,
> +                                  const __be32 *cur, const __be32 *end,
> +                                  struct of_phandle_args *out_args)
> +{
> +       phandle phandle;
> +       struct device_node *dn;
> +       int i;
> +
> +       if (!cells_name && !cell_count)
> +               return NULL;
> +
> +       if (!cur)
> +               return NULL;
> +
> +       if (end - cur <= 0)

These 2 if's can be combined: if (!cur || (end - cur <= 0))

> +               return NULL;
> +
> +       phandle = be32_to_cpup(cur++);
> +       if (!phandle)
> +               return NULL;

Won't of_find_node_by_phandle do this check?

> +
> +       dn = of_find_node_by_phandle(phandle);
> +       if (!dn)
> +               return NULL;
> +
> +       if (cells_name)
> +               if (of_property_read_u32(dn, cells_name, &cell_count))
> +                       return NULL;
> +
> +       out_args->np = dn;
> +       out_args->args_count = cell_count;
> +       for (i = 0; i < cell_count; i++)
> +               out_args->args[i] = be32_to_cpup(cur++);
> +
> +       return cur;
> +}
> +EXPORT_SYMBOL_GPL(of_phandle_iter_next);
> +
> +const __be32 *of_phandle_iter_init(const struct device_node *np,
> +                                  const char *list_name,
> +                                  const __be32 **end)
> +{
> +       size_t bytes;
> +       const __be32 *cur;
> +
> +       cur = of_get_property(np, list_name, &bytes);
> +       if (bytes)
> +               *end = cur + bytes / sizeof(*cur);
> +
> +       return cur;
> +}
> +EXPORT_SYMBOL_GPL(of_phandle_iter_init);
> +
>  static int __of_parse_phandle_with_args(const struct device_node *np,
>                                         const char *list_name,
>                                         const char *cells_name,
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 276c546..c23710b 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -303,6 +303,14 @@ extern int of_parse_phandle_with_fixed_args(const struct device_node *np,
>  extern int of_count_phandle_with_args(const struct device_node *np,
>         const char *list_name, const char *cells_name);
>
> +extern const __be32 *of_phandle_iter_init(const struct device_node *np,
> +                                         const char *list_name,
> +                                         const __be32 **end);
> +extern const __be32 *of_phandle_iter_next(const char *cells_name,
> +                                         int cell_count,
> +                                         const __be32 *cur, const __be32 *end,
> +                                         struct of_phandle_args *out_args);
> +
>  extern void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align));
>  extern int of_alias_get_id(struct device_node *np, const char *stem);
>
> @@ -527,6 +535,24 @@ static inline int of_count_phandle_with_args(struct device_node *np,
>         return -ENOSYS;
>  }
>
> +static inline const __be32 *of_phandle_iter_init(const struct device_node *np,
> +                                                const char *list_name,
> +                                                const char *cells_name,
> +                                                const int cell_count,
> +                                                struct of_phandle_args *out_args)

Need to update the arguments.

> +{
> +       return NULL;
> +}
> +
> +static inline const __be32 *of_phandle_iter_next(const char *cells_name,
> +                                                int cell_count,
> +                                                const __be32 *cur,
> +                                                const __be32 *end,
> +                                                struct of_phandle_args *out_args);
> +{
> +       return NULL;
> +}
> +
>  static inline int of_alias_get_id(struct device_node *np, const char *stem)
>  {
>         return -ENOSYS;
> @@ -613,6 +639,14 @@ static inline int of_property_read_u32(const struct device_node *np,
>                 s;                                              \
>                 s = of_prop_next_string(prop, s))
>
> +#define of_property_for_each_phandle_with_args(node, list_name,        cells_name, \

Some extra whitespace here.

> +                                              cell_count, out_args, cur, end) \
> +       for (cur = of_phandle_iter_init(node, list_name, &end),         \
> +                    cur = of_phandle_iter_next(cells_name, cell_count, \
> +                                               cur, end, &out_args);   \
> +            cur;                                                       \
> +            cur = of_phandle_iter_next(cells_name, cell_count, cur, end, &out_args))
> +
>  #if defined(CONFIG_PROC_FS) && defined(CONFIG_PROC_DEVICETREE)
>  extern void proc_device_tree_add_node(struct device_node *, struct proc_dir_entry *);
>  extern void proc_device_tree_add_prop(struct proc_dir_entry *pde, struct property *prop);
> --
> 1.8.1.5
>
>
>
>
>
> *1:
>  http://lists.linuxfoundation.org/pipermail/iommu/2013-November/007086.html
