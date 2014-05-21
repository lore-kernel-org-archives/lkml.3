Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaEUXD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:03:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43147 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbaEUXD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:03:57 -0400
Message-ID: <537D30B1.9030407@zytor.com>
Date: Wed, 21 May 2014 16:03:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com> <CALCETrUNWAU238xRZQ5zJwwQBArCHNzm=xsDBw4_LWGgGPjAuQ@mail.gmail.com> <537D2A6A.2@zytor.com> <CALCETrU-F_-p8yLRE+z0ULHTr8yhiet4owOW-1tuxT9TQFtTGQ@mail.gmail.com>
In-Reply-To: <CALCETrU-F_-p8yLRE+z0ULHTr8yhiet4owOW-1tuxT9TQFtTGQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 03:41 PM, Andy Lutomirski wrote:
>>
>> I think you are onto something here.
>>
>> In particular, the key observation here is that inside the kernel, we
>> can never *both* have an invalid stack *and* be inside an NMI, #MC or
>> #DB handler, even if nested.
> 
> Except for espfix :)

Argh.  Yes, I got that wrong... it isn't really about being inside NMI,
#MC or #DB, but rather being on those respective stacks.  If you are on
the espfix stack you are on your way back to userspace OR (and this gets
really, really ugly) you took an NMI/MC/DB after a SYSCALL executed in
16-bit mode, but even then you are in the kernel entry/exit code and
re-enabling NMI is fine.

>> Now, does this prevent us from using RET in the common case?  I'm not
>> sure it is a huge loss since kernel-to-kernel is relatively rare.
> 
> I don't think so.  The most common case should be plain old interrupts
> and I suspect that #PF is a distant second.
> 
> In any event, plain old interrupts and #PF are non-IST interrupts and
> they should be unconditionally safe for RET

	-hpa


