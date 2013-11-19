Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab3KSFYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:24:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43007 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab3KSFYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:24:01 -0500
Message-ID: <528AF5D7.7000308@zytor.com>
Date: Mon, 18 Nov 2013 21:23:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 04:27 PM, Andi Kleen wrote:
> 
> Proposed man page:
> 
> NAME
> 	text_poke - Safely modify running instructions (x86)
> 
> SYNOPSYS
> 	int text_poke(void *addr, const void *opcode, size_t len,
> 	              void (*handler)(void), int timeout);
> 
> DESCRIPTION
> 	The text_poke system allows to safely modify code that may
> 	be currently executing in parallel on other threads.
> 	Patch the instruction at addr with the new instructions
> 	at opcode of length len. The target instruction will temporarily
> 	be patched with a break point, before it is replaced
> 	with the final replacement instruction. When the break point
> 	hits the code handler will be called in the context
> 	of the thread. The handler does not save any registers
> 	and cannot return. Typically it would consist of the
> 	original instruction and then a jump to after the original
> 	instruction. The handler is only needed during the
> 	patching process and can be overwritten once the syscall
> 	returns. timeout defines an optional timout to indicate
> 	to the kernel how long the patching could be delayed.
> 	Right now it has to be 0.
> 

I think I would prefer an interface which took a list of patch points,
or implemented only the aspects which are impossible to do in user space.

All we really need in the kernel is the IPI broadcasts - the rest can be
done in user space, including intercepting SIGTRAP.  For userspace it is
probably the best to just put a thread to sleep until the patching is
done, which can be done with a futex.

One advantage with doing this in userspace is that the kernel doesn't
have to be responsible avoiding holding a thread due to a slightly
different SIGTRAP -- it will all come out after the signal handler is
restored, anyway.

That being said, the user space code would really need to be librarized.

	-hpa

