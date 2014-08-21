Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaHUMHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:07:22 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:62166 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbaHUMHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:07:19 -0400
Message-ID: <53F5E0F1.20808@bjorling.me>
Date: Thu, 21 Aug 2014 14:07:13 +0200
From: =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>
CC: willy@linux.intel.com, sbradshaw@micron.com, axboe@fb.com,
        tom.leiming@gmail.com, hch@infradead.org, rlnelson@google.com,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH v12] NVMe: Convert to blk-mq
References: <1408126604-10611-1-git-send-email-m@bjorling.me> <1408126604-10611-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1408181643280.4696@AMR>
In-Reply-To: <alpine.LRH.2.03.1408181643280.4696@AMR>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 12:49 AM, Keith Busch wrote:
> On Fri, 15 Aug 2014, Matias Bjørling wrote:
>>
>> * NVMe queues are merged with the tags structure of blk-mq.
>>
>
> I see the driver's queue suspend logic is removed, but I didn't mean to
> imply it was safe to do so without replacing it with something else. I
> thought maybe we could use the blk_stop/start_queue() functions if I'm
> correctly understanding what they're for.

They're usually only used for the previous request model.

Please correct me if I'm wrong. The flow of suspend is as following 
(roughly):

1. Freeze user threads
2. Perform sys_sync
3. Freeze freezable kernel threads
4. Freeze devices
5. ...

On nvme suspend, we process all outstanding request and cancels any 
outstanding IOs, before going suspending.

 From what I found, is it still possible for IOs to be submitted and 
lost in the process?

>
> With what's in version 12, we could free an irq multiple times that
> doesn't even belong to the nvme queue anymore in certain error conditions.
>
> A couple other things I just noticed:
>
>   * We lose the irq affinity hint after a suspend/resume or device reset
>   because the driver's init_hctx() isn't called in these scenarios.

Ok, you're right.

>
>   * After a reset, we are not guaranteed that we even have the same number
>   of h/w queues. The driver frees ones beyond the device's capabilities,
>   so blk-mq may have references to freed memory. The driver may also
>   allocate more queues if it is capable, but blk-mq won't be able to take
>   advantage of that.

Ok. Out of curiosity, why can the number of exposed nvme queues change 
from the hw perspective on suspend/resume?
