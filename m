Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab3GaXMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 19:12:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab3GaXMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 19:12:36 -0400
Message-ID: <51F999DE.7080200@redhat.com>
Date: Wed, 31 Jul 2013 19:12:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, Peter Anvin <hpa@zytor.com>, dzickus@redhat.com,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched,x86: optimize switch_mm for multi-threaded workloads
References: <20130731174335.006a58f9@annuminas.surriel.com> <CA+55aFx3ZHZrgP3yQwb=ttYUeH1zFVQtUA5dFW1h8FPhjfKgUA@mail.gmail.com> <51F98CAB.80100@redhat.com> <CA+55aFwj+6P4y8MgGTGbiK_EtfY7LJ_bL_7k9zFYLx4S8F0rJQ@mail.gmail.com> <51F99218.4060104@redhat.com> <CA+55aFxKSEHSkdsCkTvjwwo4MnEpN0TwJrek2jd1QJCyUTb-=Q@mail.gmail.com>
In-Reply-To: <CA+55aFxKSEHSkdsCkTvjwwo4MnEpN0TwJrek2jd1QJCyUTb-=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 06:46 PM, Linus Torvalds wrote:
>
> On Jul 31, 2013 3:39 PM, "Rik van Riel" <riel@redhat.com
> <mailto:riel@redhat.com>> wrote:
>  >
>  > On 07/31/2013 06:21 PM, Linus Torvalds wrote:
>  >>
>  >> Ummm.. The race is to the testing of the bit, not setting. The testing
>  >> of the bit is not valid before we have set the tlb state, AFAIK.
>  >
>  >
>  > I believe the bit is cleared and set by the current CPU.
>
> Yes, but we need to be careful with interrupts.
>
>  > Interrupts are blocked inside switch_mm, so I think we
>  > are safe.
>
> Are they? I thought we removed all that.

context_switch() shows that the runqueue lock (which is an irq
lock) is released, and irqs re-enabled, by the next task, after
switch_to(), in finish_lock_switch(), called from finish_task_switch()

> Note that switch_mm gets called for activate_mm too, or something.

Good catch, though it looks like activate_mm is only called from
exec_mmap, with the new mm as its argument.  While the new mm can
have pages in memory yet, it has never been run so there should
be nothing in the TLB yet for the new mm.

This is subtler than I thought, but it does appear to be safe.

-- 
All rights reversed
