Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab3BFAY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 19:24:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab3BFAY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 19:24:56 -0500
Date: Tue, 5 Feb 2013 19:24:10 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: NeilBrown <neilb@suse.de>
cc: device-mapper development <dm-devel@redhat.com>,
        Guangliang Zhao <gzhao@suse.com>, linux-kernel@vger.kernel.org,
        agk@redhat.com
Subject: Re: [dm-devel] [PATCH 0/3 v3] add resync speed control for dm-raid1
In-Reply-To: <20130123152044.3726fb4e@notabene.brown>
Message-ID: <Pine.LNX.4.64.1302051911590.30143@file.rdu.redhat.com>
References: <1357552933-26126-1-git-send-email-gzhao@suse.com>
 <Pine.LNX.4.64.1301090034200.29917@file.rdu.redhat.com>
 <20130116082109.GA2154@glzhao-laptop.site> <Pine.LNX.4.64.1301222033290.4723@file.rdu.redhat.com>
 <20130123152044.3726fb4e@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Jan 2013, NeilBrown wrote:

> On Tue, 22 Jan 2013 20:44:41 -0500 (EST) Mikulas Patocka
> <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Wed, 16 Jan 2013, Guangliang Zhao wrote:
> > 
> > > On Wed, Jan 09, 2013 at 12:43:21AM -0500, Mikulas Patocka wrote:
> > > > Hi
> > > Hi,
> > > 
> > > I think it is very good that your patches could be used for other
> > > targets(snapshot, thin) after reviewing yours, but I find some issues
> > > (maybe not, please correct me if I am wrong).
> > > 
> > > > 
> > > > I did this already some times ago.
> > > > I'm sending my patches in the next mail.
> > > > 
> > > > Basically, my and Guangliang's patches have the following differences:
> > > > 
> > > > my patch: uses per-module throttle settings
> > > > Guangliang's patch: uses per-device settings
> > > > (my patch could be changed to use per-device throttle too, but without 
> > > > userspace support it isn't much useful because userspace lvm can 
> > > > reload the mirror and per-device settings would be lost)
> > > 
> > > We couldn't force every devices in the system hold the same throttle,
> > > IMHO, per-device settings couldn't be ignored. 
> > > Setting the global value by the parameters of module is a good way, and
> > > it could also be used to set the default value in my patches. In this way,
> > > the global setting wouldn't be lost, and we could also adjust every device's
> > > speed.
> > 
> > It could be good to have per-device throttle.
> > 
> > > > my patch: uses fine grained throttling of the individual IOs in kcopyd - 
> > > > it measures active/inactive ratio and if the disk is active more than the 
> > > > specified percentage of time, sleep is inserted.
> > > 
> > > I think this policy might not be able to represent the exact write speed, 
> > > while other modules(such as md, drbd) monitor the real IO speed.
> > 
> > But you don't want to limit raid resynchronization to a certain speed. A 
> > disk has varying speed, it is faster in the beginning and slower in the 
> > end.
> > 
> > So if you want to limit raid resynchronization so that other tasks have 
> > faster access to the disk, you need to limit percentage of time that is 
> > spent on resynchronization, not resynchronization speed.
> 
> Sounds good ..... not that easy though.
> 
> But if the disk is otherwise idle, I want 100% of the time to be spend on
> synchronisation.  If it isn't otherwise idle, I want a much more modest
> faction to be used.

So, hack the i/o scheduler - the scheduler can make such decisions, it is 
impossible to do this decision in the dm-mirror layer, because the 
dm-mirror layer has no knowledge of how much is the disk loaded.

It is clearly better solution to solve it in the scheduler, this throttle 
is a simple solution for the case when the i/o scheduler isn't right.

> Getting this "right" is very hard.  You want to resync aggressively if there
> is no other traffic, but to back off quickly to some small background rate if
> there is any other traffic.  That is what md tries to do.
> 
> dm-raid1 has an extra complication.  It is used in clusters (clvm) where
> multiple separate hosts might be accessing the device.  So the host which is
> driving the resync cannot know what other IO there might be.

The same problem arises on a single computer - there may be multiple 
logical volumes or multiple partitions on the same disk.

> In that case the only thing that seems to be practical is an maximum sync
> speed that can be set by the admin.

Maximum speed sync doesn't work well because the disk has a different 
speed in the beginning and in the end. For example, if you set maximum 
speed as 50% of the resync speed when you start resynchronizing, the 
throttle stops working at the end of the disk, because the disk itself is 
50% slower at the end.

A better solution is to limit the time spent doing i/o. If you set it to 
50%, it is 50% loaded and 50% idle for the whole duration of the 
resynchronization, regardless of different transfer speed in each disk 
region.

> NeilBrown

Mikulas
