Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbbAVBFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:05:10 -0500
Received: from ozlabs.org ([103.22.144.67]:59789 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbbAVBFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:05:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrey Tsyvarev <tsyvarev@ispras.ru>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] kernel/module.c: Free lock-classes if parse_args failed
In-Reply-To: <54BF8439.2000905@ispras.ru>
References: <1421216708-1975-1-git-send-email-tsyvarev@ispras.ru> <87iog2arfk.fsf@rustcorp.com.au> <54BE082A.20207@ispras.ru> <87d268c3mi.fsf@rustcorp.com.au> <54BF8439.2000905@ispras.ru>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 22 Jan 2015 11:10:30 +1030
Message-ID: <87bnlrwsu9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Tsyvarev <tsyvarev@ispras.ru> writes:
> 21.01.2015 4:40, Rusty Russell пишет:
>> Andrey Tsyvarev <tsyvarev@ispras.ru> writes:
>>> 20.01.2015 9:37, Rusty Russell пишет:
>>>> Andrey Tsyvarev <tsyvarev@ispras.ru> writes:
>>>>> parse_args call module parameters' .set handlers, which may use locks defined in the module.
>>>>> So, these classes should be freed in case parse_args returns error(e.g. due to incorrect parameter passed).
>>>> Thanks, this seems right.  Applied.
>>>>
>>>> But this makes me ask: where is lockdep_free_key_range() called on the
>>>> module init code?  It doesn't seem to be at all...
>>> As I understand, locks are not allowed to be defined in the module init
>>> section. So, no needs to call lockdep_free_key_range() for it.
>>> This has a sense: objects from that section are allowed to be used only
>>> by module->init() function. But a single function call doesn't require
>>> any synchronization wrt itself.
>> I don't know that we have any __initdata locks; it would be really
>> weird.
>>
>> But change 'static DEFINE_MUTEX(mutex_param);' to 'static __initdata
>> DEFINE_MUTEX(mutex_param);' to test.
> Compiler warns about sections mismatch, but the test works.
>
> According to lockdep_free_key_range() code, lock class is cleared not 
> only according to
> its key(which is equal to lock address in the case of static lock) but 
> also according to its name.

What happens if you later register another lock at that address, since
the memory is freed?

A quick grep revealed no __initdata locks in the kernel, so I don't
think we care anyway.

Cheers,
Rusty.
