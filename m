Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308Ab3FSIld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:41:33 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33842 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934194Ab3FSIl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:41:27 -0400
Date: Wed, 19 Jun 2013 01:41:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        laijs@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/kthread.c: need spin_lock_irq() for 'worker'
 before main looping,  since it can "WARN_ON(worker->task)".
Message-ID: <20130619084124.GF30681@mtj.dyndns.org>
References: <51C12D9A.8030801@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C12D9A.8030801@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 12:03:38PM +0800, Chen Gang wrote:
> 
> Since "WARN_ON(worker->task)", we can not assume that 'worker->task'
> will be NULL before set 'current' to it.
> 
> So need let 'worker' lock protected too, just like it already lock
> protected all time in main looping.

That synchronization is the kthread_worker user's responsibility.  The
locking around worker->task = NULL is to prevent the worker task being
destroyed while insert_kthread_work() is trying to wake it up.  It has
nothing to do with the user trying to attach multiple tasks to the
same kthread_worker.  Plus, putting locking around WARN_ON() is
pointless.  It doesn't really fix anything.  It just makes WARN_ON()
trigger *slightly* more reliably.

Thanks.

-- 
tejun
