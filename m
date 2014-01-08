Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbaAHRFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:05:33 -0500
Received: from 71-19-161-253.dedicated.allstream.net ([71.19.161.253]:58547
	"EHLO nsa.nbspaymentsolutions.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756509AbaAHRFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:05:30 -0500
X-Greylist: delayed 1327 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jan 2014 12:05:29 EST
From: Bill Pringlemeir <bpringlemeir@nbsps.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alison Wang <b18965@freescale.com>,
        Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv8 RFC] pwm: Add Freescale FTM PWM driver support
Organization: NBS Payment Solutions
References: <1388726661-3391-1-git-send-email-Li.Xiubo@freescale.com>
Date: Wed, 08 Jan 2014 11:36:44 -0500
Message-ID: <87lhyqa0rn.fsf@nbsps.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  3 Jan 2014, Li.Xiubo@freescale.com wrote:

> The FTM PWM device can be found on Vybrid VF610 Tower and
> Layerscape LS-1 SoCs.
>
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Signed-off-by: Alison Wang <b18965@freescale.com>
> Signed-off-by: Jingchang Lu <b35083@freescale.com>
> Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>
> Hi Thierry, Bill

[snip]

> +static unsigned long fsl_pwm_calculate_period_cycles(struct fsl_pwm_chip *fpc,
> +						     unsigned long period_ns,
> +						     enum fsl_pwm_clk index)
> +{
> +	bool bg = fpc->big_endian;
> +	int ret;
> +
> +	fpc->counter_clk_select = FTM_SC_CLK(bg, index);

Yes, this is the spirit of what I was suggesting.  The code is much less
efficient/bigger on the Vybrid with this run-time detection; but this is
more efficient/smaller than previous versions.  I think that 'bg' can be
a compiler '#define' base on the configured SOC-systems.  Ie, if the
kernel config only has 'Vybrid' or only 'LayerScape', then 'bg' can be a
hard coded value.  The compiler will produce much better code in these
cases.

Also, maybe 'distro' people may want to make a 'hand-held' (Debian) or a
'router' (OpenWRT) distribution and they would only pick either 'Vybrid'
or 'LayerScape'.  However, if someone wants an 'every ARM under the
sun', then the code still works.  So, I think that the code is better
setup for a subsequent patch set like this (or at least just a good).

Especially, the stuff on the I/O swapping in the 'readl()' and
'writel()' is no longer needed; I think you can use the same function
for both SOCs.

> +#define __FTM_SWAP32(v) ((u32)(\
> +	(((u32)(v) & (u32)0x000000ffUL) << 24) |\
> +	(((u32)(v) & (u32)0x0000ff00UL) <<  8) |\
> +	(((u32)(v) & (u32)0x00ff0000UL) >>  8) |\
> +	(((u32)(v) & (u32)0xff000000UL) >> 24)))
> +#define FTM_SWAP32(b, v)	(b ? __FTM_SWAP32(v) : v)

I think that there are macros that you could use here.  For instance,
'#include <linux/swab.h>' (powerpc and arm) has some assembler macros
that are quite fast for swapping.  If the kernel config has ARCH >= 6
for ARM, then the very fast 'rev' instruction is used.  If not, then a
generic version is used as you have coded.  The PowerPC (another
possible future ARCH for QorIQ/Layerscape SOC?) always has inline
assembler macros.

So,

+ #include <linux/swab.h>
...
+ #define FTM_SWAP32(b, v)	(b ? __swab32(v) : v)

might be better.

Suggested-by: Bill Pringlemeir <bpringlemeir@nbsps.com>

Thanks,
Bill Pringlemeir.
