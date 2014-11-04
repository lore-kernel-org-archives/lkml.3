Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaKDIlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:41:05 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:54992 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbaKDIlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:41:03 -0500
Message-ID: <545890F8.60909@st.com>
Date: Tue, 4 Nov 2014 09:40:24 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: <gong.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, <tytso@mit.edu>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <kernel@stlinux.com>, <eric.paire@st.com>
Subject: Re: [PATCH] bitops: Fix shift overflow in GENMASK macros
References: <1415036398-26984-1-git-send-email-maxime.coquelin@st.com> <20141104082901.GF10501@worktop.programming.kicks-ass.net>
In-Reply-To: <20141104082901.GF10501@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-04_04:2014-11-03,2014-11-04,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 11/04/2014 09:29 AM, Peter Zijlstra wrote:
> On Mon, Nov 03, 2014 at 06:39:58PM +0100, Maxime COQUELIN wrote:
>> On some 32 bits architectures, including x86, GENMASK(31, 0) returns 0
>> instead of the expected ~0UL.
>>
>> This is the same on some 64 bits architectures with GENMASK_ULL(63, 0).
>>
>> This is due to an overflow in the shift operand, 1 << 32 for GENMASK,
>> 1 << 64 for GENMASK_ULL.
>>
>> Fixes: 10ef6b0dffe404bcc54e94cb2ca1a5b18445a66b
>> Cc: <stable@vger.kernel.org> #v3.13+
>> Reported-by: Eric Paire <eric.paire@st.com>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>> ---
>>   include/linux/bitops.h | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
>> index be5fd38..81f9725 100644
>> --- a/include/linux/bitops.h
>> +++ b/include/linux/bitops.h
>> @@ -18,8 +18,12 @@
>>    * position @h. For example
>>    * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
>>    */
>> -#define GENMASK(h, l)		(((U32_C(1) << ((h) - (l) + 1)) - 1) << (l))
>> -#define GENMASK_ULL(h, l)	(((U64_C(1) << ((h) - (l) + 1)) - 1) << (l))
>> +#define GENMASK(h, l) \
>> +	((~0UL >> ((BITS_PER_LONG - 1) - (h))) & ~((1UL << (l)) - 1))
>> +
>> +#define GENMASK_ULL(h, l) \
>> +	((~0ULL >> ((BITS_PER_LONG_LONG - 1) - (h))) & ~((1ULL << (l)) - 1))
>> +
> I was not expecting the mask there, but instead something like:
>
> 	((~0UL >> (BITS_PER_LONG - (h-l+1))) << l)
>
> which shifts the bits to the desired length and then back to the desired
> place. Would that not be more readable?
>
Yes, this is indeed more readable.
I will send a v2 with your implementation.

Thanks,
Maxime


