Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab3JRRmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:42:13 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56296 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756517Ab3JRRmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:42:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lan Tianyu <lantianyu1986@gmail.com>, Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH] ACPI/Power: Check physical device's runtime pm status before requesting to resume it
Date: Fri, 18 Oct 2013 19:54:02 +0200
Message-ID: <3170486.zy96d8TsUF@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52613209.3000104@intel.com>
References: <1381479385-1614-1-git-send-email-tianyu.lan@intel.com> <4249062.PmvqKh0Nrz@vostro.rjw.lan> <52613209.3000104@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 18, 2013 09:05:13 PM Lan Tianyu wrote:
> On 10/17/2013 07:38 PM, Rafael J. Wysocki wrote:
> >>>>>>> Unfortunately, I don't see how we can fix this race in a
> >>>>>>> satisfactory way and I'm starting to think that the whole
> >>>>>>> resuming of dependent devices may be a bad idea.
> >>>>>>>
> >>>>>>> IIRC, the original concern was that devices may end up in
> >>>>>>> D0-uninitialized if we don't do that, but then whoever
> >>>>>>> turned the power resource on will probably turn if off at
> >>>>>>> one point anyway, so they will be in that state
> >>>>>>> temporarily.  In other words, in addition to the fact
> >>>>>>> that this is racy, there even is no reason to do it.
> >>>>>>>
> >>>>>>> I'll send a patch to rip off that stuff later today.
> >>>
> >>> Currently, dropping it should be the better choice but I think we
> >>> still need to resolve the D0-uninitialized problem, right?
> > Why do you think it is a problem in the first place?  Those devices
> > will not be accessed while in that state (unless there's a bug
> > somewhere).
> >
> 
> Yes, those devices will not be accessed but they will continue to stay
> D0-uninitiallized without any users before next resume and suspend. PM
> core and device driver still think they are in the lower power state.
> 
> At this point, it seems these devices should be put into lower power
> state(E.G D3hot) than D0-uninitiallized.
> 
> E.G, two devices share one power resource. After they are suspended and
> power resource turns off, one device is resumed and power resource turns
> on. The other device will remain D0-uninitallized until there are resume
> and suspend for it.

That's not correct.  If the device that has been resumed is now suspended
again, that will cause the power resource to go off again and the other
device will not stay in D0-uninitialized.

> It may consume more power than lowest power state it can reach at that point.

I don't see a compelling case for that.  The only situation of interest is
if A and B share a power resource, they both are suspended to start with, so
the power resource is off, and then A is resumed and not suspended again for
a relatively long time.  In that case B *may* be in D0-uninitialized although
it could go into D3hot if it were resumed and suspended.  Now there's a
question of timing, because the resume and suspend of B is only beneficial
if it would stay in D0-uninitialized long enough and we can't say in advance
when A is going to be suspended again.  Moreover, we don't really know what
state B is in, because "power restored" need not automatically mean "clock
enabled" etc. for various kinds of devices.

I think the whole problem is highly theoretical and really only affects PCI
where "power restored" pretty much means "reset".  And I am yet to see a system
where it actually matters.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
