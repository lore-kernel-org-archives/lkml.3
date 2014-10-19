Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaJSMRk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 08:17:40 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:46648 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaJSMRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 08:17:39 -0400
MIME-Version: 1.0
In-Reply-To: <87mw8sctrb.fsf@openvz.org>
References: <1408539282-5699-1-git-send-email-dmonakhov@openvz.org>
	<1408539282-5699-2-git-send-email-dmonakhov@openvz.org>
	<CAC5umyjaE6HimXyBc52jMvGYM3OgQCX1aOhQxtZ90j+9vfGnSg@mail.gmail.com>
	<87ppfvqlcu.fsf@openvz.org>
	<87mw8sctrb.fsf@openvz.org>
Date: Sun, 19 Oct 2014 21:17:37 +0900
Message-ID: <CAC5umyhQK8e8oCJg3SJ0D0RA67++v2iRP8PFei0763q9=Wgj3Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] fault-inject: add ratelimit option
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

2014-10-19 18:07 GMT+09:00 Dmitry Monakhov <dmonakhov@openvz.org>:
> Dmitry Monakhov <dmonakhov@openvz.org> writes:
> Ping.

Could you resend this series with CCing Andrew for asking -mm tree
inclusion?

>> On Wed, 20 Aug 2014 23:20:18 +0900, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>>> This looks a bit redundant.  NULL pointer to "%pd" format produces
>>> "(null)" string, so this printk and if-else can be removed.
>>>
>>> Also, this message line is a bit longer than usual kernel message.
>>> Should we put '\n' after "forcing a failure."?
>>>
>>> This patch looks good to me.  Please feel free to add my ACK.
>> Ok. Here is updated version.
>> From d06acefdd4da0d590e6dc0b1351e7adefad98fc7 Mon Sep 17 00:00:00 2001
>> From: Dmitry Monakhov <dmonakhov@openvz.org>
>> Date: Wed, 20 Aug 2014 18:31:06 +0400
>> Subject: [PATCH] fault-inject: add ratelimit option  v2
>>
>> Current debug levels are not optimal. Especially if one want to
>> provoke big numbers of faults(broken device simulator) then any verbose
>> level will produce giant numbers of identical logging messages.
>> Let's add ratelimit parameter for that purpose.
>>
>> Change-log:
>> - Dump fault_attr configuration on minimal verbose level.
>> - Add name to fault_attr
>> - Add ratelimit parameter
>>
>> Example:
>>   # Limit verbosity to one at 5 seconds
>>   echo 1 > /sys/kernel/debug/fail_make_request/verbose_ratelimit_burst
>>   echo 5000 > /sys/kernel/debug/fail_make_request/verbose_ratelimit_interval_ms
>>
>>   # dump only once in a day
>>   echo 1 > /sys/kernel/debug/fail_make_request/verbose_ratelimit_burst
>>   echo $((24 * 60 * 60* 1000)) > /sys/kernel/debug/fail_make_request/verbose_ratelimit_interval_ms
>>
>> Acked-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>>  include/linux/fault-inject.h |   17 +++++++++++------
>>  lib/fault-inject.c           |   21 +++++++++++++++++----
>>  2 files changed, 28 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
>> index c6f996f..798fad9 100644
>> --- a/include/linux/fault-inject.h
>> +++ b/include/linux/fault-inject.h
>> @@ -5,6 +5,7 @@
>>
>>  #include <linux/types.h>
>>  #include <linux/debugfs.h>
>> +#include <linux/ratelimit.h>
>>  #include <linux/atomic.h>
>>
>>  /*
>> @@ -25,14 +26,18 @@ struct fault_attr {
>>       unsigned long reject_end;
>>
>>       unsigned long count;
>> +     struct ratelimit_state ratelimit_state;
>> +     struct dentry *dname;
>>  };
>>
>> -#define FAULT_ATTR_INITIALIZER {                             \
>> -             .interval = 1,                                  \
>> -             .times = ATOMIC_INIT(1),                        \
>> -             .require_end = ULONG_MAX,                       \
>> -             .stacktrace_depth = 32,                         \
>> -             .verbose = 2,                                   \
>> +#define FAULT_ATTR_INITIALIZER {                                     \
>> +             .interval = 1,                                          \
>> +             .times = ATOMIC_INIT(1),                                \
>> +             .require_end = ULONG_MAX,                               \
>> +             .stacktrace_depth = 32,                                 \
>> +             .ratelimit_state = RATELIMIT_STATE_INIT_DISABLED,       \
>> +             .verbose = 2,                                           \
>> +             .dname = NULL,                                          \
>>       }
>>
>>  #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
>> diff --git a/lib/fault-inject.c b/lib/fault-inject.c
>> index d7d501e..f1cdeb0 100644
>> --- a/lib/fault-inject.c
>> +++ b/lib/fault-inject.c
>> @@ -40,10 +40,16 @@ EXPORT_SYMBOL_GPL(setup_fault_attr);
>>
>>  static void fail_dump(struct fault_attr *attr)
>>  {
>> -     if (attr->verbose > 0)
>> -             printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure\n");
>> -     if (attr->verbose > 1)
>> -             dump_stack();
>> +     if (attr->verbose > 0 && __ratelimit(&attr->ratelimit_state)) {
>> +             printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure.\n"
>> +                    "name %pd, interval %lu, probability %lu, "
>> +                    "space %d, times %d\n", attr->dname,
>> +                    attr->probability, attr->interval,
>> +                    atomic_read(&attr->space),
>> +                    atomic_read(&attr->times));
>> +             if (attr->verbose > 1)
>> +                     dump_stack();
>> +     }
>>  }
>>
>>  #define atomic_dec_not_zero(v)               atomic_add_unless((v), -1, 0)
>> @@ -202,6 +208,12 @@ struct dentry *fault_create_debugfs_attr(const char *name,
>>               goto fail;
>>       if (!debugfs_create_ul("verbose", mode, dir, &attr->verbose))
>>               goto fail;
>> +     if (!debugfs_create_u32("verbose_ratelimit_interval_ms", mode, dir,
>> +                             &attr->ratelimit_state.interval))
>> +             goto fail;
>> +     if (!debugfs_create_u32("verbose_ratelimit_burst", mode, dir,
>> +                             &attr->ratelimit_state.burst))
>> +             goto fail;
>>       if (!debugfs_create_bool("task-filter", mode, dir, &attr->task_filter))
>>               goto fail;
>>
>> @@ -222,6 +234,7 @@ struct dentry *fault_create_debugfs_attr(const char *name,
>>
>>  #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
>>
>> +     attr->dname = dget(dir);
>>       return dir;
>>  fail:
>>       debugfs_remove_recursive(dir);
>> --
>> 1.7.1
