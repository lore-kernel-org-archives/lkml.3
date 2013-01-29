Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3A2CN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:13:56 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:50843 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3A2CNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:13:50 -0500
MIME-Version: 1.0
In-Reply-To: <20130128125023.GA2027@linaro.org>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
	<1359132254.21576.230.camel@gandalf.local.home>
	<20130125165934.GE2069@linaro.org>
	<201301260045.28804.arnd@arndb.de>
	<CA+KhAHYJus7+LsVhNa4RcxfpeTBtV=_vf2YDACtoMujo5c6tXA@mail.gmail.com>
	<20130128125023.GA2027@linaro.org>
Date: Tue, 29 Jan 2013 11:13:49 +0900
Message-ID: <CA+KhAHYvbxANa84FMDVV96udwhif2P2_XirPhWVWTKy_8iK72A@mail.gmail.com>
Subject: Re: [PATCH 19/19] [INCOMPLETE] ARM: make return_address available for ARM_UNWIND
From: Keun-O Park <kpark3469@gmail.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Steven Rostedt <rostedt@goodmis.org>,
        sahara <keun-o.park@windriver.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 9:50 PM, Dave Martin <dave.martin@linaro.org> wrote:
> On Mon, Jan 28, 2013 at 11:33:11AM +0900, Keun-O Park wrote:
>> Hello guys,
>>
>> Could you please review the patch of fixing bug first of returning
>> wrong address when using frame pointer?
>> I am wondering if the first patch is not delivered to the mailing.
>
> I posted a similar patch to alkml a couple of months ago, but I got
> no response and it looks like I forgot about it.
>
> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/129381.html

Yes, same except initialization of data.addr. :)
This means there might be no one interested in using
ftrace-irqsoff/premptoff in ARM during a couple of months?


>
> [...]
>
>>
>> ~~~~~~~~~~~~~~~~~~~~~snip~~~~~~~~~~~~~~~~~~~~~~~~~
>> From 3a60b536d22a2043d735c890a9aac9e7cb72de8f Mon Sep 17 00:00:00 2001
>> From: sahara <keun-o.park@windriver.com>
>> Date: Thu, 3 Jan 2013 17:12:37 +0900
>> Subject: [PATCH 1/2] arm: fix returning wrong CALLER_ADDRx
>>
>> This makes return_address return correct value for ftrace feature.
>> unwind_frame does not update frame->lr but frame->pc for backtrace.
>> And, the initialization for data.addr was missing so that wrong value
>> returned when unwind_frame failed.
>>
>> Signed-off-by: sahara <keun-o.park@windriver.com>
>> ---
>>  arch/arm/kernel/return_address.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/kernel/return_address.c b/arch/arm/kernel/return_address.c
>> index 8085417..fafedd8 100644
>> --- a/arch/arm/kernel/return_address.c
>> +++ b/arch/arm/kernel/return_address.c
>> @@ -26,7 +26,7 @@ static int save_return_addr(struct stackframe *frame, void *d)
>>         struct return_address_data *data = d;
>>
>>         if (!data->level) {
>> -               data->addr = (void *)frame->lr;
>> +               data->addr = (void *)frame->pc;
>>
>>                 return 1;
>>         } else {
>> @@ -41,7 +41,8 @@ void *return_address(unsigned int level)
>>         struct stackframe frame;
>>         register unsigned long current_sp asm ("sp");
>>
>> -       data.level = level + 1;
>> +       data.level = level + 2;
>> +       data.addr = NULL;
>
> Can you explain why this is needed?  I think I concluded it wasn't
> necessary, but you may be right -- I think if walk_stackframe()
> fails to unwind the next frame just after data.level reaches zero,
> then data.addr can remain unset and return_address() may return
> uninitialised garbage.

That's correct.
Here is the examples of reproducing the problem.
I added one line printk for test in wakeup_flusher_threads() in
fs/fs-writeback.c.
And then after boot up, I synced.

[TEST#1 : print CALLER_ADDR0, 1 and 2]
Without initialization of data.addr:
~ # sync
TEST: CALLER_ADDR0=(sys_sync+0x34/0xac),
CALLER_ADDR1=(ret_fast_syscall+0x0/0x48),
CALLER_ADDR2=(ret_fast_syscall+0x0/0x48)
With initialization of data.addr:
~ # sync
TEST: CALLER_ADDR0=(sys_sync+0x34/0xac),
CALLER_ADDR1=(ret_fast_syscall+0x0/0x48), CALLER_ADDR2=(  (null))

[TEST#2 : print CALLER_ADDR0 and 2]
Without initialization of data.addr:
~ # sync
TEST: CALLER_ADDR0=(sys_sync+0x34/0xac), CALLER_ADDR2=(0x872fffb0)
With initialization of data.addr:
~ # sync
TEST: CALLER_ADDR0=(sys_sync+0x34/0xac), CALLER_ADDR2=((null))

As you see, when unwind_fame() fails right after data.level reaches zero,
the routine returns data.addr which has uninitialized garbage value.

-- kpark
