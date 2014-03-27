Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaC0EzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:55:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:63753 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbaC0Eyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:54:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,739,1389772800"; 
   d="scan'208";a="507896192"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 5/5] tracing: Add 'hash' event trigger command
Date: Wed, 26 Mar 2014 23:54:07 -0500
Message-Id: <b81b0860d2915c0b562863fce889249dad080922.1395894625.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1395894625.git.tom.zanussi@linux.intel.com>
References: <cover.1395894625.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1395894625.git.tom.zanussi@linux.intel.com>
References: <cover.1395894625.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hash triggers allow users to continually hash events which can then be
dumped later by simply reading the trigger file.  This is done
strictly via one-liners and without any kind of programming language.

The syntax follows the existing trigger syntax:

  # echo hash:key(s):value(s)[:sort_keys()][ if filter] > event/trigger

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
key: call_site:18446744071579450186	vals: count:1 bytes_alloc:64
key: call_site:18446744071579439780	vals: count:1 bytes_alloc:64
key: call_site:18446744071579400894	vals: count:1 bytes_alloc:1024
key: call_site:18446744072104627352	vals: count:1 bytes_alloc:512
key: call_site:18446744071580027351	vals: count:1 bytes_alloc:512
key: call_site:18446744071580991590	vals: count:1 bytes_alloc:16
key: call_site:18446744071579463899	vals: count:1 bytes_alloc:64
key: call_site:18446744072102260685	vals: count:1 bytes_alloc:512
key: call_site:18446744071579439821	vals: count:1 bytes_alloc:64
key: call_site:18446744071579532598	vals: count:1 bytes_alloc:1024
key: call_site:18446744071584838347	vals: count:1 bytes_alloc:64
key: call_site:18446744071579450148	vals: count:1 bytes_alloc:64
key: call_site:18446744071580886173	vals: count:2 bytes_alloc:256
key: call_site:18446744071580886422	vals: count:2 bytes_alloc:1024
key: call_site:18446744071580987082	vals: count:2 bytes_alloc:8192
key: call_site:18446744071580652885	vals: count:2 bytes_alloc:128
key: call_site:18446744071580565960	vals: count:2 bytes_alloc:512
key: call_site:18446744071580680412	vals: count:2 bytes_alloc:64
key: call_site:18446744071580891052	vals: count:2 bytes_alloc:1024
key: call_site:18446744071580886777	vals: count:2 bytes_alloc:64
key: call_site:18446744071580572594	vals: count:3 bytes_alloc:3072
key: call_site:18446744071580592783	vals: count:3 bytes_alloc:48
key: call_site:18446744071580679805	vals: count:3 bytes_alloc:12288
key: call_site:18446744071582021108	vals: count:3 bytes_alloc:768
key: call_site:18446744071580572564	vals: count:3 bytes_alloc:576
key: call_site:18446744071581165381	vals: count:4 bytes_alloc:256
key: call_site:18446744071580953553	vals: count:4 bytes_alloc:256
key: call_site:18446744072102160648	vals: count:4 bytes_alloc:1024
key: call_site:18446744071580652708	vals: count:4 bytes_alloc:4224
key: call_site:18446744071580680238	vals: count:5 bytes_alloc:640
key: call_site:18446744071581375333	vals: count:6 bytes_alloc:384
key: call_site:18446744072102162313	vals: count:16 bytes_alloc:7616
key: call_site:18446744071581165832	vals: count:24 bytes_alloc:1600
key: call_site:18446744071582016247	vals: count:26 bytes_alloc:832
key: call_site:18446744071580843814	vals: count:35 bytes_alloc:2240
key: call_site:18446744071581367368	vals: count:39 bytes_alloc:3744
key: call_site:18446744072101806931	vals: count:39 bytes_alloc:1248
key: call_site:18446744072103721852	vals: count:89 bytes_alloc:8544
key: call_site:18446744072101850501	vals: count:89 bytes_alloc:8544
key: call_site:18446744072103729728	vals: count:89 bytes_alloc:17088
key: call_site:18446744071583128580	vals: count:154 bytes_alloc:157696
key: call_site:18446744072103573325	vals: count:643 bytes_alloc:10288
key: call_site:18446744071582381017	vals: count:643 bytes_alloc:159008
key: call_site:18446744072103563942	vals: count:645 bytes_alloc:123840
key: call_site:18446744071582043239	vals: count:765 bytes_alloc:6120
key: call_site:18446744072101884462	vals: count:776 bytes_alloc:49664
key: call_site:18446744072103903864	vals: count:1026 bytes_alloc:98496
key: call_site:18446744072103596026	vals: count:1026 bytes_alloc:287040
key: call_site:18446744072103599888	vals: count:1026 bytes_alloc:724736
key: call_site:18446744071580813202	vals: count:2433 bytes_alloc:155712
key: call_site:18446744072099520315	vals: count:2948 bytes_alloc:64856
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
key: call_site:ffffffff811e7f26	vals: count:1 bytes_alloc:64
key: call_site:ffffffff811a5bb2	vals: count:1 bytes_alloc:1024
key: call_site:ffffffff811a41c8	vals: count:1 bytes_alloc:256
key: call_site:ffffffff811c002e	vals: count:1 bytes_alloc:128
key: call_site:ffffffff811209d7	vals: count:1 bytes_alloc:256
key: call_site:ffffffff811f26f9	vals: count:1 bytes_alloc:32
key: call_site:ffffffff811f2596	vals: count:1 bytes_alloc:512
key: call_site:ffffffff811f249d	vals: count:1 bytes_alloc:128
key: call_site:ffffffff811f37ac	vals: count:1 bytes_alloc:512
key: call_site:ffffffff811bfe7d	vals: count:1 bytes_alloc:4096
key: call_site:ffffffff811a5b94	vals: count:1 bytes_alloc:192
key: call_site:ffffffff813075f4	vals: count:1 bytes_alloc:256
key: call_site:ffffffff811b9555	vals: count:1 bytes_alloc:64
key: call_site:ffffffff811b94a4	vals: count:2 bytes_alloc:2112
key: call_site:ffffffff81236745	vals: count:2 bytes_alloc:128
key: call_site:ffffffff813062f7	vals: count:5 bytes_alloc:160
key: call_site:ffffffff811e0792	vals: count:8 bytes_alloc:512
key: call_site:ffffffff81236908	vals: count:12 bytes_alloc:800
key: call_site:ffffffffa0491a40	vals: count:12 bytes_alloc:2304
key: call_site:ffffffffa02c6d85	vals: count:12 bytes_alloc:1152
key: call_site:ffffffffa048fb7c	vals: count:12 bytes_alloc:1152
key: call_site:ffffffffa0470ffa	vals: count:144 bytes_alloc:40192
key: call_site:ffffffffa0471f10	vals: count:144 bytes_alloc:96192
key: call_site:ffffffffa04bc278	vals: count:144 bytes_alloc:13824
key: call_site:ffffffffa04692a6	vals: count:218 bytes_alloc:41856
key: call_site:ffffffffa046b74d	vals: count:218 bytes_alloc:3488
key: call_site:ffffffff8135f3d9	vals: count:218 bytes_alloc:53344
key: call_site:ffffffffa02cf22e	vals: count:230 bytes_alloc:14720
key: call_site:ffffffff8130cc67	vals: count:1229 bytes_alloc:9832
Totals:
    Hits: 2623
    Entries: 29
    Dropped: 0

Even more useful would be to display the call_sites as symbolic names.
To do that we can add a '.sym' modifier to the call_site key:

root@trz-ThinkPad-T420:~# echo 'hash:call_site.sym:bytes_alloc' > /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger

root@trz-ThinkPad-T420:~# cat /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger

hash:unlimited
key: call_site:[ffffffff8120aeca] stat_open	vals: count:1 bytes_alloc:4096
key: call_site:[ffffffff811a5bb2] alloc_pipe_info     vals: count:1 bytes_alloc:1024
key: call_site:[ffffffff811f2596] load_elf_binary     vals: count:1 bytes_alloc:512
key: call_site:[ffffffff811209d7] event_hash_trigger_print  vals: count:1 bytes_alloc:256
key: call_site:[ffffffff811f26f9] load_elf_binary	    vals: count:1 bytes_alloc:32
key: call_site:[ffffffff811b9555] alloc_fdtable		    vals: count:1 bytes_alloc:64
key: call_site:[ffffffff811f37ac] load_elf_binary	    vals: count:1 bytes_alloc:512
key: call_site:[ffffffff811a41c8] do_execve_common.isra.28  vals: count:1 bytes_alloc:256
key: call_site:[ffffffff811c00dc] single_open		    vals: count:1 bytes_alloc:32
key: call_site:[ffffffff811f249d] load_elf_binary	    vals: count:1 bytes_alloc:128
key: call_site:[ffffffff811a5b94] alloc_pipe_info	    vals: count:1 bytes_alloc:192
key: call_site:[ffffffff813075f4] aa_path_name		    vals: count:1 bytes_alloc:256
key: call_site:[ffffffff811dd155] mounts_open_common	    vals: count:2 bytes_alloc:384
key: call_site:[ffffffff811b94a4] alloc_fdmem		    vals: count:2 bytes_alloc:2112
key: call_site:[ffffffff81202bd1] proc_reg_open		    vals: count:2 bytes_alloc:128
key: call_site:[ffffffff8120c066] proc_self_follow_link	    vals: count:2 bytes_alloc:32
key: call_site:[ffffffff811c002e] seq_open		    vals: count:3 bytes_alloc:384
key: call_site:[ffffffff811bfe7d] seq_read		    vals: count:4 bytes_alloc:16384
key: call_site:[ffffffff811e0792] inotify_handle_event	    vals: count:4 bytes_alloc:256
key: call_site:[ffffffff813062f7] aa_alloc_task_context	    vals: count:5 bytes_alloc:160
key: call_site:[ffffffffa0491a40] intel_framebuffer_create  vals: count:8 bytes_alloc:1536
key: call_site:[ffffffffa02c6d85] drm_mode_page_flip_ioctl  vals: count:8 bytes_alloc:768
key: call_site:[ffffffffa048fb7c] intel_crtc_page_flip	    vals: count:8 bytes_alloc:768
key: call_site:[ffffffffa04692a6] i915_gem_obj_lookup_or_create_vma	  vals: count:112 bytes_alloc:21504
key: call_site:[ffffffffa046b74d] i915_gem_object_get_pages_gtt		  vals: count:112 bytes_alloc:1792
key: call_site:[ffffffff8135f3d9] sg_kmalloc				  vals: count:112 bytes_alloc:33088
key: call_site:[ffffffffa02cf22e] drm_vma_node_allow			  vals: count:120 bytes_alloc:7680
key: call_site:[ffffffffa0470ffa] i915_gem_do_execbuffer.isra.21	  vals: count:122 bytes_alloc:34432
key: call_site:[ffffffffa0471f10] i915_gem_execbuffer2			  vals: count:122 bytes_alloc:80960
key: call_site:[ffffffffa04bc278] intel_ring_begin			  vals: count:122 bytes_alloc:11712
key: call_site:[ffffffff8130cc67] apparmor_file_alloc_security		  vals: count:126 bytes_alloc:1008
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

key: call_site:[ffffffff813062f7] aa_alloc_task_context						   vals: count:30 bytes_req:960,  bytes_alloc:960,  bytes_alloc-bytes_req:0
key: call_site:[ffffffff813075f4] aa_path_name							   vals: count:4 bytes_req:1024,  bytes_alloc:1024,  bytes_alloc-bytes_req:0
key: call_site:[ffffffff811c002e] seq_open							   vals: count:18 bytes_req:2304,  bytes_alloc:2304,  bytes_alloc-bytes_req:0
key: call_site:[ffffffff811bfd3a] seq_read							   vals: count:3 bytes_req:24576,  bytes_alloc:24576,  bytes_alloc-bytes_req:0
key: call_site:[ffffffff810912cd] alloc_fair_sched_group					   vals: count:1 bytes_req:64,  bytes_alloc:64,  bytes_alloc-bytes_req:0
key: call_site:[ffffffff810970db] sched_autogroup_create_attach					   vals: count:1 bytes_req:64,  bytes_alloc:64,  bytes_alloc-bytes_req:0
key: call_site:[ffffffff811aaa8f] vfs_rename							   vals: count:2 bytes_req:22,  bytes_alloc:32,  bytes_alloc-bytes_req:10
key: call_site:[ffffffff8120c066] proc_self_follow_link						   vals: count:3 bytes_req:36,  bytes_alloc:48,  bytes_alloc-bytes_req:12
key: call_site:[ffffffff811f26f9] load_elf_binary						   vals: count:4 bytes_req:112,  bytes_alloc:128,  bytes_alloc-bytes_req:16
key: call_site:[ffffffff811f2596] load_elf_binary						   vals: count:4 bytes_req:2016,  bytes_alloc:2048,  bytes_alloc-bytes_req:32
key: call_site:[ffffffff81269b65] ext4_ext_remove_space						   vals: count:3 bytes_req:144,  bytes_alloc:192,  bytes_alloc-bytes_req:48
key: call_site:[ffffffff811dd155] mounts_open_common						   vals: count:2 bytes_req:320,  bytes_alloc:384,  bytes_alloc-bytes_req:64
key: call_site:[ffffffff811b9555] alloc_fdtable							   vals: count:4 bytes_req:192,  bytes_alloc:256,  bytes_alloc-bytes_req:64
key: call_site:[ffffffff81236745] ext4_readdir							   vals: count:13 bytes_req:624,  bytes_alloc:832,  bytes_alloc-bytes_req:208
key: call_site:[ffffffff811a5b94] alloc_pipe_info						   vals: count:5 bytes_req:680,  bytes_alloc:960,  bytes_alloc-bytes_req:280
key: call_site:[ffffffff81202bd1] proc_reg_open							   vals: count:14 bytes_req:560,  bytes_alloc:896,  bytes_alloc-bytes_req:336
key: call_site:[ffffffff81087abe] sched_create_group						   vals: count:1 bytes_req:664,  bytes_alloc:1024,  bytes_alloc-bytes_req:360
key: call_site:[ffffffffa0312f89] cfg80211_inform_bss_width_frame				   vals: count:2 bytes_req:546,  bytes_alloc:1024,  bytes_alloc-bytes_req:478
key: call_site:[ffffffff811f37ac] load_elf_binary						   vals: count:4 bytes_req:1568,  bytes_alloc:2048,  bytes_alloc-bytes_req:480
key: call_site:[ffffffff811209d7] event_hash_trigger_print					   vals: count:7 bytes_req:2520,  bytes_alloc:3328,  bytes_alloc-bytes_req:808
key: call_site:[ffffffff811e7f26] eventfd_file_create						   vals: count:71 bytes_req:3408,  bytes_alloc:4544,  bytes_alloc-bytes_req:1136
key: call_site:[ffffffff81236908] ext4_htree_store_dirent					   vals: count:100 bytes_req:6246,  bytes_alloc:7456,  bytes_alloc-bytes_req:1210
key: call_site:[ffffffff811a5bb2] alloc_pipe_info						   vals: count:5 bytes_req:3200,  bytes_alloc:5120,  bytes_alloc-bytes_req:1920
key: call_site:[ffffffffa02c6d85] drm_mode_page_flip_ioctl					   vals: count:370 bytes_req:32560,  bytes_alloc:35520,  bytes_alloc-bytes_req:2960
key: call_site:[ffffffff8120aeca] stat_open							   vals: count:7 bytes_req:24752,  bytes_alloc:28672,  bytes_alloc-bytes_req:3920
key: call_site:[ffffffff811e0792] inotify_handle_event						   vals: count:644 bytes_req:37470,  bytes_alloc:41792,  bytes_alloc-bytes_req:4322
key: call_site:[ffffffffa048fb7c] intel_crtc_page_flip						   vals: count:370 bytes_req:26640,  bytes_alloc:35520,  bytes_alloc-bytes_req:8880
key: call_site:[ffffffffa008df3b] hid_report_raw_event						   vals: count:7048 bytes_req:140960,  bytes_alloc:155056,  bytes_alloc-bytes_req:14096
key: call_site:[ffffffffa0491a40] intel_framebuffer_create					   vals: count:370 bytes_req:53280,  bytes_alloc:71040,  bytes_alloc-bytes_req:17760
key: call_site:[ffffffff8130cc67] apparmor_file_alloc_security					   vals: count:3058 bytes_req:6116,  bytes_alloc:24464,  bytes_alloc-bytes_req:18348
key: call_site:[ffffffffa04bc278] intel_ring_begin						   vals: count:2754 bytes_req:242352,  bytes_alloc:264384,  bytes_alloc-bytes_req:22032
key: call_site:[ffffffffa04692a6] i915_gem_obj_lookup_or_create_vma				   vals: count:1835 bytes_req:308280,  bytes_alloc:352320,  bytes_alloc-bytes_req:44040
key: call_site:[ffffffffa02cf22e] drm_vma_node_allow						   vals: count:2291 bytes_req:91640,  bytes_alloc:146624,  bytes_alloc-bytes_req:54984
key: call_site:[ffffffff8135f3d9] sg_kmalloc							   vals: count:1827 bytes_req:432512,  bytes_alloc:491808,  bytes_alloc-bytes_req:59296
key: call_site:[ffffffffa0470ffa] i915_gem_do_execbuffer.isra.21				   vals: count:2754 bytes_req:534960,  bytes_alloc:922624,  bytes_alloc-bytes_req:387664
key: call_site:[ffffffffa0471f10] i915_gem_execbuffer2						   vals: count:2754 bytes_req:2030840,  bytes_alloc:2729792,  bytes_alloc-bytes_req:698952
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

key: common_pid:bash[3112], id:sys_write				       vals: count:69
key: common_pid:bash[3112], id:sys_rt_sigprocmask			       vals: count:218
key: common_pid:update-notifier[3164], id:sys_poll			       vals: count:37
key: common_pid:update-notifier[3164], id:sys_recvfrom			       vals: count:118
key: common_pid:deja-dup-monito[3194], id:sys_sendto			       vals: count:1
key: common_pid:deja-dup-monito[3194], id:sys_read			       vals: count:4
key: common_pid:deja-dup-monito[3194], id:sys_poll			       vals: count:8
key: common_pid:deja-dup-monito[3194], id:sys_recvmsg			       vals: count:8
key: common_pid:deja-dup-monito[3194], id:sys_geteuid			       vals: count:8
key: common_pid:deja-dup-monito[3194], id:sys_write			       vals: count:8
key: common_pid:deja-dup-monito[3194], id:sys_getegid			       vals: count:8
key: common_pid:emacs[3275], id:sys_fsync				       vals: count:1
key: common_pid:emacs[3275], id:sys_open				       vals: count:1
key: common_pid:emacs[3275], id:sys_unlink				       vals: count:1
key: common_pid:emacs[3275], id:sys_close				       vals: count:1
key: common_pid:emacs[3275], id:sys_symlink				       vals: count:2
key: common_pid:emacs[3275], id:sys_readlink				       vals: count:2
key: common_pid:emacs[3275], id:sys_access				       vals: count:2
key: common_pid:emacs[3275], id:sys_geteuid				       vals: count:2
key: common_pid:emacs[3275], id:sys_getgid				       vals: count:2
key: common_pid:emacs[3275], id:sys_getuid				       vals: count:2
key: common_pid:emacs[3275], id:sys_getegid				       vals: count:3
key: common_pid:emacs[3275], id:sys_newlstat				       vals: count:4
key: common_pid:emacs[3275], id:sys_setitimer				       vals: count:7
key: common_pid:emacs[3275], id:sys_newstat				       vals: count:8
key: common_pid:emacs[3275], id:sys_read				       vals: count:9
key: common_pid:emacs[3275], id:sys_write				       vals: count:14
key: common_pid:emacs[3275], id:sys_kill				       vals: count:14
key: common_pid:emacs[3275], id:sys_poll				       vals: count:23
key: common_pid:emacs[3275], id:sys_select				       vals: count:23
key: common_pid:emacs[3275], id:unknown_syscall				       vals: count:34
key: common_pid:emacs[3275], id:sys_ioctl				       vals: count:60
key: common_pid:emacs[3275], id:sys_rt_sigprocmask			       vals: count:116
key: common_pid:cat[3323], id:sys_munmap				       vals: count:1
key: common_pid:cat[3323], id:sys_fadvise64				       vals: count:1

Finally, the below uses a string as a hash key, and simply tallies and
displays the default count ('hitcount').

  # echo 'hash:child_comm:hitcount' > /sys/kernel/debug/tracing/events/sched/sched_process_fork/trigger

  # cat /sys/kernel/debug/tracing/events/sched/sched_process_fork/trigger

hash:unlimited

key: child_comm:pool	vals: count:1
key: child_comm:unity-panel-ser	vals: count:1
key: child_comm:pool		vals: count:1
key: child_comm:hud-service	vals: count:1
key: child_comm:Cache I/O	vals: count:1
key: child_comm:postgres	vals: count:1
key: child_comm:gdbus		vals: count:1
key: child_comm:bash		vals: count:1
key: child_comm:ubuntu-webapps-	vals: count:2
key: child_comm:dbus-daemon	vals: count:2
key: child_comm:compiz		vals: count:3
key: child_comm:apt-cache	vals: count:3
key: child_comm:unity-webapps-s	vals: count:4
key: child_comm:java		vals: count:6
key: child_comm:firefox		vals: count:52
Totals:
    Hits: 80
    Entries: 15
    Dropped: 0

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 include/linux/ftrace_event.h        |    1 +
 kernel/trace/trace_events_filter.c  |    3 +-
 kernel/trace/trace_events_trigger.c | 1404 +++++++++++++++++++++++++++++++++++
 3 files changed, 1407 insertions(+), 1 deletion(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5961964..8700630 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -353,6 +353,7 @@ enum event_trigger_type {
 	ETT_SNAPSHOT		= (1 << 1),
 	ETT_STACKTRACE		= (1 << 2),
 	ETT_EVENT_ENABLE	= (1 << 3),
+	ETT_EVENT_HASH		= (1 << 4),
 };
 
 extern void destroy_preds(struct ftrace_event_file *file);
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 60a8e3f..cee9b29 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -941,7 +941,8 @@ int filter_assign_type(const char *type)
 	if (strstr(type, "__data_loc") && strstr(type, "char"))
 		return FILTER_DYN_STRING;
 
-	if (strchr(type, '[') && strstr(type, "char"))
+	if (strchr(type, '[') &&
+	    (strstr(type, "char") || strstr(type, "u8")))
 		return FILTER_STATIC_STRING;
 
 	return FILTER_OTHER;
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 323846e..210ddd0 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -22,6 +22,9 @@
 #include <linux/ctype.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/hash.h>
+#include <linux/stacktrace.h>
+#include <linux/sort.h>
 
 #include "trace.h"
 
@@ -1427,12 +1430,1413 @@ static __init int register_trigger_traceon_traceoff_cmds(void)
 	return ret;
 }
 
+struct hash_field;
+
+typedef u64 (*hash_field_fn_t) (struct hash_field *field, void *event);
+
+struct hash_field {
+	struct ftrace_event_field	*field;
+	struct ftrace_event_field	*aux_field;
+	hash_field_fn_t			fn;
+	unsigned long			flags;
+};
+
+static u64 hash_field_none(struct hash_field *field, void *event)
+{
+	return 0;
+}
+
+static u64 hash_field_string(struct hash_field *hash_field, void *event)
+{
+	char *addr = (char *)(event + hash_field->field->offset);
+
+	return (u64)addr;
+}
+
+static u64 hash_field_diff(struct hash_field *hash_field, void *event)
+{
+	u64 *m, *s;
+
+	m = (u64 *)(event + hash_field->field->offset);
+	s = (u64 *)(event + hash_field->aux_field->offset);
+
+	return *m - *s;
+}
+
+#define DEFINE_HASH_FIELD_FN(type)					\
+static u64 hash_field_##type(struct hash_field *hash_field, void *event)\
+{									\
+	type *addr = (type *)(event + hash_field->field->offset);	\
+									\
+	return (u64)*addr;						\
+}
+
+DEFINE_HASH_FIELD_FN(s64);
+DEFINE_HASH_FIELD_FN(u64);
+DEFINE_HASH_FIELD_FN(s32);
+DEFINE_HASH_FIELD_FN(u32);
+DEFINE_HASH_FIELD_FN(s16);
+DEFINE_HASH_FIELD_FN(u16);
+DEFINE_HASH_FIELD_FN(s8);
+DEFINE_HASH_FIELD_FN(u8);
+
+#define HASH_TRIGGER_BITS	11
+#define COMPOUND_KEY_MAX	8
+#define HASH_VALS_MAX		16
+#define HASH_SORT_KEYS_MAX	2
+
+/* Largest event field string currently 32, add 1 = 64 */
+#define HASH_KEY_STRING_MAX	64
+
+enum hash_field_flags {
+	HASH_FIELD_SYM		= 1,
+	HASH_FIELD_HEX		= 2,
+	HASH_FIELD_STACKTRACE	= 4,
+	HASH_FIELD_STRING	= 8,
+	HASH_FIELD_EXECNAME	= 16,
+	HASH_FIELD_SYSCALL	= 32,
+};
+
+enum sort_key_flags {
+	SORT_KEY_COUNT		= 1,
+};
+
+struct hash_trigger_sort_key {
+	bool		descending;
+	bool		use_hitcount;
+	bool		key_part;
+	unsigned int	idx;
+};
+
+struct hash_trigger_data {
+	struct	hlist_head		*hashtab;
+	unsigned int			hashtab_bits;
+	char				*keys_str;
+	char				*vals_str;
+	char				*sort_keys_str;
+	struct hash_field		*keys[COMPOUND_KEY_MAX];
+	unsigned int			n_keys;
+	struct hash_field		*vals[HASH_VALS_MAX];
+	unsigned int			n_vals;
+	struct ftrace_event_file	*event_file;
+	unsigned long			total_hits;
+	unsigned long			total_entries;
+	struct hash_trigger_sort_key	*sort_keys[HASH_SORT_KEYS_MAX];
+	struct hash_trigger_sort_key	*sort_key_cur;
+	spinlock_t			lock;
+	unsigned int			max_entries;
+	struct hash_trigger_entry	*entries;
+	unsigned int			n_entries;
+	struct stack_trace		*struct_stacktrace_entries;
+	unsigned int			n_struct_stacktrace_entries;
+	unsigned long			*stacktrace_entries;
+	unsigned int			n_stacktrace_entries;
+	char				*hash_key_string_entries;
+	unsigned int			n_hash_key_string_entries;
+	unsigned long			drops;
+};
+
+enum hash_key_type {
+	HASH_KEY_TYPE_U64,
+	HASH_KEY_TYPE_STACKTRACE,
+	HASH_KEY_TYPE_STRING,
+};
+
+struct hash_key_part {
+	enum hash_key_type		type;
+	unsigned long			flags;
+	union {
+		u64			val_u64;
+		struct stack_trace	*val_stacktrace;
+		char			*val_string;
+	} var;
+};
+
+struct hash_trigger_entry {
+	struct	hlist_node		node;
+	struct hash_key_part		key_parts[COMPOUND_KEY_MAX];
+	u64				sums[HASH_VALS_MAX];
+	char				comm[TASK_COMM_LEN + 1];
+	u64				count;
+	struct hash_trigger_data*	hash_data;
+};
+
+#define HASH_STACKTRACE_DEPTH 16
+#define HASH_STACKTRACE_SKIP 4
+
+static hash_field_fn_t select_value_fn(int field_size, int field_is_signed)
+{
+	hash_field_fn_t fn = NULL;
+
+	switch (field_size) {
+	case 8:
+		if (field_is_signed)
+			fn = hash_field_s64;
+		else
+			fn = hash_field_u64;
+		break;
+	case 4:
+		if (field_is_signed)
+			fn = hash_field_s32;
+		else
+			fn = hash_field_u32;
+		break;
+	case 2:
+		if (field_is_signed)
+			fn = hash_field_s16;
+		else
+			fn = hash_field_u16;
+		break;
+	case 1:
+		if (field_is_signed)
+			fn = hash_field_s8;
+		else
+			fn = hash_field_u8;
+		break;
+	}
+
+	return fn;
+}
+
+#define FNV_OFFSET_BASIS	(14695981039346656037ULL)
+#define FNV_PRIME		(1099511628211ULL)
+
+static u64 hash_fnv_1a(char *key, unsigned int size, unsigned int bits)
+{
+	u64 hash = FNV_OFFSET_BASIS;
+	unsigned int i;
+
+	for (i = 0; i < size; i++) {
+		hash ^= key[i];
+		hash *= FNV_PRIME;
+	}
+
+	return hash >> (64 - bits);
+}
+
+static u64 hash_stacktrace(struct stack_trace *stacktrace, unsigned int bits)
+{
+	unsigned int size;
+
+	size = stacktrace->nr_entries * sizeof(*stacktrace->entries);
+
+	return hash_fnv_1a((char *)stacktrace->entries, size, bits);
+}
+
+static u64 hash_string(struct hash_field *hash_field,
+		       unsigned int bits, void *rec)
+{
+	unsigned int size;
+	char *string;
+
+	size = hash_field->field->size;
+	string = (char *)hash_field->fn(hash_field, rec);
+
+	return hash_fnv_1a(string, size, bits);
+}
+
+static u64 hash_compound_key(struct hash_trigger_data *hash_data,
+			     unsigned int bits, void *rec)
+{
+	struct hash_field *hash_field;
+	u64 key[COMPOUND_KEY_MAX];
+	unsigned int i;
+
+	for (i = 0; i < hash_data->n_keys; i++) {
+		hash_field = hash_data->keys[i];
+		key[i] = hash_field->fn(hash_field, rec);
+	}
+
+	return hash_fnv_1a((char *)key, hash_data->n_keys * sizeof(key[0]), bits);
+}
+
+static u64 hash_key(struct hash_trigger_data *hash_data, void *rec,
+		    struct stack_trace *stacktrace)
+{
+	/* currently can't have compound key with string or stacktrace */
+	struct hash_field *hash_field = hash_data->keys[0];
+	unsigned int bits = hash_data->hashtab_bits;
+	u64 hash_idx = 0;
+
+	if (hash_field->flags & HASH_FIELD_STACKTRACE)
+		hash_idx = hash_stacktrace(stacktrace, bits);
+	else if (hash_field->flags & HASH_FIELD_STRING)
+		hash_idx = hash_string(hash_field, bits, rec);
+	else if (hash_data->n_keys > 1)
+		hash_idx = hash_compound_key(hash_data, bits, rec);
+	else {
+		u64 hash_val = hash_field->fn(hash_field, rec);
+
+		switch (hash_field->field->size) {
+		case 8:
+			hash_idx = hash_64(hash_val, bits);
+			break;
+		case 4:
+			hash_idx = hash_32(hash_val, bits);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			break;
+		}
+	}
+
+	return hash_idx;
+}
+
+static inline void save_comm(char *comm, struct task_struct *task) {
+
+	if (!task->pid) {
+		strcpy(comm, "<idle>");
+		return;
+	}
+
+	if (WARN_ON_ONCE(task->pid < 0)) {
+		strcpy(comm, "<XXX>");
+		return;
+	}
+
+	if (task->pid > PID_MAX_DEFAULT) {
+		strcpy(comm, "<...>");
+		return;
+	}
+
+	memcpy(comm, task->comm, TASK_COMM_LEN);
+}
+
+static void stacktrace_entry_fill(struct hash_trigger_entry *entry,
+				  unsigned int key,
+				  struct hash_field *hash_field,
+				  struct stack_trace *stacktrace)
+{
+	struct hash_trigger_data *hash_data = entry->hash_data;
+	struct stack_trace *stacktrace_copy;
+	unsigned int size, offset, idx;
+
+	idx = hash_data->n_struct_stacktrace_entries++;
+	stacktrace_copy = &hash_data->struct_stacktrace_entries[idx];
+	*stacktrace_copy = *stacktrace;
+
+	idx = hash_data->n_stacktrace_entries++;
+	size = sizeof(unsigned long) * HASH_STACKTRACE_DEPTH;
+	offset = HASH_STACKTRACE_DEPTH * idx;
+	stacktrace_copy->entries = &hash_data->stacktrace_entries[offset];
+	memcpy(stacktrace_copy->entries, stacktrace->entries, size);
+
+	entry->key_parts[key].type = HASH_KEY_TYPE_STACKTRACE;
+	entry->key_parts[key].flags = hash_field->flags;
+	entry->key_parts[key].var.val_stacktrace = stacktrace_copy;
+}
+
+static void string_entry_fill(struct hash_trigger_entry *entry,
+			      unsigned int key,
+			      struct hash_field *hash_field,
+			      void *rec)
+{
+	struct hash_trigger_data *hash_data = entry->hash_data;
+	unsigned int size = hash_field->field->size + 1;
+	unsigned int offset;
+	char *string_copy;
+
+	offset = HASH_KEY_STRING_MAX * hash_data->n_hash_key_string_entries++;
+	string_copy = &hash_data->hash_key_string_entries[offset];
+
+	memcpy(string_copy, (char *)hash_field->fn(hash_field, rec), size);
+
+	entry->key_parts[key].type = HASH_KEY_TYPE_STRING;
+	entry->key_parts[key].flags = hash_field->flags;
+	entry->key_parts[key].var.val_string = string_copy;
+}
+
+static struct hash_trigger_entry *
+hash_trigger_entry_create(struct hash_trigger_data *hash_data, void *rec,
+			  struct stack_trace *stacktrace)
+{
+	struct hash_trigger_entry *entry = NULL;
+	struct hash_field *hash_field;
+	bool save_execname = false;
+	unsigned int i;
+
+	if (hash_data->n_entries < hash_data->max_entries) {
+		entry = &hash_data->entries[hash_data->n_entries++];
+		if (!entry)
+			return NULL;
+	}
+
+	entry->hash_data = hash_data;
+
+	for (i = 0; i < hash_data->n_keys; i++) {
+		hash_field = hash_data->keys[i];
+
+		if (hash_field->flags & HASH_FIELD_STACKTRACE)
+			stacktrace_entry_fill(entry, i, hash_field, stacktrace);
+		else if (hash_field->flags & HASH_FIELD_STRING)
+			string_entry_fill(entry, i, hash_field, rec);
+		else {
+			u64 hash_val = hash_field->fn(hash_field, rec);
+
+			entry->key_parts[i].type = HASH_KEY_TYPE_U64;
+			entry->key_parts[i].flags = hash_field->flags;
+			entry->key_parts[i].var.val_u64 = hash_val;
+			/*
+			  EXECNAME only applies to common_pid as a
+			  key, And with the assumption that the comm
+			  saved is only for common_pid i.e. current
+			  pid when the event was logged.  comm is
+			  saved only when the hash entry is created,
+			  subsequent hits for that hash entry map the
+			  same pid and comm.
+			*/
+			if (hash_field->flags & HASH_FIELD_EXECNAME)
+				save_execname = true;
+		}
+	}
+
+	if (save_execname)
+		save_comm(entry->comm, current);
+
+	return entry;
+}
+
+static void destroy_hashtab(struct hash_trigger_data *hash_data)
+{
+	struct hlist_head *hashtab = hash_data->hashtab;
+
+	if (!hashtab)
+		return;
+
+	kfree(hashtab);
+
+	hash_data->hashtab = NULL;
+}
+
+static void destroy_hash_field(struct hash_field *hash_field)
+{
+	kfree(hash_field);
+}
+
+static struct hash_field *
+create_hash_field(struct ftrace_event_field *field,
+		  struct ftrace_event_field *aux_field,
+		  unsigned long flags)
+{
+	hash_field_fn_t fn = hash_field_none;
+	struct hash_field *hash_field;
+
+	hash_field = kzalloc(sizeof(struct hash_field), GFP_KERNEL);
+	if (!hash_field)
+		return NULL;
+
+	if (flags & HASH_FIELD_STACKTRACE) {
+		hash_field->flags = flags;
+		goto out;
+	}
+
+	if (is_string_field(field)) {
+		flags |= HASH_FIELD_STRING;
+		fn = hash_field_string;
+	} else if (is_function_field(field))
+		goto free;
+	else {
+		if (aux_field) {
+			hash_field->aux_field = aux_field;
+			fn = hash_field_diff;
+		} else {
+			fn = select_value_fn(field->size, field->is_signed);
+			if (!fn)
+				goto free;
+		}
+	}
+
+	hash_field->field = field;
+	hash_field->fn = fn;
+	hash_field->flags = flags;
+ out:
+	return hash_field;
+ free:
+	kfree(hash_field);
+	hash_field = NULL;
+	goto out;
+}
+
+static void destroy_hash_fields(struct hash_trigger_data *hash_data)
+{
+	unsigned int i;
+
+	for (i = 0; i < hash_data->n_keys; i++) {
+		destroy_hash_field(hash_data->keys[i]);
+		hash_data->keys[i] = NULL;
+	}
+
+	for (i = 0; i < hash_data->n_vals; i++) {
+		destroy_hash_field(hash_data->vals[i]);
+		hash_data->vals[i] = NULL;
+	}
+}
+
+static inline struct hash_trigger_sort_key *create_default_sort_key(void)
+{
+	struct hash_trigger_sort_key *sort_key;
+
+	sort_key = kzalloc(sizeof(*sort_key), GFP_KERNEL);
+	if (!sort_key)
+		return NULL;
+
+	sort_key->use_hitcount = true;
+
+	return sort_key;
+}
+
+static inline struct hash_trigger_sort_key *
+create_sort_key(char *field_name, struct hash_trigger_data *hash_data)
+{
+	struct hash_trigger_sort_key *sort_key;
+	bool key_part = false;
+	unsigned int j;
+
+	if (!strcmp(field_name, "hitcount"))
+		return create_default_sort_key();
+
+	if (strchr(field_name, '-')) {
+		char *aux_field_name = field_name;
+
+		field_name = strsep(&aux_field_name, "-");
+		if (!aux_field_name)
+			return NULL;
+
+		for (j = 0; j < hash_data->n_vals; j++)
+			if (!strcmp(field_name,
+				    hash_data->vals[j]->field->name) &&
+			    (hash_data->vals[j]->aux_field &&
+			     !strcmp(aux_field_name,
+				     hash_data->vals[j]->aux_field->name)))
+				goto out;
+	}
+
+	for (j = 0; j < hash_data->n_vals; j++)
+		if (!strcmp(field_name, hash_data->vals[j]->field->name))
+			goto out;
+
+	for (j = 0; j < hash_data->n_keys; j++) {
+		if (hash_data->keys[j]->flags & HASH_FIELD_STACKTRACE)
+			continue;
+		if (hash_data->keys[j]->flags & HASH_FIELD_STRING)
+			continue;
+		if (!strcmp(field_name, hash_data->keys[j]->field->name)) {
+			key_part = true;
+			goto out;
+		}
+	}
+
+	return NULL;
+ out:
+	sort_key = kzalloc(sizeof(*sort_key), GFP_KERNEL);
+	if (!sort_key)
+		return NULL;
+
+	sort_key->idx = j;
+	sort_key->key_part = key_part;
+
+	return sort_key;
+}
+
+static int create_sort_keys(struct hash_trigger_data *hash_data)
+{
+	char *fields_str = hash_data->sort_keys_str;
+	struct hash_trigger_sort_key *sort_key;
+	char *field_str, *field_name;
+	unsigned int i;
+	int ret = 0;
+
+	if (!fields_str) {
+		sort_key = create_default_sort_key();
+		if (!sort_key) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		hash_data->sort_keys[0] = sort_key;
+		goto out;
+	}
+
+	strsep(&fields_str, "=");
+	if (!fields_str) {
+		ret = -EINVAL;
+		goto free;
+	}
+
+	for (i = 0; i < HASH_SORT_KEYS_MAX; i++) {
+		field_str = strsep(&fields_str, ",");
+		if (!field_str) {
+			if (i == 0) {
+				ret = -EINVAL;
+				goto free;
+			} else
+				break;
+		}
+
+		field_name = strsep(&field_str, ".");
+		sort_key = create_sort_key(field_name, hash_data);
+		if (!sort_key) {
+			ret = -EINVAL; /* or -ENOMEM */
+			goto free;
+		}
+		if (field_str) {
+			if (!strcmp(field_str, "descending"))
+				sort_key->descending = true;
+			else if (strcmp(field_str, "ascending")) {
+				ret = -EINVAL; /* not either, err */
+				goto free;
+			}
+		}
+		hash_data->sort_keys[i] = sort_key;
+	}
+out:
+	return ret;
+free:
+	for (i = 0; i < HASH_SORT_KEYS_MAX; i++) {
+		if (!hash_data->sort_keys[i])
+			break;
+		kfree(hash_data->sort_keys[i]);
+		hash_data->sort_keys[i] = NULL;
+	}
+	goto out;
+}
+
+static int create_key_field(struct hash_trigger_data *hash_data,
+			    unsigned int key,
+			    struct ftrace_event_file *file,
+			    char *field_str)
+{
+	struct ftrace_event_field *field = NULL;
+	unsigned long flags = 0;
+	char *field_name;
+	int ret = 0;
+
+	if (!strcmp(field_str, "stacktrace")) {
+		flags |= HASH_FIELD_STACKTRACE;
+	} else {
+		field_name = strsep(&field_str, ".");
+		if (field_str) {
+			if (!strcmp(field_str, "sym"))
+				flags |= HASH_FIELD_SYM;
+			else if (!strcmp(field_str, "hex"))
+				flags |= HASH_FIELD_HEX;
+			else if (!strcmp(field_str, "execname") &&
+				 !strcmp(field_name, "common_pid"))
+				flags |= HASH_FIELD_EXECNAME;
+			else if (!strcmp(field_str, "syscall"))
+				flags |= HASH_FIELD_SYSCALL;
+		}
+
+		field = trace_find_event_field(file->event_call, field_name);
+		if (!field) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	hash_data->keys[key] = create_hash_field(field, NULL, flags);
+	if (!hash_data->keys[key]) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	hash_data->n_keys++;
+ out:
+	return ret;
+}
+
+static int create_val_field(struct hash_trigger_data *hash_data,
+			    unsigned int val,
+			    struct ftrace_event_file *file,
+			    char *field_str)
+{
+	struct ftrace_event_field *field = NULL;
+	unsigned long flags = 0;
+	char *field_name;
+	int ret = 0;
+
+	if (!strcmp(field_str, "hitcount"))
+		return ret; /* There's always a hitcount */
+
+	field_name = strsep(&field_str, "-");
+	if (field_str) {
+		struct ftrace_event_field *m_field, *s_field;
+
+		m_field = trace_find_event_field(file->event_call, field_name);
+		if (!m_field || is_string_field(m_field) ||
+		    is_function_field(m_field)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		s_field = trace_find_event_field(file->event_call, field_str);
+		if (!s_field || is_string_field(m_field) ||
+		    is_function_field(m_field)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		hash_data->vals[val] = create_hash_field(m_field, s_field, flags);
+		if (!hash_data->vals[val]) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	} else {
+		field_str = field_name;
+		field_name = strsep(&field_str, ".");
+
+		if (field_str) {
+			if (!strcmp(field_str, "sym"))
+				flags |= HASH_FIELD_SYM;
+			else if (!strcmp(field_str, "hex"))
+				flags |= HASH_FIELD_HEX;
+		}
+
+		field = trace_find_event_field(file->event_call, field_name);
+		if (!field) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		hash_data->vals[val] = create_hash_field(field, NULL, flags);
+		if (!hash_data->vals[val]) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+	hash_data->n_vals++;
+ out:
+	return ret;
+}
+
+static int create_hash_fields(struct hash_trigger_data *hash_data,
+			      struct ftrace_event_file *file)
+{
+	char *fields_str, *field_str;
+	unsigned int i;
+	int ret = 0;
+
+	fields_str = hash_data->keys_str;
+
+	for (i = 0; i < COMPOUND_KEY_MAX; i++) {
+		field_str = strsep(&fields_str, ",");
+		if (!field_str) {
+			if (i == 0) {
+				ret = -EINVAL;
+				goto out;
+			} else
+				break;
+		}
+
+		ret = create_key_field(hash_data, i, file, field_str);
+		if (ret)
+			goto out;
+	}
+
+	fields_str = hash_data->vals_str;
+
+	for (i = 0; i < HASH_VALS_MAX; i++) {
+		field_str = strsep(&fields_str, ",");
+		if (!field_str) {
+			if (i == 0) {
+				ret = -EINVAL;
+				goto out;
+			} else
+				break;
+		}
+
+		ret = create_val_field(hash_data, i, file, field_str);
+		if (ret)
+			goto out;
+	}
+
+	ret = create_sort_keys(hash_data);
+ out:
+	return ret;
+}
+
+static void destroy_hashdata(struct hash_trigger_data *hash_data)
+{
+	synchronize_sched();
+
+	kfree(hash_data->keys_str);
+	kfree(hash_data->vals_str);
+	kfree(hash_data->sort_keys_str);
+	hash_data->keys_str = NULL;
+	hash_data->vals_str = NULL;
+	hash_data->sort_keys_str = NULL;
+
+	kfree(hash_data->entries);
+	hash_data->entries = NULL;
+
+	kfree(hash_data->struct_stacktrace_entries);
+	hash_data->struct_stacktrace_entries = NULL;
+
+	kfree(hash_data->stacktrace_entries);
+	hash_data->stacktrace_entries = NULL;
+
+	kfree(hash_data->hash_key_string_entries);
+	hash_data->hash_key_string_entries = NULL;
+
+	destroy_hash_fields(hash_data);
+	destroy_hashtab(hash_data);
+
+	kfree(hash_data);
+}
+
+static struct hash_trigger_data *create_hash_data(unsigned int hashtab_bits,
+						  const char *keys,
+						  const char *vals,
+						  const char *sort_keys,
+						  struct ftrace_event_file *file,
+						  int *ret)
+{
+	unsigned int hashtab_size = (1 << hashtab_bits);
+	struct hash_trigger_data *hash_data;
+	unsigned int i, size;
+
+	hash_data = kzalloc(sizeof(*hash_data), GFP_KERNEL);
+	if (!hash_data)
+		return NULL;
+
+	/* Let's just say we size for a perfect hash but are not
+	 * perfect. So let's have enough for 2 * the hashtab_size. */
+
+	/* Also, we'll run out of entries before or at the same time
+	 * we run out of other items like strings or stacks, so we
+	 * only need to pay attention to one counter, for entries. */
+
+	/* Also, use vmalloc or something for these large blocks. */
+	hash_data->max_entries = hashtab_size * 2;
+	size = sizeof(struct hash_trigger_entry) * hash_data->max_entries;
+	hash_data->entries = kzalloc(size, GFP_KERNEL);
+	if (!hash_data->entries)
+		goto free;
+
+	size = sizeof(struct stack_trace) * hash_data->max_entries;
+	hash_data->struct_stacktrace_entries = kzalloc(size, GFP_KERNEL);
+	if (!hash_data->struct_stacktrace_entries)
+		goto free;
+
+	size = sizeof(unsigned long) * HASH_STACKTRACE_DEPTH * hash_data->max_entries;
+	hash_data->stacktrace_entries = kzalloc(size, GFP_KERNEL);
+	if (!hash_data->stacktrace_entries)
+		goto free;
+
+	size = sizeof(char) * HASH_KEY_STRING_MAX * hash_data->max_entries;
+	hash_data->hash_key_string_entries = kzalloc(size, GFP_KERNEL);
+	if (!hash_data->hash_key_string_entries)
+		goto free;
+
+	hash_data->keys_str = kstrdup(keys, GFP_KERNEL);
+	hash_data->vals_str = kstrdup(vals, GFP_KERNEL);
+	if (sort_keys)
+		hash_data->sort_keys_str = kstrdup(sort_keys, GFP_KERNEL);
+
+	*ret = create_hash_fields(hash_data, file);
+	if (*ret < 0)
+		goto free;
+
+	hash_data->hashtab = kzalloc(hashtab_size * sizeof(struct hlist_head),
+				     GFP_KERNEL);
+	if (!hash_data->hashtab) {
+		*ret = -ENOMEM;
+		goto free;
+	}
+
+	for (i = 0; i < hashtab_size; i++)
+		INIT_HLIST_HEAD(&hash_data->hashtab[i]);
+	spin_lock_init(&hash_data->lock);
+
+	hash_data->hashtab_bits = hashtab_bits;
+	hash_data->event_file = file;
+ out:
+	return hash_data;
+ free:
+	destroy_hashdata(hash_data);
+	hash_data = NULL;
+	goto out;
+}
+
+static inline bool match_stacktraces(struct stack_trace *entry_stacktrace,
+				     struct stack_trace *stacktrace)
+{
+	unsigned int size;
+
+	if (entry_stacktrace->nr_entries != entry_stacktrace->nr_entries)
+		return false;
+
+	size = sizeof(*stacktrace->entries) * stacktrace->nr_entries;
+	if (memcmp(entry_stacktrace->entries, stacktrace->entries, size) == 0)
+		return true;
+
+	return false;
+}
+
+static struct hash_trigger_entry *
+hash_trigger_entry_match(struct hash_trigger_entry *entry,
+			 struct hash_key_part *key_parts,
+			 unsigned int n_key_parts)
+{
+	unsigned int i;
+
+	for (i = 0; i < n_key_parts; i++) {
+		if (entry->key_parts[i].type != key_parts[i].type)
+			return NULL;
+
+		switch (entry->key_parts[i].type) {
+		case HASH_KEY_TYPE_U64:
+			if (entry->key_parts[i].var.val_u64 !=
+			    key_parts[i].var.val_u64)
+				return NULL;
+			break;
+		case HASH_KEY_TYPE_STACKTRACE:
+			if (!match_stacktraces(entry->key_parts[i].var.val_stacktrace,
+					       key_parts[i].var.val_stacktrace))
+				return NULL;
+			break;
+		case HASH_KEY_TYPE_STRING:
+			if (strcmp(entry->key_parts[i].var.val_string,
+				   key_parts[i].var.val_string))
+				return NULL;
+			break;
+		default:
+			return NULL;
+		}
+	}
+
+	return entry;
+}
+
+static struct hash_trigger_entry *
+hash_trigger_entry_find(struct hash_trigger_data *hash_data, void *rec,
+			struct stack_trace *stacktrace)
+{
+	struct hash_key_part key_parts[COMPOUND_KEY_MAX];
+	unsigned int i, n_keys = hash_data->n_keys;
+	struct hash_trigger_entry *entry;
+	struct hash_field *hash_field;
+	u64 hash_idx;
+
+	hash_idx = hash_key(hash_data, rec, stacktrace);
+
+	for (i = 0; i < n_keys; i++) {
+		hash_field = hash_data->keys[i];
+		if (hash_field->flags & HASH_FIELD_STACKTRACE) {
+			key_parts[i].type = HASH_KEY_TYPE_STACKTRACE;
+			key_parts[i].var.val_stacktrace = stacktrace;
+		} else if (hash_field->flags & HASH_FIELD_STRING) {
+			u64 hash_val = hash_field->fn(hash_field, rec);
+
+			key_parts[i].type = HASH_KEY_TYPE_STRING;
+			key_parts[i].var.val_string = (char *)hash_val;
+		} else {
+			u64 hash_val = hash_field->fn(hash_field, rec);
+
+			key_parts[i].type = HASH_KEY_TYPE_U64;
+			key_parts[i].var.val_u64 = hash_val;
+		}
+	}
+
+	hlist_for_each_entry_rcu(entry, &hash_data->hashtab[hash_idx], node) {
+		if (hash_trigger_entry_match(entry, key_parts, n_keys))
+			return entry;
+	}
+
+	return NULL;
+}
+
+static void hash_trigger_entry_insert(struct hash_trigger_data *hash_data,
+				      struct hash_trigger_entry *entry,
+				      void *rec,
+				      struct stack_trace *stacktrace)
+{
+	u64 hash_idx = hash_key(hash_data, rec, stacktrace);
+
+	hash_data->total_entries++;
+
+	hlist_add_head_rcu(&entry->node, &hash_data->hashtab[hash_idx]);
+}
+
+static void
+hash_trigger_entry_update(struct hash_trigger_data *hash_data,
+			  struct hash_trigger_entry *entry, void *rec)
+{
+	struct hash_field *hash_field;
+	unsigned int i;
+	u64 hash_val;
+
+	for (i = 0; i < hash_data->n_vals; i++) {
+		hash_field = hash_data->vals[i];
+		hash_val = hash_field->fn(hash_field, rec);
+		entry->sums[i] += hash_val;
+	}
+
+	entry->count++;
+}
+
+static void
+event_hash_trigger(struct event_trigger_data *data, void *rec)
+{
+	struct hash_trigger_data *hash_data = data->private_data;
+	struct hash_trigger_entry *entry;
+	struct hash_field *hash_field;
+
+	struct stack_trace stacktrace;
+	unsigned long entries[HASH_STACKTRACE_DEPTH];
+
+	unsigned long flags;
+
+	if (hash_data->drops) {
+		hash_data->drops++;
+		return;
+	}
+
+	hash_field = hash_data->keys[0];
+
+	if (hash_field->flags & HASH_FIELD_STACKTRACE) {
+		stacktrace.max_entries = HASH_STACKTRACE_DEPTH;
+		stacktrace.entries = entries;
+		stacktrace.nr_entries = 0;
+		stacktrace.skip = HASH_STACKTRACE_SKIP;
+
+		save_stack_trace(&stacktrace);
+	}
+
+	spin_lock_irqsave(&hash_data->lock, flags);
+	entry = hash_trigger_entry_find(hash_data, rec, &stacktrace);
+
+	if (!entry) {
+		entry = hash_trigger_entry_create(hash_data, rec, &stacktrace);
+		WARN_ON_ONCE(!entry);
+		if (!entry) {
+			spin_unlock_irqrestore(&hash_data->lock, flags);
+			return;
+		}
+		hash_trigger_entry_insert(hash_data, entry, rec, &stacktrace);
+	}
+
+	hash_trigger_entry_update(hash_data, entry, rec);
+	hash_data->total_hits++;
+	spin_unlock_irqrestore(&hash_data->lock, flags);
+}
+
+static void
+hash_trigger_stacktrace_print(struct seq_file *m,
+			      struct stack_trace *stacktrace)
+{
+	char str[KSYM_SYMBOL_LEN];
+	unsigned int spaces = 8;
+	unsigned int i;
+
+	for (i = 0; i < stacktrace->nr_entries; i++) {
+		if (stacktrace->entries[i] == ULONG_MAX)
+			return;
+		seq_printf(m, "%*c", 1 + spaces, ' ');
+		sprint_symbol(str, stacktrace->entries[i]);
+		seq_printf(m, "%s\n", str);
+	}
+}
+
+static void
+hash_trigger_entry_print(struct seq_file *m,
+			 struct hash_trigger_data *hash_data,
+			 struct hash_trigger_entry *entry)
+{
+	char str[KSYM_SYMBOL_LEN];
+	unsigned int i;
+
+	seq_printf(m, "key: ");
+	for (i = 0; i < hash_data->n_keys; i++) {
+		if (i > 0)
+			seq_printf(m, ", ");
+		if (entry->key_parts[i].flags & HASH_FIELD_SYM) {
+			kallsyms_lookup(entry->key_parts[i].var.val_u64,
+					NULL, NULL, NULL, str);
+			seq_printf(m, "%s:[%llx] %s",
+				   hash_data->keys[i]->field->name,
+				   entry->key_parts[i].var.val_u64,
+				   str);
+		} else if (entry->key_parts[i].flags & HASH_FIELD_HEX) {
+			seq_printf(m, "%s:%llx",
+				   hash_data->keys[i]->field->name,
+				   entry->key_parts[i].var.val_u64);
+		} else if (entry->key_parts[i].flags & HASH_FIELD_STACKTRACE) {
+			seq_printf(m, "stacktrace:\n");
+			hash_trigger_stacktrace_print(m,
+				      entry->key_parts[i].var.val_stacktrace);
+		} else if (entry->key_parts[i].flags & HASH_FIELD_STRING) {
+			seq_printf(m, "%s:%s",
+				   hash_data->keys[i]->field->name,
+				   entry->key_parts[i].var.val_string);
+		} else if (entry->key_parts[i].flags & HASH_FIELD_EXECNAME) {
+			seq_printf(m, "%s:%s[%llu]",
+				   hash_data->keys[i]->field->name,
+				   entry->comm,
+				   entry->key_parts[i].var.val_u64);
+		} else if (entry->key_parts[i].flags & HASH_FIELD_SYSCALL) {
+			int syscall = entry->key_parts[i].var.val_u64;
+			const char *syscall_name = get_syscall_name(syscall);
+
+			if (!syscall_name)
+				syscall_name = "unknown_syscall";
+			seq_printf(m, "%s:%s",
+				   hash_data->keys[i]->field->name,
+				   syscall_name);
+		} else {
+			seq_printf(m, "%s:%llu",
+				   hash_data->keys[i]->field->name,
+				   entry->key_parts[i].var.val_u64);
+		}
+	}
+
+	seq_printf(m, "\tvals: count:%llu", entry->count);
+
+	for (i = 0; i < hash_data->n_vals; i++) {
+		if (i > 0)
+			seq_printf(m, ", ");
+		if (hash_data->vals[i]->aux_field) {
+			seq_printf(m, " %s-%s:%llu",
+				   hash_data->vals[i]->field->name,
+				   hash_data->vals[i]->aux_field->name,
+				   entry->sums[i]);
+			continue;
+		}
+		seq_printf(m, " %s:%llu",
+			   hash_data->vals[i]->field->name,
+			   entry->sums[i]);
+	}
+	seq_printf(m, "\n");
+}
+
+static int sort_entries(const struct hash_trigger_entry **a,
+			const struct hash_trigger_entry **b)
+{
+	const struct hash_trigger_entry *entry_a, *entry_b;
+	struct hash_trigger_sort_key *sort_key;
+	struct hash_trigger_data *hash_data;
+	u64 val_a, val_b;
+	int ret = 0;
+
+	entry_a = *a;
+	entry_b = *b;
+
+	hash_data = entry_a->hash_data;
+	sort_key = hash_data->sort_key_cur;
+
+	if (sort_key->use_hitcount) {
+		val_a = entry_a->count;
+		val_b = entry_b->count;
+	} else if (sort_key->key_part) {
+		/* TODO: make sure we never use a stacktrace here */
+		val_a = entry_a->key_parts[sort_key->idx].var.val_u64;
+		val_b = entry_b->key_parts[sort_key->idx].var.val_u64;
+	} else {
+		val_a = entry_a->sums[sort_key->idx];
+		val_b = entry_b->sums[sort_key->idx];
+	}
+
+	if (val_a > val_b)
+		ret = 1;
+	else if (val_a < val_b)
+		ret = -1;
+
+	if (sort_key->descending)
+		ret = -ret;
+
+	return ret;
+}
+
+static void sort_secondary(struct hash_trigger_data *hash_data,
+			   struct hash_trigger_entry **entries,
+			   unsigned int n_entries)
+{
+	struct hash_trigger_sort_key *primary_sort_key;
+	unsigned int start = 0, n_subelts = 1;
+	struct hash_trigger_entry *entry;
+	bool do_sort = false;
+	unsigned int i, idx;
+	u64 cur_val;
+
+	primary_sort_key = hash_data->sort_keys[0];
+
+	entry = entries[0];
+	if (primary_sort_key->use_hitcount)
+		cur_val = entry->count;
+	else if (primary_sort_key->key_part)
+		cur_val = entry->key_parts[primary_sort_key->idx].var.val_u64;
+	else
+		cur_val = entry->sums[primary_sort_key->idx];
+
+	hash_data->sort_key_cur = hash_data->sort_keys[1];
+
+	for (i = 1; i < n_entries; i++) {
+		entry = entries[i];
+		if (primary_sort_key->use_hitcount) {
+			if (entry->count != cur_val) {
+				cur_val = entry->count;
+				do_sort = true;
+			}
+		} else if (primary_sort_key->key_part) {
+			idx = primary_sort_key->idx;
+			if (entry->key_parts[idx].var.val_u64 != cur_val) {
+				cur_val = entry->key_parts[idx].var.val_u64;
+				do_sort = true;
+			}
+		} else {
+			idx = primary_sort_key->idx;
+			if (entry->sums[idx] != cur_val) {
+				cur_val = entry->sums[idx];
+				do_sort = true;
+			}
+		}
+
+		if (i == n_entries - 1)
+			do_sort = true;
+
+		if (do_sort) {
+			if (n_subelts > 1) {
+				sort(entries + start, n_subelts, sizeof(entry),
+				     (int (*)(const void *, const void *))sort_entries, NULL);
+			}
+			start = i;
+			n_subelts = 1;
+			do_sort = false;
+		} else
+			n_subelts++;
+	}
+}
+
+static bool
+print_entries_sorted(struct seq_file *m, struct hash_trigger_data *hash_data)
+{
+	unsigned int hashtab_size = (1 << hash_data->hashtab_bits);
+	struct hash_trigger_entry **entries;
+	struct hash_trigger_entry *entry;
+	unsigned int entries_size;
+	unsigned int i = 0, j = 0;
+
+	entries_size = sizeof(entry) * hash_data->total_entries;
+	entries = kmalloc(entries_size, GFP_KERNEL);
+	if (!entries)
+		return false;
+
+	for (i = 0; i < hashtab_size; i++) {
+		hlist_for_each_entry_rcu(entry, &hash_data->hashtab[i], node)
+			entries[j++] = entry;
+	}
+
+	hash_data->sort_key_cur = hash_data->sort_keys[0];
+	sort(entries, j, sizeof(struct hash_trigger_entry *),
+	     (int (*)(const void *, const void *))sort_entries, NULL);
+
+	if (hash_data->sort_keys[1])
+		sort_secondary(hash_data, entries, j);
+
+	for (i = 0; i < j; i++)
+		hash_trigger_entry_print(m, hash_data, entries[i]);
+
+	kfree(entries);
+
+	return true;
+}
+
+static bool
+print_entries_unsorted(struct seq_file *m, struct hash_trigger_data *hash_data)
+{
+	unsigned int hashtab_size = (1 << hash_data->hashtab_bits);
+	struct hash_trigger_entry *entry;
+	unsigned int i = 0;
+
+	for (i = 0; i < hashtab_size; i++) {
+		hlist_for_each_entry_rcu(entry, &hash_data->hashtab[i], node)
+			hash_trigger_entry_print(m, hash_data, entry);
+	}
+
+	return true;
+}
+
+static int
+event_hash_trigger_print(struct seq_file *m, struct event_trigger_ops *ops,
+			 struct event_trigger_data *data)
+{
+	struct hash_trigger_data *hash_data = data->private_data;
+	bool sorted;
+	int ret;
+
+	ret = event_trigger_print("hash", m, (void *)data->count,
+				  data->filter_str);
+
+	sorted = print_entries_sorted(m, hash_data);
+	if (!sorted)
+		print_entries_unsorted(m, hash_data);
+
+	seq_printf(m, "Totals:\n    Hits: %lu\n    Entries: %lu\n    Dropped: %lu\n",
+		   hash_data->total_hits, hash_data->total_entries, hash_data->drops);
+
+	if (!sorted)
+		seq_printf(m, "Unsorted (couldn't alloc memory for sorting)\n");
+
+	return ret;
+}
+
+static void
+event_hash_trigger_free(struct event_trigger_ops *ops,
+			struct event_trigger_data *data)
+{
+	struct hash_trigger_data *hash_data = data->private_data;
+
+	if (WARN_ON_ONCE(data->ref <= 0))
+		return;
+
+	data->ref--;
+	if (!data->ref) {
+		destroy_hashdata(hash_data);
+		trigger_data_free(data);
+	}
+}
+
+static struct event_trigger_ops event_hash_trigger_ops = {
+	.func			= event_hash_trigger,
+	.print			= event_hash_trigger_print,
+	.init			= event_trigger_init,
+	.free			= event_hash_trigger_free,
+};
+
+static struct event_trigger_ops *
+event_hash_get_trigger_ops(char *cmd, char *param)
+{
+	/* counts don't make sense for hash triggers */
+	return &event_hash_trigger_ops;
+}
+
+static int
+event_hash_trigger_func(struct event_command *cmd_ops,
+			struct ftrace_event_file *file,
+			char *glob, char *cmd, char *param)
+{
+	struct event_trigger_data *trigger_data;
+	struct event_trigger_ops *trigger_ops;
+	struct hash_trigger_data *hash_data;
+	char *sort_keys = NULL;
+	char *trigger;
+	char *number;
+	int ret = 0;
+	char *keys;
+	char *vals;
+
+	if (!param)
+		return -EINVAL;
+
+	/* separate the trigger from the filter (s:e:n [if filter]) */
+	trigger = strsep(&param, " \t");
+	if (!trigger)
+		return -EINVAL;
+
+	keys = strsep(&trigger, ":");
+	if (!trigger)
+		return -EINVAL;
+
+	vals = strsep(&trigger, ":");
+	if (trigger)
+		sort_keys = strsep(&trigger, ":");
+
+	hash_data = create_hash_data(HASH_TRIGGER_BITS, keys, vals, sort_keys,
+				     file, &ret);
+	if (ret)
+		return ret;
+
+	trigger_ops = cmd_ops->get_trigger_ops(cmd, trigger);
+
+	ret = -ENOMEM;
+	trigger_data = kzalloc(sizeof(*trigger_data), GFP_KERNEL);
+	if (!trigger_data)
+		goto out;
+
+	trigger_data->count = -1;
+	trigger_data->ops = trigger_ops;
+	trigger_data->cmd_ops = cmd_ops;
+	INIT_LIST_HEAD(&trigger_data->list);
+	RCU_INIT_POINTER(trigger_data->filter, NULL);
+
+	trigger_data->private_data = hash_data;
+
+	if (glob[0] == '!') {
+		cmd_ops->unreg(glob+1, trigger_ops, trigger_data, file);
+		ret = 0;
+		goto out_free;
+	}
+
+	if (trigger) {
+		number = strsep(&trigger, ":");
+
+		ret = -EINVAL;
+		if (strlen(number)) /* hash triggers don't support counts */
+			goto out_free;
+	}
+
+	if (!param) /* if param is non-empty, it's supposed to be a filter */
+		goto out_reg;
+
+	if (!cmd_ops->set_filter)
+		goto out_reg;
+
+	ret = cmd_ops->set_filter(param, trigger_data, file);
+	if (ret < 0)
+		goto out_free;
+
+ out_reg:
+	ret = cmd_ops->reg(glob, trigger_ops, trigger_data, file);
+	/*
+	 * The above returns on success the # of functions enabled,
+	 * but if it didn't find any functions it returns zero.
+	 * Consider no functions a failure too.
+	 */
+	if (!ret) {
+		ret = -ENOENT;
+		goto out_free;
+	} else if (ret < 0)
+		goto out_free;
+	/* Just return zero, not the number of enabled functions */
+	ret = 0;
+ out:
+	return ret;
+
+ out_free:
+	if (cmd_ops->set_filter)
+		cmd_ops->set_filter(NULL, trigger_data, NULL);
+	kfree(trigger_data);
+	destroy_hashdata(hash_data);
+	goto out;
+}
+
+static struct event_command trigger_hash_cmd= {
+	.name			= "hash",
+	.trigger_type		= ETT_EVENT_HASH,
+	.post_trigger		= true, /* need non-NULL rec */
+	.func			= event_hash_trigger_func,
+	.reg			= register_trigger,
+	.unreg			= unregister_trigger,
+	.get_trigger_ops	= event_hash_get_trigger_ops,
+	.set_filter		= set_trigger_filter,
+};
+
+static __init int register_trigger_hash_cmd(void)
+{
+	int ret;
+
+	ret = register_event_command(&trigger_hash_cmd);
+	WARN_ON(ret < 0);
+
+	return ret;
+}
+
 __init int register_trigger_cmds(void)
 {
 	register_trigger_traceon_traceoff_cmds();
 	register_trigger_snapshot_cmd();
 	register_trigger_stacktrace_cmd();
 	register_trigger_enable_disable_cmds();
+	register_trigger_hash_cmd();
 
 	return 0;
 }
-- 
1.8.3.1

