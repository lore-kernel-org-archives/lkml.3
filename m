Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3EUS7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:59:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab3EUS7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:59:08 -0400
Date: Tue, 21 May 2013 21:00:27 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Message-ID: <cover.1369155164.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

This is a patch I sent to Jeff few months ago. As you asked, I am
resending it on top of 3.10-rc2 Linus tree. Jeff has said he
applied this patch, but I am not sure what exactly it means ;)

Also, I am not sure about my reading of the statistics and the
trade-off I identified (below), so this patch is a RFC.

The numbers are taken by running 'if=/dev/sd{a,b,c} of=/dev/null'
All time values is in us.

Before this update host lock average holdtime was 3.266532061 and
average waittime was 0.009832679 [1]. After the update average
holdtime (slightly) rose up to 0.335267418 while average waittime
decreased to 0.000320469 [2]. Which means host lock with local
interrupt disabled is held roughly the same while the average
waittime dropped 30 times.

After this update port events are handled with local interrupts
enabled and compete on individual per-port locks with average
holdtime 1.540987475 and average waittime 0.000714864 [3].
Comparing to [1], ata_scsi_queuecmd() holds port locks 2 times
less and waits for locks 13 times less.

The downside of this change is introduction of a kernel thread
and (supposedly) increased total average time of handling a
AHCI interrupt - at most 1.5 times.

The upside is better access times from ata_scsi_queuecmd() to
port locks and moving port interrupt handling out of the
hardware interrupt context.

Thanks!

Lock usage statistics.

	1. ahci_interrupt vs ata_scsi_queuecmd (host->lock)

Test	holdtime-total	waittime-total	acquisitions	holdtime-avg	waittime-avg
#
01.	22732497.77	93399.89	06393367	3.555637862	0.014608874
02.	20358052.08	52869.72	06454133	3.154265969	0.008191607
03.	20322516.57	54981.40	06459318	3.146232554	0.008511951
04.	18558686.89	39178.05	06469468	2.868657344	0.006055838
05.	19069799.90	31961.00	06455953	2.953831897	0.004950625
06.	23783542.56	97159.79	06387322	3.723554654	0.015211350
07.	23889266.74	102625.45	06386666	3.740491007	0.016068705
08.	19284522.61	32655.91	06450568	2.989585198	0.005062486
							-----------	-----------
avg							3.266532061	0.009832679

	2. ahci_single_irq_intr vs ahci_port_thread_fn (host->lock)


Alexander Gordeev (1):
  AHCI: Optimize interrupt processing

 drivers/ata/acard-ahci.c    |    8 ++---
 drivers/ata/ahci.c          |   54 ++++++++++++++++++-------------
 drivers/ata/ahci.h          |   10 +++--
 drivers/ata/ahci_platform.c |    3 +-
 drivers/ata/libahci.c       |   74 +++++++++++++++++++++++++------------------
 5 files changed, 85 insertions(+), 64 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
