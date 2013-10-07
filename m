Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3JGKiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:38:07 -0400
Received: from intranet.asianux.com ([58.214.24.6]:6440 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3JGKaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:30:14 -0400
X-Spam-Score: -100.8
Message-ID: <52528CF7.8050405@asianux.com>
Date: Mon, 07 Oct 2013 18:29:11 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/pid.c: check pid whether be NULL in __change_pid()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Within __change_pid(), 'new' may be NULL if it comes from detach_pid(),
and 'link->pid' also may be NULL ("link->pid = new"), so theoretically,\
the original 'link->pid' may be NULL, too.

In real world, at least now, all callers which will call detach_pid()
or change_pid() will not cause issue, but still recommend to check it
in __change_pid() to let itself consistency.

After the modification, it passed a simpe test: "build -> boot up ->
[s/g]et_[p/s/g]id() test by LTP tools".


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/pid.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 9b9a266..15b1b3d 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -399,6 +399,9 @@ static void __change_pid(struct task_struct *task, enum pid_type type,
 	hlist_del_rcu(&link->node);
 	link->pid = new;
 
+	if (!pid)
+		return;
+
 	for (tmp = PIDTYPE_MAX; --tmp >= 0; )
 		if (!hlist_empty(&pid->tasks[tmp]))
 			return;
-- 
1.7.7.6
