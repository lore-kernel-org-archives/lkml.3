Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186Ab3D3Agm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:36:42 -0400
Received: from peace.netnation.com ([204.174.223.2]:47311 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3D3Agk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:36:40 -0400
Date: Mon, 29 Apr 2013 17:36:40 -0700
From: Simon Kirby <sim@hostway.ca>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [ 02/42] TTY: do not update atime/mtime on read/write
Message-ID: <20130430003639.GB17260@hostway.ca>
References: <20130429184752.435249613@linuxfoundation.org>
 <20130429184752.700428715@linuxfoundation.org>
 <20130430001445.GA17260@hostway.ca>
 <20130430002117.GA4202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430002117.GA4202@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 05:21:17PM -0700, Greg Kroah-Hartman wrote:

> On Mon, Apr 29, 2013 at 05:14:45PM -0700, Simon Kirby wrote:
> > On Mon, Apr 29, 2013 at 12:01:44PM -0700, Greg Kroah-Hartman wrote:
> > 
> > > 3.8-stable review patch.  If anyone has any objections, please let me know.
> > 
> > I object. This breaks functionality I use every day (seeing who else is
> > working on stuff with "w").
> > 
> > Furthermore, the patch does not actually fix the hole referenced (see
> > ptmx-keystroke-latency.c on http://vladz.devzero.fr/013_ptmx-timing.php).
> > I can still reproduce the timing capture even with this patch applied
> > (in 3.9-rc8).
> 
> How?  There are no keystrokes being reported to other users, or did we
> miss something with this patch?

wget http://vladz.devzero.fr/svn/codes/PoC/ptmx-keystroke-latency.c
gcc -O ptmx-keystroke-latency ptmx-keystroke-latency.c
./ptmx-keystroke-latency

Log in to another tty, as another user. See keystroke timing. 3.9-rc8.

Seems like it was missed. Meanwhile, idle times in "w" do not update.

> > The grsec patch instead introdues another test within the inotify code
> > (is_sidechannel_device()-related bits) -- untested by me, but probably
> > more relevant.
> > 
> > Even 37b7f3c76595e23257f61bd80b223de8658617ee, the "regression fix",
> > which Linus merged in for the 3.9 release, is still a regression for me.
> 
> And I applied that one as well.

Right, so this restores updates but increases the granularity to 60
seconds. I'm complaining that this is still affects my occupational
performance.

> > 60 seconds means somebody is asleep in my environment, and so is still
> > the kind of thing that just pisses me off. I'd rather revert this whole
> > thing.
> 
> Users taking a break for longer than a minute upset you?  What are you
> really trying to keep track of here?

Really? In a team environment, a person idle for 30 seconds means they've
stopped to look at something else. Now we have to wait 2 minutes to know
if this has happened or not. Now it becomes faster to interrupt somebody
to ask them if maintenance can be done, etc.

> > I'd stand maybe 1 seconds as maximum granularity. You could do that with
> > less code and no test.
> 
> Patch to show this?

I was thinking of just updating the seconds field of the timespec struct,
or leaving this particular part and setting sb->s_time_gran to 100000000,
though that would probably break other things. Since I've never looked at
this stuff before, I'm not sure I should make a patch, but I can...

Simon-
