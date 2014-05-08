Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaEHOow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:44:52 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41535 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaEHOov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:44:51 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-31-536b98612858
Message-id: <536B975F.7070603@samsung.com>
Date: Thu, 08 May 2014 18:40:31 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Afzal Mohammed <afzal.mohd.ma@gmail.com>
Cc: linux@arm.linux.org.uk, open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: memset: zero out upper bytes in r1
References: <1399273875-8403-1-git-send-email-a.ryabinin@samsung.com>
 <20140507234255.GA2050@afzal-ThinkPad-R50e> <536B3946.9070106@samsung.com>
In-reply-to: <536B3946.9070106@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t/xy7qJM7KDDWbPYLL4v3E1u8Wmx9dY
	LS7vmsNmcfsyrwOLR0tzD5vHzll32T02L6n3+LxJLoAlissmJTUnsyy1SN8ugSvj0JtH7AX9
	3BVrpy1gamCcwdHFyMkhIWAi0dPcwAxhi0lcuLeerYuRi0NIYCmjRNfmtcwQTiOTxKLOZhaQ
	Kl4BLYlLR+6zgtgsAqoSu3ZtYQSx2QT0JP7N2s4GYosKREjcazzMClEvKPFj8j2wXhEBHYnb
	L3eDbWMW6GCUaN9UDWILC9hIrFjxmhVi2SRGiTvv94M1cwpoS5y5uZYFokFHYn/rNDYIW15i
	85q3zBMYBWYh2TELSdksJGULGJlXMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoQE75cdjIuP
	WR1iFOBgVOLhfRGdESzEmlhWXJl7iFGCg1lJhJd7QnawEG9KYmVValF+fFFpTmrxIUYmDk6p
	BkZd1eilM3hDpn2zmKF0et209N9hVXbrg965bz4ZfYhd2K8+dil3irDUZevFG2aKWtpFyhoe
	1yrYNd0tbcUu8aN10SU51c6s61evvTvhY1TAo3UXd8Z8s3r8e/2qB08bQkKn858ttn15YOKa
	h6qcstw2qhvDYtizQ/IuLrjCt6P4Z9PcFeWsn1cosRRnJBpqMRcVJwIAuI/wJDwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/14 11:59, Andrey Ryabinin wrote:
> On 05/08/14 03:42, Afzal Mohammed wrote:
>>
>> int is to be converted to unsigned char in memset, would having above
>> change immediately upon entry to memset rather than at a place where it
>> won't always execute make intention clearer ? (although it doesn't make
>> difference)
>>
> 
> I think it's better to keep it near other manipulations with r1.
> Plus this will save us from executing extra instruction on 'memset -> 6 -> 5 -> return'
> path (memset for size <= 3).
> 
> 
>> ubfx r1, r1, #0, #8 would have given the needed typecasting, but seems
>> it is available only on ARMv6T2 & above.
>>
> 
> Indeed. It might be wrapped it with #if #else, but it will be a bit ugly,
> probably not worth to do.
> 
> 

Err, there is no reason to use ubfx, it just the same as and r1,r1, #0xff.
On ARMv6T2 & above one instruction could be saved by using BFI instead of ORR, like this:

diff --git a/arch/arm/lib/memset.S b/arch/arm/lib/memset.S
index 94b0650..9a7f714 100644
--- a/arch/arm/lib/memset.S
+++ b/arch/arm/lib/memset.S
@@ -22,8 +22,8 @@ ENTRY(memset)
 /*
  * we know that the pointer in ip is aligned to a word boundary.
  */
-1:     orr     r1, r1, r1, lsl #8
-       orr     r1, r1, r1, lsl #16
+1:     bfi     r1, r1, #8, #8
+       bfi     r1, r1, #16, #16
        mov     r3, r1
        cmp     r2, #16
        blt     4f

