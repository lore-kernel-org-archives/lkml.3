Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab3A0Wxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 17:53:44 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:60207 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab3A0Wxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 17:53:40 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130124165055.0bceb033.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.1301250041001.25545@skynet.skynet.ie>
	<20130124165055.0bceb033.akpm@linux-foundation.org>
Date: Sun, 27 Jan 2013 23:53:38 +0100
X-Google-Sender-Auth: kmIIXtZwQLxVlTSvqFZnVZWZ7To
Message-ID: <CAKMK7uF+s+bMBp0p36m29Ks9Pt0V5Ehh8k2RNr4UpTRTg4DW1w@mail.gmail.com>
Subject: Re: [git pull] fbcon locking fixes.
From: Daniel Vetter <daniel@ffwll.ch>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linux-fbdev@vger.kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        David Herrmann <dh.herrmann@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 1:50 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 25 Jan 2013 00:42:37 +0000 (GMT)
> Dave Airlie <airlied@linux.ie> wrote:
>
>> These patches have been sailing around long enough, waiting for a maintainer
>> to reappear, so I've decided enough is enough, lockdep is kinda useful to have.
>>
>> Thanks to Daniel for annoying me enough :-)
>
> Me too, but the patches broke Maarten's EFI driver setup:
> https://lkml.org/lkml/2013/1/15/203.

Oops, didn't know that there are open issues, otherwise I'd have
worked on fixes instead of annoying you guys. To make due I've crawled
through fbcon code a bit to hunt for ways we could solve this mess
better than just flinging duct-tape. All the patches extend the
console_lock'ed area quite a bit, and I don't really like big kernel
looks with creeping coverage. More so if they come with funny
semantics like console_lock attached.

Looking at the fb notifier there are three use-cases for it:
- Special blank/unblank handling, used by the backlight and lcd
drivers in the fbdev subsystem. Could easily be extracted to another
notifier chain, and seems to have no need for the console lock. Also,
for kms drivers I don't care about this one bit.
- suspend/resume handling for the same fbdev lcd drivers. Same applies
(besides that it probably should get converted to proper device model
suspend/resume stuff).
- Runtime dependency injection between fbdev (and vga_switcheroor) for
fbcon. This allows you to load fbcon.ko and fbdev drives in any order,
and end up with an fbcon on each fbdev. Or not load fbcon.ko at all,
and only use the underlying fbdev. On a quick look it also racy as
hell.

The last one is the tricky one. If we could just add a hard
(compile-time) dependency between fbdevs and fbcon, we could rip out
all the fb notifier madness which also involves the console_lock in
some way and should be able to straighten out the locking. Users could
still opt out of using the fbcon at runtime, but ofc this might break
a really obscure setup somewhere. Quick survey of distros shows though
that all use the sane option of built-in fbcon support.

My proposal is to change the fbcon tristate to a bool and see what
happens. If it works out for a few kernel releases, garbage-collect
the fb_notifier for fbcon and use direct function calls instead
(stubbed it out properly if fbcon is disabeld ofc). Or is that too
much bending of the "thou shalt not break stuff" rule?

Plan B would be to simply mash-up a console on top of kms drivers
directly (since that's what I care about). Which has the downside that
we'd still need to keep the drm fbdev emulation helper code around,
since quite a few people use that to run older userspace (and even
report some bugs, e.g. mplayer on the linux console played some tricks
we needed to catch). And so end up with two pieces of code who's main
job is to paint console output onto the screen.

Ideas?

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
