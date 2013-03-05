Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab3CEUwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:52:25 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:35356 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab3CEUwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:52:24 -0500
MIME-Version: 1.0
In-Reply-To: <51364AB9.80206@hp.com>
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
	<513626E9.2040509@redhat.com>
	<51364AB9.80206@hp.com>
Date: Tue, 5 Mar 2013 12:52:23 -0800
X-Google-Sender-Auth: PS27tp0QwZiSE4OCDk_cqFTrsMA
Message-ID: <CA+55aFwYOUyG_DQUqVPrQNi_a=AUwS53U-Yi6jbvJTGRxQ_aEQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] ipc: reduce ipc lock contention
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Rik van Riel <riel@redhat.com>, Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 11:42 AM, Waiman Long <Waiman.Long@hp.com> wrote:
>
> The recommended kernel.sem value from Oracle is "250 32000 100 128". I have
> tried to reduce the maximum semaphores per array (1st value) while
> increasing the max number of arrays. That tends to reduce the ipc_lock
> contention in kernel, but it is against Oracle's recommendation.

Ok, the Oracle recommendations seem to be assuming that we'd be
scaling the semaphore locking sanely, which we don't. Since we share
one single lock for all semaphores in the whole array, Oracle's
recommendation does the wrong thing for our ipc_lock contention.

At the same time, I have to say that Oracle's recommendation is the
right thing to do, and it's really a kernel limitation that we scale
badly with lots of semaphores in the array. I'm surprised this hasn't
really come up before. It seems such a basic scalability issue for
such a traditional Unix load. And while everybody hates the SysV IPC
stuff, it's not like it's all *that* complicated. We've had people who
worked on much more fundamental and complex scalability things.

David's patch should make it much easier to do the locking more
fine-grained, and it sounds like Rik is actively working on that, so
I'm hopeful that we can actually do this right in the not too distant
future. The fact that oracle recomments using large semaphore arrays
actually makes me very hopeful that they use semaphores correctly, so
that if we just do our scalability work, you'd get the full advantage
of it..

                Linus
