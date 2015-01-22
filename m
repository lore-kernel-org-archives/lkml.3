Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbbAVJ2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:28:05 -0500
Received: from smtp.ispras.ru ([83.149.199.79]:37420 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbbAVJ1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:27:54 -0500
Message-ID: <54C0C294.30908@ispras.ru>
Date: Thu, 22 Jan 2015 12:27:48 +0300
From: Andrey Tsyvarev <tsyvarev@ispras.ru>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] kernel/module.c: Free lock-classes if parse_args failed
References: <1421216708-1975-1-git-send-email-tsyvarev@ispras.ru> <87iog2arfk.fsf@rustcorp.com.au> <54BE082A.20207@ispras.ru> <87d268c3mi.fsf@rustcorp.com.au> <54BF8439.2000905@ispras.ru> <87bnlrwsu9.fsf@rustcorp.com.au>
In-Reply-To: <87bnlrwsu9.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


22.01.2015 3:40, Rusty Russell пишет:
> Andrey Tsyvarev <tsyvarev@ispras.ru> writes:
>> 21.01.2015 4:40, Rusty Russell пишет:
>>> Andrey Tsyvarev <tsyvarev@ispras.ru> writes:
>>>> 20.01.2015 9:37, Rusty Russell пишет:
>>>>> Andrey Tsyvarev <tsyvarev@ispras.ru> writes:
>>>>>> parse_args call module parameters' .set handlers, which may use locks defined in the module.
>>>>>> So, these classes should be freed in case parse_args returns error(e.g. due to incorrect parameter passed).
>>>>> Thanks, this seems right.  Applied.
>>>>>
>>>>> But this makes me ask: where is lockdep_free_key_range() called on the
>>>>> module init code?  It doesn't seem to be at all...
>>>> As I understand, locks are not allowed to be defined in the module init
>>>> section. So, no needs to call lockdep_free_key_range() for it.
>>>> This has a sense: objects from that section are allowed to be used only
>>>> by module->init() function. But a single function call doesn't require
>>>> any synchronization wrt itself.
>>> I don't know that we have any __initdata locks; it would be really
>>> weird.
>>>
>>> But change 'static DEFINE_MUTEX(mutex_param);' to 'static __initdata
>>> DEFINE_MUTEX(mutex_param);' to test.
>> Compiler warns about sections mismatch, but the test works.
>>
>> According to lockdep_free_key_range() code, lock class is cleared not
>> only according to
>> its key(which is equal to lock address in the case of static lock) but
>> also according to its name.
> What happens if you later register another lock at that address, since
> the memory is freed?
Do you mean that scenario:

1) mutex1 is placed in module1 .init.data section,
2) after module1 is initialized, .init.data section is freed,
3) same memory is reused for module2 .data section,
4) mutex2 is placed in module2 .data section at the same address, as 
mutex1 was?

It seems, mutex2 will share lock class with mutex1. That is, lockdep 
will confused:

[kernel/locking/lockdep.c]
707                 if (class->key == key) {
708                         /*
709                          * Huh! same key, different name? Did 
someone trample
710                          * on some memory? We're most confused.
711                          */
712                         WARN_ON_ONCE(class->name != lock->name);
713                         return class;

Things will go worse, when

5) module1 is exited, and lock class for mutex1 will be cleared

because mutex2 will cache lock class which actually does not exist.

-- 
Best regards,

Andrey Tsyvarev
Linux Verification Center, ISPRAS
web:http://linuxtesting.org

