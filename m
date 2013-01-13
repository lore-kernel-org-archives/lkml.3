Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab3AMMGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 07:06:06 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:49621 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab3AMMGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 07:06:03 -0500
Message-ID: <50F2A310.5010006@ahsoftware.de>
Date: Sun, 13 Jan 2013 13:05:36 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Bernie Thompson <bernie@plugable.com>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Dave Airlie <airlied@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] fb: udlfb: fix hang at disconnect
References: <1357996822-13072-1-git-send-email-holler@ahsoftware.de> <CAF1V4O8UUgWB1XbS=3EsirBjhP9Lp7JQ8XK8MQxbe3ZkH8pd3Q@mail.gmail.com>
In-Reply-To: <CAF1V4O8UUgWB1XbS=3EsirBjhP9Lp7JQ8XK8MQxbe3ZkH8pd3Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.01.2013 23:22, schrieb Bernie Thompson:
> Hi Alexander,
>
> On Sat, Jan 12, 2013 at 5:20 AM, Alexander Holler <holler@ahsoftware.de> wrote:
>> When a device was disconnected the driver may hang at waiting for urbs it never
>> will get. Fix this by using a timeout while waiting for the used semaphore.
>
> The code used to be this way, but it used to cause nasty shutdown hangs:
> http://git.plugable.com/gitphp/index.php?p=udlfb&a=commitdiff&h=1dd39a65001deb5a84088dfabb788d3274fbb6b6
>
> Which is why the code is the way it is today.
>
> Can you say under what situations you're hitting hangs on device
> disconnect?  Have you tested extensively to confirm no shutdown hangs
> with your patch?
>

The driver almost always (2/3) hangs here when the device gets 
disconnected. It is easy to see when the device gets attached again as 
nothing will happen if the driver (already) hangs (in addition that a 
shutdown isn't possible).

I didn't test it extensively, but without the patch the driver isn't 
usable here. Maybe my previous patch which moves damages to a workqueue 
is the reason that it's more likely that urbs get missing, but the 
problem already existed because an urb might get missed on disconnect. I 
don't know what problems existed before, maybe people just had a problem 
with the BUG_ON(ret). If that _interrupted_ is really needed, it could 
make sense to implement a down_timeout_interruptible() for semaphores.

> Stepping back, there was another recent patch from the community to
> udlfb to work around issues of sleeping in the wrong context. The fix
> involved introducing another scheduled workitem. This slows everything
> down when it's in the main path, and isn't really desirable if we can
> avoid it.

Do you mean the one I've recently posted? It is needed, at least for 3.7 
(I don't know since when those "schedule while atomic" messages appear).
It might slow down refreshes, but it is needed, at least until someone 
gets around those semaphores or removes the spinlocks in upper layers 
(as Alan Cox suggested with the "I am crap" helper for printk).

Maybe using a WQ_HIGHPRI for the workqueue with the damages will speed 
up things.

More optimizations might be doable too (e.g. combining multiple queued 
damages).

> Another option to eliminate all these problems -- long considered but
> never implemented -- is to get rid of all semaphores and potential
> sleeps in udlfb entirely.  That would require a strategy to throttle
> rendering in some way other than by waiting in kernel (without some
> throttling strategy, the USB bus can be a bottleneck which can flood
> the system with rendered but untransmitted pixels).
>
> Options might be:
>
> 1) When transfer buffers are full, keep track of dirty rectangles for
> the rest and pick up where we left off the next time we're entered
> (avoiding flooding by potentially having pixels in the dirty regions
> be written over multiple times before we get to rendering them once)
>
> 2 ) If we "bet" on page-fault-based defio dirty pixel detection, we
> could allocate buffers dynamically but increase the scheduling time to
> transfer as our outstanding buffer count grows, and reduce the latency
> only when the buffer count goes down (again, pixels will be
> potentially rendered many times before being transfered once, avoiding
> flooding).
>
> Any other ideas on the specific or general case are welcome.  Also
> note that udlfb is being largely superceeded by the udl DRM driver -
> so any decisions here should also be considered in that codebase.
>
> In any case, thanks for giving the DisplayLink USB 2.0 graphics
> drivers attention - it's much appreciated!

Thanks for the sugestions, but I don't feel the need to spend a lot of 
time here. I just wanted to use the console with the device and a kernel 
3.7.x and neither udlfb nor udl currently worked (and I'm pretty sure 
I've used one of them some time before, likely udlfb).

Btw, to see the console again after a disconnect and connect, I'm 
currently using the following (necessary) quick&dirty hack:

---------
         /* if clients still have us open, will be freed on last close */
-       if (dev->fb_count == 0)
+//     if (dev->fb_count == 0)
                 schedule_delayed_work(&dev->free_framebuffer_work, 0);
---------

Without that the framebuffer will never get unregistered (because just 
unlinking it doesn't remove the fb-console which counts for one client) 
with the result that the new one (after connecting the device again) 
will not get the console.

Regards,

Alexander
