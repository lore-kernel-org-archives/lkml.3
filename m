Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaCCT56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:57:58 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:41208 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaCCT54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:57:56 -0500
MIME-Version: 1.0
In-Reply-To: <20140303145110.0c09709c@gandalf.local.home>
References: <1393651938-16418-1-git-send-email-filbranden@google.com>
	<1393651938-16418-2-git-send-email-filbranden@google.com>
	<20140303145110.0c09709c@gandalf.local.home>
Date: Mon, 3 Mar 2014 11:57:55 -0800
Message-ID: <CADU+-uCP96f-B=c2Cy+Po2qNYnhTTROw5kDgJP3dZENjkxZUiQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] tracing: correctly expand len expressions from
 __dynamic_array macro
From: Filipe Brandenburger <filbranden@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizefan@huawei.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

I don't think this needs to be backported to stable, since the only
place that uses the high 16 bits of the offset field as the length is
filter_pred_strloc which only works for strings and sizeof(char) == 1
so that essentially whenever the bug is triggered, the actual stored
value is not used.

I have a follow up patch to expose that field to TP_fast_assign (as
something like __get_dynamic_array_length) in which case it's
important that this is fixed, otherwise for __dynamic_array of
something other than char we'll have a bug.

Thanks,
Filipe


On Mon, Mar 3, 2014 at 11:51 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 28 Feb 2014 21:32:16 -0800
> Filipe Brandenburger <filbranden@google.com> wrote:
>
>> This fixes expansion of the len argument in __dynamic_array macros.
>> The previous code from commit 7d536cb3f would not fully evaluate the
>> expression before multiplying its result by the size of the type.
>>
>> This went unnoticed because the length stored in the high 16 bits of the
>> offset (which is the one that was broken here) is only used by
>> filter_pred_strloc which only acts on strings for which the size of the
>> type is 1.
>>
>
> Was this visible in any of the tracepoints? Should this be marked for
> stable? It's been in the kernel for a long time (2009). Or is a new
> tracepoint showing a problem?
>
> -- Steve
>
>> Signed-off-by: Filipe Brandenburger <filbranden@google.com>
>> ---
>>  include/trace/ftrace.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
>> index 1a8b28d..82e8d89 100644
>> --- a/include/trace/ftrace.h
>> +++ b/include/trace/ftrace.h
>> @@ -375,7 +375,7 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call) \
>>  #define __dynamic_array(type, item, len)                             \
>>       __data_offsets->item = __data_size +                            \
>>                              offsetof(typeof(*entry), __data);        \
>> -     __data_offsets->item |= (len * sizeof(type)) << 16;             \
>> +     __data_offsets->item |= ((len) * sizeof(type)) << 16;           \
>>       __data_size += (len) * sizeof(type);
>>
>>  #undef __string
>
