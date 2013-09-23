Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3IWH4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:56:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41969 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab3IWH4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:56:41 -0400
Date: Mon, 23 Sep 2013 17:56:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@au1.ibm.com>
Subject: Re: [PATCH] powerpc/irq: Run softirqs off the top of the irq stack
Message-Id: <20130923175621.e9bab9ff0e6545457666602f@canb.auug.org.au>
In-Reply-To: <1379910958.6625.3.camel@pasglop>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	<CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	<alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	<20130920162603.GA30381@localhost.localdomain>
	<CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	<CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	<1379799901.24090.6.camel@pasglop>
	<523E4F8A.7020708@zytor.com>
	<1379824754.24090.11.camel@pasglop>
	<1379824861.24090.12.camel@pasglop>
	<20130922162410.GA10649@laptop.programming.kicks-ass.net>
	<1379887000.24090.19.camel@pasglop>
	<CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
	<1379889489.24090.34.camel@pasglop>
	<1379910958.6625.3.camel@pasglop>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Sep_2013_17_56_21_+1000_EXBcDQzK7fOR66L4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Sep_2013_17_56_21_+1000_EXBcDQzK7fOR66L4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Mon, 23 Sep 2013 14:35:58 +1000 Benjamin Herrenschmidt <benh@kernel.cras=
hing.org> wrote:
>
> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> index c69440c..0c9646f 100644
> --- a/arch/powerpc/kernel/irq.c
> +++ b/arch/powerpc/kernel/irq.c
> @@ -443,46 +443,7 @@ void migrate_irqs(void)
> =20
>  static inline void handle_one_irq(unsigned int irq)
>  {
> -	struct thread_info *curtp, *irqtp;
> -	unsigned long saved_sp_limit;
> -	struct irq_desc *desc;
> -
> -	desc =3D irq_to_desc(irq);
> -	if (!desc)
> -		return;
> -
> -	/* Switch to the irq stack to handle this */
> -	curtp =3D current_thread_info();
> -	irqtp =3D hardirq_ctx[smp_processor_id()];
> -
> -	if (curtp =3D=3D irqtp) {
> -		/* We're already on the irq stack, just handle it */
> -		desc->handle_irq(irq, desc);
> -		return;
> -	}
> -
> -	saved_sp_limit =3D current->thread.ksp_limit;
> -
> -	irqtp->task =3D curtp->task;
> -	irqtp->flags =3D 0;
> -
> -	/* Copy the softirq bits in preempt_count so that the
> -	 * softirq checks work in the hardirq context. */
> -	irqtp->preempt_count =3D (irqtp->preempt_count & ~SOFTIRQ_MASK) |
> -			       (curtp->preempt_count & SOFTIRQ_MASK);
> =20
> -	current->thread.ksp_limit =3D (unsigned long)irqtp +
> -		_ALIGN_UP(sizeof(struct thread_info), 16);
> -
> -	call_handle_irq(irq, desc, irqtp, desc->handle_irq);
> -	current->thread.ksp_limit =3D saved_sp_limit;
> -	irqtp->task =3D NULL;
> -
> -	/* Set any flag that may have been set on the
> -	 * alternate stack
> -	 */
> -	if (irqtp->flags)
> -		set_bits(irqtp->flags, &curtp->flags);
>  }

This function ends up as a single blank line ...

> @@ -519,18 +480,64 @@ void do_IRQ(struct pt_regs *regs)
>  	 */
>  	irq =3D ppc_md.get_irq();
> =20
> -	/* We can hard enable interrupts now */
> +	/* We can hard enable interrupts now to allow perf interrupts */
>  	may_hard_irq_enable();
> =20
>  	/* And finally process it */
> -	if (irq !=3D NO_IRQ)
> -		handle_one_irq(irq);

then you remove the only call, so why not just remove the function
completely?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__23_Sep_2013_17_56_21_+1000_EXBcDQzK7fOR66L4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSP/QqAAoJEECxmPOUX5FE2SQP/i9v00jfdhVMuZ/rRcHJ7d7V
MxlqUpRetFOwFu6pk+DDPpfwiGBaVyv14A2AlOJK4X14Qf49WgcfGZFYDbtMC7XY
AzAOaut+A7W7PocazNqs9Do51JAkGB3culEB8CZ08+f2zIU3NpBrStlztoiwA37D
R2ogmQrAdfvkh3tDnUZd00umrz3zgBaWzFDyaGQc+GEvgask8KFImGgWB3hUlWeg
oi66J4fd46ZOexe6zhg1/ieR8BSB/RmBEP8pS2OLXZnFWppo0228aAZlwj+Fj3N7
kZxwhLO5wHEd+cDZ298M8UeosMap4WikcOnRYoT3BeGzzeXP3rr0QMHxts2B4AMU
hPCKENDNzH6ZQoHDcO1L4170Db11AxGRYKwtbAb1XznKdIj34/gF2ReIS64WoIqg
8x1JUjUMqrtYzgeJzQqGPMxmBxMIWkWkhSkEJzChAtDQ+qRCVPbEfqMBHcbzXhTC
757ySB+2wjaG8o2IHO7/GpYs/kRpFLfu1csmOpi28F7we4hoDRo/pFTDFPeOsQbZ
I0N8DcLGToSmuYsoLVlJa28CXuajS3ee7R3+q5ekTqoGnU95CjDvio/6OgQv8b5I
byvKT5TV8pXUePPPTMn6JOArYe9K9wPPzVjHYEwD/l8fYsanzvBhvoektWJrh8ac
OJUP+C3PNW5p0yuLTOm7
=hgo+
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Sep_2013_17_56_21_+1000_EXBcDQzK7fOR66L4--
