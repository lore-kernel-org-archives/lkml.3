Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbbAWMey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:34:54 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54354 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbbAWMet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:34:49 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
X-AuditID: cbfec7f4-b7f126d000001e9a-68-54c23f5500b4
Content-transfer-encoding: 8BIT
Message-id: <54C23FE5.9030403@samsung.com>
Date: Fri, 23 Jan 2015 13:34:45 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
To: =?UTF-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <mina86@mina86.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>, balbi@ti.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: ffs: add eventfd notification about ffs events
References: <1422005298-31321-1-git-send-email-r.baldyga@samsung.com>
 <CA+pa1O0nZJ6G1NpPF+qHvchnfSuCvi-f0KMROkOkVq6pNkMX3Q@mail.gmail.com>
In-reply-to: <CA+pa1O0nZJ6G1NpPF+qHvchnfSuCvi-f0KMROkOkVq6pNkMX3Q@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t/xy7qh9odCDCZeULc4eL/eonnxejaL
	2xOnsVlc3jWHzWLRslZmiwXHW1gd2Dz2z13D7rHuzysmj74tqxg9jt/YzuTxeZNcAGsUl01K
	ak5mWWqRvl0CV8bMz7EFr3krLs3jaWDcwNnFyMkhIWAicWnaKiYIW0ziwr31bF2MXBxCAksZ
	JVqXzGcDSfAKCEr8mHyPpYuRg4NZQF7iyKVsCFNdYsqUXIjyj4wSzycchirXkrh+bQ4bSA2L
	gKrEpdn1IGE2AR2JLd8nMILYogIREh9WfQUrERGwkXjbJQgSZhZYySgx6bY2iC0sECDxrGsZ
	O8T4HkaJFTcmsoIkOAWCJXrOfGCcwCgwC8lxsxCOm4Vw3AJG5lWMoqmlyQXFSem5hnrFibnF
	pXnpesn5uZsYIcH8ZQfj4mNWhxgFOBiVeHh3PD0YIsSaWFZcmXuIUYKDWUmE11rzUIgQb0pi
	ZVVqUX58UWlOavEhRiYOTqkGRv/MZnXT6/2hE66e2OdSPfN8RFc0W9sX4zDdJSLL4oqZtu6J
	m28uOtWQ9UmlsMqU+APz0pP3fmb73ZBVuPlyiME7pksWpxQPffy4t3A6S63gNiOhRc0zlnRN
	rbza1Xm8/voOhSndly5//ewYd7KvR/ivkYH7VL2AM19Phoncj9ti/tBI3P/oXiWW4oxEQy3m
	ouJEAFWVnnNEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 01:21 PM, Michał Nazarewicz wrote:
> 23 sty 2015 10:28 "Robert Baldyga" <r.baldyga@samsung.com
> <mailto:r.baldyga@samsung.com>> napisał(a):
>> Add eventfd which notifies userspace about ep0 events and AIO completion
>> events. It simplifies using of FunctionFS with event loop, because now
>> we need to poll on single file (instead of polling on ep0 and eventfd's
>> supplied to AIO layer).
>>
>> FunctionFS eventfd is not triggered if another eventfd is supplied to
>> AIO layer (in AIO request). It can be useful, for example, when we want
>> to handle AIO transations for chosen endpoint in separate thread.
>>
>> Signed-off-by: Robert Baldyga
> 
> I don't know much about eventfd interface bit from ffs point of view:
> 
> Acked-by: Michal Nazarewicz <mina86@mina86.com <mailto:mina86@mina86.com>>
> 
>> @@ -2180,6 +2191,20 @@ static int __ffs_data_got_descs(struct ffs_data
> *ffs,
>>                 goto error;
>>         }
>>
>> +       if (flags & FUNCTIONFS_EVENTFD) {
>> +               if (len < 4)
>> +                       goto error;
>> +               ffs->ffs_eventfd =
>> +                       eventfd_ctx_fdget((int)get_unaligned_le32(data));
>> +               if (IS_ERR(ffs->ffs_eventfd)) {
>> +                       ffs->ffs_eventfd = NULL;
>> +                       ret = PTR_ERR(ffs->ffs_eventfd);
> 
> Need to swap those lines.
> 
>> +                       goto error;
>> +               }
>> +               data += 4;
>> +               len  -= 4;
>> +       }
>> +
>>         /* Read fs_count, hs_count and ss_count (if present) */
>>         for (i = 0; i < 3; ++i) {
>>                 if (!(flags & (1 << i))) {
> 

Good catch, thanks!

Best regards,
Robert Baldyga
