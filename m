Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3AaMjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:39:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:51746 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab3AaMjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:39:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,576,1355126400"; 
   d="scan'208";a="280813725"
Date: Thu, 31 Jan 2013 20:40:04 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] rwsem-spinlock: let rwsem write lock stealable
Message-ID: <20130131124004.GA12678@yliu-dev.sh.intel.com>
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

On Thu, Jan 31, 2013 at 03:57:51AM -0800, Michel Lespinasse wrote:
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

Yes, my bad for missing that. Thanks a lot for pointing it out. Will fix it.
> 
> Other than that, I like the idea. I was originally uncomfortable with
> doing lock stealing for the rwsem, but I think doing it for writers
> only as you propose should be fine. Readers wait for any queued
> writers, and in exchange they are guaranteed to get the lock once
> they've blocked.

> You *still* want to check for regressions that this
> change might cause - not with anon_vma as this was a mutex not long
> ago, but possibly with mmap_sem

Yes. Well, at least it passed Fengguang's 0-DAY test, which did lots
of tests on almost all ARCHs. Well, you reminds me that I just enabled
RWSEM_GENERIC_SPINLOCK for x86 ARCH, thus I need to enable
RWSEM_GENERIC_SPINLOCK to all ARCHs and do test again.

BTW, mind to tell a nice test case for mmap_sem?

> - but I'm crossing my fingers and
> thinking that it'll most likely turn out fine.

Thanks!

> 
> I may be able to help with the non-spinlock version of this as I still
> remember how this works.

That would be great! Especially I will have vacation soon for Chinese
New Year.


	--yliu
