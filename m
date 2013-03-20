Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab3CTSKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:10:25 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54772 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab3CTSKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:10:24 -0400
Date: Wed, 20 Mar 2013 11:10:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/21] workqueue: remove worker_maybe_bind_and_lock()
Message-ID: <20130320181010.GA30484@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
 <1363721306-2030-16-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363721306-2030-16-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 03:28:15AM +0800, Lai Jiangshan wrote:
>  static struct worker *alloc_worker(void)
>  {
>  	struct worker *worker;
> @@ -2326,7 +2262,8 @@ repeat:
>  		spin_unlock_irq(&wq_mayday_lock);
>  
>  		/* migrate to the target cpu if possible */
> -		worker_maybe_bind_and_lock(pool);
> +		set_cpus_allowed_ptr(current, pool->attrs->cpumask);
> +		spin_lock_irq(&pool->lock);
>  		rescuer->pool = pool;

You can't do this.  The CPU might go up between set_cpus_allowed_ptr()
and spin_lock_irq() and the rescuer can end up executing a work item
which was issued while the target CPU is up on the wrong CPU.

Thanks.

-- 
tejun
