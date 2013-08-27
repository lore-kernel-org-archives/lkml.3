Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3H0Oqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:46:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab3H0Oqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:46:33 -0400
Date: Tue, 27 Aug 2013 16:40:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Willy Tarreau <w@1wt.eu>, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: [PATCH 1/1] proc: make /proc/self point to thread
Message-ID: <20130827144004.GB19425@redhat.com>
References: <20130825065039.GB9299@1wt.eu> <CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com> <20130825194844.GA16717@redhat.com> <CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com> <20130826153301.GA15890@redhat.com> <20130826163704.GA21763@redhat.com> <20130826175441.GA28856@redhat.com> <CA+55aFzCghYYF1_dcvBY9XZ82TU9b=hhgFqkGoWpaZuKJ7R6_A@mail.gmail.com> <CA+55aFwAw=AZNqmDNip_P6WiY4zGRNWks-kLwN7ZgJ8JJsAx-A@mail.gmail.com> <20130827143938.GA19425@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827143938.GA19425@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/self points to /proc/<tgid>, not to /proc/<tid>, and thus
"self" actually means "group leader".

Change fs/proc/self.c to print the caller's tid, this is probably
what the users actually expect.

Note: this is obviously semantically different and the difference
is subtle, but most (all?) users should not notice this change.
Lets see if it breaks something.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/self.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/proc/self.c b/fs/proc/self.c
index 6b6a993..7da7154 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -11,26 +11,26 @@ static int proc_self_readlink(struct dentry *dentry, char __user *buffer,
 			      int buflen)
 {
 	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
-	pid_t tgid = task_tgid_nr_ns(current, ns);
+	pid_t tid = task_pid_nr_ns(current, ns);
 	char tmp[PROC_NUMBUF];
-	if (!tgid)
+	if (!tid)
 		return -ENOENT;
-	sprintf(tmp, "%d", tgid);
+	sprintf(tmp, "%d", tid);
 	return vfs_readlink(dentry,buffer,buflen,tmp);
 }
 
 static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
-	pid_t tgid = task_tgid_nr_ns(current, ns);
+	pid_t tid = task_pid_nr_ns(current, ns);
 	char *name = ERR_PTR(-ENOENT);
-	if (tgid) {
+	if (tid) {
 		/* 11 for max length of signed int in decimal + NULL term */
 		name = kmalloc(12, GFP_KERNEL);
 		if (!name)
 			name = ERR_PTR(-ENOMEM);
 		else
-			sprintf(name, "%d", tgid);
+			sprintf(name, "%d", tid);
 	}
 	nd_set_link(nd, name);
 	return NULL;
@@ -57,7 +57,7 @@ int proc_setup_self(struct super_block *s)
 	struct inode *root_inode = s->s_root->d_inode;
 	struct pid_namespace *ns = s->s_fs_info;
 	struct dentry *self;
-	
+
 	mutex_lock(&root_inode->i_mutex);
 	self = d_alloc_name(s->s_root, "self");
 	if (self) {
-- 
1.5.5.1


