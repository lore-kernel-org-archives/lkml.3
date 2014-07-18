Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965395AbaGRLIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:08:02 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31596 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281AbaGRLIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:08:00 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-47-53c9000de393
Message-id: <53C9000F.4070007@samsung.com>
Date: Fri, 18 Jul 2014 13:07:59 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "balbi@ti.com" <balbi@ti.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "andrzej.p@samsung.com" <andrzej.p@samsung.com>
Subject: Re: [PATCH v2 10/12] usb: dwc2/gadget: assign TX FIFO dynamically
References: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
 <1405506150-16185-11-git-send-email-r.baldyga@samsung.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844BEA77@US01WEMBX2.internal.synopsys.com>
In-reply-to: <A2CA0424C0A6F04399FB9E1CD98E0304844BEA77@US01WEMBX2.internal.synopsys.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xa7q8DCeDDW4eVreY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9ktHj3cyurA7rF/7hp2j74tqxg9tuz/zOhx/MZ2Jo/Pm+QC
	WKO4bFJSczLLUov07RK4Mn5tW8dcsJGvYum960wNjIu5uxg5OSQETCReL9rLCGGLSVy4t54N
	xBYSWMoosX0fSxcjF5D9kVFiRcMRZpAEr4CWxM5dK9hBbBYBVYmFjS/AbDYBHYkt3yeADRIV
	iJA40PeMFaJeUOLH5HssILaIgL/ErFO/mECGMgssZZI4cXsx2FBhAS+J3itdjBDbLjBK/Jr4
	BayDUyBK4ufkVrAiZqAN+1unsUHY8hKb17xlnsAoMAvJkllIymYhKVvAyLyKUTS1NLmgOCk9
	10ivODG3uDQvXS85P3cTIyTMv+5gXHrM6hCjAAejEg/vApMTwUKsiWXFlbmHGCU4mJVEeLPv
	Hw8W4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLg8/2DKZv+TV054KvP2bCtiFYoPCv3/6h7Ph1lz
	LOz2Tb169Lu/aM9E64ZAY/VrqXutnfT6c2P2z17mtWhKkSxX/o/J72yMjJvW6s16nrh27VnV
	OWy7Nb5WqTNsvCj89eOsaNMpPzkPbLycFqo9J3Lti/v6S56suPsuhnduhPLb0PDyb5MTJW4o
	sRRnJBpqMRcVJwIAAaLtAVECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 09:58 PM, Paul Zimmerman wrote:
>> From: Robert Baldyga [mailto:r.baldyga@samsung.com]
>> Sent: Wednesday, July 16, 2014 3:22 AM
>>
>> Because we have not enough memory to have each TX FIFO of size at least 3072
>> bytes (the maximum single packet size), we create four FIFOs of lenght 1024,
>> and four of length 3072 bytes, and assing them to endpoints dynamically
>> according to maxpacket size value of given endpoint.
> 
> I don't think this commit message entirely explains what you are doing
> here.
> 
> 3072 is actually 3 times the max packet size for an Isoc endpoint. So you
> want to have four TX FIFOs of that size, presumably to be assigned to
> Isoc endpoints. Where before this change, all TX FIFOs were of size 768,
> which is not even 1 max packet size for an Isoc endpoint. So I guess you
> were seeing some problem with that?

FIFO size in DPTXFSIZn register is in terms of 32-bit words, so
768*4=3072 - maximum packet size with 3 transactions per microframe
(Mult=2). The problem is that we have not enough memory to have all
FIFOs of this size, so we split available memory to have at least few
FIFOs of maximum packet size.

> 
> With a TX FIFO size of 3072, an entire microframe worth of Isoc data
> (when MaxBurst=2) can fit in the FIFO. I guess that is why you chose
> 3072?
> 

Yes, this is why I chose this value.

> Also, after this change, you are only initializing 8 TX FIFOs, where
> before you were initializing all 15. So now there can only be a maximum
> of 8 IN endpoints active at the same time. That's OK I guess, but I
> think you should mention that in the commit message.
> 

We use only 8 IN endpoints so there is no need to have more TX FIFOs.

I'm preparing v3 of this patchset so I will supply better description.

Thanks,
Robert Baldyga
