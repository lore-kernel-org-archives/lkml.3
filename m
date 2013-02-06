Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab3BFXP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 18:15:27 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:55891 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755163Ab3BFXPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 18:15:24 -0500
Message-ID: <1360192513.4909.21.camel@thor.lan>
Subject: Re: [PATCH 3/4] pps: Use lookup list to reduce ldisc coupling
From: Peter Hurley <peter@hurleysoftware.com>
To: George Spelvin <linux@horizon.com>
Cc: giometti@enneenne.com, gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Wed, 06 Feb 2013 18:15:13 -0500
In-Reply-To: <20130206221905.15297.qmail@science.horizon.com>
References: <20130206221905.15297.qmail@science.horizon.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-06 at 17:19 -0500, George Spelvin wrote:
> > I did this first and it's a mess -- the patch basically ends up looking
> > like a rewrite. But feel free to use these patches as a base for a
> > version you do like and submit those instead for review. I just wanted
> > to show the way.
> 
> I wouldn't think so, but I'll give it a try and see myself.  Thanks!
> 
> > (Well, actually that was the second version. When I reviewed the
> > uart_handle_dcd_change() and saw the separate timestamp, I thought that
> > maybe the latency was going to be a problem. So the first version used
> > the same approach but with an rcu 'lockless' list instead -- then I went
> > back and audited the IRQ path and realized there were 5 bus locks and an
> > i/o port read already. So total overkill.)
> 
> Er... but you went and captured the timestamp *before* doing the list
> lookup.  It was only moved one jsr later.

This was before I moved the dcd_change() call. In the original commit,
the timestamp was acquired in uart_handle_dcd_change() and
only after wake_up/hangup handling did it call the ldisc dcd_change().

So obviously that was misleading.

Also, I wasn't really sure how contended a lock might be. It wasn't
until I'd spent some time with the code to realize that answer was "not
contended".

> Really, what I'd *like* to do is to unconditionally capture a *raw*
> timestamp (rdtsc or equivalent) very early in the interrupt handling,
> for use by random seeding, pps, network timestamps, and so on.  But the
> conversion to a "struct timespec" would be deferred until when and if
> it was actually needed.
> 
> This is complicated because the conversion has to happen "soon" after
> the capture, soon enough that the low-level clock that was read has not
> wrapped and become ambiguous.
> 
> But that's a lot more complicated.

I understand that's a long-term plan. You should approach the RT crowd
about this. I think some might be interested in timestamping interrupts
(at least on certain platforms) for test measurement.

> >> A more ambitious cleanup would use the existing pps_device list
> >> (maintained to allocate minor device numbers) and add an "owner" field
> >> that can be looked up on, without creating a new data structure and
> >> allocation.
> 
> > Didn't see where that was (unless you mean the IDR allocation).
> 
> Exactly the IDR.  You can just do idr_for_each() until you find
> the right one.
> 
> > Probably best to keep it separate in the event that relative lifetimes
> > change at some point in the future.
> 
> I don't see how that could plausibly happen.  Currently, a device
> is registered in the IDR immediately after allocation, and is freed
> immediately before deallocation.  There is no time that it's permitted to
> call any kernel PPS API function with a pps_device * that *not* in
> the IDR.
> 
> Information with a longer life is segregated in the struct
> pps_source_info.  (Which is where I was thinging of adding the
> parent_dev field.)

Ok, so at least someone is thinking about that.

> > Please let us know if you plan to respin the patches, so these patches
> > don't get pushed.
> 
> I do, in the next few hours.  Can you give mt until 0600 UTC,
> or should I try for faster?

What release are you trying to hit? Regardless, nothing's happening
within hours -- days maybe.

