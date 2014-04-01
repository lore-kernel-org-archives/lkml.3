Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaDAUok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:44:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36303 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaDAUoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:44:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140401185241.GA29884@redhat.com>
References: <1396288478-1314-1-git-send-email-mdempsky@chromium.org>
 <20140331181651.GA27686@redhat.com> <CAF52+S5i7oqJnJ1NN0bk5Vg=CiYrussw0AunteE72kMMcWkeJA@mail.gmail.com>
 <20140401185241.GA29884@redhat.com>
From: Matthew Dempsky <mdempsky@chromium.org>
Date: Tue, 1 Apr 2014 13:44:15 -0700
X-Google-Sender-Auth: cbjKqu4ZE687laAZqZVJyRQh8-E
Message-ID: <CAF52+S6Y40K-sRPf4YAb8ceAmtgBzZ9OUbyhPTOc_AcOWuQ=Ng@mail.gmail.com>
Subject: Re: [PATCH v2] Fix ptrace events across pid namespaces
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 11:52 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Sorry for slow response,

No worries!

>> But how can I guard against current->parent disappearing?  Do I need
>> to grab a read lock on the tasklist and rcu?
>
> rcu_read_lock() should be enough.

Noted.

> The main question is how we can ensure that we use the correct namespace,
> iow, how we can ensure that current->parent won't change after this.
>
> Suppose that debugger detaches right after we calculated pid_t we were
> going to report.
>
> Now suppose that another task from the different namespace does
> ptrace(PTRACE_SEIZE, PTRACE_O_TRACEFORK). Or PTRACE_O_TRACEVFORKDONE.
>
> In this case ptrace_event() will still report the wrong pid. I simply do
> not see how we can prevent this race without the really ugly complications.

Yeah, the 'best' alternative I can think of is to save the "struct pid
*" instead of a pid_t in the ptrace_message field, and then have
PTRACE_GETEVENTMSG handle translating it into a pid_t (similar to what
SCM_CREDENTIALS does)... but that seems very messy and intrusive for
such an unlikely situation (because we need extra bits to distinguish
the contents of ptrace_message and to free up references).

> But perhaps we do not really care? The race is very unlikely, and nothing
> really bad can happen. So perhaps your simple patch makes sense anyway,
> just the problem should be documented. Currently "nr" is always wrong if
> the tracer is from another ns, this change will obviously makes the things
> better in any case.

Yeah, I'm leaning towards just accepting that the ptrace event message
might be wrong in this case, and documenting that.  It's at least no
worse than the status quo where it's wrong in all cases.  I'll
followup with a v3 patch for this in a bit.

>> Basically, if process A is being ptraced by process B and we record an
>> event for it, I don't want process B to detach and then process C to
>> attach and be able to still view the event.
>
> Aha, so I got it right. But see above, this won't help anyway, C can
> attach before ptrace_event() sets ->ptrace_message.
>
> Perhaps this change makes sense anyway. I think it needs a separate patch
> but I won't insist.
>
>> > Probably this is related to detach/attach, but then it would be better
>> > to do this in PTRACE_ATTACH. Because ->ptrace_message can be non-zero
>> > if, say, a traced task forks.
>>
>> I think zeroing out ptrace_message at attach time works too, and I can
>> do it that way if you prefer.
>
> I do not really mind. But once again, unless we clear it in PTRACE_ATTACH,
> PTRACE_GETEVENTMSG still can return non-zero right after PTRACE_ATTACH.
> Of course we can change copy_process() to clear child->ptrace_message,
> but I don't think this would be better.

I think I'll punt on zero'ing ptrace_message for now and propose that
as a followup patch then.  I think it's a really narrow and unlikely
issue (like the detach/attach race above), and I don't want to
distract from the more pressing matter of getting debugging working.
:)

> Matthew, I just noticed we discuss this off-list, I added lkml.

Thanks!
