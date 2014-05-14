Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaENWao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:30:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaENWan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:30:43 -0400
Date: Wed, 14 May 2014 15:30:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, 1vier1@web.de
Subject: Re: [PATCH 6/6] ipc/sem.c: make semctl(,,{GETNCNT,GETZCNT})
 standard compliant
Message-Id: <20140514153042.40e75ab7b63c0d32afa1e10c@linux-foundation.org>
In-Reply-To: <1400079158.9356.10.camel@buesod1.americas.hpqcorp.net>
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
	<1399716199-26776-2-git-send-email-manfred@colorfullife.com>
	<1399716199-26776-3-git-send-email-manfred@colorfullife.com>
	<1399716199-26776-4-git-send-email-manfred@colorfullife.com>
	<1399716199-26776-5-git-send-email-manfred@colorfullife.com>
	<1399716199-26776-6-git-send-email-manfred@colorfullife.com>
	<1399716199-26776-7-git-send-email-manfred@colorfullife.com>
	<1400079158.9356.10.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014 07:52:38 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:

> > --- a/ipc/sem.c
> > +++ b/ipc/sem.c
> > @@ -993,38 +993,33 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
> >  }
> >  
> >  /*
> > - * check_qop: Test how often a queued operation sleeps on the semaphore semnum
> > + * check_qop: Test if a queued operation sleeps on the semaphore semnum
> >   */
> >  static int check_qop(struct sem_array *sma, int semnum, struct sem_queue *q,
> >  			bool count_zero)
> >  {
> > -	struct sembuf *sops = q->sops;
> > -	int nsops = q->nsops;
> > -	int i, semcnt;
> > +	struct sembuf *sop = q->blocking;
> >  
> > -	semcnt = 0;
> > +	BUG_ON(sop->sem_flg & IPC_NOWAIT);
> > +	BUG_ON(sop->sem_op > 0);
> 
> Hmm in light of Linus' recent criticism about randomly sprinkling
> BUG_ONs in the kernel I'm not sure we want this. Yes, all those calls
> are correct from a logical pov and should never occur, however, would
> WARN be more suitable instead? I don't know. 

Well, this BUG_ON is so old that a decent approach would be to just
delete the thing, if only Manfred wasn't changing stuff.

Yes, if we can reasonably warn-then-recover then I guess that's worth
doing.

