Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaHOQlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:41:22 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54009 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaHOQlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:41:21 -0400
Message-ID: <53EE3826.2040000@gmail.com>
Date: Sat, 16 Aug 2014 00:41:10 +0800
From: "zhaoxiu.zeng" <zhaoxiu.zeng@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        George Spelvin <linux@horizon.com>,
        David Howells <dhowells@redhat.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] GCD: add binary GCD algorithm
References: <1408106956-12986-1-git-send-email-zhaoxiu.zeng@gmail.com> <20140815135855.GG19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140815135855.GG19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2014/8/15 21:58, Peter Zijlstra 写道:
> On Fri, Aug 15, 2014 at 08:49:16PM +0800, Zhaoxiu Zeng wrote:
>> Because some architectures (alpha, armv6, etc.) don't provide hardware division,
>> the mod operation is slow! Binary GCD algorithm uses simple arithmetic operations,
>> it replaces division with arithmetic shifts, comparisons, and subtraction.
>>
>> Signed-off-by: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
>> ---
>>  lib/Kconfig | 15 +++++++++++++++
>>  lib/gcd.c   | 31 ++++++++++++++++++++++++++++++-
>>  2 files changed, 45 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/Kconfig b/lib/Kconfig
>> index a5ce0c7..80e8e54 100644
>> --- a/lib/Kconfig
>> +++ b/lib/Kconfig
>> @@ -177,6 +177,21 @@ config CRC8
>>  	  when they need to do cyclic redundancy check according CRC8
>>  	  algorithm. Module will be called crc8.
>>  
>> +#
>> +# GCD
>> +#
>> +choice
>> +	prompt "GCD implementation"
>> +	default GCD_ALGO_EUCLIDEAN
>> +
>> +config GCD_ALGO_EUCLIDEAN
>> +	bool "Euclidean algorithm"
>> +
>> +config GCD_ALGO_BINARY
>> +	bool "Binary GCD algorithm (Stein's algorithm)"
>> +
>> +endchoice
> 
> Does this result in the user being asked which GCD algo he wants? If so,
> I think that's bad.
> 

For the architecture which doesn't provide hardware division, "GCD_ALGO_BINARY"
can be selected in arch/???/Kconfig.

> 
>> +#else
>> +	r = a | b;
>> +
>> +	if (!a || !b)
>> +		return r;
>> +
>> +	r = r ^ (r - 1);
>> +	if (!(a & r))
>> +		goto even_odd; /* a/c even, b/c odd */
>> +	if (!(b & r))
>> +		goto odd_even; /* a/c odd, b/c even */
>> +
>> +	/* a/c and b/c both odd */
>> +	while (a != b) {
>> +		if (a > b) {
>> +			a -= b;
>> +even_odd:
>> +			do
>> +				a >>= 1;
>> +			while (!(a & r));
>> +		} else {
>> +			b -= a;
>> +odd_even:
>> +			do
>> +				b >>= 1;
>> +			while (!(b & r));
>> +		}
>> +	}
>> +#endif
>>  	return b;
>>  }
> 
> So I looked at wikipedia (I wasn't aware of this algorithm, clever
> though), and am still somewhat puzzled by your 'r'.
> 
> What's 'wrong' with their iterative version, or what's better about your
> 'r' stuff?
> 

If use "r = (r & -r)" to replace "r = r ^ (r - 1)", the function works fine too.
"r = (r & -r)" get the lsb of (a | b), it's the largest power of 2 that divides
a and b. Using r not 1, can avoid pre-shift right and post-shift left.

The result of "r = r ^ (r - 1)" equal to "lsb | (lsb - 1)". 
Using "r = r ^ (r - 1)" because it requires fewer instructions than "r = (r & -r)"
on some architectures.

