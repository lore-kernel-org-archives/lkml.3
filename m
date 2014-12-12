Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031154AbaLLR3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:29:54 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:51021 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030845AbaLLR3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:29:52 -0500
Date: Fri, 12 Dec 2014 12:29:48 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 5/5] workqueue: retry on NUMA_NO_NODE when
 create_worker() fails
Message-ID: <20141212172948.GE20020@htj.dyndns.org>
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
 <1418379595-6281-6-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418379595-6281-6-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 06:19:55PM +0800, Lai Jiangshan wrote:
...
>  fail:
> -	if (id >= 0)
> -		ida_simple_remove(&pool->worker_ida, id);
> +	if (node != NUMA_NO_NODE) {
> +		node = NUMA_NO_NODE;
> +		goto again;
> +	}
> +	ida_simple_remove(&pool->worker_ida, id);

The retry seems too general for the problem case it's trying to solve.
Can we interlock it properly with node offline event?  On node
offline, grab pool_mutex and clear all pool->node's which match the
node which is going down and take it off circulation.

Thanks.

-- 
tejun
