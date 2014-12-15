Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaLOKFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:05:30 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18225 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaLOKF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:05:27 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-64-548eb2647fd7
Message-id: <548EB262.6040208@samsung.com>
Date: Mon, 15 Dec 2014 11:05:22 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Peter Chen <peter.chen@freescale.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        k.opasiak@samsung.com
Subject: Re: [PATCH] usb: gadget: udc-core: call udc_stop() before gadget unbind
References: <1418390248-6254-1-git-send-email-r.baldyga@samsung.com>
 <20141215051317.GC25410@shlinux2>
In-reply-to: <20141215051317.GC25410@shlinux2>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t/xK7opm/pCDD63cVocvF9v0bx4PZvF
	7YnT2Cwu75rDZrFoWSuzxdojd9ktjs3+y+TA7vHvcD+Tx/65a9g9+rasYvQ4fmM7k8fnTXIB
	rFFcNimpOZllqUX6dglcGf0LuxkLVgpVLJyl38DYxt/FyMEhIWAisfePYBcjJ5ApJnHh3nq2
	LkYuDiGBpYwSx55+gXI+MkosvzGRBaSKV0BLYtHTKYwgNouAqsSO/avYQWw2AR2JLd8ngMVF
	BSIkrqyZwwhRLyjxY/I9sF4RAU2JdeePMYEMZRaYwSixdd4ZZpCEsECAxOcPN1hBbCGBDImn
	M+8wgdicAnoSR1YvYAS5lBnIvn9RCyTMLCAvsXnNW+YJjAKzkKyYhVA1C0nVAkbmVYyiqaXJ
	BcVJ6bmGesWJucWleel6yfm5mxgh4f1lB+PiY1aHGAU4GJV4eBP29oYIsSaWFVfmHmKU4GBW
	EuGNm9MXIsSbklhZlVqUH19UmpNafIiRiYNTqoFx9p7HsdIr3v2eUucwObXVOWRWxM0vD0Md
	NXe8n6d3Um5aZ4PhBt1jjw+dsji8sUW0VXf+nj+dd1T4+1NfNz2MzL+r2chhvyjs2hkW0TXX
	hFStdN+F1fjZLd98lt/u8ynxjHtdsVd7O3tsfx2cyHql/HvyDocQ31VT/qbwW9T/c1iyaqYT
	o8I2JZbijERDLeai4kQAzkoRCk0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 06:13 AM, Peter Chen wrote:
> On Fri, Dec 12, 2014 at 02:17:28PM +0100, Robert Baldyga wrote:
>> As usb function drivers assumes that all usb request will be completed
>> before function unbind call, we should supply such behavior. In some
>> cases ep_disable() won't kill all request effectively, because some
>> IN requests can be in running state. In such situation it's possible
>> to have unbind function called before last request completion, which
>> can cause problems.
> 
> Doesn't the function's disable/unbind should call usb_ep_dequeue to make
> sure the transfer has ended?

USB function drivers like ECM or HID surely doesn't. It looks like
there's assumption that all requests will be completed by UDC driver.

Function ep_disable() should complete requests in hardware driver, but
at least in DWC2 driver not all requests are completed at this stage
(request which are in hardware FIFO are omitted to give them chance to
be transferred). Those requests are forced to complete in udc_stop()
function, and that's why it's needed to be called before unbind.

> 
> .udc_stop may stop the controller, and .unbind may still visit hardware.

Hmm, indeed it can be problem.

Thanks,
Robert Baldyga

> 
>>
>> For example unbinding f_ecm function while request on 'notify' endpoint
>> is not completed, ends up NULL pointer dereference in unbind() function.
>>
>> usb_gadget_udc_stop() call causes completion of all requests so if it's
>> called before gadget unbind there is no risk that some of requests will
>> stay uncompleted.
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>> ---
>>  drivers/usb/gadget/udc/udc-core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/udc-core.c
>> index e31d574..6f0d233 100644
>> --- a/drivers/usb/gadget/udc/udc-core.c
>> +++ b/drivers/usb/gadget/udc/udc-core.c
>> @@ -331,8 +331,8 @@ static void usb_gadget_remove_driver(struct usb_udc *udc)
>>  
>>  	usb_gadget_disconnect(udc->gadget);
>>  	udc->driver->disconnect(udc->gadget);
>> -	udc->driver->unbind(udc->gadget);
>>  	usb_gadget_udc_stop(udc);
>> +	udc->driver->unbind(udc->gadget);
>>  
>>  	udc->driver = NULL;
>>  	udc->dev.driver = NULL;
>> -- 
>> 1.9.1
>>
> 

