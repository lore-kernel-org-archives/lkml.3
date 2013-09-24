Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750801Ab3IXH2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 03:28:51 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:47643 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3IXH2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 03:28:49 -0400
Date: Tue, 24 Sep 2013 09:28:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [pchecks v1 2/4] Use raw cpu ops for calls that would trigger
 with checks
Message-ID: <20130924072845.GC28538@gmail.com>
References: <20130923191256.584672290@linux.com>
 <000001414c3d064a-ebe0610b-6951-4a74-bd33-8480e3e1e364-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001414c3d064a-ebe0610b-6951-4a74-bd33-8480e3e1e364-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> These location triggered during testing with KVM.
> 
> These are fetches without preemption off where we judged that
> to be more performance efficient or where other means of
> providing synchronization (BH handling) are available.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/include/linux/topology.h
> ===================================================================
> --- linux.orig/include/linux/topology.h	2013-09-12 13:26:29.216103951 -0500
> +++ linux/include/linux/topology.h	2013-09-12 13:41:30.762358687 -0500
> @@ -182,7 +182,7 @@ DECLARE_PER_CPU(int, numa_node);
>  /* Returns the number of the current Node. */
>  static inline int numa_node_id(void)
>  {
> -	return __this_cpu_read(numa_node);
> +	return raw_cpu_read(numa_node);
>  }
>  #endif
>  
> @@ -239,7 +239,7 @@ static inline void set_numa_mem(int node
>  /* Returns the number of the nearest Node with memory */
>  static inline int numa_mem_id(void)
>  {
> -	return __this_cpu_read(_numa_mem_);
> +	return raw_cpu_read(_numa_mem_);
>  }

These are generic primitives used in quite a few places and it can easily 
be a bug to use numa_node_id() in a preemptible section - and this patch 
would hide that fact.

So the correct way to do it is to have checking in these and to introduce 
raw_numa_node_id()/raw_numa_mem_id() and change eventual KVM (and any 
other) preemptible-section use of numa_node_id() to raw_numa_node_id() and 
explain why it's safe to do it.

Thanks,

	Ingo
