Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbaAHKUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:20:55 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754994AbaAHKUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:20:52 -0500
From: Richard Weinberger <richard@nod.at>
To: x86@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, seiji.aguchi@hds.com,
        rientjes@google.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, bp@alien8.de
Subject: Re: [PATCH] APIC: Read Error Status Register correctly
Date: Wed, 08 Jan 2014 11:20:40 +0100
Message-ID: <2193321.5PpjVl4PAc@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.12.0-34.ge8fa6b4-desktop; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1387823250-27218-1-git-send-email-richard@nod.at>
References: <1387823250-27218-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 23. Dezember 2013, 19:27:30 schrieb Richard Weinberger:
> Currently we do a read, a dummy write and a final read to fetch the error
> code. The value from the final read is taken.
> This is not the recommended way and leads to corrupted/lost ESR values.
> 
> Intel(c) 64 and IA-32 Architectures Software Developer's Manual,
> 
> Combined Volumes 1, 2ABC, 3ABC, Section 10.5.3 states:
> >>Before attempt to read from the ESR, software should first write to it.
> 
> (The value written does not affect the values read subsequently;
> only zero may be written in x2APIC mode.) This write clears
> any previously logged errors and updates the ESR with any errors
> detected since the last write to the ESR.
> This write also rearms the APIC error interrupt triggering mechanism.<<
> 
> This patch removes the first read such that we are conform with the manual.
> 
> On my (very old) Pentium MMX SMP system this patch fixes the issue that
> APIC errors a) are not always reported and b) are reported with false
> error numbers.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/x86/kernel/apic/apic.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index d278736..4ec1dd6 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1968,7 +1968,7 @@ __visible void smp_trace_spurious_interrupt(struct
> pt_regs *regs) */
>  static inline void __smp_error_interrupt(struct pt_regs *regs)
>  {
> -	u32 v0, v1;
> +	u32 v;
>  	u32 i = 0;
>  	static const char * const error_interrupt_reason[] = {
>  		"Send CS error",		/* APIC Error Bit 0 */
> @@ -1982,21 +1982,20 @@ static inline void __smp_error_interrupt(struct
> pt_regs *regs) };
> 
>  	/* First tickle the hardware, only then report what went on. -- REW */
> -	v0 = apic_read(APIC_ESR);
>  	apic_write(APIC_ESR, 0);
> -	v1 = apic_read(APIC_ESR);
> +	v = apic_read(APIC_ESR);
>  	ack_APIC_irq();
>  	atomic_inc(&irq_err_count);
> 
> -	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x(%02x)",
> -		    smp_processor_id(), v0 , v1);
> +	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x",
> +		    smp_processor_id(), v);
> 
> -	v1 = v1 & 0xff;
> -	while (v1) {
> -		if (v1 & 0x1)
> +	v &= 0xff;
> +	while (v) {
> +		if (v & 0x1)
>  			apic_printk(APIC_DEBUG, KERN_CONT " : %s", 
error_interrupt_reason[i]);
>  		i++;
> -		v1 >>= 1;
> +		v >>= 1;
>  	}
> 
>  	apic_printk(APIC_DEBUG, KERN_CONT "\n");

Any comments on this?

Thanks,
//richard

