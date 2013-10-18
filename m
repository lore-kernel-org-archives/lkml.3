Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3JRJt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 05:49:27 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:59871 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3JRJt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:49:26 -0400
MIME-Version: 1.0
In-Reply-To: <20131017224605.2e1d4bab@gandalf.local.home>
References: <1382060696-30746-1-git-send-email-geyslan@gmail.com>
	<20131017224605.2e1d4bab@gandalf.local.home>
Date: Fri, 18 Oct 2013 06:49:25 -0300
Message-ID: <CAGG-pURzhHWMHN8u4YKCNsc1UKyGJQC5tBfFhWNkrOC_o6zsJg@mail.gmail.com>
Subject: Re: [PATCH] tracing: fix referencing after memory freeing and
 refactors code
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-br <kernel-br@googlegroups.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/17 Steven Rostedt <rostedt@goodmis.org>:
> On Thu, 17 Oct 2013 22:44:56 -0300
> "Geyslan G. Bem" <geyslan@gmail.com> wrote:
>
>> Restructures function logic conditions testing 'tracing_open_generic'
>> return before the others. It avoids: unnecessary trace_array_get and
>> kzalloc when tracing is disabled; and fix the possible 'dir'
>> assignment after freeing it.
>>
>> Centralizes the exiting, ensuring the 'trace_array_put' on error,
>> in accordance to Coding Style, Chapter 7.
>>
>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>> ---
>>  kernel/trace/trace_events.c | 22 ++++++++++++----------
>>  1 file changed, 12 insertions(+), 10 deletions(-)
>>
>> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
>> index 368a4d5..8232362 100644
>> --- a/kernel/trace/trace_events.c
>> +++ b/kernel/trace/trace_events.c
>> @@ -1108,26 +1108,28 @@ static int system_tr_open(struct inode *inode, struct file *filp)
>>       struct trace_array *tr = inode->i_private;
>>       int ret;
>>
>> -     if (trace_array_get(tr) < 0)
>> -             return -ENODEV;
>> +     ret = tracing_open_generic(inode, filp);
>> +     if (ret)
>> +             return ret;
>> +
>> +     ret = trace_array_get(tr);
>> +     if (ret)
>> +             return ret;
>
> Hmm,
>
> I'm thinking of just nuking the tracing_open_generic() here. The only
> thing it does here is the tracing_disabled check. The assignment of
> inode->i_private to filp->private_data is pointless as it just
> reassigns it anyway.
>
> We could add a tracing_is_disabled() function to test instead.

Nice, I can do it.

Questions:

1267 static const struct file_operations ftrace_enable_fops = {
1268         .open = tracing_open_generic,
...
1286 static const struct file_operations ftrace_event_filter_fops = {
1287         .open = tracing_open_generic,
...
1317 static const struct file_operations ftrace_show_header_fops = {
1318         .open = tracing_open_generic,

Are that structures in same case? Their 'open' can be replaced to the
new 'tracing_is_disabled()?

I think that 'subsystem_open()' can be also refactored to use the
about to rise 'tracing_is_disabled()'. Am I right?
1096         ret = tracing_open_generic(inode, filp);

Regards,
-- Geyslan

>
> -- Steve
>
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
>> +err_dir:
>> +     trace_array_put(tr);
>>       return ret;
>>  }
>>
>
