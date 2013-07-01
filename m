Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3GACtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 22:49:36 -0400
Received: from mail1.windriver.com ([147.11.146.13]:64206 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3GACte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 22:49:34 -0400
From: Fan Du <fan.du@windriver.com>
To: <viro@zeniv.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] percpu_counter: __this_cpu_write doesn't need to be protected by spinlock
Date: Mon, 1 Jul 2013 10:48:14 +0800
Message-ID: <1372646894-17884-1-git-send-email-fan.du@windriver.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__this_cpu_write doesn't need to be protected by spinlock, AS we are doing
per cpu write with preempt disabled. And another reason to remove __this_cpu_write
outside of spinlock: __percpu_counter_sum is not a accurate counter.  

Signed-off-by: Fan Du <fan.du@windriver.com>
---
 lib/percpu_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index ba6085d..1fc23a3 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -80,8 +80,8 @@ void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 	if (count >= batch || count <= -batch) {
 		raw_spin_lock(&fbc->lock);
 		fbc->count += count;
-		__this_cpu_write(*fbc->counters, 0);
 		raw_spin_unlock(&fbc->lock);
+		__this_cpu_write(*fbc->counters, 0);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
 	}
-- 
1.7.1

