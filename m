Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab3JAOQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:16:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab3JAOQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:16:42 -0400
Date: Tue, 1 Oct 2013 16:09:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] sched, wait: Collapse __wait_event macros -v4
Message-ID: <20131001140940.GA32328@redhat.com>
References: <20130930152242.207382649@infradead.org> <20130930174054.GA28129@redhat.com> <20130930180939.GN15690@laptop.programming.kicks-ass.net> <20130930181358.GA29544@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930181358.GA29544@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30, Oleg Nesterov wrote:
>
> On 09/30, Peter Zijlstra wrote:
> >
> > On Mon, Sep 30, 2013 at 07:40:54PM +0200, Oleg Nesterov wrote:
> > > Once again, of course I do not blame this series, but
> > > wait_event_timeout(wq, true, 0) still returns 0.
> >
> > So we have:
> >
> > [...snip...]
>
> > So wait_event_timeout(wq, true, 0) turns into:
>
> Not really, because of fast-path check,
>
> 	#define wait_event_timeout(wq, condition, timeout)			\
> 	({									\
> 		long __ret = timeout;						\
> 		if (!(condition)) 						\
> 			__ret = __wait_event_timeout(wq, condition, timeout);	\
> 		__ret;								\
> 	})
>
> we do not even call __wait_event_timeout() if "condition" is already
> true at the start.

But somehow I didn't realize that ___wait_cond_timeout() can be used
as is, so the simple patch below should work?

Oleg.

--- x/include/linux/wait.h
+++ x/include/linux/wait.h
@@ -270,7 +270,7 @@ do {									\
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition)) 						\
+	if (!___wait_cond_timeout(condition)) 				\
 		__ret = __wait_event_timeout(wq, condition, timeout);	\
 	__ret;								\
 })
@@ -328,7 +328,7 @@ do {									\
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition))						\
+	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_interruptible_timeout(wq, 		\
 						condition, timeout);	\
 	__ret;								\
@@ -770,7 +770,7 @@ do {									\
 						  timeout)		\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition))						\
+	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_interruptible_lock_irq_timeout(	\
 					wq, condition, lock, timeout);	\
 	__ret;								\

