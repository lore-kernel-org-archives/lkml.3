Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbaDKUdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:33:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58998 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbaDKUdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:33:44 -0400
Date: Fri, 11 Apr 2014 16:33:42 -0400 (EDT)
Message-Id: <20140411.163342.1319748709214614224.davem@davemloft.net>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jbenc@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, fweisbec@gmail.com
Subject: Re: [PATCH] softirq: punt to ksoftirqd if __do_softirq recently
 looped
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140410115706.662fb5e7@annuminas.surriel.com>
References: <20140410115706.662fb5e7@annuminas.surriel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Apr 2014 13:33:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>
Date: Thu, 10 Apr 2014 11:57:06 -0400

> @@ -330,7 +334,11 @@ void irq_enter(void)
>  
>  static inline void invoke_softirq(void)
>  {
> -	if (!force_irqthreads) {
> +	/*
> +	 * If force_irqthreads is set, or if we looped in __do_softirq this
> +	 * jiffie, punt to ksoftirqd to prevent userland starvation.
> +	 */
> +	if (!force_irqthreads && this_cpu_read(softirq_looped) != jiffies) {

If we do this, which I'm not convinced of yet, I think we should use two
jiffies as the cutoff.

Because if we are at the tail end of one jiffie we'll prematurely go to
ksoftirqd when we really have no reason to do so.
