Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab3DVXFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 19:05:24 -0400
Received: from longford.logfs.org ([213.229.74.203]:58890 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab3DVXFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 19:05:23 -0400
Date: Mon, 22 Apr 2013 17:38:39 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Alan Cox <alan@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] Watchdog: add pretimeout
Message-ID: <20130422213839.GB14907@logfs.org>
References: <20130422194347.GA14907@logfs.org>
 <20130422224203.GA8805@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130422224203.GA8805@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 April 2013 15:42:03 -0700, Guenter Roeck wrote:
> 
> Copying the watchdog mailing list.

I had no idea it exists.  Thanks!

> On Mon, Apr 22, 2013 at 03:43:47PM -0400, Jörn Engel wrote:
> > This patch adds a pretimeout with three actions to the generic watchdog
> > code:
> > 1) Print a kernel message.
> > 2) Send a signal to the userspace process holding /dev/watchdogX open.
> > 3) Call sys_sync.
> > 
> > I have found all of the above to be useful.  If the system gets rebooted
> > by a watchdog, you first want to notice that it happened (1).  Next you
> > want userspace logfiles from the time when it failed to acknowledge the
> > watchdog.  (2) gives cooperating userspace a chance to flush userspace
> > buffers and (3) increases the chances of those logfiles surviving the
> > reboot.
> > 
> > 
> > Given that this patch changes the userspace ABI, now would be a good
> > time to raise concerns.  The most likely problem I see is using SIGILL
> > to notify userspace.  Then again, whatever signal you pick will have
> > other meanings attached, so the only choices are not to notify
> > userspace or to pick some lesser of many evils.
> 
> You could send a udev event, or a poll event, or both.
> 
> I think that sending a signal would be a bad idea, as it could inadvertently
> kill the very application responsible for pinging the watchdog. And you
> can not really expect that application to understand the difference
> between your SIGSomething and a real signal.

The counter-argument is that applications have to opt-in by setting a
pretimeout.  Although I have to admit to not testing applications that
don't opt-in.

Udev sounds like a bad idea, as that usually means spawning a number
of shell scripts and is more likely to get lost in realtime systems or
similar.  Polling on a file descriptor would make sense.

I would be fine with removing the notification for now and have
someone else add a proper interface as time permits.  Someone else may
well be a future version of me.

> Also, I think there should be a callback into the watchdog drivers.
> There are watchdogs out there implementing a pre-timeout in hardware,
> and the watchdog code could make use of that functionality.

Sounds like a good idea in principle, but I can see few advantages in
reality.  The code gets slightly more complex, test coverage is
divided between platforms and it only matters if kernel timers are
somehow borked.  Not sure if you have a strong argument in favor.

Jörn

--
The only real mistake is the one from which we learn nothing.
-- John Powell
