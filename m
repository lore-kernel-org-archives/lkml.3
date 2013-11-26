Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab3KZOcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:32:46 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:35797 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab3KZOco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:32:44 -0500
MIME-Version: 1.0
In-Reply-To: <20131126075859.2060f6fd@gandalf.local.home>
References: <CAGdX0WFeEuy+DtpsJzyzn0343qEEjLX97+o1VREFkUEhndC+5Q@mail.gmail.com>
	<20131126075859.2060f6fd@gandalf.local.home>
Date: Tue, 26 Nov 2013 07:32:43 -0700
Message-ID: <CAKocOOOMEsUCux27f7S1k7ecanfzXoNnP5319zgnGWMhqOimiQ@mail.gmail.com>
Subject: Re: [BUG] 3.13-rc1 kernel crash when enable all tracepoints
From: Shuah Khan <shuahkhan@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I sent in a patch to fix it. You can try the patch out if you like,

https://lkml.org/lkml/2013/11/22/337

thanks,
-- Shuah

On Tue, Nov 26, 2013 at 5:58 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 26 Nov 2013 12:38:53 +0800
> Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
>
>> Hi,
>>
>> I'm not sure this issue already be fixed or not, it can be reproduced
>> permanently.
>>
>> (I didn't use git-bisect yet, you guys might can understand it quickly)
>>
>> #echo 1 > /sys/kernel/debug/tracing/events/enable
>>
>> [  160.472176] BUG: unable to handle kernel NULL pointer dereference
>> at           (null)
>> [  160.472176] IP: [<ffffffff8132ae40>] strlen+0x0/0x30
>
> I hit this bug last night when testing a fix for another bug. I have a
> patch for this too, and will send it out after I put it through my
> tests.
>
> You can try it out.
>
> -- Steve
>
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 52594b2..bdac88c 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -372,7 +372,8 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)   \
>         __data_size += (len) * sizeof(type);
>
>  #undef __string
> -#define __string(item, src) __dynamic_array(char, item, strlen(src) + 1)
> +#define __string(item, src) __dynamic_array(char, item,                        \
> +                                   strlen((src) ? (src) : "(null)") + 1)
>
>  #undef DECLARE_EVENT_CLASS
>  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print) \
> @@ -501,7 +502,7 @@ static inline notrace int ftrace_get_offsets_##call(                        \
>
>  #undef __assign_str
>  #define __assign_str(dst, src)                                         \
> -       strcpy(__get_str(dst), src);
> +       strcpy(__get_str(dst), (src) ? (src) : "(null)");
>
>  #undef TP_fast_assign
>  #define TP_fast_assign(args...) args
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
