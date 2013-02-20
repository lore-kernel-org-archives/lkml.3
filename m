Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab3BTWzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:55:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:43515 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3BTWzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:55:05 -0500
Date: Wed, 20 Feb 2013 23:55:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Armin Steinhoff <armin@steinhoff.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>, x86@kernel.org
Subject: Re: io_apic.c --> "nr_ioapics" not initialized !
In-Reply-To: <5124F7BA.5080905@steinhoff.de>
Message-ID: <alpine.LFD.2.02.1302202336270.22263@ionos>
References: <20130219035623.277664914@goodmis.org> <20130219035646.405150342@goodmis.org> <5124F7BA.5080905@steinhoff.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, Armin Steinhoff wrote:
> after a walk through the module "io_apic.c" in
> "/usr/src/linux/arch/x86/kernel/apic" I got the impression that the variable
> "nr_ioapics" is used but isn't initialized !
> Could it be the source of boot problems ?

Well no, unless your compiler is silly.
 
arch/x86/kernel/apic/io_apic.c:int nr_ioapics;

That's initialized to 0

> Dangerous coding stile in "static struct resource * __init
> ioapic_setup_resources(int nr_ioapics)" ....

Though the brilliant brain who decided to name the argument of
ioapic_setup_resources() the same as a global variable and of course
the call site of it to do:

    ioapic_res = ioapic_setup_resources(nr_ioapics);

Brilliant. Unfortunately that's completely correct C code. Though it's
confusing as hell and definitely worth to be fixed. Patch below.

Thanks,

	tglx

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3637,25 +3637,25 @@ void __init setup_ioapic_dest(void)
 
 static struct resource *ioapic_resources;
 
-static struct resource * __init ioapic_setup_resources(int nr_ioapics)
+static struct resource * __init ioapic_setup_resources(int cnt)
 {
 	unsigned long n;
 	struct resource *res;
 	char *mem;
 	int i;
 
-	if (nr_ioapics <= 0)
+	if (cnt <= 0)
 		return NULL;
 
 	n = IOAPIC_RESOURCE_NAME_SIZE + sizeof(struct resource);
-	n *= nr_ioapics;
+	n *= cnt;
 
 	mem = alloc_bootmem(n);
 	res = (void *)mem;
 
-	mem += sizeof(struct resource) * nr_ioapics;
+	mem += sizeof(struct resource) * cnt;
 
-	for (i = 0; i < nr_ioapics; i++) {
+	for (i = 0; i < cnt; i++) {
 		res[i].name = mem;
 		res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 		snprintf(mem, IOAPIC_RESOURCE_NAME_SIZE, "IOAPIC %u", i);
