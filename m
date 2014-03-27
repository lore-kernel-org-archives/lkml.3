Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbaC0S4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 14:56:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:45854 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879AbaC0S4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 14:56:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,744,1389772800"; 
   d="scan'208";a="508446584"
Message-ID: <1395946555.10059.62.camel@empanada>
Subject: Re: [GIT PULL] tracing: Fix traceon trigger condition to actually
 turn tracing on
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 27 Mar 2014 13:55:55 -0500
In-Reply-To: <1395875849.7641.6.camel@pippen.local.home>
References: <1395839857.7667.9.camel@pippen.local.home>
	 <1395857987.10059.23.camel@empanada>
	 <1395875849.7641.6.camel@pippen.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding lkml to the Cc: for completeness - this is the 'other thread' I
mentioned in my hash triggers post, which accidentally didn't get Cc:'ed
to the list...

On Wed, 2014-03-26 at 19:17 -0400, Steven Rostedt wrote:
> On Wed, 2014-03-26 at 13:19 -0500, Tom Zanussi wrote:
> 
> > Also, if you'd be interested in adding something for your Collab Summit
> > event triggers talk, I've been working on a new trigger type called a
> > 'hash' trigger and have been using it for my own work here.  If so, I
> > can do a quick cleanup and push it somewhere...
> 
> Thanks, but I'm currently at 82 slides with what I got (for a 2 hour
> tutorial). I'm not sure I can add that. Although, I have two slides near
> the end that say "Coming in 3.15" and "Coming in 3.16". I can add this
> to the 3.16 slide. Unless you have it well tested, it may be too close

Hi Steve,

Here's the commit log for the current hash trigger command, which kind
of explains what it does, in case you need some kind of description for
it for a 'coming in 3.xx' slide.  Feel free to use whatever you want
from this...

commit 2466f73ec49fb4df65dcfd7cd85469df1a99c07d
Author: Tom Zanussi <tom.zanussi@linux.intel.com>
Date:   Sat Mar 1 12:07:27 2014 -0600

    tracing: Add 'hash' event trigger command
    
    Hash triggers allow users to continually hash events which can then be
    dumped later by simply reading the trigger file.  This is done
    strictly via one-liners and without any kind of programming language.
    
    The syntax follows the existing trigger syntax:
    
      # echo 'hash:key(s):value(s)[:sort_keys()][ if filter] > event/trigger
    
    The values used as keys and values are just the fields that define the
    trace event and available in the event's 'format' file.  For example,
    the kmalloc event:
    
    root@ie:/sys/kernel/debug/tracing/events/kmem/kmalloc# cat format
    name: kmalloc
    ID: 370
    format:
            field:unsigned short common_type;       offset:0;       size:2; signed:0;
            field:unsigned char common_flags;       offset:2;       size:1; signed:0;
            field:unsigned char common_preempt_count;       offset:3;       size:1;signed:0;
            field:int common_pid;   offset:4;       size:4; signed:1;
    
            field:unsigned long call_site;  offset:8;       size:4; signed:0;
            field:const void * ptr; offset:12;      size:4; signed:0;
            field:size_t bytes_req; offset:16;      size:4; signed:0;
            field:size_t bytes_alloc;       offset:20;      size:4; signed:0;
            field:gfp_t gfp_flags;  offset:24;      size:4; signed:0;
    
    The key can be made up of one or more of these fields and any number of
    values can specified - these are automatically tallied in the hash entry
    any time the event is hit.  Stacktraces can also be used as keys.
    
    For example, the following uses the stacktrace leading up to a kmalloc
    as the key for hashing kmalloc events.  For each hash entry a tally of
    the bytes_alloc field is kept.  Dumping out the trigger shows the sum
    of bytes allocated for each execution path that led to a kmalloc:
    
      # echo 'hash:call_site:bytes_alloc' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
      # cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
    
    key: stacktrace:
             kmem_cache_alloc_trace+0xeb/0x140
             intel_ring_begin+0xd8/0x1a0 [i915]
             gen6_ring_sync+0x3c/0x140 [i915]
             i915_gem_object_sync+0xd1/0x130 [i915]
             i915_gem_do_execbuffer.isra.21+0x632/0x10d0 [i915]
             i915_gem_execbuffer2+0xac/0x280 [i915]
             drm_ioctl+0x4e9/0x610 [drm]
             do_vfs_ioctl+0x83/0x510
             SyS_ioctl+0x91/0xb0
             system_call_fastpath+0x16/0x1b
         vals: count:1595 bytes_alloc:153120
    key: stacktrace:
             __kmalloc+0x10b/0x180
             i915_gem_do_execbuffer.isra.21+0x67a/0x10d0 [i915]
             i915_gem_execbuffer2+0xac/0x280 [i915]
             drm_ioctl+0x4e9/0x610 [drm]
             do_vfs_ioctl+0x83/0x510
             SyS_ioctl+0x91/0xb0
             system_call_fastpath+0x16/0x1b
         vals: count:2850 bytes_alloc:888736
    key: stacktrace:
             __kmalloc+0x10b/0x180
             i915_gem_execbuffer2+0x60/0x280 [i915]
             drm_ioctl+0x4e9/0x610 [drm]
             do_vfs_ioctl+0x83/0x510
             SyS_ioctl+0x91/0xb0
             system_call_fastpath+0x16/0x1b
         vals: count:2850 bytes_alloc:2560384
    key: stacktrace:
             __kmalloc+0x10b/0x180
             hid_report_raw_event+0x15b/0x450 [hid]
             hid_input_report+0x119/0x1a0 [hid]
             hid_irq_in+0x20b/0x250 [usbhid]
             __usb_hcd_giveback_urb+0x7c/0x130
             usb_giveback_urb_bh+0x96/0xe0
             tasklet_hi_action+0xd7/0xe0
             __do_softirq+0x125/0x2e0
             irq_exit+0xb5/0xc0
             do_IRQ+0x67/0x110
             ret_from_intr+0x0/0x13
             cpuidle_idle_call+0xbb/0x1f0
             arch_cpu_idle+0xe/0x30
             cpu_startup_entry+0x9f/0x240
             rest_init+0x77/0x80
             start_kernel+0x3db/0x3e8
         vals: count:5968 bytes_alloc:131296
    Totals:
        Hits: 22648
        Entries: 119
        Dropped: 0
    
    This turns the hash trigger off:
    
      # echo '!hash:stacktrace:bytes_alloc' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
    
    Stack traces, of course, are very useful but a bit of overkill for
    many uses.  For instance, suppose we just want a line per caller.
    Here, we keep a tally of bytes_alloc per caller.  Note that you don't
    need to explicitly keep a 'count' tally - counts are automatically
    tallied and displayed (and are in fact the default sort key).
    
    Also note that the raw call_site printed here isn't very useful (we'll
    remedy that later).
    
      # echo 'hash:call_site:bytes_alloc' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
    
      # cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
    
    hash:unlimited
    key: call_site:18446744071579450186 vals: count:1 bytes_alloc:64
    key: call_site:18446744071579439780 vals: count:1 bytes_alloc:64
    key: call_site:18446744071579400894 vals: count:1 bytes_alloc:1024
    key: call_site:18446744072104627352 vals: count:1 bytes_alloc:512
    key: call_site:18446744071580027351 vals: count:1 bytes_alloc:512
    key: call_site:18446744071580991590 vals: count:1 bytes_alloc:16
    key: call_site:18446744071579463899 vals: count:1 bytes_alloc:64
    key: call_site:18446744072102260685 vals: count:1 bytes_alloc:512
    key: call_site:18446744071579439821 vals: count:1 bytes_alloc:64
    key: call_site:18446744071579532598 vals: count:1 bytes_alloc:1024
    key: call_site:18446744071584838347 vals: count:1 bytes_alloc:64
    key: call_site:18446744071579450148 vals: count:1 bytes_alloc:64
    key: call_site:18446744071580886173 vals: count:2 bytes_alloc:256
    key: call_site:18446744071580886422 vals: count:2 bytes_alloc:1024
    key: call_site:18446744071580987082 vals: count:2 bytes_alloc:8192
    key: call_site:18446744071580652885 vals: count:2 bytes_alloc:128
    key: call_site:18446744071580565960 vals: count:2 bytes_alloc:512
    key: call_site:18446744071580680412 vals: count:2 bytes_alloc:64
    key: call_site:18446744071580891052 vals: count:2 bytes_alloc:1024
    key: call_site:18446744071580886777 vals: count:2 bytes_alloc:64
    key: call_site:18446744071580572594 vals: count:3 bytes_alloc:3072
    key: call_site:18446744071580592783 vals: count:3 bytes_alloc:48
    key: call_site:18446744071580679805 vals: count:3 bytes_alloc:12288
    key: call_site:18446744071582021108 vals: count:3 bytes_alloc:768
    key: call_site:18446744071580572564 vals: count:3 bytes_alloc:576
    key: call_site:18446744071581165381 vals: count:4 bytes_alloc:256
    key: call_site:18446744071580953553 vals: count:4 bytes_alloc:256
    key: call_site:18446744072102160648 vals: count:4 bytes_alloc:1024
    key: call_site:18446744071580652708 vals: count:4 bytes_alloc:4224
    key: call_site:18446744071580680238 vals: count:5 bytes_alloc:640
    key: call_site:18446744071581375333 vals: count:6 bytes_alloc:384
    key: call_site:18446744072102162313 vals: count:16 bytes_alloc:7616
    key: call_site:18446744071581165832 vals: count:24 bytes_alloc:1600
    key: call_site:18446744071582016247 vals: count:26 bytes_alloc:832
    key: call_site:18446744071580843814 vals: count:35 bytes_alloc:2240
    key: call_site:18446744071581367368 vals: count:39 bytes_alloc:3744
    key: call_site:18446744072101806931 vals: count:39 bytes_alloc:1248
    key: call_site:18446744072103721852 vals: count:89 bytes_alloc:8544
    key: call_site:18446744072101850501 vals: count:89 bytes_alloc:8544
    key: call_site:18446744072103729728 vals: count:89 bytes_alloc:17088
    key: call_site:18446744071583128580 vals: count:154 bytes_alloc:157696
    key: call_site:18446744072103573325 vals: count:643 bytes_alloc:10288
    key: call_site:18446744071582381017 vals: count:643 bytes_alloc:159008
    key: call_site:18446744072103563942 vals: count:645 bytes_alloc:123840
    key: call_site:18446744071582043239 vals: count:765 bytes_alloc:6120
    key: call_site:18446744072101884462 vals: count:776 bytes_alloc:49664
    key: call_site:18446744072103903864 vals: count:1026 bytes_alloc:98496
    key: call_site:18446744072103596026 vals: count:1026 bytes_alloc:287040
    key: call_site:18446744072103599888 vals: count:1026 bytes_alloc:724736
    key: call_site:18446744071580813202 vals: count:2433 bytes_alloc:155712
    key: call_site:18446744072099520315 vals: count:2948 bytes_alloc:64856
    Totals:
        Hits: 12601
        Entries: 51
        Dropped: 0
    
    A little more useful, but not much, would be to display the call_sites
    as hex addresses.  To do this we add a '.hex' modifier to the
    call_site key :
    
    root@trz-ThinkPad-T420:~# echo 'hash:call_site.hex:bytes_alloc' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
    
    root@trz-ThinkPad-T420:~# cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
    
    hash:unlimited
    key: call_site:ffffffff811e7f26     vals: count:1 bytes_alloc:64
    key: call_site:ffffffff811a5bb2     vals: count:1 bytes_alloc:1024
    key: call_site:ffffffff811a41c8     vals: count:1 bytes_alloc:256
    key: call_site:ffffffff811c002e     vals: count:1 bytes_alloc:128
    key: call_site:ffffffff811209d7     vals: count:1 bytes_alloc:256
    key: call_site:ffffffff811f26f9     vals: count:1 bytes_alloc:32
    key: call_site:ffffffff811f2596     vals: count:1 bytes_alloc:512
    key: call_site:ffffffff811f249d     vals: count:1 bytes_alloc:128
    key: call_site:ffffffff811f37ac     vals: count:1 bytes_alloc:512
    key: call_site:ffffffff811bfe7d     vals: count:1 bytes_alloc:4096
    key: call_site:ffffffff811a5b94     vals: count:1 bytes_alloc:192
    key: call_site:ffffffff813075f4     vals: count:1 bytes_alloc:256
    key: call_site:ffffffff811b9555     vals: count:1 bytes_alloc:64
    key: call_site:ffffffff811b94a4     vals: count:2 bytes_alloc:2112
    key: call_site:ffffffff81236745     vals: count:2 bytes_alloc:128
    key: call_site:ffffffff813062f7     vals: count:5 bytes_alloc:160
    key: call_site:ffffffff811e0792     vals: count:8 bytes_alloc:512
    key: call_site:ffffffff81236908     vals: count:12 bytes_alloc:800
    key: call_site:ffffffffa0491a40     vals: count:12 bytes_alloc:2304
    key: call_site:ffffffffa02c6d85     vals: count:12 bytes_alloc:1152
    key: call_site:ffffffffa048fb7c     vals: count:12 bytes_alloc:1152
    key: call_site:ffffffffa0470ffa     vals: count:144 bytes_alloc:40192
    key: call_site:ffffffffa0471f10     vals: count:144 bytes_alloc:96192
    key: call_site:ffffffffa04bc278     vals: count:144 bytes_alloc:13824
    key: call_site:ffffffffa04692a6     vals: count:218 bytes_alloc:41856
    key: call_site:ffffffffa046b74d     vals: count:218 bytes_alloc:3488
    key: call_site:ffffffff8135f3d9     vals: count:218 bytes_alloc:53344
    key: call_site:ffffffffa02cf22e     vals: count:230 bytes_alloc:14720
    key: call_site:ffffffff8130cc67     vals: count:1229 bytes_alloc:9832
    Totals:
        Hits: 2623
        Entries: 29
        Dropped: 0
    
    Even more useful would be to display the call_sites as symbolic names.
    To do that we can add a '.sym' modifier to the call_site key:
    
    root@trz-ThinkPad-T420:~# echo 'hash:call_site.sym:bytes_alloc' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
    
    root@trz-ThinkPad-T420:~# cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
    
    hash:unlimited
    key: call_site:[ffffffff8120aeca] stat_open vals: count:1 bytes_alloc:4096
    key: call_site:[ffffffff811a5bb2] alloc_pipe_info     vals: count:1 bytes_alloc:1024
    key: call_site:[ffffffff811f2596] load_elf_binary     vals: count:1 bytes_alloc:512
    key: call_site:[ffffffff811209d7] event_hash_trigger_print  vals: count:1 bytes_alloc:256
    key: call_site:[ffffffff811f26f9] load_elf_binary       vals: count:1 bytes_alloc:32
    key: call_site:[ffffffff811b9555] alloc_fdtable                 vals: count:1 bytes_alloc:64
    key: call_site:[ffffffff811f37ac] load_elf_binary       vals: count:1 bytes_alloc:512
    key: call_site:[ffffffff811a41c8] do_execve_common.isra.28  vals: count:1 bytes_alloc:256
    key: call_site:[ffffffff811c00dc] single_open                   vals: count:1 bytes_alloc:32
    key: call_site:[ffffffff811f249d] load_elf_binary       vals: count:1 bytes_alloc:128
    key: call_site:[ffffffff811a5b94] alloc_pipe_info       vals: count:1 bytes_alloc:192
    key: call_site:[ffffffff813075f4] aa_path_name                  vals: count:1 bytes_alloc:256
    key: call_site:[ffffffff811dd155] mounts_open_common            vals: count:2 bytes_alloc:384
    key: call_site:[ffffffff811b94a4] alloc_fdmem                   vals: count:2 bytes_alloc:2112
    key: call_site:[ffffffff81202bd1] proc_reg_open                 vals: count:2 bytes_alloc:128
    key: call_site:[ffffffff8120c066] proc_self_follow_link         vals: count:2 bytes_alloc:32
    key: call_site:[ffffffff811c002e] seq_open              vals: count:3 bytes_alloc:384
    key: call_site:[ffffffff811bfe7d] seq_read              vals: count:4 bytes_alloc:16384
    key: call_site:[ffffffff811e0792] inotify_handle_event          vals: count:4 bytes_alloc:256
    key: call_site:[ffffffff813062f7] aa_alloc_task_context         vals: count:5 bytes_alloc:160
    key: call_site:[ffffffffa0491a40] intel_framebuffer_create  vals: count:8 bytes_alloc:1536
    key: call_site:[ffffffffa02c6d85] drm_mode_page_flip_ioctl  vals: count:8 bytes_alloc:768
    key: call_site:[ffffffffa048fb7c] intel_crtc_page_flip          vals: count:8 bytes_alloc:768
    key: call_site:[ffffffffa04692a6] i915_gem_obj_lookup_or_create_vma   vals: count:112 bytes_alloc:21504
    key: call_site:[ffffffffa046b74d] i915_gem_object_get_pages_gtt               vals: count:112 bytes_alloc:1792
    key: call_site:[ffffffff8135f3d9] sg_kmalloc                                  vals: count:112 bytes_alloc:33088
    key: call_site:[ffffffffa02cf22e] drm_vma_node_allow                          vals: count:120 bytes_alloc:7680
    key: call_site:[ffffffffa0470ffa] i915_gem_do_execbuffer.isra.21      vals: count:122 bytes_alloc:34432
    key: call_site:[ffffffffa0471f10] i915_gem_execbuffer2                        vals: count:122 bytes_alloc:80960
    key: call_site:[ffffffffa04bc278] intel_ring_begin                    vals: count:122 bytes_alloc:11712
    key: call_site:[ffffffff8130cc67] apparmor_file_alloc_security                vals: count:126 bytes_alloc:1008
    Totals:
        Hits: 1008
        Entries: 31
        Dropped: 0
    
    Most useful of all would be to not only display the call_sites
    symbolically, but also display tallies of the total number of bytes
    requested by each caller, the number allocated, and sort by the
    difference betwen the two, which essentially gives you a listing of
    the callers that waste the most bytes due to the lack of allocation
    granularity.
    
    This is a good demonstration of hashing multiple values, tallying the
    difference between values (- is the only 'operator' supported), and
    specifying a non-default sort order.
    
      # echo 'hash:call_site.sym:bytes_req,bytes_alloc,bytes_alloc-bytes_req:sort=bytes_alloc-bytes_req' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
    
      # cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
    
    key: call_site:[ffffffff813062f7] aa_alloc_task_context                                                vals: count:30 bytes_req:960,  bytes_alloc:960,  bytes_alloc-bytes_req:0
    key: call_site:[ffffffff813075f4] aa_path_name                                                         vals: count:4 bytes_req:1024,  bytes_alloc:1024,  bytes_alloc-bytes_req:0
    key: call_site:[ffffffff811c002e] seq_open                                                     vals: count:18 bytes_req:2304,  bytes_alloc:2304,  bytes_alloc-bytes_req:0
    key: call_site:[ffffffff811bfd3a] seq_read                                                     vals: count:3 bytes_req:24576,  bytes_alloc:24576,  bytes_alloc-bytes_req:0
    key: call_site:[ffffffff810912cd] alloc_fair_sched_group                                       vals: count:1 bytes_req:64,  bytes_alloc:64,  bytes_alloc-bytes_req:0
    key: call_site:[ffffffff810970db] sched_autogroup_create_attach                                        vals: count:1 bytes_req:64,  bytes_alloc:64,  bytes_alloc-bytes_req:0
    key: call_site:[ffffffff811aaa8f] vfs_rename                                                           vals: count:2 bytes_req:22,  bytes_alloc:32,  bytes_alloc-bytes_req:10
    key: call_site:[ffffffff8120c066] proc_self_follow_link                                                vals: count:3 bytes_req:36,  bytes_alloc:48,  bytes_alloc-bytes_req:12
    key: call_site:[ffffffff811f26f9] load_elf_binary                                              vals: count:4 bytes_req:112,  bytes_alloc:128,  bytes_alloc-bytes_req:16
    key: call_site:[ffffffff811f2596] load_elf_binary                                              vals: count:4 bytes_req:2016,  bytes_alloc:2048,  bytes_alloc-bytes_req:32
    key: call_site:[ffffffff81269b65] ext4_ext_remove_space                                                vals: count:3 bytes_req:144,  bytes_alloc:192,  bytes_alloc-bytes_req:48
    key: call_site:[ffffffff811dd155] mounts_open_common                                                   vals: count:2 bytes_req:320,  bytes_alloc:384,  bytes_alloc-bytes_req:64
    key: call_site:[ffffffff811b9555] alloc_fdtable                                                        vals: count:4 bytes_req:192,  bytes_alloc:256,  bytes_alloc-bytes_req:64
    key: call_site:[ffffffff81236745] ext4_readdir                                                         vals: count:13 bytes_req:624,  bytes_alloc:832,  bytes_alloc-bytes_req:208
    key: call_site:[ffffffff811a5b94] alloc_pipe_info                                              vals: count:5 bytes_req:680,  bytes_alloc:960,  bytes_alloc-bytes_req:280
    key: call_site:[ffffffff81202bd1] proc_reg_open                                                        vals: count:14 bytes_req:560,  bytes_alloc:896,  bytes_alloc-bytes_req:336
    key: call_site:[ffffffff81087abe] sched_create_group                                                   vals: count:1 bytes_req:664,  bytes_alloc:1024,  bytes_alloc-bytes_req:360
    key: call_site:[ffffffffa0312f89] cfg80211_inform_bss_width_frame                              vals: count:2 bytes_req:546,  bytes_alloc:1024,  bytes_alloc-bytes_req:478
    key: call_site:[ffffffff811f37ac] load_elf_binary                                              vals: count:4 bytes_req:1568,  bytes_alloc:2048,  bytes_alloc-bytes_req:480
    key: call_site:[ffffffff811209d7] event_hash_trigger_print                                     vals: count:7 bytes_req:2520,  bytes_alloc:3328,  bytes_alloc-bytes_req:808
    key: call_site:[ffffffff811e7f26] eventfd_file_create                                                  vals: count:71 bytes_req:3408,  bytes_alloc:4544,  bytes_alloc-bytes_req:1136
    key: call_site:[ffffffff81236908] ext4_htree_store_dirent                                      vals: count:100 bytes_req:6246,  bytes_alloc:7456,  bytes_alloc-bytes_req:1210
    key: call_site:[ffffffff811a5bb2] alloc_pipe_info                                              vals: count:5 bytes_req:3200,  bytes_alloc:5120,  bytes_alloc-bytes_req:1920
    key: call_site:[ffffffffa02c6d85] drm_mode_page_flip_ioctl                                     vals: count:370 bytes_req:32560,  bytes_alloc:35520,  bytes_alloc-bytes_req:2960
    key: call_site:[ffffffff8120aeca] stat_open                                                    vals: count:7 bytes_req:24752,  bytes_alloc:28672,  bytes_alloc-bytes_req:3920
    key: call_site:[ffffffff811e0792] inotify_handle_event                                                 vals: count:644 bytes_req:37470,  bytes_alloc:41792,  bytes_alloc-bytes_req:4322
    key: call_site:[ffffffffa048fb7c] intel_crtc_page_flip                                                 vals: count:370 bytes_req:26640,  bytes_alloc:35520,  bytes_alloc-bytes_req:8880
    key: call_site:[ffffffffa008df3b] hid_report_raw_event                                                 vals: count:7048 bytes_req:140960,  bytes_alloc:155056,  bytes_alloc-bytes_req:14096
    key: call_site:[ffffffffa0491a40] intel_framebuffer_create                                     vals: count:370 bytes_req:53280,  bytes_alloc:71040,  bytes_alloc-bytes_req:17760
    key: call_site:[ffffffff8130cc67] apparmor_file_alloc_security                                         vals: count:3058 bytes_req:6116,  bytes_alloc:24464,  bytes_alloc-bytes_req:18348
    key: call_site:[ffffffffa04bc278] intel_ring_begin                                             vals: count:2754 bytes_req:242352,  bytes_alloc:264384,  bytes_alloc-bytes_req:22032
    key: call_site:[ffffffffa04692a6] i915_gem_obj_lookup_or_create_vma                            vals: count:1835 bytes_req:308280,  bytes_alloc:352320,  bytes_alloc-bytes_req:44040
    key: call_site:[ffffffffa02cf22e] drm_vma_node_allow                                                   vals: count:2291 bytes_req:91640,  bytes_alloc:146624,  bytes_alloc-bytes_req:54984
    key: call_site:[ffffffff8135f3d9] sg_kmalloc                                                           vals: count:1827 bytes_req:432512,  bytes_alloc:491808,  bytes_alloc-bytes_req:59296
    key: call_site:[ffffffffa0470ffa] i915_gem_do_execbuffer.isra.21                               vals: count:2754 bytes_req:534960,  bytes_alloc:922624,  bytes_alloc-bytes_req:387664
    key: call_site:[ffffffffa0471f10] i915_gem_execbuffer2                                                 vals: count:2754 bytes_req:2030840,  bytes_alloc:2729792,  bytes_alloc-bytes_req:698952
    Totals:
        Hits: 28354
        Entries: 48
        Dropped: 0
    
    Here's an example of using a compound key.  The below tallies syscall
    hits for every unique combination of pid/syscall id ('hitcount' is
    essentially a placeholder - as mentioned before, counts are always
    kept - using 'hitcount' essentially references that 'fake' event field
    in the hash trigger specification).  Both the syscall id and the pid
    are displayed symbolically via the .syscall and .execname modifiers.
    
      # echo 'hash:common_pid.execname,id.syscall:hitcount:sort=common_pid,hitcount' > /sys/kernel/debug/tracing/events/raw_syscalls/sys_enter/trigger
    
      # cat /sys/kernel/debug/tracing/events/raw_syscalls/sys_enter/trigger
    
    key: common_pid:bash[3112], id:sys_write                                   vals: count:69
    key: common_pid:bash[3112], id:sys_rt_sigprocmask                          vals: count:218
    key: common_pid:update-notifier[3164], id:sys_poll                         vals: count:37
    key: common_pid:update-notifier[3164], id:sys_recvfrom                             vals: count:118
    key: common_pid:deja-dup-monito[3194], id:sys_sendto                               vals: count:1
    key: common_pid:deja-dup-monito[3194], id:sys_read                         vals: count:4
    key: common_pid:deja-dup-monito[3194], id:sys_poll                         vals: count:8
    key: common_pid:deja-dup-monito[3194], id:sys_recvmsg                              vals: count:8
    key: common_pid:deja-dup-monito[3194], id:sys_geteuid                              vals: count:8
    key: common_pid:deja-dup-monito[3194], id:sys_write                        vals: count:8
    key: common_pid:deja-dup-monito[3194], id:sys_getegid                              vals: count:8
    key: common_pid:emacs[3275], id:sys_fsync                                  vals: count:1
    key: common_pid:emacs[3275], id:sys_open                                   vals: count:1
    key: common_pid:emacs[3275], id:sys_unlink                                 vals: count:1
    key: common_pid:emacs[3275], id:sys_close                                  vals: count:1
    key: common_pid:emacs[3275], id:sys_symlink                                vals: count:2
    key: common_pid:emacs[3275], id:sys_readlink                                       vals: count:2
    key: common_pid:emacs[3275], id:sys_access                                 vals: count:2
    key: common_pid:emacs[3275], id:sys_geteuid                                vals: count:2
    key: common_pid:emacs[3275], id:sys_getgid                                 vals: count:2
    key: common_pid:emacs[3275], id:sys_getuid                                 vals: count:2
    key: common_pid:emacs[3275], id:sys_getegid                                vals: count:3
    key: common_pid:emacs[3275], id:sys_newlstat                                       vals: count:4
    key: common_pid:emacs[3275], id:sys_setitimer                                      vals: count:7
    key: common_pid:emacs[3275], id:sys_newstat                                vals: count:8
    key: common_pid:emacs[3275], id:sys_read                                   vals: count:9
    key: common_pid:emacs[3275], id:sys_write                                  vals: count:14
    key: common_pid:emacs[3275], id:sys_kill                                   vals: count:14
    key: common_pid:emacs[3275], id:sys_poll                                   vals: count:23
    key: common_pid:emacs[3275], id:sys_select                                 vals: count:23
    key: common_pid:emacs[3275], id:unknown_syscall                                    vals: count:34
    key: common_pid:emacs[3275], id:sys_ioctl                                  vals: count:60
    key: common_pid:emacs[3275], id:sys_rt_sigprocmask                         vals: count:116
    key: common_pid:cat[3323], id:sys_munmap                                   vals: count:1
    key: common_pid:cat[3323], id:sys_fadvise64                                vals: count:1
    
    Finally, the below uses a string as a hash key, and simply tallies and
    displays the default count ('hitcount').
    
      # echo 'hash:child_comm:hitcount' > /sys/kernel/debug/tracing/events/sched/sched_process_fork/trigger
    
      # cat /sys/kernel/debug/tracing/events/sched/sched_process_fork/trigger
    
    hash:unlimited
    
    key: child_comm:pool        vals: count:1
    key: child_comm:unity-panel-ser     vals: count:1
    key: child_comm:pool                vals: count:1
    key: child_comm:hud-service vals: count:1
    key: child_comm:Cache I/O   vals: count:1
    key: child_comm:postgres    vals: count:1
    key: child_comm:gdbus               vals: count:1
    key: child_comm:bash                vals: count:1
    key: child_comm:ubuntu-webapps-     vals: count:2
    key: child_comm:dbus-daemon vals: count:2
    key: child_comm:compiz              vals: count:3
    key: child_comm:apt-cache   vals: count:3
    key: child_comm:unity-webapps-s     vals: count:4
    key: child_comm:java                vals: count:6
    key: child_comm:firefox             vals: count:52
    Totals:
        Hits: 80
        Entries: 15
        Dropped: 0
    
    Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>



