Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab3LJTzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:55:09 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:59498 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3LJTzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:55:07 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
References: <20131210154724.GA30020@redhat.com>
	<CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	<alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
Date: Tue, 10 Dec 2013 11:55:06 -0800
X-Google-Sender-Auth: E7d1K3Z-LPm2Kfl-d2sPOSEKBKc
Message-ID: <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
Subject: Re: process 'stuck' at exit.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 11:18 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> So this is pretty unlikely. The retry requires:
>
>    get_futex_value_locked() == EFAULT;
>
> Now we drop the hash bucket locks and do:
>
>    get_user();
>
> And if that get_user() faults again, we bail out.

I think you need to look closer.

We have at least also that "futex_proxy_trylock_atomic() returns
-EAGAIN" case. Which triggers at some exit condition. Another thread
in the same group, perhaps never completing the exit because it's
waiting for this one? I dunno, I didn't look any closer (but this does
make me think "Hey, we should add Oleg to the Cc too", since
PF_EXITING is involved).. So maybe there is some situation where that
EAGAIN will keep happening, forever..

Now, I'm *not* saying that that is it. It's quite possible/likely some
other loop, but I do have to say that it sure isn't _obvious_. And
that whole EAGAIN return case is quite deep and special, so ...

                 Linus

PS: Oleg - the whole thread is on lkml. Ping me if you need more context.
