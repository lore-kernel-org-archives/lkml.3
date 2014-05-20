Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaETK0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:26:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbaETK0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:26:30 -0400
Date: Tue, 20 May 2014 12:26:25 +0200
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 0/3] timekeeping: Improved NOHZ frequency steering (v2)
Message-ID: <20140520102625.GI4060@localhost>
References: <1400288204-414-1-git-send-email-john.stultz@linaro.org>
 <20140519101439.GE4060@localhost>
 <CALAqxLUyCGJeYDwzXKN0zCBdmYuapo1iYJX4nvR7Sru+ySkesQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLUyCGJeYDwzXKN0zCBdmYuapo1iYJX4nvR7Sru+ySkesQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 10:57:29AM -0700, John Stultz wrote:
> On Mon, May 19, 2014 at 3:14 AM, Miroslav Lichvar <mlichvar@redhat.com> wrote:
> > Ok, so it seems to be almost identical to my patch now. The only two
> > differences seem to be the removal of the ntp_error correction to
> > change the effective clock frequency at the current time instead of
> > aligning it to the start of the tick and the flag to handle the xtime
> > underflow.

> So as for the ntp_error correction when we adjust the multiplier, I
> believe that is still needed, since when we adjust the freq we move
> the xtime_nsec value, which means we need to adjust the error from
> that xtime_nsec value to the ideal value at that point.  But if you
> can provide a better rational as to why it can be safely dropped, I'd
> be happy to listen.

Ok, I tried to make a drawing to explain it better
http://mlichvar.fedorapeople.org/tmp/mult_update.png

My understanding of the current code is this. The update of mult value
doesn't happen exactly on tick boundary, so xtime needs to be
corrected to not break the continuity of the observed time (i.e. time
with old mult/xtime is equal to the time with new mult/xtime at the
time of the update), that's the start of the blue line in the drawing.
To make it appear as if the frequency was adjusted on tick boundary
(green line), the xtime correction is added to ntp_error and the time
is slowly corrected in the following updates (red line). 

I think that ntp_error correction is not necessary and we can stick
to the blue line. The frequency of the clock was changed at the
current time instead of the start of the current tick.

> So one part of my concern is I'm not as comfortable bending over
> backwards all the time to avoid ntp_error. Sure, if we can avoid it in
> the common case, that makes things better, but having occasional
> bursts for good reason (like the underflow issue) I think is important
> so we can ensure that the logic to converge does actually function
> with larger errors.

It will converge but very slowly, I'm not sure if that's acceptable
even if it happens rarely. If it was able to correct larger errors
quickly, we would have the other problems we were trying to fix back
again.

> If we constrain all the cases where error can be
> added, I worry it will make the correction logic fragile in the end.
> But I'm not totally settled on this.

The correction logic is simple and robust, but slow. It can be used
only if all these sources of the error are removed.

> Another area we have to be careful with is there are still
> architectures (powerpc and ia64) which haven't switched from the old
> vsyscall rounding logic (CONFIG_GENERIC_TIME_VSYSCALL_OLD). In these
> cases we add up to 1ns of error each tick/update as we round up the
> sub-nanoseconds to ensure we don't see inconsistencies.  If the
> adjustment logic can't handle this, I don't want to regress those
> arches.

Yes, this would probably need to be fixed too. If converting the
remaining vsyscalls is difficult, maybe a short-term fix could be
adding a new register for the rounding error and use it to select
which direction should be xtime rounded instead of always rounding up?

Thanks,

--
Miroslav Lichvar
