Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbaJNNFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:05:32 -0400
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:26592
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755240AbaJNNF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:05:29 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Richard Cochran <richardcochran@gmail.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Thread-Topic: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Thread-Index: AQHP55ZRTp/VO8CmfEuTJogFjyVUzJwve/cAgAAPyNA=
Date: Tue, 14 Oct 2014 13:04:35 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540BFD41@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
 <20141014115412.GC4019@localhost.localdomain>
In-Reply-To: <20141014115412.GC4019@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.173.50.55]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(51704005)(199003)(377454003)(13464003)(24454002)(189002)(164054003)(46406003)(15975445006)(23726002)(95666004)(2656002)(87936001)(55846006)(120916001)(19580405001)(68736004)(69596002)(33656002)(16796002)(19580395003)(31966008)(84676001)(85852003)(44976005)(99396003)(6806004)(50466002)(76176999)(92566001)(92726001)(4396001)(54356999)(97756001)(77096002)(50986999)(106466001)(21056001)(81156004)(107046002)(106116001)(86612001)(1411001)(20776003)(86362001)(76482002)(15202345003)(86146001)(26826002)(66066001)(110136001)(47776003)(85306004)(80022003)(46102003)(97736003)(64706001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1211;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1211;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03648EFF89
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Richard Cochran
> Sent: Tuesday, October 14, 2014 7:54 PM
> To: Thomas Shao
> Cc: tglx@linutronix.de; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; KY Srinivasan
> Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
> time sample
> 
> On Tue, Oct 14, 2014 at 04:11:18AM -0700, Thomas Shao wrote:
> > In current hyper-v time sync service,it only gets the initial clock
> > time from the host. It didn't process the following time samples. This
> > change introduced a module parameter called host_time_sync. If it is
> > set to true, the guest will periodically sychronize it's time with the
> > host clock using host time sample. By default it is disabled, because
> > we still recommend user to configure NTP for time synchronization.
> 
> I really don't see the need for this. We have NTP. If the guests want to, they
> may use it. Otherwise, they have a free running clock, just like real machines.
> 
Sometimes the user can't setup NTP. For example the guest OS didn't have network
connection. And in some cases, they may want the guest time sync with host. 
With the existing hyper-v time source, the system clock will has around 1.5 second
time drift per day. If the workload in the host is heavy, the number could be larger.
So this feature is really useful for some scenarios.

> > +		/*
> > +		* Use the Hyper-V time sample to adjust the guest time. The
> > +		* algorithm is: If the sample offsets exceeds 1 second, we
> > +		* directly set the clock to the server time. If the offset is
> 
> So the guests will experience random time jumps in the kernel, without any
> rhyme or reason?

This behavior is designed for some extreme cases. Like manually setting guest time
to some value. Or the host resumes from a hibernate state. Normally, we should not
run into this.

> 
> > +		* less than 1ms, we ignore the time sample. Otherwise we
> adjust
> > +		* the clock.
> > +		*/
> 
> So when using this kernel module, the sychronization is never expected to
> be better than one millisecond. That is not too good. I expect NTP can do
> better. So what was the point of this change again?

The time sync component will try to slew the time if the time drift is larger than 
1ms. It doesn't mean the time drift will always be larger than 1ms. This component 
module is trying to keep the time sync with host. And NTP is to keep the time sync 
with external time source from Internet. And yes, NTP has more complicated algorithm,
and it can do better.

> 
> Thanks,
> Richard
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
