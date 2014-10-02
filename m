Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaJBUGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 16:06:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbaJBUGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 16:06:17 -0400
Date: Thu, 2 Oct 2014 22:06:12 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Tom Gundersen <teg@jklm.no>, systemd-devel@lists.freedesktop.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Michal Hocko <mhocko@suse.cz>, Greg KH <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Tejun Heo <tj@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Robert Milasan <rmilasan@suse.com>, werner@suse.com,
        Oleg Nesterov <oleg@redhat.com>, hare <hare@suse.com>,
        Benjamin Poirier <bpoirier@suse.de>,
        Santosh Rastapur <santosh@chelsio.com>, pmladek@suse.cz,
        dbueso@suse.com, LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kay Sievers <kay@vrfy.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Casey Leedom <leedom@chelsio.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        "mpt-fusionlinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 5/5] driver-core: add driver asynchronous probe
	support
Message-ID: <20141002200612.GQ14081@wotan.suse.de>
References: <1411768637-6809-1-git-send-email-mcgrof@do-not-panic.com> <1411768637-6809-6-git-send-email-mcgrof@do-not-panic.com> <CAG-2HqWmVODJ6Q46t96mS9ALbeFjRcQ18ypwejY=ug0wCUVv-Q@mail.gmail.com> <20140930022751.GA14081@wotan.suse.de> <CAG-2HqUdFWBPUrHg2yezVVu7xedqTQDBxAW5nuYWKWJCTkZSBg@mail.gmail.com> <20140930152419.GF14081@wotan.suse.de> <CAG-2HqVBnXUKSRBrJE=gEKA3St5KMfdgAbx2vRfpF3qw_teLOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG-2HqVBnXUKSRBrJE=gEKA3St5KMfdgAbx2vRfpF3qw_teLOg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per Tom, adding systemd-devel for advice / review / of the request to avoid
the sigkill for kmod workers. Keeping others on Cc as its a discussion that
I think can help if both camps are involved. Specially since we've been
ping ponging back and forth on this particular topic for a long time now.

On Thu, Oct 02, 2014 at 08:12:37AM +0200, Tom Gundersen wrote:
> On Tue, Sep 30, 2014 at 5:24 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> >> > commit e64fae5573e566ce4fd9b23c68ac8f3096603314
> >> > Author: Kay Sievers <kay.sievers@vrfy.org>
> >> > Date:   Wed Jan 18 05:06:18 2012 +0100
> >> >
> >> >     udevd: kill hanging event processes after 30 seconds
> >> >
> >> >     Some broken kernel drivers load firmware synchronously in the module init
> >> >     path and block modprobe until the firmware request is fulfilled.
> >> >     <...>
> >>
> >> This was a workaround to avoid a deadlock between udev and the kernel.
> >> The 180 s timeout was already in place before this change, and was not
> >> motivated by firmware loading. Also note that this patch was not about
> >> "tracking device drivers", just about avoiding dead-lock.
> >
> > Thanks, can you elaborate on how a deadlock can occur if the kmod
> > worker is not at some point sigkilled?
> 
> This was only relevant whet udev did the firmware loading. modprobe
> would wait for the kernel, which would wait for the firmware loading,
> which would wait for modprobe. This is no longer a problem as udev
> does not do firmware loading any more.

Thanks for clarifying. So the deadlock concern is no longer there, therefore
it is not a reason to keep the sigkill for kmod.

> > Is the issue that if there is no extra worker available and all are
> > idling on sleep / synchronous long work boot will potentially hang
> > unless a new worker becomes available to do more work?
> 
> Correct.

Ok.

> > If so I can
> > see the sigkill helping for hanging tasks but it doesn't necessarily
> > mean its a good idea to kill modules loading taking a while. Also
> > what if the sigkill is just avoided for *just* kmod workers?
> 
> Depending on the number of devices you have, I suppose we could still
> exhaust the workers.

Ok can systemd dynamically create a worker or set of workers per device
that creeps up? Async probe for most drivers will help with this but
having it dynamic should help as well, specially since there are drivers
that will require probe synchronously -- and the fact that async probe
mechanism is not yet merged.

> >> The way I see it, the current status from systemd's side is: our
> >> short-term work-around is to increase the timeout, and at the moment
> >> it appears no long-term solution is needed (i.e., it seems like the
> >> right thing to do is to make sure insmod can be near instantaneous, it
> >> appears people are working towards this goal, and so far no examples
> >> have cropped up showing that it is fundamentally impossible (once/if
> >> they do, we should of course revisit the problem)).
> >
> > That again would be reactive behaviour, what would prevent avoiding the
> > sigkill only for kmod workers? Is it known the deadlock is immiment?
> > If the amount of workers for kmod that would hit the timeout is
> > considered low I don't see how that's possible and why not just lift
> > the sigkill.
> 
> Making kmod a special case is of course possible. However, as long as
> there is no fundamental reason why kmod should get this special
> treatment, this just looks like a work-around to me. 

I've mentioned a series of five reasons why its a bad idea right now to
sigkill modules [0], we're reviewed them each and still at least
items 2-4 remain particularly valid fundamental reasons to avoid it
specially if the deadlock is no longer possible. Running out of
workers because they are loading modules and that is taking a while
is not really a good standing reason to be killing them, specially
if the timeout already is set to a high value. All we're doing there is
limiting Linux / number of devices arbitrarily just to help free
workers, and it seems that should be dealt with differently. Killing
module loading arbitrarily in the middle is not advisable and can cause
more issue than help in any way.

Async probe mechanism will help free workers faster but this patch series is
still being evolved, we should still address the sigkill for kmod workers
separately and see what remaining reasons we have for it in light of the
possible issues highlighted that it can introduce if kept. If we want to
capture drivers taking long on probe each subsystem should handle that and WARN
/ pick up on it, we cannot however assume that this a generally bad things as
discussed before. We will also not be able to async probe *every* driver,
which is why the series allows a flag to specify for this.

[0] https://lkml.org/lkml/2014/9/26/879

> We already have a
> work-around, which is to increase the global timeout. If you still
> think we should do something different in systemd, it is probably best
> to take the discussion to systemd-devel to make sure all the relevant
> people are involved.

Sure, I've included systemd-devel. Hope is we can have a constructive
discussion on the sigkill for kmod.

  Luis
