Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbbAMKTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:19:07 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20552 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbbAMKTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:19:03 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-da-54b4f1160c3a
Message-id: <54B4F113.3060200@samsung.com>
Date: Tue, 13 Jan 2015 11:18:59 +0100
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
In-reply-to: <A2CA0424C0A6F04399FB9E1CD98E030484506E69@US01WEMBX2.internal.synopsys.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xy7piH7eEGKw/pG1x8H69xcqT2hbN
	i9ezWVzeNYfNYtGyVmaLtUfusls8eriV1YHdY+esu+we++euYffo27KK0WPL/s+MHsdvbGfy
	+LxJLoAtissmJTUnsyy1SN8ugStj7sX5rAWrBSuubJnC3sD4g7eLkZNDQsBE4vLedUwQtpjE
	hXvr2boYuTiEBJYySnw6+4cJwvnIKLHk+F6wKl4BLYk1Jw4wgtgsAqoSm26tZgWx2QR0JLZ8
	nwAWFxWIkPiw6isbRL2gxI/J91hAbBGBRInDN36zgwxlFuhkknhx9RFYQljAVaJ71XR2EFtI
	oEJia/ttZhCbUyBK4tXnFUBDOYAa1CWmTMkFCTMLyEtsXvOWeQKjwCwkK2YhVM1CUrWAkXkV
	o2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkiof93BuPSY1SFGAQ5GJR7eHdlbQoRYE8uKK3MP
	MUpwMCuJ8M6/DRTiTUmsrEotyo8vKs1JLT7EyMTBKdXAuGtON9vcbwsCVS1C/q+K2ye8zSFg
	y6SSphmXZgdMOZgexiB/3enPuteBJxdy3vJvXelw8WJxU/jknk/nn856f+78QYeXeun+XJJT
	r8wz/LLh23H34qx8rsMW+ztXrZ///ufSG5IHXz1RTWiJYn+oprPoyrfIQI++lFlbV9scnb5r
	U+0pncNCHi+UWIozEg21mIuKEwEMB79HUwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 10:35 PM, Paul Zimmerman wrote:
>> From: Robert Baldyga [mailto:r.baldyga@samsung.com]
>> Sent: Monday, December 22, 2014 6:13 AM
>>
>> I have recently noticed problem with DWC2 driver in latest linux-next. I
>> use it in gadget only mode at Samsung platform (Odroid U3) but I believe
>> the bug can be reproduced at another platforms.
>>
>> While running FFS example (tools/usb/ffs-aio-example/simple/) the
>> communication breaks after few seconds. It's because one of IN requests
>> enqueued in DWC2 driver do not complete. At USB analyzer I see that USB
>> device started to transmit data from this request, but it ended incomplete.
>>
>> I bisected kernel tree, and I got following patches are reason of break.
>>
>> 941fcce usb: dwc2: Update the gadget driver to use common dwc2_hsotg
>> structure
>> 117777b usb: dwc2: Move gadget probe function into platform code
>> bcc0607 usb: dwc2: convert to use dev_pm_ops API
>> 510ffaa usb: dwc2: Initialize the USB core for peripheral mode
>> db8178c usb: dwc2: Update common interrupt handler to call gadget
>> interrupt handler
>> 8d736d8 usb: dwc2: gadget: Do not fail probe if there isn't a clock node
>>
>> Patch 941fcce breaks DWC2 driver at my platform and it starts to work
>> from 8d736d8 but it has described bug.
>>
>> I will try to localize reason of this issue.
> 
> Hi Robert,
> 
> I think the most likely suspect would be db8178c, since the rest appear
> to be init-time things. It seems to revert cleanly, can you try
> reverting just that patch and see if it helps?
> 

Hi Paul,

Thanks. It looks like you're right, commit db8178c causes the break.

I have found out that if we don't call dwc2_is_controller_alive() in
interrupt handler everything works well. Conclusion is that reading from
GSNPSID causes the problem.

BTW it's strange that this register is used for testing if controller is
alive. Documentation says nothing about that as well as it does not say
that reading this register can affect hardware behaviour.

Avoiding to read this register in device mode seems to be the simplest
solution. But the question is why does it behave this way?

Best regards,
Robert Baldyga
