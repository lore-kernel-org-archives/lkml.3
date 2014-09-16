Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbaIPBrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:47:13 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:4322 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854AbaIPBrM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:47:12 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jiang Liu <jiang.liu@huawei.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 16 Sep 2014 09:44:15 +0800
Subject: [PATCH v2] arm:extend __init_end to a page align address
Thread-Topic: [PATCH v2] arm:extend __init_end to a page align address
Thread-Index: Ac/RT7llVenLLwtMQVWZZrJ0eagO8Q==
Message-ID: <35FD53F367049845BC99AC72306C23D103D6DB49160B@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch change the __init_end address to a
page align address, so that free_initmem() can
free the whole .init section, because if the end
address is not page aligned, it will round down to
a page align address, then the tail unligned page
will not be freed.

Signed-off-by: wang <yalin.wang2010@gmail.com>
---
 arch/arm/kernel/vmlinux.lds.S     | 2 +-
 arch/arm64/kernel/vmlinux.lds.S   | 2 +-
 include/asm-generic/vmlinux.lds.h | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 6f57cb9..8e95aa4 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -219,8 +219,8 @@ SECTIONS
 	__data_loc = ALIGN(4);		/* location in binary */
 	. = PAGE_OFFSET + TEXT_OFFSET;
 #else
-	__init_end = .;
 	. = ALIGN(THREAD_SIZE);
+	__init_end = .;
 	__data_loc = .;
 #endif
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 97f0c04..edf8715 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -97,9 +97,9 @@ SECTIONS
 
 	PERCPU_SECTION(64)
 
+	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 
-	. = ALIGN(PAGE_SIZE);
 	_data = .;
 	_sdata = .;
 	RW_DATA_SECTION(64, PAGE_SIZE, THREAD_SIZE)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 5ba0360..aa70cbd 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -40,6 +40,8 @@
  * }
  *
  * [__init_begin, __init_end] is the init section that may be freed after init
+ * 	// __init_begin and __init_end should be page aligned, so that we can
+ *	// free the whole .init memory
  * [_stext, _etext] is the text section
  * [_sdata, _edata] is the data section
  *
-- 
2.1.0
