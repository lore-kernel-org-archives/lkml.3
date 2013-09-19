Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3ISX1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 19:27:35 -0400
Received: from dkim1.fusionio.com ([66.114.96.53]:42039 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3ISX1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 19:27:33 -0400
X-ASG-Debug-ID: 1379633252-0421b5022240fbd0001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
Date: Thu, 19 Sep 2013 19:27:32 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <walken@google.com>, <linux-kernel@vger.kernel.org>, <mingo@elte.hu>,
        <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] rwsem: add rwsem_is_contended V2
Message-ID: <20130919232732.GC1615@localhost.localdomain>
X-ASG-Orig-Subj: Re: [PATCH 1/2] rwsem: add rwsem_is_contended V2
References: <1379605688-987-1-git-send-email-jbacik@fusionio.com>
 <523B8157.4050508@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <523B8157.4050508@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1379633252
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140765
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 06:57:27PM -0400, Peter Hurley wrote:
> On 09/19/2013 11:48 AM, Josef Bacik wrote:
> >Btrfs needs a simple way to know if it needs to let go of it's read lock on a
> >rwsem.  Introduce rwsem_is_contended to check to see if there are any waiters on
> >this rwsem currently.  This is just a hueristic, it is meant to be light and not
> >100% accurate and called by somebody already holding on to the rwsem in either
> >read or write.  Thanks,
> >
> >Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> >---
> >V1->V2: took everybodys suggestions and simplified it to just one function in
> >rwsem.h so it works for both the spinlock case and non-spinlock case.
> >
> >  include/linux/rwsem.h | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> >diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
> >index 0616ffe..c340493 100644
> >--- a/include/linux/rwsem.h
> >+++ b/include/linux/rwsem.h
> >@@ -75,6 +75,19 @@ do {								\
> >  } while (0)
> >
> >  /*
> >+ * This is the same regardless of which rwsem implementation that is being used.
> >+ * It is just a heuristic meant to be called by somebody alreadying holding the
> >+ * rwsem to see if somebody from  the opposite type is wanting access to the
>                                         ^^^^^^^^^^^^^
> 
> Readers can infer that at least one writer is waiting if the wait_list is
> !empty; however, writers cannot infer anything other than some other
> thread is waiting -- it could be a reader or a writer or multiples of either.
> 

Right duh, I'll fix that up.

> 
> >+ * lock.
> >+ */
> >+static inline int rwsem_is_contended(struct rw_semaphore *sem)
> >+{
> >+	if (!list_empty(&sem->wait_list))
> >+		return 1;
> >+	return 0;
> 
> How about
> 
>         return !list_empty(&sem->wait_list);
> 
> ?
> 

Another duh, thanks I'll wait for any other input and then fix this up and
resend.  Thanks,

Josef
