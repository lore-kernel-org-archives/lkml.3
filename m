Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980AbaE2PkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:40:11 -0400
Received: from mx2.netorek.fi ([213.157.84.84]:35221 "EHLO mx2.netorek.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933213AbaE2PkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:40:07 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 May 2014 11:40:06 EDT
Date: Sun, 19 Feb 2006 14:20:54 -0500
From: Maurice Volaski <mvolaski@aecom.yu.edu>
To: drbd-user@linbit.com
Cc: linux-kernel@vger.kernel.org
Subject: [DRBD-user] drbd-0.7.15 crashed doing a full sync under 2.6.13
Message-Id: <20140529153616.E35F7205A36@mx2.netorek.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First posted to drbd mailing list on 2/6 with no reply. It hasn't 
happened since, but once is enough to mean something is wrong 
somewhere.....

I did a resize of all the underlying LVMs and that proceeded very
nicely since drbd automatically recognized the new sizes and
resize2fs automatically figured out the new size, too.

Anyway, bringing up the secondary automatically caused the primary to
start a fully sync. The performance this time was very nice,
averaging 50-55 MB per second across a total of 8 drbd resources, all
syncing simultaneously. Each resource is an underlying logical volume
and is assigned its own TCP port in drbd.conf. The primary has dual
bonded gigabit in active load balancing mode and secondary is single
gigabit.

A total of 5600 GB has to be moved. I am estimating the resources
were between 1/3 and 1/2 finished when the kernel panicked.

The secondary, which is running the same kernel and drbd, did not
panic. The drives in both systems are attached via LSI Logic SCSI
cards and on the primary the driver is mptscsih; on the secondary it
is sym53c8xx.

Unfortunately, I never gotten an easy way to capture the text of a
panic, and apparently attachments are excluded if the message exceeds
40K, so I typed out the whole thing:

ne_endio+243}
<ffffffff8029460b.{__end_that_request_first+283}
<ffffffff802d297c.{scsi_end_request+60}
<ffffffff802d2d7b>{scsi_io_completion+651}
<ffffffff802e1eb1>{sd_rw_intr+721}
<ffffffff802d25cf>{scsi_device_unbusy+95}
<ffffffff802cd722>{scsi_softirq+258}
<ffffffff8013b111>{__do_softirq+113}
<ffffffff8010ee63>{call_softirq+31}
<ffffffff80110a55>{do_softirq+53} <ffffffff80119a0f>{do_IRQ+79}
<ffffffff8010e20a>{ret_from_intr+0} <EOI>
<ffffffff880bda221>{:drbd:drbd_bm_clear_bit+497}
<ffffffff880bda21>{:drbd:drbd_bm_clear_bit+497}
<ffffffff880ccc21>{:drbd:__drbd_set_in_sync+545}
<ffffffff880c9140>{:drbd:got_BlockAck+96}
<ffffffff880c9a99>{:drbd:drbd_asender+1081}
<ffffffff880ce526>{:drbd:drbd_thread_setup+190}
<ffffffff8010e91a>{child_rip+8}
<ffffffff880ce460>{:drbd:drbd_thread_setup+0>
<ffffffff8010e912>{child_rip+0}

Code: 80 3b 00 7e f9 e9 89 fb ff ff e8 40 27 ef ff e9 01 fc ff ff
console shuts up...
   <0>Kernel panic --not syncing:Aiee, killing interrupt handler!

keywords: crash, freeze, freezing, hang, hung, panic, locked up,
scsi, thread, threads, interrupt handler, bug, race condition.
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
_______________________________________________
drbd-user mailing list
drbd-user@lists.linbit.com
http://lists.linbit.com/mailman/listinfo/drbd-user


