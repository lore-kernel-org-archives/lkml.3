Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbaFIJFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:05:48 -0400
Received: from imp02.mtu.ru ([62.5.255.19]:44522 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964897AbaFIJFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:05:43 -0400
X-Spam-Flag: NO
Message-ID: <53957896.6020907@pavlinux.ru>
Date: Mon, 09 Jun 2014 13:04:22 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
CC: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] rt/aio: fix rcu garbage collection might_sleep()
 splat
References: <1402216538.31630.7.camel@marge.simpson.net>	 <5395172E.4010007@cn.fujitsu.com>	 <1402283822.5195.3.camel@marge.simpson.net> <1402294928.6316.38.camel@marge.simpson.net>
In-Reply-To: <1402294928.6316.38.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

09.06.2014 10:22, Mike Galbraith пишет:
> On Mon, 2014-06-09 at 05:17 +0200, Mike Galbraith wrote:
>> On Mon, 2014-06-09 at 10:08 +0800, Lai Jiangshan wrote:
>>> Hi, rt-people

> @@ -522,7 +524,9 @@ static void free_ioctx_users(struct perc
>   	struct kioctx *ctx = container_of(ref, struct kioctx, users);
>   	struct kiocb *req;
>
> +	preempt_enable_rt();
>   	spin_lock_irq(&ctx->ctx_lock);
> +	local_irq_disable_rt();
>
>   	while (!list_empty(&ctx->active_reqs)) {
>   		req = list_first_entry(&ctx->active_reqs,
> @@ -536,6 +540,8 @@ static void free_ioctx_users(struct perc
>
>   	percpu_ref_kill(&ctx->reqs);
>   	percpu_ref_put(&ctx->reqs);
> +	preempt_disable_rt();
> +	local_irq_enable_rt();


I think, enable_/disable_ must be as mirror reflections


     preempt_enable_rt();
         local_irq_disable_rt();

                 do_something();

         local_irq_enable_rt();
     preempt_disable_rt();



-- 

                                                          Pavel.
