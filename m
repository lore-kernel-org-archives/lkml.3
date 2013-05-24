Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab3EXOSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:18:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab3EXOSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:18:17 -0400
Date: Fri, 24 May 2013 17:18:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: [PATCH v3 10/11] kernel: drop voluntary schedule from might_fault
Message-ID: <1369404522-12927-10-git-send-email-mst@redhat.com>
References: <cover.1368702323.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1368702323.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

might_fault is called from functions like copy_to_user
which most callers expect to be very fast, like
a couple of instructions.  So functions like memcpy_toiovec call them
many times in a loop.
But might_fault calls might_sleep() and with CONFIG_PREEMPT_VOLUNTARY
this results in a function call.

Let's not do this - just call __might_sleep that produces
a diagnostic for sleep within atomic, but drop
might_preempt().

Here's a test sending traffic between the VM and the host,
host is built with CONFIG_PREEMPT_VOLUNTARY:
Before:
	incoming: 7122.77   Mb/s
	outgoing: 8480.37   Mb/s
after:
	incoming: 8619.24   Mb/s
	outgoing: 9455.42   Mb/s

As a side effect, this fixes an issue pointed
out by Ingo: might_fault might schedule differently
depending on PROVE_LOCKING. Now there's no
preemption point in both cases, so it's consistent.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/kernel.h | 2 +-
 mm/memory.c            | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e96329c..c514c06 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -198,7 +198,7 @@ void might_fault(void);
 #else
 static inline void might_fault(void)
 {
-	might_sleep();
+	__might_sleep(__FILE__, __LINE__, 0);
 }
 #endif
 
diff --git a/mm/memory.c b/mm/memory.c
index 6dc1882..c1f190f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4222,7 +4222,8 @@ void might_fault(void)
 	if (segment_eq(get_fs(), KERNEL_DS))
 		return;
 
-	might_sleep();
+	__might_sleep(__FILE__, __LINE__, 0);
+
 	/*
 	 * it would be nicer only to annotate paths which are not under
 	 * pagefault_disable, however that requires a larger audit and
-- 
MST
