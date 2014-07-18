Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653AbaGRWwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:52:05 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:58339 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbaGRWwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:52:03 -0400
Date: Fri, 18 Jul 2014 18:51:59 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: detach rescuer from pool until the last
Message-ID: <20140718225159.GB5739@htj.dyndns.org>
References: <1405493811-26203-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405493811-26203-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 16, 2014 at 02:56:50PM +0800, Lai Jiangshan wrote:
> @@ -2300,11 +2300,6 @@ repeat:
>  				move_linked_works(work, scheduled, &n);
>  
>  		process_scheduled_works(rescuer);
> -		spin_unlock_irq(&pool->lock);
> -
> -		worker_detach_from_pool(rescuer, pool);
> -
> -		spin_lock_irq(&pool->lock);
>  
>  		/*
>  		 * Put the reference grabbed by send_mayday().  @pool won't
> @@ -2322,8 +2317,11 @@ repeat:
>  			wake_up_worker(pool);
>  
>  		rescuer->pool = NULL;
> -		spin_unlock(&pool->lock);
> -		spin_lock(&wq_mayday_lock);
> +		spin_unlock_irq(&pool->lock);
> +
> +		worker_detach_from_pool(rescuer, pool);
> +
> +		spin_lock_irq(&wq_mayday_lock);

Can you please also update the comment above put_pwq() and explain
above detach that @pool will stay around till detach is complete?

Thanks.

-- 
tejun
