Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab3CPU00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 16:26:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab3CPU0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 16:26:24 -0400
Date: Sat, 16 Mar 2013 21:24:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH 2/2] set_task_comm: kill the pointless memset() + wmb()
Message-ID: <20130316202411.GC18613@redhat.com>
References: <20130312182210.GA15862@redhat.com> <CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com> <20130312191118.GA17439@redhat.com> <CA+55aFzmATkP-W0uX1a_gP7E1fwcp2Mh4537Ou2uwHDixNKPTg@mail.gmail.com> <20130312203514.GA23488@redhat.com> <20130313174641.GA28083@redhat.com> <20130313174705.GB28083@redhat.com> <20130314152819.7fb1242b493e8bad2d34671b@linux-foundation.org> <20130315163916.GA31995@redhat.com> <20130316202327.GA18613@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316202327.GA18613@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_task_comm() does memset() + wmb() before strlcpy(). This buys
nothing but adds the confusion, the comment is wrong.

- We do not need memset() to be "safe from non-terminating string
  reads", the final char is always zero and we never change it.

- wmb() is paired with nothing, it can't not prevent from printing
  the mixture of the old/new data unless the reader takes the lock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index bea2f7d..b270844 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1030,17 +1030,7 @@ EXPORT_SYMBOL_GPL(get_task_comm);
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
 	task_lock(tsk);
-
 	trace_task_rename(tsk, buf);
-
-	/*
-	 * Threads may access current->comm without holding
-	 * the task lock, so write the string carefully.
-	 * Readers without a lock may see incomplete new
-	 * names but are safe from non-terminating string reads.
-	 */
-	memset(tsk->comm, 0, TASK_COMM_LEN);
-	wmb();
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
 	perf_event_comm(tsk);
-- 
1.5.5.1


