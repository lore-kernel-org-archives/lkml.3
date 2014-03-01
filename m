Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaCAAkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:40:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaCAAkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:40:39 -0500
Date: Fri, 28 Feb 2014 16:42:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC/RFT v3 2/9] drivers: base: support cpu cache
 information interface to userspace via sysfs
Message-ID: <20140301004216.GA30634@kroah.com>
References: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
 <1392825976-17633-3-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392825976-17633-3-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 04:06:09PM +0000, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> This patch adds initial support for providing processor cache information
> to userspace through sysfs interface. This is based on already existing
> implementations(x86, ia64, s390 and powerpc) and hence the interface is
> intended to be fully compatible.
> 
> The main purpose of this generic support is to avoid further code
> duplication to support new architectures and also to unify all the existing
> different implementations.
> 
> This implementation maintains the hierarchy of cache objects which reflects
> the system's cache topology. Cache devices are instantiated as needed as
> CPUs come online. The cache information is replicated per-cpu even if they are
> shared. A per-cpu array of cache information maintained is used mainly for
> sysfs-related book keeping.
> 
> It also implements the shared_cpu_map attribute, which is essential for
> enabling both kernel and user-space to discover the system's overall cache
> topology.
> 
> This patch also add the missing ABI documentation for the cacheinfo sysfs
> interface already, which is well defined and widely used.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Rob Herring <robh@kernel.org>
> Cc: linux-doc@vger.kernel.org
> ---
>  Documentation/ABI/testing/sysfs-devices-system-cpu |  40 ++
>  drivers/base/Makefile                              |   2 +-
>  drivers/base/cacheinfo.c                           | 484 +++++++++++++++++++++
>  include/linux/cacheinfo.h                          |  55 +++
>  4 files changed, 580 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/base/cacheinfo.c
>  create mode 100644 include/linux/cacheinfo.h
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index d5a0d33..dabe03e 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -224,3 +224,43 @@ Description:	Parameters for the Intel P-state driver
>  		frequency range.
>  
>  		More details can be found in Documentation/cpu-freq/intel-pstate.txt
> +
> +What:		/sys/devices/system/cpu/cpu*/cache/index*/<set_of_attributes_mentioned_below>
> +Date:		February 2014
> +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>

No, your name goes here, you don't get to run away from this new code :)

> +Description:	Parameters for the CPU cache attributes
> +
> +		attributes:
> +			- writethrough: data is written to both the cache line
> +					and to the block in the lower-level memory
> +			- writeback: data is written only to the cache line and
> +				     the modified cache line is written to main
> +				     memory only when it is replaced
> +			- writeallocate: allocate a memory location to a cache line
> +					 on a cache miss because of a write
> +			- readallocate: allocate a memory location to a cache line
> +					on a cache miss because of a read
> +
> +		coherency_line_size: the minimum amount of data that gets transferred
> +
> +		level: the cache hierarcy in the multi-level cache configuration
> +
> +		number_of_sets: total number of sets in the cache, a set is a
> +				collection of cache lines with the same cache index
> +
> +		physical_line_partition: number of physical cache line per cache tag
> +
> +		shared_cpu_list: the list of cpus sharing the cache
> +
> +		shared_cpu_map: logical cpu mask containing the list of cpus sharing
> +				the cache
> +
> +		size: the total cache size in kB
> +
> +		type:
> +			- instruction: cache that only holds instructions
> +			- data: cache that only caches data
> +			- unified: cache that holds both data and instructions
> +
> +		ways_of_associativity: degree of freedom in placing a particular block
> +					of memory in the cache

With this patch, does this all work for x86, or does it need more glue
logic?

thanks,

greg k-h
