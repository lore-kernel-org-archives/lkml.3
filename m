Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3BPBoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 20:44:55 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:55655 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3BPBoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 20:44:54 -0500
MIME-Version: 1.0
In-Reply-To: <20130216012242.GZ4503@ZenIV.linux.org.uk>
References: <20130214053656.GS4503@ZenIV.linux.org.uk> <CA+55aFz1JjGSCdqXpVz3oH-PWFDE3Qdxt3EVxqC2i=nfLqf0Jw@mail.gmail.com>
 <20130215215946.GX4503@ZenIV.linux.org.uk> <CAGDaZ_pMLScoO811es3AZxzAnSiS5ixku-DeuEi4FwX8mNv3cQ@mail.gmail.com>
 <20130216000435.GY4503@ZenIV.linux.org.uk> <CA+55aFyzGenPNnKxf_PnAWVa1tZP294XUrhAVXgi0EuKm1x=vA@mail.gmail.com>
 <20130216012242.GZ4503@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Feb 2013 17:44:33 -0800
X-Google-Sender-Auth: rLnO0cZHh_MjiG3O11CQNCIkHtc
Message-ID: <CA+55aFyZFf_9ZMFSOs9y-n3EsQ7n2V0qEnCrqAGFWgDGmPBmtg@mail.gmail.com>
Subject: Re: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Shentino <shentino@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 5:22 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Fine by me - the variant I'd posted simply moved these calls in one
> place; I've no problem with replacing them with force_sig() (or
> force_sigsegv(SIGSEGV, current), for paranoia sake).  OTOH, I'd probably
> prefer to make it a separate commit.

I'd argue that it actually makes sense in the same commit - since
you're changing SIGKILL to SIGSEGV, and what makes SIGKILL special
really is that it can never be blocked. So even conceptually, it's
actually *that* change that it should couple with.

But I don't care enough, so if you already just have the one commit
and want to add on top of it with a second one, that's fine.

> Cause: SET_PERSONALITY() on alpha doesn't care to preserve the upper bits
> of current->personality and just does either set_personality(PER_LINUX) or
> set_personality(PER_LINUX_32BIT).

Christ, we should just try to get rid of the personality bits
entirely, they are completely insane. We don't even use most of the
numbers, yet we have these odd personality numbers for emulating
legacy Unixes that we don't even care about. Some of it *may* have
made sense back when we actually thought things like iBCS2 would
matter. I cannot believe it possibly matters any more.

But nobody seems to care enough, and the numbers have slipped into
user space. I do wonder if we could make things clearer, get rid of
the insane internal "personality number", and instead have explicit
bits for the few things that actually do matter (like the whole
zero-page mapping, the address randomization etc). And then leave the
insane "set_personality()" system call as a legacy interface that just
looks at the number and moves the bits around appropriately.

The fact that we actually carry this insane meaningless number along,
and then have crazy things like that "upper bits of the crazy number
doesn't get set by alpha SET_PERSONALITY" is just crazy.

But don't worry, I sympathize 100% with all sane people who go "I
don't want to touch that mess".

              Linus
