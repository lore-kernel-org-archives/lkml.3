Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3KTQmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:42:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38031 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab3KTQmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:42:45 -0500
Message-ID: <528CE65B.6020300@zytor.com>
Date: Wed, 20 Nov 2013 08:42:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org> <528AF5D7.7000308@zytor.com> <20131119184959.GE29695@two.firstfloor.org>
In-Reply-To: <20131119184959.GE29695@two.firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 10:49 AM, Andi Kleen wrote:
> 
> We already have all the code. Why not just use it?
> 

We're talking user space here, which has different requirement (COW,
memory protection, ...) which means it is not really the same code.  You
can't take a page fault while patching the kernel.

> Note I'm not adding any new mechanism, just exporting the existing one.
> So the usual "do things in user space" arguments do not really
> apply here.
> 
> Also this is subtle enough that there is definitely benefit from
> having only a single canonical code that does it.
> 
> If we ever need any new errata workarounds for this they could be also
> all done in a single central place.
> 
>>
>> All we really need in the kernel is the IPI broadcasts - the rest can be
>> done in user space, including intercepting SIGTRAP.  For userspace it is
>> probably the best to just put a thread to sleep until the patching is
>> done, which can be done with a futex.
> 
> I'm not sure that's worth it. IPIs are reasonably fast (a few 1000s cycles).
> Sleeping likely only becomes beneficial with much longer delays, like
> ms. But if the IPIs start taking ms we have much more problems.

I'm referring to if some thread actually stumbles over INT 3, which is
indeed not very long for one patch site (as long as you don't end up
with page faults.)  However, for tracing, you may want to do tens of
thousands of patches, and you really want to batch them.

>> One advantage with doing this in userspace is that the kernel doesn't
>> have to be responsible avoiding holding a thread due to a slightly
>> different SIGTRAP -- it will all come out after the signal handler is
>> restored, anyway.
> 
> It's just some spinning, not a new task state. I don't think any
> task states make sense here.

I'd rather spin in user space, though.

	-hpa

