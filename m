Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab3GBCVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 22:21:36 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:54298 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3GBCVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 22:21:35 -0400
MIME-Version: 1.0
In-Reply-To: <1372728304.22688.32.camel@gandalf.local.home>
References: <1372717885-4543-1-git-send-email-azl@google.com>
 <1372717885-4543-3-git-send-email-azl@google.com> <1372728304.22688.32.camel@gandalf.local.home>
From: Alexander Lam <azl@google.com>
Date: Mon, 1 Jul 2013 19:21:14 -0700
Message-ID: <CANiYik6aYAEB74qrkL_3Sq_tk7crKsYW5xa-Qxe7pGJB2fLRxw@mail.gmail.com>
Subject: Re: [PATCH 3/3] tracing: Protect ftrace_trace_arrays list in trace_events.c
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, sorry, that is an incomplete patch; some bits are in a patch I
dropped. I'll send you a new one in about 20 minutes.

- Alex

On Mon, Jul 1, 2013 at 6:25 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2013-07-01 at 15:31 -0700, Alexander Z Lam wrote:
>> There are multiple places where the ftrace_trace_arrays list is accessed in
>> trace_events.c without the trace_types_lock held.
>
> Hmm, doesn't compile. Not a complete patch? trace_types_lock is local to
> trace.c, and needs to be in trace.h and non static.
>
> -- Steve
>
>>
>> Cc: David Sharp <dhsharp@google.com>
>> Cc: Alexander Z Lam <lambchop468@gmail.com>
>> Signed-off-by: Alexander Z Lam <azl@google.com>
>> ---
>>  kernel/trace/trace_events.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
>> index 6db3290..26351cc 100644
>> --- a/kernel/trace/trace_events.c
>> +++ b/kernel/trace/trace_events.c
>> @@ -1586,6 +1586,7 @@ static void __add_event_to_tracers(struct ftrace_event_call *call,
>>  int trace_add_event_call(struct ftrace_event_call *call)
>>  {
>>       int ret;
>> +     mutex_lock(&trace_types_lock);
>>       mutex_lock(&event_mutex);
>>
>>       ret = __register_event(call, NULL);
>> @@ -1593,11 +1594,13 @@ int trace_add_event_call(struct ftrace_event_call *call)
>>               __add_event_to_tracers(call, NULL);
>>
>>       mutex_unlock(&event_mutex);
>> +     mutex_unlock(&trace_types_lock);
>>       return ret;
>>  }
>>
>>  /*
>> - * Must be called under locking both of event_mutex and trace_event_sem.
>> + * Must be called under locking of trace_types_lock, event_mutex and
>> + * trace_event_sem.
>>   */
>>  static void __trace_remove_event_call(struct ftrace_event_call *call)
>>  {
>> @@ -1609,11 +1612,13 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
>>  /* Remove an event_call */
>>  void trace_remove_event_call(struct ftrace_event_call *call)
>>  {
>> +     mutex_lock(&trace_types_lock);
>>       mutex_lock(&event_mutex);
>>       down_write(&trace_event_sem);
>>       __trace_remove_event_call(call);
>>       up_write(&trace_event_sem);
>>       mutex_unlock(&event_mutex);
>> +     mutex_unlock(&trace_types_lock);
>>  }
>>
>>  #define for_each_event(event, start, end)                    \
>> @@ -1757,6 +1762,7 @@ static int trace_module_notify(struct notifier_block *self,
>>  {
>>       struct module *mod = data;
>>
>> +     mutex_lock(&trace_types_lock);
>>       mutex_lock(&event_mutex);
>>       switch (val) {
>>       case MODULE_STATE_COMING:
>> @@ -1767,6 +1773,7 @@ static int trace_module_notify(struct notifier_block *self,
>>               break;
>>       }
>>       mutex_unlock(&event_mutex);
>> +     mutex_unlock(&trace_types_lock);
>>
>>       return 0;
>>  }
>
>
