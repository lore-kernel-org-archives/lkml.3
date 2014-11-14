Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161962AbaKNUy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:54:28 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:50633 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635AbaKNUy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:54:26 -0500
MIME-Version: 1.0
In-Reply-To: <1415985728.5912.17.camel@perches.com>
References: <1415969446-26356-1-git-send-email-a.ryabinin@samsung.com>
	<1415969446-26356-2-git-send-email-a.ryabinin@samsung.com>
	<1415985728.5912.17.camel@perches.com>
Date: Sat, 15 Nov 2014 00:54:24 +0400
Message-ID: <CAPAsAGwCJqBeoQRb5AwNdkFDRLvqk8WhE3tKcAYXWs5W_r-fDA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kernel: printk: specify alignment for struct printk_log
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>, Michal Marek <mmarek@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yury Gribov <y.gribov@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>, linux-doc@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-14 20:22 GMT+03:00 Joe Perches <joe@perches.com>:
> On Fri, 2014-11-14 at 15:50 +0300, Andrey Ryabinin wrote:
>> On architectures that have support for efficient unaligned access
>> struct printk_log has 4-byte alignment.
>> Specify alignment attribute in type declaration.
>>
>> The whole point of this patch is to fix deadlock which happening
>> when UBSan detects unaligned access in printk() thus UBSan recursively
>> calls printk() with logbuf_lock held by top printk() call.
> []
>> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> []
>> @@ -223,7 +223,11 @@ struct printk_log {
>>       u8 facility;            /* syslog facility */
>>       u8 flags:5;             /* internal record flags */
>>       u8 level:3;             /* syslog level */
>> -};
>> +}
>> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>> +__packed __aligned(4)
>> +#endif
>
> Why is adding __packed useful or __aligned(4) useful?
>

On x86_64, from compiler's point of view, 'struct printk_log' should
be 8-byte aligned.
But it stored in log buffer only with 4-byte alignment (LOG_ALIGN define).

This inconsistency makes UBSAN unhappy.  UBSAN uses printk to report errors,
thus any access to 4-byte aligned 'struct printk_log' causing
recursive printk() call from ubsan handler.
And if logbuf_lock was taken we end up with deadlock.
Specifying alignment removes this inconsistency. Now compiler knows
that 'printk_log'
actually aligned on 4, and it makes UBSAN happy and silent.

Attribute 'aligned' without attribute 'packed' can only increase alignment.
So __packed is used here because we need to decrease alignment from 8 to 4.


> The struct is naturally aligned on u64 and should be

Not, always. On 32-bits it will be 4-bytes aligned, on 64-bits - 8-bytes aligned

> the size of 2 u64s.
>
> struct printk_log {
>         u64 ts_nsec;            /* timestamp in nanoseconds */
>         u16 len;                /* length of entire record */
>         u16 text_len;           /* length of text buffer */
>         u16 dict_len;           /* length of dictionary buffer */
>         u8 facility;            /* syslog facility */
>         u8 flags:5;             /* internal record flags */
>         u8 level:3;             /* syslog level */
> };
>
> Is there any case when it's not sizeof(u64) * 2?
>

I think no. As I said __packed used for decreasing alignment only.
