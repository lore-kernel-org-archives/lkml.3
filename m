Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3AXUx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:53:26 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:55386 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755885Ab3AXUxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:53:18 -0500
Message-ID: <1359060797.1325.33.camel@x61.thuisdomein>
Subject: [PATCH] Silence warning if CONFIG_LOCKDEP isn't set
From: Paul Bolle <pebolle@tiscali.nl>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 24 Jan 2013 21:53:17 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jan 2013 20:53:16.0999 (UTC) FILETIME=[D593B570:01CDFA74]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit c9a4962881929df7f1ef6e63e1b9da304faca4dd ("nfsd: make
client_lock per net") compiling nfs4state.o without CONFIG_LOCKDEP set,
triggers this GCC warning:
    fs/nfsd/nfs4state.c: In function ‘free_client’:
    fs/nfsd/nfs4state.c:1051:19: warning: unused variable ‘nn’ [-Wunused-variable]

The cause of that warning is that lockdep_assert_held() compiles away if
CONFIG_LOCKDEP is not set. Silence this warning by using the argument to
lockdep_assert_held() as a nop if CONFIG_LOCKDEP is not set.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested only.

1) This patch triggers a checkpatch false positive:
    WARNING: Single statement macros should not use a do {} while (0) loop

2) Review is rather needed here, since I'm not sure what, if any, the
downsides are of this patch for all other "calls" of
lockdep_assert_held(). Besides, a cleaner solution might be to simply
drop lockdep_assert_held() in free_client(). There are only three
callers of that function and it seems obvious that all three do hold
'client_lock'.

 include/linux/lockdep.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 2bca44b..f05631e 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -410,7 +410,7 @@ struct lock_class_key { };
 
 #define lockdep_depth(tsk)	(0)
 
-#define lockdep_assert_held(l)			do { } while (0)
+#define lockdep_assert_held(l)			do { (void)(l); } while (0)
 
 #define lockdep_recursing(tsk)			(0)
 
-- 
1.7.11.7

