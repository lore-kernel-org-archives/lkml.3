Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965376Ab3GCTWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:22:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964986Ab3GCTWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:22:38 -0400
Date: Wed, 3 Jul 2013 21:17:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PATCH? trace_remove_event_call() should fail if call is active
Message-ID: <20130703191748.GA2884@redhat.com>
References: <51D16E1D.5040904@hitachi.com> <20130702190037.GA6289@redhat.com> <20130702193425.GA8813@redhat.com> <1372799087.22688.58.camel@gandalf.local.home> <20130702213808.GA24757@redhat.com> <20130702222359.GA27629@redhat.com> <51D38F8D.3010708@hitachi.com> <20130703172029.GA14309@redhat.com> <20130703175420.GA25668@redhat.com> <1372874547.22688.111.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372874547.22688.111.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03, Steven Rostedt wrote:
>
> On Wed, 2013-07-03 at 19:54 +0200, Oleg Nesterov wrote:
> > On 07/03, Oleg Nesterov wrote:
> > >
> > > IOW. So far _I think_ we just need the additional changes in
> > > trace_remove_event_call() if it succeeds (with the patch I sent)
> > > to prevent the races like above, but I didn't even try to think
> > > about this problem.
> >
> > And I guess greatly underestimated the problem(s). When I look at
> > this code now, it seems that, say, event_enable_write() will use
> > the already freed ftrace_event_file in this case.
> >
> > Still I think this is another (although closely related) problem.
>
> Correct, and I think if we fix that problem, it will encapsulate fixing
> the kprobe race too.

I do not think so, but I can be easily wrong. Again, we shouldn't
destroy the event if there is a perf_event attached to this tp_event.
And we can't (afaics!) rely on TRACE_REG_UNREGISTER from event_remove()
paths, FTRACE_EVENT_FL_SOFT_MODE can nack it.

So I still think that we also need something like the patch I sent.
But please forget about this for the moment.

Can't we do something like below? Just in case, of course this change
is incomplete, just to explain what I mean... And of course I how no
idea if the change in debugfs is safe, I never looked into fs/debugfs
before. But, perhaps, somehow we can clear i_private under event_mutex
and kernel/trace can use file_inode() instead of filp->private_data ?

Oleg.


diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 4888cb3..c23d41e 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -475,6 +475,7 @@ static int __debugfs_remove(struct dentry *dentry, struct dentry *parent)
 				kfree(dentry->d_inode->i_private);
 				/* fall through */
 			default:
+				dentry->d_inode->i_private = NULL;
 				simple_unlink(parent->d_inode, dentry);
 				break;
 			}
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 27963e2..bdfd161 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -643,13 +643,10 @@ static ssize_t
 event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
-	struct ftrace_event_file *file = filp->private_data;
+	struct ftrace_event_file *file;
 	unsigned long val;
 	int ret;
 
-	if (!file)
-		return -EINVAL;
-
 	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
 	if (ret)
 		return ret;
@@ -661,8 +658,11 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	switch (val) {
 	case 0:
 	case 1:
+		ret = -EINVAL;
 		mutex_lock(&event_mutex);
-		ret = ftrace_event_enable_disable(file, val);
+		file = file_inode(filp)->i_private;
+		if (file)
+			ret = ftrace_event_enable_disable(file, val);
 		mutex_unlock(&event_mutex);
 		break;
 

