Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3F3Sak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 14:30:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab3F3Sai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 14:30:38 -0400
Date: Sun, 30 Jun 2013 20:19:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Lukas Czerner <lczerner@redhat.com>,
        Samuel Ortiz <samuel@sortiz.org>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Ralf Baechle <ralf@linux-mips.org>, Valdis.Kletnieks@vt.edu
Subject: Re: linux-next: Tree for Jun 28 [ BISECTED: rsyslog/imklog: High
	CPU usage ]
Message-ID: <20130630181945.GA5171@redhat.com>
References: <CA+icZUXo=Z4gDfCMvLqRQDq_fpNAq+UqtUw=jrU=3=kVZP-2+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXo=Z4gDfCMvLqRQDq_fpNAq+UqtUw=jrU=3=kVZP-2+A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please drop these

	wait-introduce-wait_event_commonwq-condition-state-timeout.patch
	wait-introduce-prepare_to_wait_event.patch

patches again. I'll send v3 although it really looks like I should
never try to touch wait.h.

On 06/29, Sedat Dilek wrote:
>
> As this all did not show me what caused the problem I started a
> git-bisect session.
>
> This revealed the following culprit commit:
>
>      commit bb1f30cb7d3ba21098f0ee7e0382160ba2599a43
>      "wait: introduce wait_event_common(wq, condition, state, timeout)"

Heh. First of all, I am really sorry.

Not only "__wait_no_timeout(tout) ?:" was wrong, I didn't bother
to recheck this logic even after I got the "warning: the omitted
middle operand in ?:" reports.

Sedat, thanks you very much! Any chance you can try the patch below?

Oleg.


--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -191,12 +191,8 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 	for (;;) {							\
 		__ret = prepare_to_wait_event(&wq, &__wait, state);	\
 		if (condition) {					\
-			__ret = __wait_no_timeout(tout);		\
-			if (!__ret) {					\
-				__ret = __tout;				\
-				if (!__ret)				\
-					__ret = 1;			\
-			}						\
+			__ret = __wait_no_timeout(tout) ? 0 :		\
+							(__tout ?: 1);	\
 			break;						\
 		}							\
 									\
@@ -217,16 +213,10 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 #define wait_event_common(wq, condition, state, tout)			\
 ({									\
 	long __ret;							\
-	if (condition) {						\
-		__ret = __wait_no_timeout(tout);			\
-		if (!__ret) {						\
-			__ret = tout;					\
-			if (!__ret)					\
-				__ret = 1;				\
-		}							\
-	} else {							\
+	if (condition)							\
+		__ret = __wait_no_timeout(tout) ? 0 : ((tout) ?: 1);	\
+	else								\
 		__ret = __wait_event_common(wq, condition, state, tout);\
-	}								\
 	__ret;								\
 })
 

