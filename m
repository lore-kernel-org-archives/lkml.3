Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab3CCGIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 01:08:19 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:56894 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab3CCGIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 01:08:17 -0500
MIME-Version: 1.0
In-Reply-To: <1362288734.2886.14.camel@buesod1.americas.hpqcorp.net>
References: <1362183400.3420.24.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFzxJo3y7r_5BvUVwZX4LyC6dba8qPTbp+iDf_nRgYg4cw@mail.gmail.com>
	<1362288734.2886.14.camel@buesod1.americas.hpqcorp.net>
Date: Sat, 2 Mar 2013 22:08:15 -0800
X-Google-Sender-Auth: yuQGicPWblL5GdifAiYSaT1BwlY
Message-ID: <CA+55aFzojVt8fw9ih5kXt4Po83j4JT=h_+LEVbOQ7V_aLSBjXA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] ipc: introduce obtaining a lockless ipc object
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>, Rik van Riel <riel@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
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

On Sat, Mar 2, 2013 at 9:32 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
>
> After updating the callers, [msgctl, semctl, shmctl]_down, to acquire
> the lock for IPC_RMID and IPC_SET commands, I'm no longer seeing these
> issues - so far on my regular laptop and two big boxes running my Oracle
> benchmarks for a few hours. Something like below (yes, I will address
> the open coded spin_lock calls):

Actually, please do me a favor, and do *not* change the semantics of
these helper calls without changing the name of the helper.

So I'd ask that instead of changing the callers, do this:

 - make the version that does *not* lock be called ipcctl_pre_down_nolock()

 - then, keep the old name, and just make it do the
ipcctl_pre_down_nolock() followed by the spin_lock() (or rather, the
non-open-coded one).

Then, you can make each caller individually use the "nolock" version
instead, and move the locking into the caller. But don't do the same
mistake as the original patch, which was to change the locking
semantics while keeping the same name of the function.

In other words, it's much better to make these changes in small
gradual pieces, and make each piece very obviously not change any
semantics. So the first piece is the introduce the helper functions
with new semantics (and new names), while keeping the old helpers with
the old semantics and old names. Make it really clear that no
semantics change. And the second piece is then to start using the
split-up helpers that have different locking semantics and new names,
and do it on a call-by-call basis.

Ok?

              Linus
