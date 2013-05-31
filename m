Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab3EaVwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:52:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3EaVwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:52:15 -0400
Date: Fri, 31 May 2013 14:52:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youquan Song <youquan.song@intel.com>
Cc: gregkh@linuxfoundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] core: Fix maxcpus boot option broken
Message-Id: <20130531145214.27bb260219f55131b6e6e605@linux-foundation.org>
In-Reply-To: <1369886406-14079-1-git-send-email-youquan.song@intel.com>
References: <1369886406-14079-1-git-send-email-youquan.song@intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013 00:00:06 -0400 Youquan Song <youquan.song@intel.com> wrote:

> maxcpus boot option to limit maximum number of CPUs on system, but this option
> is broken at recent kernel.

Can you help us identify which kernel versions have this bug? 
Identifying the offending commit would be best.  Thanks.

> Though we use maxcpus to limit CPUs number, but
> current kernel will register all of present CPUs in sysfs.
> udev will enumerate all registered cpu at sysfs, and it will bring up the CPU
> if the CPU is offline. So the maxcpus option is broken.
> 
> This patch will only register the CPU which is not over limitation of maxcpus 
> option in sysfs. So it will keep the maxcpus limitation when udev enumeration
> or other intention of bring up CPUs over the limitation by method like  
> echo 1 > /sys/devices/system/cpu/online 
> 
> ...
>
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -272,6 +272,10 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
>  {
>  	int error;
>  
> +	/* return when cpu number greater than maximum number of CPUs */
> +	if (num >= setup_max_cpus)
> +		return 0;
> +
>  	cpu->node_id = cpu_to_node(num);
>  	memset(&cpu->dev, 0x00, sizeof(struct device));
>  	cpu->dev.id = num;
> -- 
> 1.7.7.4
