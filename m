Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3GAQQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:16:49 -0400
Received: from www.sr71.net ([198.145.64.142]:56059 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab3GAQQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:16:48 -0400
Message-ID: <51D1AB6E.9030905@sr71.net>
Date: Mon, 01 Jul 2013 09:16:46 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zheng Liu <gnehzuil.liu@gmail.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] mm: madvise: MADV_POPULATE for quick pre-faulting
References: <20130627231605.8F9F12E6@viggo.jf.intel.com> <20130628054757.GA10429@gmail.com> <51CDB056.5090308@sr71.net> <51CE4451.4060708@gmail.com>
In-Reply-To: <51CE4451.4060708@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 07:20 PM, Zheng Liu wrote:
>> > IOW, a process needing to do a bunch of MAP_POPULATEs isn't
>> > parallelizable, but one using this mechanism would be.
> I look at the code, and it seems that we will handle MAP_POPULATE flag
> after we release mmap_sem locking in vm_mmap_pgoff():
> 
>                 down_write(&mm->mmap_sem);
>                 ret = do_mmap_pgoff(file, addr, len, prot, flag, pgoff,
>                                     &populate);
>                 up_write(&mm->mmap_sem);
>                 if (populate)
>                         mm_populate(ret, populate);
> 
> Am I missing something?

I went and did my same test using mmap(MAP_POPULATE)/munmap() pair
versus using MADV_POPULATE in 160 threads in parallel.

MADV_POPULATE was about 10x faster in the threaded configuration.

With MADV_POPULATE, the biggest cost is shipping the mmap_sem cacheline
around so that we can write the reader count update in to it.  With
mmap(), there is a lot of _contention_ on that lock which is much, much
more expensive than simply bouncing a cacheline around.
