Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbaHUNx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:53:57 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:37494 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbaHUNxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:53:55 -0400
In-Reply-To: <53F45F3C.5000207@de.ibm.com>
References: <1407659404-razya@il.ibm.com> <20140810083035.0CF58380729@moren.haifa.ibm.com> <53F45F3C.5000207@de.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: abel.gordon@gmail.com, Alex Glikson <GLIKSON@il.ibm.com>,
        Eran Raichstein <ERANRA@il.ibm.com>, Joel Nider <JOELN@il.ibm.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Yossi Kuperman1 <YOSSIKU@il.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] vhost: Add polling mode
X-KeepSent: 9D20825B:8FFA2829-C2257D3B:004A777F;
 type=4; name=$KeepSent
X-Mailer: IBM Notes Release 9.0.1SHF211 December 19, 2013
From: Razya Ladelsky <RAZYA@il.ibm.com>
Message-ID: <OF9D20825B.8FFA2829-ONC2257D3B.004A777F-C2257D3B.004C47BC@il.ibm.com>
Date: Thu, 21 Aug 2014 16:53:47 +0300
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5IF1HF3|November 07, 2013) at
 21/08/2014 16:53:48,
	Serialize complete at 21/08/2014 16:53:48
Content-Type: text/plain; charset="US-ASCII"
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082113-2966-0000-0000-000000E37453
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger <borntraeger@de.ibm.com> wrote on 20/08/2014 
11:41:32 AM:


> > 
> > Results:
> > 
> > Netperf, 1 vm:
> > The polling patch improved throughput by ~33% (1516 MB/sec -> 2046 
MB/sec).
> > Number of exits/sec decreased 6x.
> > The same improvement was shown when I tested with 3 vms running 
netperf
> > (4086 MB/sec -> 5545 MB/sec).
> > 
> > filebench, 1 vm:
> > ops/sec improved by 13% with the polling patch. Number of exits 
> was reduced by
> > 31%.
> > The same experiment with 3 vms running filebench showed similar 
numbers.
> > 
> > Signed-off-by: Razya Ladelsky <razya@il.ibm.com>
> 
> Gave it a quick try on s390/kvm. As expected it makes no difference 
> for big streaming workload like iperf.
> uperf with a 1-1 round robin got indeed faster by about 30%.
> The high CPU consumption is something that bothers me though, as 
> virtualized systems tend to be full.
> 
> 

Thanks for confirming the results!
The best way to use this patch would be along with a shared vhost thread 
for multiple
devices/vms, as described in:
http://domino.research.ibm.com/library/cyberdig.nsf/1e4115aea78b6e7c85256b360066f0d4/479e3578ed05bfac85257b4200427735!OpenDocument
This work assumes having a dedicated I/O core where the vhost thread 
serves multiple vms, which 
makes the high cpu utilization less of a concern. 



> > +static int poll_start_rate = 0;
> > +module_param(poll_start_rate, int, S_IRUGO|S_IWUSR);
> > +MODULE_PARM_DESC(poll_start_rate, "Start continuous polling of 
> virtqueue when rate of events is at least this number per jiffy. If 
> 0, never start polling.");
> > +
> > +static int poll_stop_idle = 3*HZ; /* 3 seconds */
> > +module_param(poll_stop_idle, int, S_IRUGO|S_IWUSR);
> > +MODULE_PARM_DESC(poll_stop_idle, "Stop continuous polling of 
> virtqueue after this many jiffies of no work.");
> 
> This seems ridicoudly high. Even one jiffie is an eternity, so 
> setting it to 1 as a default would reduce the CPU overhead for most 
cases.
> If we dont have a packet in one millisecond, we can surely go back 
> to the kick approach, I think.
> 
> Christian
> 

Good point, will reduce it and recheck.
Thank you,
Razya

