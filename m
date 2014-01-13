Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaAMQle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:41:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53253 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaAMQDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve Capper <steve.capper@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 093/208] ARM: 7923/1: mm: fix dcache flush logic for compound high pages
Date: Mon, 13 Jan 2014 15:58:54 +0000
Message-Id: <1389628849-1614-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mm/flush.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 6d5ba9a..3387e60 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -175,16 +175,16 @@ void __flush_dcache_page(struct address_space *mapping, struct page *page)
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
-- 
1.8.3.2

