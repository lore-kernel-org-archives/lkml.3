Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab3CFLVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:21:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757401Ab3CFLVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:21:30 -0500
Date: Wed, 6 Mar 2013 12:26:12 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH RFC 0/1] AHCI: Optimize interrupt processing
Message-ID: <cover.1362568800.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

As I am not sure about my reading of the statistics and the
trade-off I identified (below), this patch a RFC.

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

Test	holdtime-total	waittime-total	acquisitions	holdtime-avg	waittime-avg
#
01.	7572820.95	08414.47	21614279	0.350361951	0.000389301
02.	7029942.02	02992.88	21680248	0.324255609	0.000138046
03.	7298791.32	05974.01	21701755	0.336322630	0.000275278
04.	7077621.26	04360.66	21745564	0.325474256	0.000275278
05.	7606619.38	12158.88	21832248	0.348412100	0.000556923
06.	7605174.70	12205.41	21828021	0.348413386	0.000559162
07.	7058514.97	03701.46	21740632	0.324669263	0.000170255
08.	7039641.91	04331.74	21711867	0.324230151	0.000199510
							-----------	-----------
avg							0.335267418	0.000320469

	3. ahci_port_thread_fn vs ata_scsi_queuecmd (pp->lock)

Test	holdtime-total	waittime-total	acquisitions	holdtime-avg	waittime-avg
#
01.	38531452.56	24236.62	21752844	1.771329421	0.001114182
02.	00024050.92	00005.84	00015999	1.503276455	0.000365023
03.	34071257.07	09699.50	21829593	1.560782973	0.000444328
04.	00019086.10	00001.37	00016054	1.188868818	0.000085337
05.	36535324.31	20676.43	21949439	1.664522009	0.000942003
06.	37433608.34	22942.34	21945295	1.705769202	0.001045433
07.	31456091.88	19895.22	21862170	1.438836670	0.000910030
08.	32628001.94	17739.99	21831844	1.494514249	0.000812574
							-----------	-----------
avg							1.540987475	0.000714864

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
