Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab3FFP6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:58:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57755 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab3FFP6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:58:38 -0400
Date: Thu, 6 Jun 2013 17:58:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 4/4] x86, efi: Map runtime services 1:1
Message-ID: <20130606155822.GH20972@pd.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-5-git-send-email-bp@alien8.de>
 <20130606131439.GI30420@console-pimps.org>
 <20130606132908.GE20972@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130606132908.GE20972@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 03:29:08PM +0200, Borislav Petkov wrote:
> On Thu, Jun 06, 2013 at 02:14:39PM +0100, Matt Fleming wrote:
> > This patch makes my TunnelMountain machine spin in handle_pte_fault()
> > when triggering one of the "firmware makes references to physical
> > addresses" code paths.
> >
> > I'll try and dig into this tomorrow to figure out what's going on.
> 
> Hmmm, looks like we have forgotten to map an EFI region and we do a #PF
> when executing the EFI code.

How about this one - I don't know whether it would flood dmesg, I guess
you'll have to try.

We could try using blockconsole to catch dmesg to an usb drive, though,
even if you don't have serial or netconsole or such. :-).

--
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 654be4ae3047..7a6129afdff1 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1021,6 +1021,9 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	/* Get the faulting address: */
 	address = read_cr2();
 
+	if (read_cr3() == (unsigned long)real_mode_header->trampoline_pgd)
+		pr_err("%s: #PF addr: 0x%lx\n", __func__, address);
+
 	/*
 	 * Detect and handle instructions that would cause a page fault for
 	 * both a tracked kernel page and a userspace page.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
