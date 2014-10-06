Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaJFMvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:51:16 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10963 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaJFMvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:51:12 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-59-5432903c6a81
Message-id: <5432903A.9070907@samsung.com>
Date: Mon, 06 Oct 2014 14:51:06 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrzej.p@samsung.com,
        k.opasiak@samsung.com
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
References: <1412594714-535-1-git-send-email-r.baldyga@samsung.com>
 <xa1tvbnx2x4w.fsf@mina86.com>
In-reply-to: <xa1tvbnx2x4w.fsf@mina86.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xq7o2E4xCDN7sE7eY9bKdxeLg/XqL
	5sXr2SxuT5zGZnF51xw2i0XLWpktFhxvYXVg99g/dw27x7o/r5g8+rasYvQ4fmM7k8fnTXIB
	rFFcNimpOZllqUX6dglcGXOvH2YsOCBc8bHxGFsD4z7+LkZODgkBE4mrvx4yQthiEhfurWfr
	YuTiEBJYyiixvP8jO4TzkVHi8PQ3YFW8AloSu+50gtksAqoSs1dMYAax2QR0JLZ8nwAWFxWI
	kDh5dw87RL2gxI/J91hAbBEBc4kTf1ewgAxlFmhnlFjc0gDWLCxgKTFv0VwwW0ggWeL0nW9M
	IDYn0LI7DfOBBnEANahLTJmSCxJmFpCX2LzmLfMERoFZSFbMQqiahaRqASPzKkbR1NLkguKk
	9FxDveLE3OLSvHS95PzcTYyQEP+yg3HxMatDjAIcjEo8vBE7DEOEWBPLiitzDzFKcDArifBq
	9RuFCPGmJFZWpRblxxeV5qQWH2Jk4uCUamDk9Lj956Zd5Vu9mfO01r1YeWJ3MWf9OecqNl1f
	g4Nn5/U+n/Ko5Iv0Sn0RCbHztXbuTk+2/KpjNbvwIGZdq9utr67bM8Wn1xXufD+pb9nL7qN8
	Tt+2nme6+bjm92t5uycaGwrDFZ7GvlEL9EjRfuYqtP/zmvrOd+G7TS4vNX38fYLriVdSD3d1
	K7EUZyQaajEXFScCAC5nHk9PAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 02:36 PM, Michal Nazarewicz wrote:
> On Mon, Oct 06 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
>> Since we can compose gadgets from many functions, there is the problem
>> related to gadget breakage while FunctionFS daemon being closed. In some
>> cases it's strongly desired to keep gadget alive for a while, despite
>> FunctionFS files are closed, to allow another functions to complete
>> some presumably critical operations.
>>
>> For this purpose this patch introduces "zombie" mode. It can be enabled
>> by setting mount option "zombie=1", and results with defering function
>> closure to the moment of reopening ep0 file or filesystem umount.
>>
>> When ffs->state == FFS_ZOMBIE:
>> - function is still binded and visible to host,
>> - setup requests are automatically stalled,
>> - all another transfers are refused,
>> - opening ep0 causes function close, and then FunctionFS is ready for
>>   descriptors and string write,
>> - umount of functionfs cause function close.
> 
> However, all the ep# files will still exist on the filesystem.  This may
> be a bit confusing and error-prone, no?

Shouldn't be error-prone, because opening them will fail with -ENODEV,
but indeed it can be confusing. I will try to do something about that :)

> 
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>> ---
>>  drivers/usb/gadget/function/f_fs.c | 25 ++++++++++++++++++++++---
>>  drivers/usb/gadget/function/u_fs.h |  4 ++++
>>  2 files changed, 26 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
>> @@ -1222,6 +1225,12 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
>>  
>>  		/* Interpret option */
>>  		switch (eq - opts) {
>> +		case 6:
>> +			if (!memcmp(opts, "zombie", 6))
>> +				data->zombie_mode  = !!value;
> 
> Unnecessary double space before =.
> 
>> +			else
>> +				goto invalid;
>> +			break;
>>  		case 5:
>>  			if (!memcmp(opts, "rmode", 5))
>>  				data->root_mode  = (value & 0555) | S_IFDIR;
>> diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/function/u_fs.h
>> @@ -92,6 +92,8 @@ enum ffs_state {
>>  	 */
>>  	FFS_ACTIVE,
>>  
>> +	FFS_ZOMBIE,
>> +
> 
> Add comment describing the state.
> 
>>  	/*
>>  	 * All endpoints have been closed.  This state is also set if
>>  	 * we encounter an unrecoverable error.  The only
> 

Thanks,
Robert Baldyga
