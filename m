Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaBYV6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:58:19 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:42228 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaBYV6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:58:18 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        metag <linux-metag@vger.kernel.org>
Subject: Re: [patch 06/26] metag: Use irq_set_affinity instead of homebrewn code
Date: Tue, 25 Feb 2014 21:57:59 +0000
Message-ID: <1649567.LUiB1QnacO@radagast>
Organization: Imagination Technologies
User-Agent: KMail/4.11.5 (Linux/3.13.4+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.02.1402241432360.21251@ionos.tec.linutronix.de>
References: <20140223212703.511977310@linutronix.de> <530B47FD.80608@imgtec.com> <alpine.DEB.2.02.1402241432360.21251@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6570997.k8I0jsJaj9"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart6570997.k8I0jsJaj9
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Thomas,

Sorry for delay, I didn't get a chance to try this earlier.

On Monday 24 February 2014 15:24:55 Thomas Gleixner wrote:
> On Mon, 24 Feb 2014, James Hogan wrote:
> > On 23/02/14 21:40, Thomas Gleixner wrote:
> > > There is no point in having an incomplete copy of irq_set_affinity()
> > > for the hotplug irq migration code.
> > 
> > That sounds reasonable, but when I gave it a try I started getting
> > warnings on the log after offlining one cpu then the other:
> > 
> > META213-Thread0 DSP [LogF] IRQ13 no longer affine to CPU1
> > META213-Thread0 DSP [LogF] IRQ14 no longer affine to CPU1
> > META213-Thread0 DSP [LogF] IRQ15 no longer affine to CPU1
> > META213-Thread0 DSP [LogF] IRQ18 no longer affine to CPU1
> > META213-Thread0 DSP [LogF] IRQ29 no longer affine to CPU1
> > META213-Thread0 DSP [LogF] IRQ30 no longer affine to CPU1
> > META213-Thread0 DSP [LogF] IRQ31 no longer affine to CPU1
> > 
> > It appears that the irq affinities weren't getting modified previously,
> > whereas now irq_do_set_affinity() does do cpumask_copy(data->affinity,
> > mask). Once all CPUs have been offlined at least once you get those
> > spurious messages even though the IRQ affinities haven't been explicitly
> > limited by anything.
> > 
> > I wonder if the stored affinity should really be altered in this case?
> 
> Delta patch below.

Thanks, that does the trick although the same thing needs doing in 
drivers/irqchips/irq-metag-ext.c too.

> 
> You need that irq-metag part in any case as the user space interface
> does not filter out stuff. Assume you offlined core 1 and user changes
> affinity from 0xf to 0xe. So your selector will pick core 1 which is
> offline....

... crap, you're absolutely right. Thanks for spotting that. I'll apply the 
irqchip hunks for v3.14.

As for the rest, I'll take this patch (with the irq.c hunk below) through the 
metag tree if it's okay with you so I can make sure it goes after the irqchip 
fixes (otherwise cpu0 hotplug blows up too).

Thanks a lot,

Cheers
James

> 
> Btw, our handling of this is a bit awkward. Right now we let the user
> do
> 
>       echo 0xf > /proc/irq/$N/smp_affinity
> 
> and reading that back will give you 0xf though the kernel just selects
> a subset or even a single target cpu and one has to analyze
> /proc/interrupts to find out which one.
> 
> We should add some mechanism to tell the user what's really going on.
> But that's a separate issue.
> 
> Thanks,
> 
> 	tglx
> 
> Index: tip/arch/metag/kernel/irq.c
> ===================================================================
> --- tip.orig/arch/metag/kernel/irq.c
> +++ tip/arch/metag/kernel/irq.c
> @@ -287,10 +287,8 @@ void migrate_irqs(void)
>  					    i, cpu);
> 
>  			cpumask_setall(data->affinity);
> -			newcpu = cpumask_any_and(data->affinity,
> -						 cpu_online_mask);
>  		}
> -		irq_set_affinity(i, cpumask_of(newcpu));
> +		irq_set_affinity(i, data->affinity);
>  	}
>  }
>  #endif /* CONFIG_HOTPLUG_CPU */
> Index: tip/drivers/irqchip/irq-metag.c
> ===================================================================
> --- tip.orig/drivers/irqchip/irq-metag.c
> +++ tip/drivers/irqchip/irq-metag.c
> @@ -201,7 +201,7 @@ static int metag_internal_irq_set_affini
>  	 * one cpu (the interrupt code doesn't support it), so we just
>  	 * pick the first cpu we find in 'cpumask'.
>  	 */
> -	cpu = cpumask_any(cpumask);
> +	cpu = cpumask_any_and(cpumask, cpu_online_mask);
>  	thread = cpu_2_hwthread_id[cpu];
> 
>  	metag_out32(TBI_TRIG_VEC(TBID_SIGNUM_TR1(thread)),
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-metag" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--nextPart6570997.k8I0jsJaj9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTDRH1AAoJEKHZs+irPybfBsIP/2OjCFz/1yOrsMAbRiDs/6DQ
pY5s2Jp+k+EeaFzOSWskoV9akp0yG6PSyOwslPixy8m0tnRjYPebCE/azb4kTrEN
+jjIpGxEbCAN0XW2VP9dkRsL0MPXSoHP+ueOIY06+Ei3Dfs/lqG8/eGX+drW6Iwl
zgRup6SstJkf0S25x/JrkBUveoCZCcubXI8CDiBLHi90oEJYNOd0YCxmYPJWnLn+
sUr+V4sKbOkPXVaDoLIisbxoLCXSbVLzT03ZxIEBHjaX8YEOBbIwOUYawL67BDsr
B3sm9vPXsPaTnuHS8CA+4iY/n8DygRNrBl/1Dpb7zLixqpEsqN3e8z/CqOq6CHK7
vRxtQR1vcY4QiwNQ1ZzJvq9XejIgE7ywKj2sk6Fg0GpFHlbUJ6Z//IcWlbDYAphe
1547zsFptcihvkeE94FfzchoXSBMEoMKik5ZWGjVsT6ZJc5ZOdM9e54po3gB1cAy
DaOaqB2Z1lL/tl3SMapSEPgz++IA9BMIe7nqe7GwReu5UnjJzFosfGQ0/z9n/3ys
jM90JsMBZR1XlYiDmErLTqrKgU75qW8FNsVdlgbLkycM1F28NxMBAIf74Emy5//+
G3aOxOtEuHN27f1mG+2t6txO/AiN4ijDQXLMfcf6fiARHCL92MxBLkLovWA/qbkU
efHFkvIrSVvnXKOaA+gw
=e8vy
-----END PGP SIGNATURE-----

--nextPart6570997.k8I0jsJaj9--

