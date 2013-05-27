Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab3E0UcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 16:32:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757527Ab3E0UcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 16:32:05 -0400
Date: Mon, 27 May 2013 22:28:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        Sha Zhengju <handai.szj@taobao.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] proc: change first_tid() to use while_each_thread()
Message-ID: <20130527202819.GA19281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130527202751.GA19250@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change first_tid() to use while_each_thread() instead of
next_thread().

This doesn't make the code simpler/better, but we are going
to fix or replace while_each_thread(), next_thread() should
be avoided whenever possible.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/base.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index c939c9f..bed1096 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3186,24 +3186,24 @@ static struct task_struct *first_tid(struct task_struct *leader,
 			goto found;
 	}
 
-	pos = NULL;
 	/* If nr exceeds the number of threads there is nothing todo */
 	if (nr && nr >= get_nr_threads(leader))
-		goto out;
+		goto fail;
 	/* It could be unhashed before we take rcu lock */
 	if (!pid_alive(leader))
-		goto out;
+		goto fail;
 
 	/* If we haven't found our starting place yet start
 	 * with the leader and walk nr threads forward.
 	 */
-	for (pos = leader; nr > 0; --nr) {
-		pos = next_thread(pos);
-		if (pos == leader) {
-			pos = NULL;
-			goto out;
-		}
-	}
+	pos = leader;
+	do {
+		if (nr-- <= 0)
+			goto found;
+	} while_each_thread(leader, pos);
+fail:
+	pos = NULL;
+	goto out;
 found:
 	get_task_struct(pos);
 out:
-- 
1.5.5.1

