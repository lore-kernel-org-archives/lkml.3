Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3KTS3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:29:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab3KTS3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:29:08 -0500
Date: Wed, 20 Nov 2013 19:30:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>, Sameer Nanda <snanda@chromium.org>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] proc: change first_tid() to use while_each_thread()
	rather than next_thread()
Message-ID: <20131120183024.GA12212@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120183009.GA12193@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rerwrite the main loop to use while_each_thread() instead of
next_thread(). We are going to fix or replace while_each_thread(),
next_thread() should be avoided whenever possible.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/base.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index da12c5c..7ab3785 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3100,23 +3100,23 @@ static struct task_struct *first_tid(struct task_struct *leader,
 	}
 
 	/* If nr exceeds the number of threads there is nothing todo */
-	pos = NULL;
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

