Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929AbaJ2Phs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:37:48 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:37468 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933664AbaJ2Phr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:37:47 -0400
Date: Wed, 29 Oct 2014 08:36:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Johan Hovold <johan@kernel.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Message-ID: <20141029153641.GB20565@roeck-us.net>
References: <20141024195532.GF19377@localhost>
 <20141027162251.d7ff2a5f31917c638d4e47f7@linux-foundation.org>
 <20141028002552.GX12379@n2100.arm.linux.org.uk>
 <20141028081616.GL2006@localhost>
 <20141028084745.GY12379@n2100.arm.linux.org.uk>
 <20141028131257.GS2006@localhost>
 <20141028151610.GA12379@n2100.arm.linux.org.uk>
 <20141029123418.GB2265@localhost>
 <5450E9A8.1060506@roeck-us.net>
 <20141029133526.GE2265@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029133526.GE2265@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.545109CA.01FD,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 16
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 02:35:26PM +0100, Johan Hovold wrote:
> On Wed, Oct 29, 2014 at 06:20:40AM -0700, Guenter Roeck wrote:
> > On 10/29/2014 05:34 AM, Johan Hovold wrote:
> > > On Tue, Oct 28, 2014 at 03:16:10PM +0000, Russell King - ARM Linux wrote:
> > >> On Tue, Oct 28, 2014 at 02:12:57PM +0100, Johan Hovold wrote:
> > >>> That's not what I was trying to refer to. But the patch set explicitly
> > >>> allows for multiple, prioritised power-off handlers, which can power
> > >>> off a board in different ways and with various degrees of success.
> > >>> Specifically, it allows for fallback handlers in case one or more
> > >>> power-off handlers fail.
> > >>>
> > >>> So if we allow for that, what is to prevent the final power-off handler
> > >>> from failing? And should this not be logged by arch code in the same way
> > >>> as failure to restart is?
> > >>
> > >> And how is that different from having a set of power-off handlers, and
> > >> reporting when each individual one fails?  Don't you want to know if
> > >> your primary high priority reboot handler fails, just as much as you
> > >> want to know if your final last-resort power-off handler fails?
> > >
> > > Good point. Failed power-off should probably be logged by the power-off
> > > call chain implementation (which seems to makes notifier chains a bad
> > > fit).
> >
> > Good that I just replaced notifier chain with an open coded implementation.
> 
> Good to hear.
> 
> > Sure, that is possible, but I would prefer to do that as a follow-up commit,
> > and it should be discussed in the context of the power-off handler patch set.
> 
> Fine with me.
> 
> > > And what about any power-off latencies? Should this always be dealt with
> > > in the power-off handler?
> > >
> > > Again, if it's predictable and high, as in the OMAP RTC case, it should
> > > go in the handler. But what if it's just normal bus latencies
> > > (peripheral busses, i2c, or whatever people may come up with)?
> > >
> > > Should there always be a short delay before calling the next handler?
> > 
> > That delay would depend on the individual power-off handler, so I think
> > the current implementation works just fine (where power-off handlers
> > implement the delay).
> 
> Some don't, and could possibly unknowingly have been relying on the fact
> that they could return to user space and be powered off at some later
> time. With systemd that would have caused a panic.
> 
Agreed, but there are two cases to consider: What should be the delay
before the next power-off handler is called, and what should the system
do if all power-off handlers fail (or if there are none). The current
behavior isn't exactly well defined. Ok, with systemd that results in
a crash, but I am not really sure if one can or should blame systemd
for that. The discussion about systemd and its philosophy should not
cloud the fact that power-off behavior isn't exactly well defined.

> Also consider generic power-off handlers such as gpio-poweroff. It
> currently hard-codes a three-second delay but the actual delay would
> really be board specific.
> 
A configurable delay would address that. The actually required delay
could be provided in platform data or as devicetree property.

Thanks,
Guenter
