Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3H0D4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:56:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:1076 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab3H0D4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:56:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,965,1367996400"; 
   d="scan'208";a="287149841"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v7 00/10] tracing: trace event triggers
Date: Mon, 26 Aug 2013 22:55:57 -0500
Message-Id: <cover.1377573424.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is v7 of the trace event triggers patchset.  This version mainly
moves some code between patches to fix some bisectibity problems, but
also adds a couple minor cleanups and variable naming changes
mentioned by Masami Hiramatsu.

v7:
 - moved find_event_file() extern declartion to patch 06.
 - moved helper functions from patch 02 to 03, where they're first
   used.
 - removed copies of cmd_ops fields from trigger_data and changed to
   use cmd_ops diretly instead.
 - renamed trigger_mode to trigger_type to avoid confusion with the
   FTRACE_EVENT_FL_TRIGGER_MODE_BIT bitflag, and fixed up
   usage/documentation, etc.

v6:
 - fixed up the conflicts in trace_events.c related to the actual
   creation of the per-event 'trigger' files.

v5:
 - got rid of the trigger_iterator, a vestige of the first patchset,
   which attempted to abstract the ftrace_iterator for triggers, and
   cleaned up related code simplified as a result.
 - replaced the void *cmd_data everywhere with ftrace_event_file *,
   another vestige of the initial patchset.
 - updated the patchset to use event_file_data() to grab the i_private
   ftrace_event_files where appropriate (this was a separate patch in
   the previous patchset, but was merged into the basic framework
   patch as suggested by Masami.  The only interesting part about this
   is that it moved event_file_data() from kernel/trace/trace_events.c
   to kernel/trace/trace.h so it can be used in
   e.g. trace_events_trigger.c as well.)
 - add missing grab of event_mutex in event_trigger_regex_write().
 - realized when making the above changes that the trigger filters
   weren't being freed when the trigger was freed, so added a
   trigger_data_free() to do that.  It also ensures that trigger_data
   won't be freed until nothing is using it.
 - added clear_event_triggers(), which clears all triggers in a trace
   array (and soft-disable associated with event_enable/disable
   events).
 - added a comment to ftrace_syscall_enter/exit to document the use of
   rcu_dereference_raw() there.

v4:
 - made some changes to the soft-disable for syscall patch, according
   to Masami's suggestions.  Actually, since there's now an array of
   ftrace_files for syscalls that can serve the same purpose, the
   enabled_enter/exit_syscalls bit arrays became redundant and were
   removed.
 - moved all the remaining common functions out of the
   traceon/traceoff patch and into the basic trigger framework patch
   and added comments to all the common functions.
 - extensively commented the event_trigger_ops and event_command ops.
 - made the register/unregister_command functions __init.  Since that
   code was originally inspired by similar ftrace code, a new patch
   was added to do the same thing for the register/unregister of the
   ftrace commands (patch 10/11).
 - fixed the event_trigger_regex_open i_private problem noted by
   Masami that's currently being addressed by Oleg Nesterov's fixes
   for this.  Note that that patchset also affects patch 8/11 (update
   filters for multi-buffer, since it touches event filters as well).
   Patch 11/11 depends on that patchset and also moves
   event_file_data() to trace.h.b

v3:
 - added a new patch to the series (patch 8/9 - update event filters
   for multibuffer) to bring the event filters up-to-date wrt the
   multibuffer changes - without this patch, the same filter is
   applied to all buffers regardless of which instance sets it; this
   patch allows you to set per-instance filters as you'd expect.  The
   one exception to this is the 'ftrace subsystem' events, which are
   special and retain their current behavior.
 - changed the syscall soft enabling to keep a per-trace-array array
   of trace_event_files alongside the 'enabled' bitmaps there.  This
   keeps them in a place where they're only allocated for tracing
   and which I think addresses all the previous comments for that
   patch.

v2:
 - removed all changes to __ftrace_event_enable_disable() (except
   for patch 04/11 which clears the soft_disabled bit as discussed)
   and created a separate trace_event_trigger_enable_disable() that
   calls it after setting/clearing the TRIGGER_MODE_BIT.
 - added a trigger_mode enum for future patches that break up the
   trigger calls for filtering, but that's also now used as a command
   id for registering/unregistering commands.
 - removed the enter_file/exit_file members that were added to
   syscall_metadata after realizing that they were unnecessary if
   ftrace_syscall_enter/exit() were modified to receive a pointer
   to the ftrace_file instead of the pointer to the trace_array in
   the ftrace_file.
 - broke up the trigger invocation into two parts so that triggers
   like 'stacktrace' that themselves log into the trace buffer can
   defer the actual trigger invocation until after the current
   record is closed, which is needed for the filter check that
   in turn determines whether the trigger gets invoked.
 - other minor cleanup


This patchset implements 'trace event triggers', which are similar to
the function triggers implemented for 'ftrace filter commands' (see
'Filter commands' in Documentation/trace/ftrace.txt), but instead of
being invoked from function calls are invoked by trace events.
Basically the patchset allows 'commands' to be triggered whenever a
given trace event is hit.  The set of commands implemented by this
patchset are:

 - enable/disable_event - enable or disable another event whenever
   the trigger event is hit

 - stacktrace - dump a stacktrace to the trace buffer whenever the
   trigger event is hit

 - snapshot - create a snapshot of the current trace buffer whenever
   the trigger event is hit

 - traceon/traceoff - turn tracing on or off whenever the trigger
   event is hit

Triggers can also be conditionally invoked by associating a standard
trace event filter with them - if the given event passes the filter,
the trigger is invoked, otherwise it's not. (see 'Event filtering' in
Documentation/trace/events.txt for info on event filters).

See the last patch in the series for more complete documention on
event triggers and the available trigger commands, and below for some
simple examples of each of the above commands along with conditional
filtering.

The first four patches are bugfix patches or minor improvements which
can be applied regardless; the rest contain the basic framework and
implementations for each command.

This patchset was based on some ideas from Steve Rostedt, which he
outlined during a couple discussions at ELC and follow-on e-mails.
Code- and interface-wise, it's also partially based on the existing
function triggers implementation and essentially works on top of the
SOFT_DISABLE mode introduced for that.  Both Steve and Masami
Hiramatsu took a look at a couple early versions of this patchset, and
offered some very useful suggestions reflected in this patchset -
thanks to them both for the ideas and for taking the time to do some
basic sanity reviews!

Below are a few concrete examples demonstrating each of the available
commands.

The first example attempts to capture all the kmalloc events that
happen as a result of reading a particular file.

The first part of the set of commands below adds a kmalloc
'enable_event' trigger to the sys_enter_read trace event - as a
result, when the sys_enter_read event occurs, kmalloc events are
enabled, resulting in those kmalloc events getting logged into the
trace buffer.  The :1 at the end of the kmalloc enable_event specifies
that the enabling of kmalloc events on sys_enter_read will only happen
once - subsequent reads won't trigger the kmalloc logging.  The next
part of the example reads a test file, which triggers the
sys_enter_read tracepoint and thus turns on the kmalloc events, and
once done, adds a trigger to sys_exit_read that disables kmalloc
events.  The disable_event doesn't have a :1 appended, which means it
happens on every sys_exit_read.

# echo 'enable_event:kmem:kmalloc:1' > \
  /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/trigger; \
  cat ~/junk.txt > /dev/null; \
  echo 'disable_event:kmem:kmalloc' > \
  /sys/kernel/debug/tracing/events/syscalls/sys_exit_read/trigger

Just to show a bit of what happens under the covers, if we display the
kmalloc 'enable' file, we see that it's 'soft disabled' (the asterisk
after the enable flag).  This means that it's actually enabled but is
in the SOFT_DISABLED state, and is essentially held back from actually
logging anything to the trace buffer, but can be made to log into the
buffer by simply flipping a bit :

# cat /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
0*

If we look at the 'enable' file for the triggering sys_enter_read
trace event, we can see that it also has the 'soft disable' flag set.
This is because in the case of the triggering event, we also need to
have the trace event invoked regardless of whether or not its actually
being logged, so we can process the triggers.  This functionality is
also built on top of the SOFT_DISABLE flag and is reflected in the
enable state as well:

# cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/enable
0*

To find out which triggers are set for a particular event, we can look
at the 'trigger' file for the event.  Here's what the 'trigger' file
for the sys_enter_read event looks like:

# cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/trigger
enable_event:kmem:kmalloc:count=0

The 'count=0' field at the end shows that this trigger has no more
triggering ability left - it's essentially fired all its shots - if
it was still active, it would have a non-zero count.

Looking at the sys_exit_read, we see that since we didn't specify a
number at the end, the number of times it can fire is unlimited:

# cat /sys/kernel/debug/tracing/events/syscalls/sys_exit_read/trigger
disable_event:kmem:kmalloc:unlimited

# cat /sys/kernel/debug/tracing/events/syscalls/sys_exit_read/enable
0*

Finally, let's look at the results of the above set of commands by
cat'ing the 'trace' file:

# cat /sys/kernel/debug/tracing/trace

# tracer: nop
#
# entries-in-buffer/entries-written: 85/85   #P:4
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
             cat-2596  [001] ....   374.518849: kmalloc: call_site=ffffffff812de707 ptr=ffff8800306b9290 bytes_req=2 bytes_alloc=8 gfp_flags=GFP_KERNEL|GFP_ZERO
             cat-2596  [001] ....   374.518956: kmalloc: call_site=ffffffff81182a12 ptr=ffff88010c8e1500 bytes_req=256 bytes_alloc=256 gfp_flags=GFP_KERNEL|GFP_ZERO
             cat-2596  [001] ....   374.518959: kmalloc: call_site=ffffffff812d8e49 ptr=ffff88003002a200 bytes_req=32 bytes_alloc=32 gfp_flags=GFP_KERNEL|GFP_ZERO
             cat-2596  [001] ....   374.518960: kmalloc: call_site=ffffffff812de707 ptr=ffff8800306b9088 bytes_req=2 bytes_alloc=8 gfp_flags=GFP_KERNEL|GFP_ZERO
             cat-2596  [003] ....   374.519063: kmalloc: call_site=ffffffff812d9f50 ptr=ffff8800b793fd00 bytes_req=256 bytes_alloc=256 gfp_flags=GFP_KERNEL
             cat-2596  [003] ....   374.519119: kmalloc: call_site=ffffffff811cc3bc ptr=ffff8800b7918900 bytes_req=128 bytes_alloc=128 gfp_flags=GFP_KERNEL
             cat-2596  [003] ....   374.519122: kmalloc: call_site=ffffffff811cc4d2 ptr=ffff880030404800 bytes_req=504 bytes_alloc=512 gfp_flags=GFP_KERNEL
             cat-2596  [003] ....   374.519125: kmalloc: call_site=ffffffff811cc64e ptr=ffff88003039d8a0 bytes_req=28 bytes_alloc=32 gfp_flags=GFP_KERNEL
.
.
.
            Xorg-1194  [000] ....   374.543956: kmalloc: call_site=ffffffffa03a8599 ptr=ffff8800ba23b700 bytes_req=112 bytes_alloc=128 gfp_flags=GFP_TEMPORARY|GFP_NOWARN|GFP_NORETRY
            Xorg-1194  [000] ....   374.543961: kmalloc: call_site=ffffffffa03a7639 ptr=ffff8800b7905b40 bytes_req=56 bytes_alloc=64 gfp_flags=GFP_TEMPORARY|GFP_ZERO
            Xorg-1194  [000] ....   374.543973: kmalloc: call_site=ffffffffa039f716 ptr=ffff8800b7905ac0 bytes_req=64 bytes_alloc=64 gfp_flags=GFP_KERNEL
.
.
.
          compiz-1769  [002] ....   374.547586: kmalloc: call_site=ffffffffa03a8599 ptr=ffff8800ba320400 bytes_req=952 bytes_alloc=1024 gfp_flags=GFP_TEMPORARY|GFP_NOWARN|GFP_NORETRY
          compiz-1769  [002] ....   374.547592: kmalloc: call_site=ffffffffa03a7639 ptr=ffff8800bd5f7400 bytes_req=280 bytes_alloc=512 gfp_flags=GFP_TEMPORARY|GFP_ZERO
          compiz-1769  [002] ....   374.547623: kmalloc: call_site=ffffffffa039f716 ptr=ffff8800b792d580 bytes_req=64 bytes_alloc=64 gfp_flags=GFP_KERNEL
.
.
.
             cat-2596  [000] ....   374.646019: kmalloc: call_site=ffffffff8123df9f ptr=ffff8800ba2f2900 bytes_req=96 bytes_alloc=96 gfp_flags=GFP_NOFS|GFP_ZERO
             cat-2596  [000] ....   374.648263: kmalloc: call_site=ffffffff8123df9f ptr=ffff8800ba2f2900 bytes_req=96 bytes_alloc=96 gfp_flags=GFP_NOFS|GFP_ZERO
             cat-2596  [000] ....   374.650503: kmalloc: call_site=ffffffff8123df9f ptr=ffff8800ba2f2900 bytes_req=96 bytes_alloc=96 gfp_flags=GFP_NOFS|GFP_ZERO
.
.
.
            bash-2425  [002] ....   374.654923: kmalloc: call_site=ffffffff8123df9f ptr=ffff8800b7a28780 bytes_req=96 bytes_alloc=96 gfp_flags=GFP_NOFS|GFP_ZERO
        rsyslogd-974   [002] ....   374.655163: kmalloc: call_site=ffffffff81046ae6 ptr=ffff8800ba320400 bytes_req=1024 bytes_alloc=1024 gfp_flags=GFP_KERNEL

As you can see, we captured all the kmallocs from our 'cat' reads, but
also any other kmallocs that happened for other processes between the
time we turned on kmalloc events and turned them off.  Future work
should add a way to screen out unwanted events e.g. the abilitiy to
capture the triggering pid in a simple variable and use that variable
in event filters to screen out other pids.

To turn off the events we turned on, simply reinvoke the commands
prefixed by '!':

# echo '!enable_event:kmem:kmalloc:1' > /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/trigger
# echo '!disable_event:kmem:kmalloc' > /sys/kernel/debug/tracing/events/syscalls/sys_exit_read/trigger

You can verify that the events have been turned off by again examining
the 'enable' and 'trigger' files:

# cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/trigger
# cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/enable
0
# cat /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
0


The next example shows how to use the 'stacktrace' command.  To have a
stacktrace logged every time a particular event occurs, simply echo
'stacktrace' into the 'trigger' file for that event:

# echo 'stacktrace' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger

# cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
stacktrace:unlimited

Looking at the 'trace' output, we indeed see stack traces for every
kmalloc:

# cat /sys/kernel/debug/tracing/trace

          compiz-1769  [003] ....  2422.614630: <stack trace>
 => i915_add_request
 => i915_gem_do_execbuffer.isra.15
 => i915_gem_execbuffer2
 => drm_ioctl
 => do_vfs_ioctl
 => SyS_ioctl
 => system_call_fastpath
            Xorg-1194  [002] ....  2422.619076: <stack trace>
 => drm_wait_vblank
 => drm_ioctl
 => do_vfs_ioctl
 => SyS_ioctl
 => system_call_fastpath
            Xorg-1194  [000] ....  2422.625823: <stack trace>
 => i915_gem_execbuffer2
 => drm_ioctl
 => do_vfs_ioctl
 => SyS_ioctl
 => system_call_fastpath
.
.
.
            bash-2842  [001] ....  2423.002059: <stack trace>
 => __tracing_open
 => tracing_open
 => do_dentry_open
 => finish_open
 => do_last
 => path_openat
 => do_filp_open
 => do_sys_open
 => SyS_open
 => system_call_fastpath
            bash-2842  [001] ....  2423.002070: <stack trace>
 => __tracing_open
 => tracing_open
 => do_dentry_open
 => finish_open
 => do_last
 => path_openat
 => do_filp_open
 => do_sys_open
 => SyS_open
 => system_call_fastpath

For an event like kmalloc, however, we don't typically want to see a
stack trace for every single event, since the amount of data produced
is overwhelming.  What we'd typically want to do is only log a stack
trace for particular events of interest.  We can accomplish that by
appending an 'event filter' to the trigger.  The event filters used to
filter triggers are exactly the same as those implemented for the
existing trace event 'filter' files - see the trace event
documentation for details.

First, let's turn off the existing stacktrace event, and clear the
trace buffer:

# echo '!stacktrace' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
# echo > /sys/kernel/debug/tracing/trace

Now, we can add a new stacktrace trigger which will fire 5 times, but
only if the number of bytes requested by the caller was greater than
or equal to 512:

# echo 'stacktrace:5 if bytes_req >= 512' > \
     /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger

# cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
stacktrace:count=0 if bytes_req >= 512

>From looking at the trigger, we can see the event fired 5 times
(count=0) and looking at the 'trace' file, we can verify that:

# cat trace
# tracer: nop
#
# entries-in-buffer/entries-written: 5/5   #P:4
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
        rsyslogd-974   [000] ....  1796.412997: <stack trace>
 => kmem_cache_alloc_trace
 => do_syslog
 => kmsg_read
 => proc_reg_read
 => vfs_read
 => SyS_read
 => system_call_fastpath
          compiz-1769  [000] ....  1796.427342: <stack trace>
 => __kmalloc
 => i915_gem_execbuffer2
 => drm_ioctl
 => do_vfs_ioctl
 => SyS_ioctl
 => system_call_fastpath
            Xorg-1194  [003] ....  1796.441251: <stack trace>
 => __kmalloc
 => i915_gem_execbuffer2
 => drm_ioctl
 => do_vfs_ioctl
 => SyS_ioctl
 => system_call_fastpath
            Xorg-1194  [003] ....  1796.441392: <stack trace>
 => __kmalloc
 => sg_kmalloc
 => __sg_alloc_table
 => sg_alloc_table
 => i915_gem_object_get_pages_gtt
 => i915_gem_object_get_pages
 => i915_gem_object_pin
 => i915_gem_execbuffer_reserve_object.isra.11
 => i915_gem_execbuffer_reserve
 => i915_gem_do_execbuffer.isra.15
 => i915_gem_execbuffer2
 => drm_ioctl
 => do_vfs_ioctl
 => SyS_ioctl
 => system_call_fastpath
            Xorg-1194  [003] ....  1796.441672: <stack trace>
 => __kmalloc
 => i915_gem_execbuffer2
 => drm_ioctl
 => do_vfs_ioctl
 => SyS_ioctl
 => system_call_fastpath

So the trace output shows exactly 5 stacktraces, as expected.

Just for comparison, let's look at an event that's harder to trigger,
to see a count that isn't 0 in the trigger description:

# echo 'stacktrace:5 if bytes_req >= 65536' > \
     /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger

# cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
stacktrace:count=5 if bytes_req >= 65536


The next example shows how to use the 'snapshot' command to capture a
snapshot of the trace buffer when an 'interesting' event occurs.

In this case, we'll first start the entire block subsystem tracing:

# echo 1 > /sys/kernel/debug/tracing/events/block/enable

Next, we add a 'snapshot' trigger that will take a snapshot of all the
events leading up to the particular event we're interested in, which
is a block queue unplug with a depth > 1.  In this case we're
interested in capturing the snapshot just one time, the first time it
occurs:

# echo 'snapshot:1 if nr_rq > 1' > \
     /sys/kernel/debug/tracing/events/block/block_unplug/trigger

It may take awhile for the condition to occur, but once it does, we
can see the entire sequence of block events leading up to in in the
'snapshot' file:

# cat /sys/kernel/debug/tracing/snapshot

     jbd2/sdb1-8-278   [001] ....   382.075012: block_bio_queue: 8,16 WS 629429976 + 8 [jbd2/sdb1-8]
     jbd2/sdb1-8-278   [001] ....   382.075012: block_bio_backmerge: 8,16 WS 629429976 + 8 [jbd2/sdb1-8]
     jbd2/sdb1-8-278   [001] d...   382.075015: block_rq_insert: 8,16 WS 0 () 629429912 + 72 [jbd2/sdb1-8]
     jbd2/sdb1-8-278   [001] d...   382.075030: block_rq_issue: 8,16 WS 0 () 629429912 + 72 [jbd2/sdb1-8]
     jbd2/sdb1-8-278   [001] d...   382.075044: block_unplug: [jbd2/sdb1-8] 1
          <idle>-0     [000] ..s.   382.075310: block_rq_complete: 8,16 WS () 629429912 + 72 [0]
     jbd2/sdb1-8-278   [000] ....   382.075407: block_touch_buffer: 8,17 sector=78678492 size=4096
     jbd2/sdb1-8-278   [000] ....   382.075413: block_bio_remap: 8,16 FWFS 629429984 + 8 <- (8,17) 629427936
     jbd2/sdb1-8-278   [000] ....   382.075415: block_bio_queue: 8,16 FWFS 629429984 + 8 [jbd2/sdb1-8]
     jbd2/sdb1-8-278   [000] ....   382.075418: block_getrq: 8,16 FWFS 629429984 + 8 [jbd2/sdb1-8]
     jbd2/sdb1-8-278   [000] d...   382.075421: block_rq_insert: 8,16 FWFS 0 () 629429984 + 8 [jbd2/sdb1-8]
     jbd2/sdb1-8-278   [000] d...   382.075424: block_rq_issue: 8,16 FWS 0 () 18446744073709551615 + 0 [jbd2/sdb1-8]
          <idle>-0     [000] dNs.   382.115912: block_rq_issue: 8,16 WS 0 () 629429984 + 8 [swapper/0]
          <idle>-0     [000] ..s.   382.116059: block_rq_complete: 8,16 WS () 629429984 + 8 [0]
          <idle>-0     [000] dNs.   382.116079: block_rq_issue: 8,16 FWS 0 () 18446744073709551615 + 0 [swapper/0]
          <idle>-0     [000] d.s.   382.131030: block_rq_complete: 8,16 WS () 629429984 + 0 [0]
     jbd2/sdb1-8-278   [000] ....   382.131106: block_dirty_buffer: 8,17 sector=26 size=4096
     jbd2/sdb1-8-278   [000] ....   382.131111: block_dirty_buffer: 8,17 sector=106954757 size=4096
.
.
.
   kworker/u16:3-66    [002] ....   387.144505: block_bio_remap: 8,16 WM 2208 + 8 <- (8,17) 160
   kworker/u16:3-66    [002] ....   387.144512: block_bio_queue: 8,16 WM 2208 + 8 [kworker/u16:3]
   kworker/u16:3-66    [002] ....   387.144522: block_getrq: 8,16 WM 2208 + 8 [kworker/u16:3]
   kworker/u16:3-66    [002] ....   387.144525: block_plug: [kworker/u16:3]
   kworker/u16:3-66    [002] ....   387.144530: block_bio_remap: 8,16 WM 2216 + 8 <- (8,17) 168
   kworker/u16:3-66    [002] ....   387.144531: block_bio_queue: 8,16 WM 2216 + 8 [kworker/u16:3]
   kworker/u16:3-66    [002] ....   387.144533: block_bio_backmerge: 8,16 WM 2216 + 8 [kworker/u16:3]
.
.
.
   kworker/u16:3-66    [002] d...   387.144631: block_rq_insert: 8,16 WM 0 () 2208 + 16 [kworker/u16:3]
   kworker/u16:3-66    [002] d...   387.144636: block_rq_insert: 8,16 WM 0 () 2256 + 16 [kworker/u16:3]
   kworker/u16:3-66    [002] d...   387.144638: block_rq_insert: 8,16 WM 0 () 662702080 + 8 [kworker/u16:3]
   kworker/u16:3-66    [002] d...   387.144640: block_rq_insert: 8,16 WM 0 () 683673680 + 8 [kworker/u16:3]
   kworker/u16:3-66    [002] d...   387.144641: block_rq_insert: 8,16 WM 0 () 729812344 + 8 [kworker/u16:3]
   kworker/u16:3-66    [002] d...   387.144642: block_rq_insert: 8,16 WM 0 () 729828896 + 8 [kworker/u16:3]
   kworker/u16:3-66    [002] d...   387.144643: block_rq_insert: 8,16 WM 0 () 730599480 + 8 [kworker/u16:3]
   kworker/u16:3-66    [002] d...   387.144644: block_rq_insert: 8,16 WM 0 () 855640104 + 8 [kworker/u16:3]
   kworker/u16:3-66    [002] d...   387.144645: block_rq_insert: 8,16 WM 0 () 880805984 + 8 [kworker/u16:3]
   kworker/u16:3-66    [002] d...   387.144646: block_rq_insert: 8,16 WM 0 () 1186990400 + 8 [kworker/u16:3]
   kworker/u16:3-66    [002] d...   387.144649: block_unplug: [kworker/u16:3] 10


The final example shows something very similer but using the
'traceoff' command to stop tracing when an 'interesting' event occurs.
The traceon and traceoff commands can be used together to toggle
tracing on and off in creative ways to capture different traces in the
'trace' buffer, but this example just shows essentially the same use
case as the previous example but using 'traceoff' to capture trace
data of interest in the standard 'trace' buffer.

Again, we'll start the entire block subsystem tracing:

# echo 1 > /sys/kernel/debug/tracing/events/block/enable

# echo 'traceoff:1 if nr_rq > 1' > \
     /sys/kernel/debug/tracing/events/block/block_unplug/trigger

# cat /sys/kernel/debug/tracing/trace

   kworker/u16:4-67    [000] ....   803.003670: block_bio_remap: 8,16 WM 2208 + 8 <- (8,17) 160
   kworker/u16:4-67    [000] ....   803.003670: block_bio_queue: 8,16 WM 2208 + 8 [kworker/u16:4]
   kworker/u16:4-67    [000] ....   803.003672: block_getrq: 8,16 WM 2208 + 8 [kworker/u16:4]
   kworker/u16:4-67    [000] ....   803.003674: block_bio_remap: 8,16 WM 2216 + 8 <- (8,17) 168
   kworker/u16:4-67    [000] ....   803.003675: block_bio_queue: 8,16 WM 2216 + 8 [kworker/u16:4]
   kworker/u16:4-67    [000] ....   803.003676: block_bio_backmerge: 8,16 WM 2216 + 8 [kworker/u16:4]
   kworker/u16:4-67    [000] ....   803.003678: block_bio_remap: 8,16 WM 2232 + 8 <- (8,17) 184
   kworker/u16:4-67    [000] ....   803.003678: block_bio_queue: 8,16 WM 2232 + 8 [kworker/u16:4]
   kworker/u16:4-67    [000] ....   803.003680: block_getrq: 8,16 WM 2232 + 8 [kworker/u16:4]
.
.
.
   kworker/u16:4-67    [000] d...   803.003720: block_rq_insert: 8,16 WM 0 () 285223776 + 16 [kworker/u16:4]
   kworker/u16:4-67    [000] d...   803.003721: block_rq_insert: 8,16 WM 0 () 662702080 + 8 [kworker/u16:4]
   kworker/u16:4-67    [000] d...   803.003722: block_rq_insert: 8,16 WM 0 () 683673680 + 8 [kworker/u16:4]
   kworker/u16:4-67    [000] d...   803.003723: block_rq_insert: 8,16 WM 0 () 730599480 + 8 [kworker/u16:4]
   kworker/u16:4-67    [000] d...   803.003724: block_rq_insert: 8,16 WM 0 () 763365384 + 8 [kworker/u16:4]
   kworker/u16:4-67    [000] d...   803.003725: block_rq_insert: 8,16 WM 0 () 880805984 + 8 [kworker/u16:4]
   kworker/u16:4-67    [000] d...   803.003726: block_rq_insert: 8,16 WM 0 () 1186990872 + 8 [kworker/u16:4]
   kworker/u16:4-67    [000] d...   803.003727: block_rq_insert: 8,16 WM 0 () 1187057608 + 8 [kworker/u16:4]
   kworker/u16:4-67    [000] d...   803.003729: block_unplug: [kworker/u16:4] 14

The following changes since commit fc30f13b7c1b87b44ee364462c3408c913f01439:

  Merge branch 'trace/ftrace/core-tpstring' into trace/for-next (2013-08-22 12:30:55 -0400)

are available in the git repository at:


  git://git.yoctoproject.org/linux-yocto-contrib.git tzanussi/event-triggers-v6
  http://git.yoctoproject.org/cgit/cgit.cgi/linux-yocto-contrib/log/?h=tzanussi/event-triggers-v7

Tom Zanussi (10):
  tracing: Add support for SOFT_DISABLE to syscall events
  tracing: add basic event trigger framework
  tracing: add 'traceon' and 'traceoff' event trigger commands
  tracing: add 'snapshot' event trigger command
  tracing: add 'stacktrace' event trigger command
  tracing: add 'enable_event' and 'disable_event' event trigger
    commands
  tracing: add and use generic set_trigger_filter() implementation
  tracing: update event filters for multibuffer
  tracing: add documentation for trace event triggers
  tracing: make register/unregister_ftrace_command __init

 Documentation/trace/events.txt       |  207 +++++
 include/linux/ftrace.h               |    4 +-
 include/linux/ftrace_event.h         |   56 +-
 include/trace/ftrace.h               |   39 +-
 kernel/trace/Makefile                |    1 +
 kernel/trace/ftrace.c                |   12 +-
 kernel/trace/trace.c                 |   31 +-
 kernel/trace/trace.h                 |  194 ++++-
 kernel/trace/trace_branch.c          |    2 +-
 kernel/trace/trace_events.c          |   49 +-
 kernel/trace/trace_events_filter.c   |  181 ++++-
 kernel/trace/trace_events_trigger.c  | 1402 ++++++++++++++++++++++++++++++++++
 kernel/trace/trace_export.c          |    2 +-
 kernel/trace/trace_functions_graph.c |    4 +-
 kernel/trace/trace_kprobe.c          |    4 +-
 kernel/trace/trace_mmiotrace.c       |    4 +-
 kernel/trace/trace_sched_switch.c    |    4 +-
 kernel/trace/trace_syscalls.c        |   62 +-
 kernel/trace/trace_uprobe.c          |    3 +-
 19 files changed, 2142 insertions(+), 119 deletions(-)
 create mode 100644 kernel/trace/trace_events_trigger.c

-- 
1.7.11.4

