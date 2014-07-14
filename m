Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbaGNRay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:30:54 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57344 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbaGNRaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:30:46 -0400
Message-ID: <53C413C3.7050308@kernel.dk>
Date: Mon, 14 Jul 2014 19:30:43 +0200
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Robert Elliot <Elliott@hp.com>
CC: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] aio: protect reqs_available updates from changes in interrupt
 handlers
References: <20140714171227.GC11326@kvack.org>
In-Reply-To: <20140714171227.GC11326@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-14 19:12, Benjamin LaHaise wrote:
> Hello everyone,
>
> Please pull the following commit (263782c1c95bbddbb022dc092fd89a36bb8d5577)
> from git://git.kvack.org/aio-fixes.git to fix an aio bug reported by Robert
> Elliot.
> ---
> As of commit f8567a3845ac05bb28f3c1b478ef752762bd39ef it is now possible to
> have put_reqs_available() called from irq context.  While put_reqs_available()
> is per cpu, it did not protect itself from interrupts on the same CPU.  This
> lead to aio_complete() corrupting the available io requests count when run
> under a heavy O_DIRECT workloads as reported by Robert Elliott.  Fix this by
> disabling irq updates around the per cpu batch updates of reqs_available.
>
> Many thanks to Robert and folks for testing and tracking this down.
>
> Reported-by: Robert Elliot <Elliott@hp.com>
> Tested-by: Robert Elliot <Elliott@hp.com>
> Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
> Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
> Cc: stable@vger.kenel.org
> ---
>   fs/aio.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 955947e..1c9c5f0 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -830,16 +830,20 @@ void exit_aio(struct mm_struct *mm)
>   static void put_reqs_available(struct kioctx *ctx, unsigned nr)
>   {
>   	struct kioctx_cpu *kcpu;
> +	unsigned long flags;
>
>   	preempt_disable();
>   	kcpu = this_cpu_ptr(ctx->cpu);
>
> +	local_irq_save(flags);
>   	kcpu->reqs_available += nr;

Why not just makes this:

	local_irq_save(flags);
	kcpu = this_put_ptr(...);
	...

and get rid of the preemption bits, it's a bit redundant now you need to 
kill local interrupts anyway.

-- 
Jens Axboe

