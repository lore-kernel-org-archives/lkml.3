Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab3CGE3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:29:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50071 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab3CGE3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:29:22 -0500
Date: Wed, 6 Mar 2013 20:28:07 -0800
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-98e7a989979b185f49e86ddaed2ad6890299d9f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, rydberg@euromail.se
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, rydberg@euromail.se
In-Reply-To: <CAE9FiQX4nQ7_1kg5RL_vh56rmcSHXUi1ExrZX7CwED4NGMnHfg@mail.gmail.com>
References: <CAE9FiQX4nQ7_1kg5RL_vh56rmcSHXUi1ExrZX7CwED4NGMnHfg@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mm:
  Make sure to find a 2M free block for the first mapped area
Git-Commit-ID: 98e7a989979b185f49e86ddaed2ad6890299d9f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 20:28:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98e7a989979b185f49e86ddaed2ad6890299d9f0
Gitweb:     http://git.kernel.org/tip/98e7a989979b185f49e86ddaed2ad6890299d9f0
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 6 Mar 2013 20:18:21 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Mar 2013 20:18:32 -0800

x86, mm: Make sure to find a 2M free block for the first mapped area

Henrik reported that his MacAir 3.1 would not boot with

| commit 8d57470d8f859635deffe3919d7d4867b488b85a
| Date:   Fri Nov 16 19:38:58 2012 -0800
|
|    x86, mm: setup page table in top-down

It turns out that we do not calculate the real_end properly:
We try to get 2M size with 4K alignment, and later will round down
to 2M, so we will get less then 2M for first mapping, in extreme
case could be only 4K only. In Henrik's system it has (1M-32K) as
last usable rage is [mem 0x7f9db000-0x7fef8fff].

The problem is exposed when EFI booting have several holes and it
will force mapping to use PTE instead as we only map usable areas.

To fix it, just make it be 2M aligned, so we can be guaranteed to be
able to use large pages to map it.

Reported-by: Henrik Rydberg <rydberg@euromail.se>
Bisected-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/CAE9FiQX4nQ7_1kg5RL_vh56rmcSHXUi1ExrZX7CwED4NGMnHfg@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 4903a03..59b7fc4 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -410,9 +410,8 @@ void __init init_mem_mapping(void)
 	/* the ISA range is always mapped regardless of memory holes */
 	init_memory_mapping(0, ISA_END_ADDRESS);
 
-	/* xen has big range in reserved near end of ram, skip it at first */
-	addr = memblock_find_in_range(ISA_END_ADDRESS, end, PMD_SIZE,
-			 PAGE_SIZE);
+	/* xen has big range in reserved near end of ram, skip it at first.*/
+	addr = memblock_find_in_range(ISA_END_ADDRESS, end, PMD_SIZE, PMD_SIZE);
 	real_end = addr + PMD_SIZE;
 
 	/* step_size need to be small so pgt_buf from BRK could cover it */
