Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab3ENGvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 02:51:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:38811 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab3ENGvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 02:51:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,668,1363104000"; 
   d="scan'208";a="7263828"
Message-ID: <5191DE5A.3020302@cn.fujitsu.com>
Date: Tue, 14 May 2013 14:48:58 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v2] x86, 64bit: Fix a possible wraparound bug in switchover
 in head_64.S
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 14:50:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 14:50:09,
	Serialize complete at 2013/05/14 14:50:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@vger.kernel.org
---
-v2: make the change simpler and avoid using jmp
---
 arch/x86/kernel/head_64.S |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

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
-- 
1.7.1
