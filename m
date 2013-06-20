Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3FTHC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:02:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:59051 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3FTHC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:02:57 -0400
Date: Thu, 20 Jun 2013 09:02:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        laijs@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/kthread.c: need spin_lock_irq() for 'worker'
 before main looping, since it can "WARN_ON(worker->task)".
In-Reply-To: <51C26087.9000109@asianux.com>
Message-ID: <alpine.DEB.2.02.1306200900030.4013@ionos.tec.linutronix.de>
References: <51C12D9A.8030801@asianux.com> <20130619084124.GF30681@mtj.dyndns.org> <51C18540.5060200@asianux.com> <20130619155218.GA14881@htj.dyndns.org> <51C26087.9000109@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Chen Gang wrote:

> On 06/19/2013 11:52 PM, Tejun Heo wrote:
> > On Wed, Jun 19, 2013 at 06:17:36PM +0800, Chen Gang wrote:
> >> > Hmm... can 'worker->task' has chance to be not NULL before set 'current'
> >> > to it ?
> > Yes, if the caller screws up and try to attach more than one workers
> > to the kthread_worker, which has some possibility of happening as
> > kthread_worker allows both attaching and detaching a worker.
> > 
> 
> If we detect the bugs, and still want to use WARN_ON() to report warning
> and continue running, we need be sure of keeping the related things no
> touch (at least not lead to worse).
> 
> If we can not be sure of keeping the related things no touch:
>   if it is a kernel bug, better use BUG_ON() instead of,
>   if it is a user mode bug, better to return failure with error code and
> print related information.

Wrong. BUG_ON() is only for cases where the kernel CANNOT continue at
all. WARN_ON() prints the very same information, but allows to
continue.

> BUG_ON() will stop current working flow and report kernel bug in details.

There is no reason to crash the machine completely. The kernel can
continue and the WARN_ON reports the bug with the same details.

Thanks,

	tglx
