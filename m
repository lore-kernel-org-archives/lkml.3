Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab3KEDaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 22:30:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41123 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3KEDaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 22:30:21 -0500
Message-ID: <52786640.90403@oracle.com>
Date: Tue, 05 Nov 2013 11:30:08 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Bob Liu <lliubbo@gmail.com>, konrad.wilk@oracle.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] drivers: xen-selfballoon: consider slab pages
References: <1383568764-30478-1-git-send-email-bob.liu@oracle.com> <5277D7EA.9000801@citrix.com>
In-Reply-To: <5277D7EA.9000801@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/05/2013 01:22 AM, David Vrabel wrote:
> On 04/11/13 12:39, Bob Liu wrote:
>> Currently the goal_page in xen-selfballon doesn't consider much about pages used
>> in kernel space.
>> A typical usage is slab pages, without consider slab pages the goal_page result
>> may be too rough and lead extra memory pressure to guest os.
> 
> Can you provide some real world figures where the calculatation got it
> wrong? What was the resultant behavior?  Swap death? OOM killer?
> 

Sorry, I didn't run any testing I just think it's unreasonable while
reading the source code.

vm_memory_committed() only calculate pages which mapped to process
address space, but the kernel itself(like block, fs and network
subsystem) may occupy some memory. And it's possible that those
subsystem may occupy a significant amount of memory in some situation.

I'm afraid if we don't consider those kernel memory while calculating
goal_pages, guest memory will be set lower than guest really needs.

>> Signed-off-by: Bob Liu <bob.liu@oracle.com>
>> ---
>>  drivers/xen/xen-selfballoon.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
>> index 21e18c1..4814759 100644
>> --- a/drivers/xen/xen-selfballoon.c
>> +++ b/drivers/xen/xen-selfballoon.c
>> @@ -191,6 +191,8 @@ static void selfballoon_process(struct work_struct *work)
>>  		tgt_pages = cur_pages; /* default is no change */
>>  		goal_pages = vm_memory_committed() +
>>  				totalreserve_pages +
>> +				global_page_state(NR_SLAB_RECLAIMABLE) +
> 
> Does SLAB_RECLAIMABLE want to be included here?  Unless I'm
> misunderstanding here, SLAB_RECLAIMABLE is effectively free.
> 

SLAB_RECLAIMABLE isn't effectively free, it means the slab page is in
used but can be reclaimed(freed) during memory pressure.

>> +				global_page_state(NR_SLAB_UNRECLAIMABLE) +
> 
> This bit looks fine to me.
> 
>>  				MB2PAGES(selfballoon_reserved_mb);
>>  #ifdef CONFIG_FRONTSWAP
>>  		/* allow space for frontswap pages to be repatriated */
> 
> David
> 

Thanks for your review.

-- 
Regards,
-Bob
