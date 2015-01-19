Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbbASLEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:04:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbbASLEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:04:45 -0500
Date: Mon, 19 Jan 2015 12:04:44 +0100
From: Jan Kara <jack@suse.cz>
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: Jan Kara <jack@suse.cz>, lsf-pc@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Lsf-pc] [LSF/MM ATTEND]: Linux SCSI experiences in Google
 Compute Engine & SCSI multiqueue-per-target discussion
Message-ID: <20150119110444.GD5662@quack.suse.cz>
References: <CAHdzE--ypgihzrWadAt81TP=gPSY0SvwYdPsyAywG8g2vs0HAg@mail.gmail.com>
 <20150116095006.GE25884@quack.suse.cz>
 <CAHdzE-8PvKAfBmPx-UPz-7R5_rEJEq7=TKji4o8zXySwFwqQHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHdzE-8PvKAfBmPx-UPz-7R5_rEJEq7=TKji4o8zXySwFwqQHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 16-01-15 09:38:23, Venkatesh Srinivas wrote:
> On Fri, Jan 16, 2015 at 1:50 AM, Jan Kara <jack@suse.cz> wrote:
> >   Hello,
> >
> > On Thu 15-01-15 15:14:01, Venkatesh Srinivas wrote:
> >> I work at Google on the SCSI emulation and virtual storage array
> >> (Persistent Disk) in Google Compute Engine; we emulate a VirtioScsi
> >> PCI adapter and a SCSI storage target for use by (primarily) Linux
> >> virtual machines running on our hardware.
> >>
> >> I'd be interested in attending LSF/MM 2015, to participate in
> >> discussions around scsi-mq in the virtio-scsi driver and the SCSI
> >> midlayer. I'd also like to discuss ultimately driving a single scsi
> >> target from multiple request queues -- we have experimented with this
> >> in Google Compute Engine and it would allow interfacing very high IOPS
> >> storage devices to the SCSI midlayer.
> >>
> >> I'd also like to talk about a couple of pain points we've had running
> >> in our environment -- around "backpressure" (BUSY statuses); around
> >> the SCSI midlayer not having access to per-request REQ_END flags; and
> >> around CFQ and nonrotational media.
> >   Well, CFQ was never meant for non-rotational media AFAIK so why are you
> > using it?
> 
> 1) The Debian project's default scheduler (even for VM guests) is CFQ; Debian
>     stable (+ the backports kernel, 3.16 currently) is GCE's default and most
>     popular image. The default guest configuration should really work well,
>     customer manual tuning is less than ideal.
  Then you should talk to Debian. VM guests shouldn't definitely use CFQ by
default. In most cases that's just a way to waste CPU cycles only to
increase IO latency - i.e. a loose-loose situation :).

> 2) CFQ does have logic to handle nonrotational media (see the test in
>     cfq_shoud_idle()); however the logic also takes into account blockdev queue
>     depth over time, I'd like to talk about why that logic is there.
  Yes, I know it does have logic for non-rotational media. But in most
cases using deadline or noop IO scheduler just ends up yielding better
results for non-rotational media. I specifically talked to block layer guys
(Jeff Moyer, Jens Axboe) about some shortcomings of CFQ we have observed in
SUSE or upstream and their answer was that CFQ is good for rotating drives.
For anything else you should use a different IO scheduler.

> 3) To a first order, our disk emulation has no seek penalties, so any of
> CFQ's heuristics to optimize for seek order are not necessary. However,
> our disk emulation (like many real SSDs!) does benefit from larger I/O
> batches; we have observed bandwidth-constrained workloads generate larger
> request batches per doorbell write/device kick with CFQ is told it has a
> rotational disk. We'd like to not lose this benefit by wholesale
> disabling CFQ.
  If you have some data on this, I think it would be interesting to block
layer guys. And comparison what request sizes you achieve with different
CFQ settings and different IO schedulers is worthwhile. The factor to
consider as well is the additional CPU load though - whether the additional
CPU cost for finding mergeable requests is worth the increase in size of
requests. That's always something to consider and how things work out
depends on the details of the workload.

> 4) (minor) IIUC CFQ provides users with better block stats currently?
  Hum, I'm not aware of that. Which stats? CFQ allows you to use IO
priorities, priority classes, and block cgroups which is the main advantage
of CFQ in this area I'm aware of.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
