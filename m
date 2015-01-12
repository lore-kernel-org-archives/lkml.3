Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbbALTEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:04:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57977 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbbALS3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:29:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 120/216] exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiting
Date: Mon, 12 Jan 2015 18:28:18 +0000
Message-Id: <1421087394-2712-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.4

