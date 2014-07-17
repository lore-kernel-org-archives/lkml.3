Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578AbaGQP6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:58:18 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:51657 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaGQP6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:58:16 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-metag@vger.kernel.org
Cc: james.hogan@imgtec.com, dan.carpenter@oracle.com,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] arch/metag/kernel/cachepart.c: fix failure check
Date: Thu, 17 Jul 2014 18:58:06 +0300
Message-Id: <1405612686-3554-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <20140717145811.GI25880@mwanda>
References: <20140717145811.GI25880@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-3.16-rc5/arch/metag/kernel/cachepart.c:102]: (style) Checking if
unsigned variable 'thread_cache_size' is less than zero.

Source code is

        if (thread_cache_size < 0)
            pr_emerg("Can't read %s cache size\n",
                 cache_type ? "DCACHE" : "ICACHE");

but

    unsigned int thread_cache_size;

Function get_thread_cache_size returns an error code
as (unsigned int) -1.

Changed get_thread_cache_size() to return signed int, and its result is stored
into signed int variable.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80361
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 arch/metag/kernel/cachepart.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/metag/kernel/cachepart.c b/arch/metag/kernel/cachepart.c
index 0a2385f..04b7d4f 100644
--- a/arch/metag/kernel/cachepart.c
+++ b/arch/metag/kernel/cachepart.c
@@ -55,7 +55,7 @@ unsigned int get_global_icache_size(void)
 	return (get_icache_size() * ((temp >> SYSC_xCPARTG_AND_S) + 1)) >> 4;
 }
 
-static unsigned int get_thread_cache_size(unsigned int cache, int thread_id)
+static int get_thread_cache_size(unsigned int cache, int thread_id)
 {
 	unsigned int cache_size;
 	unsigned int t_cache_part;
@@ -94,7 +94,7 @@ static unsigned int get_thread_cache_size(unsigned int cache, int thread_id)
 
 void check_for_cache_aliasing(int thread_id)
 {
-	unsigned int thread_cache_size;
+	int thread_cache_size;
 	unsigned int cache_type;
 	for (cache_type = ICACHE; cache_type <= DCACHE; cache_type++) {
 		thread_cache_size =
-- 
1.8.5.5

