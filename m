Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaEWVFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:05:34 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:59908 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaEWVFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:05:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140523084914.GA30445@twins.programming.kicks-ass.net>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org>
	<1400799936-26499-4-git-send-email-keescook@chromium.org>
	<20140523084914.GA30445@twins.programming.kicks-ass.net>
Date: Fri, 23 May 2014 14:05:29 -0700
X-Google-Sender-Auth: j15vSg1ptt69Dz3_XslEx5T12CU
Message-ID: <CAGXu5jK1jy3P733+dgGdSGjLV5eXNEjO9PvyHO4YwZGjjGU2zA@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] seccomp: introduce writer locking
From: Kees Cook <keescook@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dario Faggioli <raistlin@linux.it>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        liguang <lig.fnst@cn.fujitsu.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 1:49 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, May 22, 2014 at 04:05:33PM -0700, Kees Cook wrote:
>> Normally, task_struct.seccomp.filter is only ever read or modified by
>> the task that owns it (current). This property aids in fast access
>> during system call filtering as read access is lockless.
>>
>> Updating the pointer from another task, however, opens up race
>> conditions. To allow cross-task filter pointer updates, writes to the
>> seccomp fields are now protected by a spinlock.  Read access remains
>> lockless because pointer updates themselves are atomic.  However, writes
>> (or cloning) often entail additional checking (like maximum instruction
>> counts) which require locking to perform safely.
>>
>> In the case of cloning threads, the child is invisible to the system
>> until it enters the task list. To make sure a child can't be cloned
>> from a thread and left in a prior state, seccomp duplication is moved
>> under the tasklist_lock. Then parent and child are certain have the same
>> seccomp state when they exit the lock.
>>
>
> So I'm a complete noob on the whole seccomp thing, so maybe this is a
> silly question, but.. what about object lifetimes?

The get/put logic on seccomp filters eluded me when I first looked at
it too. :) Basically, each branch point holds counts, which means a
given filter will only get freed when all tasks using it have died.

> Looking at put_seccomp_filter() it explicitly takes a tsk pointer,
> suggesting one can call it on !current. And while it does a dec_and_test
> on the object itself, run_filter() does nothing with refcounts, and
> therefore can be touching dead memory.

That's technically true, but the only caller of put_seccomp_filter()
is free_task(), for which "current" doesn't make sense. But when
called, the task is no longer part of the task_list, so there's no
dead memory touching. (Unless you see something I don't.)

-Kees

-- 
Kees Cook
Chrome OS Security
