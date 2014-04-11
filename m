Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaDKWga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:36:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48487 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300AbaDKWg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:36:29 -0400
Message-ID: <53486E3F.1020307@zytor.com>
Date: Fri, 11 Apr 2014 15:35:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, JBeulich@suse.com,
        bp@alien8.de
CC: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] X86: Probe for PIC and set legacy_pic appropriately
References: <1397257344-3035-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1397257344-3035-1-git-send-email-kys@microsoft.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 04:02 PM, K. Y. Srinivasan wrote:
>  
> diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
> index 2e977b5..0a57a19 100644
> --- a/arch/x86/kernel/i8259.c
> +++ b/arch/x86/kernel/i8259.c
> @@ -299,11 +299,22 @@ static void unmask_8259A(void)
>  static void init_8259A(int auto_eoi)
>  {
>  	unsigned long flags;
> +	unsigned char probe_val = 0xfb;
>  
>  	i8259A_auto_eoi = auto_eoi;
>  
>  	raw_spin_lock_irqsave(&i8259A_lock, flags);
>  
> +	/* Check to see if we have a PIC */
> +	outb(probe_val, PIC_MASTER_IMR);
> +	probe_val = inb(PIC_MASTER_IMR);
> +	if (probe_val == 0xff) {
> +		printk(KERN_INFO "Using NULL legacy PIC\n");
> +		legacy_pic = &null_legacy_pic;
> +		raw_spin_unlock_irqrestore(&i8259A_lock, flags);
> +		return;
> +	}
> +
>  	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
>  	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
>  

I think it is important to document what this actually means here.  0xfb
is "mask all except for the cascade."

Arguably, we should do this after masking the slave PIC.

On a whole other subject... the whole __byte() logic is a just plain
horrific piece of crap.  Clearly whomever wrote it had never heard of a
union.

I'm still horrifically confused, though, why we mask IRQ 2 (the cascade
interrupt) in i8259.c, but we explicitly do *not* mask IRQ 2 in
boot/pm.c (nor in the assembly code on which boot/pm.c was based.)  In
fact, it looks like we never unmask it.  I'm guessing that the masking
status of the cascade input simply doesn't matter.

At the very least, though, we shouldn't have 0xfb as a magic number, but
use ~(1U << PIC_CASCADE_IR).

	-hpa





