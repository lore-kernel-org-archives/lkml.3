Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3HEQZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:25:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab3HEQZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:25:40 -0400
Message-ID: <51FFD267.6080500@redhat.com>
Date: Mon, 05 Aug 2013 18:27:19 +0200
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130621 Thunderbird/17.0.7
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Borislav Petkov <bp@alien8.de>, edk2-devel@lists.sourceforge.net,
        David Woodhouse <dwmw2@infradead.org>, linux-efi@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [edk2] Corrupted EFI region
References: <20130731205431.GG4724@pd.tnic>  <1375307727.22084.103.camel@shinybook.infradead.org>  <20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com>  <20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com>  <20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com>  <20130805144010.GE31845@pd.tnic> <51FFC19A.1020204@redhat.com> <1375716889.2163.12.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1375716889.2163.12.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies in advance for my response because it diverges from the
technical stuff.

On 08/05/13 17:34, James Bottomley wrote:
> On Mon, 2013-08-05 at 17:15 +0200, Laszlo Ersek wrote:
>> On 08/05/13 16:40, Borislav Petkov wrote:
>>> On Mon, Aug 05, 2013 at 04:27:44PM +0200, Laszlo Ersek wrote:
>>>> I wouldn't call the design of SetVirtualAddressMap() braindead.
>>>
>>> Ok, I've always wondered and you could probably shed some light on the
>>> matter: why is SetVirtualAddressMap() a call-once only? Why can't I
>>> simply call it again and update the mappings?
>>
>> The current implementation (how pointers are converted) probably doesn't
>> accommodate a second call.
> 
> Having actually looked at the code (trying to find why we were getting
> an unconverted pointer), I second that.

I have also "actually" looked at the code, just not right now.

> However, the ugliness of the
> massive pointer chase should have been an indication that something was
> not quite right architecturally (or implementation wise) with
> SetVirtualAddressMap().
> 
>> Of course you want to know why SetVirtualAddressMap() was designed like
>> that... I didn't participate in the design so I don't know :)
>>
>> But, as I said, a kernel directly executing another kernel is an
>> unexpected idea. IMHO the second kernel in question doesn't fit the UEFI
>> phases at all. The OS booted like that (ie. the OS whose kernel is the
>> 2nd (=kexec) kernel) never goes through SEC, PEI, DXE, BDS.
> 
> That thinking is a bit last century (not that I'm blaming you for it, it
> seems to be ingrained in the way UEFI sometimes goes about things) ...

It is not *my* thinking. (This is a recurrent pattern and it drives me mad.)

I just tried to come up with a plausible explanation for why things have
come to be like this. edk2-devel is CC'd; the above was an invitation
for others who *have* participated in the design phase to chime in.

I put on the UEFI hat for the sake of argument.

What many people don't seem to understand (and I have honestly no idea
if this includes you) is that in order to write edk2 code, in order to
post bugfixes with a straight face and with a clear conscience, a person
with a FLOSS / Linux / UNIX background has to *brainwash*
himself/herself into edk2. You must force yourself to identify with the
code to some extent in order to be able to track it, to follow the
original author's train of thought. You can't afford to reject edk2 100%
if you want to effect gradual improvements.

When I got the assignment, this brainwashing I forced upon myself took
me months. The reward for it now is that "my thinking is last century".

Again, I *did not* participate in the design of UEFI. I must simply
accept its main design ideas, sometimes even make (hopefully plausible)
guesses at them, to be able to reason about it.

> in the old days, DOS was bootstrapped by the 512 byte jump code in a
> well known sector.  In the current century, almost every OS is
> bootstrapped by a sophisticated loader, which is effectively another OS
> (if you don't believe this, try looking at the grub source code one
> day);

I've debugged grub and written patches for it. I believe it.

> it's a short step from this to one OS booting another, and that's
> really what kexec is.  The utility of kexec has proven itself over the
> past couple of decades or so by allowing us to dump (kexec to a dump
> kernel),

I've debugged and tested kdump / kexec several times, mainly during my
RHEL-5 Xen days at RH. There's no need to convince me about it.

> short circuit the boot process (simply re-kexec the kernel on
> crash) and now do rebootless upgrades (checkpoint the userspace and
> kexec to the new kernel).  It's not even unique to Linux: Solaris used a
> hidden kexec system call to do live upgrades as well and I believe
> several other UNIXs have this feature.

I was in fact missing this bit about Solaris and other UNIXen.

In any case, by calling kexec "unique/unexpected", I meant that Windows
probably doesn't have it, which was likely the reason the UEFI designers
didn't consider it.

I did not spell out this windows-based argument and went for the polite
route instead because I know where justifying anything with "windows
market dominance / mindshare" leads: more application of the adjective
"braindead".

I'm aware of the love for "management by perkele" on lkml. I oppose it.
(At least on edk2-devel, and I'm not subscribed to lkml partially
because of it.) My OVMF work depends on the goodwill of people on
edk2-devel, and I won't ignite flames that endanger that.

So, my unwashed *guess* is that SetVirtualAddressMap() was designed like
this because Windows doesn't have a need or use for a second
SetVirtualAddressMap() call. (Not sure about non-Linux kernels on Itanium.)

In any case, calling this status quo "last century", "braindead" or
worse won't make you many friends on edk2-devel. The practice of
attacking people whose input you want doesn't look very efficient. And I
certainly do not count myself among those people -- I'm just trying to
help with my limited skills & experience. You want the input of people
*much smarter* than I am. As I gather, many of them don't give a rat's
ass about Linux. (Notice the lack of tumultus in this thread?) Don't
start by alienating them.

"UEFI is an abomination, now help me work with it" is an attitude that
lkml people need to dispense with, in their own best interest.
edk2-devel doesn't appear to be the place where people put up with the
abuse just to get their patches into Linux.

(FWIW I'll help with the issue at hand as much as I can. It may not be
much, apologies.)

Cheers,
Laszlo
