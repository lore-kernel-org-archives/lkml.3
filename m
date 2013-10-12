Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab3JLSF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 14:05:59 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:42211 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab3JLSF5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 14:05:57 -0400
MIME-Version: 1.0
In-Reply-To: <20131012171553.GA17548@gmail.com>
References: <20131012171553.GA17548@gmail.com>
Date: Sat, 12 Oct 2013 11:05:56 -0700
X-Google-Sender-Auth: Km0-Pc-Hfbbz0aBUskksOPoCx6Q
Message-ID: <CA+55aFxFu9k7xOWd8DqXx8t+PONoV5ijGJv5mshZrYeVsVp32w@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Len Brown <len.brown@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 10:15 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Ville Syrjälä (1):
>       x86/reboot: Add reboot quirk for Dell Latitude E5410

So we have a number of these quirks, and Dell seems to be one of the
more common factors.

Now, I'd suggest we just trigger it automatically for Dell, but the
thing is, Dell tends to be the *least* differentiating PC maker out
there, so I'm wondering if it is our default reboot order that is just
plain wrong.

We start off trying to reboot using ACPI. Is that really sane? Is
there any reason to not make the default case be to use the PCI
reboot?

The history behind this seems to be that we _used_ to default to
REBOOT_KBD (since that's the traditional method), and fall back to the
triple fault. Then, it was changed to default to ACPI back in 2008 by
Avi Kivity, because those methods apparently could "assert INIT
instead of RESET", and INIT is apparently blocked in Intel VT.  See
commit

But that immediately caused problems, and got reverted by commit
8d00450d296d. But despite the _known_ problems with the ACPI method,
then in 2011 Matthew Garrett defaulted to ACPI again in commit
660e34cebf0a, claiming that that is what Windows does. Which is
clearly NOT TRUE, since I can pretty much guarantee that Windows works
fine on Dell computers.

So Windows clearly does not default to the ACPI reboot model, at least
not unconditionally. There must be something we're missing. I'm
wondering if the way Matthew figured out the Windows defaults was to
run it in a virtual environment? Or uses some other flag to determine
whether the ACPI reboot is reliable or not. Because considering the
known issues with VT, maybe what Windows actually does is to use ACPI
only on VT machines, or something like that.

Because since that whole re-introduction of "default to ACPI", the
majority of patches to the reboot.c file seems to be just "ACPI reboot
doesn't work on this machine, so let's quirk it".

The alternative is that our "acpi_reboot" code is just completely
bogus. If you look at it, it does magic things with
ACPI_ADR_SPACE_PCI_CONFIG: and then calls acpi_reset() if that's not
the case. And the two functions have *inconsistent* validation of the
ACPI registers. acpi_reboot() will happily use a zero address forits
ACPI_ADR_SPACE_PCI_CONFIG poking, for example. And those functions
have gone back and forth on their breakage too (like not checking
ACPI_FADT_RESET_REGISTER which broke things entirely etc etc).

Guys, any ideas/suggestions? Because this constant "let's quirk things
because we're clearly doing something wrong" is wrong.

              Linus
