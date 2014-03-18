Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbaCROpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:45:07 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63169 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaCROpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:45:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140318140504.GD23193@laptop.programming.kicks-ass.net>
References: <1395148208-2209-1-git-send-email-bergwolf@gmail.com>
 <20140318133331.GA23193@laptop.programming.kicks-ass.net> <CA+a=Yy74V9_N4L8DoG=6iLnjGyOb6=ifraAqs5jW7ZsCG0t7jw@mail.gmail.com>
 <20140318140504.GD23193@laptop.programming.kicks-ass.net>
From: Peng Tao <bergwolf@gmail.com>
Date: Tue, 18 Mar 2014 22:44:43 +0800
Message-ID: <CA+a=Yy567xtU0Osz+9-hTCNrzB65vE=ErYWTq880N+uEwG2DHA@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: introduce add_wait_queue_exclusive_head
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 10:05 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Mar 18, 2014 at 09:51:04PM +0800, Peng Tao wrote:
>> > Firstly I think the _head postfix for LIFO is a bad name,
>> Do you have any preference on the name? add_wait_queue_exclusive_lifo()?
>
> I think we can avoid the entire function if we add
> WQ_FLAG_LIFO and make prepare_to_wait_event() DTRT.
>
> Then we only need to teach ___wait() about this; and I suppose we could
> make .exclusive=-1 be the LIFO flag.
>
> Unless you cannot use ___wait() and really need to open-code the
> wait_event() stuff.
>
Lustre's private l_wait_event() stuff takes care to (un)mask
LUSTRE_FATAL_SIGS and always wait in TASK_INTERRUPTIBLE state.

It looks to me that we can at least wrap l_wait_event() on top of
wait_event_interruptible/wait_event_timeout_interruptible.

Andreas, any opinions? Was l_wait_event added just for cross platform
support or is there some deeper reason that I missed?

Thanks,
Tao

>> > If you don't mix exclusive and !exclusive tasks on the same waitqueue
>> > this isn't a problem, but I'm sure people will eventually do this and
>> > get a nasty surprise.
>> >
>> Yes, Lustre takes care not to mix exclusive and !exclusive tasks in this case.
>
> Right; I saw you had a comment to that effect after I wrote this email.
>
>> > I'm not sure what the best way around this would be; but I can see two
>> > options:
>> >
>> >  - add enough debugging bits to detect this fail case.
>> >  - extend wait_queue_head_t to keep a pointer to the first !exclusive
>
> s/!//
>
>> >    element and insert exclusive LIFO tasks there -- thereby keeping
>> >    !exclusive tasks at the front.
>> >
>> Thank you for the suggestions. Personally I am in favor of the second
>> one but I'll wait others to comment first.
>
> Oleg, Ingo, any preferences?
