Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaG1PTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:19:24 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:41113 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaG1PTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:19:22 -0400
MIME-Version: 1.0
In-Reply-To: <1406559487-30007-1-git-send-email-bobby.prani@gmail.com>
References: <1406559487-30007-1-git-send-email-bobby.prani@gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 28 Jul 2014 11:18:49 -0400
Message-ID: <CAJhHMCA_85kAxtL4TKGS0bvOD+OtPY5Fvi=O=RC6gXfE7JopFQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] rcu: Use separate wait queues for leaders and followers
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 10:58 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> Commit fbce7497ee5a ("rcu: Parallelize and economize NOCB kthread wakeups")
>
> tries to reduce the wake up overhead by creating leader and follower nocb
> kthreads.
>
> One thing overlooked here is that all the kthreads wait on the same wait queue.
> When we try to wake up the leader threads on the wait queue, we also try to wake
> up the follower threads because of which there is still wake up overhead.
>
> This commit tries to avoid that by using separate wait queues for the leaders and
> followers.

This solution is still not the best we can do. All the followers will
still wait in one wait queue and we try to wake them up all each time
we call wake_up on the follower wait queue.

To illustrate, let me take the original example in the above commit.
Let us say there are 4096 nocb kthreads, 64 leaders each of which have
64 followers.

The grace period kthread will now try to wake up only 64 leader nocb
kthreads, which is better than before, but each leader will try to
wake up all the followers on the follower wait queue. It would be
great if each leader had its own follower wait queue to wake up, but I
guess that is a stretch.

Thoughts?

--
Pranith
