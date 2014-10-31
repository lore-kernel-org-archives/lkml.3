Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbaJaRle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:41:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37276 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757993AbaJaRld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:41:33 -0400
Date: Fri, 31 Oct 2014 18:41:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: peter@hurleysoftware.com, oleg@redhat.com, rjw@rjwysocki.net,
        torvalds@linux-foundation.org, tglx@linutronix.de, eparis@redhat.com,
        umgwanakikbuti@gmail.com, marcel@holtmann.org, ebiederm@xmission.com,
        davem@davemloft.net, fengguang.wu@intel.com
Subject: Re: [PATCH 2/7] wait: Reimplement wait_event_freezable()
Message-ID: <20141031174114.GO10501@worktop.programming.kicks-ass.net>
References: <20141031111037.936236584@infradead.org>
 <20141031111549.551132563@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031111549.551132563@infradead.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 12:10:39PM +0100, Peter Zijlstra wrote:
> Provide better implementations of wait_event_freezable() APIs.
> 
> The problem is with freezer_do_not_count(), it hides the thread from
> the freezer, even though this thread might not actually freeze/sleep
> at all.
> 
> Cc: oleg@redhat.com
> Cc: Rafael Wysocki <rjw@rjwysocki.net>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---

This would maybe compile better.. gotta run, will test later.

--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -284,12 +284,13 @@ do {									\
  * change the result of the wait condition.
  */
 #define wait_event_freezable(wq, condition)				\
-do {									\
+({									\
+	int __ret = 0;							\
 	might_sleep();							\
-	if (condition)							\
-		break;							\
-	__wait_event_freezable(wq, condition);				\
-} while (0)
+	if (!(condition))						\
+		__ret = __wait_event_freezable(wq, condition);		\
+	__ret;								\
+})
 
 #define __wait_event_timeout(wq, condition, timeout)			\
 	___wait_event(wq, ___wait_cond_timeout(condition),		\
