Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaHNBDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 21:03:51 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:45878 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaHNBDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 21:03:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140814003559.GG4752@linux.vnet.ibm.com>
References: <CAJhHMCADiEsUC7GsYF7=qMNEyRJerfhC5zh7WQPgkQ0gJn5=5A@mail.gmail.com>
 <20140804185226.GQ8101@linux.vnet.ibm.com> <CAJhHMCBEprK9hp786cwguJR=JW7Xxgt4GKX5=E0vikO-D4qmZg@mail.gmail.com>
 <20140805073237.GX3935@laptop> <CAJhHMCBjub+_Gg_wC2EoR5OgzwT7JTHr-wzoGp_dePUBVwEG8g@mail.gmail.com>
 <20140813224436.GA4752@linux.vnet.ibm.com> <53EBFE6E.1060400@gmail.com> <20140814003559.GG4752@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 13 Aug 2014 21:03:18 -0400
Message-ID: <CAJhHMCBes7Y2x-=M7or13_m07fR4+RBV4KMUpiZJVB0f9CPaqA@mail.gmail.com>
Subject: Re: Question regarding "Control Dependencies" in memory-barriers.txt
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 8:35 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>>
>> If the stores to 'b' differ, then there is no issue. Why not document how to
>> avoid re-ordering in the case where both the stores are the same? In that case
>> using a stronger barrier like mb() should be sufficient for both the compiler
>> and the CPU to avoid re-ordering, right?
>
> Like this?  (On top of the earlier patch.)
>

That looks good, thank you!


>                                                         Thanx, Paul
>
> ------------------------------------------------------------------------
>
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index 6062f175abc6..22a969cdd476 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -625,9 +625,20 @@ Now there is no conditional between the load from 'a' and the store to
>  'b', which means that the CPU is within its rights to reorder them:
>  The conditional is absolutely required, and must be present in the
>  assembly code even after all compiler optimizations have been applied.
> +Therefore, if you need ordering in this example, you need explicit
> +memory barriers, for example, smp_store_release():
>
> -So two-legged-if control ordering is guaranteed only when the stores
> -differ, for example:
> +       q = ACCESS_ONCE(a);
> +       if (q) {
> +               smp_store_release(&b, p);
> +               do_something();
> +       } else {
> +               smp_store_release(&b, p);
> +               do_something_else();
> +       }
> +
> +In contrast, without explicit memory barriers, two-legged-if control
> +ordering is guaranteed only when the stores differ, for example:
>
>         q = ACCESS_ONCE(a);
>         if (q) {
>

-- 
Pranith
