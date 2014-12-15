Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaLOQBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:01:22 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30595 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaLOQBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:01:18 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-95-548f05cbb852
Message-id: <548F05CA.4080702@samsung.com>
Date: Mon, 15 Dec 2014 17:01:14 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "k.opasiak@samsung.com" <k.opasiak@samsung.com>
Subject: Re: [PATCH] usb: dwc2: gadget: kill requests with 'force' in
 s3c_hsotg_udc_stop()
References: <1418132505-897-1-git-send-email-r.baldyga@samsung.com>
 <A2CA0424C0A6F04399FB9E1CD98E030484500C06@US01WEMBX2.internal.synopsys.com>
In-reply-to: <A2CA0424C0A6F04399FB9E1CD98E030484500C06@US01WEMBX2.internal.synopsys.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xq7qnWftDDG6uFrU4eL/eonnxejaL
	2xOnsVlc3jWHzWLRslZmi7VH7rJbPHq4ldWB3WP/3DXsHn1bVjF6bNn/mdHj+I3tTB6fN8kF
	sEZx2aSk5mSWpRbp2yVwZbw4f4W1YJ5qxZcJtQ2MU+W7GDk5JARMJF69uc4KYYtJXLi3nq2L
	kYtDSGApo8TTK20sIAkhgY+MEmfadEFsXgEtiUUnTzGD2CwCqhInz74Aq2ET0JHY8n0CI4gt
	KhAhcWXNHEaIekGJH5PvgdWICBhIbDg6DWwBs8AxJolvx7czgSSEBWIk/k/ZBrV5IqPExWtz
	wTo4BaIkuq9sYe9i5ADq0JO4f1ELJMwsIC+xec1b5gmMArOQ7JiFUDULSdUCRuZVjKKppckF
	xUnpuYZ6xYm5xaV56XrJ+bmbGCEB/mUH4+JjVocYBTgYlXh4E/b2hgixJpYVV+YeYpTgYFYS
	4Z31ri9EiDclsbIqtSg/vqg0J7X4ECMTB6dUA6P9j/X8Sdt8WKoWtTF/N7BdOdVFsOtbouM/
	Ec+3ewoVCh4FPcjb6byYn+Xh1cjLh6+LTnfcsERi1rx/Hk6NHqJ2Kw9HizzLSdz8zerdrlOx
	jWlz3Cfo9r7jnr4+R3jPJ++kTf8/+nOKyktEOt3pC5L61Z57htOsfU1sl+jkarkdxTf8SvSW
	iiixFGckGmoxFxUnAgA9x/03TgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 08:34 PM, Paul Zimmerman wrote:
>> From: Robert Baldyga [mailto:r.baldyga@samsung.com]
>> Sent: Tuesday, December 09, 2014 5:42 AM
>>
>> This makes us sure that all requests are completed before we unbind
>> gadget. There are assumptions in gadget API that all requests have to
>> be completed and leak of complete can break some usb function drivers.
>>
>> For example unbind of ECM function can cause NULL pointer dereference:
>>
>> [   26.396595] configfs-gadget gadget: unbind function
>> 'cdc_ethernet'/e79c4c00
>> [   26.414999] Unable to handle kernel NULL pointer dereference at
>> virtual address 00000000
>> (...)
>> [   26.452223] PC is at ecm_unbind+0x6c/0x9c
>> [   26.456209] LR is at ecm_unbind+0x68/0x9c
>> (...)
>> [   26.603696] [<c033fdb4>] (ecm_unbind) from [<c033661c>]
>> (purge_configs_funcs+0x94/0xd8)
>> [   26.611674] [<c033661c>] (purge_configs_funcs) from [<c0336674>]
>> (configfs_composite_unbind+0x14/0x34)
>> [   26.620961] [<c0336674>] (configfs_composite_unbind) from
>> [<c0337124>] (usb_gadget_remove_driver+0x68/0x9c)
>> [   26.630683] [<c0337124>] (usb_gadget_remove_driver) from [<c03376c8>]
>> (usb_gadget_unregister_driver+0x64/0x94)
>> [   26.640664] [<c03376c8>] (usb_gadget_unregister_driver) from
>> [<c0336be8>] (unregister_gadget+0x20/0x3c)
>> [   26.650038] [<c0336be8>] (unregister_gadget) from [<c0336c84>]
>> (gadget_dev_desc_UDC_store+0x80/0xb8)
>> [   26.659152] [<c0336c84>] (gadget_dev_desc_UDC_store) from
>> [<c0335120>] (gadget_info_attr_store+0x1c/0x28)
>> [   26.668703] [<c0335120>] (gadget_info_attr_store) from [<c012135c>]
>> (configfs_write_file+0xe8/0x148)
>> [   26.677818] [<c012135c>] (configfs_write_file) from [<c00c8dd4>]
>> (vfs_write+0xb0/0x1a0)
>> [   26.685801] [<c00c8dd4>] (vfs_write) from [<c00c91b8>]
>> (SyS_write+0x44/0x84)
>> [   26.692834] [<c00c91b8>] (SyS_write) from [<c000e560>]
>> (ret_fast_syscall+0x0/0x30)
>> [   26.700381] Code: e30409f8 e34c0069 eb07b88d e59430a8 (e5930000)
>> [   26.706485] ---[ end trace f62a082b323838a2 ]---
>>
>> It's because in some cases request is still running on endpoint during
>> unbind and kill_all_requests() called from s3c_hsotg_udc_stop() function
>> doesn't cause call of complete() of request. Missing complete() call
>> causes ecm->notify_req equals NULL in ecm_unbind() function, and this
>> is reason of this bug.
>>
>> Similar breaks can be observed in another usb function drivers.
>>
>> This patch fixes this bug forcing usb request completion in when
>> s3c_hsotg_ep_disable() is called from s3c_hsotg_udc_stop().
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>> ---
>>  drivers/usb/dwc2/gadget.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
>> index 8b5c079..cb4c925 100644
>> --- a/drivers/usb/dwc2/gadget.c
>> +++ b/drivers/usb/dwc2/gadget.c
>> @@ -2590,7 +2590,7 @@ error:
>>   * s3c_hsotg_ep_disable - disable given endpoint
>>   * @ep: The endpoint to disable.
>>   */
>> -static int s3c_hsotg_ep_disable(struct usb_ep *ep)
>> +static int s3c_hsotg_ep_disable_force(struct usb_ep *ep, bool force)
>>  {
>>  	struct s3c_hsotg_ep *hs_ep = our_ep(ep);
>>  	struct s3c_hsotg *hsotg = hs_ep->parent;
>> @@ -2611,7 +2611,7 @@ static int s3c_hsotg_ep_disable(struct usb_ep *ep)
>>
>>  	spin_lock_irqsave(&hsotg->lock, flags);
>>  	/* terminate all requests with shutdown */
>> -	kill_all_requests(hsotg, hs_ep, -ESHUTDOWN, false);
>> +	kill_all_requests(hsotg, hs_ep, -ESHUTDOWN, force);
>>
>>  	hsotg->fifo_map &= ~(1<<hs_ep->fifo_index);
>>  	hs_ep->fifo_index = 0;
>> @@ -2632,6 +2632,10 @@ static int s3c_hsotg_ep_disable(struct usb_ep *ep)
>>  	return 0;
>>  }
>>
>> +static int s3c_hsotg_ep_disable(struct usb_ep *ep)
>> +{
>> +	return s3c_hsotg_ep_disable_force(ep, false);
>> +}
>>  /**
>>   * on_list - check request is on the given endpoint
>>   * @ep: The endpoint to check.
>> @@ -2933,7 +2937,7 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
>>
>>  	/* all endpoints should be shutdown */
>>  	for (ep = 1; ep < hsotg->num_of_eps; ep++)
>> -		s3c_hsotg_ep_disable(&hsotg->eps[ep].ep);
>> +		s3c_hsotg_ep_disable_force(&hsotg->eps[ep].ep, true);
>>
>>  	spin_lock_irqsave(&hsotg->lock, flags);
>>  
> 
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> 

One more thing which I have forgot to write: This patch makes sense only
with my patch to udc-core [1] which modifies order of calls in
usb_gadget_remove_driver() function. Hence this patch shouldn't be
applied before [1] will be accepted.

[1] https://lkml.org/lkml/2014/12/12/360

Best regards,
Robert Baldyga
