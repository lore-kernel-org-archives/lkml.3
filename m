Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaJTOK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:10:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbaJTOKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:10:22 -0400
Message-ID: <5445179A.4080804@redhat.com>
Date: Mon, 20 Oct 2014 16:09:30 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: drivers: random: Shift out-of-bounds in _mix_pool_bytes
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com> <5444EBFA.5030103@samsung.com> <20141020124929.GA23177@thunk.org> <54451501.2070700@samsung.com>
In-Reply-To: <54451501.2070700@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 03:58 PM, Andrey Ryabinin wrote:
> On 10/20/2014 04:49 PM, Theodore Ts'o wrote:
>> On Mon, Oct 20, 2014 at 03:03:22PM +0400, Andrey Ryabinin wrote:
>>> Hi, Theodore.
>>>
>>> I've got this while booting kernel with ubsan:
>>>
>>>      [    0.000000] ================================================================================
>>>      [    0.000000] UBSan: Undefined behaviour in ../include/linux/bitops.h:107:33
>>>      [    0.000000] shift exponent 32 is to large for 32-bit type 'unsigned int'
>>        ...
>>>      [    0.000000] _mix_pool_bytes (/home/andrew/linux/ubsan_x86//include/linux/bitopsh:107 /home/andrew/linux/ubsan_x86//drivers/char/randomc:509)
>>
>> So this doesn't make any sense to me.   This is triggering here:
>>
>> 	w = rol32(*bytes++, input_rotate);
>>
>> .... but input_rotate should never be >= 32, since it is set this way:
>>
>
> It's triggering when input_rotate == 0, so UBSan complains about right shift in rol32()
>
> static inline __u32 rol32(__u32 word, unsigned int shift)
> {
> 	return (word << shift) | (word >> (32 - shift));
> }

So that would be the case when the entropy store's input_rotate calls
_mix_pool_bytes() for the very first time ... I don't think it's an
issue though.
