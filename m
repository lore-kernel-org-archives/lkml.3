Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763431Ab3DCKQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 06:16:40 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52821 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760695Ab3DCKQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 06:16:37 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v6 2/3] staging: zcache: introduce zero-filled page stat count
Date: Wed,  3 Apr 2013 18:16:22 +0800
Message-Id: <1364984183-9711-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1364984183-9711-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1364984183-9711-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040310-4790-0000-0000-000007AEECF7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce zero-filled page statistics to monitor the number of
zero-filled pages.

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/debug.c       |    3 +++
 drivers/staging/zcache/debug.h       |   17 +++++++++++++++++
 drivers/staging/zcache/zcache-main.c |    4 ++++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zcache/debug.c b/drivers/staging/zcache/debug.c
index faab2a9..daa2691 100644
--- a/drivers/staging/zcache/debug.c
+++ b/drivers/staging/zcache/debug.c
@@ -35,6 +35,8 @@ ssize_t zcache_pers_ate_eph;
 ssize_t zcache_pers_ate_eph_failed;
 ssize_t zcache_evicted_eph_zpages;
 ssize_t zcache_evicted_eph_pageframes;
+ssize_t zcache_zero_filled_pages;
+ssize_t zcache_zero_filled_pages_max;
 
 #define ATTR(x)  { .name = #x, .val = &zcache_##x, }
 static struct debug_entry {
@@ -62,6 +64,7 @@ static struct debug_entry {
 	ATTR(last_inactive_anon_pageframes),
 	ATTR(eph_nonactive_puts_ignored),
 	ATTR(pers_nonactive_puts_ignored),
+	ATTR(zero_filled_pages),
 #ifdef CONFIG_ZCACHE_WRITEBACK
 	ATTR(outstanding_writeback_pages),
 	ATTR(writtenback_pages),
diff --git a/drivers/staging/zcache/debug.h b/drivers/staging/zcache/debug.h
index 8ec82d4..ddad92f 100644
--- a/drivers/staging/zcache/debug.h
+++ b/drivers/staging/zcache/debug.h
@@ -122,6 +122,21 @@ static inline void dec_zcache_pers_zpages(unsigned zpages)
 	zcache_pers_zpages = atomic_sub_return(zpages, &zcache_pers_zpages_atomic);
 }
 
+extern ssize_t zcache_zero_filled_pages;
+static atomic_t zcache_zero_filled_pages_atomic = ATOMIC_INIT(0);
+extern ssize_t zcache_zero_filled_pages_max;
+static inline void inc_zcache_zero_filled_pages(void)
+{
+	zcache_zero_filled_pages = atomic_inc_return(
+					&zcache_zero_filled_pages_atomic);
+	if (zcache_zero_filled_pages > zcache_zero_filled_pages_max)
+		zcache_zero_filled_pages_max = zcache_zero_filled_pages;
+}
+static inline void dec_zcache_zero_filled_pages(void)
+{
+	zcache_zero_filled_pages = atomic_dec_return(
+					&zcache_zero_filled_pages_atomic);
+}
 static inline unsigned long curr_pageframes_count(void)
 {
 	return zcache_pageframes_alloced -
@@ -200,6 +215,8 @@ static inline void inc_zcache_eph_zpages(void) { };
 static inline void dec_zcache_eph_zpages(unsigned zpages) { };
 static inline void inc_zcache_pers_zpages(void) { };
 static inline void dec_zcache_pers_zpages(unsigned zpages) { };
+static inline void inc_zcache_zero_filled_pages(void) { };
+static inline void dec_zcache_zero_filled_pages(void) { };
 static inline unsigned long curr_pageframes_count(void)
 {
 	return 0;
diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 1994cab..f3de76d 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -374,6 +374,7 @@ static void *zcache_pampd_eph_create(char *data, size_t size, bool raw,
 	if (page_is_zero_filled(page)) {
 		clen = 0;
 		zero_filled = true;
+		inc_zcache_zero_filled_pages();
 		goto got_pampd;
 	}
 
@@ -440,6 +441,7 @@ static void *zcache_pampd_pers_create(char *data, size_t size, bool raw,
 	if (page_is_zero_filled(page)) {
 		clen = 0;
 		zero_filled = true;
+		inc_zcache_zero_filled_pages();
 		goto got_pampd;
 	}
 
@@ -652,6 +654,7 @@ static int zcache_pampd_get_data_and_free(char *data, size_t *sizep, bool raw,
 		zpages = 1;
 		if (!raw)
 			*sizep = PAGE_SIZE;
+		dec_zcache_zero_filled_pages();
 		goto zero_fill;
 	}
 
@@ -702,6 +705,7 @@ static void zcache_pampd_free(void *pampd, struct tmem_pool *pool,
 		zero_filled = true;
 		zsize = 0;
 		zpages = 1;
+		dec_zcache_zero_filled_pages();
 	}
 
 	if (pampd_is_remote(pampd) && !zero_filled) {
-- 
1.7.5.4

