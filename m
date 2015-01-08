Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbbAHJQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:16:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbbAHJQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:16:30 -0500
From: Fam Zheng <famz@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Juri Lelli <juri.lelli@gmail.com>,
        Zach Brown <zab@zabbo.net>, David Drysdale <drysdale@google.com>,
        Fam Zheng <famz@redhat.com>, Kees Cook <keescook@chromium.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Dario Faggioli <raistlin@linux.it>, "Theodore Ts'o" <tytso@mit.edu>,
        Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Oleg Nesterov <oleg@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Fabian Frederick <fabf@skynet.be>,
        Josh Triplett <josh@joshtriplett.org>,
        "David S. Miller" <davem@davemloft.net>, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [RESEND PATCH 0/3] epoll: Add epoll_pwait1 syscall
Date: Thu,  8 Jan 2015 17:16:00 +0800
Message-Id: <1420708563-21743-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resend because my script screwed the recipient format, sorry for the noise.]

Applications could use epoll interface when then need to poll a big number of
files in their main loops, to achieve better performance than ppoll(2). Except
for one concern: epoll only takes timeout parameters in microseconds, rather
than nanoseconds.

That is a drawback we should address. For a real case in QEMU, we run into a
scalability issue with ppoll(2) when many devices are attached to guest, in
which case many host fds, such as virtual disk images and sockets, need to be
polled by the main loop. As a result we are looking at switching to epoll, but
the coarse timeout precision is a trouble, as explained below. 

We're already using prctl(PR_SET_TIMERSLACK, 1) which is necessary to implement
timers in the main loop; and we call ppoll(2) with the next firing timer as
timeout, so when ppoll(2) returns, we know that we have more work to do (either
handling IO events, or fire a timer callback). This is natual and efficient,
except that ppoll(2) itself is slow.

Now that we want to switch to epoll, to speed up the polling. However the timer
slack setting will be effectively undone, because that way we will have to
round up the timeout to microseconds honoring timer contract. But consequently,
this hurts the general responsiveness.

Note: there are two alternatives, without changing kernel:

1) Leading ppoll(2), with the epollfd only and a nanosecond timeout. It won't
be slow as one fd is polled. No more scalability issue. And if there are
events, we know from ppoll(2)'s return, then we do the epoll_wait(2) with
timeout=0; otherwise, there can't be events for the epoll, skip the following
epoll_wait and just continue with other work.

2) Setup and add a timerfd to epoll, then we do epoll_wait(..., timeout=-1).
The timerfd will hopefully force epoll_wait to return when it timeouts, even if
no other events have arrived. This will inheritly give us timerfd's precision.
Note that for each poll, the desired timeout is different because the next
timer is different, so that, before each epoll_wait(2), there will be a
timerfd_settime syscall to set it to a proper value.

Unfortunately, both approaches require one more syscall per iteration, compared
to the original single ppoll(2), cost of which is unneglectable when we talk
about nanosecond granularity.

Fam


Fam Zheng (3):
  epoll: Extract epoll_wait_do and epoll_pwait_do
  epoll: Add implementation for epoll_pwait1
  x86: hook up epoll_pwait1 syscall

 arch/x86/syscalls/syscall_32.tbl |   1 +
 arch/x86/syscalls/syscall_64.tbl |   1 +
 fs/eventpoll.c                   | 160 +++++++++++++++++++++++----------------
 include/linux/syscalls.h         |   4 +
 kernel/sys_ni.c                  |   3 +
 5 files changed, 103 insertions(+), 66 deletions(-)

-- 
1.9.3

