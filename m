Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbbAVPvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:51:47 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61161 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752349AbbAVPvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:51:45 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [RFC PATCH] gpio: support for GPIO forwarding
Date: Thu, 22 Jan 2015 17:14:22 +0100
Message-ID: <1564228.rcRekIyDUd@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAAVeFuJjMDfz7TZexkYnYrCGkAmRwubs32UhSPO-4qZWbMJjuQ@mail.gmail.com>
References: <1418890998-23811-1-git-send-email-heikki.krogerus@linux.intel.com> <4078818.ecVtLF3hjd@vostro.rjw.lan> <CAAVeFuJjMDfz7TZexkYnYrCGkAmRwubs32UhSPO-4qZWbMJjuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 22, 2015 11:57:55 AM Alexandre Courbot wrote:
> On Wed, Jan 21, 2015 at 6:25 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Tuesday, January 20, 2015 01:16:06 PM Linus Walleij wrote:
> >> On Mon, Jan 19, 2015 at 6:59 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
> >>
> >> > I am not really fond of this idea since it adds complexity to the
> >> > (already too complex) GPIO lookup, and only solves to a local level
> >> > (GPIO) what is a more global problem (bad ACPI tables that can affect
> >> > any subsystem).
> >> (...)
> >> > it
> >> > seems more to-the-point to find a way to fix/patch the ACPI tables at
> >> > runtime, if that is possible at all, to provide a more general
> >> > solution to this issue.
> >>
> >> This is my position as well, until proven that this cannot be done.
> >
> > Well, that goes against the current practice, mind you, which *is* to put
> > workarounds for buggy ACPI tables into the kernel.  I'm not going to defend
> > that, but it has been done for several years now.
> >
> > Also someone may say to that: "Why don't *you* demonstrate that it can be done
> > in the first place?"  And what if it can be done, but is too complex to be
> > practical or similar?
> >
> > My personal opinion is that having a way to apply a fix on top of broken ACPI
> > tables (or an extension on top of correct ones for that matter) without touching
> > the kernel would be very useful indeed, but making it secure may be somewhat
> > challenging, because in principle there's no reason why the kernel should trust
> > such "external" fixes.
> >
> >> In device tree the same mechanism is called "device tree overlays"
> >> and I just have some vague feeling that such stuff is patched around in
> >> some Intel platforms already, but maybe that involves replacing
> >> the whole DSDT from userspace,
> >
> > From initramfs rather than from user space, but yes, it does.
> >
> >> surely the mechanism can be refined?
> >
> > Yes, it can (in principle).  In fact, we have a plan to refine it, but it is
> > going to take some time.  Once we've done that, we'll see how painful it is to
> > "patch" ACPI tables this way in practice.
> >
> > Also there is an ecosystem problem related to distributing such "patches".
> > Today, distributions don't need to worry about patching buggy platform
> > firmware, because they get workarounds in the kernel, but if we switch over
> > to the model in which platform firmware "overlays" need to be provided in
> > addition to it, then suddenly questions arise about who should be responsible
> > for making them available, how to avoid duplication of efforts between
> > distributions etc.
> >
> > All of that needs to be clarified before we start making hard statements like
> > "No in-kernel workarounds for that!"
> >
> > And, of course, there's the question of what the kernel should do if the given
> > firmware patch is not effective, so it doesn't really fix the problem it is
> > supposed to fix or it fixes that problem only partially or, worse yet, it
> > introuces more bugs than it fixes.  Should the kernel simply fail then (and
> > in what way if so) or should it try to carry out some default "sanitization"
> > of what the firmare (and patch) tells it and try to continue on the best
> > effort basis?
> 
> If we decide to go ahead with the solution proposed by this patch for
> practical reasons (which are good reasons indeed), I still have one
> problem with its current form.
> 
> As the discussion highlighted, this is an ACPI problem, so I'd very
> much like it to be confined to the ACPI GPIO code, to be enabled only
> when ACPI is, and to use function names that start with acpi_gpio.

I can agree with that.

> The current implementation leverages platform lookup, making said lookup
> less efficient in the process and bringing confusion about its
> purpose. Although the two processes are indeed similar, they are
> separate things: one is a legitimate way to map GPIOs, the other is a
> fixup for broken firmware.
> 
> I suppose we all agree this is a hackish fix, so let's confine it as
> much as we can.

OK

Heikki, any comments?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
