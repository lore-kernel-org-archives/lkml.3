Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaEUWjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:39:37 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:47564 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbaEUWjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:39:35 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3281198D@ORSMSX114.amr.corp.intel.com>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home> <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
 <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz> <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com>
 <20140521163315.GJ21205@pd.tnic> <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
 <CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com>
 <20140521214845.GG25130@pd.tnic> <CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F328116D8@ORSMSX114.amr.corp.intel.com>
 <CALCETrWA1X-X7W7MZn5eYEO-hxWWYk3APORmH-1dw=5ua1dG+A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3281189E@ORSMSX114.amr.corp.intel.com>
 <CALCETrXMe_rvKBcZpGhodXO1WY44WHSyZM8OKQG-AXm=X0kMrw@mail.gmail.com> <3908561D78D1C84285E8C5FCA982C28F3281198D@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 15:39:11 -0700
Message-ID: <CALCETrXxEAwJ33bF7FeRLeCbE7BfMn==OsFsoorW_NWFLxwuew@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 3:32 PM, Luck, Tony <tony.luck@intel.com> wrote:
>>> The recovery path has to do more than just send a signal - it needs to walk processes and
>>> "mm"s to see which have mapped the physical address that the h/w told us has gone bad.
>>
>> I still feel like I'm missing something.  If we interrupted user space
>> code, then the context we're in should be identical to the context
>> we'll get when we're about to return to userspace.
>
> True. And this far along in do_machine_check() we have set all the other cpus
> free, so the are heading back to whatever context we interrupted them in. So
> we might be able to do all that other stuff inline here ... we interrupted user
> mode, so we know we don't hold any locks. Other cpus are running, so they can
> complete what they are doing to release any locks we might need.
>
> But it will take a while (to scan all those processes). And we haven't yet
> cleared MCG_STATUS ... so another machine check before we do that
> would be fatal (x86 doesn't allow nesting).  Even if we moved the work
> after the clear of MCG_STATUS we'd still be vulnerable to a new machine
> check on x86_64 because we are sitting on the one & only machine check
> stack.

But if we get a new MCE in here, it will be an MCE from kernel context
and it's fatal.  So, yes, we'll clobber the stack, but we'll never
return (unless tolerant is set to something insane), so who cares?

Anyway, I care less about this now that I don't have to worry about it
re: IRET :)

--Andy
