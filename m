Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab3EMMiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:38:03 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54535 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3EMMiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:38:01 -0400
Message-ID: <5190DEA1.7030901@gmail.com>
Date: Mon, 13 May 2013 20:37:53 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de, mingo@redhat.com
CC: yinghai@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        konrad.wilk@oracle.com
Subject: [PATCH] x86, 64bit: Fix a possible bug in switchover in head_64.S
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

In head_64.S, a switchover has been used to handle kernel crossing
1G, 512G boundaries.

And commit 8170e6bed465b4b0c7687f93e9948aca4358a33b
    x86, 64bit: Use a #PF handler to materialize early mappings on demand
said:
    During the switchover in head_64.S, before #PF handler is available,
    we use three pages to handle kernel crossing 1G, 512G boundaries with
    sharing page by playing games with page aliasing: the same page is
    mapped twice in the higher-level tables with appropriate wraparound.

The switchover code is:
104         leaq    _text(%rip), %rdi
105         leaq    early_level4_pgt(%rip), %rbx
106
107         movq    %rdi, %rax
108         shrq    $PGDIR_SHIFT, %rax
109
110         leaq    (4096 + _KERNPG_TABLE)(%rbx), %rdx
111         movq    %rdx, 0(%rbx,%rax,8)
112         movq    %rdx, 8(%rbx,%rax,8)
113
114         addq    $4096, %rdx
115         movq    %rdi, %rax
116         shrq    $PUD_SHIFT, %rax
117         andl    $(PTRS_PER_PUD-1), %eax
118         movq    %rdx, (4096+0)(%rbx,%rax,8)
119         movq    %rdx, (4096+8)(%rbx,%rax,8)
120
121         addq    $8192, %rbx
122         movq    %rdi, %rax
123         shrq    $PMD_SHIFT, %rdi
124         addq    $(__PAGE_KERNEL_LARGE_EXEC & ~_PAGE_GLOBAL), %rax
125         leaq    (_end - 1)(%rip), %rcx
126         shrq    $PMD_SHIFT, %rcx
127         subq    %rdi, %rcx
128         incl    %ecx
129
130 1:
131         andq    $(PTRS_PER_PMD - 1), %rdi
132         movq    %rax, (%rbx,%rdi,8)
133         incq    %rdi
134         addq    $PMD_SIZE, %rax
135         decl    %ecx
136         jnz     1b

It seems line 119 has a potential bug there. For example,
the kernel is loaded at physical address 511G+1008M, that is
    000000000 111111111 111111000 000000000000000000000
and the kernel _end is 512G+2M, that is
    000000001 000000000 000000001 000000000000000000000
So in this example, when using the 2nd page to setup PUD (line 114~119),
rax is 511.
In line 118, we put rdx which is the address of the PMD page (the 3rd page)
into entry 511 of the PUD table. But in line 119, the entry we calculate from
(4096+8)(%rbx,%rax,8) has exceeded the PUD page. IMO, the entry in line
119 should be wraparound into entry 0 of the PUD table.

Sorry for not having a machine with memory exceeding 512GB, so I cannot
test to see if my guess is right or not. Please correct me if I am wrong.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/kernel/head_64.S |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 08f7e80..2395d8f 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -116,8 +116,13 @@ startup_64:
 	shrq	$PUD_SHIFT, %rax
 	andl	$(PTRS_PER_PUD-1), %eax
 	movq	%rdx, (4096+0)(%rbx,%rax,8)
+	cmp	$511, %rax
+	je	1f
 	movq	%rdx, (4096+8)(%rbx,%rax,8)
-
+	jmp	2f
+1:
+	movq	%rdx, (4096)(%rbx)
+2:
 	addq	$8192, %rbx
 	movq	%rdi, %rax
 	shrq	$PMD_SHIFT, %rdi
-- 
1.7.1
