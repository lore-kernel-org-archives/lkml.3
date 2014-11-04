Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbaKDPx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:53:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34195 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbaKDPxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:53:54 -0500
Date: Tue, 4 Nov 2014 16:53:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 2/8] x86, microcode, intel: don't update each HT core
 twice
Message-ID: <20141104155345.GA14296@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-3-git-send-email-hmh@hmh.eng.br>
 <20141020133252.GC3524@pd.tnic>
 <20141020182427.GB19306@khazad-dum.debian.net>
 <20141028173109.GB10873@pd.tnic>
 <20141031184344.GB27028@khazad-dum.debian.net>
 <20141101110626.GB4462@pd.tnic>
 <20141101192026.GA9155@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141101192026.GA9155@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 05:20:26PM -0200, Henrique de Moraes Holschuh wrote:
> I understand your objective, yes.  I just don't agree with your reasoning
> entirely.  I fully agree it should not bother the user by inducing doubts,
> or being too verbose, though.
> 
> Suppose I do the work so that we get something like this:
> 
> <microcode driver>: sig XXX, pf XXX, rev YYY
> 
> or, if an update is done, we get this *instead*:
> 
> <microcode driver>: sig XXX, pf XXX, updated from rev YYY to rev ZZZ (YYYYMMDD)
> 
> And that will be all, unless you actually have multiple [different]
> microcodes in the system (which is rare), in which case you will get more
> lines.
> 
> You'd get the same one line if an update is triggered at runtime and it
> manages to update at least one processor.

And what is wrong with putting that info in /proc/cpuinfo and not saying
anything in dmesg?

> I used it also as a fallback in Debian/Ubuntu should the early update
> driver fail, but I have no idea whether it was effective or not because the
> early microcode driver currently fails silently.

The early driver should not fail - if it does we need to fix it. Feel
free to CC me on bug reports so that this gets sorted out and fixed.

And it fails silently because that early we cannot call anything
printk-like anyway as a debugging aid.

> Yes, we can, but I'd still like to have my one log line per boot, please.
> 
> The log line has one feature /proc/cpuinfo won't ever have: it is always
> there in the boot logs, even if you didn't ask for it in advance.

Yeah right. Even if dmesg ring buffer has wrapped and overwritten stuff.

The lines which are always there are the /proc/cpuinfo ones. And CPU
microcode belongs to the CPU so it is only natural to put it there.
Oh, and removing the dmesg likes will save you silly bug reports like
microcode being updated only on the even-numbered cores.

> For /proc/cpuinfo to be complete for *tool use*, I'd really need
> cpuid_eax(1),

No, you don't. You can *call* CPUID in your tool.

>  and on intel, the three bits from MSR 0x17 [52:50] in pf_mask
> format (1 << (MSR 0x17[52:50])).
> 
> microcode sig: 0x0000000
> microcode pfm: 0x00	[only on intel]
> 
> We could make the "BIOS microcode" line optional, and supress it when no
> microcode update was applied (i.e. BIOS microcode == current microcode).
> 
> However, that's two new lines for AMD, and three for Intel.

Not a problem.

> Somewhat related, but independent of what we do to /proc/cpuinfo,
> microcode.ko really should grow a signature field in sysfs, so that you
> don't need both microcode.ko *and* cpuid.ko to know what microcode the box
> needs.  I even have a patch that does this ready, if you want it.

You can call CPUID in your tool - it is not a privileged instruction
like accessing the MSRs, for example.

> And it is much better to deal with sysfs than parse /proc/cpuinfo...
> cpuinfo is for humans, and it is quite important, but machine-parsing it
> properly is annoying (requires a state machine, etc).

Really?! I'd use awk :-)

But whatever, we can put stuff in sysfs if you prefer.

> It is a field composed by cpuid_eax(1) [13:12].  According to the Intel
> SDM:
> 
>   00b: Original OEM processor
>   01b: overdrive processor
>   10b: dual processor
>   11b: Intel reserved
> 
> This is the microcode for the Pentium Overdrive processor:
> sig 0x00001632, pf mask 0x00, 1998-06-10, rev 0x0002, size 2048
> 
> where you can see that bits 13:12 of the signture are 01b (type: overdrive
> processor).

Ok.

> Anyway, AFAIK the Intel SDM defines the microcode signature to be all 32
> bits in cpuid_eax(1), including the reserved bits (which doesn't seem
> right, you're usually told to mask these to zero, but whatever).

They probably say somewhere too that those are Read-As-Zero too...

> msr.ko is a security nightmare.  The less it is used, the better.  I'd like
> it to either go away entirely, or (more realistically) that it switched to
> a processor model-aware whitelist of safe, in-use-by-userspace MSRs, and
> reject everything else no matter what (even to processes with
> CAP_SYS_RAWIO).

Right, I think people even blacklist it on production systems.

> But yes, I can get that information as-is, and I don't even need msr.ko to
> do it.  It may not be convenient at all, but the information is reachable
> from userspace through cpuid.ko and the late microcode loader
> (microcode.ko).

Ok, so far I gather all you need is CPUID which you can call - you
don't necessarily need cpuid.ko - and stuff exported through sysfs or
/proc/cpuinfo.

Sounds like a much better interface to me than grepping to fragile logs
which might get overwritten.

Btw, on bug reports, you can do a small script which goes and collects
all that info from the user's machine. I know alsa does something like
that.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
