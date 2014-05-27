Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaE0SlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:41:00 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:46315 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbaE0Sk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:40:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jL4erM41JBG703adSht-f4K7fAfbG9XyjPNUwiyAde-Nw@mail.gmail.com>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org>
 <1400799936-26499-7-git-send-email-keescook@chromium.org> <CALCETrWR6s7wqSwEeygOYqizrxy8eAyHb3SqvLoTooMZ+MfdqA@mail.gmail.com>
 <CAGXu5j+=itFtHe25pZxXsk+1C1Cca4DGm83SC93=xRctUdeXsw@mail.gmail.com>
 <CALCETrX3fjeHeigLXy7Juq6XrNFEeZLQPLmQhiOwBDgc0MRtBw@mail.gmail.com> <CAGXu5jL4erM41JBG703adSht-f4K7fAfbG9XyjPNUwiyAde-Nw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 27 May 2014 11:40:36 -0700
Message-ID: <CALCETrVZADpErLwsyaWEQqVa45_VEMyQg+L+g2gR4NhwNCXd4g@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] seccomp: add SECCOMP_EXT_ACT_TSYNC and SECCOMP_FILTER_TSYNC
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
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
        LSM List <linux-security-module@vger.kernel.org>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 11:24 AM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, May 26, 2014 at 12:27 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Fri, May 23, 2014 at 10:05 AM, Kees Cook <keescook@chromium.org> wrote:
>>> On Thu, May 22, 2014 at 4:11 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> On Thu, May 22, 2014 at 4:05 PM, Kees Cook <keescook@chromium.org> wrote:
>>>>> Applying restrictive seccomp filter programs to large or diverse
>>>>> codebases often requires handling threads which may be started early in
>>>>> the process lifetime (e.g., by code that is linked in). While it is
>>>>> possible to apply permissive programs prior to process start up, it is
>>>>> difficult to further restrict the kernel ABI to those threads after that
>>>>> point.
>>>>>
>>>>> This change adds a new seccomp extension action for synchronizing thread
>>>>> group seccomp filters and a prctl() for accessing that functionality,
>>>>> as well as a flag for SECCOMP_EXT_ACT_FILTER to perform sync at filter
>>>>> installation time.
>>>>>
>>>>> When calling prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT, SECCOMP_EXT_ACT_FILTER,
>>>>> flags, filter) with flags containing SECCOMP_FILTER_TSYNC, or when calling
>>>>> prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT, SECCOMP_EXT_ACT_TSYNC, 0, 0), it
>>>>> will attempt to synchronize all threads in current's threadgroup to its
>>>>> seccomp filter program. This is possible iff all threads are using a filter
>>>>> that is an ancestor to the filter current is attempting to synchronize to.
>>>>> NULL filters (where the task is running as SECCOMP_MODE_NONE) are also
>>>>> treated as ancestors allowing threads to be transitioned into
>>>>> SECCOMP_MODE_FILTER. If prctrl(PR_SET_NO_NEW_PRIVS, ...) has been set on the
>>>>> calling thread, no_new_privs will be set for all synchronized threads too.
>>>>> On success, 0 is returned. On failure, the pid of one of the failing threads
>>>>> will be returned, with as many filters installed as possible.
>>>>
>>>> Is there a use case for adding a filter and synchronizing filters
>>>> being separate operations?  If not, I think this would be easier to
>>>> understand and to use if there was just a single operation.
>>>
>>> Yes: if the other thread's lifetime is not well controlled, it's good
>>> to be able to have a distinct interface to retry the thread sync that
>>> doesn't require adding "no-op" filters.
>>
>> Wouldn't this still be solved by:
>>
>> seccomp_add_filter(final_filter, SECCOMP_FILTER_ALL_THREADS);
>>
>> the idea would be that, if seccomp_add_filter fails, then you give up
>> and, if it succeeds, then you're done.  It shouldn't fail unless out
>> of memory or you've nested too deeply.
>
> I wanted to keep the case of being able to to wait for non-ancestor
> threads to finish. For example, 2 threads start and set separate
> filters. 1 does work and exits, 2 starts another thread (3) which adds
> filters, does work, and then waits for 1 to finish by calling TSYNC.
> Once 1 dies, TSYNC succeeds. In the case of not having direct control
> over thread lifetime (say, when using third-party libraries), I'd like
> to retain the flexibility of being able to do TSYNC without needing a
> filter being attached to it.

I must admit this strikes me as odd.  What's the point of having a
thread set a filter if it intends to be a short-lived thread?

In any cast, I must have missed the ability for TSYNC to block.  Hmm.
That seems complicated, albeit potentially useful.

>
>>>> If you did that, you'd have to decide whether to continue requiring
>>>> that all the other threads have a filter that's an ancestor of the
>>>> current thread's filter.
>>>
>>> This is required no matter what to make sure there is no way to
>>> replace a filter tree with a different one (allowing accidental
>>> bypasses, misbehavior, etc).
>>
>> What I mean is:  should the add-new-filter-to-all-threads operation
>> add the new filter to all threads, regardless of what their current
>> state is, or should it fail if any thread has a filter that isn't an
>> ancestor of the current thread's filter?  Either version should be
>> safe.
>
> It should fail -- we don't want to run the risk of effectively
> replacing a filter out from under a thread. Adding additional
> restrictions is safe as long as we retain the nnp from the caller .

The other option would be to add the new filter.  The threads wouldn't
end up being ancestors of each other, but that could still be okay.

In any case, I don't have a strong feeling about this particular issue.

--Andy
