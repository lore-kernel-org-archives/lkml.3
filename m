Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750858Ab3FVFIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 01:08:20 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:59497 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3FVFIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 01:08:19 -0400
MIME-Version: 1.0
In-Reply-To: <1371846146.18733.126.camel@gandalf.local.home>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
	<dd9d5f3d3781d1074bf554a473d49648dc79b359.1371751701.git.tom.zanussi@linux.intel.com>
	<51C3F866.4080705@huawei.com>
	<1371846146.18733.126.camel@gandalf.local.home>
Date: Sat, 22 Jun 2013 13:08:18 +0800
Message-ID: <CACV3sbJcgQbLdjypvRPL3cU+cki5bzinpnyy2ESmS5mLPvPVHA@mail.gmail.com>
Subject: Re: [PATCH 03/11] tracing: add soft disable for syscall events
From: Jovi Zhang <bookjovi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        masami.hiramatsu.pt@hitachi.com, LKML <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 4:22 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2013-06-21 at 14:53 +0800, zhangwei(Jovi) wrote:
>> On 2013/6/21 2:31, Tom Zanussi wrote:
>> > Add support for SOFT_DISABLE to syscall events.
>> >
>> > The original SOFT_DISABLE patches didn't add support for soft disable
>> > of syscall events; this adds it and paves the way for future patches
>> > allowing triggers to be added to syscall events, since triggers are
>> > built on top of SOFT_DISABLE.
>> >
>> > Because the trigger and SOFT_DISABLE bits are attached to the
>> > ftrace_event_file associated with the event, pointers to the
>> > ftrace_event_files associated with the event are added to the syscall
>> > metadata entry for the event.
>> >
>> > Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
>> > ---
>> >  include/linux/syscalls.h      |  2 ++
>> >  include/trace/syscall.h       |  5 +++++
>> >  kernel/trace/trace_syscalls.c | 28 ++++++++++++++++++++++++----
>> >  3 files changed, 31 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>> > index 4147d70..b4c2afa 100644
>> > --- a/include/linux/syscalls.h
>> > +++ b/include/linux/syscalls.h
>> > @@ -158,6 +158,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>> >             .args           = nb ? args_##sname : NULL,     \
>> >             .enter_event    = &event_enter_##sname,         \
>> >             .exit_event     = &event_exit_##sname,          \
>> > +           .enter_file     = NULL, /* Filled in at boot */ \
>> > +           .exit_file      = NULL, /* Filled in at boot */ \
>> >             .enter_fields   = LIST_HEAD_INIT(__syscall_meta_##sname.enter_fields), \
>> >     };                                                      \
>> >     static struct syscall_metadata __used                   \
>> > diff --git a/include/trace/syscall.h b/include/trace/syscall.h
>> > index fed853f..ba24d3a 100644
>> > --- a/include/trace/syscall.h
>> > +++ b/include/trace/syscall.h
>> > @@ -19,6 +19,8 @@
>> >   * @enter_fields: list of fields for syscall_enter trace event
>> >   * @enter_event: associated syscall_enter trace event
>> >   * @exit_event: associated syscall_exit trace event
>> > + * @enter_file: associated syscall_enter ftrace event file
>> > + * @exit_file: associated syscall_exit ftrace event file
>> >   */
>> >  struct syscall_metadata {
>> >     const char      *name;
>> > @@ -30,6 +32,9 @@ struct syscall_metadata {
>> >
>> >     struct ftrace_event_call *enter_event;
>> >     struct ftrace_event_call *exit_event;
>> > +
>> > +   struct ftrace_event_file *enter_file;
>> > +   struct ftrace_event_file *exit_file;
>> >  };
>>
>> I doubt this could work correctly.
>> struct ftrace_event_file is allocated dynamically, there could
>> have many ftrace_event_file in there, associated with different trace_array,
>> it means there may have many ftrace_event_file linked with same syscall_metadata.
>>
>> The enter_file/exit_file pointer of syscall_metadata will be override if another
>> ftrace_event_file registered in some other trace_array.
>>
>> Perhaps we could use simple list_head in here, which link with all registered ftrace_event_file.
>>
>> Oleg use "struct event_file_link" for trace_kprobe, the structure could be reuse in here.
>>
>>
>> struct event_file_link {
>>       struct ftrace_event_file        *file;
>>       struct list_head                list;
>> };
>>
>> struct syscall_metadata {
>>         const char      *name;
>>         int             syscall_nr;
>>         int             nb_args;
>>         const char      **types;
>>         const char      **args;
>>         struct list_head enter_fields;
>>
>>         struct ftrace_event_call *enter_event;
>>         struct ftrace_event_call *exit_event;
>>
>>       struct list_head        enter_files;
>>       struct list_head        exit_files;
>> };
>>
>
>
> I would really like to make these smaller. They are made for every
> system call, and I consider tracing to always be added overhead. I hate
> it when we waste more memory for tracing as very few people use it
> (compared to those that use Linux).
>
> Is it possible to allocate this only when its first used?
>
> -- Steve

I think the answer is yes.

Compare with link ftrace_event_file with static syscall_metadata, another option
is put into structure trace_array, just like enabled_enter_syscalls and
enabled_exit_syscalls BITMAP already in there
(need change to dynamic allocated NR_syscalls array, just keep a
pointer in trace_array).

Then in this way, there don't have any extra size overhead for static
syscall_metadata,
but need to allocate a array with NR_syscalls elements when first use
syscall tracing.

which option do you prefer? steven.

.jovi
