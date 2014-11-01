Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbaKATUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 15:20:42 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44026 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759204AbaKATUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 15:20:39 -0400
X-Sasl-enc: OnGiR6qSNJhB91FSgs3X/7Ak4p4+KH51h2jlOaDrLOyT 1414869637
Date: Sat, 1 Nov 2014 17:20:26 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 2/8] x86, microcode, intel: don't update each HT core
 twice
Message-ID: <20141101192026.GA9155@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-3-git-send-email-hmh@hmh.eng.br>
 <20141020133252.GC3524@pd.tnic>
 <20141020182427.GB19306@khazad-dum.debian.net>
 <20141028173109.GB10873@pd.tnic>
 <20141031184344.GB27028@khazad-dum.debian.net>
 <20141101110626.GB4462@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141101110626.GB4462@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Nov 2014, Borislav Petkov wrote:
> Now, we're not about reducing the log info in general but rather only
> saying something when we really have to. Microcode updates should work
> in the background and the user should not be bothered at all about it in
> the normal, success case. Only when there are issues with it, only then
> we want to say something.

I understand your objective, yes.  I just don't agree with your reasoning
entirely.  I fully agree it should not bother the user by inducing doubts,
or being too verbose, though.

Suppose I do the work so that we get something like this:

<microcode driver>: sig XXX, pf XXX, rev YYY

or, if an update is done, we get this *instead*:

<microcode driver>: sig XXX, pf XXX, updated from rev YYY to rev ZZZ (YYYYMMDD)

And that will be all, unless you actually have multiple [different]
microcodes in the system (which is rare), in which case you will get more
lines.

You'd get the same one line if an update is triggered at runtime and it
manages to update at least one processor.

> The late loader is for the cases where you don't want to reboot the
> system when applying microcode.

I used it also as a fallback in Debian/Ubuntu should the early update
driver fail, but I have no idea whether it was effective or not because the
early microcode driver currently fails silently.

Anyway, the use of the late driver in initramfs (even as a fallback) is gone
from Debian since two weeks ago, and it will be gone from Ubuntu when they
sync to Debian once again.

> But all systems out there should enable the early loader - microcode
> should be applied as early as possible.

Agreed.

> > It was also really useful when I was searching the net for reports about a
> > specific processor signature, /proc/cpuinfo is really unhelpful for that.
> 
> Why is that so? Can we improve it?

Yes, we can, but I'd still like to have my one log line per boot, please.

The log line has one feature /proc/cpuinfo won't ever have: it is always
there in the boot logs, even if you didn't ask for it in advance.

And the log currently has one feature that is valuable IMO: it is complete,
it has all the errors, warnings and useful information, and you just need
"grep microcode" to get it all.

> Well, if you really need it, we could add it there:
> 
> cat /proc/cpuinfo:
> 
> ...
> vendor_id       : AuthenticAMD
> cpu family      : 21
> model           : 2
> model name      : AMD FX(tm)-8350 Eight-Core Processor
> stepping        : 0
> microcode       : 0x6000832
> BIOS microcode	: 0x6000822

For /proc/cpuinfo to be complete for *tool use*, I'd really need
cpuid_eax(1), and on intel, the three bits from MSR 0x17 [52:50] in pf_mask
format (1 << (MSR 0x17[52:50])).

microcode sig: 0x0000000
microcode pfm: 0x00	[only on intel]

We could make the "BIOS microcode" line optional, and supress it when no
microcode update was applied (i.e. BIOS microcode == current microcode).

However, that's two new lines for AMD, and three for Intel.


Somewhat related, but independent of what we do to /proc/cpuinfo,
microcode.ko really should grow a signature field in sysfs, so that you
don't need both microcode.ko *and* cpuid.ko to know what microcode the box
needs.  I even have a patch that does this ready, if you want it.

And it is much better to deal with sysfs than parse /proc/cpuinfo...
cpuinfo is for humans, and it is quite important, but machine-parsing it
properly is annoying (requires a state machine, etc).

> but I don't see why you need it. Regardless of the effort, you want to have
> microcode loader running on all systems, that's it.

Eh, I don't _need_ it because right now the kernel log has everything I
want (as long as the late microcode module gets loaded) other than error
messages from the early loader.

> > > > I really miss the full microcode ID information in /proc/cpuinfo, in fact.
> > > 
> > > Full ID, you mean all fields of struct cpu_signature on Intel?
> > 
> > cpu signature, pf mask and revision.  Since we already log the date, might
> > as well keep it too.
> > 
> > >    ->sig - CPUID_EAX(1) which is in /proc/cpuinfo
> > 
> > Not in a format amicable to finding it through a search engine.  Besides, we
> > lose the processor type bits.  Given that we have a brand new i586 chip, who
> 
> processor type bits? What is that?

It is a field composed by cpuid_eax(1) [13:12].  According to the Intel
SDM:

  00b: Original OEM processor
  01b: overdrive processor
  10b: dual processor
  11b: Intel reserved

This is the microcode for the Pentium Overdrive processor:
sig 0x00001632, pf mask 0x00, 1998-06-10, rev 0x0002, size 2048

where you can see that bits 13:12 of the signture are 01b (type: overdrive
processor).

Anyway, AFAIK the Intel SDM defines the microcode signature to be all 32
bits in cpuid_eax(1), including the reserved bits (which doesn't seem
right, you're usually told to mask these to zero, but whatever).

> You can access sysfs then in your scripts and query everything you need.
> And use cpuid.ko and msr.ko too. I think with that you get all the info
> needed.

msr.ko is a security nightmare.  The less it is used, the better.  I'd like
it to either go away entirely, or (more realistically) that it switched to
a processor model-aware whitelist of safe, in-use-by-userspace MSRs, and
reject everything else no matter what (even to processes with
CAP_SYS_RAWIO).

But yes, I can get that information as-is, and I don't even need msr.ko to
do it.  It may not be convenient at all, but the information is reachable
from userspace through cpuid.ko and the late microcode loader
(microcode.ko).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
