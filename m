Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3G1Sjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 14:39:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab3G1Sjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 14:39:43 -0400
Date: Sun, 28 Jul 2013 20:34:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] tracing: open/delete fixes
Message-ID: <20130728183407.GA16723@redhat.com>
References: <20130726172513.GA3586@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726172513.GA3586@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26, Oleg Nesterov wrote:
>
> Testing: seems to work, but assumes that debugs was fixed too. Hopefully
> "debugfs: debugfs_remove_recursive() must not rely on list_empty(d_subdirs)"
> is fine.
>
> (We should probably make debugfs_remove_recursive() to return the error
>  and trace_events.c should warn if it fails)
>
> However: I am still testing this patches, so this is still mostly for
> review. I'll report if I find anything,

I tried to play more with these patches, and didn't find anything wrong.

However, after I re-read 6/6 I think it should be updated:

	- remove_event_file_dir() needs to check file->dir != NULL

	  it can be NULL if event_create_dir()->debugfs_create_dir()
	  fails, or if event_create_dir() fails before.

	- I've also added spin_lock(d_lock) and d_inode != NULL check.

	  I do not think this is needed. Afaics __create_file() can't
	  leave the !debugfs_positive() file on ->d_subdirs list if
	  debugfs_get_inode() fails, dput()->d_kill() should remove it.

	  But I do not understand this code enough, and debugfs checks
	  d_inode != NULL all the time.

I am sending "PATCH v3 6/6" in reply to "PATCH v2 6/6". See the diff
below.

So I am waiting for your review. If you and Masami agree with these
changes I'll resend other fixes (1 from me and 2 from Steven) on top
of this series.

Oleg.

--- x/kernel/trace/trace_events.c
+++ x/kernel/trace/trace_events.c
@@ -431,12 +431,18 @@ static void remove_event_file_dir(struct
 	struct dentry *dir = file->dir;
 	struct dentry *child;
 
-	/* ->i_mutex is not needed, nobody can create/remove a file */
-	list_for_each_entry(child, &dir->d_subdirs, d_u.d_child)
-		child->d_inode->i_private = NULL;
+	if (dir) {
+		spin_lock(&dir->d_lock);	/* probably unneeded */
+		list_for_each_entry(child, &dir->d_subdirs, d_u.d_child) {
+			if (child->d_inode)	/* probably unneeded */
+				child->d_inode->i_private = NULL;
+		}
+		spin_unlock(&dir->d_lock);
+
+		debugfs_remove_recursive(dir);
+	}
 
 	list_del(&file->list);
-	debugfs_remove_recursive(dir);
 	remove_subsystem(file->system);
 	kmem_cache_free(file_cachep, file);
 }

