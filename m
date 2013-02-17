Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab3BQACM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 19:02:12 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41767 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab3BQACK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 19:02:10 -0500
Date: Sat, 16 Feb 2013 16:01:19 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
In-Reply-To: <CA+55aFwF1qZmPaL5LPA+0ys68s=TF7wfXpb5y9GWi0q5RJDJ-Q@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1302161522130.22723@eggly.anvils>
References: <20130212193901.GA18906@redhat.com> <alpine.LNX.2.00.1302121549500.890@eggly.anvils> <20130213004059.GA14451@redhat.com> <alpine.LNX.2.00.1302121652240.1077@eggly.anvils> <20130213041629.GA28622@redhat.com> <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
 <20130213193411.GA15928@redhat.com> <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com> <20130215011503.GA11914@redhat.com> <alpine.LNX.2.00.1302141804400.3330@eggly.anvils> <CA+55aFyLDnmwy16V8TQRwJV2O51K-dmqBhuWi2ytRd4sYi8J+g@mail.gmail.com>
 <alpine.LNX.2.00.1302161302290.21380@eggly.anvils> <CA+55aFwF1qZmPaL5LPA+0ys68s=TF7wfXpb5y9GWi0q5RJDJ-Q@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2013, Linus Torvalds wrote:
> On Sat, Feb 16, 2013 at 1:45 PM, Hugh Dickins <hughd@google.com> wrote:
> >
> > I hacked around on your PM_TRACE set_magic_time() / read_magic_time()
> > yesterday, to save an oopsing core kernel ip there, instead of hashed
> > pm trace info (it makes sense in this case to invert your sequence,
> > putting the high order into years and the low order into minutes).
> 
> That sounds like a good idea in general. The PM_TRACE() thing was done
> to figure out things that locked up the PCI bus etc, but encoding the
> oopses during suspend sounds like a really good idea too.

Yes, it can and should be generalized, but needs more than I gave it.

> 
> Is your patch clean enough to just be made part of the standard
> PM_TRACE infrastructure, or was it something really hacky and one-off?

Not really hacky, but three reasons why it cannot be standard without
more work (I am supposing that it should not be tied to suspend/resume,
but could be used for any oops which gets hidden by graphic screen,
and also fails to reach /var/log/messages).

1. Because I usually have a version of KDB patched into my kernels
("forked" many years ago, never time to integrate with that subset
which eventually went into 2.6.??), it was easiest to implement as
a pair of KDB commands (needing keyboard input: I already knew I
could "reboot" from KDB in this state).  (Sidenote: using KDB can
prevent getting a trace into /var/log/messages: so I had tried
without it, but still failed to get one.)

2. I don't use initrd, have very little in modules, and a pared down
kernel: so for me it was not a serious restriction to limit to core
kernel addresses, which easily fitted within the limit; but we ought
to put thought into handling module addresses too.

3. Needs care on the interface: a debug config option presumably,
but perhaps also needs to tie in with panic_on_oops or something -
I don't like my date getting messed up by surprise, and there's no
point in messing it up unless there's reason to believe the machine
will very quickly be rebooted.  Since I had to open the lid to resume
to hit the oops, in this case we could rely on me quickly rebooting.

But I've appended what I had below, so it's on the record, and can
be taken further if (likely) someone gets there sooner than I do.

> 
> > Rewarded last night by reboot to Feb 21 14:45:53 2006.  Which is
> > ffffffff812d60ed intel_choose_pipe_bpp_dither.isra.13+0x216/0x2d6
> >
> > /home/hugh/3087X/drivers/gpu/drm/i915/intel_display.c:4159
> >          * enable dithering as needed, but that costs bandwidth.  So choose
> >          * the minimum value that expresses the full color range of the fb but
> >          * also stays within the max display bpc discovered above.
> >          */
> >
> >         switch (fb->depth) {
> > ffffffff812d60e9:       48 8b 55 c0             mov    -0x40(%rbp),%rdx
> > ffffffff812d60ed:       8b 02                   mov    (%rdx),%eax
> >
> > (gcc chose to pass a pointer to fb->depth down to the function,
> > instead of fb itself, since that is the only use of it there.)
> >
> > I expect that fb is NULL; but with an average of one failure to resume
> > per day, and ~26 bits of info per crash, this is not a fast procedure!
> >
> > I notice that intel_pipe_set_base() allows for NULL fb,
> > so I'm currently running with the oops-in-rtc hackery, plus
> > -       switch (fb->depth) {
> > +       if (WARN_ON(!fb))
> > +               bpc = 8;
> > +       else switch (fb->depth) {
> >
> > There's been a fair bit of change to intel_display.c since 3.7 (if
> > my 3.7 was indeed good), mainly splitting intel_ into haswell_ versus
> > ironlake_, but I've not yet spotted anything obvious; nor yet looked
> > to see where fb would originate from anyway.
> >
> > Once I've got just a little more info out of it, I'll start another
> > thread addressed principally to the drm/gpu/i915 guys.
> 
> I think it's worth it to give them a heads-up already. So I've cc'd
> the main suspects here..

Okay, thanks.

> 
> Daniel, Dave - any comments about a NULL fb in
> intel_choose_pipe_bpp_dither() during either suspend or resume? Some
> googling shows this:
> 
>     https://bugzilla.redhat.com/show_bug.cgi?id=895123

Great, yes, I'm sure that's the same (though it says "suspend"
and I say "resume").

> 
> which sounds remarkably similar, and is also during a suspend attempt
> (but apparently Satish got a full oops out).. Some timing race with a
> worker entry?
> 
>                         Linus

#include <linux/rtc.h>
#include <asm/rtc.h>
/*
 * HughD adapted the following from drivers/base/power/trace.c:
 *
 * Copyright (C) 2006 Linus Torvalds
 *
 * Trace facility for suspend/resume problems, when none of the
 * devices may be working.
 *
 * Horrid, horrid, horrid.
 *
 * It turns out that the _only_ piece of hardware that actually
 * keeps its value across a hard boot (and, more importantly, the
 * POST init sequence) is literally the realtime clock.
 *
 * Never mind that an RTC chip has 114 bytes (and often a whole
 * other bank of an additional 128 bytes) of nice SRAM that is
 * _designed_ to keep data - the POST will clear it. So we literally
 * can just use the few bytes of actual time data, which means that
 * we're really limited.
 *
 * It means, for example, that we can't use the seconds at all
 * (since the time between the hang and the boot might be more
 * than a minute).
 *
 * There are the wday fields etc, but I wouldn't guarantee those
 * are dependable either. And if the date isn't valid, either the
 * hw or POST will do strange things.
 *
 * So we're left with:
 *  - year: 0-99
 *  - month: 0-11
 *  - day-of-month: 1-28
 *  - hour: 0-23
 *  - min: 0-59
 *
 * Giving us a total range of 0-48384000 (0x2e24800), ie less
 * than 26 bits of actual data we can save across reboots:
 * but that should be enough to save one core kernel address.
 */

#define LIMITING_VALUE (100*12*28*24*60)
static unsigned int saved_value;

static void set_magic_time(unsigned int n)
{
	// June 7th, 2006
	static struct rtc_time time = {
		.tm_sec = 0,
		.tm_min = 0,
		.tm_hour = 0,
		.tm_mday = 7,
		.tm_mon = 5,	// June - counting from zero
		.tm_year = 106,
		.tm_wday = 3,
		.tm_yday = 160,
		.tm_isdst = 1
	};

	time.tm_min = (n % 60);
	n /= 60;
	time.tm_hour = (n % 24);
	n /= 24;
	time.tm_mday = (n % 28) + 1;
	n /= 28;
	time.tm_mon = (n % 12);
	n /= 12;
	time.tm_year = (n % 100);
	set_rtc_time(&time);
}

static unsigned int __init read_magic_time(void)
{
	struct rtc_time time;
	unsigned int n;

	get_rtc_time(&time);
	n = time.tm_year;
	if (n >= 100)
		n -= 100;
	n *= 12;
	n += time.tm_mon;
	n *= 28;
	n += time.tm_mday - 1;
	n *= 24;
	n += time.tm_hour;
	n *= 60;
	n += time.tm_min;
	return n;
}

static int kdba_rtcw(int argc, const char **argv)
{
	unsigned long addr;

	if (!kdb_current_regs)
		return KDB_BADADDR;
	addr = kdb_current_regs->ip;
	if (addr < (unsigned long)_stext ||
	    addr > (unsigned long)_etext)
		return KDB_BADADDR;
	if (addr - (unsigned long)_stext >= LIMITING_VALUE)
		return KDB_BADADDR;
	saved_value = addr - (unsigned long)_stext;
	set_magic_time(saved_value);
	return 0;
}

static int kdba_rtcr(int argc, const char **argv)
{
	int diag = KDB_BADADDR;
	unsigned long addr;

	addr = saved_value + (unsigned long)_stext;
	if (addr < (unsigned long)_stext ||
	    addr > (unsigned long)_etext)
		return diag;
	kdb_printf("%*p %pB\n",
			2 * (int)sizeof(long), (void *)addr, (void *)addr);
	return 0;
}

void __init kdba_rtcinit(void)
{
	saved_value = read_magic_time();
	kdb_register("rtcw", kdba_rtcw, "", "Write ip to rtc", 0);
	kdb_register("rtcr", kdba_rtcr, "", "Read ip from rtc", 0);
}
