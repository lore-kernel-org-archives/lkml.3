Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaDQXSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:18:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDQXS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:18:29 -0400
Date: Thu, 17 Apr 2014 16:18:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Yao <ryao@gentoo.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel@gentoo.org,
        Matthew Thode <mthode@mthode.org>
Subject: Re: [PATCH] mm/vmalloc: Introduce DEBUG_VMALLOCINFO to reduce
 spinlock contention
Message-Id: <20140417161828.b1740b30bf9d5462f46562cc@linux-foundation.org>
In-Reply-To: <1397148058-8737-1-git-send-email-ryao@gentoo.org>
References: <1397148058-8737-1-git-send-email-ryao@gentoo.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014 12:40:58 -0400 Richard Yao <ryao@gentoo.org> wrote:

> Performance analysis of software compilation by Gentoo portage on an
> Intel E5-2620 with 64GB of RAM revealed that a sizeable amount of time,
> anywhere from 5% to 15%, was spent in get_vmalloc_info(), with at least
> 40% of that time spent in the _raw_spin_lock() invoked by it.

This means that something in userspace is beating the crap out of
/proc/meminfo.  What is it and why is it doing this?

/proc/meminfo reads a large amount of stuff and gathering it will
always be expensive.  I don't think we really want to be doing
significant work and adding significant complexity to optimize meminfo.

If there really is a legitimate need to be reading meminfo with this
frequency then it would be pretty simple to optimise
get_vmalloc_info(): all it does is to return two ulongs and we could
maintain those at vmalloc/vfree time rather than doing the big list
walk.

If we can address these things then the vmap_area_lock problem should
just go away - the kernel shouldn't be calling vmalloc/vfree at high
frequency, especially during a compilation workload.
