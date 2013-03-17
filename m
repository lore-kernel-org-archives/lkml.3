Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab3CQTuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 15:50:07 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:35091 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab3CQTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 15:50:04 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130316101920.GB17405@cantiga.alporthouse.com>
References: <CA+ydwtpuBvbwxbt-tdgPUvj1EU7itmCHo_2B3w13HkD5+jWKow@mail.gmail.com>
	<1363265997-29023-1-git-send-email-chris@chris-wilson.co.uk>
	<20130315045004.GA14747@bwidawsk.net>
	<20130315082403.GA29916@cantiga.alporthouse.com>
	<20130315163606.GA17773@bwidawsk.net>
	<20130315220619.GA17405@cantiga.alporthouse.com>
	<20130315234942.GB715@bwidawsk.net>
	<20130316101920.GB17405@cantiga.alporthouse.com>
Date: Sun, 17 Mar 2013 20:50:03 +0100
Message-ID: <CAKMK7uFiMLcE_TYj5=sKZsVAcCnWSmg49qPrxjswH2s3J5byOg@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Sanity check incoming ioctl data
 for a NULL pointer
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>, Ben Widawsky <ben@bwidawsk.net>,
        Tommi Rantala <tt.rantala@gmail.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 11:19 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Fri, Mar 15, 2013 at 04:49:42PM -0700, Ben Widawsky wrote:
>> On Fri, Mar 15, 2013 at 10:06:19PM +0000, Chris Wilson wrote:
>> > On Fri, Mar 15, 2013 at 09:36:07AM -0700, Ben Widawsky wrote:
>> > > On Fri, Mar 15, 2013 at 08:24:03AM +0000, Chris Wilson wrote:
>> > > > That's what I thought too. Looking at the stack trace, the empirical
>> > > > evidence is that we need the check.
>> > > > -Chris
>> > >
>> > > I think we need to investigate the issue more then, or put a BUG_ON() in
>> > > the drm code and run it through trinity. We have other places where arg
>> > > can't/shouldn't be NULL and we don't check.
>> >
>> > Actually we are both wrong. drm_ioctl() does not validate that the
>> > user struct matches the expected size, just ensures that if that user
>> > cmd specifies that the arg is to be used that it only up to the known
>> > size is copied.
>> >
>> > A hostile userspace can bludgen a NULL pointer through drm_ioctl() into
>> > the driver->ioctl->func().
>>
>> > > > +   if (args == NULL)
>> > > > +           return -EINVAL;
>> > > > +
>>
>> I must be failing to see the obvious, but I'm still not getting how args
>> can ever be NULL. kdata which is passed to us as "data" and cast to
>> "args' is either always some stack variable, or some kmalloc'd memory. I
>> see how the arguments themselves can be crap which is really only when
>> user size != drv_size.
>>
>> So tell me, which case can result in a NULL arg?
>> 1. user size == drv_size // better not be this one
>> 2. user size < driver size
>> 3. user size > driver size
>>
>> It seems to me we still must [simply] be missing something in our
>> parameter validation.
>
> If *userspace* doesn't request either IOC_IN | IOC_OUT in their ioctl
> command (which are seperate from the ioctl number), then kdata is set to
> NULL.

Doesn't that mean that we need these checks everywhere? Or at least a
fixup in drm core proper?

And I think we need to add trinity to our test setup eventually ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
