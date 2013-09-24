Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3IXXa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 19:30:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:60662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab3IXXa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 19:30:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,974,1371106800"; 
   d="scan'208";a="408623546"
Subject: Re: [PATCH v5 1/6] rwsem: check the lock before cpmxchg in
 down_write_trylock
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <CAGQ1y=7okjk0AZaH-WNn33vkpyhT8Z-eNDJr1CiqW4jK9OnVFw@mail.gmail.com>
References: <cover.1380057198.git.tim.c.chen@linux.intel.com>
	 <1380061346.3467.50.camel@schen9-DESK>
	 <CAGQ1y=7okjk0AZaH-WNn33vkpyhT8Z-eNDJr1CiqW4jK9OnVFw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Sep 2013 16:30:19 -0700
Message-ID: <1380065419.3467.59.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-24 at 16:22 -0700, Jason Low wrote:
> Should we do something similar with __down_read_trylock, such as
> the following?
> 
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>
> ---
>  include/asm-generic/rwsem.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-generic/rwsem.h b/include/asm-generic/rwsem.h
> index bb1e2cd..47990dc 100644
> --- a/include/asm-generic/rwsem.h
> +++ b/include/asm-generic/rwsem.h
> @@ -42,6 +42,9 @@ static inline int __down_read_trylock(struct
> rw_semaphore *sem)
>         long tmp;
> 
>         while ((tmp = sem->count) >= 0) {
> +               if (sem->count != tmp)
> +                       continue;
> +

Considering that tmp has just been assigned the value of sem->count, the
added if check failure is unlikely and probably not needed.  We should
proceed to cmpxchg below.

>                 if (tmp == cmpxchg(&sem->count, tmp,
>                                    tmp + RWSEM_ACTIVE_READ_BIAS)) {
>                         return 1;

Tim

