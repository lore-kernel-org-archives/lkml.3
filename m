Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbaJ3Gan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:30:43 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:20962 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaJ3Gam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:30:42 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Fabian Frederick <fabf@skynet.be>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "iss_storagedev@hp.com" <iss_storagedev@hp.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/1 linux-next] hpsa: remove set but unused variable rc
Thread-Topic: [PATCH 1/1 linux-next] hpsa: remove set but unused variable rc
Thread-Index: AQHP84ssxSD1/Ez/9ESDZTGtasvkt5xIJRKAgAAEdHA=
Date: Thu, 30 Oct 2014 06:28:13 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295934CA1C@G9W0745.americas.hpqcorp.net>
References: <1414595704-3119-1-git-send-email-fabf@skynet.be>
 <20141030055517.GC3519@sudip-PC>
In-Reply-To: <20141030055517.GC3519@sudip-PC>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.216.65.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Sudip Mukherjee
> Sent: Thursday, October 30, 2014 12:55 AM
> To: Fabian Frederick
> Cc: linux-kernel@vger.kernel.org; Stephen M. Cameron; James E.J.
> Bottomley; iss_storagedev@hp.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1 linux-next] hpsa: remove set but unused variable
> rc
> 
> On Wed, Oct 29, 2014 at 04:15:04PM +0100, Fabian Frederick wrote:
> > Fix -Wunused-but-set-variable warning
> 
> you should also mention why you have left the call to
> irq_set_affinity_hint().
> i am not sure , but it looks like irq_set_affinity_hint() is only
> checking if
> the lock is available or not. It is just locking ,then if lock is
> successfull then
> returning 0 or if lock fails then return -EINVAL, and unlocks before
> returnig.
> not doing anything else.
> 
> thanks
> sudip

No, that function sets a mask value that shows up in 
	/proc/irq/nnn/affinity_hint
that a program like irqbalance may use to set the CPU affinity mask
for each irq via 
	/proc/irq/nnn/smp_affinity   (bitmap format)
	/proc/irq/nnn/smp_affinity_list   (range format)

The reason is that in many cases, it is best when all these occur 
on the same CPU that submitted the IO:
* LLD submission queues (if multiple are supported)
* LDD completion queues
* MSI-X interrupt indicating completion
* LLD completion interrupt handler
* block layer completion handler

Benefits include:
* cache efficiency - the data structures for the IO aren't
pulled from CPU to CPU.

* avoid IPI overhead in the block layer to get the completion 
processed on the submitting CPU (which is done if using 
rq_affinity=2 and the interrupt is routed to on another CPU).

* self-throttle the CPUs - avoid swamping one CPU with 
completion processing for IOs submitted by many other CPUs
(which leads to stalls on the victim and timeouts on the
aggressors).

You must run irqbalance with an option to honor the hints;
some versions default to that, others don't.  Or, disable
the irqbalance service and set them up the affinities
manually.


