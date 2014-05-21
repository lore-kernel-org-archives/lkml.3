Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaEUWhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:37:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42924 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbaEUWhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:37:21 -0400
Message-ID: <537D2A6A.2@zytor.com>
Date: Wed, 21 May 2014 15:36:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com> <CALCETrUNWAU238xRZQ5zJwwQBArCHNzm=xsDBw4_LWGgGPjAuQ@mail.gmail.com>
In-Reply-To: <CALCETrUNWAU238xRZQ5zJwwQBArCHNzm=xsDBw4_LWGgGPjAuQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 11:11 AM, Andy Lutomirski wrote:
> On Tue, May 20, 2014 at 5:53 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> Here's a real proposal for iret-less return.  If this is correct, then
>> NMIs will never nest, which will probably delete a lot more scariness
>> than is added by the code I'm describing.
> 
> OK, here's a case where I'm wrong.  An NMI interrupts userspace on a
> 16-bit stack.  The return from NMI goes through the espfix code.
> Something interrupts while on the espfix stack.  Boom!  Neither return
> style is particularly good.
> 
> More generally, if we got interrupted while on the espfix stack, we
> need to return back there using IRET.  Fortunately, re-enabling NMIs
> there in harmless, since we've already switched off the NMI stack.
> 
> This makes me think that maybe the logic should be turned around: have
> some RIP ranges on which the kernel stack might be invalid (which
> includes the espfix code and some of the syscall code) and use IRET
> only on return from NMI, return to nonstandard CS, and return to these
> special ranges.  The NMI code just needs to never so any of this stuff
> unless it switches off the NMI stack first.
> 
> For this to work reliably, we'll probably have to change CS before
> calling into EFI code.  That should be straightforward.
> 

I think you are onto something here.

In particular, the key observation here is that inside the kernel, we
can never *both* have an invalid stack *and* be inside an NMI, #MC or
#DB handler, even if nested.

Now, does this prevent us from using RET in the common case?  I'm not
sure it is a huge loss since kernel-to-kernel is relatively rare.

	-hpa

