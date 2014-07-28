Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaG1Gmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:42:52 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29354 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaG1Gms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:42:48 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-d6-53d5f0e5569e
Message-id: <53D5F0E4.1090500@samsung.com>
Date: Mon, 28 Jul 2014 08:42:44 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrzej.p@samsung.com
Subject: Re: [PATCH v2 2/3] usb: gadget: f_fs: add ioctl returning ep descriptor
References: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com>
 <1406295363-26998-3-git-send-email-r.baldyga@samsung.com>
 <xa1twqb1ttgq.fsf@mina86.com>
In-reply-to: <xa1twqb1ttgq.fsf@mina86.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xq7pPP1wNNji4Ws5i1st2FouD9+st
	mhevZ7O4vGsOm8WiZa3MFguOt7BaPDi8k92B3WP/3DXsHuv+vGLy6NuyitHj+I3tTB6fN8kF
	sEZx2aSk5mSWpRbp2yVwZXT/X8hc0Ctcca2tqIFxKn8XIyeHhICJxKw5y9khbDGJC/fWs3Ux
	cnEICSxllLg45QkThPOJUWLJl5+MIFW8AloS7UsPsILYLAKqEseaVzCD2GwChhJdb7vYQGxR
	gRiJM72fmSHqBSV+TL7HAmKLCCRK/PgyB6yXWaBA4sGluUwgtrBAgMS3i9uhli1klHjV+Rrs
	JE6gZU/e7YRqMJN41LKOGcKWl9i85i3zBEaBWUh2zEJSNgtJ2QJG5lWMoqmlyQXFSem5RnrF
	ibnFpXnpesn5uZsYIUH+dQfj0mNWhxgFOBiVeHgL3l0JFmJNLCuuzD3EKMHBrCTC63nuarAQ
	b0piZVVqUX58UWlOavEhRiYOTqkGxsC/Cz76sJYwKqo7r73/4CU390+tr6rpC1foaR8IU+68
	uHvKw5cGRyw+Ojc55al8mnTRXuLc2bhTS3drupjs6/TKyYvU5Di1RsJz07Gzj9oCvh+M7dRM
	6DjU5lN1W03DtPnAVGuuY7+Ygi1Pb8nJ2JbRE8Km/KPT9c2/+xLzI7+HfD8meW7dOiWW4oxE
	Qy3mouJEAKISp8NQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-07-25 16:15, Michal Nazarewicz wrote:
> On Fri, Jul 25 2014, Robert Baldyga wrote:
>> This patch introduces ioctl named FUNCTIONFS_ENDPOINT_DESC, which
>> returns endpoint descriptor to userspace. It works only if function
>> is active.
> I would argue that user space should never need to know the real
> descriptor.  Is this ioctl needed for anything in particular?

Some proprietary broken usb protocols might embed real physical endpoint
(or interface) number into the data stream. In such case functionfs driver
is unable to do proper endpoint/interface number fixup.

>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>> ---
>>   drivers/usb/gadget/f_fs.c           | 17 +++++++++++++++++
>>   include/uapi/linux/usb/functionfs.h |  6 ++++++
>>   2 files changed, 23 insertions(+)
>>
>> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
>> index 490b30f..a2e18cc 100644
>> --- a/drivers/usb/gadget/f_fs.c
>> +++ b/drivers/usb/gadget/f_fs.c
>> @@ -1031,6 +1031,23 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
>>   		case FUNCTIONFS_ENDPOINT_REVMAP:
>>   			ret = epfile->ep->num;
>>   			break;
>> +		case FUNCTIONFS_ENDPOINT_DESC:
>> +		{
>> +			int desc_idx;
>> +			struct usb_endpoint_descriptor *desc;
>> +
>> +			if (epfile->ffs->gadget->speed == USB_SPEED_SUPER)
>> +				desc_idx = 2;
>> +			else if (epfile->ffs->gadget->speed == USB_SPEED_HIGH)
>> +				desc_idx = 1;
>> +			else
>> +				desc_idx = 0;
>> +			desc = epfile->ep->descs[desc_idx];
>> +			ret = copy_to_user((void *)value, desc, sizeof(*desc));
>> +			if (ret)
>> +				ret = -EFAULT;
>> +			break;
>> +		}
>>   		default:
>>   			ret = -ENOTTY;
>>   		}
>> diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
>> index 1dc473a..1ab6f06 100644
>> --- a/include/uapi/linux/usb/functionfs.h
>> +++ b/include/uapi/linux/usb/functionfs.h
>> @@ -197,6 +197,12 @@ struct usb_functionfs_event {
>>    */
>>   #define	FUNCTIONFS_ENDPOINT_REVMAP	_IO('g', 129)
>>   
>> +/*
>> + * Returns endpoint descriptor. In funciton is not active returns -ENODEV.
>> + */
>> +#define	FUNCTIONFS_ENDPOINT_DESC	_IOR('g', 130, \
>> +					     struct usb_endpoint_descriptor)
>> +
>>   
>>   
>>   #endif /* _UAPI__LINUX_FUNCTIONFS_H__ */
>> -- 
>> 1.9.1

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

