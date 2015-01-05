Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbbAEDjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 22:39:41 -0500
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:42484 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752838AbbAEDjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 22:39:40 -0500
From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
To: <akpm@linux-foundation.org>, <ionut.m.alexa@gmail.com>,
        <mark.yang@spreadtrum.com>, <wei.qiao@spreadtrum.com>,
        <geng.ren@spreadtrum.com>
CC: <orson.zhai@spreadtrum.com>, <zhizhou.zhang@spreadtrum.com>,
        <ke.wang@spreadtrum.com>, <zhang.lyra@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: async: Fixed the wrong waitting condition of wait_event
Date: Mon, 5 Jan 2015 11:35:35 +0800
Message-ID: <1420428935-30385-1-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <async>
References: <async>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.0.67.164]
X-ClientProxiedBy: SHCAS02.spreadtrum.com (10.0.1.202) To
 SHMBX02.spreadtrum.com (10.0.1.204)
X-MAIL: SHSQR01.spreadtrum.com t053awR4002764
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yonghui Yang <mark.yang@spreadtrum.com>

This patch changes the waitting condition of wait_event in the
function 'async_synchronize_cookie_domain'.

This function waits until all asynchronous function calls for the certain
domain have been done.

But, the function 'lowest_in_progress' returns the lowest *pending*
entry's cookie.

So we should make sure that the return value of lowest_in_progress(domain)
must be larger than @cookie.

Verified-by: Wei Qiao <wei.qiao@spreadtrum.com>
Signed-off-by: Yonghui Yang <mark.yang@spreadtrum.com>
Signed-off-by: Geng Ren <geng.ren@spreadtrum.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
---
 kernel/async.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 4c3773c..894ae80 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -267,7 +267,7 @@ EXPORT_SYMBOL_GPL(async_unregister_domain);
  */
 void async_synchronize_full_domain(struct async_domain *domain)
 {
-	async_synchronize_cookie_domain(ASYNC_COOKIE_MAX, domain);
+	async_synchronize_cookie_domain(ASYNC_COOKIE_MAX-1, domain);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 
@@ -289,7 +289,7 @@ void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain
 		starttime = ktime_get();
 	}
 
-	wait_event(async_done, lowest_in_progress(domain) >= cookie);
+	wait_event(async_done, lowest_in_progress(domain) > cookie);
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		endtime = ktime_get();
-- 
1.7.9.5

