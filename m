Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3DVXZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 19:25:47 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52811 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab3DVXZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 19:25:46 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 22 Apr 2013 16:26:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Alan Cox <alan@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] Watchdog: add pretimeout
Message-ID: <20130422232613.GA28472@roeck-us.net>
References: <20130422194347.GA14907@logfs.org>
 <20130422224203.GA8805@roeck-us.net>
 <20130422213839.GB14907@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130422213839.GB14907@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 05:38:39PM -0400, Jörn Engel wrote:
> On Mon, 22 April 2013 15:42:03 -0700, Guenter Roeck wrote:
> > 
> > Copying the watchdog mailing list.
> 
> I had no idea it exists.  Thanks!
> 
> > On Mon, Apr 22, 2013 at 03:43:47PM -0400, Jörn Engel wrote:
> > > This patch adds a pretimeout with three actions to the generic watchdog
> > > code:
> > > 1) Print a kernel message.
> > > 2) Send a signal to the userspace process holding /dev/watchdogX open.
> > > 3) Call sys_sync.
> > > 
> > > I have found all of the above to be useful.  If the system gets rebooted
> > > by a watchdog, you first want to notice that it happened (1).  Next you
> > > want userspace logfiles from the time when it failed to acknowledge the
> > > watchdog.  (2) gives cooperating userspace a chance to flush userspace
> > > buffers and (3) increases the chances of those logfiles surviving the
> > > reboot.
> > > 
> > > 
> > > Given that this patch changes the userspace ABI, now would be a good
> > > time to raise concerns.  The most likely problem I see is using SIGILL
> > > to notify userspace.  Then again, whatever signal you pick will have
> > > other meanings attached, so the only choices are not to notify
> > > userspace or to pick some lesser of many evils.
> > 
> > You could send a udev event, or a poll event, or both.
> > 
> > I think that sending a signal would be a bad idea, as it could inadvertently
> > kill the very application responsible for pinging the watchdog. And you
> > can not really expect that application to understand the difference
> > between your SIGSomething and a real signal.
> 
> The counter-argument is that applications have to opt-in by setting a
> pretimeout.  Although I have to admit to not testing applications that
> don't opt-in.
> 
Still, how does the application distinguish SIGINT (real from SIGINT (watchdog) ?

> Udev sounds like a bad idea, as that usually means spawning a number
> of shell scripts and is more likely to get lost in realtime systems or
> similar.  Polling on a file descriptor would make sense.
> 
> I would be fine with removing the notification for now and have
> someone else add a proper interface as time permits.  Someone else may
> well be a future version of me.
> 
> > Also, I think there should be a callback into the watchdog drivers.
> > There are watchdogs out there implementing a pre-timeout in hardware,
> > and the watchdog code could make use of that functionality.
> 
> Sounds like a good idea in principle, but I can see few advantages in
> reality.  The code gets slightly more complex, test coverage is
> divided between platforms and it only matters if kernel timers are
> somehow borked.  Not sure if you have a strong argument in favor.
> 
I am currently dealing with a watchdog which does support pre-timeouts.
It would seem odd to me if the core watchdog API would support pre-timeouts,
but not the pre-timeouts supported by the actual watchdog driver.

For that specific driver, there would be two means to set a pre-timeout:
The one in the watchdog core, and the one in the actual watchdog driver.
Both would be independent of each other, and both would be set independently.
That doesn't make much sense to me and would be just as good as implementing
a softdog in the watchdog core and not supporting the actual hardware-watchdogs
through its API.

Guenter
