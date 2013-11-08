Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab3KHTS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:18:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60897 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758014Ab3KHTS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:18:28 -0500
Message-ID: <527D38D5.7010408@zytor.com>
Date: Fri, 08 Nov 2013 11:17:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>, Joe Perches <joe@perches.com>
CC: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH v2 2/2] x86: add prefetching to do_csum
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com> <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com> <1383751399-10298-3-git-send-email-nhorman@tuxdriver.com> <20131106153429.GA26336@redhat.com> <20131106155445.GB6357@neilslaptop.think-freely.org> <1383758363.7940.19.camel@joe-AO722> <20131106200204.GB11415@hmsreliant.think-freely.org> <1383768458.7940.33.camel@joe-AO722> <20131108162502.GA16052@hmsreliant.think-freely.org> <1383929467.2639.14.camel@joe-AO722> <20131108190710.GC16052@hmsreliant.think-freely.org>
In-Reply-To: <20131108190710.GC16052@hmsreliant.think-freely.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 11:07 AM, Neil Horman wrote:
> On Fri, Nov 08, 2013 at 08:51:07AM -0800, Joe Perches wrote:
>> On Fri, 2013-11-08 at 11:25 -0500, Neil Horman wrote:
>>> On Wed, Nov 06, 2013 at 12:07:38PM -0800, Joe Perches wrote:
>>>> On Wed, 2013-11-06 at 15:02 -0500, Neil Horman wrote:
>>>>> On Wed, Nov 06, 2013 at 09:19:23AM -0800, Joe Perches wrote:
>>>> []
>>>>>> __always_inline instead of inline
>>>>>> static __always_inline void prefetch_lines(const void *addr, size_t len)
>>>>>> {
>>>>>> 	const void *end = addr + len;
>>>>>> ...
>>>>>>
>>>>>> buff doesn't need a void * cast in prefetch_lines
>>>>>>
>>>>> Actually I take back what I said here, we do need the cast, not for a conversion
>>>>> from unsigned char * to void *, but rather to discard the const qualifier
>>>>> without making the compiler complain.
>>>>
>>>> Not if the function is changed to const void *
>>>> and end is also const void * as shown.
>>>>
>>> Addr is incremented in the for loop, so it can't be const.  I could add a loop
>>> counter variable on the stack, but that doesn't seem like it would help anything
>>
>> Perhaps you meant
>> 	void * const addr;
>> but that's not what I wrote.
>>
> No, I meant smoething like:
> static __always_inline void prefetch_lines(const void * addr, size_t len)
> {
> 	const void *tmp = (void *)addr;
> 	...
> 	for(;tmp<end; tmp+=cache_line_size())
> 	...
> }
> 
>> Let me know if this doesn't compile.
>> It does here...
> Huh, it does.  But that makes very little sense to me.  by qualifying addr as
> const, how is the compiler not throwing a warning in the for loop about us
> incrementing that same variable?
> 

As Joe is pointing out, you are confusing "const foo *tmp" with "foo *
const tmp".  The former means: "tmp is a variable pointing to type const
foo".  The latter means: "tmp is a constant pointing to type foo".

There is no problem modifying tmp in the former case; it prohibits
modifying *tmp.  In the latter case modifying tmp is prohibited, but
modifying *tmp is just fine.

Now, "const char *" would arguably be more correct here since arithmetic
on void is a gcc extension, but the same argument applies there.

	-hpa


