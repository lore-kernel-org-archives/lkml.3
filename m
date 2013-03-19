Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab3CSJ0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:26:52 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53796 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab3CSJ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:26:48 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 7/8] staging: zcache: introduce zero-filled page stat count
Date: Tue, 19 Mar 2013 17:25:49 +0800
Message-Id: <1363685150-18303-8-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363685150-18303-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1363685150-18303-1-git-send-email-liwanp@linux.vnet.ibm.com>
x-cbid: 13031909-3568-0000-0000-0000034F3AB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce zero-filled page statistics to monitor the number of
zero-filled pages.

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 drivers/staging/zcache/debug.h       |   15 +++++++++++++++
 drivers/staging/zcache/zcache-main.c |    5 +++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zcache/debug.h b/drivers/staging/zcache/debug.h
index 8ec82d4..178bf75 100644
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
diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index d1118f0..f8ba619 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -176,6 +176,8 @@ ssize_t zcache_pers_ate_eph;
 ssize_t zcache_pers_ate_eph_failed;
 ssize_t zcache_evicted_eph_zpages;
 ssize_t zcache_evicted_eph_pageframes;
+ssize_t zcache_zero_filled_pages;
+ssize_t zcache_zero_filled_pages_max;
 
 /* Used by this code. */
 ssize_t zcache_last_active_file_pageframes;
@@ -404,6 +406,7 @@ static void *zcache_pampd_eph_create(char *data, size_t size, bool raw,
 	if (page_is_zero_filled(page)) {
 		clen = 0;
 		zero_filled = true;
+		inc_zcache_zero_filled_pages();
 		goto got_pampd;
 	}
 
@@ -470,6 +473,7 @@ static void *zcache_pampd_pers_create(char *data, size_t size, bool raw,
 	if (page_is_zero_filled(page)) {
 		clen = 0;
 		zero_filled = true;
+		inc_zcache_zero_filled_pages();
 		goto got_pampd;
 	}
 
@@ -682,6 +686,7 @@ static int zcache_pampd_get_data_and_free(char *data, size_t *sizep, bool raw,
 		zpages = 1;
 		if (!raw)
 			*sizep = PAGE_SIZE;
+		dec_zcache_zero_filled_pages();
 		goto zero_fill;
 	}
 
-- 
1.7.7.6

