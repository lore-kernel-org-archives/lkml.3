Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab3BUHai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 02:30:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63719 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab3BUHag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 02:30:36 -0500
Message-ID: <5125CD12.2080002@steinhoff.de>
Date: Thu, 21 Feb 2013 08:30:26 +0100
From: Armin Steinhoff <armin@steinhoff.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>, x86@kernel.org
Subject: Re: io_apic.c --> "nr_ioapics" not initialized !
References: <20130219035623.277664914@goodmis.org> <20130219035646.405150342@goodmis.org> <5124F7BA.5080905@steinhoff.de> <alpine.LFD.2.02.1302202336270.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1302202336270.22263@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:WYItGx7H8fsdgN+3w2QCCWCgnRcOF94+NxLyOP2uZD9
 UUVP3JRIQq1hPU/bkmnFl53+V2vPR9/MVQH55Vd4MKB5GdfQaB
 EpYJ0vFKcBfg/5wQoPwcXMEn8XK9ZTwiE9NCSWCwBF/euxCZck
 pBrFbgtNOh8mDZI3xrXdZcsLfK0qp99GBceYCfWKpojsb+168A
 MDm+eZY3/8zM3Jlth+M2TI3bEH8+S7aC1qLdGDupnyOVX2Htaw
 Yz6yBfMvGQsV0WijX/ituO/jFAstblCA5Zb1eqp31LZj9vqo20
 GXwZDHyaxMFJKOoYuoFgv97hYlInmXLtEhPheQFUzISFvmy9UX
 lz/WfTWNvXp5dEpgQ4Z4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 20 Feb 2013, Armin Steinhoff wrote:
>> after a walk through the module "io_apic.c" in
>> "/usr/src/linux/arch/x86/kernel/apic" I got the impression that the variable
>> "nr_ioapics" is used but isn't initialized !
>> Could it be the source of boot problems ?
> Well no, unless your compiler is silly.
>   
> arch/x86/kernel/apic/io_apic.c:int nr_ioapics;
>
> That's initialized to 0

  My "silly compiler" does it only during load time ....

--Armin

>
>> Dangerous coding stile in "static struct resource * __init
>> ioapic_setup_resources(int nr_ioapics)" ....
> Though the brilliant brain who decided to name the argument of
> ioapic_setup_resources() the same as a global variable and of course
> the call site of it to do:
>
>      ioapic_res = ioapic_setup_resources(nr_ioapics);
>
> Brilliant. Unfortunately that's completely correct C code. Though it's
> confusing as hell and definitely worth to be fixed. Patch below.
>
> Thanks,
>
> 	tglx
>
> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
> @@ -3637,25 +3637,25 @@ void __init setup_ioapic_dest(void)
>   
>   static struct resource *ioapic_resources;
>   
> -static struct resource * __init ioapic_setup_resources(int nr_ioapics)
> +static struct resource * __init ioapic_setup_resources(int cnt)
>   {
>   	unsigned long n;
>   	struct resource *res;
>   	char *mem;
>   	int i;
>   
> -	if (nr_ioapics <= 0)
> +	if (cnt <= 0)
>   		return NULL;
>   
>   	n = IOAPIC_RESOURCE_NAME_SIZE + sizeof(struct resource);
> -	n *= nr_ioapics;
> +	n *= cnt;
>   
>   	mem = alloc_bootmem(n);
>   	res = (void *)mem;
>   
> -	mem += sizeof(struct resource) * nr_ioapics;
> +	mem += sizeof(struct resource) * cnt;
>   
> -	for (i = 0; i < nr_ioapics; i++) {
> +	for (i = 0; i < cnt; i++) {
>   		res[i].name = mem;
>   		res[i].flags = IORESOURCE_MEM | IORESOURCE_BUSY;
>   		snprintf(mem, IOAPIC_RESOURCE_NAME_SIZE, "IOAPIC %u", i);
>

