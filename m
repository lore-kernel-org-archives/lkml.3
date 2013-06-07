Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3FGToX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:44:23 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:46942 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755102Ab3FGToV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:44:21 -0400
Date: Fri, 7 Jun 2013 14:37:12 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: 3.10-rc4 stalls during mmap writes
Message-ID: <20130607193712.GD2995@sbohrermbp13-local.rgmadvisors.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've started testing the 3.10 kernel, previously I was on 3.4, and I'm
encounting some fairly large stalls in my memory mapped writes in the
range of .01 to 1s.  I've managed to capture two of these stalls so
far and both looked like the following:

1) Writing process writes to a new page and blocks on xfs_ilock:

    <...>-21567 [009]  9435.453069: sched_switch:     prev_comm=tick_receiver_m prev_pid=21567 prev_prio=79 prev_state=D ==> next_comm=swapper/9 next_pid=0 next_prio=120
    <...>-21567 [009]  9435.453072: kernel_stack:     <stack trace>
=> schedule (ffffffff814ca379)
=> rwsem_down_write_failed (ffffffff814cb095)
=> call_rwsem_down_write_failed (ffffffff81275053)
=> xfs_ilock (ffffffff8120b25c)
=> xfs_vn_update_time (ffffffff811cf3d3)
=> update_time (ffffffff81158dd3)
=> file_update_time (ffffffff81158f0c)
=> block_page_mkwrite (ffffffff81171d23)
=> xfs_vm_page_mkwrite (ffffffff811c5375)
=> do_wp_page (ffffffff8110c27f)
=> handle_pte_fault (ffffffff8110dd24)
=> handle_mm_fault (ffffffff8110f430)
=> __do_page_fault (ffffffff814cef72)
=> do_page_fault (ffffffff814cf2e7)
=> page_fault (ffffffff814cbab2)

2) kworker calls xfs_iunlock and wakes up my process:

   kworker/u50:1-403   [013]  9436.027354: sched_wakeup:     comm=tick_receiver_m pid=21567 prio=79 success=1 target_cpu=009
   kworker/u50:1-403   [013]  9436.027359: kernel_stack:     <stack trace>
=> ttwu_do_activate.constprop.34 (ffffffff8106c556)
=> try_to_wake_up (ffffffff8106e996)
=> wake_up_process (ffffffff8106ea87)
=> __rwsem_do_wake (ffffffff8126e531)
=> rwsem_wake (ffffffff8126e62a)
=> call_rwsem_wake (ffffffff81275077)
=> xfs_iunlock (ffffffff8120b55c)
=> xfs_iomap_write_allocate (ffffffff811ce4e7)
=> xfs_map_blocks (ffffffff811bf145)
=> xfs_vm_writepage (ffffffff811bfbc2)
=> __writepage (ffffffff810f14e7)
=> write_cache_pages (ffffffff810f189e)
=> generic_writepages (ffffffff810f1b3a)
=> xfs_vm_writepages (ffffffff811bef8d)
=> do_writepages (ffffffff810f3380)
=> __writeback_single_inode (ffffffff81166ae5)
=> writeback_sb_inodes (ffffffff81167d4d)
=> __writeback_inodes_wb (ffffffff8116800e)
=> wb_writeback (ffffffff811682bb)
=> wb_check_old_data_flush (ffffffff811683ff)
=> wb_do_writeback (ffffffff81169bd1)
=> bdi_writeback_workfn (ffffffff81169cca)
=> process_one_work (ffffffff81059104)
=> worker_thread (ffffffff8105a1bc)
=> kthread (ffffffff810605f0)
=> ret_from_fork (ffffffff814d395c)

In this case my process stalled for roughly half a second:

<...>-21567 [009]  9436.027388: print:                tracing_mark_write: stall of 0.574282

So I guess my question is does anyone know why I'm now seeing these
stalls with 3.10?  Are there any suggestions for how to eliminate them?

# xfs_info /home/
meta-data=/dev/sda5              isize=256    agcount=4, agsize=67774016 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=271096064, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=132371, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# grep sda5 /proc/mounts 
/dev/sda5 /home xfs rw,noatime,nodiratime,attr2,nobarrier,inode64,noquota 0 0

Thanks,
Shawn

-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
