Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaBWVUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:20:47 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49281 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaBWVUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:20:46 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tomasz Figa <tomasz.figa@gmail.com>,
        "Gregory CLEMENT" <gregory.clement@free-electrons.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <530A420B.5050207@gmail.com>
Cc: "Thomas Petazzoni" <thomas.petazzoni@free-electrons.com>,
        "Andrew Lunn" <andrew@lunn.ch>, "Jason Cooper" <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org,
        "Ezequiel Garcia" <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        "Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>
References: <1392054179-28830-1-git-send-email-gregory.clement@free-electrons.com>
 <530A420B.5050207@gmail.com>
Message-ID: <20140223212040.22529.18650@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2] clk: respect the clock dependencies in of_clk_init
Date: Sun, 23 Feb 2014 13:20:40 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tomasz Figa (2014-02-23 10:46:35)
> Hi Gregory,
> 
> On 10.02.2014 18:42, Gregory CLEMENT wrote:
> > Until now the clock providers were initialized in the order found in
> > the device tree. This led to have the dependencies between the clocks
> > not respected: children clocks could be initialized before their
> > parent clocks.
> >
> > Instead of forcing each platform to manage its own initialization order,
> > this patch adds this work inside the framework itself.
> >
> > Using the data of the device tree the of_clk_init function now delayed
> > the initialization of a clock provider if its parent provider was not
> > ready yet.
> 
> In general this is really great. It's a first step towards sorting out 
> dependencies between clock providers correctly. I have some comments 
> inline, though.

Just to add in here, I think the approach is good but agree with Tomasz'
review comments.

Regards,
Mike

> 
> >
> > The strict dependency check (all parents of a given clk must be
> > initialized) was added by Boris BREZILLON
> 
> Shouldn't this be reflected by a tag of this patch? If you squash a 
> patch signed off by someone then I believe their sign-off tag should be 
> added to the base patch. Correct me if I'm wrong, though.
> 
> >
> > Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > ---
> >
> > Since the v1, I have merged the  strict dependency check from Boris.
> > And of course tested on my Armada 370 and Armada XP based board
> >
> >   drivers/clk/clk.c | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
> >   1 file changed, 106 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> > index 5517944495d8..684976993297 100644
> > --- a/drivers/clk/clk.c
> > +++ b/drivers/clk/clk.c
> > @@ -2526,24 +2526,127 @@ const char *of_clk_get_parent_name(struct device_node *np, int index)
> >   }
> >   EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
> >
> > +struct clock_provider {
> 
> The name is a bit too generic and slightly misleading. IMHO struct 
> deferred_clk_provider (and deferred_clk_providers for the list) would be 
> better.
> 
> > +     of_clk_init_cb_t clk_init_cb;
> > +     struct device_node *np;
> > +     struct list_head node;
> > +};
> > +
> > +static LIST_HEAD(clk_provider_list);
> > +
> > +/*
> > + * This function looks for a parent clock. If there is one, then it
> > + * checks that the provider for this parent clock was initialized, in
> > + * this case the parent clock will be ready.
> > + */
> > +static int parent_ready(struct device_node *np)
> > +{
> > +     struct of_phandle_args clkspec;
> > +     struct of_clk_provider *provider;
> > +     int num_parents;
> > +     bool found;
> > +     int i;
> > +
> > +     /*
> > +      * If there is no clock parent, no need to wait for them, then
> > +      * we can consider their absence as being ready
> > +      */
> > +     num_parents = of_count_phandle_with_args(np, "clocks", "#clock-cells");
> > +     if (num_parents <= 0)
> > +             return 1;
> 
> of_clk_get_parent_count() can be used here...
> 
> > +
> > +     for (i = 0; i < num_parents; i++) {
> > +             if (of_parse_phandle_with_args(np, "clocks", "#clock-cells", i,
> > +                                            &clkspec))
> > +                     return 1;
> > +
> > +             /* Check if we have such a provider in our array */
> > +             found = false;
> > +             list_for_each_entry(provider, &of_clk_providers, link) {
> > +                     if (provider->node == clkspec.np) {
> > +                             found = true;
> > +                             break;
> > +                     }
> > +             }
> > +
> > +             if (!found)
> > +                     return 0;
> > +     }
> 
> ...or even better, __of_clk_get_from_provider() could modified to return 
> -EPROBE_DEFER if requested provider is not registered and you could 
> simply call of_clk_get(np, i) and handle its return value appropriately:
> 
> - on !IS_ERR(clk) call clk_put() and continue with iterations,
> - on IS_ERR(clk) && PTR_ERR(clk) == -EPROBE_DEFER return 0 immediately,
> - in any other case end the loop (end of clock specifiers).
> 
> This would make CCF even closer to proper handling of provider ordering, 
> with a nice side effect of handling deferred probe for platform devices.
> 
> > +
> > +     return 1;
> > +}
> > +
> >   /**
> >    * of_clk_init() - Scan and init clock providers from the DT
> >    * @matches: array of compatible values and init functions for providers.
> >    *
> > - * This function scans the device tree for matching clock providers and
> > - * calls their initialization functions
> > + * This function scans the device tree for matching clock providers
> > + * and calls their initialization functions. It also do it by trying
> > + * to follow the dependencies.
> >    */
> >   void __init of_clk_init(const struct of_device_id *matches)
> >   {
> >       const struct of_device_id *match;
> >       struct device_node *np;
> > +     struct clock_provider *clk_provider, *next;
> > +     bool is_init_done;
> >
> >       if (!matches)
> >               matches = &__clk_of_table;
> >
> >       for_each_matching_node_and_match(np, matches, &match) {
> >               of_clk_init_cb_t clk_init_cb = match->data;
> > -             clk_init_cb(np);
> > +
> > +
> > +             if (parent_ready(np)) {
> > +                     /*
> > +                      * The parent clock is ready or there is no
> > +                      * clock parent at all, in this case the
> > +                      * provider can be initialize immediately.
> > +                      */
> > +                     clk_init_cb(np);
> > +             } else {
> > +                     /*
> > +                      * The parent clock is not ready, this
> > +                      * provider is moved to a list to be
> > +                      * initialized later
> > +                      */
> > +                     struct clock_provider *parent = kzalloc(sizeof(struct clock_provider),
> > +                                                     GFP_KERNEL);
> > +
> > +                     parent->clk_init_cb = match->data;
> > +                     parent->np = np;
> > +                     list_add(&parent->node, &clk_provider_list);
> > +             }
> > +     }
> 
> I wonder if this couldn't be replaced with simply adding all the 
> providers to the list first and then proceeding with the loop below to 
> handle the registrations.
> 
> > +
> > +     while (!list_empty(&clk_provider_list)) {
> > +             is_init_done = false;
> > +             list_for_each_entry_safe(clk_provider, next,
> > +                                     &clk_provider_list, node) {
> > +                     if (parent_ready(clk_provider->np)) {
> > +                             clk_provider->clk_init_cb(clk_provider->np);
> > +                             list_del(&clk_provider->node);
> > +                             kfree(clk_provider);
> > +                             is_init_done = true;
> > +                     }
> > +             }
> > +
> > +             if (!is_init_done) {
> > +                     /*
> > +                      * We didn't managed to initialize any of the
> > +                      * remaining providers during the last loop,
> > +                      * so now we initialize all the remaining ones
> > +                      * unconditionally in case the clock parent
> > +                      * was not mandatory
> > +                      */
> > +                     list_for_each_entry_safe(clk_provider, next,
> > +                                             &clk_provider_list, node) {
> > +                             clk_provider->clk_init_cb(clk_provider->np);
> > +                             list_del(&clk_provider->node);
> > +                             kfree(clk_provider);
> 
> Hmm, this is basically the code above repeated without the if. What 
> about something like the code snippet below?
> 
> bool force = false;
> while (!list_empty(&clk_provider_list)) {
>         is_init_done = false;
>         list_for_each_entry_safe(clk_provider, next,
>                                 &clk_provider_list, node) {
>                 if (force || parent_ready(clk_provider->np)) {
>                         clk_provider->clk_init_cb(clk_provider->np);
>                         list_del(&clk_provider->node);
>                         kfree(clk_provider);
>                         is_init_done = true;
>                 }
>         }
> 
>         if (!is_init_done)
>                 force = true;
> }
> 
> Best regards,
> Tomasz
