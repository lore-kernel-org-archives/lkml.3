Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab3BLUNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:13:23 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:41014 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3BLUNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:13:22 -0500
MIME-Version: 1.0
In-Reply-To: <20130212193901.GA18906@redhat.com>
References: <20130212193901.GA18906@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2013 12:13:00 -0800
X-Google-Sender-Auth: 064Mg0y294-oikVeNxaTZRIYiDw
Message-ID: <CA+55aFwLYMKoyNO8xVdWZ9gorVpaxBM2-_yQck5tQQ1yhpCHDA@mail.gmail.com>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 11:39 AM, Dave Jones <davej@redhat.com> wrote:
> My Thinkpad T430s suspend/resumes fine most of the time. But every so often
> (like one in ten times or so), as soon as I suspend, I get a black screen,
> and a blinking power button.
>
> (Note: Not the capslock lights like when we panic, this laptop 'conveniently
>  doesn't have those. This is the light surrounding the power button, which afaik
>  isn't even OS controlled, so maybe we're dying somewhere in SMI/BIOS land?)

Yeah, the blinking power light is a feature of the chipset, the SMI
code sets a magic bit in one the register and it will pulse a pin at a
given frequency so that you get the "power light blinking while
suspended" thing.

So the suspend finished, and

> I tried debugging this with pm_trace, which told me..
>
> [    4.576035]   Magic number: 0:455:740
> [    4.576037]   hash matches drivers/base/power/main.c:645
>
> Which points me at..
>
>  642  Complete:
>  643         complete_all(&dev->power.completion);
>  644
>  645         TRACE_RESUME(error);
>  646
>  647         return error;
>  648 }

I suspect it's the last tracepoint, and the kernel thinks it
sucessfully resumed all devices. You *should* be able to match the
magic number with the last device too, but that's only interesting if
you get the hash matching *before* the device is resumed (ie you can
try to figure out if the resume hung in the device resume list). And
it only works if it gets a matching name on the dpm_list (see
show_dev_hash), and it apparently didn't. I suspect it's some system
device and not interesting, and you really just hit the last entry in
the resume tree.

> The only thing interesting here I think is that this is the resume path.
> So perhaps something failed to suspend, and we tried to back out of suspending,
> but something was too screwed up to abort cleanly ?

Yes, the trace is definitely in the resume path. And maybe we have something

> I've tried hooking up a serial console, and even tried console_noblank,
> which yielded no additional info at all. (I'm guessing the consoles are suspended
> at the time of panic)

serial consoles and even nonblanking consoles seldom tend to work well
for suspend debugging. It *has* happened, but it's rare.

> I also tried unloading all the modules I have loaded before the suspend, which
> seemed to reduce the chances of it happening, but eventually it reoccurred.
>
> Any ideas on how I can further debug this ?

The design of the TRACE_RESUME() thing really is as a really poor mans
"printf()". IOW, the existing points are more "suggested starting
points" than anything else, and the idea is that you can start adding
more and more of them as you try to narrow down exactly where it
fails..

And it's painful has hell. Plus add too many of them, and you get hash
collisions etc. It's a last-ditch effort, but it exists mainly because
we have never really figured out anything better.

There's a reason I've asked Intel for better CPU lockup tracing
facilities for the last 10+ years ;)

                   Linus
