Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059Ab3FYEOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 00:14:33 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:39554 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3FYEOb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 00:14:31 -0400
Date: Mon, 24 Jun 2013 23:14:27 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC 1/2] x86_64, mm: Delay initializing large portion of
 memory
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: holt@sgi.com, travis@sgi.com, nzimmer@sgi.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1371831934-156971-2-git-send-email-nzimmer@sgi.com> (from
	nzimmer@sgi.com on Fri Jun 21 11:25:33 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1372133667.2776.145@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 11:25:33 AM, Nathan Zimmer wrote:
> On a 16TB system it can takes upwards of two hours to boot the system  
> with
> about 60% of the time being spent initializing memory.  This patch  
> delays
> initializing a large portion of memory until after the system is  
> booted.
> This can significantly reduce the time it takes the boot the system  
> down
> to the 15 to 30 minute range.

Why is this conditional? Initialize the minimum amount of memory to  
bring up each NUMA node, and then have each processor initialize its  
own memory. I would have thought it was already doing this...


> +	delay_mem_init=B:M:n:l:h
> +			This delays the initialization of a large  
> portion of
> +			memory by inserting it into the "absent" memory  
> list.
> +			This allows the system to boot up much faster  
> at the
> +			expense of the time needed to add this absent  
> memory
> +			after the system has booted.  That however can  
> be done
> +			in parallel with other operations.

This seems like a giant advertisement primarily aimed at repeating why  
you think we need to merge the patch, not explaining what it is or how  
to use it.

I would rephrase:

			Defer memory initialization until after SMP  
init (so
			large memory ranges can be initialized in  
parallel) by
			moving memory not needed during boot to the  
"absent" list.

And I repeat: why do we need to micromanage this? It sounds like all  
NUMA systems should do something like this. (Single-threaded memory  
initialization in an SMP system is kind of weird.)

> +			Format: B:M:n:l:h
> +			    (1 << B) is the block size (bsize)
> +			    	     ['0' indicates use the default  
> 128M]
> +			    (1 << M) is the address space per node
> +			    (n * bsize) is minimum sized node memory to  
> slice
> +			    (l * bisze) is low memory to leave on node
> +			    (h * bisze) is high memory to leave on node

I don't understand this in the slightest. I understand "low memory to  
leave on the node", I have no idea why there are four other parameters.


> +config DELAY_MEM_INIT
> +	bool "Delay memory initialization"
> +	depends on EFI && MEMORY_HOTPLUG_SPARSE
> +	---help---
> +	  This  option delays initializing a large portion of memory
> +	  until after the system is booted.  This can significantly
> +	  reduce the time it takes the boot the system when there
> +	  is a significant amount of memory present.  Systems with
> +	  8TB or more of memory benefit the most.

I can see an SMP phone wanting to use this to shave a quarter second  
off its boot time. Your "large portion of memory" description is a bit  
myopic.

Rob