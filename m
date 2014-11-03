Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaKCSwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:52:08 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33725 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaKCSwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:52:04 -0500
Message-ID: <5457CEB4.9020700@gmail.com>
Date: Mon, 03 Nov 2014 10:51:32 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: linux-arm-kernel@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lauraa@codeaurora.org, gioh.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com, m.szyprowski@samsung.com,
        akpm@linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DMA allocations from CMA and fatal_signal_pending check
References: <544FE9BE.6040503@gmail.com> <20141031082818.GB14642@js1304-P5Q-DELUXE> <5453F80C.4090006@gmail.com> <xa1tlhnsw7v8.fsf@mina86.com>
In-Reply-To: <xa1tlhnsw7v8.fsf@mina86.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 08:45 AM, Michal Nazarewicz wrote:
> On Fri, Oct 31 2014, Florian Fainelli wrote:
>> I agree that the CMA allocation should not be allowed to succeed, but
>> the dma_alloc_coherent() allocation should succeed. If we look at the
>> sysport driver, there are kmalloc() calls to initialize private
>> structures, those will succeed (except under high memory pressure), so
>> by the same token, a driver expects DMA allocations to succeed (unless
>> we are under high memory pressure)
>>
>> What are we trying to solve exactly with the fatal_signal_pending()
>> check here? Are we just optimizing for the case where a process has
>> allocated from a CMA region to allow this region to be returned to the
>> pool of free pages when it gets killed? Could there be another mechanism
>> used to reclaim those pages if we know the process is getting killed
>> anyway?
> 
> We're guarding against situations where process may hang around
> arbitrarily long time after receiving SIGKILL.  If user does “kill -9
> $pid” the usual expectation is that the $pid process will die within
> seconds and anything longer is perceived by user as a bug.
> 
> What problem are *you* trying to solve?  If user sent SIGKILL to
> a process that imitated device initialisation, what is the point of
> continuing initialising the device?  Just recover and return -EINTR.

I have two problems with the current approach:

- behavior of a dma_alloc_coherent() call is not consistent between a
CONFIG_CMA=y vs. CONFIG_CMA=n build, which is probably fine as long as
we document that properly

- there is currently no way for a caller of dma_alloc_coherent to tell
whether the allocation failed because it was interrupted by a signal, a
genuine OOM or something else, this is largely made worse by problem 1

> 
>> Well, not really. This driver is not an isolated case, there are tons of
>> other networking drivers that do exactly the same thing, and we do
>> expect these dma_alloc_* calls to succeed.
> 
> Again, why do you expect them to succeed?  The code must handle failures
> correctly anyway so why do you wish to ignore fatal signal?

I guess expecting them to succeed is probably not good, but at we should
at least be able to report an accurate error code to the caller and down
to user-space.

Thanks
--
Florian

