Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab3JNXKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 19:10:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab3JNXKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 19:10:48 -0400
Date: Mon, 14 Oct 2013 16:10:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH] mm: Set N_CPU to node_states during boot
Message-Id: <20131014161047.4a6a54e985d68a9f1ce7234b@linux-foundation.org>
In-Reply-To: <1381781096-13168-1-git-send-email-toshi.kani@hp.com>
References: <1381781096-13168-1-git-send-email-toshi.kani@hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Oct 2013 14:04:56 -0600 Toshi Kani <toshi.kani@hp.com> wrote:

> After a system booted, N_CPU is not set to any node as has_cpu
> shows an empty line.
> 
>   # cat /sys/devices/system/node/has_cpu
>   (show-empty-line)
> 
> setup_vmstat() registers its CPU notifier callback,
> vmstat_cpuup_callback(), which marks N_CPU to a node when
> a CPU is put into online.  However, setup_vmstat() is called
> after all CPUs are launched in the boot sequence.
> 
> Change setup_vmstat() to mark N_CPU to the nodes with online
> CPUs at boot.
> 
> ...
>
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1276,8 +1276,10 @@ static int __init setup_vmstat(void)
>  
>  	register_cpu_notifier(&vmstat_notifier);
>  
> -	for_each_online_cpu(cpu)
> +	for_each_online_cpu(cpu) {
>  		start_cpu_timer(cpu);
> +		node_set_state(cpu_to_node(cpu), N_CPU);
> +	}
>  #endif
>  #ifdef CONFIG_PROC_FS
>  	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);

This seems a bit hacky.  Would it not be better to register
vmstat_notifier() before bringing up CPUs?


And this patch might be racy as well - what happens if a CPU comes up
and goes down again before setup_vmstat() is called?

(Where does N_CPU get cleared?  It doesn't, afaict.  Should we clear it
if a node's final CPU goes offline?)
