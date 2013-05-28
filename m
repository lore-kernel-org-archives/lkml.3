Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993Ab3E1XCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:02:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55519 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389Ab3E1XCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:02:38 -0400
Date: Tue, 28 May 2013 16:02:17 -0700
From: tip-bot for Zhang Yanfei <tipbot@zytor.com>
Message-ID: <tip-e9d0626ed43a41a3fc526d1df06122b0d4eac174@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, zhangyanfei@cn.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, zhangyanfei@cn.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <5191DE5A.3020302@cn.fujitsu.com>
References: <5191DE5A.3020302@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64, init:
  Fix a possible wraparound bug in switchover in head_64.S
Git-Commit-ID: e9d0626ed43a41a3fc526d1df06122b0d4eac174
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

Commit-ID:  e9d0626ed43a41a3fc526d1df06122b0d4eac174
Gitweb:     http://git.kernel.org/tip/e9d0626ed43a41a3fc526d1df06122b0d4eac174
Author:     Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
AuthorDate: Tue, 14 May 2013 14:48:58 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 28 May 2013 15:41:59 -0700

x86-64, init: Fix a possible wraparound bug in switchover in head_64.S

In head_64.S, a switchover has been used to handle kernel crossing
1G, 512G boundaries.

And commit 8170e6bed465b4b0c7687f93e9948aca4358a33b
    x86, 64bit: Use a #PF handler to materialize early mappings on demand
said:
    During the switchover in head_64.S, before #PF handler is available,
    we use three pages to handle kernel crossing 1G, 512G boundaries with
    sharing page by playing games with page aliasing: the same page is
    mapped twice in the higher-level tables with appropriate wraparound.

But from the switchover code, when we set up the PUD table:
114         addq    $4096, %rdx
115         movq    %rdi, %rax
116         shrq    $PUD_SHIFT, %rax
117         andl    $(PTRS_PER_PUD-1), %eax
118         movq    %rdx, (4096+0)(%rbx,%rax,8)
119         movq    %rdx, (4096+8)(%rbx,%rax,8)

It seems line 119 has a potential bug there. For example,
if the kernel is loaded at physical address 511G+1008M, that is
    000000000 111111111 111111000 000000000000000000000
and the kernel _end is 512G+2M, that is
    000000001 000000000 000000001 000000000000000000000
So in this example, when using the 2nd page to setup PUD (line 114~119),
rax is 511.
In line 118, we put rdx which is the address of the PMD page (the 3rd page)
into entry 511 of the PUD table. But in line 119, the entry we calculate from
(4096+8)(%rbx,%rax,8) has exceeded the PUD page. IMO, the entry in line
119 should be wraparound into entry 0 of the PUD table.

The patch fixes the bug.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/5191DE5A.3020302@cn.fujitsu.com
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: <stable@vger.kernel.org> v3.9
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head_64.S | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 08f7e80..321d65e 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -115,8 +115,10 @@ startup_64:
 	movq	%rdi, %rax
 	shrq	$PUD_SHIFT, %rax
 	andl	$(PTRS_PER_PUD-1), %eax
-	movq	%rdx, (4096+0)(%rbx,%rax,8)
-	movq	%rdx, (4096+8)(%rbx,%rax,8)
+	movq	%rdx, 4096(%rbx,%rax,8)
+	incl	%eax
+	andl	$(PTRS_PER_PUD-1), %eax
+	movq	%rdx, 4096(%rbx,%rax,8)
 
 	addq	$8192, %rbx
 	movq	%rdi, %rax
