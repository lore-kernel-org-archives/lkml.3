Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaIXPC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:02:56 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:37867 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbaIXPBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:01:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140924145658.GB31678@khazad-dum.debian.net>
References: <9c84cde6-3d70-4337-8738-0283d06d8cf0@email.android.com>
 <20140918200659.GA5331@khazad-dum.debian.net> <20140919001311.GB5331@khazad-dum.debian.net>
 <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
 <20140919110014.GC29639@khazad-dum.debian.net> <20140919112953.GA3256@nazgul.tnic>
 <20140919075415.5149d5f2@as> <20140919150042.GC5318@nazgul.tnic>
 <20140919164217.GD17456@khazad-dum.debian.net> <20140923200054.GB16467@pd.tnic>
 <20140924145658.GB31678@khazad-dum.debian.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 24 Sep 2014 08:00:43 -0700
Message-ID: <CALCETrU3-iNqCOT7EArtB91zAZC6ChuVN1wF6LbtdUqpoyJ+ig@mail.gmail.com>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Borislav Petkov <bp@alien8.de>, Chuck Ebbert <cebbert.lkml@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 7:56 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Tue, 23 Sep 2014, Borislav Petkov wrote:
>> On Fri, Sep 19, 2014 at 01:42:17PM -0300, Henrique de Moraes Holschuh wrote:
>> > 1. offline a "guinea pig" group of "cpus", i.e. an entire "microcode update
>> > unit" that doesn't include the BSP.  This is going to be a pain, as what
>> > composes a "microcode update unit" is not set in stone, and could change in
>> > a future microarch.
>>
>> I'm pretty sure it is very dangerous to run with different microcode
>> revisions on different cores. Your plan won't fly and I have hard time
>> understanding why one would do such thing even if it did work.
>
> I don't want that plan to fly, it is too complex and I wrote as much at
> the end of that email.  I won't bother with the situations where it would
> be helpful, they're not very interesting.
>
>
> On the topic of microcode revision skew in a multi-processor system:
>
> For a long time we had an Extremely Bad userspace interface that required
> userspace to trigger the microcode update once per cpu, and it fetched the
> microcode from userspace once per cpu.
>
> This made for an absurdly large time window during which we'd have
> microcode revision skew across cpus, and yet nothing blew up sky-high.  If
> microcode revision skew was not generally safe, we'd have had a lot of
> trouble already.
>
> In fact, we still run the system with microcode revision skew while the
> microcode update is taking place through the regular microcode driver, as
> it is serialized one cpu at a time, and the other cpus are active and
> running.
>
> I don't know about AMD, but on Intel, the time it takes to update the
> microcode on a core is anything but negligible[1], so the microcode
> version skew window still exists, and it is not small.  It is much smaller
> than it once was, but it is still there.
>
> The only way to really minimize the risk of microcode version skew is to
> limit oneself to firmware and early initramfs microcode updates.
>
>> If we're going to have to hide stuff which software might be using, I
>> don't see a way around rebooting.
>
> Nor do I.
>
> But IMHO we still need to detect and do something smart when
> x86_capability changes due to a microcode update.
>
> And I'd really prefer it to be "update x86_capability, warn the user and
> carry on" for anything that is not going to crash the kernel.  Several
> distros will really want this backported to -stable, as the older kernels
> cannot do early microcode updates.
>

I'm trying to see if Intel is willing to document any additional
controls for the TSX bits in this ucode.  No word yet, but I might
hear something soon.

--Andy

>
> [1] Intel processors take from 200 thousand cycles to several million
>     cycles per core to sucessfully apply a microcode update.  Verified
>     using get_cycles() right before and right after the WRMSR 0x79.
>     Variance was really high, about 10%.  My limited testing matched what
>     has been previously reported by Ben Hawkes.
>
> --
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh



-- 
Andy Lutomirski
AMA Capital Management, LLC
