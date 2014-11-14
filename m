Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935096AbaKNBiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:38:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934808AbaKNBiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:38:18 -0500
Date: Fri, 14 Nov 2014 02:38:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Rik van Riel <riel@redhat.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] exit: proc: don't try to flush /proc/tgid/task/tgid
Message-ID: <20141114013825.GA5140@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114013750.GA4697@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_flush_task_mnt() always tries to flush task/pid, but this is
pointless if we reap the leader. d_invalidate() is recursive, and
if nothing else the next d_hash_and_lookup(tgid) should fail anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 772efa4..e7b04a3 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2618,6 +2618,9 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
 		dput(dentry);
 	}
 
+	if (pid == tgid)
+		return;
+
 	name.name = buf;
 	name.len = snprintf(buf, sizeof(buf), "%d", tgid);
 	leader = d_hash_and_lookup(mnt->mnt_root, &name);
-- 
1.5.5.1

