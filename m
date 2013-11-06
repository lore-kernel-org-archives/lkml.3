Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab3KFTIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:08:52 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:51237 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3KFTIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:08:49 -0500
MIME-Version: 1.0
In-Reply-To: <20131106111732.5f4593f5@gandalf.local.home>
References: <1382129982-9668-1-git-send-email-geyslan@gmail.com>
	<1382129982-9668-2-git-send-email-geyslan@gmail.com>
	<20131106111732.5f4593f5@gandalf.local.home>
Date: Wed, 6 Nov 2013 17:08:46 -0200
Message-ID: <CAGG-pUS0uKBxe8xfVEK=TgfE-oY+BxH+wKZGBup9T7w9TBOo9Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] tracing: fix referencing after memory freeing and
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
> Sorry for the late review, I was busy getting ready for kernel summit
> and then traveling too much.
>
No problem.

>
> On Fri, 18 Oct 2013 17:59:42 -0300
> "Geyslan G. Bem" <geyslan@gmail.com> wrote:
>
>> In 'system_tr_open()':
>> Fix possible 'dir' assignment after freeing it.
>>
>> In both functions:
>> Restructures logic conditions testing 'tracing_is_disabled()'
>> return before the others tests.
>> Centralizes the exiting in accordance to Coding Style, Chapter 7.
>>
>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>> ---
>>  kernel/trace/trace_events.c | 46 +++++++++++++++++++++++----------------------
>>  1 file changed, 24 insertions(+), 22 deletions(-)
>>
>> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
>> index 368a4d5..0f56ebf 100644
>> --- a/kernel/trace/trace_events.c
>> +++ b/kernel/trace/trace_events.c
>> @@ -1060,7 +1060,10 @@ static int subsystem_open(struct inode *inode, struct file *filp)
>>       struct event_subsystem *system = NULL;
>>       struct ftrace_subsystem_dir *dir = NULL; /* Initialize for gcc */
>>       struct trace_array *tr;
>> -     int ret;
>> +     int ret = -ENODEV;
>> +
>> +     if (tracing_is_disabled())
>> +             return ret;
>>
>>       /* Make sure the system still exists */
>>       mutex_lock(&trace_types_lock);
>> @@ -1082,23 +1085,21 @@ static int subsystem_open(struct inode *inode, struct file *filp)
>>       mutex_unlock(&trace_types_lock);
>>
>>       if (!system)
>> -             return -ENODEV;
>> +             return ret;
>>
>>       /* Some versions of gcc think dir can be uninitialized here */
>>       WARN_ON(!dir);
>>
>>       /* Still need to increment the ref count of the system */
>> -     if (trace_array_get(tr) < 0) {
>> -             put_system(dir);
>> -             return -ENODEV;
>> -     }
>> +     ret = trace_array_get(tr);
>> +     if (ret)
>> +             goto err_get;
>>
>> -     ret = tracing_open_generic(inode, filp);
>> -     if (ret < 0) {
>> -             trace_array_put(tr);
>> -             put_system(dir);
>> -     }
>> +     filp->private_data = dir;
>> +     return 0;
>>
>> +err_get:
>> +     put_system(dir);
>>       return ret;
>
> I don't see any improvement in the above code, except for the initial
> check of tracing_is_disabled(). Just add:
>
>         if (tracing_is_disabled())
>                 return -ENODEV;
>
> no need for all the fancy work with using ret and goto.
>
>
>>  }
>>
>> @@ -1106,28 +1107,29 @@ static int system_tr_open(struct inode *inode, struct file *filp)
>>  {
>>       struct ftrace_subsystem_dir *dir;
>>       struct trace_array *tr = inode->i_private;
>> -     int ret;
>> +     int ret = -ENODEV;
>>
>> -     if (trace_array_get(tr) < 0)
>> -             return -ENODEV;
>> +     if (tracing_is_disabled())
>> +             return ret;
>> +
>> +     ret = trace_array_get(tr);
>> +     if (ret)
>> +             return ret;
>>
>>       /* Make a temporary dir that has no system but points to tr */
>>       dir = kzalloc(sizeof(*dir), GFP_KERNEL);
>>       if (!dir) {
>> -             trace_array_put(tr);
>> -             return -ENOMEM;
>> +             ret = -ENOMEM;
>> +             goto err_dir;
>>       }
>>
>>       dir->tr = tr;
>>
>> -     ret = tracing_open_generic(inode, filp);
>> -     if (ret < 0) {
>> -             trace_array_put(tr);
>> -             kfree(dir);
>> -     }
>> -
>>       filp->private_data = dir;
>> +     return 0;
>>
>
> Again, we don't need the goto and err_dir. The simple fix is to finish
> the function with:
>
>         ret = tracing_open_generic(inode, filp);
>         if (ret < 0) {
>                 trace_array_put(tr);
>                 kfree(dir);
>                 return ret;
>         }
>
>         filp->private_data = dir;
>
>         return 0;
>
> -- Steve
>
>> +err_dir:
>> +     trace_array_put(tr);
>>       return ret;
>>  }
>>
>

Done:
[PATCH v2] tracing: fix referencing after memory freeing and refactors code


-- 
Regards,

Geyslan G. Bem
hackingbits.com
