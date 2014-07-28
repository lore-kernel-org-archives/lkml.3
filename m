Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaG1Lwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:52:37 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49574 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaG1Lwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:52:35 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-fd-53d6397f5c36
Message-id: <53D6397F.50403@samsung.com>
Date: Mon, 28 Jul 2014 13:52:31 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com
Subject: Re: [PATCH v2 1/3] usb: gadget: f_fs: virtual address mapping
References: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com>
 <1406295363-26998-2-git-send-email-r.baldyga@samsung.com>
 <xa1ttx65ttca.fsf@mina86.com> <53D5E539.9030609@samsung.com>
 <xa1tk36xrde3.fsf@mina86.com>
In-reply-to: <xa1tk36xrde3.fsf@mina86.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xK7r1lteCDZbtN7WY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9ktFhxvYXVg99g/dw27x7o/r5g8+rasYvQ4fmM7k8fnTXIB
	rFFcNimpOZllqUX6dglcGW++3GQumClV8fzXZfYGxnmiXYwcHBICJhLr52V0MXICmWISF+6t
	Z+ti5OIQEljKKNF8+hgrhPORUeLPpd/sIFW8AhoS+3c/ZgKxWQRUJT5uO8UGYrMJ6Ehs+T6B
	EcQWFQiTePbrIBNEvaDEj8n3WEBsEQFziRN/V7CADGUW6GKUWP/1JNhQYQE3iYN/Z0Jte8Ao
	sWjFW7AEp4CWxNsZ31lATmUWUJeYMiUXJMwsIC+xec1b5gmMArOQ7JiFUDULSdUCRuZVjKKp
	pckFxUnpuYZ6xYm5xaV56XrJ+bmbGCEh/mUH4+JjVocYBTgYlXh4I25eCRZiTSwrrsw9xCjB
	wawkwjtV/1qwEG9KYmVValF+fFFpTmrxIUYmDk6pBsb5ov1Gb17/TN1i0tuyZMVu32VREzhq
	mP/+9zlg2R/qzK2999XHyR75q91uzJlct/rR7v+s+hf4/6/+bRhq1r6YaxVD5UKzWxc0Z6lW
	v/zvLiEiV3Mg+d+6hsSoH9p3kj7v6fl5VqJ81Z8/yzRfVicE1DFNe908wbdX9+zmdT9r1QJF
	9m99tE9MiaU4I9FQi7moOBEANgJb0E8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 12:22 PM, Michal Nazarewicz wrote:
> On Mon, Jul 28 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
>> On 07/25/2014 04:18 PM, Michal Nazarewicz wrote:
>>> On Fri, Jul 25 2014, Robert Baldyga wrote:
>>>> This patch adds virtual endpoint address mapping to functionfs.
>>>>
>>>> So far endpoint addresses given by user through endpoint descriptors
>>>> were ignored, and replaced by physical endpoint addresses. Endpoint
>>>> address in wIndex field of setup requesti, addressed to endpoint, was
>>>> the physical endpoint address, and names of files in functionfs
>>>> directory was numered in order, and were the same as indexes of
>>>> ffs_epfile in epfile array. In result user has no way to indicate
>>>> which file in functionfs is associated with which particular
>>>> requested endpoint. He also didn't know which endpoint is recipient
>>>> of setup request.
>>>
>>> Couldn't that be solved by simply providing the mapping to user space?
>>
>> There would be only small differences in code (add mapping instead of
>> changing file names) so why would we not want do it in more intuitive
>> way?
> 
> So I'm confused again.  With your patch, the endpoint number read from
> user space will have barring *only* on the file name and it *will not*
> correspond to the real/physical endpoint number, right?  Why do we want
> that?  What's the advantage over having endpoints numbered in the order
> they were specified?
> 
> To know what physical number endpoint has, user space would have to read
> the descriptor via the new proposed ioctl or get a mapping from ep file
> names to physical endpoint numbers.

No, endpoint number read from user space will also affects on value in
wIndex field in setup request. The goal is to have only one number
identifying each endpoint. User can choose this number through endpoint
descriptor, and then use it in each context - to open endpoint file, to
find recipient of setup request, to recognize which endpoint is linked
with particular fd using FUNCTIONFS_ENDPOINT_DESC ioctl.

Yes, this ioctl returns bEndpointAddress in function address space. To
obtain physical endpoint address (which shouldn't be needed in functions
compatible with USB specification), there is another ioctl -
FUNCTIONFS_ENDPOINT_REVMAP.

The main advantage is that each function has its own "sandbox" and it
can work as if it was the only function in gadget. Furthermore it's less
confusing for user than ignoring endpoint number chosen in descriptor,
create endpoint files numbered in order they were specified, and refer
to endpoints using physical addresses in setup requests...

> 
>>>> There was also one more problem - if endpoint addresses in descriptors
>>>> were non-consecutive, there were created redundant files, which could
>>>> cause problems in kernel, when user tryed to read/write to them.
>>>> It was result of fact that maximum endpoint address was taken as
>>>> total number of endpoints in funciton.
>>>
>>> This is kinda unrelated though.  I mean it's a separate bug.
>>
>> Yes, but it can be fixed by the way, as a side effect, so there is no
>> sense (and probably no simple way) to move it into separate patch.
> 
> Right, but now, we're arguing about the whole patch as opposed to having
> part of it already acked. :P
> 

