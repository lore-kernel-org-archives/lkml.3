Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3K0F2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 00:28:12 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:54997 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab3K0F2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 00:28:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAHb8M2A5h==bu76m1AitY3G6gaTrTdL+VMUw9XUWTC5HB4=79Q@mail.gmail.com>
References: <2547094.3YTvOEEdct@daeseok-laptop>
	<87y54attlw.fsf@xmission.com>
	<CAHb8M2A5h==bu76m1AitY3G6gaTrTdL+VMUw9XUWTC5HB4=79Q@mail.gmail.com>
Date: Wed, 27 Nov 2013 14:28:06 +0900
Message-ID: <CAHb8M2DQzr7YB67az1Awgx-nMHiTTbuGuaf0EusAi1+7P_0New@mail.gmail.com>
Subject: Re: [PATCH] kernel/fork.c : remove local 'oldmm' and retval
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, oleg <oleg@redhat.com>,
        viro <viro@zeniv.linux.org.uk>, luto <luto@amacapital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry.
my e-mail was rejected by vger.kernel.org server.
resend my e-mail.

2013/11/27 DaeSeok Youn <daeseok.youn@gmail.com>
>
> Thank you for reviewing my patch.
>
> I am a newbie who want to know kernel source deeply. :)
>
> I agree your comments but I want to explain my patch why it is sent.
>
> I think "ENOMEM" is enough to explain to fail by dup_mm().
> So I replace the goto line to "return -ENOMEM" in if(!mm).
>
> And I think oldmm doesn't use any meaning control in copy_mm(),
> so re-use local 'mm' variable. If the source has less comprehensible,
> how about adding a comment like 'parent and child share address space'
> above "mm = current->mm" in my patch.
>
> just my opinion, let me know if i am wrong.
> Actually I need to learn about kernel source code.
>
> Thanks.
> Daeseok Youn.
>
>
>
> 2013/11/27 Eric W. Biederman <ebiederm@xmission.com>
>
>> Daeseok Youn <daeseok.youn@gmail.com> writes:
>>
>> > From cec2f201f0dc99a33a58d9d1e0452140bb0993a1 Mon Sep 17 00:00:00 2001
>> > From: Daeseok Youn <daeseok.youn@lge.com>
>> > Date: Wed, 27 Nov 2013 09:54:41 +0900
>> > Subject: [PATCH] kernel/fork.c : remove local 'oldmm' and retval
>> >
>> >  Local oldmm is used only for increaing mm_users field
>> >  in current->mm. When clone_flags have a CLONE_VM flag,
>> >  current->mm is assigning to local 'mm'.
>> >  Local retval is used only for returning -ENOMEM value.
>> >  When dup_mm() is failed, just return -ENOMEM.
>>
>> You are making the generated code worse, and the source less
>> comprehensible.
>>
>> You are adding additional exit points making it harder to analyze the
>> function.
>>
>> You are introducing races and expense by not caching current->mm in
>> oldmm.
>>
>> This looks like code churn for no good reason, and that will result in
>> worse code.
>>
>> ick.
>>
>> Eric
>>
>> >  Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> > ---
>> >  kernel/fork.c |   16 +++++-----------
>> >  1 file changed, 5 insertions(+), 11 deletions(-)
>> >
>> > diff --git a/kernel/fork.c b/kernel/fork.c
>> > index 728d5be..022a0af 100644
>> > --- a/kernel/fork.c
>> > +++ b/kernel/fork.c
>> > @@ -857,8 +857,7 @@ fail_nocontext:
>> >
>> >  static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
>> >  {
>> > -     struct mm_struct *mm, *oldmm;
>> > -     int retval;
>> > +     struct mm_struct *mm;
>> >
>> >       tsk->min_flt = tsk->maj_flt = 0;
>> >       tsk->nvcsw = tsk->nivcsw = 0;
>> > @@ -874,28 +873,23 @@ static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
>> >        *
>> >        * We need to steal a active VM for that..
>> >        */
>> > -     oldmm = current->mm;
>> > -     if (!oldmm)
>> > +     if (!current->mm)
>> >               return 0;
>> >
>> >       if (clone_flags & CLONE_VM) {
>> > -             atomic_inc(&oldmm->mm_users);
>> > -             mm = oldmm;
>> > +             mm = current->mm;
>> > +             atomic_inc(&mm->mm_users);
>> >               goto good_mm;
>> >       }
>> >
>> > -     retval = -ENOMEM;
>> >       mm = dup_mm(tsk);
>> >       if (!mm)
>> > -             goto fail_nomem;
>> > +             return -ENOMEM;
>> >
>> >  good_mm:
>> >       tsk->mm = mm;
>> >       tsk->active_mm = mm;
>> >       return 0;
>> > -
>> > -fail_nomem:
>> > -     return retval;
>> >  }
>> >
>> >  static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
>
>
