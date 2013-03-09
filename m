Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab3CITqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 14:46:47 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:38271 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab3CITqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 14:46:46 -0500
MIME-Version: 1.0
In-Reply-To: <1362855725.3690.92.camel@shinybook.infradead.org>
References: <1362758331.32099.121.camel@i7.infradead.org>
	<513AF783.6050906@gmail.com>
	<1362855725.3690.92.camel@shinybook.infradead.org>
Date: Sat, 9 Mar 2013 20:46:45 +0100
Message-ID: <CABJ1b_TJKZFp7uwc46K1NnUvhHfAXR7yYH5mVLBDO9S8ywGg+Q@mail.gmail.com>
Subject: Re: memory leak and other oddness in pinctrl-mvebu.c
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

I will not be able to test before mid-week ealiest. I added Andrew Lunn to
the list. He and Thomas can test your patch for Kirkwood and Armada XP/370
respectively. I will test on Dove asap.

Sebastian

On Sat, Mar 9, 2013 at 8:02 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Sat, 2013-03-09 at 09:49 +0100, Sebastian Hesselbarth wrote:
>> I don't have a strong opinion on that, but I prefer not to have the list
>> statically in the SoC specific drivers. I think counting the number of
>> unique functions for each SoC specific driver once and verify the above
>> heuristic (fewer unique functions than pins) is still valid. Then drop
>> the krealloc and leave the array the way it is allocated on devm_kzalloc.
>
> Yeah. If you stick a check in the loop and make it warn if it *would*
> have run over the end of the array, that sounds like it ought to be
> fine. Something like this, perhaps? Still untested but otherwise
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>
> diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
> index c689c04..55d55d5 100644
> --- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
> +++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
> @@ -478,7 +478,8 @@ static struct pinctrl_ops mvebu_pinctrl_ops = {
>         .dt_free_map = mvebu_pinctrl_dt_free_map,
>  };
>
> -static int _add_function(struct mvebu_pinctrl_function *funcs, const char *name)
> +static int _add_function(struct mvebu_pinctrl_function *funcs, int nr_funcs,
> +                        const char *name)
>  {
>         while (funcs->num_groups) {
>                 /* function already there */
> @@ -487,7 +488,11 @@ static int _add_function(struct mvebu_pinctrl_function *funcs, const char *name)
>                         return -EEXIST;
>                 }
>                 funcs++;
> +               nr_funcs--;
>         }
> +       if (!nr_funcs)
> +               return -EOVERFLOW;
> +
>         funcs->name = name;
>         funcs->num_groups = 1;
>         return 0;
> @@ -501,7 +506,7 @@ static int mvebu_pinctrl_build_functions(struct platform_device *pdev,
>         int n, s;
>
>         /* we allocate functions for number of pins and hope
> -        * there are less unique functions than pins available */
> +        * there are fewer unique functions than pins available */
>         funcs = devm_kzalloc(&pdev->dev, pctl->desc.npins *
>                              sizeof(struct mvebu_pinctrl_function), GFP_KERNEL);
>         if (!funcs)
> @@ -510,26 +515,27 @@ static int mvebu_pinctrl_build_functions(struct platform_device *pdev,
>         for (n = 0; n < pctl->num_groups; n++) {
>                 struct mvebu_pinctrl_group *grp = &pctl->groups[n];
>                 for (s = 0; s < grp->num_settings; s++) {
> +                       int ret;
> +
>                         /* skip unsupported settings on this variant */
>                         if (pctl->variant &&
>                             !(pctl->variant & grp->settings[s].variant))
>                                 continue;
>
>                         /* check for unique functions and count groups */
> -                       if (_add_function(funcs, grp->settings[s].name))
> +                       ret = _add_function(funcs, pctl->desc.npins,
> +                                           grp->settings[s].name);
> +                       if (ret == -EOVERFLOW)
> +                               dev_err(&pdev->dev,
> +                                       "More functions than pins(%d)\n",
> +                                       pctl->desc.npins);
> +                       if (ret)
>                                 continue;
>
>                         num++;
>                 }
>         }
>
> -       /* with the number of unique functions and it's groups known,
> -          reallocate functions and assign group names */
> -       funcs = krealloc(funcs, num * sizeof(struct mvebu_pinctrl_function),
> -                        GFP_KERNEL);
> -       if (!funcs)
> -               return -ENOMEM;
> -
>         pctl->num_functions = num;
>         pctl->functions = funcs;
>
>
>
> --
> dwmw2
>
