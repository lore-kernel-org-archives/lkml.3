Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaJSTgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 15:36:12 -0400
Received: from www17.your-server.de ([213.133.104.17]:37620 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaJSTgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 15:36:08 -0400
Message-ID: <1413747337.2991.36.camel@localhost.localdomain>
Subject: Re: [uml-devel] kernel stalls in balance_dirty_pages_ratelimited()
From: Thomas Meyer <thomas@m3y3r.de>
To: Anton Ivanov <anton.ivanov@kot-begemot.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
In-Reply-To: <5443E097.2000801@kot-begemot.co.uk>
References: <1413236904.13916.13.camel@localhost.localdomain>
	 <543CB6BA.9030907@kot-begemot.co.uk>	<543CC5FE.4000601@kot-begemot.co.uk>
	 <1413271301.13744.13.camel@localhost.localdomain>
	 <543CD148.7010904@kot-begemot.co.uk>
	 <1413730776.2991.16.camel@localhost.localdomain>
	 <5443E097.2000801@kot-begemot.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Oct 2014 21:35:37 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 19.10.2014, 17:02 +0100 schrieb Anton Ivanov:
> On 19/10/14 15:59, Thomas Meyer wrote:
> > Am Dienstag, den 14.10.2014, 08:31 +0100 schrieb Anton Ivanov:
> >> I see a very similar stall on writeout to ubd with my patches (easy) and 
> >> without (difficult - takes running an IO soak for a few days).
> >>
> >> It stalls (usually) when trying to flush the journal file of ext4.
> > Hi,
> >
> > here an extract of the trace of all writeback:* tracepoints:
> >
> >              yum-1553  [000] ....  1246.020000: balance_dirty_pages: bdi 98:0: limit=24732 setpoint=16229 dirty=18446744073709551284 bdi_setpoint=16227 bdi_dirty=1 dirty_ratelimit=4 task_ratelimit=0 dirtied=1 dirtied_pause=0 paused=0 pause=10 period=10 think=0
> >     kworker/u2:0-2603  [000] ....  1246.020000: global_dirty_state: dirty=18446744073709551284 writeback=0 unstable=0 bg_thresh=5151 thresh=10303 limit=24732 dirtied=340955 written=358957
> >     kworker/u2:0-2603  [000] ....  1246.020000: global_dirty_state: dirty=18446744073709551284 writeback=0 unstable=0 bg_thresh=5151 thresh=10303 limit=24732 dirtied=340955 written=358957
> >     kworker/u2:0-2603  [000] ....  1246.020000: writeback_start: bdi 98:0: sb_dev 0:0 nr_pages=9223372036854775807 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
> >     kworker/u2:0-2603  [000] ....  1246.020000: writeback_queue_io: bdi 98:0: older=4295061898 age=0 enqueue=1 reason=background
> >     kworker/u2:0-2603  [000] ....  1246.020000: writeback_single_inode_start: bdi 98:0: ino=29951 state=I_DIRTY_SYNC|I_DIRTY_PAGES|I_SYNC dirtied_when=4295061898 age=8 index=9 to_write=1024 wrote=0
> >     kworker/u2:0-2603  [000] ....  1246.020000: writeback_write_inode_start: bdi 98:0: ino=29951 sync_mode=0
> >     kworker/u2:0-2603  [000] ....  1246.020000: writeback_write_inode: bdi 98:0: ino=29951 sync_mode=0
> >     kworker/u2:0-2603  [000] ....  1246.020000: writeback_single_inode: bdi 98:0: ino=29951 state=I_SYNC dirtied_when=4295061898 age=8 index=9 to_write=1024 wrote=1
> >     kworker/u2:0-2603  [000] ....  1246.020000: writeback_written: bdi 98:0: sb_dev 0:0 nr_pages=9223372036854775806 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
> >     kworker/u2:0-2603  [000] ....  1246.020000: global_dirty_state: dirty=18446744073709551283 writeback=0 unstable=0 bg_thresh=5151 thresh=10303 limit=24732 dirtied=340955 written=358958
> >     kworker/u2:0-2603  [000] ....  1246.020000: writeback_start: bdi 98:0: sb_dev 0:0 nr_pages=9223372036854775806 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
> >     kworker/u2:0-2603  [000] ....  1246.020000: writeback_queue_io: bdi 98:0: older=4295061898 age=0 enqueue=0 reason=background
> >     kworker/u2:0-2603  [000] ....  1246.020000: writeback_written: bdi 98:0: sb_dev 0:0 nr_pages=9223372036854775806 sync_mode=0 kupdate=0 range_cyclic=1 background=1 reason=background
> >     kworker/u2:0-2603  [000] ....  1246.020000: writeback_pages_written: 1
> >
> > I wonder why "global_dirty_state: dirty=18446744073709551284" can get so high!
> > I think this is maybe an signed long, but "nr_dirty" should be a unsigned long. Two's complement of above value is 332...
> >
> > I'm not sure what's going on here...
> 
> Neither am I, but, unless I am mistaken, it does look like the writeout
> just stops working and the dirty starts to grow uncontrolled. :)
> 
> >
> > any ideas?
> 
> I had some suspicion of a race somewhere in the UML VM subsystem. I
> sprinked barrier() all over it, nope not the case.
> 
> I have gone through the ubd driver itself with a microscope ~ 3 times,
> cannot see anything wrong with the logic. While it does not win a beauty
> contest, it does seem like it should work.
> 
> All I know is that my fixes to UBD and the replacement epoll IRQ
> controller for UML make it more likely, however, you can trigger it with
> the stock UML too.

this is a trace with traceoff with the first global_dirty_state nr_dirty > 1000000

    kworker/u2:2-112   [000] ....   541.590000: writeback_write_inode_start: bdi 98:0: ino=51 sync_mode=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_write_inode: bdi 98:0: ino=51 sync_mode=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_single_inode: bdi 98:0: ino=51 state=I_SYNC dirtied_when=4294988447 age=117 index=69 to_write=4096 wrote=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_single_inode_start: bdi 98:0: ino=52 state=I_DIRTY_SYNC|I_DIRTY_DATASYNC|I_DIRTY_PAGES|I_SYNC dirtied_when=4294988448 age=117 index=4 to_write=4096 wrote=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_write_inode_start: bdi 98:0: ino=52 sync_mode=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_write_inode: bdi 98:0: ino=52 sync_mode=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_single_inode: bdi 98:0: ino=52 state=I_SYNC dirtied_when=4294988448 age=117 index=4 to_write=4096 wrote=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_single_inode_start: bdi 98:0: ino=53 state=I_DIRTY_SYNC|I_DIRTY_PAGES|I_SYNC dirtied_when=4294988448 age=117 index=7 to_write=4096 wrote=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_write_inode_start: bdi 98:0: ino=53 sync_mode=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_write_inode: bdi 98:0: ino=53 sync_mode=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_single_inode: bdi 98:0: ino=53 state=I_SYNC dirtied_when=4294988448 age=117 index=7 to_write=4096 wrote=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_single_inode_start: bdi 98:0: ino=54 state=I_DIRTY_SYNC|I_DIRTY_PAGES|I_SYNC dirtied_when=4294988448 age=117 index=18 to_write=4096 wrote=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_write_inode_start: bdi 98:0: ino=54 sync_mode=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_write_inode: bdi 98:0: ino=54 sync_mode=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_single_inode: bdi 98:0: ino=54 state=I_SYNC dirtied_when=4294988448 age=117 index=18 to_write=4096 wrote=0
    kworker/u2:2-112   [000] ....   541.590000: writeback_written: bdi 98:0: sb_dev 0:0 nr_pages=15382 sync_mode=0 kupdate=1 range_cyclic=1 background=0 reason=periodic
    kworker/u2:2-112   [000] ....   541.590000: writeback_start: bdi 98:0: sb_dev 0:0 nr_pages=15382 sync_mode=0 kupdate=1 range_cyclic=1 background=0 reason=periodic
    kworker/u2:2-112   [000] ....   541.590000: writeback_queue_io: bdi 98:0: older=4294988455 age=30000 enqueue=0 reason=periodic
    kworker/u2:2-112   [000] ....   541.590000: writeback_written: bdi 98:0: sb_dev 0:0 nr_pages=15382 sync_mode=0 kupdate=1 range_cyclic=1 background=0 reason=periodic
    kworker/u2:2-112   [000] ....   541.590000: global_dirty_state: dirty=18446744073709551604 writeback=30 unstable=0 bg_thresh=6954 thresh=13909 limit=24789 dirtied=278225 written=295588

So something seems to mess with global_page_state(NR_FILE_DIRTY) which
is vm_stat[11].counter
and indeed vm_stat is defined as signed long, that explains the negativ
value.

Maybe some unbalanced calls between dec/inc_zone_page_state(page, NR_FILE_DIRTY)?

Is it possible in gdb to set a watchpoint on vm_stat[11].counter when a value < 0 is written to this address?

> >> On 14/10/14 08:21, Thomas Meyer wrote:
> >>> Am Dienstag, den 14.10.2014, 07:43 +0100 schrieb Anton Ivanov:
> >>>> On 14/10/14 06:38, Anton Ivanov wrote:
> >>>>> How does the stall manifest itself?
> >>>>>
> >>>>> Do you have the journal thread (and sometimes a couple of other threads)
> >>>>> sitting in D state?
> >>>> Sorry, should not be asking questions at 6 am before the 3rd double
> >>>> espresso.
> >>>>
> >>>> I think it is the same bug I am chasing - a stall in ubd, you hit it on
> >>>> swap while I hit it in normal operation on a swapless system. I see a
> >>>> stall in the journal instead of a backing dev stall.
> >>>>
> >>>> If you apply the ubd patches out of my patchsets, you can trigger this
> >>>> one with ease. In theory, all they do is to make UBD faster so they
> >>>> should not by themselves introduce new races. They may however make the
> >>>> older ones more pronounced.
> >>>>
> >>>> My working hypothesis is a race somewhere in the vm subsystem. I have
> >>>> been unable to nail it though.
> >>> Hi Anton,
> >>>
> >>> I see this bug on a 3.17 uml kernel with the sync fix patch from
> >>> Thorsten Knabe applied.
> >>>
> >>> The stall has to do with the writepage ratelimit mechanism, as the
> >>> mechanism seems to reach a state where it tries to write out page, per
> >>> page:
> >>>
> >>> Breakpoint 1, balance_dirty_pages (pages_dirtied=1, mapping=<optimized out>) at	mm/page-writeback.c:1338
> >>> (gdb) bt
> >>> #0  balance_dirty_pages	(pages_dirtied=1, mapping=<optimized out>) at mm/page-writeback.c:1338
> >>>
> >>> pages_dirtied = 1 !!
> >>>
> >>> #0  try_to_grab_pending (work=0x7fa2a348, is_dwork=true, flags=0x72ff5ab8) at kernel/workqueue.c:1159
> >>> #1  0x0000000060051feb in mod_delayed_work_on (cpu=2141365064, wq=0x1, dwork=0x72ff5ab8, delay=<optimized out>) at kernel/workqueue.c:1510
> >>> #2  0x00000000600f382c in mod_delayed_work (delay=<optimized out>, dwork=<optimized out>, wq=<optimized out>) at include/linux/workqueue.h:504
> >>> #3  bdi_wakeup_thread (bdi=<optimized out>) at fs/fs-writeback.c:98
> >>> #4  0x00000000600f4aca in bdi_start_background_writeback (bdi=<optimized out>) at fs/fs-writeback.c:179
> >>> #5  0x000000006042d4c0 in balance_dirty_pages (pages_dirtied=<optimized out>, mapping=<optimized out>) at mm/page-writeback.c:1408
> >>> #6  0x00000000600a6e1a in balance_dirty_pages_ratelimited (mapping=<optimized out>) at mm/page-writeback.c:1627
> >>> #7  0x00000000600ba54f in do_wp_page (mm=<optimized out>, vma=<optimized out>, address=<optimized out>, page_table=<optimized out>, pmd=<optimized out>, orig_pte=..., ptl=<optimized out>) at mm/memory.c:2178
> >>> #8  0x00000000600bc986 in handle_pte_fault (flags=<optimized out>, pmd=<optimized out>, pte=<optimized out>, address=<optimized out>, vma=<optimized out>, mm=<optimized out>) at mm/memory.c:3230
> >>> #9  __handle_mm_fault (flags=<optimized out>, address=<optimized out>, vma=<optimized out>, mm=<optimized out>) at mm/memory.c:3335
> >>> #10 handle_mm_fault (mm=<optimized out>, vma=0x7f653228, address=1472490776, flags=<optimized out>) at mm/memory.c:3364
> >>> #11 0x0000000060028cec in handle_page_fault (address=1472490776, ip=<optimized out>, is_write=<optimized out>, is_user=0, code_out=<optimized out>) at arch/um/kernel/trap.c:75
> >>> #12 0x00000000600290d7 in segv (fi=..., ip=1228924391, is_user=<optimized out>, regs=0x73eb8de8) at arch/um/kernel/trap.c:222
> >>> #13 0x0000000060029395 in segv_handler (sig=<optimized out>, unused_si=<optimized out>, regs=<optimized out>) at arch/um/kernel/trap.c:191
> >>> #14 0x0000000060039c0f in userspace (regs=0x73eb8de8) at arch/um/os-Linux/skas/process.c:429
> >>> #15 0x0000000060026a8c in fork_handler () at arch/um/kernel/process.c:149
> >>> #16 0x000000000070b620 in ?? ()
> >>> #17 0x0000000000000000 in ?? ()
> >>>
> >>> I'm not sure if this is the same error you encounter.
> >>>
> >>> This is on an ubd device with a cow image attached to it.
> >>>
> >>> The original ubd file and the cow file are spares ones, and do also
> >>> contain a swap partition.
> >>>
> >>> I hope to get tracepoints/perf working, now as there is stacktrace
> >>> support in uml. An interessting tracepoint would be
> >>> TRACE_EVENT(bdi_dirty_ratelimit) or TRACE_EVENT(balance_dirty_pages)
> >>>
> >>>
> >>>> A.
> >>>>
> >>>>> A.
> >>>>>
> >>>>> On 13/10/14 22:48, Thomas Meyer wrote:
> >>>>>> #0  balance_dirty_pages_ratelimited (mapping=0x792cc618) at mm/page-writeback.c:1587
> >>>>>> #1  0x00000000600ba54f in do_wp_page (mm=<optimized out>, vma=<optimized out>, address=<optimized out>, page_table=<optimized out>, pmd
> >>>>>> =<optimized out>, orig_pte=..., ptl=<optimized out>) at mm/memory.c:2178
> >>>>>> #2  0x00000000600bc986 in handle_pte_fault (flags=<optimized out>, pmd=<optimized out>, pte=<optimized out>, address=<optimized out>, v
> >>>>>> ma=<optimized out>, mm=<optimized out>) at mm/memory.c:3230
> >>>>>> #3  __handle_mm_fault (flags=<optimized out>, address=<optimized out>, vma=<optimized out>, mm=<optimized out>) at mm/memory.c:3335
> >>>>>> #4  handle_mm_fault (mm=<optimized out>, vma=0x78008e88, address=1462695424, flags=<optimized out>) at mm/memory.c:3364
> >>>>>> #5  0x0000000060028cec in handle_page_fault (address=1462695424, ip=<optimized out>, is_write=<optimized out>, is_user=0, code_out=<opt
> >>>>>> imized out>) at arch/um/kernel/trap.c:75
> >>>>>> #6  0x00000000600290d7 in segv (fi=..., ip=1228924391, is_user=<optimized out>, regs=0x624f5728) at arch/um/kernel/trap.c:222
> >>>>>> #7  0x0000000060029395 in segv_handler (sig=<optimized out>, unused_si=<optimized out>, regs=<optimized out>) at arch/um/kernel/trap.c:
> >>>>>> 191
> >>>>>> #8  0x0000000060039c0f in userspace (regs=0x624f5728) at arch/um/os-Linux/skas/process.c:429
> >>>>>> #9  0x0000000060026a8c in fork_handler () at arch/um/kernel/process.c:149
> >>>>>> #10 0x0000000000000000 in ?? ()
> >>>>>>
> >>>>>> backing_dev_info:
> >>>>>> p *mapping->backing_dev_info
> >>>>>> $2 = {bdi_list = {next = 0x605901a0 <bdi_list>, prev = 0x80a42890}, ra_pages = 32, state = 8, capabilities = 4, congested_fn = 0x0, con
> >>>>>> gested_data = 0x0, name = 0x604fb827 "block", bdi_stat = {{count = 4}, {count = 0}, {count = 318691}, {count = 314567}}, bw_time_stamp
> >>>>>> = 4339445229, dirtied_stamp = 318686, written_stamp = 314564, write_bandwidth = 166, avg_write_bandwidth = 164, dirty_ratelimit = 1, ba
> >>>>>> lanced_dirty_ratelimit = 1, completions = {events = {count = 3}, period = 4481, lock = {raw_lock = {<No data fields>}}}, dirty_exceeded
> >>>>>>    = 0, min_ratio = 0, max_ratio = 100, max_prop_frac = 1024, wb = {bdi = 0x80a42278, nr = 0, last_old_flush = 4339445229, dwork = {work
> >>>>>> = {data = {counter = 65}, entry = {next = 0x80a42350, prev = 0x80a42350}, func = 0x600f4b25 <bdi_writeback_workfn>}, timer = {entry = {
> >>>>>> next = 0x606801a0 <boot_tvec_bases+4896>, prev = 0x803db650}, expires = 4339445730, base = 0x6067ee82 <boot_tvec_bases+2>, function = 0
> >>>>>> x60051dbb <delayed_work_timer_fn>, data = 2158240584, slack = -1}, wq = 0x808d9c00, cpu = 1}, b_dirty = {next = 0x7a4ce1f8, prev = 0x80
> >>>>>> 6ad9a8}, b_io = {next = 0x80a423c0, prev = 0x80a423c0}, b_more_io = {next = 0x80a423d0, prev = 0x80a423d0}, list_lock = {{rlock = {raw_
> >>>>>> lock = {<No data fields>}}}}}, wb_lock = {{rlock = {raw_lock = {<No data fields>}}}}, work_list = {next = 0x80a423e0, prev = 0x80a423e0
> >>>>>> }, dev = 0x80b68e00, laptop_mode_wb_timer = {entry = {next = 0x0, prev = 0x0}, expires = 0, base = 0x6067ee80 <boot_tvec_bases>, functi
> >>>>>> on = 0x600a6efd <laptop_mode_timer_fn>, data = 2158240008, slack = -1}, debug_dir = 0x80419e58, debug_stats = 0x80419d98}
> >>>>>>
> >>>>>> when i set the cap_dirty from the backing-dev ( capabilities = 5 ) the system comes back to normal.
> >>>>>>
> >>>>>> any ideas what's going on here?
> >>>>>>
> >>>>>> with kind regards
> >>>>>> thomas
> >



