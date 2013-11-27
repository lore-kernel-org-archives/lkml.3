Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab3K0X2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:28:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53846 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab3K0X2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:28:52 -0500
Message-ID: <52968018.5090907@zytor.com>
Date: Wed, 27 Nov 2013 15:28:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>	<5294F10C.8060901@amacapital.net>	<CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com>	<52964EC7.9000504@zytor.com>	<52966C0A.7070201@zytor.com>	<CA+55aFzr9ZKcGfT_Q31T9_vuCcmWxGCh0wixuZqt7VhjxxYU9g@mail.gmail.com>	<529677D7.9080203@zytor.com> <CA+55aFx9mXy3VASfek5052GTbiUVSgBVsRwnF4cse1dc=z70HQ@mail.gmail.com>
In-Reply-To: <CA+55aFx9mXy3VASfek5052GTbiUVSgBVsRwnF4cse1dc=z70HQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 03:15 PM, Linus Torvalds wrote:
> 
> Oh, I agree. The interface of the original patch was just inane/insane.
> 
> The timeout and the callback is pointless. The only thing the system
> call should get as an argument is the address and the replacement
> instruction.  So
> 
>   int text_poke(void *addr, const void *opcode, size_t len)
> 
> sounds fine to me. And it would do:
>  - take some (possibly per-mm) mutex
>  - write the one-byte int3
>  - do the IPI
>  - write the other bytes
>  - do the IPI
>  - do the first byte
>  - release the (possibly per-mm) mutex
> 
> and then in the BP handler we'd just take the mutex, see if the first
> byte of the exception is still int3, if it's not, just return silently
> (because that means that we hit the race).
> 

I was going to say we can just re-execute the instruction until it goes
away, but this is unsafe for user space since you might have CD 03
(INT 3) somewhere instead of CC (INT3) and backing up to the previous
byte would be bad in the former case.

Even if matched against patch sites it would be iffy.

> Hmm? It doesn't sound too bad. And I really don't see the point of
> some timeout handling or anything like that.

The timeout bit was an acknowledgment that some kind of batching
interface is necessary.  If you are doing this for function tracing, for
example, you can easily have a hundred thousand patch sites or more, and
you may not want to have to go through this process anew for each single
site.  Hence my earlier comment about feeling that we would need a
batched interface of some sort.  Which, unfortunately, has its own set
of problems relating to restartability and potential delay.

	-hpa


