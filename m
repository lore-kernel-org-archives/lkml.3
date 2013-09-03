Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3ICOz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:55:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab3ICOzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:55:24 -0400
Date: Tue, 3 Sep 2013 16:57:19 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 0/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130903145719.GB14221@dhcp-26-207.brq.redhat.com>
References: <cover.1378111919.git.agordeev@redhat.com>
 <20130903135541.GB10522@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903135541.GB10522@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 09:55:41AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Mon, Sep 02, 2013 at 10:59:07AM +0200, Alexander Gordeev wrote:
> > This series is aimed to conserve on othewise wasted interrupt
> > resources for 10 of 16 unused MSI vectors for AHCI devices on
> > Intel chipsets.
> 
> Hmmm.... I've been looking at the code and and a curiosity.  Why does
> multiple MSI support implicitly enabled threaded IRQ handling?  Why
> are those two linked?  Also, do you have any numbers to show that this
> actually is better?  Handling the processing off to a thread isn't a
> light operation.

Just to emphasize the purpose of this series - it is aimed on configuring
(allocating x86 vectors, irq_desc's etc.) 6/16 interrupts instead of current
16/16 - while 10/16 are unused. Nothing more.

Multiple MSI support enables threaded IRQ handling, because at the time of
posting I did not want to intrude into the existing single-MSI codebase while
multiple MSI/multipe CPU approach gained good numbers (below).

Besides, the ports interrupt handling moved from the interrupt-disabled
hardware context to the interrupt-enabled threaded context and also ports
got per-port locks instead of the single host lock. AFAIR I did not post
the numbers, but it was something close to no-contention.


Host-wide lock statistics summary:

  Taken using command 'if=/dev/sd{a,b,c} of=/dev/null' running in parallel
  on three SATA HDDs:
	ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
	ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
	ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)

  ahci_interrupt()
  Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-

Test	holdtime-total	waittime-total	acquis.	holdtime-avg	waittime-avg
#
01.	22565801.27	93056.41	6377094	3.538571216	0.014592291
02.	20358324.12	60825.47	6411012	3.175524257	0.009487655
03.	21190730.38	63610.38	6384508	3.319085884	0.009963239
04.	22491064.54	80624.96	6398390	3.515113105	0.012600820
05.	21986193.10	78034.38	6379092	3.446602291	0.012232835
06.	20556437.70	62314.64	6287673	3.269323596	0.009910604
07.	20477137.55	66190.92	6388507	3.205308776	0.010360937
08.	21442240.03	69306.80	6402109	3.349246323	0.010825620
						-----------	-----------
avg						3.352346931	0.011246750

  ahci_hw_interrupt()
  Capabilities: [80] MSI: Enable+ Count=16/16 Maskable- 64bit-

Test	holdtime-total	waittime-total	acquis.	holdtime-avg	waittime-avg
#
09.	8936643.32	54559.79	6505606	1.373683454	0.008386581
10.	8579972.36	51496.56	6496233	1.320761180	0.007927142
11.	8138708.47	54061.46	6494647	1.253141005	0.008324003
12.	8322068.81	60427.51	6509975	1.278356493	0.009282295
13.	8527745.18	65978.83	6515589	1.308821839	0.010126303
14.	8662461.99	57291.39	6510702	1.330495850	0.008799572
15.	8054911.26	69186.41	6514262	1.236504037	0.010620759
16.	9618631.17	39726.37	6517385	1.475842101	0.006095446
						-----------	-----------
avg						1.322200745	0.008695263


> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
