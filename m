Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3AXXxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 18:53:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6838 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3AXXxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 18:53:06 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1lp5RE5RrrwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=CpGQe48J6BUA:10 a=fmDjJsrZAAAA:8 a=C_IRinGWAAAA:8 a=MRHyUqWkLcQPHUEgpLMA:9 a=PUjeQqilurYA:10 a=YK30HMD7P3IA:10 a=si9q_4b84H0A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359071583.21576.167.camel@gandalf.local.home>
Subject: Re: [RFC] Hack to use mkdir/rmdir in debugfs
From: Steven Rostedt <rostedt@goodmis.org>
To: Valdis.Kletnieks@vt.edu
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 24 Jan 2013 18:53:03 -0500
In-Reply-To: <28808.1359067162@turing-police.cc.vt.edu>
References: <1358910114.21576.86.camel@gandalf.local.home>
	 <20130123040846.GA2638@kroah.com>
	 <1358915495.21576.102.camel@gandalf.local.home>
	 <1358916249.21576.105.camel@gandalf.local.home>
	 <28808.1359067162@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 17:39 -0500, Valdis.Kletnieks@vt.edu wrote:

> > +static int instance_rmdir(struct inode *inode, struct dentry *dentry)
> > +{
> > +	struct dentry *parent;
> > +	int ret;
> > +
> > +	/* Paranoid: Make sure the parent is the "instances" directory */
> > +	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_alias);
> > +	if (WARN_ON_ONCE(parent != trace_instance_dir))
> > +		return -ENOENT;
> > +
> > +	/* The caller did a dget() on dentry */
> > +	mutex_unlock(&dentry->d_inode->i_mutex);
> > +
> > +	/*
> > +	 * The inode mutex is locked, but debugfs_create_dir() will also
> > +	 * take the mutex. As the instances directory can not be destroyed
> > +	 * or changed in any other way, it is safe to unlock it, and
> > +	 * let the dentry try. If two users try to make the same dir at
> > +	 * the same time, then the instance_delete() will determine the
> > +	 * winner.
> > +	 */
> > +	mutex_unlock(&inode->i_mutex);
> 
> Looks like the rmdir comment was slice-n-miced from the mkdir one?
> 
> What exactly *are* the race condition rules here, especially for mkdir
> racing against an rmdir?

Note, after the i_mutex is released, new mutexes are grabbed to test if
we can create or delete a file:

static int new_instance_create(const char *name)
{
        enum ring_buffer_flags rb_flags;
        struct trace_array *tr;
        int ret;
        int i;

        mutex_lock(&trace_types_lock);

        ret = -EEXIST;
        list_for_each_entry(tr, &ftrace_trace_arrays, list) {
                if (tr->name && strcmp(tr->name, name) == 0)
                        goto out_unlock;
        }

        ret = -ENOMEM;
        tr = kzalloc(sizeof(*tr), GFP_KERNEL);
        if (!tr)
                goto out_unlock;

        tr->name = kstrdup(name, GFP_KERNEL);
        if (!tr->name)
                goto out_free_tr;

        raw_spin_lock_init(&tr->start_lock);

        tr->current_trace = &nop_trace;

        INIT_LIST_HEAD(&tr->systems);
        INIT_LIST_HEAD(&tr->events);

        rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;

        tr->buffer = ring_buffer_alloc(trace_buf_size, rb_flags);
        if (!tr->buffer)
                goto out_free_tr;

        tr->data = alloc_percpu(struct trace_array_cpu);
        if (!tr->data)
                goto out_free_tr;

        for_each_tracing_cpu(i) {
                memset(per_cpu_ptr(tr->data, i), 0, sizeof(struct trace_array_cpu));
                per_cpu_ptr(tr->data, i)->trace_cpu.cpu = i;
                per_cpu_ptr(tr->data, i)->trace_cpu.tr = tr;
        }

        /* Holder for file callbacks */
        tr->trace_cpu.cpu = RING_BUFFER_ALL_CPUS;
        tr->trace_cpu.tr = tr;

        tr->dir = debugfs_create_dir(name, trace_instance_dir);
        if (!tr->dir)
                goto out_free_tr;

        ret = event_trace_add_tracer(tr->dir, tr);
        if (ret)
                goto out_free_tr;

        init_tracer_debugfs(tr, tr->dir);

        list_add(&tr->list, &ftrace_trace_arrays);

        mutex_unlock(&trace_types_lock);

        return 0;

 out_free_tr:
        if (tr->buffer)
                ring_buffer_free(tr->buffer);
        kfree(tr->name);
        kfree(tr);

 out_unlock:
        mutex_unlock(&trace_types_lock);

        return ret;

}

static int instance_delete(const char *name)
{
        struct trace_array *tr;
        int found = 0;
        int ret;

        mutex_lock(&trace_types_lock);

        ret = -ENODEV;
        list_for_each_entry(tr, &ftrace_trace_arrays, list) {
                if (tr->name && strcmp(tr->name, name) == 0) {
                        found = 1;
                        break;
                }
        }
        if (!found)
                goto out_unlock;

        list_del(&tr->list);

        event_trace_del_tracer(tr);
        debugfs_remove_recursive(tr->dir);
        free_percpu(tr->data);
        ring_buffer_free(tr->buffer);

        kfree(tr->name);
        kfree(tr);

        ret = 0;

 out_unlock:
        mutex_unlock(&trace_types_lock);

        return ret;
}


The trace_types_lock protects the ftrace_trace_arrays, which holds the
descriptors for the entities that can be created or removed. The
debugfs_remove_recursive(), and debugfs_create_dir() etc, are children
of the inode i_mutex that we released. Basically, the trace_types_lock
takes over for creating and destroying directories. It's the same type
of protection I had when I had the "new" and "free" files that would
create the directory when echoing in "new" and delete one when echoing
in "free". There's really no difference. I'm only using the mkdir/rmdir
interface to trigger the exact same interface I had before. They both
have the same locking.

There is no rename or any other manipulation here. Even the parent
directory can't change (no way to delete it).

As for races, I've been running this little script to test it out, and
it works fine:

-- Steve

----
#!/bin/bash

if [ ! -d /debug/tracing/instances ]; then
	echo "No instances directory"
	exit 0
fi

cd /debug/tracing/instances

instance_slam() {
	while :; do
		mkdir x
		mkdir y
		mkdir z
		rmdir x
		rmdir y
		rmdir z
	done 2>/dev/null
}

instance_slam &
x=`jobs -l`
p1=`echo $x | cut -d' ' -f2`
echo $p1

instance_slam &
x=`jobs -l | tail -1`
p2=`echo $x | cut -d' ' -f2`
echo $p2

instance_slam &
x=`jobs -l | tail -1`
p3=`echo $x | cut -d' ' -f2`
echo $p3

instance_slam &
x=`jobs -l | tail -1`
p4=`echo $x | cut -d' ' -f2`
echo $p4

instance_slam &
x=`jobs -l | tail -1`
p5=`echo $x | cut -d' ' -f2`
echo $p5

for i in `seq 120`; do
	ls
	sleep 1
done
kill -9 $p1 
kill -9 $p2
kill -9 $p3
kill -9 $p4
kill -9 $p5

mkdir x y z
ls x y z
rmdir x y z
exit


