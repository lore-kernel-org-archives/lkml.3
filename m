Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaEUWls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:41:48 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:47490 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbaEUWlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:41:47 -0400
MIME-Version: 1.0
In-Reply-To: <537D2A6A.2@zytor.com>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <CALCETrUNWAU238xRZQ5zJwwQBArCHNzm=xsDBw4_LWGgGPjAuQ@mail.gmail.com> <537D2A6A.2@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 15:41:26 -0700
Message-ID: <CALCETrU-F_-p8yLRE+z0ULHTr8yhiet4owOW-1tuxT9TQFtTGQ@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 3:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/21/2014 11:11 AM, Andy Lutomirski wrote:
>> On Tue, May 20, 2014 at 5:53 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> Here's a real proposal for iret-less return.  If this is correct, then
>>> NMIs will never nest, which will probably delete a lot more scariness
>>> than is added by the code I'm describing.
>>
>> OK, here's a case where I'm wrong.  An NMI interrupts userspace on a
>> 16-bit stack.  The return from NMI goes through the espfix code.
>> Something interrupts while on the espfix stack.  Boom!  Neither return
>> style is particularly good.
>>
>> More generally, if we got interrupted while on the espfix stack, we
>> need to return back there using IRET.  Fortunately, re-enabling NMIs
>> there in harmless, since we've already switched off the NMI stack.
>>
>> This makes me think that maybe the logic should be turned around: have
>> some RIP ranges on which the kernel stack might be invalid (which
>> includes the espfix code and some of the syscall code) and use IRET
>> only on return from NMI, return to nonstandard CS, and return to these
>> special ranges.  The NMI code just needs to never so any of this stuff
>> unless it switches off the NMI stack first.
>>
>> For this to work reliably, we'll probably have to change CS before
>> calling into EFI code.  That should be straightforward.
>>
>
> I think you are onto something here.
>
> In particular, the key observation here is that inside the kernel, we
> can never *both* have an invalid stack *and* be inside an NMI, #MC or
> #DB handler, even if nested.

Except for espfix :)

>
> Now, does this prevent us from using RET in the common case?  I'm not
> sure it is a huge loss since kernel-to-kernel is relatively rare.

I don't think so.  The most common case should be plain old interrupts
and I suspect that #PF is a distant second.

In any event, plain old interrupts and #PF are non-IST interrupts and
they should be unconditionally safe for RET

--Andy
