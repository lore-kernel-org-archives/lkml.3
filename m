Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaBRXOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:14:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbaBRWqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kyle McMartin <kyle@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.12 10/32] arm64: vdso: prevent ld from aligning PT_LOAD segments to 64k
Date: Tue, 18 Feb 2014 14:47:10 -0800
Message-Id: <20140218224500.397635540@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224500.101465031@linuxfoundation.org>
References: <20140218224500.101465031@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/vdso/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -48,7 +48,7 @@ $(obj-vdso): %.o: %.S
 
 # Actual build commands
 quiet_cmd_vdsold = VDSOL $@
-      cmd_vdsold = $(CC) $(c_flags) -Wl,-T $^ -o $@
+      cmd_vdsold = $(CC) $(c_flags) -Wl,-n -Wl,-T $^ -o $@
 quiet_cmd_vdsoas = VDSOA $@
       cmd_vdsoas = $(CC) $(a_flags) -c -o $@ $<
 


