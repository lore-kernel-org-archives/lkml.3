Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaCCTTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:19:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55909 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbaCCS4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:56:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 10/67] arm64: vdso: prevent ld from aligning PT_LOAD segments to 64k
Date: Mon,  3 Mar 2014 10:54:58 -0800
Message-Id: <1393872955-28810-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 40507403485fcb56b83d6ddfc954e9b08305054c upstream.

Whilst the text segment for our VDSO is marked as PT_LOAD in the ELF
headers, it is mapped by the kernel and not actually subject to
demand-paging. ld doesn't realise this, and emits a p_align field of 64k
(the maximum supported page size), which conflicts with the load address
picked by the kernel on 4k systems, which will be 4k aligned. This
causes GDB to fail with "Failed to read a valid object file image from
memory" when attempting to load the VDSO.

This patch passes the -n option to ld, which prevents it from aligning
PT_LOAD segments to the maximum page size.

Reported-by: Kyle McMartin <kyle@redhat.com>
Acked-by: Kyle McMartin <kyle@redhat.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/kernel/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index d8064af..6d20b7d 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -48,7 +48,7 @@ $(obj-vdso): %.o: %.S
 
 # Actual build commands
 quiet_cmd_vdsold = VDSOL $@
-      cmd_vdsold = $(CC) $(c_flags) -Wl,-T $^ -o $@
+      cmd_vdsold = $(CC) $(c_flags) -Wl,-n -Wl,-T $^ -o $@
 quiet_cmd_vdsoas = VDSOA $@
       cmd_vdsoas = $(CC) $(a_flags) -c -o $@ $<
 
-- 
1.8.3.2

