Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaAQBVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:21:10 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47372 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaAQBVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:21:09 -0500
Date: Thu, 16 Jan 2014 17:21:05 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Hugh Dickins <hughd@google.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: next bio iters break discard?
Message-ID: <20140117012105.GS9037@kmo>
References: <alpine.LSU.2.11.1401121909160.1239@eggly.anvils>
 <20140114023346.GN9037@kmo>
 <yq161pnmcl2.fsf@sermon.lab.mkp.net>
 <20140114044841.GO9037@kmo>
 <yq1ob3el3mr.fsf@sermon.lab.mkp.net>
 <20140114222424.GA7333@moria.home.lan>
 <alpine.LSU.2.11.1401161129380.1321@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1401161129380.1321@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 12:21:10PM -0800, Hugh Dickins wrote:
> For me this just shifts the crash,
> from __blk_recalc_rq_segments() to blk_rq_map_sg():
> 
> blk_rq_map_sg
> scsi_init_sgtable
> scsi_init_io
> scsi_setup_blk_pc_cmnd
> sd_prep_fn
> blk_peek_request
> scsi_request_fn
> __blk_run_queue
> blk_run_queue
> scsi_run_queue
> scsi_next_command
> scsi_io_completion
> scsi_finish_command
> scsi_softirq_done
> blk_done_softirq
> __do_softirq
> irq_exit
> do_IRQ
> common_interrupt
> <EOI>
> cpuidle_idle_call
> arch_cpu_idle
> cpu_startup_entry
> start_secondary
> 
> It's GPF'ing on struct scatter_list *sg 0x800000001473e064 in
> 
> static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
> {
> 	unsigned long page_link = sg->page_link & 0x3;
> 
> It appears to be in the static inline __blk_segment_map_sg(),
> and that GPF'ing address is what it just got from sg_next().
> 
> Sorry, this isn't the kind of dump you'll be used to, but it's the
> best I can do at the moment, and I've just had to reboot the machine.
> 
> O, tried again and it hit the BUG_ON(count > sdb->table.nents)
> on line 1048 of drivers/scsi/scsi_lib.c:
> 
> scsi_init_sgtable
> <IRQ> scsi_init_io
> scsi_setup_blk_pc_cmnd
> sd_setup_discard_cmnd
> sd_prep_fn
> blk_peek_request
> etc. as before

Ok, I reread the code and figured it out - the analagous change also has to be
made in __blk_segment_map_sg(). I'll mail out a patch for this tomorrow after
I've stared at the code more and had less beer.
