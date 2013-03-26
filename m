Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045Ab3CZNTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:19:39 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35101
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933294Ab3CZNTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:19:39 -0400
Message-ID: <1364303965.5053.29.camel@laptop>
Subject: Re: [PATCH -mm -next] ipc,sem: fix lockdep false positive
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@surriel.com>, Sasha Levin <sasha.levin@oracle.com>,
        torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, lwoodman@redhat.com,
        chegu_vinod@hp.com, Dave Jones <davej@redhat.com>, benisty.e@gmail.com,
        Ingo Molnar <mingo@redhat.com>
Date: Tue, 26 Mar 2013 14:19:25 +0100
In-Reply-To: <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <5150B1C2.8090607@oracle.com>
	 <20130325163844.042a45ba@annuminas.surriel.com>
	 <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-25 at 14:42 -0700, Michel Lespinasse wrote:
> depth nesting here...
> Adding Peter & Ingo for advice about how to proceed

> > +++ b/ipc/sem.c
> > @@ -357,7 +357,7 @@ static inline int sem_lock(struct sem_array
> *sma, struct sembuf *sops,
> >                 spin_lock(&sma->sem_perm.lock);
> >                 for (i = 0; i < sma->sem_nsems; i++) {
> >                         struct sem *sem = sma->sem_base + i;
> > -                       spin_lock(&sem->lock);
> > +                       spin_lock_nested(&sem->lock,
> SINGLE_DEPTH_NESTING);
> >                 }
> >                 locknum = -1;
> >         }

Right, so as walken said, this isn't going to work right.

I need a little more information as I've not really paid much attention
to this stuff. Firstly, is there a limit to sem_nsems or is this a
random user specified number? Secondly do we care about lock order at
all, or is array order the only order that counts?



