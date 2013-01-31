Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3AaNKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:10:39 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:59311 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3AaNKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:10:37 -0500
Date: Thu, 31 Jan 2013 14:10:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Michel Lespinasse <walken@google.com>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] rwsem-spinlock: let rwsem write lock stealable
Message-ID: <20130131131032.GA6627@gmail.com>
References: <1359537244-20588-1-git-send-email-yuanhan.liu@linux.intel.com>
 <CANN689GwGh2sHwoP66JjoXs2ZMQAXbVpA0MHQahWq5M+baNfSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689GwGh2sHwoP66JjoXs2ZMQAXbVpA0MHQahWq5M+baNfSQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michel Lespinasse <walken@google.com> wrote:

> On Wed, Jan 30, 2013 at 1:14 AM, Yuanhan Liu
> <yuanhan.liu@linux.intel.com> wrote:
> > We(Linux Kernel Performance project) found a regression introduced by
> > commit 5a50508, which just convert all mutex lock to rwsem write lock.
> > The semantics is same, but the results is quite huge in some cases.
> > After investigation, we found the root cause: mutex support lock
> > stealing. Here is the link for the detailed regression report:
> >     https://lkml.org/lkml/2013/1/29/84
> >
> > Ingo suggests to add write lock stealing to rwsem as well:
> >     "I think we should allow lock-steal between rwsem writers - that
> >      will not hurt fairness as most rwsem fairness concerns relate to
> >      reader vs. writer fairness"
> >
> > I then tried it with rwsem-spinlock first as I found it much easier to
> > implement it than lib/rwsem.c. And here I sent out this patch first for
> > comments. I'd try lib/rwsem.c later once the change to rwsem-spinlock
> > is OK to you guys.
> 
> I noticed that you haven't modified __down_write_trylock() - for
> consistency with __down_write() you should replace
>         if (sem->activity == 0 && list_empty(&sem->wait_list)) {
> with
>         if (sem->activity == 0) {
> 
> Other than that, I like the idea. I was originally 
> uncomfortable with doing lock stealing for the rwsem, but I 
> think doing it for writers only as you propose should be fine. 
> Readers wait for any queued writers, and in exchange they are 
> guaranteed to get the lock once they've blocked. You *still* 
> want to check for regressions that this change might cause - 
> not with anon_vma as this was a mutex not long ago, but 
> possibly with mmap_sem - but I'm crossing my fingers and 
> thinking that it'll most likely turn out fine.

My gut feeling, from having implemented lock stealing in a 
number of locking primitives in the past, is that writer 
lock-stealing will be a measurable win for mmap_sem as well.

Thanks,

	Ingo
