Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3F0DxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 23:53:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58575 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3F0DxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 23:53:00 -0400
Message-ID: <1372305134.5871.5.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH RT 1/6] rt,rcu: Have rcu_read_lock_sched() use
 locks for PREEMPT_RT
From: Mike Galbraith <bitbucket@online.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 27 Jun 2013 05:52:14 +0200
In-Reply-To: <20130626193049.724948276@goodmis.org>
References: <20130626192806.107564905@goodmis.org>
	 <20130626193049.724948276@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:KGq2eM4xpBFRp2y+5++MTYOJGPVgEI/8PbS1NhFhkem
 01UP++Ma+9/29ZtsIbT/XwkV4bOmieCZNz9JDRBEVXb07GMGtS
 +dh7NkKknfDBkOE/jhQSETz4eUlthFDEkfMBBjke7bs6Jnfzao
 dYkGLbsaxxQSUKdV9QRb2A1uBBAWF3g+9lAmh3q+Q6USsJOInO
 CbP7xJ44TIwuDdmAsH6FGt/LhH9AemibhYA/5B2iPVNMluVURt
 AdLJGT2H0sGUwui+r5Q5pv4y37s0nyeGw7TYaRZG4f/nyVCQJX
 bEd4inmlGyr/9zKT9bG1vZ+86sc6lt44F7SO7lDc+/ER2pO8vI
 2i0pCExjXme0xpg/tJa32uTukKd0nOVF0BIgwcK+zZC1gt85h9
 43NxrMY7rJfOg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 15:28 -0400, Steven Rostedt wrote:

> @@ -2491,6 +2491,31 @@ static inline int rcu_blocking_is_gp(voi
>  	return ret;
>  }
>  
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +DEFINE_LOCAL_IRQ_LOCK(rcu_sched_lock);
> +/*
> + * Real-time allows for synchronize sched to sleep but not migrate.
> + * This is done via the local locks. When calling synchronize_sched(),
> + * all the local locks need to be taken and released. This will ensure
> + * that all users of rcu_read_lock_sched() will be out of their critical
> + * sections at the completion of this function. synchronize_sched() will
> + * still perform the normal RCU sched operations to synchronize with
> + * locations that use disabling preemption or interrupts.
> + */
> +static void rcu_synchronize_sched_rt(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		spin_lock(&per_cpu(rcu_sched_lock, cpu).lock);
> +		spin_unlock(&per_cpu(rcu_sched_lock, cpu).lock);
> +	}
> +}

Does that have to be possible vs online?

-Mike

