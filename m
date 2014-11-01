Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbaKALGc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 07:06:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53145 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbaKALGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 07:06:30 -0400
Date: Sat, 1 Nov 2014 12:06:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 2/8] x86, microcode, intel: don't update each HT core
 twice
Message-ID: <20141101110626.GB4462@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-3-git-send-email-hmh@hmh.eng.br>
 <20141020133252.GC3524@pd.tnic>
 <20141020182427.GB19306@khazad-dum.debian.net>
 <20141028173109.GB10873@pd.tnic>
 <20141031184344.GB27028@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141031184344.GB27028@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 04:43:45PM -0200, Henrique de Moraes Holschuh wrote:
> Every time I issued a warning to users that they need to upgrade their
> microcode due to either security errata or other nasty issue, the fact that
> you can just grep for microcode in the logs to know whether it worked or not
> *and* the reasons why it did/did not work has been helpful.

Ok, I see what you mean.

A couple of thoughs/suggestions for that:

/proc/cpuinfo is the place which gives you, well, CPU info. So all
the information pertinent to the CPU should be there. And since on bug
reports we do ask for /proc/cpuinfo along with dmesg, I think that
should be fine.

Now, we're not about reducing the log info in general but rather only
saying something when we really have to. Microcode updates should work
in the background and the user should not be bothered at all about it in
the normal, success case. Only when there are issues with it, only then
we want to say something.

> The logging also tells me whether the early or regular microcode driver was
> the one that did the update.  This matters to me, as it helps me detect when
> the regular microcode update driver is doing work that should have been done
> by the early driver.

This is wrong: if! the early loader is enabled and initrd is supplied,
it should apply the microcode. That's why it is an early loader in the
first place.

The late loader is for the cases where you don't want to reboot the
system when applying microcode.

But all systems out there should enable the early loader - microcode
should be applied as early as possible.

> It was also really useful when I was searching the net for reports about a
> specific processor signature, /proc/cpuinfo is really unhelpful for that.

Why is that so? Can we improve it?

> It also gives me one interesting information that just looking at
> /proc/cpuinfo doesn't: the version of the microcode installed by the user's
> BIOS/UEFI.  This kind of information is relevant to some of the Linux
> distros (at least to Debian) due to the non-free nature of the microcode
> updates [note: this assumes the regular microcode driver was loaded].  It is
> the only metric I have that tells me whether the effort is worth it.

Well, if you really need it, we could add it there:

cat /proc/cpuinfo:

...
vendor_id       : AuthenticAMD
cpu family      : 21
model           : 2
model name      : AMD FX(tm)-8350 Eight-Core Processor
stepping        : 0
microcode       : 0x6000832
BIOS microcode	: 0x6000822

but I don't see why you need it. Regardless of the effort, you want to have
microcode loader running on all systems, that's it.

> > > I really miss the full microcode ID information in /proc/cpuinfo, in fact.
> > 
> > Full ID, you mean all fields of struct cpu_signature on Intel?
> 
> cpu signature, pf mask and revision.  Since we already log the date, might
> as well keep it too.
> 
> >    ->sig - CPUID_EAX(1) which is in /proc/cpuinfo
> 
> Not in a format amicable to finding it through a search engine.  Besides, we
> lose the processor type bits.  Given that we have a brand new i586 chip, who

processor type bits? What is that?

> is to say we won't see once again processors that have one of those bits set
> in their signature?
> 
> >    ->pf - processor flags in MSR_0x17[52:50] - I guess you can read that
> >    out with rdmsr 0x17. Why do we need to know that one except maybe to
> >    verify why a patch doesn't get accepted by the loader?
> 
> This one has very limited use right now, yes.  But without it, I cannot even
> tell whether the user has an up-to-date microcode or not when Intel releases
> microcode updates that do not apply to all processors with the same
> CPUID_EAX(1).  They haven't done this in the last couple years, but it is
> needed for processors that are not that old, such as cpuid 0x30661 (Intel
> Atom D25xx/N26xx,N28xx, from 2011).  It is likely it will be needed again.

Well, you have all that info:

grep . /sys/devices/system/cpu/cpu?/microcode/*
/sys/devices/system/cpu/cpu0/microcode/processor_flags:0x10
/sys/devices/system/cpu/cpu0/microcode/version:0x1b
/sys/devices/system/cpu/cpu1/microcode/processor_flags:0x10
/sys/devices/system/cpu/cpu1/microcode/version:0x1b
/sys/devices/system/cpu/cpu2/microcode/processor_flags:0x10
/sys/devices/system/cpu/cpu2/microcode/version:0x1b
/sys/devices/system/cpu/cpu3/microcode/processor_flags:0x10
/sys/devices/system/cpu/cpu3/microcode/version:0x1b

We can easily extend sysfs with more info required instead of spewing it
into dmesg.

You can access sysfs then in your scripts and query everything you need.
And use cpuid.ko and msr.ko too. I think with that you get all the info
needed.

> It is for debugging, indeed.  But too much stuff never logs at the pr_debug
> level, so you need to take special action.  If you accept my proposal for
> log size reduction while still logging the stuff I find useful, this could
> be pr_info() as it would *not* be per-core anymore.

See above.

Bottom line is: dmesg should contain only error information when
microcode fails applying. All the remaining info should be in sysfs and
/proc/cpuinfo.

This is much cleaner IMO and will save us a lot of useless bug reports.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
