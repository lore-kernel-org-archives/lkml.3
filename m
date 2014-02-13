Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaBMR6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:58:49 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43763 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaBMR6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:58:48 -0500
MIME-Version: 1.0
In-Reply-To: <20140213174020.GA14455@redhat.com>
References: <20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
	<20140212113928.GO18016@ZenIV.linux.org.uk>
	<CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
	<20140212211421.GP18016@ZenIV.linux.org.uk>
	<CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
	<20140213174020.GA14455@redhat.com>
Date: Thu, 13 Feb 2014 09:58:47 -0800
X-Google-Sender-Auth: CjRK4PoOgV74-MF4A59wt7xqJTc
Message-ID: <CA+55aFxwozCQ05axLB02R3huX8sj=20EoFfw0cSDDL8fBE_Y6Q@mail.gmail.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 9:40 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> And we should be careful with SIGQUEUE_PREALLOC, at least
> collect_signal() should not do list_del_init()... Plus we need to
> handle the SEND_SIG_FORCED-like case.

I don't think the users need to care. They'd just call
"sigqueue_free()" not knowing about our preallocations etc. That kind
of detail should be confined to inside signal.c.

But there really aren't that many users. There's a couple of
"dequeue_signal_lock()" users, but they don't actually *want* the
siginfo at all (they're kernel threads), so we can just make that
function free the siginfo immediately (and get rid of the totally
unnecessay kernel stack allocation). And outside of signal.c only
signalfd uses "dequeue_signal()" itself, and that would be the only
one that would need to be taught to use (in signalfd_copyinfo()) and
then free the sigqueue entry.

So it really looks like the right thing to do, and fairly
straightforward. But I'm leaving the coding proof to Al, since he
already offered ;)

             Linus
