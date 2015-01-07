Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbbAGCDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:03:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265AbbAGCB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:01:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 33/38] exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiting
Date: Tue,  6 Jan 2015 17:50:45 -0800
Message-Id: <20150107014957.703096015@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014952.440109372@linuxfoundation.org>
References: <20150107014952.440109372@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/pid.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -335,6 +335,8 @@ out:
 
 out_unlock:
 	spin_unlock_irq(&pidmap_lock);
+	put_pid_ns(ns);
+
 out_free:
 	while (++i <= ns->level)
 		free_pidmap(pid->numbers + i);


