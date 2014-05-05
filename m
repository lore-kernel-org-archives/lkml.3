Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbaEEObt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:31:49 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:58430 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575AbaEEObs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:31:48 -0400
Date: Mon, 5 May 2014 10:31:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] workqueue: async worker destruction
Message-ID: <20140505143128.GC11231@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398571754-12443-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 12:08:58PM +0800, Lai Jiangshan wrote:
> worker destruction includes these parts of code:
> 	adjust pool's stats
> 	remove the worker from idle list
> 	unbind the worker from the pool
> 	kthread_stop() to wait for the worker's task exit
> 	free the worker struct
> 
> We can find out that there is no essential thing to do after
> kthread_stop(). Which means destroy_worker() doesn't need
> to wait for the worker's task exit. So we can remove kthread_stop()
> and free the worker struct in the worker exiting path.
> 
> But put_unbound_pool() still needs to sync the all the workers'
> destruction before to destroy the pool. Otherwise the workers
> may access to the invalid pool when they are exiting.
> 
> So we also move the code of "unbind the worker" to the exiting
> path and let put_unbound_pool() to sync with this code via
> a wait_queue_head_t workers_unbound.
> 
> The code of "unbind the worker" is wrapped in a function "worker_unbind_pool()"
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |   44 ++++++++++++++++++++++++++++----------------
>  1 files changed, 28 insertions(+), 16 deletions(-)

Is this any simpler?  Does this enable larger simplification down the
road?

Thanks.

-- 
tejun
