Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaKRXEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:04:45 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:42921 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaKRXEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:04:43 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3293FFBA@ORSMSX114.amr.corp.intel.com>
References: <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic> <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
 <20141112162225.GF16807@pd.tnic> <20141113180436.GG14070@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3293BEAE@ORSMSX114.amr.corp.intel.com>
 <20141117185030.GA25157@pd.tnic> <CALCETrXOPc3j8dC3rMS1jbcAofZkXDhFupbtHZgYw1JpmZasOQ@mail.gmail.com>
 <20141117200354.GB25157@pd.tnic> <CALCETrW75rES4=c1AYFXO0pobTZVjb6gYzpgWb0f9jAjYYduPQ@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293F5DA@ORSMSX114.amr.corp.intel.com>
 <CALCETrU6x4yVQy57KGm-Rk==ZYNqHorytAs6WvgKNVoT+Dk9Uw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293F64E@ORSMSX114.amr.corp.intel.com>
 <CALCETrWPzO1vz+Rcjs78B+wWWi4eu_g__-k9iCHH1G1Mc6af+A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293F681@ORSMSX114.amr.corp.intel.com>
 <CALCETrXsxJ6eotRJG1tjPD8dkpAd6P2roDm+fj+Yqi36uh3WHA@mail.gmail.com> <3908561D78D1C84285E8C5FCA982C28F3293FFBA@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 18 Nov 2014 15:04:21 -0800
Message-ID: <CALCETrXdfKut2MDi1Z-iS1aJF30Ebfyumh65=QTm4MCihBbv1A@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 10:30 AM, Luck, Tony <tony.luck@intel.com> wrote:
>>> The lost cpu is *really* lost.  Warm reset doesn't fix the machine, I usually
>>> have to do a full power cycle.
>
>> How is it even possible that I did that with a few lines of asm?
>
> Probably not your directly your fault - some cascade of errors may have occurred.

I went and read the manual.  Here's a hypothesis:

Your test case is presumably doing something that involves setting
undocumented registers* to program the CPU or memory controller to
generate a machine check on access to some address.  Presumably this
is done by broadcasting an SMI and programming the registers in SMM.

Now SMM is rather strange.  The docs list a large set of interrupt
sources that are disabled on SMM entry, and this list does not include
#MC.  So presumably #MC is actually left enabled on entry to SMM.
That means that, unless SMRAM has an interrupt table that has a
working machine check handler (which seems highly unlikely), then
there is at least some window in which a #MC delivered in SMM will
cause some kind of failure.  This could really happen: a broadcast #MC
could easily race a broadcast SMI and do this.

If you crash your SMM code, then I wouldn't be at all surprised if the
CPU wedges hard enough that even your remote management thing can't
reset it.

* These are probably the registers that are supposed to be documented
in volume 2 section 4.4.9 of the Xeon E5 1600/2600 datasheet,
reference 326509-003, but the docs are extremely incomplete.

--Andy

>
>> Could this be a hardware bug?  Is there some condition that causes #MC
>> delivery to wedge hard enough that even INIT/RESET stops working?  Or
>> possibly some CPU got stuck in SMM -- I have no idea what warm reset
>> does these days.
>
> I'm not even sure what kind of reset the remote management i/f I used
> actually applied.
>
>> Here's the patch to improve the timeout messages, but given the degree
>> of wedgedness, I can guess what it'll say:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/paranoid&id=e5cbd9d141bde651ecb20f0b65ad13bcef2468d0
>
> Heh - I'd already put in some hacky printk()s to do similar. Mine aren't upstream quality, but do print the value of mce_callin/mce_executing
> as appropriate.  But I got some confusing results - reporter complained that only 142 of 144 had shown up. So two threads missing,
> maybe means one core went into h/w shutdown.  Need to dig further to see if the missing duo really are from the same core.
>
> -Tony



-- 
Andy Lutomirski
AMA Capital Management, LLC
