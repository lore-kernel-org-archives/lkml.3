Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab3KMGIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 01:08:23 -0500
Received: from imap.thunk.org ([74.207.234.97]:57630 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab3KMGIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 01:08:15 -0500
Date: Wed, 13 Nov 2013 01:08:07 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Price <price@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 00/11] random: code cleanups
Message-ID: <20131113060807.GA11394@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg Price <price@MIT.EDU>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	Jiri Kosina <jkosina@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52830546.8010002@zytor.com>
 <20131113042303.GY8043@ringworld.MIT.EDU>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 11:23:03PM -0500, Greg Price wrote:
> > The basic idea is that we don't want to break systems, but we do want
> > to gently coerce people to do the right thing.  Otherwise, I'm worried
> > that distros, or embedded/mobile/consume electronics engineers would
> > just patch out the check.
> 
> That's a good idea.  I've worried about the same thing, but hadn't
> thought of that solution.

I think the key is that we set a default of requiring 128 bits, or 5
minutes, with boot-line options to change the defaults.  BTW, with the
changes that are scheduled for 3.13, this shouldn't be a problem on
most desktops.  From my T430s laptop:

...
[    4.446047] random: nonblocking pool is initialized
[    4.542119] usb 3-1.6: New USB device found, idVendor=04f2, idProduct=b2da
[    4.542124] usb 3-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.542128] usb 3-1.6: Product: Integrated Camera
[    4.542131] usb 3-1.6: Manufacturer: Chicony Electronics Co., Ltd.
[    4.575753] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.653338] udevd[462]: starting version 175
...
[    6.253131] EXT4-fs (sdc3): re-mounted. Opts: (null)

So even without adding device attach times (which is on the todo list)
the /dev/urandom pool is getting an estimated 128 bits of entropy
almost two seconds *before* the root file system is remouted
read/write.

(And this is also before fixing the rc80211 minstrel code to stop
wasting about two dozen bits of entropy at startup --- it's using
get_random_bytes even though it doesn't actually need
cryptographically secure random numbers.)

This is why I've been working improving the random driver's efficiency
in getting the urandom pool as soon as possible, as higher priority
than adding blocking-on-boot for /dev/urandom.

> And, pray tell, how will you know that you have done that?
> 
> Even the best entropy estimation algorithms are nothing but estimations,
> and min-entropy is the hardest form of entropy to estimate.

Of course it's only an estimate.  Some researchers have looked into
this and their results show that at least for x86 desktop/servers, we
appear to be conservative enough in our entropy estimation.  But
ultimately, yes, that is an issue which I am concerned about.  But I
believe that's a separable problem that we can work on separately from
other /dev/random issues --- and I'm hoping we can get some students
to study this problem on a variety of different hardware platforms and
entropy sources.

					- Ted


