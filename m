Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3F2CCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 22:02:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35189 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3F2CCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 22:02:33 -0400
Message-ID: <51CE4038.5000905@codeaurora.org>
Date: Fri, 28 Jun 2013 19:02:32 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: balbi@ti.com
CC: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: sleeping while atomic in dwc3_gadget_start
References: <20130626215256.GC11625@codeaurora.org> <20130627065837.GL15455@arwen.pp.htv.fi> <51CC6F10.3000202@codeaurora.org> <20130628105805.GN11297@arwen.pp.htv.fi>
In-Reply-To: <20130628105805.GN11297@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/13 03:58, Felipe Balbi wrote:
> Hi,
>
> On Thu, Jun 27, 2013 at 09:57:52AM -0700, Stephen Boyd wrote:
>> On 06/26/13 23:58, Felipe Balbi wrote:
>>> On Wed, Jun 26, 2013 at 02:52:56PM -0700, Stephen Boyd wrote:
>>>> Hi,
>>>>
>>>> I'm getting the folllowing BUG message on bootup with 3.10-rc5
>>>>
>>>> BUG: sleeping function called from invalid context at mm/slub.c:926
>>>> in_atomic(): 1, irqs_disabled(): 128, pid: 1, name: swapper/0
>>>> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc5-gee3e35b-09316-ge78f3b35 #643
>>>> [<c0014220>] (unwind_backtrace+0x0/0x120) from [<c001212c>] (show_stack+0x10/0x14)
>>>> [<c001212c>] (show_stack+0x10/0x14) from [<c0143750>] (kmem_cache_alloc_trace+0x3c/0x210)
>>>> [<c0143750>] (kmem_cache_alloc_trace+0x3c/0x210) from [<c00e0c60>] (request_threaded_irq+0x88/0x11c)
>>>> [<c00e0c60>] (request_threaded_irq+0x88/0x11c) from [<c03bf53c>] (dwc3_gadget_start+0x198/0x200)
>>>> [<c03bf53c>] (dwc3_gadget_start+0x198/0x200) from [<c03f7a5c>] (udc_bind_to_driver+0x70/0xd8)
>>>> [<c03f7a5c>] (udc_bind_to_driver+0x70/0xd8) from [<c03f7b50>] (usb_gadget_probe_driver+0x8c/0xb8)
>>>>
>>>> and I suspect this problem was introduced in commit 8698e2acf
>>>> (usb: dwc3: gadget: introduce and use enable/disable irq
>>>> methods). Is there a fix for this problem? Can we just move the
>>>> irq request outside the spinlock?
>>> nice :-)
>>>
>>> how about this ?
>> If start fails do you call stop? I believe the answer is no, so we'll
>> need to free_irq() somewhere along the error path. Or we can request it
>> after the spin_unlock()?
> good point here's v2:

Ok looks good to me. I hope that platform_get_irq() doesn't fail,
otherwise we're in for a nasty surprise. Maybe we should add a check in
request_irq() for that case.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

