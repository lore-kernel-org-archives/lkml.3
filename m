Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbaHEFai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 01:30:38 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:39458 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaHEFag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 01:30:36 -0400
Message-ID: <1407216632.2566.22.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 4/7] locking/rwsem: threshold limited spinning for
 active readers
From: Davidlohr Bueso <davidlohr@hp.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Date: Mon, 04 Aug 2014 22:30:32 -0700
In-Reply-To: <1407214461.2566.14.camel@buesod1.americas.hpqcorp.net>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
	 <1407119782-41119-5-git-send-email-Waiman.Long@hp.com>
	 <1407214461.2566.14.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-04 at 21:54 -0700, Davidlohr Bueso wrote:
> >  #ifdef CONFIG_RWSEM_SPIN_ON_OWNER
> > +/*
> > + * The owner field is set to RWSEM_READ_OWNED if the last owner(s) are
> > + * readers. It is not reset until a writer takes over and set it to its
> > + * task structure pointer or NULL when it frees the lock. So a value
> > + * of RWSEM_READ_OWNED doesn't mean it currently has active readers.
> > + */
> > +#define RWSEM_READ_OWNED	((struct task_struct *)-1)
> 
> Looks rather weird...

Instead of populating owner when taking the reader lock, why not just
leave it NULL. Then, we can differentiate between the owner being NULL
either because it is taken by reader(s) or simply because it is not
taken. So something like this:

static inline bool rwsem_owner_is_reader(struct rw_semaphore *sem)
{
	return !sem->owner && rwsem_is_locked(sem));
}

