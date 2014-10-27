Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaJ0Mwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:52:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJ0Mww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:52:52 -0400
Date: Mon, 27 Oct 2014 10:52:37 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "ramakrmu@cisco.com" <ramakrmu@cisco.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sander Eikelenboom <linux@eikelenboom.it>, prabhakar.csengg@gmail.com,
        Antti Palosaari <crope@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        "olebowle@gmx.com" <olebowle@gmx.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v2 5/6] sound/usb: pcm changes to use media
 token api
Message-ID: <20141027105237.5f5ec7fd@recife.lan>
In-Reply-To: <s5hk33n8ccj.wl-tiwai@suse.de>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
	<cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com>
	<543FB374.8020604@metafoo.de>
	<543FC3CD.8050805@osg.samsung.com>
	<s5h38aow1ub.wl-tiwai@suse.de>
	<543FD1EC.5010206@osg.samsung.com>
	<s5hy4sgumjo.wl-tiwai@suse.de>
	<543FD892.6010209@osg.samsung.com>
	<s5htx34ul3w.wl-tiwai@suse.de>
	<54467EFB.7050800@xs4all.nl>
	<s5hbnp5z9uy.wl-tiwai@suse.de>
	<CAGoCfixD-zv1MMHUXLnjGV5KVB-DGdp2ZqZ0hUTR14UvLh-Gvw@mail.gmail.com>
	<544804F1.7090606@linux.intel.com>
	<20141025114115.292ff5d2@recife.lan>
	<s5hk33n8ccj.wl-tiwai@suse.de>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, 26 Oct 2014 09:27:40 +0100
Takashi Iwai <tiwai@suse.de> escreveu:

> At Sat, 25 Oct 2014 11:41:15 -0200,
> Mauro Carvalho Chehab wrote:

> >      +---------------+
> >      |     start     |
> >      +---------------+
> >        |
> >        |
> >        v
> >      +--------------------------------+
> >      |              idle              | <+
> >      +--------------------------------+  |
> >        |                ^           |    |
> >        |                |           |    |
> >        v                |           |    |
> >      +---------------+  |           |    |
> >      | configuration |  |           |    |
> >      +---------------+  |           |    |
> >        |                |           |    |
> >        |                |           |    |
> >        v                |           |    |
> >      +---------------+  |           |    |
> >   +> |   streaming   | -+           |    |
> >   |  +---------------+              |    |
> >   |    |                            |    |
> >   |    |                            |    |
> >   |    v                            v    |
> >   |  +---------------+-----------+----+  |
> >   +- |       1       | suspended |  2 | -+
> >      +---------------+-----------+----+


The above diagram is actually simplified. There's an extra state
there that should be mentioned:

idle <-> DVB stream

(actually, DVB stream is a copy of the above, except that ALSA
won't have any business to do while the device is on DVB mode)

> So, judging from your description, the problem isn't about the
> exclusive lock, but rather implementation a kind of master/slave
> devices?  Then the proposed patch doesn't look like a correct
> implementation to me.

You might see it as a master/slave, except that it is not that simple.
It is really a hardware lock.

There are actually 3 (sub)drivers that may need to set the hardware:
	- ALSA driver;
	- V4L2 driver;
	- DVB driver.

The goal of the lock is to prevent that more than one driver would try 
to use a common piece of the hardware that it is already in usage
by another driver.

So, for example, the ALSA driver should not reprogram the hardware while 
the V4L2 driver is doing that.

I agree that, for V4L2/ALSA driver's interaction PoV, it could resemble
a sort of master/slave control, in the sense that ALSA capture start only
makes sense while V4L2 is at streaming state. Yet, just opening the device
or (even start capture on ALSA, for the hardware with multiple DMA engines,
like the ones that use snd-usb-audio) won't cause any harm if the V4L2 driver
is not reconfiguring the audio registers at the same time.

Also, ALSA open/close should be supported any time, as otherwise it will 
break existing applications. 

However, when the device is streaming on DVB mode, it is not possible
to stream on V4L2 mode, as there's just one DMA for both and just one
tuner. Also, ALSA capture doesn't make much sense on such case. Still,
locking on open/close may eventually break existing applications. Also,
it doesn't really make any sense to block the device to move from analog
to digital mode just because the ALSA devnodes are opened.

> What I (and supposedly Pierre) opposed is the implementation of
> exclusive lock control in spontaneous callbacks.  Especially the
> trigger callback is a bad place since it's a callback that is supposed
> to just trigger atomically.  In general, the only good place for
> allowing user-space to *control* the exclusive lock is open/close,
> unless the finer lock control is exposed.

I see your point. Then perhaps we should expose callbacks from other
parts of the ALSA core, perhaps at the logic that calls the trigger
callback at read and poll syscalls, plus the corresponding logic that is
used when the device is using the mmap syscall.

> But, reading through the argument from you guys, the intention of the
> patch seems like just to raise the conflict from the hardware level to
> the software level. 

Yes.

> If so, I doubt whether such an exclusive lock is
> the best way.   For example, audio stream can simply receive an error
> at any time if something is wrong and reacts accordingly instead of
> keeping the lock while streaming. Then the master side (video) can
> set the error flag, let the audio stream stop in the driver (if
> running), and sync with it.

Hmm... this is actually more complex than that. V4L2 driver doesn't
know if ALSA is streaming or not, or even if ALSA device node is opened
while he is touching at the hardware configuration or changing the
state. I mean: it is not an error to set the hardware. The error only
happens if ALSA and V4L2 tries to do it at the same time on an incompatible
way.

Also, this won't work for DVB, as on DVB this is really an exclusive
lock that would prevent both ALSA and V4L2 drivers to stream while in
DVB mode.

Implementing it with a lock seems to be the best approach, at least on
my eyes.

> That said, we should go back and start discussing the design goal at
> first.

Surely.

> 
> 
> thanks,
> 
> Takashi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
