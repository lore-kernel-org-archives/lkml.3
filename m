Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaBNCxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 21:53:10 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38192 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaBNCxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 21:53:06 -0500
Message-ID: <1392346377.4744.8.camel@ThinkPad-T5421.cn.ibm.com>
Subject: [PATCH ] workqueue: add args to workqueue lockdep name
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        trinity@vger.kernel.org
Date: Fri, 14 Feb 2014 10:52:57 +0800
In-Reply-To: <20140213221515.GL17608@htj.dyndns.org>
References: <CA+ydwtqC7En++T5S7q5qzaDe_tf9dcMx3Y3aH=+Fcss_NU7stA@mail.gmail.com>
	 <20140210192846.GF27965@twins.programming.kicks-ass.net>
	 <20140210215224.GB25350@mtj.dyndns.org>
	 <20140211110036.GT9987@twins.programming.kicks-ass.net>
	 <20140211152741.GA24490@htj.dyndns.org>
	 <1392266124.4974.35.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140213212645.GG17608@htj.dyndns.org>
	 <20140213213253.GF27965@twins.programming.kicks-ass.net>
	 <20140213221515.GL17608@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021402-5816-0000-0000-00000C444E0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tommi noticed a 'funny' lock class name: "%s#5" from a lock acquired in
process_one_work().

Maybe #fmt plus #args could be used as the lock_name to give some more
information for some fmt string like the above. 

__builtin_constant_p() check is removed (as there seems no good way to
check all the variables in args list). However, by removing the check,
it only adds two additional "s for those constants.

Some lockdep name examples printed out after the change:

lockdep name                    wq->name

"events_long"                   events_long
"%s"("khelper")                 khelper
"xfs-data/%s"mp->m_fsname       xfs-data/dm-3

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 include/linux/workqueue.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 594521b..704f4f6 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -419,10 +419,7 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 	static struct lock_class_key __key;				\
 	const char *__lock_name;					\
 									\
-	if (__builtin_constant_p(fmt))					\
-		__lock_name = (fmt);					\
-	else								\
-		__lock_name = #fmt;					\
+	__lock_name = #fmt#args;					\
 									\
 	__alloc_workqueue_key((fmt), (flags), (max_active),		\
 			      &__key, __lock_name, ##args);		\



