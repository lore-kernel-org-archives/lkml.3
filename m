Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936943Ab3DIOwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:52:34 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3471 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934327Ab3DIOwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:52:32 -0400
Message-ID: <51642B1A.9000203@parallels.com>
Date: Tue, 09 Apr 2013 18:52:10 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC PATCH 1/1] mm: Another attempt to monitor task's memory
 changes
References: <515F0484.1010703@parallels.com> <51634E58.4080104@gmail.com>
In-Reply-To: <51634E58.4080104@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 03:10 AM, KOSAKI Motohiro wrote:
>> This approach works on any task via it's proc, and can be used on different
>> tasks in parallel.
>>
>> Also, Andrew was asking for some performance numbers related to the change.
>> Now I can say, that as long as soft dirty bits are not cleared, no performance
>> penalty occur, since the soft dirty bit and the regular dirty bit are set at 
>> the same time within the same instruction. When soft dirty is cleared via 
>> clear_refs, the task in question might slow down, but it will depend on how
>> actively it uses the memory.
>>
>>
>> What do you think, does it make sense to develop this approach further?
> 
> When touching mmaped page, cpu turns on dirty bit but doesn't turn on soft dirty.

Yes. BTW, I've just thought that "soft" in soft dirty should be read as softWARE,
i.e. this bit is managed by kernel, rather than CPU.

> So, I'm not convinced how to use this flag. Please show us your userland algorithm
> how to detect diff.

It's like this:

1. First do "echo 4 > /proc/$pid/clear_refs".
   At that point kernel clears the soft dirty _and_ the writable bits from all ptes
   of process $pid. From now on every write to any page will result in #pf and the
   subsequent call to pte_mkdirty/pmd_mkdirty, which in turn will set the soft dirty
   flag.

2. Then read the /proc/$pid/pagemap (well, /proc/$pid/pagemap2 when it will appear)
   and check the soft-dirty bit reported there (in this RFC patch it's the
   PM_SOFT_DIRTY one). If set, the respective pte was written to since last call
   to clear refs. 

Thanks,
Pavel
