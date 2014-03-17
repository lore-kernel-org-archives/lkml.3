Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063AbaCQUCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:02:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaCQUCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:02:43 -0400
Date: Mon, 17 Mar 2014 13:02:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: penguin-kernel@I-love.SAKURA.ne.jp, Oleg Nesterov <oleg@redhat.com>,
        rientjes@google.com, Linus Torvalds <torvalds@linux-foundation.org>,
        tj@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@lists.ubuntu.com>
Subject: Re: [v3.13][v3.14][Regression] kthread: make kthread_create()
 killable
Message-Id: <20140317130241.7e4fde86d75d417628da6f1a@linux-foundation.org>
In-Reply-To: <53236AA2.7030105@canonical.com>
References: <53236AA2.7030105@canonical.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 16:46:26 -0400 Joseph Salisbury <joseph.salisbury@canonical.com> wrote:

> Hi Tetsuo,
> 
> A kernel bug report was opened against Ubuntu[0].  We performed a kernel
> bisect, and found that reverting the following commit resolved this bug:
> 
> 
> commit 786235eeba0e1e85e5cbbb9f97d1087ad03dfa21
> Author: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date:   Tue Nov 12 15:06:45 2013 -0800
> 
>     kthread: make kthread_create() killable
> 
> The regression was introduced as of v3.13-rc1.
> 
> The bug indicates an issue with the SAS controller during
> initialization, which prevents the system from booting.  Additional
> details are available in the bug report or on request.
> 
> I was hoping to get your feedback, since you are the patch author.  Do
> you think gathering any additional data will help diagnose this issue,
> or would it be best to submit a revert request?
> 
> [0] http://pad.lv/1276705

What process is running here?  Presumably modprobe.

A possible explanation is that modprobe has genuinely received a
SIGKILL.  Can you identify anything in this setup which might send a
SIGKILL to the modprobe process?

kthread_create_on_node() thinks that SIGKILL came from the oom-killer
and it cheerfully returns -ENOMEM, which is incorrect if that signal
came from userspace.  And I don't _think_ we prevent
userspace-originated signals from unblocking
wait_for_completion_killable()?


Root cause time: it's wrong for the oom-killer to use SIGKILL.  In fact
it's basically always wrong to send signals from in-kernel.  Signals
are a userspace IPC mechanism and using them in-kernel a) makes it hard
(or impossible) to distinguish them from userspace-originated signals
and b) permits userspace to produce surprising results in the kernel,
which I suspect is what we're seeing here.
