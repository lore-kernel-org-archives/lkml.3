Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaCMPpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:45:07 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:5397 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbaCMPpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:45:05 -0400
X-IronPort-AV: E=Sophos;i="4.97,648,1389744000"; 
   d="scan'208";a="109616406"
Message-ID: <5321D265.8070907@citrix.com>
Date: Thu, 13 Mar 2014 15:44:37 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next] xen-netback: Schedule NAPI from dealloc thread
 instead of callback
References: <1394658281-2488-1-git-send-email-zoltan.kiss@citrix.com>	 <20140313101720.GA16807@zion.uk.xensource.com> <1394707350.25873.34.camel@kazak.uk.xensource.com>
In-Reply-To: <1394707350.25873.34.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/14 10:42, Ian Campbell wrote:
> On Thu, 2014-03-13 at 10:17 +0000, Wei Liu wrote:
>> On Wed, Mar 12, 2014 at 09:04:41PM +0000, Zoltan Kiss wrote:
>>> If there are unconsumed requests in the ring, but there isn't enough free
>>> pending slots, the NAPI instance deschedule itself. As the frontend won't send
>>> any more interrupts in this case, it is the task of whoever release the pending
>>> slots to schedule the NAPI instance in this case. Originally it was done in the
>>> callback, but it's better at the end of the dealloc thread, otherwise there is
>>> a risk that the NAPI instance just deschedule itself as the dealloc thread
>>> couldn't release any used slot yet. However, as there are a lot of pending
>>> packets, NAPI will be scheduled again, and it is very unlikely that the dealloc
>>> thread can't release enough slots in the meantime.
>>>
>>
>> So this patch restores the property that "only two parties access the
>> ring", right?
>
> I think so, and therefore:
> Acked-by: Ian Campbell <ian.campbell@citrix.com>

I've just discussed this with Ian, this solution still doesn't solve the 
racing between NAPI and the dealloc thread, however it only causes some 
unnecessary napi_schedule's, not ring stalls.
There is a better solution, I'll post it as soon as it passes all the test!

Zoli

