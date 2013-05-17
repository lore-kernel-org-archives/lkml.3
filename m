Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab3EQTMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 15:12:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab3EQTMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 15:12:53 -0400
Date: Fri, 17 May 2013 12:12:25 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-fbe06b7bae7c9cf6ab05168fce5ee93b2f4bae7c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        christian.koenig@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        christian.koenig@amd.com
In-Reply-To: <CAE9FiQVofGoSk7q5-0irjkBxemqK729cND4hov-1QCBJDhxpgQ@mail.gmail.com>
References: <CAE9FiQVofGoSk7q5-0irjkBxemqK729cND4hov-1QCBJDhxpgQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, range: fix missing merge during add range
Git-Commit-ID: fbe06b7bae7c9cf6ab05168fce5ee93b2f4bae7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fbe06b7bae7c9cf6ab05168fce5ee93b2f4bae7c
Gitweb:     http://git.kernel.org/tip/fbe06b7bae7c9cf6ab05168fce5ee93b2f4bae7c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 17 May 2013 11:49:10 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 17 May 2013 11:49:10 -0700

x86, range: fix missing merge during add range

Christian found v3.9 does not work with E350 with EFI is enabled.

[    1.658832] Trying to unpack rootfs image as initramfs...
[    1.679935] BUG: unable to handle kernel paging request at ffff88006e3fd000
[    1.686940] IP: [<ffffffff813661df>] memset+0x1f/0xb0
[    1.692010] PGD 1f77067 PUD 1f7a067 PMD 61420067 PTE 0

but early memtest report all memory could be accessed without problem.

early page table is set in following sequence:
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x6e600000-0x6e7fffff]
[    0.000000] init_memory_mapping: [mem 0x6c000000-0x6e5fffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0x6bffffff]
[    0.000000] init_memory_mapping: [mem 0x6e800000-0x6ea07fff]
but later efi_enter_virtual_mode try set mapping again wrongly.
[    0.010644] pid_max: default: 32768 minimum: 301
[    0.015302] init_memory_mapping: [mem 0x640c5000-0x6e3fcfff]
that means it fails with pfn_range_is_mapped.

It turns out that we have a bug in add_range_with_merge and it does not
merge range properly when new add one fill the hole between two exsiting
ranges. In the case when [mem 0x00100000-0x6bffffff] is the hole between
[mem 0x00000000-0x000fffff] and [mem 0x6c000000-0x6e7fffff].

Fix the add_range_with_merge by calling itself recursively.

Reported-by: "Christian König" <christian.koenig@amd.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/CAE9FiQVofGoSk7q5-0irjkBxemqK729cND4hov-1QCBJDhxpgQ@mail.gmail.com
Cc: <stable@vger.kernel.org> v3.9
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/range.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/range.c b/kernel/range.c
index 071b0ab..eb911db 100644
--- a/kernel/range.c
+++ b/kernel/range.c
@@ -48,9 +48,11 @@ int add_range_with_merge(struct range *range, int az, int nr_range,
 		final_start = min(range[i].start, start);
 		final_end = max(range[i].end, end);
 
-		range[i].start = final_start;
-		range[i].end =  final_end;
-		return nr_range;
+		/* clear it and add it back for further merge */
+		range[i].start = 0;
+		range[i].end =  0;
+		return add_range_with_merge(range, az, nr_range,
+			final_start, final_end);
 	}
 
 	/* Need to add it: */
