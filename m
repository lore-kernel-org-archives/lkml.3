Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab3IYAxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:53:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab3IYARK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:17:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [ 094/110] proc: Restrict mounting the proc filesystem
Date: Tue, 24 Sep 2013 17:15:32 -0700
Message-Id: <20130925001333.597780896@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit aee1c13dd0f6c2fc56e0e492b349ee8ac655880f upstream.

Don't allow mounting the proc filesystem unless the caller has
CAP_SYS_ADMIN rights over the pid namespace.  The principle here is if
you create or have capabilities over it you can mount it, otherwise
you get to live with what other people have mounted.

Andy pointed out that this is needed to prevent users in a user
namespace from remounting proc and specifying different hidepid and gid
options on already existing proc mounts.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/root.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -110,7 +110,8 @@ static struct dentry *proc_mount(struct
 		ns = task_active_pid_ns(current);
 		options = data;
 
-		if (!current_user_ns()->may_mount_proc)
+		if (!current_user_ns()->may_mount_proc ||
+		    !ns_capable(ns->user_ns, CAP_SYS_ADMIN))
 			return ERR_PTR(-EPERM);
 	}
 


