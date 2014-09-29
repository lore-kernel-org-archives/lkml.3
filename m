Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbaI2Tlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:41:31 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:54077 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaI2Tl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:41:29 -0400
Message-ID: <5429B5E4.6080302@fds-team.de>
Date: Mon, 29 Sep 2014 21:41:24 +0200
From: Sebastian Lackner <sebastian@fds-team.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Andy Lutomirski <luto@amacapital.net>, Anish Bhatt <anish@chelsio.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
References: <1411674171-24442-1-git-send-email-anish@chelsio.com> <54299979.6080705@amacapital.net> <5429A556.50507@fds-team.de> <alpine.DEB.2.02.1409292059530.22082@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1409292059530.22082@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.2014 21:33, Thomas Gleixner wrote:
> On Mon, 29 Sep 2014, Sebastian Lackner wrote:
>> On 29.09.2014 19:40, Andy Lutomirski wrote:
>> Well, the best documentation I've found is something like
>> http://www.fermimn.gov.it/linux/quarta/x86/int.htm
>>
>> which states:
>>
>> --- snip ---
>> INTERRUPT-TO-INNER-PRIVILEGE:
>>    [...]
>>    TF := 0;
>>    NT := 0;
>> --- snip ---
>> (Doesn't say anything about HW interrupts though)
>>
>> This also makes sense at my opinion, since the interrupt handler has
>> to know if it should return to the previous task (when NT=1) or to
>> the same task (when NT=0).
> 
> No, it does not. Simply because Linux does not support nested tasks at
> all, because the TSS is not accessible and the TSS.back_link is
> sturdily NULL. So even if it would not explode with a #GP in IA-32e
> mode it would explode while trying to execute the instruction at NULL.

Sure, I also mentioned this in my last mail:

On 29.09.2014 20:30, Sebastian Lackner wrote:
> NT flag would be interpreted as a task return, and it would probably cause a different exception,
> because the kernel never uses the task link property of the TSS.

> 
>> That might be possible. It probably makes sense to review other
>> parts of the code, for similar issues.
> 
> What's the issue? Stupid user space programs segfaulting?

I see several issues here:

* At first the behaviour is not consistent between several system call and return instructions. For example calling syscalls by using 'int' doesn't have this issue, as it clears the NT flag before entering kernel code. Return instructions also don't show this issue all the time, just when it hits one of the problematic pieces of code.

* The kernel might execute all kind of other code (for example inside of drivers) and start additional threads. I didn't find any good example yet, but its not that unlikely, that the exception can also happen in a completely unrelated thread, where the kernel can not just kill the corresponding usermode app...

I'm fine with all kind of solutions, either it should be allowed to set NT, or the kernel should at least throw a proper exception, so that usermode has a chance to catch and handle it. At the moment the segfault is deadly, as the segfault handler immediately segfaults again - no chance to recover from such an error.

Regards,
Sebastian

