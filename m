Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3I3Av5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:51:57 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:54215 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3I3Avz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:51:55 -0400
MIME-Version: 1.0
In-Reply-To: <1380501626.2174.17.camel@buesod1.americas.hpqcorp.net>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	<CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	<20130928074144.GA17773@gmail.com>
	<CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
	<1380495986.2174.10.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFx1PErQQ8eR6JgQzmM0RZwyUtyc6CFfnvzzKz2RJa2GFw@mail.gmail.com>
	<1380501626.2174.17.camel@buesod1.americas.hpqcorp.net>
Date: Sun, 29 Sep 2013 17:51:53 -0700
X-Google-Sender-Auth: D5v9gS17g1ORSsZkIn_C1QwpGvI
Message-ID: <CA+55aFymh9PP12Tt40HZB-JMv6Tan2aNJvnCScXpx3XrmddTAw@mail.gmail.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 5:40 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> Hmm, I'm getting the following at bootup:
>
>  May be due to missing lock nesting notation

Yes it is. And that reminds me of a problem I think we had with this
code: we had a possible case of the preemption counter nesting too
deeply. I forget the details, but it was something people worried
about.

That mm_take_all_locks() thing is really special, and I suspect that
if we go down this way we should just do a single preempt-disable and
then use the arch_write_lock() to avoid both the lockdep splat _and_
the preemption counter overflow.

                 Linus
