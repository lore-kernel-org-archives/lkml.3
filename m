Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaDNIPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:15:25 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:50058 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaDNIPV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Mon, 14 Apr 2014 04:15:21 -0400
Message-Id: <534BB5320200007800008463@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Mon, 14 Apr 2014 09:15:14 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: <olaf@aepfle.de>, <apw@canonical.com>, <x86@kernel.org>,
        <tglx@linutronix.de>, <devel@linuxdriverproject.org>,
        <gregkh@linuxfoundation.org>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH V2 1/1] X86: Probe for PIC and set legacy_pic
 appropriately
References: <1397282200-10143-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1397282200-10143-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12.04.14 at 07:56, <kys@microsoft.com> wrote:
> --- a/arch/x86/kernel/i8259.c
> +++ b/arch/x86/kernel/i8259.c
> @@ -299,11 +299,30 @@ static void unmask_8259A(void)
>  static void init_8259A(int auto_eoi)
>  {
>  	unsigned long flags;
> +	unsigned char probe_val = ~(1 << PIC_CASCADE_IR);
> +	unsigned char new_val;
>  
>  	i8259A_auto_eoi = auto_eoi;
>  
>  	raw_spin_lock_irqsave(&i8259A_lock, flags);
>  
> +	/*
> +	 * Check to see if we have a PIC.
> +	 * Mask all except the cascade and read
> +	 * back the value we just wrote. If we don't
> +	 * have a PIC, we will read 0xff as opposed to the
> +	 * value we wrote.
> +	 */
> +	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
> +	outb(probe_val, PIC_MASTER_IMR);
> +	new_val = inb(PIC_MASTER_IMR);
> +	if (probe_val != new_val) {
> +		printk(KERN_INFO "Using NULL legacy PIC\n");
> +		legacy_pic = &null_legacy_pic;
> +		raw_spin_unlock_irqrestore(&i8259A_lock, flags);
> +		return;
> +	}
> +
>  	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
>  	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */

And I guess you should delete this last line now that this is already
being done slightly earlier - having it done twice is possibly going to
confuse future readers (in that they might ask themselves or others
whether this really needs to be done twice).

Jan

