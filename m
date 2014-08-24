Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaHXM0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 08:26:42 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:33947 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaHXM0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 08:26:39 -0400
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1747D7F3@AcuExch.aculab.com>
References: <1407659404-razya@il.ibm.com> <20140810083035.0CF58380729@moren.haifa.ibm.com> <20140820105710.GC17371@redhat.com> <OFBE98487F.0F49BDD7-ONC2257D3B.004C908C-C2257D3B.004F09FD@il.ibm.com> <063D6719AE5E284EB5DD2968C1650D6D1747D7F3@AcuExch.aculab.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "abel.gordon@gmail.com" <abel.gordon@gmail.com>,
        Alex Glikson <GLIKSON@il.ibm.com>, Eran Raichstein <ERANRA@il.ibm.com>,
        Joel Nider <JOELN@il.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Yossi Kuperman1 <YOSSIKU@il.ibm.com>
MIME-Version: 1.0
Subject: RE: [PATCH] vhost: Add polling mode
X-KeepSent: 3F9F58DB:FFDF5B60-C2257D3E:00443320;
 type=4; name=$KeepSent
X-Mailer: IBM Notes Release 9.0.1SHF211 December 19, 2013
From: Razya Ladelsky <RAZYA@il.ibm.com>
Message-ID: <OF3F9F58DB.FFDF5B60-ONC2257D3E.00443320-C2257D3E.004449BE@il.ibm.com>
Date: Sun, 24 Aug 2014 15:26:34 +0300
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5IF1HF3|November 07, 2013) at
 24/08/2014 15:26:34,
	Serialize complete at 24/08/2014 15:26:34
Content-Type: text/plain; charset="US-ASCII"
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082412-4966-0000-0000-0000011C3657
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Laight <David.Laight@ACULAB.COM> wrote on 21/08/2014 05:29:41 PM:

> From: David Laight <David.Laight@ACULAB.COM>
> To: Razya Ladelsky/Haifa/IBM@IBMIL, "Michael S. Tsirkin" 
<mst@redhat.com>
> Cc: "abel.gordon@gmail.com" <abel.gordon@gmail.com>, Alex Glikson/
> Haifa/IBM@IBMIL, Eran Raichstein/Haifa/IBM@IBMIL, Joel Nider/Haifa/
> IBM@IBMIL, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-
> kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
> "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
> "virtualization@lists.linux-foundation.org" 
> <virtualization@lists.linux-foundation.org>, Yossi 
Kuperman1/Haifa/IBM@IBMIL
> Date: 21/08/2014 05:31 PM
> Subject: RE: [PATCH] vhost: Add polling mode
> 
> From: Razya Ladelsky
> > "Michael S. Tsirkin" <mst@redhat.com> wrote on 20/08/2014 01:57:10 PM:
> > 
> > > > Results:
> > > >
> > > > Netperf, 1 vm:
> > > > The polling patch improved throughput by ~33% (1516 MB/sec -> 
> 2046 MB/sec).
> > > > Number of exits/sec decreased 6x.
> > > > The same improvement was shown when I tested with 3 vms running 
netperf
> > > > (4086 MB/sec -> 5545 MB/sec).
> > > >
> > > > filebench, 1 vm:
> > > > ops/sec improved by 13% with the polling patch. Number of exits
> > > > was reduced by 31%.
> > > > The same experiment with 3 vms running filebench showed similar 
numbers.
> > > >
> > > > Signed-off-by: Razya Ladelsky <razya@il.ibm.com>
> > >
> > > This really needs more thourough benchmarking report, including
> > > system data.  One good example for a related patch:
> > > http://lwn.net/Articles/551179/
> > > though for virtualization, we need data about host as well, and if 
you
> > > want to look at streaming benchmarks, you need to test different 
message
> > > sizes and measure packet size.
> > >
> > 
> > Hi Michael,
> > I have already tried running netperf with several message sizes:
> > 64,128,256,512,600,800...
> > But the results are inconsistent even in the baseline/unpatched
> > configuration.
> > For smaller msg sizes, I get consistent numbers. However, at some 
point,
> > when I increase the msg size
> > I get unstable results. For example, for a 512B msg, I get two 
scenarios:
> > vm utilization 100%, vhost utilization 75%, throughput ~6300
> > vm utilization 80%, vhost utilization 13%, throughput ~9400 (line 
rate)
> > 
> > I don't know why vhost is behaving that way for certain message sizes.
> > Do you have any insight to why this is happening?
> 
> Have you tried looking at the actual ethernet packet sizes.
> It may well jump between using small packets (the size of the writes)
> and full sized ones.

I will check it,
Thanks,
Razya

> 
> If you are trying to measure ethernet packet 'cost' you need to use UDP.
> However that probably uses different code paths.
> 
>    David
> 
> 
> 

