Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaANAjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:39:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaANA2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Capper <steve.capper@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.12 50/77] ARM: 7923/1: mm: fix dcache flush logic for compound high pages
Date: Mon, 13 Jan 2014 16:28:11 -0800
Message-Id: <20140114002753.928774450@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Capper <steve.capper@linaro.org>

commit 2a7cfcbc0553365d75716f69ee7b704cac7c9248 upstream.

When given a compound high page, __flush_dcache_page will only flush
the first page of the compound page repeatedly rather than the entire
set of constituent pages.

This error was introduced by:
   0b19f93 ARM: mm: Add support for flushing HugeTLB pages.

This patch corrects the logic such that all constituent pages are now
flushed.

Signed-off-by: Steve Capper <steve.capper@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/flush.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -175,16 +175,16 @@ void __flush_dcache_page(struct address_
 		unsigned long i;
 		if (cache_is_vipt_nonaliasing()) {
 			for (i = 0; i < (1 << compound_order(page)); i++) {
-				void *addr = kmap_atomic(page);
+				void *addr = kmap_atomic(page + i);
 				__cpuc_flush_dcache_area(addr, PAGE_SIZE);
 				kunmap_atomic(addr);
 			}
 		} else {
 			for (i = 0; i < (1 << compound_order(page)); i++) {
-				void *addr = kmap_high_get(page);
+				void *addr = kmap_high_get(page + i);
 				if (addr) {
 					__cpuc_flush_dcache_area(addr, PAGE_SIZE);
-					kunmap_high(page);
+					kunmap_high(page + i);
 				}
 			}
 		}


