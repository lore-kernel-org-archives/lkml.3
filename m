Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab3CGWBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:01:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60562 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759748Ab3CGWBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:01:14 -0500
Date: Thu, 7 Mar 2013 13:59:37 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-60f583d56aa515b896a9d94f860f52640c1e8a75@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dave@linux.vnet.ibm.com, tglx@linutronix.de, dave@sr71.net,
        penguin-kernel@i-love.sakura.ne.jp
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dave@linux.vnet.ibm.com, tglx@linutronix.de, dave@sr71.net,
        penguin-kernel@i-love.sakura.ne.jp
In-Reply-To: <20130307163151.D9B58C4E@kernel.stglabs.ibm.com>
References: <20130307163151.D9B58C4E@kernel.stglabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Do not try to sync identity map for non-mapped pages
Git-Commit-ID: 60f583d56aa515b896a9d94f860f52640c1e8a75
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 07 Mar 2013 13:59:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60f583d56aa515b896a9d94f860f52640c1e8a75
Gitweb:     http://git.kernel.org/tip/60f583d56aa515b896a9d94f860f52640c1e8a75
Author:     Dave Hansen <dave@sr71.net>
AuthorDate: Thu, 7 Mar 2013 08:31:51 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 7 Mar 2013 13:23:28 -0800

x86: Do not try to sync identity map for non-mapped pages

kernel_map_sync_memtype() is called from a variety of contexts.  The
pat.c code that calls it seems to ensure that it is not called for
non-ram areas by checking via pat_pagerange_is_ram().  It is important
that it only be called on the actual identity map because there *IS*
no map to sync for highmem pages, or for memory holes.

The ioremap.c uses are not as careful as those from pat.c, and call
kernel_map_sync_memtype() on PCI space which is in the middle of the
kernel identity map _range_, but is not actually mapped.

This patch adds a check to kernel_map_sync_memtype() which probably
duplicates some of the checks already in pat.c.  But, it is necessary
for the ioremap.c uses and shouldn't hurt other callers.

I have reproduced this bug and this patch fixes it for me and the
original bug reporter:

	https://lkml.org/lkml/2013/2/5/396

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20130307163151.D9B58C4E@kernel.stglabs.ibm.com
Signed-off-by: Dave Hansen <dave@sr71.net>
Tested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/pat.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 2610bd9..6574388 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -563,6 +563,13 @@ int kernel_map_sync_memtype(u64 base, unsigned long size, unsigned long flags)
 	if (base > __pa(high_memory-1))
 		return 0;
 
+	/*
+	 * some areas in the middle of the kernel identity range
+	 * are not mapped, like the PCI space.
+	 */
+	if (!page_is_ram(base >> PAGE_SHIFT))
+		return 0;
+
 	id_sz = (__pa(high_memory-1) <= base + size) ?
 				__pa(high_memory) - base :
 				size;
