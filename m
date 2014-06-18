Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350AbaFRCg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 22:36:59 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:32527 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932118AbaFRCg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 22:36:58 -0400
X-IronPort-AV: E=Sophos;i="5.00,729,1396972800"; 
   d="scan'208";a="32064328"
Message-ID: <53A0FB69.2040901@cn.fujitsu.com>
Date: Wed, 18 Jun 2014 10:37:29 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cl@linux-foundation.org>, <kmo@daterainc.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] percpu-refcount: one bit is enough for REF_STATUS
References: <1403053685-28240-1-git-send-email-tj@kernel.org> <1403053685-28240-3-git-send-email-tj@kernel.org>
In-Reply-To: <1403053685-28240-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 09:08 AM, Tejun Heo wrote:
> percpu-refcount currently reserves two lowest bits of its percpu
> pointer to indicate its state; however, only one bit is used for
> PCPU_REF_DEAD.
> 
> Simplify it by removing PCPU_STATUS_BITS/MASK and testing
> PCPU_REF_DEAD directly.  This also allows the compiler to choose a
> more efficient instruction depending on the architecture.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kent Overstreet <kmo@daterainc.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> ---
>  include/linux/percpu-refcount.h | 4 +---
>  lib/percpu-refcount.c           | 2 +-
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
> index 5d8920e..bfdeb0d4 100644
> --- a/include/linux/percpu-refcount.h
> +++ b/include/linux/percpu-refcount.h
> @@ -88,12 +88,10 @@ static inline void percpu_ref_kill(struct percpu_ref *ref)
>  	return percpu_ref_kill_and_confirm(ref, NULL);
>  }
>  
> -#define PCPU_STATUS_BITS	2

Just using "#define PCPU_STATUS_BITS	1" can achieve exactly the same
result as you need. And it is better for future extensions for the status.

Anyway,
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

> -#define PCPU_STATUS_MASK	((1 << PCPU_STATUS_BITS) - 1)
>  #define PCPU_REF_PTR		0
>  #define PCPU_REF_DEAD		1
>  
> -#define REF_STATUS(count)	(((unsigned long) count) & PCPU_STATUS_MASK)
> +#define REF_STATUS(count)	(((unsigned long) count) & PCPU_REF_DEAD)
>  
>  /**
>   * percpu_ref_get - increment a percpu refcount
> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> index 963b703..17bce2b 100644
> --- a/lib/percpu-refcount.c
> +++ b/lib/percpu-refcount.c
> @@ -96,7 +96,7 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
>  
>  	/* Mask out PCPU_REF_DEAD */
>  	pcpu_count = (unsigned __percpu *)
> -		(((unsigned long) pcpu_count) & ~PCPU_STATUS_MASK);
> +		(((unsigned long) pcpu_count) & ~PCPU_REF_DEAD);
>  
>  	for_each_possible_cpu(cpu)
>  		count += *per_cpu_ptr(pcpu_count, cpu);

