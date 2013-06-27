Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab3F0Q5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:57:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45931 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3F0Q5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:57:53 -0400
Message-ID: <51CC6F10.3000202@codeaurora.org>
Date: Thu, 27 Jun 2013 09:57:52 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: balbi@ti.com
CC: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: sleeping while atomic in dwc3_gadget_start
References: <20130626215256.GC11625@codeaurora.org> <20130627065837.GL15455@arwen.pp.htv.fi>
In-Reply-To: <20130627065837.GL15455@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/13 23:58, Felipe Balbi wrote:
> On Wed, Jun 26, 2013 at 02:52:56PM -0700, Stephen Boyd wrote:
>> Hi,
>>
>> I'm getting the folllowing BUG message on bootup with 3.10-rc5
>>
>> BUG: sleeping function called from invalid context at mm/slub.c:926
>> in_atomic(): 1, irqs_disabled(): 128, pid: 1, name: swapper/0
>> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc5-gee3e35b-09316-ge78f3b35 #643
>> [<c0014220>] (unwind_backtrace+0x0/0x120) from [<c001212c>] (show_stack+0x10/0x14)
>> [<c001212c>] (show_stack+0x10/0x14) from [<c0143750>] (kmem_cache_alloc_trace+0x3c/0x210)
>> [<c0143750>] (kmem_cache_alloc_trace+0x3c/0x210) from [<c00e0c60>] (request_threaded_irq+0x88/0x11c)
>> [<c00e0c60>] (request_threaded_irq+0x88/0x11c) from [<c03bf53c>] (dwc3_gadget_start+0x198/0x200)
>> [<c03bf53c>] (dwc3_gadget_start+0x198/0x200) from [<c03f7a5c>] (udc_bind_to_driver+0x70/0xd8)
>> [<c03f7a5c>] (udc_bind_to_driver+0x70/0xd8) from [<c03f7b50>] (usb_gadget_probe_driver+0x8c/0xb8)
>>
>> and I suspect this problem was introduced in commit 8698e2acf
>> (usb: dwc3: gadget: introduce and use enable/disable irq
>> methods). Is there a fix for this problem? Can we just move the
>> irq request outside the spinlock?
> nice :-)
>
> how about this ?

If start fails do you call stop? I believe the answer is no, so we'll
need to free_irq() somewhere along the error path. Or we can request it
after the spin_unlock()?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

