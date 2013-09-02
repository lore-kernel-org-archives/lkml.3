Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab3IBRye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 13:54:34 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:43613 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab3IBRyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 13:54:33 -0400
X-IronPort-AV: E=Sophos;i="4.89,1008,1367971200"; 
   d="scan'208";a="47388520"
Message-ID: <5224D0D6.40908@citrix.com>
Date: Mon, 2 Sep 2013 18:54:30 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>,
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] tracing/events: Add bounce tracing to swiotbl-xen
References: <1377208048-8963-1-git-send-email-zoltan.kiss@citrix.com> <20130823125533.GC14306@konrad-lan.dumpdata.com>
In-Reply-To: <20130823125533.GC14306@konrad-lan.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/13 13:55, Konrad Rzeszutek Wilk wrote:
> On Thu, Aug 22, 2013 at 10:47:28PM +0100, Zoltan Kiss wrote:
>> Ftrace is currently not able to detect when SWIOTLB has to do double buffering
>> under Xen. You can only see it indirectly in function_graph, when
>> xen_swiotlb_map_page() doesn't stop after range_straddles_page_boundary(), but
>> calls spinlock functions, memcpy() and xen_phys_to_bus() as well. This patch
>> introduces the swiotlb-xen:bounced event, which also prints out the following
>> informations to help you find out why bouncing happened:
>>
>> dev_name: 0000:08:00.0 dma_mask=ffffffffffffffff dev_addr=9149f000 size=32768
>> swiotlb_force=0
>>
>> If (dev_addr + size + 1) > dma_mask, the buffer is out of the device's DMA
>> range. If swiotlb_force == 1, you should really change the kernel parameters.
>> Otherwise, the buffer is not contiguous in mfn space.
>
> Could this be in the lib/swiotlb.c instead?

You mean instead of drivers/xen/swiotlb-xen.c ? This is a Xen SWIOTLB 
specific thing, it will hit exactly at the point when double buffering 
becomes sure - under Xen.
But I can rename the tracer and call trace_bounced in swiotlb_map_page 
as well, so it can be used for normal SWIOTLB bounce tracing as well. Is 
it OK for you?

Regards,

Zoli
