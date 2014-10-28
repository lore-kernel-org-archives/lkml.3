Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbaJ1PSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:18:43 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:52617 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaJ1PSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:18:41 -0400
MIME-Version: 1.0
In-Reply-To: <1414496662-25202-3-git-send-email-will.deacon@arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
	<1414496662-25202-3-git-send-email-will.deacon@arm.com>
Date: Tue, 28 Oct 2014 08:18:39 -0700
X-Google-Sender-Auth: bbZETy1VtYSfuAzWOqwrEOf0g8Q
Message-ID: <CA+55aFxGZHzOq260=JbZOFP10=aDwhi6G9O+jaA8tM4_c2-t=A@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] zap_pte_range: fix partial TLB flushing in
 response to a dirty pte
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 4:44 AM, Will Deacon <will.deacon@arm.com> wrote:
> @@ -1194,11 +1194,10 @@ again:
>                  * then update the range to be the remaining
>                  * TLB range.
>                  */
> -               old_end = tlb->end;
> -               tlb->end = addr;
> +               tlb->end = old_end = min(tlb->end, addr);
>                 tlb_flush_mmu_tlbonly(tlb);
> -               tlb->start = addr;
> -               tlb->end = old_end;
> +               tlb->start = old_end;
> +               tlb->end = end;

I don't think this is right. Setting "tlb->end = end" looks very wrong
indeed, because "end" here inside zap_pte_range() is *not* the final
end of the zap range, it is just the end of the current set of pte's.

There's a reason the old code *saved* the old end value. You've now
ripped that out, and use the "old_end" for something else entirely.

Your arm64 version of tlb_add_flush() then hides the bug you just
introduced by updating the end range for each page you encounter. But
quite frankly, I think your problems are all fundamental to that very
issue. You're playing games with start/end during the TLB flush
itself, which is not how those things were designed to work.

So now you break everything that *doesn't* do your arm games.

                   Linus
