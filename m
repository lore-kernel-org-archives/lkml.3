Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab3AXASZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 19:18:25 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:42413 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab3AXASS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:18:18 -0500
Subject: Re: [RFC PATCH 4/6] kernel: faster queue spinlock implementation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1358896415-28569-5-git-send-email-walken@google.com>
References: <1358896415-28569-1-git-send-email-walken@google.com>
	 <1358896415-28569-5-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Jan 2013 16:18:14 -0800
Message-ID: <1358986694.12374.1267.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 15:13 -0800, Michel Lespinasse wrote:
>  {
> -	__q_spin_unlock(lock, node);
> -	preempt_enable_no_resched();
> -	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
> +	unsigned int cpu, i;
> +	struct q_spinlock_token *token;
> +	for_each_possible_cpu(cpu)
> +		for (i = 0; i < 2; i++) {
> +			token = kmalloc(sizeof(struct q_spinlock_alloc_token),
> +					GFP_KERNEL);
> +			BUG_ON(!token);
> +			token->wait = false;
> +			per_cpu(q_spinlock_token[i], cpu) = token;
> +		}

You might use kmalloc_node(...   , cpu_to_node(cpu)) to spread these
tokens on all nodes.


