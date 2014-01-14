Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaANUyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:54:00 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46806 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaANUxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:53:55 -0500
MIME-Version: 1.0
In-Reply-To: <20140114201311.GA1259@redhat.com>
References: <1389645028-17157-1-git-send-email-wad@chromium.org>
	<1389645028-17157-2-git-send-email-wad@chromium.org>
	<20140114192118.GA31411@redhat.com>
	<20140114200240.GA801@redhat.com>
	<20140114201311.GA1259@redhat.com>
Date: Tue, 14 Jan 2014 14:53:55 -0600
Message-ID: <CABqD9hZ3oRZo6azrq_o0z2=B=pbksmu0Kv4CPLS87DgwOiHa+w@mail.gmail.com>
Subject: Re: [PATCH 2/2] sys, seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
From: Will Drewry <wad@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Nicolas Schichan <nschichan@freebox.fr>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, holt@sgi.com,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 2:13 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/14, Oleg Nesterov wrote:
>>
>> On 01/14, Oleg Nesterov wrote:
>> >
>> > > +                 get_seccomp_filter(caller);
>> > > +                 /*
>> > > +                  * Drop the task reference to the shared ancestor since
>> > > +                  * current's path will hold a reference.  (This also
>> > > +                  * allows a put before the assignment.)
>> > > +                  */
>> > > +                 put_seccomp_filter(thread);
>> > > +                 thread->seccomp.filter = caller->seccomp.filter;
>> >
>> > As I said, I do not understand this patch yet, but this looks suspicious.
>> >
>> > Why we can't race with this thread doing clone(CLONE_THREAD) ? We do
>> > not the the new thread yet, but its ->seccomp can be already copied
>> > by copy_process(), no?

Ah - I thought the tasklist_lock would catch that, but of course that
happens before
the tasklist_lock is needed.

>>
>> And it seems that this can obviously race with seccomp_attach_filter()
>> called by this "thread".

And... I was hoping the task_lock would cover any attach cases, but
missing the copy_process() is a problem.
>
> Heh. I just noticed that this patch is not first in series, and I wasn't
> cc'ed. I found this one on marc.info,

Sorry!  I shouldn't have relied on cc-cmd, I usually mess it up.

>
>         http://marc.info/?l=linux-kernel&m=138964557211277
>
> this explains task_lock(). But this can't fix the race with copy_process,
> and the patch itself doesn't look right... if nothing else, we can't do
> copy_from_user() under task_lock().

Thanks -- I'll take a more critical look!
