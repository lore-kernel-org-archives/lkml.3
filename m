Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3KVRx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:53:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab3KVRx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:53:27 -0500
Date: Fri, 22 Nov 2013 18:54:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sameer Nanda <snanda@chromium.org>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] check_unsafe_exec: use while_each_thread() rather than
	next_thread()
Message-ID: <20131122175439.GA31446@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122175424.GA31432@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

next_thread() should be avoided, change check_unsafe_exec()
to use while_each_thread(). This also saves 32 bytes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 1dee8ef..0cd9c25 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1245,10 +1245,11 @@ static int check_unsafe_exec(struct linux_binprm *bprm)
 	if (current->no_new_privs)
 		bprm->unsafe |= LSM_UNSAFE_NO_NEW_PRIVS;
 
+	t = p;
 	n_fs = 1;
 	spin_lock(&p->fs->lock);
 	rcu_read_lock();
-	for (t = next_thread(p); t != p; t = next_thread(t)) {
+	while_each_thread(p, t) {
 		if (t->fs == p->fs)
 			n_fs++;
 	}
-- 
1.5.5.1

