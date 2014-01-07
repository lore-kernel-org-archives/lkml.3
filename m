Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaAGRbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:31:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:62618 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbaAGRbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:31:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,619,1384329600"; 
   d="scan'208";a="454958782"
Message-ID: <1389115745.3040.104.camel@empanada>
Subject: Re: [PATCH 0/2] tracing/triggers: A couple minor variable name
 changes
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Date: Tue, 07 Jan 2014 11:29:05 -0600
In-Reply-To: <20140106222703.5e7dbba2@gandalf.local.home>
References: <cover.1389036657.git.tom.zanussi@linux.intel.com>
	 <20140106161347.4cc82a4b@gandalf.local.home>
	 <1389055673.3040.83.camel@empanada>
	 <20140106205034.53c219cc@gandalf.local.home>
	 <1389063069.3040.90.camel@empanada>
	 <20140106222703.5e7dbba2@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 22:27 -0500, Steven Rostedt wrote:
> On Mon, 06 Jan 2014 20:51:09 -0600
> Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
> 
>  
> > > Hmm, OK, I think you may have convinced me. I'll swap the return values.
> > > 
> > 
> > Sounds great, thanks!
> 
> New patch.
> 

Looks good to me and passes my normal testing.

Acked-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Tested-by: Tom Zanussi <tom.zanussi@linux.intel.com>

Just so you know what encompasses my 'normal testing', below is what I
normally run through - if everything checks out, I'm satisfied things
are basically good, though of course it didn't catch your traceoff bug
so it's not complete.

As soon as I get the chance, I'll automate it and add more tests for
completeness - as it is it's grown into something that already takes too
long to do manually, so I need to find the time....

---- basic high-level check
     - quick enable/disable_event, capture limited number of events
     - both counted and not
     - verify flags
     - verify removal

# echo 'enable_event:kmem:kmalloc:1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/trigger;cat ~/junk.txt > /dev/null;echo 'disable_event:kmem:kmalloc' > /sys/kernel/debug/tracing/events/syscalls/sys_exit_read/trigger

# cat /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
0*

# cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/trigger
enable_event:kmem:kmalloc:count=0

# cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/enable
0*

# cat /sys/kernel/debug/tracing/events/syscalls/sys_exit_read/trigger
disable_event:kmem:kmalloc:unlimited

# cat /sys/kernel/debug/tracing/events/syscalls/sys_exit_read/enable
0*

# cat /sys/kernel/debug/tracing/trace

# echo '!enable_event:kmem:kmalloc:1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/trigger
# echo '!disable_event:kmem:kmalloc' > /sys/kernel/debug/tracing/events/syscalls/sys_exit_read/trigger

# cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/trigger
# cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/enable
0
# cat /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
0

---- basic stacktrace checks
     - both counted and not
     - trigger filter

# echo 'stacktrace' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger

# cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
stacktrace:unlimited
# cat /sys/kernel/debug/tracing/trace

# echo '!stacktrace' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
# echo > /sys/kernel/debug/tracing/trace

# echo 'stacktrace:5 if bytes_req >= 512' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
# cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
stacktrace:count=0 if bytes_req >= 512

# cat /sys/kernel/debug/tracing/trace

# echo '!stacktrace:5 if bytes_req >= 512' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
# cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
# echo 'stacktrace:5 if bytes_req >= 65536' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
# cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
stacktrace:count=5 if bytes_req >= 65536

# echo '!stacktrace:5' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger

---- basic snapshot
     - enable all block events, capture leadup to event
     - snapshot with filter

# echo 1 > /sys/kernel/debug/tracing/events/block/enable
# echo 'snapshot:1 if nr_rq > 1' > /sys/kernel/debug/tracing/events/block/block_unplug/trigger

# cat /sys/kernel/debug/tracing/snapshot

# cat /sys/kernel/debug/tracing/events/block/block_unplug/trigger
# cat /sys/kernel/debug/tracing/events/block/block_unplug/enable
1*
# echo '!snapshot:1 if nr_rq > 1' > /sys/kernel/debug/tracing/events/block/block_unplug/trigger
# cat /sys/kernel/debug/tracing/events/block/block_unplug/trigger
# cat /sys/kernel/debug/tracing/events/block/block_unplug/enable
1

---- basic traceon/traceoff
     - enable all block events, capture leadup to event
     - traceoff with filter

# echo 'traceoff:1 if nr_rq > 1' > /sys/kernel/debug/tracing/events/block/block_unplug/trigger
# cat /sys/kernel/debug/tracing/events/block/block_unplug/trigger
# cat /sys/kernel/debug/tracing/events/block/block_unplug/enable

# cat /sys/kernel/debug/tracing/trace

# cat /sys/kernel/debug/tracing/tracing_on
0
# echo '!traceoff:1 if nr_rq > 1' > /sys/kernel/debug/tracing/events/block/block_unplug/trigger
# cat /sys/kernel/debug/tracing/events/block/block_unplug/enable
1
# echo 0 > /sys/kernel/debug/tracing/events/block/enable
# cat /sys/kernel/debug/tracing/events/block/block_unplug/enable

# echo 1 > /sys/kernel/debug/tracing/tracing_on

---- multi buffer non-syscall filter test

echo > /sys/kernel/debug/tracing/trace

echo 'bytes_alloc > 8192' > /sys/kernel/debug/tracing/events/kmem/kmalloc/filter
cat /sys/kernel/debug/tracing/events/kmem/kmalloc/filter
bytes_alloc > 8192
mkdir /sys/kernel/debug/tracing/instances/test1
echo 'bytes_alloc > 2048' > /sys/kernel/debug/tracing/instances/test1/events/kmem/kmalloc/filter
cat /sys/kernel/debug/tracing/events/kmem/kmalloc/filter
bytes_alloc > 8192
cat /sys/kernel/debug/tracing/instances/test1/events/kmem/kmalloc/filter
bytes_alloc > 2048

echo 1 > /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
cat /sys/kernel/debug/tracing/trace

echo 1 > /sys/kernel/debug/tracing/instances/test1/events/kmem/kmalloc/enable
cat /sys/kernel/debug/tracing/instances/test1/trace

echo 0 > /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
echo 0 > /sys/kernel/debug/tracing/instances/test1/events/kmem/kmalloc/enable
echo 0 > /sys/kernel/debug/tracing/events/kmem/kmalloc/filter
echo 0 > /sys/kernel/debug/tracing/instances/test1/events/kmem/kmalloc/filter

rmdir /sys/kernel/debug/tracing/instances/test1

--- multi buffer filter test

echo > /sys/kernel/debug/tracing/trace

echo 'count > 65536' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/filter
echo 1 > /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/enable
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/filter
cat /sys/kernel/debug/tracing/trace

mkdir /sys/kernel/debug/tracing/instances/test1

echo 'count > 4096' > /sys/kernel/debug/tracing/instances/test1/events/syscalls/sys_enter_read/filter
echo 1 > /sys/kernel/debug/tracing/instances/test1/events/syscalls/sys_enter_read/enable
cat /sys/kernel/debug/tracing/instances/test1/events/syscalls/sys_enter_read/filter
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/filter
cat /sys/kernel/debug/tracing/instances/test1/trace
cat /sys/kernel/debug/tracing/trace

echo 0 > /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/filter
echo 0 > /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/enable

rmdir /sys/kernel/debug/tracing/instances/test1

---- multi-buffer trigger enable

# mkdir /sys/kernel/debug/tracing/instances/hoge
# echo 'enable_event:mce:mce_record' > /sys/kernel/debug/tracing/instances/hoge/events/syscalls/sys_enter_symlink/trigger
# cat /sys/kernel/debug/tracing/instances/hoge/events/syscalls/sys_enter_symlink/enable
0*
# cat /sys/kernel/debug/tracing/instances/hoge/events/mce/mce_record/enable
0*
# cat /sys/kernel/debug/tracing/events/mce/mce_record/enable
0
# ln -sf /dev/null /tmp
# cat /sys/kernel/debug/tracing/instances/hoge/events/mce/mce_record/enable
1*
# cat /sys/kernel/debug/tracing/events/mce/mce_record/enable
0

# rmdir /sys/kernel/debug/tracing/instances/hoge

---- enabled plus trigger test
     - verify triggers work on enabled event

echo > /sys/kernel/debug/tracing/trace

echo 1 > /sys/kernel/debug/tracing/events/syscalls/sys_enter_fsync/enable
echo 'stacktrace' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_fsync/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_fsync/trigger

# do an emacs save to test fsync

cat /sys/kernel/debug/tracing/trace

echo 0 > /sys/kernel/debug/tracing/events/syscalls/sys_enter_fsync/enable
echo '!stacktrace' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_fsync/trigger

---- multi-event trigger test, stack + enable
     - verify multiple triggers on single event

echo > /sys/kernel/debug/tracing/trace

# registers syscall tracepoint
echo 'stacktrace' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
echo 'enable_event:kmem:kmalloc:1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger

# do a perf stat to test

cat /sys/kernel/debug/tracing/trace

cat /sys/kernel/debug/tracing/events/kmem/kmalloc/enable

echo 0 > /sys/kernel/debug/tracing/events/kmem/kmalloc/enable

echo '!stacktrace' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
echo '!enable_event:kmem:kmalloc:1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger

---- multi-event trigger test, two enables
     - verify multiple enable_event triggers on single event

echo > /sys/kernel/debug/tracing/trace

# registers syscall tracepoint
echo 'enable_event:kmem:kmalloc:1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
echo 'enable_event:kmem:kfree:1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger

# do a perf stat to test

cat /sys/kernel/debug/tracing/trace

cat /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
cat /sys/kernel/debug/tracing/events/kmem/kfree/enable

echo 0 > /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
echo 0 > /sys/kernel/debug/tracing/events/kmem/kfree/enable

echo '!enable_event:kmem:kmalloc:1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
echo '!enable_event:kmem:kfree:1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger

---- multi-event trigger test, two enables, one with filter
     - verify multiple enable_event triggers with filters
     - also verify when only one triggers, other filtered out
     - also verify no multiple same-type events

echo > /sys/kernel/debug/tracing/trace

# registers syscall tracepoint
echo 'enable_event:kmem:kmalloc:1 if common_preempt_count == 2' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
# just to test that same event set with different filter or same event with different count can't be set
echo 'enable_event:kmem:kmalloc:1 if common_preempt_count == 1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
echo 'enable_event:kmem:kmalloc if common_preempt_count == 1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
  echo: write error: File exists
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/enable
cat /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
echo 'enable_event:kmem:kfree:1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger

# do a perf stat to test
cat /sys/kernel/debug/tracing/trace

echo '!enable_event:kmem:kmalloc:1 if common_preempt_count == 2' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
echo 'enable_event:kmem:kmalloc:1 if common_preempt_count == 1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger

# do a perf stat to test
cat /sys/kernel/debug/tracing/trace

echo '!enable_event:kmem:kmalloc:1 if common_preempt_count == 1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
echo 'enable_event:kmem:kmalloc:1 if common_preempt_count <= 1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger

# do a perf stat to test
cat /sys/kernel/debug/tracing/trace

echo '!enable_event:kmem:kmalloc:1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
echo '!enable_event:kmem:kfree:1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger

cat /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
cat /sys/kernel/debug/tracing/events/kmem/kfree/enable

echo 0 > /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
echo 0 > /sys/kernel/debug/tracing/events/kmem/kfree/enable

---- multi-event trigger test, two non-enable
     - multiple non-enable/disable triggers

echo > /sys/kernel/debug/tracing/trace

# registers syscall tracepoint
echo 'stacktrace' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
echo 'snapshot' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger

# do a perf stat to test
cat /sys/kernel/debug/tracing/trace
cat /sys/kernel/debug/tracing/snapshot

echo '!stacktrace' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
echo '!snapshot' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger
cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_perf_event_open/trigger

---- multi-event trigger test, two non-enable on non-syscall, one with filter
     - verify multiple triggers on non-syscall event
     - one with filter
     - general removal syntax on counted

echo > /sys/kernel/debug/tracing/trace

# registers syscall tracepoint
echo 'stacktrace:5' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
echo 'snapshot:5 if bytes_req >= 4096' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger

cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger

cat /sys/kernel/debug/tracing/trace
cat /sys/kernel/debug/tracing/snapshot

echo '!stacktrace' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
echo '!snapshot' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger

---- kprobes - basic check
     - stacktrace triggered by kprobe

echo > /sys/kernel/debug/tracing/trace
perf probe -a in_kmalloc=__kmalloc
echo 'stacktrace' > /sys/kernel/debug/tracing/events/probe/in_kmalloc/trigger
perf record -e probe:in_kmalloc -aR sleep 10&
perf report
cat /sys/kernel/debug/tracing/trace
cat /sys/kernel/debug/tracing/events/probe/in_kmalloc/trigger
echo '!stacktrace' > /sys/kernel/debug/tracing/events/probe/in_kmalloc/trigger
perf probe -d in_kmalloc

---- kprobes - enable normal event from kprobe event

echo > /sys/kernel/debug/tracing/trace
perf probe -a in_kmalloc=__kmalloc
echo 'enable_event:kmem:kfree:1' > /sys/kernel/debug/tracing/events/probe/in_kmalloc/trigger
cat /sys/kernel/debug/tracing/trace
cat /sys/kernel/debug/tracing/events/probe/in_kmalloc/trigger
echo '!enable_event:kmem:kfree:1' > /sys/kernel/debug/tracing/events/probe/in_kmalloc/trigger
cat /sys/kernel/debug/tracing/events/kmem/kfree/enable
echo 0 > /sys/kernel/debug/tracing/events/kmem/kfree/enable
perf probe -d in_kmalloc

---- kprobes - enable kprobe event from normal event

echo > /sys/kernel/debug/tracing/trace
perf probe -a in_kmalloc=__kmalloc
echo 'enable_event:probe:in_kmalloc:1' > /sys/kernel/debug/tracing/events/kmem/kfree/trigger
cat /sys/kernel/debug/tracing/trace
cat /sys/kernel/debug/tracing/events/kmem/kfree/trigger
cat /sys/kernel/debug/tracing/events/probe/in_kmalloc/enable
echo 0 > /sys/kernel/debug/tracing/events/probe/in_kmalloc/enable
echo '!enable_event:probe:in_kmalloc:1' > /sys/kernel/debug/tracing/events/kmem/kfree/trigger
perf probe -d in_kmalloc


