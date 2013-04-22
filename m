Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab3DVMGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:06:03 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:33635 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3DVMGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:06:01 -0400
MIME-Version: 1.0
In-Reply-To: <1366630759.4077.6.camel@laptop>
References: <1366377044-23989-1-git-send-email-vincent.guittot@linaro.org>
	<1366623052.2721.6.camel@laptop>
	<CAKfTPtBMG6KPSZsMFnJqEAajg2qjRXowKSfrWHED-EhUCLB2+Q@mail.gmail.com>
	<1366630759.4077.6.camel@laptop>
Date: Mon, 22 Apr 2013 14:05:59 +0200
Message-ID: <CAKfTPtCO6JGDkqivtPfWZfxpTGxDZz5J3uQpJ6H4bGuBRgEMmQ@mail.gmail.com>
Subject: Re: [PATCH v6] sched: fix init NOHZ_IDLE flag
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 April 2013 13:39, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2013-04-22 at 13:01 +0200, Vincent Guittot wrote:
>> > I'm not quite getting things.. what's wrong with adding this flags
>> > thing to sched_domain itself? That's already RCU destroyed so why
>> add a
>> > second RCU layer?
>>
>> We need one flags for all sched_domain so if we add it into
>> sched_domain struct, we have to define which one will handle the flags
>> for all other and find it in the sched_domain tree when we need it.
>
> Just pick rq->sd -- if the root_domain thing doesn't work out.
>
>>  In
>> addition, the flags in other sched_domain will be a waste of space.
>> The RCU in sched_domain might become useless as it is protected by the
>> one that is in sched_domain_rq
>
> I'm all for wasting space instead over adding extra pointer chasing all
> over the place. But also, look at pahole -C sched_domain, there's
> plenty of 4 byte holes in there where we can stuff a single bit.

Ok, I'm going to move the flags in sched_domain struct.
This should make the fix simpler

>
>> > We also have the root_domain for things that don't need to go in a
>> > hierarchy but are once per cpu -- it sounds like this is one of
>> those
>> > things; iirc the root_domain life-time is the same as the entire
>> > sched_domain tree so adding it to the root_domain is also an option.
>>
>> AFAICT, it doesn't share the same RCU object and as a result the same
>> lifecycle than sched_domain so there is a time window where
>> sched_domain and flags could lost their synchronization.
>> Nevertheless, i'm going to have a look at root_domain
>
> They're set under the same write side lock at the same time rq->sd it
> set, but yes I suppose that since its a separate pointer there might be
> a tiny window where we could go wrong.
>
