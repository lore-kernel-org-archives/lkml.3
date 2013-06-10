Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3FJUny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:43:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:58393 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3FJUnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:43:52 -0400
Date: Mon, 10 Jun 2013 22:43:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 17/27] genirq: Bail out early in free_desc()
In-Reply-To: <1370644273-10495-18-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.02.1306102216290.22970@ionos>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org> <1370644273-10495-18-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jun 2013, Yinghai Lu wrote:

> We pre-reserve irq range for hot-added ioapic, and later only
> some are used via realloc.
> So during hot-remove, we need to clear bits in allocated_irqs
> for both case.
> 
> Check if the irq_desc is there at first, and bail out early if
> irq_desc is not allocated yet.
> We can use irq_free_descs to clear allocated_irqs bits for
> preserved irqs only.

This changelog is a nightmare as usual. 

It has nothing to do with pre reservation and hot-added ioapics. This
is generic code and does not care at all about x86 specific crappola.

Your change is adding a generic sanity check into free_desc().

So first of all the patch subject is bogus:

   genirq: Bail out early in free_desc()

That's missing _WHY_ it bails out early.

And then the changelog itself drivels about completely irrelevant
nonsense instead of explaining the change itself.

So what I want to see here is something like this:

"genirq: Do not free unallocated irq descriptors

 Hot-added interrupt controllers can reserve a range of interrupt
 numbers, but only allocate some of them. To simplify the release on
 hot-remove allow them to iterate over the reserved range and let the
 free_desc() code return early when the descriptor does not exist."

Can you see the difference?

I told you more than once, that I'm not accepting your sloppy crap
anymore. I'm simply not buying your claim that you think "chinese"
when writing "english". You are simply too lazy to give a rats ass
about it. That applies to your code and to your changelogs in the same
way.
 
I'm really tired of dealing with shit like this.

No thanks

   tglx

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  kernel/irq/irqdesc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
> index b48f65b..32f099e 100644
> --- a/kernel/irq/irqdesc.c
> +++ b/kernel/irq/irqdesc.c
> @@ -170,6 +170,9 @@ static void free_desc(unsigned int irq)
>  {
>  	struct irq_desc *desc = irq_to_desc(irq);
>  
> +	if (!desc)
> +		return;
> +
>  	unregister_irq_proc(irq, desc);
>  
>  	mutex_lock(&sparse_irq_lock);
> -- 
> 1.8.1.4
> 
> 
