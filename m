Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3KKTnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:43:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47958 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3KKTm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:42:57 -0500
Message-ID: <52813334.2040405@zytor.com>
Date: Mon, 11 Nov 2013 11:42:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
References: <1381450698-28710-4-git-send-email-keescook@chromium.org>	<tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org>	<20131111182046.GA14961@gmail.com>	<52812F92.1020006@zytor.com> <CAGXu5j+66dfv_048iDp+ZAv4_sS4si9cHG-8L_4zJ1OHHLxaUw@mail.gmail.com>
In-Reply-To: <CAGXu5j+66dfv_048iDp+ZAv4_sS4si9cHG-8L_4zJ1OHHLxaUw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 11:37 AM, Kees Cook wrote:
> On Mon, Nov 11, 2013 at 11:27 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 11/11/2013 10:20 AM, Ingo Molnar wrote:
>>>
>>> Why aren't the 3 sources of entropy XOR-ed together?
>>
>> Note we don't want to poke i8254 if we have any other sources, as the
>> i8254 may not be present on newer systems and in some other cases not
>> safe to touch.  We can XOR in the TSC with RDRAND although it seems a
>> bit odd.
> 
> I await the final decision! :)
> 

Use the i8254 if and only if nothing else is available, it isn't safe to
touch on some newer systems.

>> HOWEVER...
>>
>> +               /* Only use the low bits of rdtsc. */
>> +               random = raw & 0xffff;
>>
>> Why?!  All that can do is throw away randomness...
> 
> Due to the 2GiB addressing and 2MiB alignment, we can never use more
> than 10 bits of entropy at maximum. The existing patches only use 9
> bits (due to page table layouts) on 64-bit and 8 bits on 32-bit.

The point is that you are already doing that masking somewhere else, it
is just odd.

>> +       /* Extend timer bits poorly... */
>> +       random |= (random << 16);
>> +#ifdef CONFIG_X86_64
>> +       random |= (random << 32);
>> +#endif
> 
> I did this so that any portion of the returned value could be used for
> the 10 bit mask.

Why?  It is standard practice to only use the low bits, and in light of
the above it is even more bizarre.  However, doing a circular multiply
might still spread in some additional entropy at least in the case of a
kexec boot on a non-RDRAND system.

>> For smearing out bits, a better way is usually to multiply with a large
>> prime number (preferably a circular multiply.)
> 
> This shouldn't be needed since we're only using the low 10 bits.

None of the above is needed in that case, although a spreading multiply
will make it less likely that you are throwing away the highest entropy
bits.

> How would you like to see this function updated to make that more
> clear? More comments?

	-hpa


