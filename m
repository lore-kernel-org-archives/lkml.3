Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab3ALWWK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 17:22:10 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:64895 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab3ALWWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 17:22:08 -0500
MIME-Version: 1.0
X-Originating-IP: [71.227.158.139]
In-Reply-To: <1357996822-13072-1-git-send-email-holler@ahsoftware.de>
References: <1357996822-13072-1-git-send-email-holler@ahsoftware.de>
Date: Sat, 12 Jan 2013 14:22:07 -0800
Message-ID: <CAF1V4O8UUgWB1XbS=3EsirBjhP9Lp7JQ8XK8MQxbe3ZkH8pd3Q@mail.gmail.com>
Subject: Re: [PATCH] fb: udlfb: fix hang at disconnect
From: Bernie Thompson <bernie@plugable.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Dave Airlie <airlied@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Sat, Jan 12, 2013 at 5:20 AM, Alexander Holler <holler@ahsoftware.de> wrote:
> When a device was disconnected the driver may hang at waiting for urbs it never
> will get. Fix this by using a timeout while waiting for the used semaphore.

The code used to be this way, but it used to cause nasty shutdown hangs:
http://git.plugable.com/gitphp/index.php?p=udlfb&a=commitdiff&h=1dd39a65001deb5a84088dfabb788d3274fbb6b6

Which is why the code is the way it is today.

Can you say under what situations you're hitting hangs on device
disconnect?  Have you tested extensively to confirm no shutdown hangs
with your patch?

Stepping back, there was another recent patch from the community to
udlfb to work around issues of sleeping in the wrong context. The fix
involved introducing another scheduled workitem. This slows everything
down when it's in the main path, and isn't really desirable if we can
avoid it.

Another option to eliminate all these problems -- long considered but
never implemented -- is to get rid of all semaphores and potential
sleeps in udlfb entirely.  That would require a strategy to throttle
rendering in some way other than by waiting in kernel (without some
throttling strategy, the USB bus can be a bottleneck which can flood
the system with rendered but untransmitted pixels).

Options might be:

1) When transfer buffers are full, keep track of dirty rectangles for
the rest and pick up where we left off the next time we're entered
(avoiding flooding by potentially having pixels in the dirty regions
be written over multiple times before we get to rendering them once)

2 ) If we "bet" on page-fault-based defio dirty pixel detection, we
could allocate buffers dynamically but increase the scheduling time to
transfer as our outstanding buffer count grows, and reduce the latency
only when the buffer count goes down (again, pixels will be
potentially rendered many times before being transfered once, avoiding
flooding).

Any other ideas on the specific or general case are welcome.  Also
note that udlfb is being largely superceeded by the udl DRM driver -
so any decisions here should also be considered in that codebase.

In any case, thanks for giving the DisplayLink USB 2.0 graphics
drivers attention - it's much appreciated!

Bernie Thompson
http://plugable.com/
