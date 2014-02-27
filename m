Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaB0F22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:28:28 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:32175 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaB0F21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:28:27 -0500
Message-ID: <1393478904.3884.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 1/2] asm-generic: rwsem: ensure sem->cnt is only
 accessed via atomic_long_*
From: Davidlohr Bueso <davidlohr@hp.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, rkuo@codeaurora.org, arnd@arndb.de,
        paulus@samba.org
Date: Wed, 26 Feb 2014 21:28:24 -0800
In-Reply-To: <1393003347-24958-1-git-send-email-will.deacon@arm.com>
References: <1393003347-24958-1-git-send-email-will.deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 17:22 +0000, Will Deacon wrote:
> The asm-generic rwsem implementation directly acceses sem->cnt when
> performing a __down_read_trylock operation. Whilst this is probably safe
> on all architectures, we should stick to the atomic_long_* API and use
> atomic_long_read instead.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  include/asm-generic/rwsem.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/asm-generic/rwsem.h b/include/asm-generic/rwsem.h
> index bb1e2cdeb9bf..75af612f54f8 100644
> --- a/include/asm-generic/rwsem.h
> +++ b/include/asm-generic/rwsem.h
> @@ -41,7 +41,7 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
>  {
>  	long tmp;
>  
> -	while ((tmp = sem->count) >= 0) {
> +	while ((tmp = atomic_long_read((atomic_long_t *)&sem->count)) >= 0) {

That's pretty ugly, how about having infinite look and just do the tmp
assign separately from the conditional?

It also looks like a cpu_relax() could help here between iterations.
Other than that:

Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>

