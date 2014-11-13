Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbaKMMom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 07:44:42 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35148 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639AbaKMMok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 07:44:40 -0500
MIME-Version: 1.0
In-Reply-To: <1415839522.5124.58.camel@kernel.crashing.org>
References: <1415771461.5124.33.camel@kernel.crashing.org> <20141113091036.4e9ec43d@canb.auug.org.au>
 <1415833725.5124.53.camel@kernel.crashing.org> <1415839522.5124.58.camel@kernel.crashing.org>
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 13 Nov 2014 12:44:19 +0000
X-Google-Sender-Auth: 92YafDxlLqSZVd24JZ7fNiKNGVI
Message-ID: <CACxGe6s0CXL2oRKCLhzzycOKWJStxdZsc1pn_X8fLuAqCguBMA@mail.gmail.com>
Subject: Re: [PATCH] of/base: Fix PowerPC address parsing hack
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Rob Herring <robherring2@gmail.com>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 12:45 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> What about this one instead ? I want to cache it because that function
> can be called quite a while and doing two additional property lookup
> and string compares every time might hurt some platforms.
>
> ----
>
> We have a historical hack that treats missing ranges properties as the
> equivalent of an empty one. This is needed for ancient PowerMac "bad"
> device-trees, and shouldn't be enabled for any other PowerPC platform,
> otherwise we get some nasty layout of devices in sysfs or even
> duplication when a set of otherwise identically named devices is
> created multiple times under a different parent node with no ranges
> property.
>
> This fix is needed for the PowerNV i2c busses to be exposed properly
> and will fix a number of other embedded cases.
>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: <stable@vger.kernel.org>

How far back does this need to go? I assume I need to get this in for v3.18.

>
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index e371825..5eae0cd 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -403,6 +403,17 @@ static struct of_bus *of_match_bus(struct device_node *np)
>         return NULL;
>  }
>
> +static int of_empty_ranges_quirk(void)
> +{
> +       /* To save cycles, we cache the result */
> +       static int quirk_state = -1;
> +

if (IS_ENABLED(CONFIG_POWERPC)) {

> +       if (quirk_state < 0)
> +               quirk_state = of_machine_is_compatible("Power Macintosh") ||
> +                       of_machine_is_compatible("MacRISC");
> +       return quirk_state;

}
return 0;

So it gets compiled out for non powerpc.

> +}
> +
>  static int of_translate_one(struct device_node *parent, struct of_bus *bus,
>                             struct of_bus *pbus, __be32 *addr,
>                             int na, int ns, int pna, const char *rprop)
> @@ -428,12 +439,10 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
>          * This code is only enabled on powerpc. --gcl
>          */
>         ranges = of_get_property(parent, rprop, &rlen);
> -#if !defined(CONFIG_PPC)
> -       if (ranges == NULL) {
> +       if (ranges == NULL && !of_empty_ranges_quirk()) {
>                 pr_err("OF: no ranges; cannot translate\n");
>                 return 1;
>         }
> -#endif /* !defined(CONFIG_PPC) */
>         if (ranges == NULL || rlen == 0) {
>                 offset = of_read_number(addr, na);
>                 memset(addr, 0, pna * 4);
>
>
