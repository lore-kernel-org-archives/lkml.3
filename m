Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab3CBCpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 21:45:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30144 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3CBCpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 21:45:21 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=dCXt4Z_EDXgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=VHl0eERhotoA:10 a=iTawgs62bG0wHPJiu44A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362192318.1231.67.camel@gandalf.local.home>
Subject: Re: linux-next: build failure after merge of the ftrace tree
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 01 Mar 2013 21:45:18 -0500
In-Reply-To: <20130301134738.ce925e1643a35b0a2c4ff275@canb.auug.org.au>
References: <20130301134738.ce925e1643a35b0a2c4ff275@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 13:47 +1100, Stephen Rothwell wrote:
> Hi Steven,
> 
> After merging the ftrace tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> kernel/trace/trace_kdb.c: In function 'ftrace_dump_buf':
> kernel/trace/trace_kdb.c:29:33: error: invalid type argument of '->' (have 'struct trace_array_cpu')
> kernel/trace/trace_kdb.c:86:33: error: invalid type argument of '->' (have 'struct trace_array_cpu')
> 
> Caused by commit eaac1836c10e ("tracing: Replace the static global
> per_cpu arrays with allocated per_cpu").
> 
> I have used the ftrace tree from next-20130228 for today.

I rebased, and it should all be good now. I also fixed breakage to the
new snapshot feature. Here's my diff:

-- Steve

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index af7be82..b36befa 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4133,14 +4133,30 @@ static int tracing_clock_open(struct inode *inode, struct file *file)
 #ifdef CONFIG_TRACER_SNAPSHOT
 static int tracing_snapshot_open(struct inode *inode, struct file *file)
 {
+	struct trace_cpu *tc = inode->i_private;
 	struct trace_iterator *iter;
+	struct seq_file *m;
 	int ret = 0;
 
 	if (file->f_mode & FMODE_READ) {
 		iter = __tracing_open(inode, file, true);
 		if (IS_ERR(iter))
 			ret = PTR_ERR(iter);
+	} else {
+		/* Writes still need the seq_file to hold the private data */
+		m = kzalloc(sizeof(*m), GFP_KERNEL);
+		if (!m)
+			return -ENOMEM;
+		iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+		if (!iter) {
+			kfree(m);
+			return -ENOMEM;
+		}
+		iter->tr = tc->tr;
+		m->private = iter;
+		file->private_data = m;
 	}
+
 	return ret;
 }
 
@@ -4148,7 +4164,9 @@ static ssize_t
 tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		       loff_t *ppos)
 {
-	struct trace_array *tr = filp->private_data;
+	struct seq_file *m = filp->private_data;
+	struct trace_iterator *iter = m->private;
+	struct trace_array *tr = iter->tr;
 	unsigned long val;
 	int ret;
 
@@ -4209,6 +4227,22 @@ out:
 	mutex_unlock(&trace_types_lock);
 	return ret;
 }
+
+static int tracing_snapshot_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = file->private_data;
+
+	if (file->f_mode & FMODE_READ)
+		return tracing_release(inode, file);
+
+	/* If write only, the seq_file is just a stub */
+	if (m)
+		kfree(m->private);
+	kfree(m);
+
+	return 0;
+}
+
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
 
@@ -4273,7 +4307,7 @@ static const struct file_operations snapshot_fops = {
 	.read		= seq_read,
 	.write		= tracing_snapshot_write,
 	.llseek		= tracing_seek,
-	.release	= tracing_release,
+	.release	= tracing_snapshot_release,
 };
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
@@ -5284,7 +5318,7 @@ static __init int tracer_init_debugfs(void)
 
 #ifdef CONFIG_TRACER_SNAPSHOT
 	trace_create_file("snapshot", 0644, d_tracer,
-			  (void *) RING_BUFFER_ALL_CPUS, &snapshot_fops);
+			  (void *)&global_trace.trace_cpu, &snapshot_fops);
 #endif
 
 	create_trace_instances(d_tracer);
diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index cc1dbdc..349f694 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -26,7 +26,7 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
 	trace_init_global_iter(&iter);
 
 	for_each_tracing_cpu(cpu) {
-		atomic_inc(&iter.tr->data[cpu]->disabled);
+		atomic_inc(&per_cpu_ptr(iter.tr->data, cpu)->disabled);
 	}
 
 	old_userobj = trace_flags;
@@ -83,7 +83,7 @@ out:
 	trace_flags = old_userobj;
 
 	for_each_tracing_cpu(cpu) {
-		atomic_dec(&iter.tr->data[cpu]->disabled);
+		atomic_dec(&per_cpu_ptr(iter.tr->data, cpu)->disabled);
 	}
 
 	for_each_tracing_cpu(cpu)


