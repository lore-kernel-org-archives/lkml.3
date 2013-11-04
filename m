Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab3KDQiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:38:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab3KDQiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:38:51 -0500
Message-ID: <1383583127.11574.29.camel@deneb.redhat.com>
Subject: [PATCH] arm64: use generic RW_DATA_SECTION macro in linker script
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 04 Nov 2013 11:38:47 -0500
In-Reply-To: <20131104112840.GC2527@arm.com>
References: <1381264659-11132-1-git-send-email-msalter@redhat.com>
	 <20131009101447.GC5985@mudshark.cambridge.arm.com>
	 <1381493921.8305.63.camel@deneb.redhat.com> <20131104112840.GC2527@arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .data section in the arm64 linker script currently lacks a
definition for page-aligned data. This leads to a .page_aligned
section being placed between the end of data and start of bss.
This patch corrects that by using the generic RW_DATA_SECTION
macro which includes support for page-aligned data.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/kernel/vmlinux.lds.S | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index f8ab9d8..4ff9dcf 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -97,30 +97,13 @@ SECTIONS
 	PERCPU_SECTION(64)
 
 	__init_end = .;
-	. = ALIGN(THREAD_SIZE);
-	__data_loc = .;
-
-	.data : AT(__data_loc) {
-		_data = .;		/* address in memory */
-		_sdata = .;
-
-		/*
-		 * first, the init task union, aligned
-		 * to an 8192 byte boundary.
-		 */
-		INIT_TASK_DATA(THREAD_SIZE)
-		NOSAVE_DATA
-		CACHELINE_ALIGNED_DATA(64)
-		READ_MOSTLY_DATA(64)
-
-		/*
-		 * and the usual data section
-		 */
-		DATA_DATA
-		CONSTRUCTORS
-
-		_edata = .;
-	}
+
+	. = ALIGN(PAGE_SIZE);
+	_data = .;
+	__data_loc = _data - LOAD_OFFSET;
+	_sdata = .;
+	RW_DATA_SECTION(64, PAGE_SIZE, THREAD_SIZE)
+	_edata = .;
 	_edata_loc = __data_loc + SIZEOF(.data);
 
 	BSS_SECTION(0, 0, 0)
-- 
1.8.3.1



