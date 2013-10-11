Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab3JKTxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:53:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932765Ab3JKTl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 095/135] kernel/kmod.c: check for NULL in call_usermodehelper_exec()
Date: Fri, 11 Oct 2013 12:39:36 -0700
Message-Id: <20131011193955.587009797@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 4c1c7be95c345cf2ad537a0c48e9aeadc7304527 upstream.

If /proc/sys/kernel/core_pattern contains only "|", a NULL pointer
dereference happens upon core dump because argv_split("") returns
argv[0] == NULL.

This bug was once fixed by commit 264b83c07a84 ("usermodehelper: check
subprocess_info->path != NULL") but was by error reintroduced by commit
7f57cfa4e2aa ("usermodehelper: kill the sub_info->path[0] check").

This bug seems to exist since 2.6.19 (the version which core dump to
pipe was added).  Depending on kernel version and config, some side
effect might happen immediately after this oops (e.g.  kernel panic with
2.6.32-358.18.1.el6).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kmod.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -571,6 +571,10 @@ int call_usermodehelper_exec(struct subp
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
 
+	if (!sub_info->path) {
+		call_usermodehelper_freeinfo(sub_info);
+		return -EINVAL;
+	}
 	helper_lock();
 	if (!khelper_wq || usermodehelper_disabled) {
 		retval = -EBUSY;


