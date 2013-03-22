Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422808Ab3CVSDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 14:03:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40020 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422633Ab3CVSDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:03:20 -0400
Date: Fri, 22 Mar 2013 18:03:05 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv3 01/10] clocksource: add generic dummy timer driver
Message-ID: <20130322180305.GB1436@e106331-lin.cambridge.arm.com>
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org>
 <1363198676-30417-2-git-send-email-sboyd@codeaurora.org>
 <20130321180922.GB10716@e106331-lin.cambridge.arm.com>
 <514B4DBD.4060403@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514B4DBD.4060403@codeaurora.org>
Thread-Topic: [PATCHv3 01/10] clocksource: add generic dummy timer driver
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 06:13:17PM +0000, Stephen Boyd wrote:
> On 03/21/13 11:09, Mark Rutland wrote:
> > Hi Stephen,
> >
> > I've just been trying to test the dummy timer, and realised it's broken, as it
> > registers a cpu notifier from a device_initcall (after SMP's been brought up),
> > and doesn't ensure all active CPUs have been set up. Evidently no-one else has
> > attempted to test it thus far, and I'm not able to throughly test it at the
> > moment.
> 
> Would it be sufficient to register as a pre-smp initcall?

I've looked a bit further into the problem, and I believe using early_initcall
will make it work as well as the current arm-specific dummy timers work with a
rating of 100 (this means the recent patch lowering the rating broke tc2 as
explained below).

I've spent the last few hours trying to get the dummy_timer driver working on
tc2 with the sp804 as the broadcast source (with architected timer support
disabled). It turns out that having dummy timer's rating so low means that it
won't be selected as the tick device on cpu0 in preference to the sp804, and
thus won't push the sp804 out of that spot (allowing it to become the broadcast
source). This leads to boot stalling.

Jumping the dummy_timer's rating up would fix this, but that doesn't seem
great. Registering the dummy before all other clocks would also fix this (I
tried calling dummy_timer_register from time_init), but I can't see a way to do
that while keeping the driver self-contained.

Thanks,
Mark.
