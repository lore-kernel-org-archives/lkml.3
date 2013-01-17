Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab3ARDuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:50:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25838 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3ARDuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:50:04 -0500
Date: Thu, 17 Jan 2013 09:41:31 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/4] x86/wakeup/sleep: Check whether the TSS GDT
 descriptor is empty before using it.
Message-ID: <20130117144131.GB2552@phenom.dumpdata.com>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
 <1350481786-4969-2-git-send-email-konrad.wilk@oracle.com>
 <507F473D.1060700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507F473D.1060700@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 05:03:09PM -0700, H. Peter Anvin wrote:
> On 10/17/2012 06:49 AM, Konrad Rzeszutek Wilk wrote:
> >We check the TSS descriptor before we try to dereference it.
> >Also fix up the value to use the #defines.
> >
> >Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >---
> >  arch/x86/power/cpu.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> >
> >diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> >index 218cdb1..c17370e 100644
> >--- a/arch/x86/power/cpu.c
> >+++ b/arch/x86/power/cpu.c
> >@@ -133,7 +133,9 @@ static void fix_processor_context(void)
> >  {
> >  	int cpu = smp_processor_id();
> >  	struct tss_struct *t = &per_cpu(init_tss, cpu);
> >-
> >+#ifdef CONFIG_X86_64
> >+	struct desc_struct *desc = get_cpu_gdt_table(cpu);
> >+#endif
> >  	set_tss_desc(cpu, t);	/*
> >  				 * This just modifies memory; should not be
> >  				 * necessary. But... This is necessary, because
> >@@ -142,7 +144,8 @@ static void fix_processor_context(void)
> >  				 */
> >
> >  #ifdef CONFIG_X86_64
> >-	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
> >+	if (!desc_empty(&desc[GDT_ENTRY_TSS]))
> >+		desc[GDT_ENTRY_TSS].type = DESC_TSS;
> >
> >  	syscall_init();				/* This sets MSR_*STAR and related */
> >  #endif
> >
> 
> Why is this patch necessary?  Presumably there is something further
> down the line which depends on the TSS descriptor being empty, but
> if so, what?

Ah, so at least on Xen, that desc is marked as RO b/c it has been given
to the hypervisor. And the hypervisor adds its own entries. Lastly on
64-bit, the TSS for PV guests is not used - as the PV kernel and user-space
both run in the user-space ring. So there is nothing in that entry.

The issue I stumbled upon was just a page-fault b/c of trying to modify
a RO region. The other way of fixing this (without knowing that the
TSS entry is not set), was to use the functions/macros, as such:


        if (alternative_tss) {
                memcpy(&tss, &desc[GDT_ENTRY_TSS], sizeof(tss_desc));
                tss.type = DESC_TSS;
                write_gdt_entry(desc, GDT_ENTRY_TSS, &tss, DESC_TSS);
        } else {
                if (!desc_empty(&desc[GDT_ENTRY_TSS])) {
                        desc[GDT_ENTRY_TSS].type = DESC_TSS;
                }   
        }   

which works as well and does not throw the person from trying to figure
out why the TSS descriptor is empty (or not).

> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
