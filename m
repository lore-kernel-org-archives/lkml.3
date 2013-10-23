Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3JWWR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 18:17:28 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46196 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab3JWWR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 18:17:26 -0400
MIME-Version: 1.0
In-Reply-To: <526844E6.1080307@codeaurora.org>
References: <526844E6.1080307@codeaurora.org>
Date: Wed, 23 Oct 2013 15:17:26 -0700
Message-ID: <CAA25o9T_FPQoymmC3j1p+FCtGhaqfzvG5qGVqw033kz3HPtYfQ@mail.gmail.com>
Subject: Re: zram/zsmalloc issues in very low memory conditions
From: Luigi Semenzato <semenzato@google.com>
To: Olav Haugan <ohaugan@codeaurora.org>
Cc: Minchan Kim <minchan@kernel.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry about the HTML in the previous message)

On Wed, Oct 23, 2013 at 2:51 PM, Olav Haugan <ohaugan@codeaurora.org> wrote:
> I am trying to use zram in very low memory conditions and I am having
> some issues. zram is in the reclaim path. So if the system is very low
> on memory the system is trying to reclaim pages by swapping out (in this
> case to zram). However, since we are very low on memory zram fails to
> get a page from zsmalloc and thus zram fails to store the page. We get
> into a cycle where the system is low on memory so it tries to swap out
> to get more memory but swap out fails because there is not enough memory
> in the system! The major problem I am seeing is that there does not seem
> to be a way for zram to tell the upper layers to stop swapping out
> because the swap device is essentially "full" (since there is no more
> memory available for zram pages). Has anyone thought about this issue
> already and have ideas how to solve this or am I missing something and I
> should not be seeing this issue?

What do you want the system to do at this point?  OOM kill?  Also, if
you are that low on memory, how are you preventing thrashing on the
code pages?

I am asking because we also use zram but haven't run into this
problem---however we had to deal with other problems that motivate
these questions.

>
> I am also seeing a couple other issues that I was wondering whether
> folks have already thought about:
>
> 1) The size of a swap device is statically computed when the swap device
> is turned on (nr_swap_pages). The size of zram swap device is dynamic
> since we are compressing the pages and thus the swap subsystem thinks
> that the zram swap device is full when it is not really full. Any
> plans/thoughts about the possibility of being able to update the size
> and/or the # of available pages in a swap device on the fly?

That is a known limitation of zram.  If you can predict your
compression ratio and your working set size, it's not a big problem:
allocate a swap device which, based on the expected compression ratio,
will use up RAM until what's left is just enough for the working set.

> 2) zsmalloc fails when the page allocated is at physical address 0 (pfn
> = 0) since the handle returned from zsmalloc is encoded as (<PFN>,
> <obj_idx>) and thus the resulting handle will be 0 (since obj_idx starts
> at 0). zs_malloc returns the handle but does not distinguish between a
> valid handle of 0 and a failure to allocate. A possible solution to this
> would be to start the obj_idx at 1. Is this feasible?
>
> Thanks,
>
> Olav Haugan
>
> --
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
