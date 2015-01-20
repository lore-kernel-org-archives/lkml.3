Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbbATHsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:48:05 -0500
Received: from smtp.ispras.ru ([83.149.199.79]:54358 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbbATHsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:48:04 -0500
Message-ID: <54BE082A.20207@ispras.ru>
Date: Tue, 20 Jan 2015 10:47:54 +0300
From: Andrey Tsyvarev <tsyvarev@ispras.ru>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] kernel/module.c: Free lock-classes if parse_args failed
References: <1421216708-1975-1-git-send-email-tsyvarev@ispras.ru> <87iog2arfk.fsf@rustcorp.com.au>
In-Reply-To: <87iog2arfk.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

20.01.2015 9:37, Rusty Russell пишет:
> Andrey Tsyvarev <tsyvarev@ispras.ru> writes:
>> parse_args call module parameters' .set handlers, which may use locks defined in the module.
>> So, these classes should be freed in case parse_args returns error(e.g. due to incorrect parameter passed).
> Thanks, this seems right.  Applied.
>
> But this makes me ask: where is lockdep_free_key_range() called on the
> module init code?  It doesn't seem to be at all...
As I understand, locks are not allowed to be defined in the module init 
section. So, no needs to call lockdep_free_key_range() for it.
This has a sense: objects from that section are allowed to be used only 
by module->init() function. But a single function call doesn't require 
any synchronization wrt itself.


If it helps, I used module below for verify effect of the patch:

test.c:
---
#include <linux/module.h>
#include <linux/moduleparam.h>

MODULE_AUTHOR("Tsyvarev Andrey");
MODULE_LICENSE("GPL");

static DEFINE_MUTEX(mutex_main);
static DEFINE_MUTEX(mutex_param);

static int param_set(const char* val, const struct kernel_param* kp)
{
     mutex_lock(&mutex_param); //Use mutex defined in the module
     mutex_unlock(&mutex_param);

     return -EINVAL; // Setting this parameter is always invalid
}

static struct kernel_param_ops param_ops =
{
     .set = param_set
};

module_param_cb(param, &param_ops, NULL, S_IRUGO);

static int minit(void)
{
     mutex_lock(&mutex_main); // Use another mutex
     mutex_unlock(&mutex_main);
     return 0;
}

static void mexit(void)
{
}

module_init(minit);
module_exit(mexit);
--

insmod test.ko param=1 # Will fail
insmod test.ko

If kernel is compiled with CONFIG_LOCKDEP, then, without patch, lockdep 
crashes on the second module insertion.

>
> Confused,
> Rusty.
>
>> Signed-off-by: Andrey Tsyvarev <tsyvarev@ispras.ru>
>> ---
>>   kernel/module.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 3965511..2b44de4 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -3311,6 +3311,9 @@ static int load_module(struct load_info *info, const char __user *uargs,
>>   	module_bug_cleanup(mod);
>>   	mutex_unlock(&module_mutex);
>>   
>> +	/* Free lock-classes: */
>> +	lockdep_free_key_range(mod->module_core, mod->core_size);
>> +
>>   	/* we can't deallocate the module until we clear memory protection */
>>   	unset_module_init_ro_nx(mod);
>>   	unset_module_core_ro_nx(mod);
>> -- 
>> 1.8.3.1

-- 
Best regards,

Andrey Tsyvarev
Linux Verification Center, ISPRAS
web:http://linuxtesting.org

