Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaFRWzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:55:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbaFRWzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:55:51 -0400
Date: Wed, 18 Jun 2014 15:55:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jack Miller <millerjo@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, davidlohr@hp.com, miltonm@us.ibm.com,
        anton@au1.ibm.com, Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [RESEND] shm: shm exit scalability fixes
Message-Id: <20140618155549.c54b11347ac9c9a2ba10e176@linux-foundation.org>
In-Reply-To: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
References: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014 12:27:44 -0500 Jack Miller <millerjo@us.ibm.com> wrote:

> [ RESEND note: Adding relevant CCs, fixed a couple of typos in commit message,
> patches unchanged. Original intro follows. ]
> 
> All -
> 
> This is small set of patches our team has had kicking around for a few versions
> internally that fixes tasks getting hung on shm_exit when there are many
> threads hammering it at once.
> 
> Anton wrote a simple test to cause the issue:
> 
> http://ozlabs.org/~anton/junkcode/bust_shm_exit.c
> 
> Before applying this patchset, this test code will cause either hanging
> tracebacks or pthread out of memory errors.
> 
> After this patchset, it will still produce output like:
> 
> root@somehost:~# ./bust_shm_exit 1024 160
> ...
> INFO: rcu_sched detected stalls on CPUs/tasks: {} (detected by 116, t=2111
> jiffies, g=241, c=240, q=7113)
> INFO: Stall ended before state dump start
> ...
> But the task will continue to run along happily, so we consider this an
> improvement over hanging, even if it's a bit noisy.
> 
> I didn't author these patches, but I'd be happy to take any feedback and
> address any issues.

As it stands, these patches will be recorded as authored by yourself. 
You can override this by putting

From: Someone Else <email-address>

at the start of the changelog.  Please let me know if you'd like me to
make such changes.


I agree that adding 8/16 bytes to the task_struct (if CONFIG_SYSVIPC)
is regrettable.  But the poor thing is a dumping ground anyway :( I
suppose one could replace this and sysvsem with a

	struct ipc_stuff *ipc_stuff;	/* NULL if I never used IPC */

but there are probably lots of similar changes we could (and one day
may) make to the task_struct.

I queued the patches, tagged for 3.16-rc1 - hopefully Davidlohr and
Manfred will be able to find the time to go over them closely.

