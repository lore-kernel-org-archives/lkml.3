Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaAUFey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:34:54 -0500
Received: from mail-yk0-f171.google.com ([209.85.160.171]:51237 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaAUFer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:34:47 -0500
Date: Mon, 20 Jan 2014 21:34:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jianguo Wu <wujianguo@huawei.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [question] how to figure out OOM reason? should dump slab/vmalloc
 info when OOM?
In-Reply-To: <52DCFC33.80008@huawei.com>
Message-ID: <alpine.DEB.2.02.1401202130590.21729@chino.kir.corp.google.com>
References: <52DCFC33.80008@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014, Jianguo Wu wrote:

> When OOM happen, will dump buddy free areas info, hugetlb pages info,
> memory state of all eligible tasks, per-cpu memory info.
> But do not dump slab/vmalloc info, sometime, it's not enough to figure out the
> reason OOM happened.
> 
> So, my questions are:
> 1. Should dump slab/vmalloc info when OOM happen? Though we can get these from proc file,
> but usually we do not monitor the logs and check proc file immediately when OOM happened.
> 

The problem is that slabinfo becomes excessively verbose and dumping it 
all to the kernel log often times causes important messages to be lost.  
This is why we control things like the tasklist dump with a VM sysctl.  It 
would be possible to dump, say, the top ten slab caches with the highest 
memory usage, but it will only be helpful for slab leaks.  Typically there 
are better debugging tools available than analyzing the kernel log; if you 
see unusually high slab memory in the meminfo dump, you can enable it.

> 2. /proc/$pid/smaps and pagecache info also helpful when OOM, should also be dumped?
> 

Also very verbose and would cause important messages to be lost, we try to 
avoid spamming the kernel log with all of this information as much as 
possible.

> 3. Without these info, usually how to figure out OOM reason?
> 

Analyze the memory usage in the meminfo and determine what is unusually 
high; if it's mostly anonymous memory, you can usually correlate it back 
to a high rss for a process in the tasklist that you didn't suspect to be 
using that much memory, for example.
