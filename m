Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110Ab3CZSfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:35:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3CZSff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:35:35 -0400
Date: Tue, 26 Mar 2013 11:35:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Subject: Re: ipc,sem: sysv semaphore scalability
Message-Id: <20130326113533.41ad9ee33b2d010b2a83e7c0@linux-foundation.org>
In-Reply-To: <1364320767.5146.11.camel@buesod1.americas.hpqcorp.net>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com>
	<CA+55aFzqBEX=cGGZJJsfNWcDwQcUOP7njEog-kZZLRxuDg8Tzg@mail.gmail.com>
	<CA+i8gK+h+FyPiOL85BPa-Pu8+bDw6LW60-oRoLHgP2AnzMADCA@mail.gmail.com>
	<CA+55aFxjGFi+gt3UwdVCVKP5riHSR=_qLkp0SovgW2zx+gcRow@mail.gmail.com>
	<CA+i8gKJuykoCk=O3qbDmmZXd=8U13wF7o_NzUviccaZoU6WLaA@mail.gmail.com>
	<CA+55aFwb9v9cUG4Ton3faO6xAD18JxxoTPcObXDV_5Zf3QQ=Kw@mail.gmail.com>
	<CA+i8gK+DNOk5tvRsVJFKyk0A2qOD_az7yJ5+3Y2xS=Ear1VkVA@mail.gmail.com>
	<1364320767.5146.11.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013 10:59:27 -0700 Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:

> On Mon, 2013-03-25 at 20:47 +0700, Emmanuel Benisty wrote:
> > On Mon, Mar 25, 2013 at 12:10 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > And you never see this problem without Rik's patches?
> > 
> > No, never.
> > 
> > > Could you bisect
> > > *which* patch it starts with? Are the first four ones ok (the moving
> > > of the locking around, but without the fine-grained ones), for
> > > example?
> > 
> > With the first four patches only, I got some X server freeze (just tried once).
> 
> Going over the code again, I found a potential recursive spinlock scenario. 
> Andrew, if you have no objections, please queue this up.
> 
> Thanks.
> 
> ---8<---
> 
> From: Davidlohr Bueso <davidlohr.bueso@hp.com>
> Subject: [PATCH] ipc, sem: prevent possible deadlock
> 
> In semctl_main(), when cmd == GETALL, we're locking
> sma->sem_perm.lock (through sem_lock_and_putref), yet
> after the conditional, we lock it again.
> Unlock sma right after exiting the conditional.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> ---
>  ipc/sem.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 1a2913d..f257afe 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -1243,6 +1243,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
>  				err = -EIDRM;
>  				goto out_free;
>  			}
> +			sem_unlock(sma, -1);
>  		}
>  
>  		sem_lock(sma, NULL, -1);

Looks right. 

Do we need the locking at all?  What does it actually do?

			sem_lock_and_putref(sma);
			if (sma->sem_perm.deleted) {
				sem_unlock(sma, -1);
				err = -EIDRM;
				goto out_free;
			}
			sem_unlock(sma, -1);

We're taking the lock, testing an int and then dropping the lock. 
What's the point in that?

