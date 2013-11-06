Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab3KFUSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:18:34 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:38952 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab3KFUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:18:33 -0500
MIME-Version: 1.0
In-Reply-To: <20131106142028.6ff5a4f9@gandalf.local.home>
References: <1383764571-7318-1-git-send-email-geyslan@gmail.com>
	<20131106142028.6ff5a4f9@gandalf.local.home>
Date: Wed, 6 Nov 2013 18:18:32 -0200
Message-ID: <CAGG-pUSASKfQ35TJ4fKkkM0kUw7oi+qDkTVCRnpj336_k2GsJg@mail.gmail.com>
Subject: Re: [PATCH v2] tracing: fix referencing after memory freeing and
 refactors code
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-br <kernel-br@googlegroups.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/6 Steven Rostedt <rostedt@goodmis.org>:
> On Wed,  6 Nov 2013 16:02:51 -0300
> "Geyslan G. Bem" <geyslan@gmail.com> wrote:
>
>> In 'system_tr_open()':
>> Fix possible 'dir' assignment after freeing it.
>
> I'll take this patch, but I'm going to reword the subject and the
> change log. The assignment of dir to filp->private_data after dir is
> freed is not as bad as it sounds. As we are returning an error,
> filp->private_data is never used.
>
> -- Steve
>
>
Ok Steve. Please, do the reword.

>>
>> In both functions:
>> Restructures logic conditions testing 'tracing_is_disabled()'
>> return before the others tests.
>>
>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>> ---
>>  kernel/trace/trace_events.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
>> index 368a4d5..b44a7ea 100644
>> --- a/kernel/trace/trace_events.c
>> +++ b/kernel/trace/trace_events.c
>> @@ -1062,6 +1062,9 @@ static int subsystem_open(struct inode *inode, struct file *filp)
>>       struct trace_array *tr;
>>       int ret;
>>
>> +     if (tracing_is_disabled())
>> +             return -ENODEV;
>> +
>>       /* Make sure the system still exists */
>>       mutex_lock(&trace_types_lock);
>>       mutex_lock(&event_mutex);
>> @@ -1108,6 +1111,9 @@ static int system_tr_open(struct inode *inode, struct file *filp)
>>       struct trace_array *tr = inode->i_private;
>>       int ret;
>>
>> +     if (tracing_is_disabled())
>> +             return -ENODEV;
>> +
>>       if (trace_array_get(tr) < 0)
>>               return -ENODEV;
>>
>> @@ -1124,11 +1130,12 @@ static int system_tr_open(struct inode *inode, struct file *filp)
>>       if (ret < 0) {
>>               trace_array_put(tr);
>>               kfree(dir);
>> +             return ret;
>>       }
>>
>>       filp->private_data = dir;
>>
>> -     return ret;
>> +     return 0;
>>  }
>>
>>  static int subsystem_release(struct inode *inode, struct file *file)
>



-- 
Regards,

Geyslan G. Bem
hackingbits.com
