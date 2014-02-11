Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaBKRRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:17:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbaBKRRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:17:22 -0500
Date: Tue, 11 Feb 2014 18:15:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Toshi Kani <toshi.kani@hp.com>, paulus@samba.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of
	callback registration functions
Message-ID: <20140211171553.GA26036@redhat.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com> <1392081980.5612.123.camel@misato.fc.hp.com> <52F9ED11.5010800@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F9ED11.5010800@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11, Srivatsa S. Bhat wrote:
>
> +static DECLARE_RWSEM(cpu_hotplug_rwsem);
> +
> +void cpu_notifier_register_begin(void)
> +{
> +	down_read(&cpu_hotplug_rwsem);
> +}
> +
> +void cpu_notifier_register_end(void)
> +{
> +	up_read(&cpu_hotplug_rwsem);
> +}
> +
>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
>  static DEFINE_MUTEX(cpu_add_remove_lock);
>  
> @@ -32,12 +45,14 @@ static DEFINE_MUTEX(cpu_add_remove_lock);
>   */
>  void cpu_maps_update_begin(void)
>  {
> +	down_write(&cpu_hotplug_rwsem);
>  	mutex_lock(&cpu_add_remove_lock);
>  }
>  
>  void cpu_maps_update_done(void)
>  {
>  	mutex_unlock(&cpu_add_remove_lock);
> +	up_write(&cpu_hotplug_rwsem);
>  }

I am a bit confused... If we do this, why we can't simply turn
cpu_add_remove_lock into rw_semaphore?

Oleg.

