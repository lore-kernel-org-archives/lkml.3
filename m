Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaJXKQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:16:50 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33722 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbaJXKQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:16:34 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-3e-544a26fe6e4e
Message-id: <544A26FD.9060406@samsung.com>
Date: Fri, 24 Oct 2014 14:16:29 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Daniel Borkmann <dborkman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: drivers: random: Shift out-of-bounds in _mix_pool_bytes
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
 <5444EBFA.5030103@samsung.com> <20141020124929.GA23177@thunk.org>
 <54451501.2070700@samsung.com> <5445179A.4080804@redhat.com>
 <20141020141635.GA4499@thunk.org>
 <20141024100108.GF12706@worktop.programming.kicks-ass.net>
In-reply-to: <20141024100108.GF12706@worktop.programming.kicks-ass.net>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t/xq7r/1LxCDK432Vh8/dLBYjFn/Ro2
	ixP/jzBaTHjYxm4xbaO4xcrOB6wWf3btYLK4vGsOm8WlAwuYLFr2XWCyON57gMli8ZHbzBab
	N01ltmjt+clu8WPDY1YHfo+WzeUeO2fdZfdYsKnUY/MKLY9NqzrZPN6dO8fucWLGbxaPpjNH
	mT0+Pr3F4vF+31U2jzMLjrB7fN4k53Gi5QtrAG8Ul01Kak5mWWqRvl0CV8aDtsiC1dwVr/f9
	YmpgvM7RxcjJISFgIrHu40ImCFtM4sK99WxdjFwcQgJLGSXurV7CDuE0M0m8ej4HrIpXQEti
	6qnlrCA2i4CqxK7338BsNgE9iX+ztrOB2KICERJX1sxhhKgXlPgx+R4LyCARgTksEof7J4MV
	CQu4SJy694gdxBYSWMUksbGbG8TmFHCXWPTnEtAyDg5moKH3L2qBhJkF5CU2r3nLPIGRfxaS
	sbMQqmYhqVrAyLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyTGvu5gXHrM6hCjAAejEg/v
	jy2eIUKsiWXFlbmHGCU4mJVEeGdJe4UI8aYkVlalFuXHF5XmpBYfYmTi4JRqYFRdpTLptP3H
	5ROFdI0WlH28tKe3nlXoQHdp93r+VzO0G9RbD7xyX7Kx9rqI2NV+lcR3V2c8Kehqmb2V48hy
	3XMPE9a1CNW0WtiKSlx8/NXdoT3Q/iHX5PPH3mtlPEnUYv2mkMpXH3svPWytkdK29ScqvuZM
	kDa2b0r4oSmluUt263ax9U4blyuxFGckGmoxFxUnAgC4NQAnjwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 02:01 PM, Peter Zijlstra wrote:
> On Mon, Oct 20, 2014 at 10:16:35AM -0400, Theodore Ts'o wrote:
>> On Mon, Oct 20, 2014 at 04:09:30PM +0200, Daniel Borkmann wrote:
>>>>
>>>> It's triggering when input_rotate == 0, so UBSan complains about right shift in rol32()
>>>>
>>>> static inline __u32 rol32(__u32 word, unsigned int shift)
>>>> {
>>>> 	return (word << shift) | (word >> (32 - shift));
>>>> }
>>>
>>> So that would be the case when the entropy store's input_rotate calls
>>> _mix_pool_bytes() for the very first time ... I don't think it's an
>>> issue though.
>>
>> I'm sure it's not an issue, but it's still true that 
>>
>> 	return (word << 0) | (word >> 32);
>>
>> is technically not undefined, and while it would be unfortunate (and
>> highly unlikely) if gcc were to say, start nethack, it's technically
>> allowed by the C spec.  :-)
> 
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

E.g. on arm (i >> 32) == 0, so rol32() will also work as expected.
But what about other architectures?

