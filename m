Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab3GDBxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 21:53:11 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:26766 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933419Ab3GDBwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 21:52:54 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH 4/4] dcache: Use rwlock as the underlying lock in rename_lock
Date: Wed,  3 Jul 2013 21:52:18 -0400
Message-Id: <1372902738-30693-5-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1372902738-30693-1-git-send-email-Waiman.Long@hp.com>
References: <1372902738-30693-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the underlying lock in rename_lock from spinlock
to a read/write lock. This allows multiple blocking readers to proceed
concurrently which is not possible with a spinlock implementation.

As contention of the rename_lock in the d_path() function is a
bottleneck when the perf tool is used to record performance data on
a large SMP system with many cores, converting rename_lock to use
read/write lock will eliminate this bottleneck and the skewing of
perf trace data.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/dcache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 480c81f..75299cc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -82,7 +82,7 @@ int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
-__cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
+__cacheline_aligned_in_smp DEFINE_SEQRWLOCK(rename_lock);
 
 EXPORT_SYMBOL(rename_lock);
 
-- 
1.7.1

