Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbbAMKuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:50:18 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21781 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbbAMKuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:50:15 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-31-54b4f865f4dd
Message-id: <54B4F863.6040303@samsung.com>
Date: Tue, 13 Jan 2015 11:50:11 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "dinh.linux@gmail.com" <dinh.linux@gmail.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: dwc2: problems with IN requests completion in linux-next
References: <549826F4.6080709@samsung.com>
 <A2CA0424C0A6F04399FB9E1CD98E030484506E69@US01WEMBX2.internal.synopsys.com>
 <54B4F113.3060200@samsung.com>
In-reply-to: <54B4F113.3060200@samsung.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xq7qpP7aEGLy+YW1x8H69xcqT2hbN
	i9ezWVzeNYfNYtGyVmaLtUfusls8eriV1YHdY+esu+we++euYffo27KK0WPL/s+MHsdvbGfy
	+LxJLoAtissmJTUnsyy1SN8ugSvjyY7vrAXdwhVPu2wbGNfxdzFyckgImEjs7u1lhLDFJC7c
	W8/WxcjFISSwlFHi6/YJLBDOR0aJB7MnsoJU8QpoSWw8cZgZxGYRUJX4d2QZC4jNJqAjseX7
	BLBJogIREh9WfWWDqBeU+DH5HliNiECixOEbv9lBhjILdDJJvLj6CCwhLOAq0b1qOjvEtpmM
	Ehc/rgJLcApoS/x7eQloMwdQh7rElCm5IGFmAXmJzWveMk9gFJiFZMcshKpZSKoWMDKvYhRN
	LU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJ9a87GJceszrEKMDBqMTDuyN7S4gQa2JZcWXuIUYJ
	DmYlEd7070Ah3pTEyqrUovz4otKc1OJDjEwcnFINjLm13ypmaiccNHbfytN5K3nK2Um3zvbY
	s0gnN2iusz0ptFWR0bp2rtvexFwD0/v/TI9E2laKGlwM+JkVut7x7IXA3b1LKh9rzHBpFNSS
	87lkYCDkvkpG12i1HL/E1KY1tgvfTs1R/frpoGaZ1MPnyjGOXsUmntv+GmzWnxP+k6XEbtKf
	nQ1cSizFGYmGWsxFxYkAH5K7YFMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 11:18 AM, Robert Baldyga wrote:
> On 01/12/2015 10:35 PM, Paul Zimmerman wrote:
>>> From: Robert Baldyga [mailto:r.baldyga@samsung.com]
>>> Sent: Monday, December 22, 2014 6:13 AM
>>>
>>> I have recently noticed problem with DWC2 driver in latest linux-next. I
>>> use it in gadget only mode at Samsung platform (Odroid U3) but I believe
>>> the bug can be reproduced at another platforms.
>>>
>>> While running FFS example (tools/usb/ffs-aio-example/simple/) the
>>> communication breaks after few seconds. It's because one of IN requests
>>> enqueued in DWC2 driver do not complete. At USB analyzer I see that USB
>>> device started to transmit data from this request, but it ended incomplete.
>>>
>>> I bisected kernel tree, and I got following patches are reason of break.
>>>
>>> 941fcce usb: dwc2: Update the gadget driver to use common dwc2_hsotg
>>> structure
>>> 117777b usb: dwc2: Move gadget probe function into platform code
>>> bcc0607 usb: dwc2: convert to use dev_pm_ops API
>>> 510ffaa usb: dwc2: Initialize the USB core for peripheral mode
>>> db8178c usb: dwc2: Update common interrupt handler to call gadget
>>> interrupt handler
>>> 8d736d8 usb: dwc2: gadget: Do not fail probe if there isn't a clock node
>>>
>>> Patch 941fcce breaks DWC2 driver at my platform and it starts to work
>>> from 8d736d8 but it has described bug.
>>>
>>> I will try to localize reason of this issue.
>>
>> Hi Robert,
>>
>> I think the most likely suspect would be db8178c, since the rest appear
>> to be init-time things. It seems to revert cleanly, can you try
>> reverting just that patch and see if it helps?
>>
> 
> Hi Paul,
> 
> Thanks. It looks like you're right, commit db8178c causes the break.
> 
> I have found out that if we don't call dwc2_is_controller_alive() in
> interrupt handler everything works well. Conclusion is that reading from
> GSNPSID causes the problem.
> 
> BTW it's strange that this register is used for testing if controller is
> alive. Documentation says nothing about that as well as it does not say
> that reading this register can affect hardware behaviour.
> 
> Avoiding to read this register in device mode seems to be the simplest
> solution. But the question is why does it behave this way?
> 

It looks like calling dwc2_is_controller_alive() under spinlock solves
the problem. I will prepare patch.

Best regards,
Robert Baldyga
