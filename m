Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbaBBGBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 01:01:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39732 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaBBGBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 01:01:23 -0500
Date: Sat, 1 Feb 2014 22:00:55 -0800
From: tip-bot for Petr Tesarik <tipbot@zytor.com>
Message-ID: <tip-170750c108bb9382f32a2a99d097aa07d551a89e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ptesarik@suse.cz, tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, ptesarik@suse.cz, rientjes@google.com
In-Reply-To: <20140201133019.32e56f86@hananiah.suse.cz>
References: <20140201133019.32e56f86@hananiah.suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix the initialization of physnode_map
Git-Commit-ID: 170750c108bb9382f32a2a99d097aa07d551a89e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 01 Feb 2014 22:01:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  170750c108bb9382f32a2a99d097aa07d551a89e
Gitweb:     http://git.kernel.org/tip/170750c108bb9382f32a2a99d097aa07d551a89e
Author:     Petr Tesarik <ptesarik@suse.cz>
AuthorDate: Sat, 1 Feb 2014 13:30:19 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 1 Feb 2014 21:57:48 -0800

x86: Fix the initialization of physnode_map

With DISCONTIGMEM, the mapping between a pfn and its owning node is
initialized using data provided by the BIOS. However, the initialization
may fail if the extents are not aligned to section boundary (64M).

The symptom of this bug is an early boot failure in pfn_to_page(),
as it tries to access NODE_DATA(__nid) using index from an unitialized
element of the physnode_map[] array.

While the bug is always present, it is more likely to be hit in kdump
kernels on large machines, because:

1. The memory map for a kdump kernel is specified as exactmap, and
   exactmap is more likely to be unaligned.

2. Large reservations are more likely to span across a 64M boundary.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
Link: http://lkml.kernel.org/r/20140201133019.32e56f86@hananiah.suse.cz
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 0342d27..8c62ec6 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -52,6 +52,8 @@ void memory_present(int nid, unsigned long start, unsigned long end)
 			nid, start, end);
 	printk(KERN_DEBUG "  Setting physnode_map array to node %d for pfns:\n", nid);
 	printk(KERN_DEBUG "  ");
+	pfn = round_down(pfn, PAGES_PER_SECTION);
+	end = round_up(end, PAGES_PER_SECTION);
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
 		physnode_map[pfn / PAGES_PER_SECTION] = nid;
 		printk(KERN_CONT "%lx ", pfn);
