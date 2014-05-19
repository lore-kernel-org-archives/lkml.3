Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaESAKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 20:10:15 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39481 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaESAKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 20:10:13 -0400
Message-ID: <1400458109.9630.1.camel@debian>
Subject: Re: [PATCH] x86/mce: Clear a useless global variable in mce.c
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org
Date: Mon, 19 May 2014 08:08:29 +0800
In-Reply-To: <20140517095838.GA23100@pd.tnic>
References: <1400316324-6280-1-git-send-email-slaoub@gmail.com>
	 <20140517095838.GA23100@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-17 at 11:58 +0200, Borislav Petkov wrote:
> On Sat, May 17, 2014 at 04:45:24PM +0800, Chen Yucong wrote:
> > This patch is just used to remove a useless global variable mce_entry
> > and relative operations in mce.c.
> 
> Well, I can see from the diff below what you're saying here but a commit
> message should contain information which explains *why* you're doing the
> change and not *what* you're doing - that we can see.
> 
> IOW, you could instead do some git history research and write in your
> commit message why this mce_entry got unused and quote commits which
> removed it, why they removed it and why we want to remove the remains of
> it now.
> 
> In any case, the change itself is correct, I would like to have a commit
> message which explains why we're removing it.
> 
> Thanks.
> 

The mce_entry, which was defined as a global variable in mce.c, was
used in nmi_watchdog_tick(). But nmi_watchdog_tick() has been discarded 
in the new generic nmi_watchdog implementation - commit 1fb9d6ad2766. 
So, of course, there is no need for the mce_entry.

This patch is just used to remove a useless global variable mce_entry
and relative operations in mce.c.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/include/asm/mce.h       |    2 --
 arch/x86/kernel/cpu/mcheck/mce.c |    5 -----
 2 files changed, 7 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 6e4ce2d..958b90f 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -176,8 +176,6 @@ int mce_available(struct cpuinfo_x86 *c);
 DECLARE_PER_CPU(unsigned, mce_exception_count);
 DECLARE_PER_CPU(unsigned, mce_poll_count);
 
-extern atomic_t mce_entry;
-
 typedef DECLARE_BITMAP(mce_banks_t, MAX_NR_BANKS);
 DECLARE_PER_CPU(mce_banks_t, mce_poll_banks);
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c
b/arch/x86/kernel/cpu/mcheck/mce.c
index 68317c8..8f520a1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -60,8 +60,6 @@ static DEFINE_MUTEX(mce_chrdev_read_mutex);
 
 #define SPINUNIT 100	/* 100ns */
 
-atomic_t mce_entry;
-
 DEFINE_PER_CPU(unsigned, mce_exception_count);
 
 struct mce_bank *mce_banks __read_mostly;
@@ -1041,8 +1039,6 @@ void do_machine_check(struct pt_regs *regs, long
error_code)
 	DECLARE_BITMAP(valid_banks, MAX_NR_BANKS);
 	char *msg = "Unknown";
 
-	atomic_inc(&mce_entry);
-
 	this_cpu_inc(mce_exception_count);
 
 	if (!cfg->banks)
@@ -1172,7 +1168,6 @@ void do_machine_check(struct pt_regs *regs, long
error_code)
 		mce_report_event(regs);
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
 out:
-	atomic_dec(&mce_entry);
 	sync_core();
 }
 EXPORT_SYMBOL_GPL(do_machine_check);
-- 
1.7.10.4

