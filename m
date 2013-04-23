Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3DWAxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 20:53:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:45533 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab3DWAxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 20:53:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,530,1363158000"; 
   d="scan'208";a="290081670"
From: "Pan, Zhenjie" <zhenjie.pan@intel.com>
To: Don Zickus <dzickus@redhat.com>
CC: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] NMI: fix NMI period is not correct when cpu
 frequency changes issue.
Thread-Topic: [PATCH v2] NMI: fix NMI period is not correct when cpu
 frequency changes issue.
Thread-Index: Ac46b5lX48efHbUtRT2d/NJzqZ6DWQBdzKSAAAC9ZQAAA1VkgAC+rv5AABWovoAAHFibUA==
Date: Tue, 23 Apr 2013 00:52:37 +0000
Message-ID: <F98D4B5C3D86834DB612ABF854C98B7FB612CB@SHSMSX101.ccr.corp.intel.com>
References: <F98D4B5C3D86834DB612ABF854C98B7FB5D7FE@SHSMSX101.ccr.corp.intel.com>
 <1366285369.19383.19.camel@laptop>
 <CABPqkBTpzSBEezx4ScwYYX6L8ir4GLBG9MMYJuAb6YA0QbiurQ@mail.gmail.com>
 <20130418133927.GJ79013@redhat.com>
 <F98D4B5C3D86834DB612ABF854C98B7FB5FACF@SHSMSX101.ccr.corp.intel.com>
 <20130422185929.GZ79013@redhat.com>
In-Reply-To: <20130422185929.GZ79013@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Don Zickus [mailto:dzickus@redhat.com]
> Sent: Tuesday, April 23, 2013 2:59 AM
> To: Pan, Zhenjie
> Cc: Stephane Eranian; Peter Zijlstra; paulus@samba.org; mingo@redhat.com;
> acme@ghostprotocols.net; akpm@linux-foundation.org; tglx@linutronix.de;
> Liu, Chuansheng; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] NMI: fix NMI period is not correct when cpu
> frequency changes issue.
> 
> On Mon, Apr 22, 2013 at 12:50:34AM +0000, Pan, Zhenjie wrote:
> > > I believe it mattered to the Chrome folks. They want the watchdog to
> > > be as tight as possible so the user experience isn't a hang but a
> > > quick reboot instead.  They like setting the watchdog to something like 2
> seconds.
> > >
> > > There was a patch a few months ago that tried to hack around this
> > > issue and I suggested this approach as a better solution.  I forgot
> > > what the original problem was.  Perhaps someone can jump in and
> > > explain the problem being solved (other than the watchdog isn't always
> 10 seconds)?
> > >
> > > Cheers,
> > > Don
> >
> > Yes, I also think the period is important sometimes.
> > As I mentioned before, the case I meet is:
> > When the system hang with interrupt disabled, we use NMI to detect.
> > Then it will find hard lockup and cause a panic.
> > Panic is very important for debug these kind of issues.
> >
> > But if cpu frequency change, the period will be 2 times, 3 times even
> > more.(if cpu can down from 2.0GHz to 200MHz, will be 10 times, it's a very
> big deviation) This make watchdog reset happen before hard lockup detect.
> 
> So you are saying with the longer hard lockup delay, the iTCO_wdt is firing
> before the hard lockup detector?
> 
> Cheers,
> Don

Give you a detail example:
0s                                                                                               50s                        60s                      70s
|_____________________________________|___________|__________|
When 50s, a watchdog interrupt happen to inform watchdog daemon to update watchdog.
If watchdog daemon does not update watchdog in 10s, another watchdog interrupt will happen at 60s to cause a panic.
Then system will have 10s to do some dump.
At 70s, watchdog hardware reset happen.

But if interrupt is disabled at 60s, panic will be lost.
So we need NMI interrupt by performance monitor to detect hard lockup.
If the NMI period is 10s, it can guarantee that hard lockup will be detected before 70s.
But if the period is changed with cpu frequency, this will be not ensure.

Hope my explanation is clear.

BTW, I use intel_scu_watchdog(but looks have big difference with that in upstream), not iTCO_wdt.

Thanks
Pan Zhenjie
