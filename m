Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3FGUnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 16:43:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:48523 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab3FGUnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 16:43:01 -0400
Date: Fri, 7 Jun 2013 22:42:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
cc: Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, guohanjun@huawei.com
Subject: Re: [PATCH 0/7] irq: fix checkpatch errors and warnings 
In-Reply-To: <1370517631-8684-1-git-send-email-wangkefeng.wang@huawei.com>
Message-ID: <alpine.LFD.2.02.1306072208420.24812@ionos>
References: <1370517631-8684-1-git-send-email-wangkefeng.wang@huawei.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jun 2013, Kefeng Wang wrote:

> Fix all the checkpath errors in kernel/irq dir, and some warnings
> also fixed.

Sorry, I'm not really interested in this kind of patches. To be
honest, it would be way more exciting if you had taught checkpatch to
actually fix the missing space after the comma.

Aside of that your mechanical fixups are mostly making the code worse
to read. Just a few examples:

--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -56,7 +56,8 @@ EXPORT_SYMBOL(irq_set_chip);
 int irq_set_irq_type(unsigned int irq, unsigned int type)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags,
+					IRQ_GET_DESC_CHECK_GLOBAL);

This is horrible to parse. If we enforce the 80 character limit here
at all, which I doubt it has a value for this particular case, then
please adhere to the coding style used in this file and make it 

	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags,
						     IRQ_GET_DESC_CHECK_GLOBAL);

Aligning the first arguments of the first and the second line makes it
way simpler to read.

Aside of that, there is no real value to make changes like this:

--- linux-2.6.orig/kernel/irq/irqdomain.c
+++ linux-2.6/kernel/irq/irqdomain.c
@@ -419,7 +419,7 @@ static void irq_domain_disassociate_many
 		irq_data->hwirq = 0;
 
 		/* Clear reverse map */
-		switch(domain->revmap_type) {
+		switch (domain->revmap_type) {

And this:

--- linux-2.6.orig/kernel/irq/proc.c
+++ linux-2.6/kernel/irq/proc.c
@@ -276,7 +276,7 @@ static int name_unique(unsigned int irq,
 	int ret = 1;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	for (action = desc->action ; action; action = action->next) {
+	for (action = desc->action; action; action = action->next) {

Now there is another category:

@@ -47,7 +47,7 @@ static void warn_no_thread(unsigned int 
 	if (test_and_set_bit(IRQTF_WARNED, &action->thread_flags))
 		return;
 
-	printk(KERN_WARNING "IRQ %d device %s returned IRQ_WAKE_THREAD "
+	pr_warn("IRQ %d device %s returned IRQ_WAKE_THREAD "
 	       "but no thread function available.", irq, action->name);

The checkpatch warning is to prevent new code to use the old style
printk format, but it's not intended to force that on existing code.

We can write a coccinelle script to fix such issues in one go all over
the kernel source tree. Though I doubt that it has much value.

It does not make the source better. It does not fix any bugs. It's
just pointless entries in the changelogs

Please sit down and read and understand the code and try to find real
issues which cannot be detected and solved by scripts and
tools. That's what's kernel hacking is about. You are not becoming a
kernel developer by running tools and blindly fixing the complaints of
the tools. You have to understand the code and you have to learn to
judge the output of tools.

Thanks,

	tglx
