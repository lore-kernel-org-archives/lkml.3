Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaHYIIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:08:41 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18699 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbaHYIIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:08:38 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-dc-53faef041268
Message-id: <53FAEF03.6060305@samsung.com>
Date: Mon, 25 Aug 2014 10:08:35 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, k.opasiak@samsung.com
Subject: Re: [PATCH v5 1/3] usb: gadget: f_fs: fix the redundant ep files
 problem
References: <1408622959-4096-1-git-send-email-r.baldyga@samsung.com>
 <1408622959-4096-2-git-send-email-r.baldyga@samsung.com>
 <xa1tsikmug8j.fsf@mina86.com>
In-reply-to: <xa1tsikmug8j.fsf@mina86.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xy7os738FG7z5wWcx62U7i8XB+/UW
	zYvXs1ncnjiNzeLyrjlsFouWtTJbrD1yl91iwfEWVgcOj/1z17B7rPvzismjb8sqRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CVceDkBcaCjSoV7RNOszQwnpLpYuTkkBAwkWj718sIYYtJ
	XLi3nq2LkYtDSGApo8Szf3OZIJyPjBKvuvewg1TxCmhJtN5eD9bBIqAq0dK1FsxmE9CR2PJ9
	ApgtKhAm8ezXQSaIekGJH5PvsYDYIgLmEif+rgCzmQUWM0r090mD2MICwRILOpaDzRcSmM8o
	8fypJojNCbTr2p5XzF2MHED16hJTpuRCtMpLbF7zlnkCo8AsJBtmIVTNQlK1gJF5FaNoamly
	QXFSeq6RXnFibnFpXrpecn7uJkZIqH/dwbj0mNUhRgEORiUe3gNyv4KFWBPLiitzDzFKcDAr
	ifA+fwMU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwBiXcCv3oc4SS5l4VbXZjzf+3TH/wdf0FRqH
	tcrkby/b2XDWdX6ZXsQhiX0sf6ymFL9fqZihfe9S/4POH6WvjQ9MWlg5bdGm4mPqryvennqu
	0LQx+23hN265nZ+ipaVUf772nT7l4/ecn/MyxD+vSlFddKP/1voHvInXdOvP79ReVMgsH2av
	eKBbiaU4I9FQi7moOBEAgwZCuFMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2014 04:14 PM, Michal Nazarewicz wrote:
> On Thu, Aug 21 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
>> Up to now, when endpoint addresses in descriptors were non-consecutive,
>> there were created redundant files, which could cause problems in kernel,
>> when user tryed to read/write to them. It was result of fact that maximum
>             ^^^^^  -- tried
> 
>> endpoint address was taken as total number of endpoints in funciton.
>>
>> This patch adds endpoint descriptors counting and storing their addresses
>> in eps_addrmap to verify their cohesion in each speed.
>>
>> Endpoint address map would be also useful for further features, just like
>> vitual endpoint address mapping.
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> 
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
>> @@ -1853,14 +1860,23 @@ static int __ffs_data_do_entity(enum ffs_entity_type type,
>>  		 * Strings are indexed from 1 (0 is magic ;) reserved
>>  		 * for languages list or some such)
>>  		 */
>> -		if (*valuep > ffs->strings_count)
>> -			ffs->strings_count = *valuep;
>> +		if (*valuep > helper->ffs->strings_count)
>> +			helper->ffs->strings_count = *valuep;
>>  		break;
>>  
>>  	case FFS_ENDPOINT:
>> -		/* Endpoints are indexed from 1 as well. */
>> -		if ((*valuep & USB_ENDPOINT_NUMBER_MASK) > ffs->eps_count)
>> -			ffs->eps_count = (*valuep & USB_ENDPOINT_NUMBER_MASK);
>> +		d = (void *)desc;
>> +		helper->eps_count++;
>> +		if (helper->eps_count >= 15)
>> +			return -EINVAL;
>> +		if (!helper->ffs->eps_count && !helper->ffs->interfaces_count)
> 
> I'd check helper->ffs->eps_count only.  helper->ffs->interfaces_count is
> zero only because endpoints and interfaces are interpret at the same
> time, but otherwise the interfaces_count is unrelated to what we're
> doing here.

Besides simple descriptor counting there are done checks if endpoints
number and their addressed are identical for each speed. For this reason
we need to know inside this function if descriptors for any speed was
already done. If it's true, we check if endpoint descriptors for current
speed has proper addresses.

There is possibility that interface has no endpoints (endpoint 0 only),
so we can recognize that descriptors for one speed were already parsed
only basing on interfaces_count. In that case if FFS_ENDPOINT will
appear, eps_count will exceed number of endpoints in previously parsed
descriptors and error will be returned.

> 
> Also, perhaps adding a comment describing what !helper->ffs->eps_count
> means makes sense here.
> 
>> +			helper->ffs->eps_addrmap[helper->eps_count] =
>> +				d->bEndpointAddress;
>> +		else if (helper->ffs->eps_count < helper->eps_count)
>> +			return -EINVAL;
> 
> Doesn't this duplicate check in __ffs_data_got_descs?
> 
>> +		else if (helper->ffs->eps_addrmap[helper->eps_count] !=
>> +				d->bEndpointAddress)
>> +			return -EINVAL;
>>  		break;
>>  	}
>>  
>> @@ -2101,13 +2118,29 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
>>  
>>  	/* Read descriptors */
>>  	raw_descs = data;
>> +	helper.ffs = ffs;
>>  	for (i = 0; i < 3; ++i) {
>>  		if (!counts[i])
>>  			continue;
>> +		helper.interfaces_count = 0;
>> +		helper.eps_count = 0;
>>  		ret = ffs_do_descs(counts[i], data, len,
>> -				   __ffs_data_do_entity, ffs);
>> +				   __ffs_data_do_entity, &helper);
>>  		if (ret < 0)
>>  			goto error;
>> +		if (!ffs->eps_count && !ffs->interfaces_count) {
>> +			ffs->eps_count = helper.eps_count;
>> +			ffs->interfaces_count = helper.interfaces_count;
>> +		} else {
>> +			if (ffs->eps_count != helper.eps_count) {
>> +				ret = -EINVAL;
>> +				goto error;
>> +			}
>> +			if (ffs->interfaces_count != helper.interfaces_count) {
>> +				ret = -EINVAL;
>> +				goto error;
>> +			}
>> +		}
>>  		data += ret;
>>  		len  -= ret;
>>  	}
>> @@ -2342,9 +2375,18 @@ static void ffs_event_add(struct ffs_data *ffs,
>>  	spin_unlock_irqrestore(&ffs->ev.waitq.lock, flags);
>>  }
>>  
>> -
>>  /* Bind/unbind USB function hooks *******************************************/
>>  
>> +static int ffs_ep_addr2idx(struct ffs_data *ffs, u8 endpoint_address)
>> +{
>> +	int i;
>> +
>> +	for (i = 1; i < 15; ++i)
> 
> +	for (i = 1; i < ARRAY_SIZE(ffs->eps_addrmap); ++i)
> 
>> +		if (ffs->eps_addrmap[i] == endpoint_address)
>> +			return i;
>> +	return -ENOENT;
>> +}
>> +
>>  static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
>>  				    struct usb_descriptor_header *desc,
>>  				    void *priv)
> 

Thanks,
Robert Baldyga
