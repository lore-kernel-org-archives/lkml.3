Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbaIIGCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:02:22 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12405 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbaIIGCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:02:20 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
X-AuditID: cbfec7f5-b7f776d000003e54-28-540e97e9d96b
Content-transfer-encoding: 8BIT
Message-id: <540E97E8.80701@samsung.com>
Date: Tue, 09 Sep 2014 08:02:16 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 2/2] usb: gadget: f_fs: virtual endpoint address
 mapping
References: <1410163020-13910-1-git-send-email-r.baldyga@samsung.com>
 <1410163020-13910-3-git-send-email-r.baldyga@samsung.com>
 <20140908134733.GL22409@saruman.home>
In-reply-to: <20140908134733.GL22409@saruman.home>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xq7ovp/OFGMybYWhx8H69RfPi9WwW
	l3fNYbNYtKyV2YHFY//cNewex29sZ/L4vEkugDmKyyYlNSezLLVI3y6BK+Pr6gMsBQvFKy49
	0Gxg/CnUxcjJISFgIjFlYxc7hC0mceHeerYuRi4OIYGljBKt3x6wgiR4BQQlfky+x9LFyMHB
	LCAvceRSNoSpLjFlSi5E+UdGiestO1lB4rwCGhKrH5qAdLIIqEosXzCJDcRmE9CR2PJ9AiOI
	LSoQJvHs10EmEFtEQEBi/YtL7BAjIyW2NIiCmMICERJ7rllCTF/JKLH05Wawck4BI4mti9ex
	TWAUmIXktlkIt81CuG0BI/MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJAg/bqDcekxq0OM
	AhyMSjy8E8v4QoRYE8uKK3MPMUpwMCuJ8DLEAoV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwhv96
	covJavKFzZUlta3Ohg6JAWo9Weu3+4i+9NgRVnZ1TriXfJf6s8oZ+o8vRd4sN1YRWu4Z0XZD
	0WhX+BqfldWhzXMzXz7nkjihKjtr38kj1zfvMM+Za7J6il1s/cTZfpGaFdulXY5ZtUx6/npF
	snLm4czPe8QsDPJiDpZpfJjpZCkeEsuvxFKckWioxVxUnAgAl1wRhDACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 03:47 PM, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Sep 08, 2014 at 09:57:00AM +0200, Robert Baldyga wrote:
>> This patch introduces virtual endpoint address mapping. It separates
>> function logic form physical endpoint addresses making it more hardware
>> independent.
>>
>> Following modifications changes user space API, so to enable them user
>> have to switch on the FUNCTIONFS_VIRTUAL_ADDR flag in descriptors.
>>
>> Endpoints are now refered using virtual endpoint addresses chosen by
>> user in endpoint descpriptors. This applies to each context when endpoint
>> address can be used:
>> - when accessing endpoint files in FunctionFS filesystemi (in file name),
>> - in setup requests directed to specific endpoint (in wIndex field),
>> - in descriptors returned by FUNCTIONFS_ENDPOINT_DESC ioctl.
>>
>> In endpoint file names the endpoint address number is formatted as
>> double-digit hexadecimal value ("ep%02x") which has few advantages -
>> it is easy to parse, allows to easly recognize endpoint direction basing
>> on its name (IN endpoint number starts with digit 8, and OUT with 0)
>> which can be useful for debugging purpose, and it makes easier to introduce
>> further features allowing to use each endpoint number in both directions
>> to have more endpoints available for function if hardware supports this
>> (for example we could have ep01 which is endpoint 1 with OUT direction,
>> and ep81 which is endpoint 1 with IN direction).
>>
>> Physical endpoint address can be still obtained using ioctl named
>> FUNCTIONFS_ENDPOINT_REVMAP, but now it's not neccesary to handle
>> USB transactions properly.
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
> after this patch I get build errors:
> 
> drivers/usb/gadget/function/f_fs.c: In function ‘ffs_epfiles_create’:
> drivers/usb/gadget/function/f_fs.c:1555:40: error: ‘struct ffs_data’ has no member named ‘eps_addrmap’
>     sprintf(epfiles->name, "ep%02x", ffs->eps_addrmap[i]);
>                                         ^
> drivers/usb/gadget/function/f_fs.c: In function ‘ffs_func_setup’:
> drivers/usb/gadget/function/f_fs.c:2900:19: error: ‘struct ffs_data’ has no member named ‘eps_addrmap’
>     ret = func->ffs->eps_addrmap[ret];
>                    ^
> make[3]: *** [drivers/usb/gadget/function/f_fs.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [drivers/usb/gadget/function] Error 2
> make[1]: *** [drivers/usb/gadget] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [drivers/usb/] Error 2
> 

Array "eps_addrmap" was introduced in patch "usb: gadget: f_fs: fix the
redundant ep files problem". I have received mails from you and Greg
that it's already applied to usb tree, so I have assumed that there is
no need to include it to this patchset. I can resend this patch if it's
needed.
