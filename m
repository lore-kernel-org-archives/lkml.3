Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaBIERG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 23:17:06 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:22334 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaBIERE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 23:17:04 -0500
Message-ID: <1391919420.1099.31.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Max number of posix queues in vanilla kernel
 (/proc/sys/fs/mqueue/queues_max)
From: Davidlohr Bueso <davidlohr@hp.com>
To: Doug Ledford <dledford@redhat.com>
Cc: m@silodev.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Manfred Spraul <manfred@colorfullife.com>
Date: Sat, 08 Feb 2014 20:17:00 -0800
In-Reply-To: <52F54F08.6060507@redhat.com>
References: <11414.87.110.183.114.1391682066.squirrel@www.silodev.com>
	 <1391803868.1099.23.camel@buesod1.americas.hpqcorp.net>
	 <52F54F08.6060507@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 16:24 -0500, Doug Ledford wrote:
> On 2/7/2014 3:11 PM, Davidlohr Bueso wrote:
> > On Thu, 2014-02-06 at 12:21 +0200, m@silodev.com wrote:
> >> Hi Folks,
> >>
> >> I have recently ported my multi-process application (like a classical open
> >> system) which uses POSIX Queues as IPC to one of the latest Linux kernels,
> >> and I have faced issue that number of maximum queues are dramatically
> >> limited down to 1024 (see include/linux/ipc_namespace.h, #define
> >> HARD_QUEUESMAX 1024).
> >>
> >> Previously the max number of queues was INT_MAX (on 64bit system was:
> >> 2147483647).
> > 
> > Hmm yes, 1024 is quite unrealistic for some workloads and breaks
> > userspace - I don't see any reasons for _this_ specific value in the
> > changelog or related changes in the patchset that introduced commits
> > 93e6f119 and 02967ea0.
> 
> There wasn't a specific selection of that number other than a general
> attempt to make the max more reasonable (INT_MAX isn't really reasonable
> given the overhead of each individual queue, even if the queue number
> and max msg size are small).
> 
> > And the fact that this limit is per namespace
> > makes no difference really. Hell, if nothing else, the mq_overview(7)
> > manpage description is evidence enough. For privileged users:
> > 
> > The default value for queues_max is 256; it can be changed to any value in the range 0 to INT_MAX.
> 
> That was obviously never updated to match the change.
> 
> In hindsight, I'm not sure we really even care though.  Since the limit
> on queues is per namespace, and we can make as many namespaces as we
> want, the limit is more or less meaningless and only serves as a
> nuisance to people. 

Yes, but namespaces aren't _that_ popular in reality, specially as you
describe the workaround.

>  Since we have accounting on a per user basis that
> spans across namespaces and across queues, maybe that should be
> sufficient and the limit on queues should simply be removed and we
> should instead just rely on memory limits.  When the user has exhausted
> their allowed memory usage, whether by large queue sizes, large message
> sizes, or large queue counts, then they are done.  When they haven't,
> they can keep allocating.  Would make things considerably easier and
> would avoid the breakage we are talking about here.
> 

Right, and this is taken care of in mqueue_get_inode().

The (untested) code below simply removes this global limit, let me know
if you're okay with it and I'll send a formal/tested patch.

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index e7831d2..d78a09f 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -120,7 +120,6 @@ extern int mq_init_ns(struct ipc_namespace *ns);
  */
 #define MIN_QUEUESMAX			1
 #define DFLT_QUEUESMAX		      256
-#define HARD_QUEUESMAX		     1024
 #define MIN_MSGMAX			1
 #define DFLT_MSG		       10U
 #define DFLT_MSGMAX		       10
diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
index 383d638..5bb8bfe 100644
--- a/ipc/mq_sysctl.c
+++ b/ipc/mq_sysctl.c
@@ -22,6 +22,16 @@ static void *get_mq(ctl_table *table)
 	return which;
 }
 
+static int proc_mq_dointvec(ctl_table *table, int write,
+			    void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table mq_table;
+	memcpy(&mq_table, table, sizeof(mq_table));
+	mq_table.data = get_mq(table);
+
+	return proc_dointvec(&mq_table, write, buffer, lenp, ppos);
+}
+
 static int proc_mq_dointvec_minmax(ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -33,12 +43,10 @@ static int proc_mq_dointvec_minmax(ctl_table *table, int write,
 					lenp, ppos);
 }
 #else
+#define proc_mq_dointvec NULL
 #define proc_mq_dointvec_minmax NULL
 #endif
 
-static int msg_queues_limit_min = MIN_QUEUESMAX;
-static int msg_queues_limit_max = HARD_QUEUESMAX;
-
 static int msg_max_limit_min = MIN_MSGMAX;
 static int msg_max_limit_max = HARD_MSGMAX;
 
@@ -51,9 +59,7 @@ static ctl_table mq_sysctls[] = {
 		.data		= &init_ipc_ns.mq_queues_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_mq_dointvec_minmax,
-		.extra1		= &msg_queues_limit_min,
-		.extra2		= &msg_queues_limit_max,
+		.proc_handler	= proc_mq_dointvec,
 	},
 	{
 		.procname	= "msg_max",
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index ccf1f9f..c3b3117 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -433,9 +433,9 @@ static int mqueue_create(struct inode *dir, struct dentry *dentry,
 		error = -EACCES;
 		goto out_unlock;
 	}
-	if (ipc_ns->mq_queues_count >= HARD_QUEUESMAX ||
-	    (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max &&
-	     !capable(CAP_SYS_RESOURCE))) {
+
+	if (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max &&
+	    !capable(CAP_SYS_RESOURCE)) {
 		error = -ENOSPC;
 		goto out_unlock;
 	}


