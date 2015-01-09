Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbbAIKiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:38:25 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44606 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757502AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 70/78] exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiting
Date: Fri,  9 Jan 2015 11:32:19 +0100
Message-Id: <259c1c876ea03d24f0d8eaccb122a7733607bd34.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 24c037ebf5723d4d9ab0996433cee4f96c292a4d upstream.

alloc_pid() does get_pid_ns() beforehand but forgets to put_pid_ns() if it
fails because disable_pid_allocation() was called by the exiting
child_reaper.

We could simply move get_pid_ns() down to successful return, but this fix
tries to be as trivial as possible.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/pid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/pid.c b/kernel/pid.c
index 9b9a26698144..82430c858d69 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -341,6 +341,8 @@ out:
 
 out_unlock:
 	spin_unlock_irq(&pidmap_lock);
+	put_pid_ns(ns);
+
 out_free:
 	while (++i <= ns->level)
 		free_pidmap(pid->numbers + i);
-- 
2.2.1

