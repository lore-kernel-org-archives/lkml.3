Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab3GaXOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 19:14:43 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:35136 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3GaXOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 19:14:40 -0400
MIME-Version: 1.0
In-Reply-To: <51F999DE.7080200@redhat.com>
References: <20130731174335.006a58f9@annuminas.surriel.com>
 <CA+55aFx3ZHZrgP3yQwb=ttYUeH1zFVQtUA5dFW1h8FPhjfKgUA@mail.gmail.com>
 <51F98CAB.80100@redhat.com> <CA+55aFwj+6P4y8MgGTGbiK_EtfY7LJ_bL_7k9zFYLx4S8F0rJQ@mail.gmail.com>
 <51F99218.4060104@redhat.com> <CA+55aFxKSEHSkdsCkTvjwwo4MnEpN0TwJrek2jd1QJCyUTb-=Q@mail.gmail.com>
 <51F999DE.7080200@redhat.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 31 Jul 2013 16:14:09 -0700
Message-ID: <CAPM31R+BiTiLbNrD+33q31z8Ww7dpm7t1vcLak-hZ-z5L2PY-g@mail.gmail.com>
Subject: Re: [PATCH] sched,x86: optimize switch_mm for multi-threaded workloads
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, Peter Anvin <hpa@zytor.com>, dzickus@redhat.com,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We attached the following explanatory comment to our version of the patch:

/*
* In the common case (two user threads sharing mm
* switching) the bit will be set; avoid doing a write
* (via atomic test & set) unless we have to.  This is
* safe, because no other CPU ever writes to our bit
* in the mask, and interrupts are off (so we can't
* take a TLB IPI here.)  If we don't do this, then
* switching threads will pingpong the cpumask
* cacheline.
*/

On Wed, Jul 31, 2013 at 4:12 PM, Rik van Riel <riel@redhat.com> wrote:
> On 07/31/2013 06:46 PM, Linus Torvalds wrote:
>>
>>
>> On Jul 31, 2013 3:39 PM, "Rik van Riel" <riel@redhat.com
>>
>> <mailto:riel@redhat.com>> wrote:
>>  >
>>  > On 07/31/2013 06:21 PM, Linus Torvalds wrote:
>>  >>
>>  >> Ummm.. The race is to the testing of the bit, not setting. The testing
>>  >> of the bit is not valid before we have set the tlb state, AFAIK.
>>  >
>>  >
>>  > I believe the bit is cleared and set by the current CPU.
>>
>> Yes, but we need to be careful with interrupts.
>>
>>
>>  > Interrupts are blocked inside switch_mm, so I think we
>>  > are safe.
>>
>> Are they? I thought we removed all that.
>
>
> context_switch() shows that the runqueue lock (which is an irq
> lock) is released, and irqs re-enabled, by the next task, after
> switch_to(), in finish_lock_switch(), called from finish_task_switch()
>
>> Note that switch_mm gets called for activate_mm too, or something.
>
>
> Good catch, though it looks like activate_mm is only called from
> exec_mmap, with the new mm as its argument.  While the new mm can
> have pages in memory yet, it has never been run so there should
> be nothing in the TLB yet for the new mm.
>
> This is subtler than I thought, but it does appear to be safe.
>
>
> --
> All rights reversed
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
