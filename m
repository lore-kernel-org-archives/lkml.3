Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbbANJdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:33:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbbANJcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:32:54 -0500
Subject: [RFC PATCH 2/5] kmod - rename call_usermodehelper() flags parameter
From: Ian Kent <ikent@redhat.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Oleg Nesterov <onestero@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Jeff Layton <jeff.layton@primarydata.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 14 Jan 2015 17:32:36 +0800
Message-ID: <20150114093235.30252.32173.stgit@pluto.fritz.box>
In-Reply-To: <20150114092704.30252.60446.stgit@pluto.fritz.box>
References: <20150114092704.30252.60446.stgit@pluto.fritz.box>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wait parameter of call_usermodehelper() is not quite a parameter
that describes the wait behaviour alone and will later be used to
request exec within a namespace.

So change its name to flags.

Signed-off-by: Ian Kent <ikent@redhat.com>
Cc: Benjamin Coddington <bcodding@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Oleg Nesterov <onestero@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jeff Layton <jeff.layton@primarydata.com>
---
 include/linux/kmod.h |    4 ++--
 kernel/kmod.c        |   16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 0555cc6..15bdeed 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -67,7 +67,7 @@ struct subprocess_info {
 };
 
 extern int
-call_usermodehelper(char *path, char **argv, char **envp, int wait);
+call_usermodehelper(char *path, char **argv, char **envp, int flags);
 
 extern struct subprocess_info *
 call_usermodehelper_setup(char *path, char **argv, char **envp, gfp_t gfp_mask,
@@ -75,7 +75,7 @@ call_usermodehelper_setup(char *path, char **argv, char **envp, gfp_t gfp_mask,
 			  void (*cleanup)(struct subprocess_info *), void *data);
 
 extern int
-call_usermodehelper_exec(struct subprocess_info *info, int wait);
+call_usermodehelper_exec(struct subprocess_info *info, int flags);
 
 extern struct ctl_table usermodehelper_table[];
 
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 2777f40..14c0188 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -534,7 +534,7 @@ EXPORT_SYMBOL(call_usermodehelper_setup);
  * asynchronously if wait is not set, and runs as a child of keventd.
  * (ie. it runs with full root capabilities).
  */
-int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
+int call_usermodehelper_exec(struct subprocess_info *sub_info, int flags)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
@@ -553,14 +553,14 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 	 * This makes it possible to use umh_complete to free
 	 * the data structure in case of UMH_NO_WAIT.
 	 */
-	sub_info->complete = (wait == UMH_NO_WAIT) ? NULL : &done;
-	sub_info->wait = wait;
+	sub_info->complete = (flags == UMH_NO_WAIT) ? NULL : &done;
+	sub_info->wait = flags;
 
 	queue_work(khelper_wq, &sub_info->work);
-	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
+	if (flags == UMH_NO_WAIT)	/* task has freed sub_info */
 		goto unlock;
 
-	if (wait & UMH_KILLABLE) {
+	if (flags & UMH_KILLABLE) {
 		retval = wait_for_completion_killable(&done);
 		if (!retval)
 			goto wait_done;
@@ -595,17 +595,17 @@ EXPORT_SYMBOL(call_usermodehelper_exec);
  * This function is the equivalent to use call_usermodehelper_setup() and
  * call_usermodehelper_exec().
  */
-int call_usermodehelper(char *path, char **argv, char **envp, int wait)
+int call_usermodehelper(char *path, char **argv, char **envp, int flags)
 {
 	struct subprocess_info *info;
-	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
+	gfp_t gfp_mask = (flags == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
 	info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
 					 NULL, NULL, NULL);
 	if (info == NULL)
 		return -ENOMEM;
 
-	return call_usermodehelper_exec(info, wait);
+	return call_usermodehelper_exec(info, flags);
 }
 EXPORT_SYMBOL(call_usermodehelper);
 

