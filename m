Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaLWGeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 01:34:21 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55626 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaLWGeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 01:34:19 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-62-54990ce8df62
Message-id: <54990CE7.1030008@samsung.com>
Date: Tue, 23 Dec 2014 07:34:15 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: balbi@ti.com
Cc: Peter Chen <peter.chen@freescale.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, k.opasiak@samsung.com
Subject: Re: [PATCH] usb: gadget: udc-core: call udc_stop() before gadget unbind
References: <1418390248-6254-1-git-send-email-r.baldyga@samsung.com>
 <20141215051317.GC25410@shlinux2> <548EB262.6040208@samsung.com>
 <20141222163430.GH12815@saruman>
In-reply-to: <20141222163430.GH12815@saruman>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xq7oveGaGGPxq1rI4eL/eonnxejaL
	2xOnsVlc3jWHzWLRslZmi7VH7rJbHJv9l8mB3ePf4X4mj/1z17B79G1Zxehx/MZ2Jo/Pm+QC
	WKO4bFJSczLLUov07RK4MtbNvslSsE+w4v6vlWwNjO18XYycHBICJhJ9l96zQ9hiEhfurWfr
	YuTiEBJYyiix9vE+RpCEkMBHRomdrUUgNq+AlkTL92lMIDaLgKrE0p3H2EBsNgEdiS3fJ4DV
	iwpESFxZM4cRol5Q4sfkeywgtoiAgMT6F5fYQRYwC2xmlLg9/zdYs7BAgMTnDzdYITavYpSY
	tu812AZOAV2JtrlzgYo4gDr0JO5f1AIJMwvIS2xe85Z5AqPALCQ7ZiFUzUJStYCReRWjaGpp
	ckFxUnquoV5xYm5xaV66XnJ+7iZGSIh/2cG4+JjVIUYBDkYlHt6T72eECLEmlhVX5h5ilOBg
	VhLhVW8FCvGmJFZWpRblxxeV5qQWH2Jk4uCUamBUjr+cOlXo+sfkL99Erlw38fpXdTZTXvlI
	s5zG/szjsSULP6hcq3DrzfOPtXu6QNPI5f0f6euf/AQFA+9OOHWBd1/Qba1O6VvZCy7OTnlV
	13BWv0emokemVqtc76Lbjfu2nIbz7k5Z+XpPG6dR1b24D4ViHa/6nnwwOqk9S6osZMWJwycX
	VAcpsRRnJBpqMRcVJwIADX8rqU8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 12/22/2014 05:34 PM, Felipe Balbi wrote:
> On Mon, Dec 15, 2014 at 11:05:22AM +0100, Robert Baldyga wrote:
>> On 12/15/2014 06:13 AM, Peter Chen wrote:
>>> On Fri, Dec 12, 2014 at 02:17:28PM +0100, Robert Baldyga wrote:
>>>> As usb function drivers assumes that all usb request will be completed
>>>> before function unbind call, we should supply such behavior. In some
>>>> cases ep_disable() won't kill all request effectively, because some
>>>> IN requests can be in running state. In such situation it's possible
>>>> to have unbind function called before last request completion, which
>>>> can cause problems.
>>>
>>> Doesn't the function's disable/unbind should call usb_ep_dequeue to make
>>> sure the transfer has ended?
>>
>> USB function drivers like ECM or HID surely doesn't. It looks like
>> there's assumption that all requests will be completed by UDC driver.
> 
> that's a bug on those drivers :-)

So we can't make assumptions that requests will be completed in
ep_disable()?

> 
>> Function ep_disable() should complete requests in hardware driver, but
>> at least in DWC2 driver not all requests are completed at this stage
> 
> and that's a bug on dwc2 :-)

I have already found that out. Another UDC drivers simply kill all
request without waiting for currently running, so I did the same in
DWC2. Here is my patch:
http://www.spinics.net/lists/linux-usb/msg118698.html

> 
>> (request which are in hardware FIFO are omitted to give them chance to
>> be transferred). Those requests are forced to complete in udc_stop()
> 
> that's wrong, we're disabling the endpoint anyway. Either dwc2 needs to
> wait_for_completion() or forcibly cancel the request. The bottom line is
> that control should not exit ep_disable() until all requests have been
> quiesced.

So that's not bug in function drivers. They make correct assumption,
because they expect that requests will be completed in ep_disable().

> 
>> function, and that's why it's needed to be called before unbind.
>>
>>>
>>> .udc_stop may stop the controller, and .unbind may still visit hardware.
>>
>> Hmm, indeed it can be problem.
> 
> yes, it will be :-)
> 

Thanks,
Robert Baldyga
