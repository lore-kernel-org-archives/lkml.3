Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaJTUBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 16:01:50 -0400
Received: from www17.your-server.de ([213.133.104.17]:59054 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaJTUBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 16:01:49 -0400
Message-ID: <1413835305.2991.46.camel@localhost.localdomain>
Subject: Re: [uml-devel] kernel stalls in balance_dirty_pages_ratelimited()
From: Thomas Meyer <thomas@m3y3r.de>
To: Anton Ivanov <anton.ivanov@kot-begemot.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Date: Mon, 20 Oct 2014 22:01:45 +0200
In-Reply-To: <1413747337.2991.36.camel@localhost.localdomain>
References: <1413236904.13916.13.camel@localhost.localdomain>
	 <543CB6BA.9030907@kot-begemot.co.uk>	<543CC5FE.4000601@kot-begemot.co.uk>
	 <1413271301.13744.13.camel@localhost.localdomain>
	 <543CD148.7010904@kot-begemot.co.uk>
	 <1413730776.2991.16.camel@localhost.localdomain>
	 <5443E097.2000801@kot-begemot.co.uk>
	 <1413747337.2991.36.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 19.10.2014, 21:35 +0200 schrieb Thomas Meyer:
> Am Sonntag, den 19.10.2014, 17:02 +0100 schrieb Anton Ivanov:
> > On 19/10/14 15:59, Thomas Meyer wrote:
> > > Am Dienstag, den 14.10.2014, 08:31 +0100 schrieb Anton Ivanov:
> > >> I see a very similar stall on writeout to ubd with my patches (easy) and 
> > >> without (difficult - takes running an IO soak for a few days).
> > >>
> > >> It stalls (usually) when trying to flush the journal file of ext4.
> > > any ideas?
> > 
> > I had some suspicion of a race somewhere in the UML VM subsystem. I
> > sprinked barrier() all over it, nope not the case.
> > 

I added this patch to the uml kernel:

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 82e7db7..7f35fa4 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -241,6 +241,10 @@ static inline void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 {
        atomic_long_dec(&zone->vm_stat[item]);
+       if (&vm_stat[item] == &vm_stat[NR_FILE_DIRTY] &&
+               atomic_long_read(&vm_stat[item]) < 0) {
+               asm("int3");
+       }
        atomic_long_dec(&vm_stat[item]);
 }


And this is the backtrace leading to the negative nr_dirty value:

Program received signal SIGTRAP, Trace/breakpoint trap.
__dec_zone_state (item=<optimized out>, zone=<optimized out>) at include/linux/vmstat.h:248
(gdb) bt
#0  __dec_zone_state (item=<optimized out>, zone=<optimized out>) at include/linux/vmstat.h:248
#1  __dec_zone_page_state (item=<optimized out>, page=<optimized out>) at include/linux/vmstat.h:260
#2  clear_page_dirty_for_io (page=0x628b7308) at mm/page-writeback.c:2333
#3  0x0000000060188c36 in mpage_submit_page (mpd=0x808ebb90, page=<optimized out>) at fs/ext4/inode.c:1785
#4  0x000000006018917e in mpage_map_and_submit_buffers (mpd=0x808ebb90) at fs/ext4/inode.c:1981
#5  0x000000006018d64a in mpage_map_and_submit_extent (give_up_on_write=<optimized out>, mpd=<optimized out>, handle=<optimized out>) at fs/ext4/inode.c:2123
#6  ext4_writepages (mapping=<optimized out>, wbc=<optimized out>) at fs/ext4/inode.c:2428
#7  0x00000000600f0838 in do_writepages	(mapping=<optimized out>, wbc=<optimized out>) at mm/page-writeback.c:2043
#8  0x0000000060143d29 in __writeback_single_inode (inode=0x75e191a8, wbc=0x808ebcb8) at fs/fs-writeback.c:461
#9  0x0000000060144c00 in writeback_sb_inodes (sb=<optimized out>, wb=0x80a92330, work=0x808ebe00) at fs/fs-writeback.c:688
#10 0x0000000060144e0e in __writeback_inodes_wb (wb=0x808eb990,	work=0x628b7308) at fs/fs-writeback.c:733
#11 0x0000000060144f8d in wb_writeback (wb=0x80a92330, work=0x808ebe00) at fs/fs-writeback.c:864
#12 0x0000000060145375 in wb_check_old_data_flush (wb=<optimized out>) at fs/fs-writeback.c:979
#13 wb_do_writeback (wb=<optimized out>) at fs/fs-writeback.c:1014
#14 bdi_writeback_workfn (work=0x808eb990) at fs/fs-writeback.c:1044
#15 0x00000000600690a2 in process_one_work (worker=0x808c3700, work=0x80a92340)	at kernel/workqueue.c:2023
#16 0x0000000060069b5e in worker_thread	(__worker=0x808eb990) at kernel/workqueue.c:2155
#17 0x000000006006dd9f in kthread (_create=0x80822040) at kernel/kthread.c:207
#18 0x000000006003ab59 in new_thread_handler ()	at arch/um/kernel/process.c:129
#19 0x0000000000000000 in ?? ()



