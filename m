Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab3CZR7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:59:32 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:8179 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3CZR7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:59:30 -0400
Message-ID: <1364320767.5146.11.camel@buesod1.americas.hpqcorp.net>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Date: Tue, 26 Mar 2013 10:59:27 -0700
In-Reply-To: <CA+i8gK+DNOk5tvRsVJFKyk0A2qOD_az7yJ5+3Y2xS=Ear1VkVA@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com>
	 <CA+55aFzqBEX=cGGZJJsfNWcDwQcUOP7njEog-kZZLRxuDg8Tzg@mail.gmail.com>
	 <CA+i8gK+h+FyPiOL85BPa-Pu8+bDw6LW60-oRoLHgP2AnzMADCA@mail.gmail.com>
	 <CA+55aFxjGFi+gt3UwdVCVKP5riHSR=_qLkp0SovgW2zx+gcRow@mail.gmail.com>
	 <CA+i8gKJuykoCk=O3qbDmmZXd=8U13wF7o_NzUviccaZoU6WLaA@mail.gmail.com>
	 <CA+55aFwb9v9cUG4Ton3faO6xAD18JxxoTPcObXDV_5Zf3QQ=Kw@mail.gmail.com>
	 <CA+i8gK+DNOk5tvRsVJFKyk0A2qOD_az7yJ5+3Y2xS=Ear1VkVA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-25 at 20:47 +0700, Emmanuel Benisty wrote:
> On Mon, Mar 25, 2013 at 12:10 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > And you never see this problem without Rik's patches?
> 
> No, never.
> 
> > Could you bisect
> > *which* patch it starts with? Are the first four ones ok (the moving
> > of the locking around, but without the fine-grained ones), for
> > example?
> 
> With the first four patches only, I got some X server freeze (just tried once).

Going over the code again, I found a potential recursive spinlock scenario. 
Andrew, if you have no objections, please queue this up.

Thanks.

---8<---

From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH] ipc, sem: prevent possible deadlock

In semctl_main(), when cmd == GETALL, we're locking
sma->sem_perm.lock (through sem_lock_and_putref), yet
after the conditional, we lock it again.
Unlock sma right after exiting the conditional.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 ipc/sem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ipc/sem.c b/ipc/sem.c
index 1a2913d..f257afe 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1243,6 +1243,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 				err = -EIDRM;
 				goto out_free;
 			}
+			sem_unlock(sma, -1);
 		}
 
 		sem_lock(sma, NULL, -1);
-- 
1.7.11.7



