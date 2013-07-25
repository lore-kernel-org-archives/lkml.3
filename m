Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab3GYRCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:02:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab3GYRCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:02:51 -0400
Date: Thu, 25 Jul 2013 18:56:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] tracing: open/delete fixes
Message-ID: <20130725165628.GA12736@redhat.com>
References: <20130723205854.GA9036@redhat.com> <20130724184640.GA21322@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724184640.GA21322@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24, Oleg Nesterov wrote:
>
> On 07/23, Oleg Nesterov wrote:
> >
> > Will try to test tomorrow.
>
> Well, it seems to work "as expected",

Yes. And so far I think it is fine.

> but I forgot about debugfs
> problems.

And yes. We still have the problems with "Failed to create system
directory" if subsytem was removed while someone keeps the file
opened.

BUT: so far I think this is another and unrelated problem, see
below.

> This makes me think again that perhaps
> the subsystem logic is not correct, but probably I misunderstood
> it for the 2nd time.

Damn yes, I misread this code again.

Now I am almost sure fs/debugfs is wrong. At least it doesn't match
my expectations ;)

Suppose we have

	dir1/
		file1
		dir2/
			file2

somewhere in debugfs.

Suppose that someone opens dir1/dir2/file2.

Now. debugfs_remove_recursive(dir1/dir2) succeeds, and dir1/di2 goes
away.

But debugfs_remove_recursive(dir1) silently fails and doesn't remove
this directory. It relies on list_empty(d_subdirs) and this doesn't
look right.

If nothing else, note that simple_empty() doesn't blindly return
list_empty(d_subdirs), this list still have the deleted nodes.

The patch below fixes the problem, but I do not think it is really
correct, I'll try to think more.

Oleg.

--- a/fs/debugfs/inode.c~	2013-03-20 12:54:00.000000000 +0100
+++ b/fs/debugfs/inode.c	2013-07-25 18:31:46.000000000 +0200
@@ -566,7 +579,7 @@ void debugfs_remove_recursive(struct den
 		 * If "child" isn't empty, walk down the tree and
 		 * remove all its descendants first.
 		 */
-		if (!list_empty(&child->d_subdirs)) {
+		if (debugfs_positive(child) && !list_empty(&child->d_subdirs)) {
 			mutex_unlock(&parent->d_inode->i_mutex);
 			parent = child;
 			mutex_lock(&parent->d_inode->i_mutex);

