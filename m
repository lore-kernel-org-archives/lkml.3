Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab3ANPCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 10:02:21 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:39636 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab3ANPCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 10:02:20 -0500
Message-ID: <50F41D9D.1000403@linux.vnet.ibm.com>
Date: Mon, 14 Jan 2013 07:00:45 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: paul.szabo@sydney.edu.au
CC: linux-mm@kvack.org, 695182@bugs.debian.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Reproducible OOM with just a few sleeps
References: <201301120331.r0C3VxXc016220@como.maths.usyd.edu.au>
In-Reply-To: <201301120331.r0C3VxXc016220@como.maths.usyd.edu.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011415-5518-0000-0000-00000AB8B339
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 07:31 PM, paul.szabo@sydney.edu.au wrote:
> Seems that any i386 PAE machine will go OOM just by running a few
> processes. To reproduce:
>   sh -c 'n=0; while [ $n -lt 19999 ]; do sleep 600 & ((n=n+1)); done'
> My machine has 64GB RAM. With previous OOM episodes, it seemed that
> running (booting) it with mem=32G might avoid OOM; but an OOM was
> obtained just the same, and also with lower memory:
>   Memory    sleeps to OOM       free shows total
>   (mem=64G)  5300               64447796
>   mem=32G   10200               31155512
>   mem=16G   13400               14509364
>   mem=8G    14200               6186296
>   mem=6G    15200               4105532
>   mem=4G    16400               2041364
> The machine does not run out of highmem, nor does it use any swap.

I think what you're seeing here is that, as the amount of total memory
increases, the amount of lowmem available _decreases_ due to inflation
of mem_map[] (and a few other more minor things).  The number of sleeps
you can do is bound by the number of processes, as you noticed from
ulimit.  Creating processes that don't use much memory eats a relatively
large amount of low memory.

This is a sad (and counterintuitive) fact: more RAM actually *CREATES*
RAM bottlenecks on 32-bit systems.

> On my large machine, 'free' fails to show about 2GB memory, e.g. with
> mem=16G it shows:
> 
> root@zeno:~# free -l
>              total       used       free     shared    buffers     cached
> Mem:      14509364     435440   14073924          0       4068     111328
> Low:        769044     120232     648812
> High:     13740320     315208   13425112
> -/+ buffers/cache:     320044   14189320
> Swap:    134217724          0  134217724

You probably have a memory hole.  mem=16G means "give me all the memory
below the physical address at 16GB".  It does *NOT* mean, "give me
enough memory such that 'free' will show ~16G available."  If you have a
1.5GB hole below 16GB, and you do mem=16G, you'll end up with ~14.5GB
available.

The e820 map (during early boot in dmesg) or /proc/iomem will let you
locate your memory holes.

