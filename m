Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871Ab3DCKkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 06:40:51 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60349 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759154Ab3DCKku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 06:40:50 -0400
X-IronPort-AV: E=Sophos;i="4.87,399,1363158000"; 
   d="scan'208";a="35341553"
Message-ID: <515C072E.3010801@codeaurora.org>
Date: Wed, 03 Apr 2013 13:40:46 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Alex.Lemberg@sandisk.com, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/3] block: Add API for urgent request handling
References: <1364202178-8936-1-git-send-email-tlinder@codeaurora.org> <20130325124007.GH22327@kernel.dk>
In-Reply-To: <20130325124007.GH22327@kernel.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/2013 2:40 PM, Jens Axboe wrote:
> On Mon, Mar 25 2013, Tanya Brokhman wrote:
>> This patch add support in block & elevator layers for handling
>> urgent requests. The decision if a request is urgent or not is taken
>> by the scheduler. Request is marked as urgent in cmd_flags (by the
>> scheduler) with a new flag - REQ_URGENT.
>> Urgent request notification is passed to the underlying
>> block device driver (eMMC for example). Block device driver may decide to
>> interrupt the currently running low priority request to serve the new
>> urgent request. By doing so READ latency is greatly reduced in read&write
>> collision scenarios.
>>
>> Note that if the current scheduler doesn't implement the urgent request
>> mechanism, this code path is never activated.
> I really don't like this out-of-band mechanism. Lets say there is an
> urgent request, the IO scheduler would put that at the head of the
> queue. So the first time the driver fetches a request, it'll see this
> urgent request. A driver that has support for this, would check the head
> of queue everytime its request_fn was invoked. There's no need to add a
> elevator_is_urgent_fn() and ->notified_urgent.
>
Hi Jens,

Thank you for your inputs. We implemented the URGENT request 
notification in block layer with elevator_is_urgent_fn() and 
->notified_urgent due to the following:

1. In the future the URGENT request mechanism may be of use to other 
block device drivers besides mmc (such as sdcc for example). Having this 
mechanism in the block layer spares all of the block devices 
re-implementing it.

2. Using the existing API (->request_fn() and not urgent_request->fn()) 
won’t work as intended for URGENT requests in case the block device 
already handles 2 requests. In such a case, when a device driver will 
peek the dispatch queue to check if an URGENT request is pending or not, 
a new request will be dispatched. If an URGENT requests is inserted to 
the scheduler after that, the block device will not be aware of its 
existence, which will result in high latency for this URGENT request. 
For example:

The device driver is currently handling requests regular_A and regular_B 
when a new regular request ( regular_C ) arrives and ->request_fn() is 
called by the block layer. The device driver ”peeks” the dispatch queue 
in order to find out if there is an URGENT request pending. The I/O 
scheduler will insert regular_C into the dispatch queue, the device 
driver will see that there is no URGNET request pending and continue its 
work. Regular_C will remain pending on the dispatch queue. Now another 
request arrives: URGENT_D and ->request_fn() is called again. But this 
time when the device driver “peeks” the dispatch queue to find if an 
URGENT request is pending it will look at regular_C and URGENT_D will 
remain in the scheduler data base till regular_A and regular_B requests 
are completed and regular_C is sent to the card.

The ->notified_urgent is needed because we don’t want to notify the 
device driver of an URGENT request if there is already an URGENT request 
in flight. This is because we don’t want URGENT requests to be interrupted.

-- 

QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member

of Code Aurora Forum, hosted by The Linux Foundation

