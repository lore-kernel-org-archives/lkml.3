Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab3ETSXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:23:12 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:50714 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3ETSXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:23:10 -0400
Date: Mon, 20 May 2013 20:23:06 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        the arch/x86 maintainers <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "x86-64, init: Do not set NX bits on non-NX
 capable hardware"
Message-ID: <20130520182306.GA5348@dhcp22.suse.cz>
References: <20130514160108.GA5055@dhcp22.suse.cz>
 <1369062192-7066-1-git-send-email-mhocko@suse.cz>
 <519A483F.7070400@zytor.com>
 <20130520164335.GA9441@dhcp22.suse.cz>
 <CA+55aFzxdGOW=7-x+41U4SZB5par7jKU9vuuhFdsQfZOuLiLtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzxdGOW=7-x+41U4SZB5par7jKU9vuuhFdsQfZOuLiLtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 20-05-13 10:21:09, Linus Torvalds wrote:
> On Mon, May 20, 2013 at 9:43 AM, Michal Hocko <mhocko@suse.cz> wrote:
> >
> > The configuration has been posted in the referenced thread:
> > https://lkml.org/lkml/2013/5/14/398
> 
> Hmm. That's a regular intel i5 Sandybridge CPU. Which certainly has NX.
> 
> Hmm. secondary_startup_64 isn't __initcode, is it? I think it's used
> for resuming the other CPU's too and for CPU hotplug. Yes/no?
> 
> If so early_pmd_flags shouldn't be __initdata, I think.
> 
> Michal, does it work if you don't do the revert, but just remove the
> __initdata instead?

Right you are! The following patch on top of your tree fixes the
problem. Thanks a lot. I will leave the proper changelog to somebody who
is more familiar with the area but AFAIU the real problem is that
early_pmd_flags is no longer available beacause the section is gone.

Anyway, feel free to add my 
Tested-by: Michal Hocko <mhocko@suse.cz>
and mark it for 3.9 stable tree
---
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index dab95a8..55b6761 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -34,7 +34,7 @@
 extern pgd_t early_level4_pgt[PTRS_PER_PGD];
 extern pmd_t early_dynamic_pgts[EARLY_DYNAMIC_PAGE_TABLES][PTRS_PER_PMD];
 static unsigned int __initdata next_early_pgt = 2;
-pmdval_t __initdata early_pmd_flags = __PAGE_KERNEL_LARGE & ~(_PAGE_GLOBAL | _PAGE_NX);
+pmdval_t early_pmd_flags = __PAGE_KERNEL_LARGE & ~(_PAGE_GLOBAL | _PAGE_NX);
 
 /* Wipe all early page tables except for the kernel symbol map */
 static void __init reset_early_page_tables(void)
-- 
Michal Hocko
SUSE Labs
