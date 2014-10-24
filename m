Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaJXNYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:24:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31622 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbaJXNYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:24:35 -0400
Message-ID: <544A52D7.6000202@oracle.com>
Date: Fri, 24 Oct 2014 09:23:35 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Daniel Borkmann <dborkman@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        x86@kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: drivers: random: Shift out-of-bounds in _mix_pool_bytes
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com> <5444EBFA.5030103@samsung.com> <20141020124929.GA23177@thunk.org> <54451501.2070700@samsung.com> <5445179A.4080804@redhat.com> <20141020141635.GA4499@thunk.org> <20141024100108.GF12706@worktop.programming.kicks-ass.net>
In-Reply-To: <20141024100108.GF12706@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 06:01 AM, Peter Zijlstra wrote:
> On Mon, Oct 20, 2014 at 10:16:35AM -0400, Theodore Ts'o wrote:
>> > On Mon, Oct 20, 2014 at 04:09:30PM +0200, Daniel Borkmann wrote:
>>>> > > >
>>>> > > >It's triggering when input_rotate == 0, so UBSan complains about right shift in rol32()
>>>> > > >
>>>> > > >static inline __u32 rol32(__u32 word, unsigned int shift)
>>>> > > >{
>>>> > > >	return (word << shift) | (word >> (32 - shift));
>>>> > > >}
>>> > > 
>>> > > So that would be the case when the entropy store's input_rotate calls
>>> > > _mix_pool_bytes() for the very first time ... I don't think it's an
>>> > > issue though.
>> > 
>> > I'm sure it's not an issue, but it's still true that 
>> > 
>> > 	return (word << 0) | (word >> 32);
>> > 
>> > is technically not undefined, and while it would be unfortunate (and
>> > highly unlikely) if gcc were to say, start nethack, it's technically
>> > allowed by the C spec.  :-)
> In fact, n >> 32 == n.
> 
> #include <stdio.h>
> 
> int main(int argc, char **argv)
> {
> 	int i = atoi(argv[1]);
> 	int shift = atoi(argv[2]);
> 	printf("%x\n", i >> shift);
> 	return 0;
> }
> 
> $ ./shift 5 32
> 5
> 
> On x86 at least the shift ops simply mask out the upper bits and
> therefore the 32 == 0.
> 
> So you end up OR-ing the same value twice, which is harmless.
> 
> So no misbehaviour on the rol32() function.
> 
> I think I've ran into this before, in that case I did get fail because I
> did indeed expect the 0 and things didn't work out.

i >> 32 may happen to be "i", but is there anything that prevents the compiler
from returning, let's say, 42?


Thanks,
Sasha
