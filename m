Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaG1GKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:10:39 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61033 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaG1GKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:10:35 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-00-53d5e958a02f
Message-id: <53D5E958.40100@samsung.com>
Date: Mon, 28 Jul 2014 08:10:32 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com
Subject: Re: [PATCH v2 2/3] usb: gadget: f_fs: add ioctl returning ep descriptor
References: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com>
 <1406295363-26998-3-git-send-email-r.baldyga@samsung.com>
 <xa1twqb1ttgq.fsf@mina86.com>
In-reply-to: <xa1twqb1ttgq.fsf@mina86.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xK7oRL68GGzz+ImMx62U7i8XB+/UW
	zYvXs1lc3jWHzWLRslZmi7VH7rJbLDjewurA7rF/7hp2j3V/XjF59G1Zxehx/MZ2Jo/Pm+QC
	WKO4bFJSczLLUov07RK4MprPHmMrmCZW0bRrJ3sD433BLkZODgkBE4kLK9YwQthiEhfurWfr
	YuTiEBJYyihxbuksZgjnI6PE8Wf3mEGqeAU0JM6sX88OYrMIqErMuDGHFcRmE9CR2PJ9Atgk
	UYEwiWe/DjJB1AtK/Jh8jwXEFhEwlzjxdwULyFBmgS5GifVfT4INEhYIkPh2cTsTxLaFjBKv
	Ol+DJTgFtCSevNsJtIEDqENdYsqUXJAws4C8xOY1b5knMArMQrJjFkLVLCRVCxiZVzGKppYm
	FxQnpeca6hUn5haX5qXrJefnbmKEBPmXHYyLj1kdYhTgYFTi4Y24eSVYiDWxrLgy9xCjBAez
	kgiv57mrwUK8KYmVValF+fFFpTmpxYcYmTg4pRoYE0T9I02PmPn/1X0eFvQkd0HHBtdPT8qD
	7ypY/DTrMfxtp/E2YN/MFzKTJ7Z7Knwyfbl0g9QhffHYGkVhT6lvyQf7nR1Pu5xcaRn3PJL9
	UPe/ry/NH1QfrFjyP8inqfBYwpwfL57M1f7j9v9j1b9Dp/XjPBIeHUqYvE3t+yzmToFfe1er
	fC3kVmIpzkg01GIuKk4EAFS2piZQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 04:15 PM, Michal Nazarewicz wrote:
> On Fri, Jul 25 2014, Robert Baldyga wrote:
>> This patch introduces ioctl named FUNCTIONFS_ENDPOINT_DESC, which
>> returns endpoint descriptor to userspace. It works only if function
>> is active.
> 
> I would argue that user space should never need to know the real
> descriptor.  Is this ioctl needed for anything in particular?

It's needed, at least, to inform user space about maximum possible
wMaxPacketSize value for the endpoint, which is returned by autoconfig
through the endpoint descriptor when value set by user is zero.

Descriptor returned form this ioctl is mostly the same as descriptor
created by user. I guess you meant that real descriptor is this one,
which contains real endpoint address, because it's probably only datum
in real descriptor which should be never known by user space.

This ioctl would be also useful in case, when FunctionFS daemon obtains
endpoint descriptors from another daemon, and do not have access to
original descriptor structures given do FunctionFS.

> 
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>> ---
>>  drivers/usb/gadget/f_fs.c           | 17 +++++++++++++++++
>>  include/uapi/linux/usb/functionfs.h |  6 ++++++
>>  2 files changed, 23 insertions(+)
>>
>> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
>> index 490b30f..a2e18cc 100644
>> --- a/drivers/usb/gadget/f_fs.c
>> +++ b/drivers/usb/gadget/f_fs.c
>> @@ -1031,6 +1031,23 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
>>  		case FUNCTIONFS_ENDPOINT_REVMAP:
>>  			ret = epfile->ep->num;
>>  			break;
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
>>  		default:
>>  			ret = -ENOTTY;
>>  		}
>> diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
>> index 1dc473a..1ab6f06 100644
>> --- a/include/uapi/linux/usb/functionfs.h
>> +++ b/include/uapi/linux/usb/functionfs.h
>> @@ -197,6 +197,12 @@ struct usb_functionfs_event {
>>   */
>>  #define	FUNCTIONFS_ENDPOINT_REVMAP	_IO('g', 129)
>>  
>> +/*
>> + * Returns endpoint descriptor. In funciton is not active returns -ENODEV.
>> + */
>> +#define	FUNCTIONFS_ENDPOINT_DESC	_IOR('g', 130, \
>> +					     struct usb_endpoint_descriptor)
>> +
>>  
>>  
>>  #endif /* _UAPI__LINUX_FUNCTIONFS_H__ */
>> -- 
>> 1.9.1
>>
> 

