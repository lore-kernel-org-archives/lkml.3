Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146AbaG2Ebz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 00:31:55 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:49233 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaG2Eby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 00:31:54 -0400
Message-ID: <1406608312.31161.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH -tip/master v2] locking/mutex: Refactor optimistic
 spinning code
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2014 21:31:52 -0700
In-Reply-To: <1406605299.2411.59.camel@j-VirtualBox>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
	 <1406524724-17946-4-git-send-email-davidlohr@hp.com>
	 <1406602517.31161.2.camel@buesod1.americas.hpqcorp.net>
	 <1406605299.2411.59.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-28 at 20:41 -0700, Jason Low wrote:
> On Mon, 2014-07-28 at 19:55 -0700, Davidlohr Bueso wrote:
> > +static bool mutex_optimistic_spin(struct mutex *lock,
> > +				  struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
> > +{
> > +	struct task_struct *task = current;
> > +
> > +	if (!mutex_can_spin_on_owner(lock))
> > +		return false;
> > +
> > +	if (!osq_lock(&lock->osq))
> > +		return false;
> 
> In the !osq_lock() case, we could exit the cancellable MCS spinlock due
> to need_resched(). However, this would return from the function rather
> than doing the need_resched() check below. Perhaps we can add something
> like "goto out" which goes to the below check?

Ah, yes. This used to be a goto slowpath. It would have served the other
way around, if having the need_resched() check outside of
mutex_optimistic_spin().

