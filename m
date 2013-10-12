Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3JLSTi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 14:19:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37905 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab3JLSTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 14:19:37 -0400
Message-ID: <52599277.3090502@zytor.com>
Date: Sat, 12 Oct 2013 11:18:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Len Brown <len.brown@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
References: <20131012171553.GA17548@gmail.com> <CA+55aFxFu9k7xOWd8DqXx8t+PONoV5ijGJv5mshZrYeVsVp32w@mail.gmail.com>
In-Reply-To: <CA+55aFxFu9k7xOWd8DqXx8t+PONoV5ijGJv5mshZrYeVsVp32w@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2013 11:05 AM, Linus Torvalds wrote:
> On Sat, Oct 12, 2013 at 10:15 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> Ville Syrjälä (1):
>>       x86/reboot: Add reboot quirk for Dell Latitude E5410
> 
> So we have a number of these quirks, and Dell seems to be one of the
> more common factors.
> 
> Now, I'd suggest we just trigger it automatically for Dell, but the
> thing is, Dell tends to be the *least* differentiating PC maker out
> there, so I'm wondering if it is our default reboot order that is just
> plain wrong.
> 
> We start off trying to reboot using ACPI. Is that really sane? Is
> there any reason to not make the default case be to use the PCI
> reboot?

We tried it, it broke too many systems.  However, I'm seriously
considering it for the case of Dell specificall.

The problem with Dell is that they are using something unusual like the
KBC to reboot, *and* apparently it is broken when VT-d is enabled.  This
may becase the versions of Windows they're testing on aren't using it,
or because they "expect" the OS to disable VT-d before shutdown.

> The history behind this seems to be that we _used_ to default to
> REBOOT_KBD (since that's the traditional method), and fall back to the
> triple fault. Then, it was changed to default to ACPI back in 2008 by
> Avi Kivity, because those methods apparently could "assert INIT
> instead of RESET", and INIT is apparently blocked in Intel VT.  See
> commit
> 
> But that immediately caused problems, and got reverted by commit
> 8d00450d296d. But despite the _known_ problems with the ACPI method,
> then in 2011 Matthew Garrett defaulted to ACPI again in commit
> 660e34cebf0a, claiming that that is what Windows does. Which is
> clearly NOT TRUE, since I can pretty much guarantee that Windows works
> fine on Dell computers.
>
> So Windows clearly does not default to the ACPI reboot model, at least
> not unconditionally. There must be something we're missing.

See above.

> I'm
> wondering if the way Matthew figured out the Windows defaults was to
> run it in a virtual environment? Or uses some other flag to determine
> whether the ACPI reboot is reliable or not. Because considering the
> known issues with VT, maybe what Windows actually does is to use ACPI
> only on VT machines, or something like that.
> 
> Because since that whole re-introduction of "default to ACPI", the
> majority of patches to the reboot.c file seems to be just "ACPI reboot
> doesn't work on this machine, so let's quirk it".
> 
> The alternative is that our "acpi_reboot" code is just completely
> bogus. If you look at it, it does magic things with
> ACPI_ADR_SPACE_PCI_CONFIG: and then calls acpi_reset() if that's not
> the case. And the two functions have *inconsistent* validation of the
> ACPI registers. acpi_reboot() will happily use a zero address forits
> ACPI_ADR_SPACE_PCI_CONFIG poking, for example. And those functions
> have gone back and forth on their breakage too (like not checking
> ACPI_FADT_RESET_REGISTER which broke things entirely etc etc).
> 
> Guys, any ideas/suggestions? Because this constant "let's quirk things
> because we're clearly doing something wrong" is wrong.

Very much so... the question is what to do about it.  However, as you
see above we actually have some idea about what is wrong.

	-hpa


