Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaEAWGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:06:31 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:64393 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaEAWGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:06:30 -0400
MIME-Version: 1.0
In-Reply-To: <5362C37E.2090603@zytor.com>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
 <1398723161-21968-5-git-send-email-andi@firstfloor.org> <535FED4D.5000703@amacapital.net>
 <20140429233950.GE2382@two.firstfloor.org> <53608180.5070800@zytor.com>
 <CALCETrVQiZPb1M183Fq61dbFAjnJScuB2y+rdH8BQ+yp-MO+Mw@mail.gmail.com>
 <20140501211554.GH2382@two.firstfloor.org> <5362C37E.2090603@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 1 May 2014 15:06:09 -0700
Message-ID: <CALCETrV=8NBb+VfmYwzh+YhjLAO_XsCszG-W2QR-BK2dWDjfYg@mail.gmail.com>
Subject: Re: [PATCH 4/7] x86: Add support for rd/wr fs/gs base
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 2:58 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/01/2014 02:15 PM, Andi Kleen wrote:
>>> If usergs == kernelgs, then ebx will always be 1 and we'll never end
>>> up in paranoid_userspace.
>>
>> You may miss a reschedule in this obscure case. It shouldn't really
>> happen because loading a kernel pointer is not useful for user space.
>>
>> Doesn't seem like a real issue to me.
>>
>> We only happen need to handle it to avoid crashing.
>>
>
> No, it would be a rootable security hole, not just a crash.
>
>>> Alternatively, what if the paranoid entry checked whether we're coming
>>> from userspace at the very beginning and, if so, just jumped to the
>>> non-paranoid entry?
>>
>> That would work, but I doubt it would be worth it.
>
> If that would solve the problem it is simple enough, but the tricky part
> is when we end up in a "crack" where we are in kernel mode with the user GS.
>
> I haven't looked through the flows (I'm at LCE so I have limited screen
> bandwidth) to see how that would be handled in this case, but in the
> general paranoid case it comes down to the fact that in this particular
> subcase we don't necessarily know exactly how many SWAPGS are between us
> and userspace after we IRET.

The current code looks like it will never try to reschedule on
paranoid exit unless it came from user *CS*, in which case there
shouldn't be any weird gs issues.  Given that the current code won't
reschedule even on a paranoid entry that hits during interruptable
kernel code, I find it unlikely that this code is important.  You
probably know more about its history and significance than I do.

What happens when ftrace or perf tries to wake a task from a debug
interrupt or NMI?

--Andy
