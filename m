Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3I0UQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 16:16:22 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:57908 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3I0UQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 16:16:20 -0400
MIME-Version: 1.0
In-Reply-To: <1380310733.3467.118.camel@schen9-DESK>
References: <cover.1380144003.git.tim.c.chen@linux.intel.com>
	<1380147049.3467.67.camel@schen9-DESK>
	<20130927152953.GA4464@linux.vnet.ibm.com>
	<1380310733.3467.118.camel@schen9-DESK>
Date: Fri, 27 Sep 2013 13:16:16 -0700
X-Google-Sender-Auth: XwuijNV90NKB3-X_OL6kp2JxvjU
Message-ID: <CAGQ1y=7bvd00iU_0byqmVAe5NoEJ=SwkVbdbcj8+O6=Bh27jzQ@mail.gmail.com>
Subject: Re: [PATCH v6 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
From: Jason Low <jason.low2@hp.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 12:38 PM, Tim Chen <tim.c.chen@linux.intel.com> wrote:

> BTW, is the above memory barrier necessary?  It seems like the xchg
> instruction already provided a memory barrier.
>
> Now if we made the changes that Jason suggested:
>
>
>         /* Init node */
> -       node->locked = 0;
>         node->next   = NULL;
>
>         prev = xchg(lock, node);
>         if (likely(prev == NULL)) {
>                 /* Lock acquired */
> -               node->locked = 1;
>                 return;
>         }
> +       node->locked = 0;
>         ACCESS_ONCE(prev->next) = node;
>         smp_wmb();
>
> We are probably still okay as other cpus do not read the value of
> node->locked, which is a local variable.

Similarly, I was wondering if we should also move smp_wmb() so that it
is before the ACCESS_ONCE(prev->next) = node and after the
node->locked = 0. Would we want to guarantee that the node->locked
gets set before it is added to the linked list where a previous thread
calling mcs_spin_unlock() would potentially modify node->locked?
