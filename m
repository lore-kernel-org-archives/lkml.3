Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaJTAAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 20:00:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28222 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaJTAAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 20:00:15 -0400
Message-ID: <54445079.4000803@oracle.com>
Date: Sun, 19 Oct 2014 19:59:53 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Aaro Koskinen <aaro.koskinen@iki.fi>, Andrew Pinski <pinskia@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: use the gnu89 standard explicitly
References: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>	<CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>	<20141019210348.GA28144@drone.musicnaut.iki.fi>	<CA+55aFzOYL-2WT2bf5C5ODAJnd=qVgpZGb-6o7z56Vu14wavJg@mail.gmail.com>	<20141019231031.GB9319@node.dhcp.inet.fi> <CA+55aFxf6_cA5hTtDGqPU4=DkKz_6OUizhiqge+Xf5u34RxeXw@mail.gmail.com>
In-Reply-To: <CA+55aFxf6_cA5hTtDGqPU4=DkKz_6OUizhiqge+Xf5u34RxeXw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2014 07:49 PM, Linus Torvalds wrote:
> On Sun, Oct 19, 2014 at 4:10 PM, Kirill A. Shutemov
> <kirill@shutemov.name> wrote:
>> >
>> > IIUC, it's nothing to do with volatile. C11 and above reads
>> >
>> >         (rwlock_t) { .raw_lock = { 0 }, }
>> >
>> > as compound literal (which is not constant) rather than constant
>> > initalizer plus a cast.
> Ahh. I thought it was the volatile, just because of the "constant"
> part and the fact that it looked like the test-case was minimal. But
> apparently that was just a red herring.
> 
> So it's just the fact that C11 hasn't got the useful GNU extension of
> a cast-with-initializer, and then that extension got removed (probably
> just an oversight) because people thought that the "standard" C11
> initializers were good enough.
> 
> And it sounds like this will get fixed (perhaps already is) in gcc anyway.

It was already fixed in gcc (I've reported it here:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63567)

> So maybe we need to do that "--std=gnu89" as a temporary workaround,
> but not as long long-term "newer versions are broken".

Agreed, I could send patches to fix the build issues resulting from c11,
but I'm afraid that it'll need real good testing to uncover things that don't
show up during the build.

> That doesn't sound too bad. My main objection to the patch was a
> "let's try to fix this properly instead", but if the breakage is just
> a temporary problem, there's no issue with "properly". Although it
> does look like the *placement* of the --std=gnu89 was incorrect in
> that original patch, so it needs updating regardless.

Apologies. It seemed like the right place to me and it worked fine when
I tested it.

> AndrewP, mind explaing the other difference you mentioned (ie wrt
> "extern inline")? I thought we had already long since ended up
> following the gcc semantics (ie use "static inline" if we don't have
> an external version somehwre), what exactly changed?

(Stolen from gcc changelog:)

gnu89: extern inline: Will not generate an out-of-line version, but
	might call one.
gnu99: extern inline: like GNU "inline", externally visible code is
	emitted.

(So what happens is that with gnu99 you end up with multiple definitions
of the symbol since it was externed from multiple compilation units).


Thanks,
Sasha
