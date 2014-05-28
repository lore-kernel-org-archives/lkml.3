Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaE1HiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:38:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:27153 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbaE1HiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:38:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,926,1392192000"; 
   d="scan'208";a="538783306"
Date: Wed, 28 May 2014 10:37:51 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140528073751.GB1757@lahna.fi.intel.com>
References: <20140526142948.GA1685@lahna.fi.intel.com>
 <20140526152703.GN18016@ZenIV.linux.org.uk>
 <CA+55aFyz1oQQ+uz9DPSEmYBBby1VKTRFz81mTt3mVSLN+tMK+A@mail.gmail.com>
 <20140526182644.GP18016@ZenIV.linux.org.uk>
 <CA+55aFxq-=xyNOLKQhS5kwy5FKZ=Jp2XSRnyZLU9e8neBLk_2A@mail.gmail.com>
 <20140527014054.GR18016@ZenIV.linux.org.uk>
 <20140527031415.GS18016@ZenIV.linux.org.uk>
 <20140527040026.GT18016@ZenIV.linux.org.uk>
 <20140527070409.GA1801@lahna.fi.intel.com>
 <20140528031955.GW18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528031955.GW18016@ZenIV.linux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 04:19:55AM +0100, Al Viro wrote:
> On Tue, May 27, 2014 at 10:04:09AM +0300, Mika Westerberg wrote:
> > On Tue, May 27, 2014 at 05:00:26AM +0100, Al Viro wrote:
> > > On Tue, May 27, 2014 at 04:14:15AM +0100, Al Viro wrote:
> > > 
> > > > As the matter of fact, let's try this instead - retry the same sucker
> > > > immediately in case if trylocks fail.  Comments?
> > > 
> > > Better yet, let's take "move back to shrink list" into dentry_kill()
> > > itself.  Then we get consistent locking rules for dentry_kill() and
> > > instead of unlock_on_failure we simply pass it NULL or the shrink
> > > list to put the sucker back.  Mika, could you test this one and see
> > > if it fixes that livelock?  The difference in behaviour is that in
> > > case of trylock failure we hit that sucker again without letting
> > > it ride all the way around the list, same as we do for other dentry_kill()
> > > callers.
> > 
> > I tried this patch and unfortunately it still results the same sort of
> > livelock. I've attached the dmesg.
> > 
> > I also tried the serialization patch from Linus and it seemed to fix the
> > problem. After several rounds of USB memory stick plug/unplug I haven't
> > seen a single "soft lockup" warning in dmesg.
> > 
> > I'm able to reproduce the problem pretty easily, so if you have
> > something else to try I'm more than happy to give it a try.
> 
> Could you try this and post the resulting log?  I'd really like to understand
> what's going on there - are we really hitting trylock failures there and what
> dentries are involved.

I sent you the whole log privately so that I don't spam everyone.

Summary is here:

May 28 10:24:23 lahna kernel: scsi 14:0:0:0: Direct-Access     JetFlash Transcend 4GB    8.07 PQ: 0 ANSI: 4
May 28 10:24:23 lahna kernel: sd 14:0:0:0: Attached scsi generic sg4 type 0
May 28 10:24:23 lahna kernel: sd 14:0:0:0: [sdc] 7864320 512-byte logical blocks: (4.02 GB/3.75 GiB)
May 28 10:24:23 lahna kernel: sd 14:0:0:0: [sdc] Write Protect is off
May 28 10:24:23 lahna kernel: sd 14:0:0:0: [sdc] Mode Sense: 23 00 00 00
May 28 10:24:23 lahna kernel: sd 14:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
May 28 10:24:23 lahna kernel:  sdc: sdc1
May 28 10:24:23 lahna kernel: sd 14:0:0:0: [sdc] Attached SCSI removable disk

Here I detached the USB stick:

May 28 10:24:32 lahna kernel: usb 3-10.4: USB disconnect, device number 6
May 28 10:24:32 lahna kernel: check_submounts_and_drop[/dev/block/8:33]; CPU 4 PID 576 [systemd-udevd]
May 28 10:24:32 lahna kernel: dput[/dev/block/8:33]; CPU 4 PID 576 [systemd-udevd]
May 28 10:24:32 lahna kernel: check_submounts_and_drop[3-10/3-10.4/3-10.4:1.0/host14]; CPU 1 PID 1683 [systemd-udevd]
May 28 10:24:32 lahna kernel: shrink[3-10.4:1.0/host14/target14:0:0/subsystem]; CPU 1 PID 1683 [systemd-udevd]
May 28 10:24:32 lahna kernel: shrink[host14/target14:0:0/14:0:0:0/rev]; CPU 1 PID 1683 [systemd-udevd]
May 28 10:24:32 lahna kernel: shrink[host14/target14:0:0/14:0:0:0/vendor]; CPU 1 PID 1683 [systemd-udevd]
May 28 10:24:32 lahna kernel: shrink[host14/target14:0:0/14:0:0:0/model]; CPU 1 PID 1683 [systemd-udevd]
May 28 10:24:32 lahna kernel: check_submounts_and_drop[/dev/block/8:32]; CPU 4 PID 576 [systemd-udevd]
...
May 28 10:24:32 lahna kernel: check_submounts_and_drop[0000:00:14.0/usb3/3-10/3-10.4]; CPU 6 PID 1684 [systemd-udevd]
May 28 10:24:32 lahna kernel: check_submounts_and_drop[0000:00:14.0/usb3/3-10/3-10.4]; CPU 7 PID 1685 [systemd-udevd]
May 28 10:24:32 lahna kernel: shrink[usb3/3-10/3-10.4/ltm_capable]; CPU 7 PID 1685 [systemd-udevd]
May 28 10:24:32 lahna kernel: A
May 28 10:24:32 lahna kernel: shrink[usb3/3-10/3-10.4/ltm_capable]; CPU 7 PID 1685 [systemd-udevd]
May 28 10:24:32 lahna kernel: A
May 28 10:24:32 lahna kernel: shrink[usb3/3-10/3-10.4/ltm_capable]; CPU 7 PID 1685 [systemd-udevd]
May 28 10:24:32 lahna kernel: A
May 28 10:24:32 lahna kernel: shrink[usb3/3-10/3-10.4/ltm_capable]; CPU 7 PID 1685 [systemd-udevd]
May 28 10:24:32 lahna kernel: A
May 28 10:24:32 lahna kernel: shrink[usb3/3-10/3-10.4/ltm_capable]; CPU 7 PID 1685 [systemd-udevd]
May 28 10:24:32 lahna kernel: A
May 28 10:24:32 lahna kernel: shrink[usb3/3-10/3-10.4/ltm_capable]; CPU 7 PID 1685 [systemd-udevd]
May 28 10:24:32 lahna kernel: A
May 28 10:24:32 lahna kernel: shrink[usb3/3-10/3-10.4/ltm_capable]; CPU 7 PID 1685 [systemd-udevd]
May 28 10:24:32 lahna kernel: A
May 28 10:24:32 lahna kernel: shrink[usb3/3-10/3-10.4/ltm_capable]; CPU 7 PID 1685 [systemd-udevd]
May 28 10:24:32 lahna kernel: A
May 28 10:24:32 lahna kernel: shrink[usb3/3-10/3-10.4/ltm_capable]; CPU 7 PID 1685 [systemd-udevd]
May 28 10:24:32 lahna kernel: A

This goes on an on with a variable amount of 'A's printed.
