Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbaDXJXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:23:15 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:51528 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaDXJXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:23:07 -0400
Date: Thu, 24 Apr 2014 10:26:42 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 3/3] of: Handle memory@0 node on PPC32 only
Message-ID: <20140424092642.GQ5904@bivouac.eciton.net>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
 <1397756521-29387-4-git-send-email-leif.lindholm@linaro.org>
 <CAMuHMdXBNWum7UJ95uT2hwTd1b5C8ebF2LQ4T-A+RS80p7MH=A@mail.gmail.com>
 <20140418125924.GF5904@bivouac.eciton.net>
 <20140422133515.E7A0BC40754@trevor.secretlab.ca>
 <20140423104528.GD30036@e106331-lin.cambridge.arm.com>
 <20140423131058.D94B6C408D2@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423131058.D94B6C408D2@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 02:10:58PM +0100, Grant Likely wrote:
> > Does anyone have a LongTrail DT to hand, and if so does the root have a
> > compatible string? From grepping through the kernel I could only find a
> > model string ("IBM,LongTrail").
> 
> Actually, on LongTrail this can be removed from the common code
> entirely. It has real open firmware and PowerPC already has the
> infrastructure for fixing up the device tree.
> 
> Here's a draft patch that I've compile tested, but nothing else.

I would certainly be happy with that.

Consider my 3/3 withdrawn.

And if the kernel proper will stop honoring nodes with no type,
there is no need for the stub to treat those specially either.

/
    Leif

> g.
> 
> ---
> 
> diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
> index 078145acf7fb..18b2c3fee98f 100644
> --- a/arch/powerpc/kernel/prom_init.c
> +++ b/arch/powerpc/kernel/prom_init.c
> @@ -2587,9 +2587,18 @@ static void __init fixup_device_tree_chrp(void)
>  	phandle ph;
>  	u32 prop[6];
>  	u32 rloc = 0x01006000; /* IO space; PCI device = 12 */
> -	char *name;
> +	char *name, strprop[16];
>  	int rc;
>  
> +	/* Deal with missing device_type in LongTrail memory node */
> +	name = "/memory@0";
> +	ph = call_prom("finddevice", 1, 1, ADDR(name));
> +	rc = prom_getprop(ph, "device_type", strprop, sizeof(strprop));
> +	if (rc == PROM_ERROR || strcmp(strprop, "memory") != 0) {
> +		prom_printf("Fixing up missing device_type on /memory@0 node...\n");
> +		prom_setprop(ph, name, "device_type", "memory", sizeof("memory"));
> +	}
> +
>  	name = "/pci@80000000/isa@c";
>  	ph = call_prom("finddevice", 1, 1, ADDR(name));
>  	if (!PHANDLE_VALID(ph)) {
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 7a2ef7bb8022..7cda0d279cbe 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -886,14 +886,7 @@ int __init early_init_dt_scan_memory(unsigned long node, const char *uname,
>  	unsigned long l;
>  
>  	/* We are scanning "memory" nodes only */
> -	if (type == NULL) {
> -		/*
> -		 * The longtrail doesn't have a device_type on the
> -		 * /memory node, so look for the node called /memory@0.
> -		 */
> -		if (depth != 1 || strcmp(uname, "memory@0") != 0)
> -			return 0;
> -	} else if (strcmp(type, "memory") != 0)
> +	if (!type || strcmp(type, "memory") != 0)
>  		return 0;
>  
>  	reg = of_get_flat_dt_prop(node, "linux,usable-memory", &l);
> 
