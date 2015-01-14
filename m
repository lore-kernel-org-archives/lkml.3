Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbbANGZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 01:25:07 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55936 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbbANGZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 01:25:04 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-b1-54b60bbd64be
Message-id: <54B60BBC.3000103@samsung.com>
Date: Wed, 14 Jan 2015 07:25:00 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yousaf.kaukab@intel.com" <yousaf.kaukab@intel.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
Subject: Re: [PATCH] usb: dwc2: call dwc2_is_controller_alive() under spinlock
References: <1421146657-18587-1-git-send-email-r.baldyga@samsung.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304845072F6@US01WEMBX2.internal.synopsys.com>
In-reply-to: <A2CA0424C0A6F04399FB9E1CD98E0304845072F6@US01WEMBX2.internal.synopsys.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t/xq7p7ubeFGPTdELA4eL/eYtWnNcwW
	zYvXs1lc3jWHzWLRslZmi7VH7rJbPHq4ldVi06afzA4cHov3vGTy2D93DbtH/7VJ7B59W1Yx
	emzZ/5nR4/iN7UwenzfJBbBHcdmkpOZklqUW6dslcGW0//vHWHCLt+L5qUbmBsaZ3F2MnBwS
	AiYSLYcuskDYYhIX7q1n62Lk4hASWMoosbBzFTOE85FR4kVjD1gVr4CWxM51bYwgNouAqkTv
	7252EJtNQEdiy/cJYHFRgQiJD6u+skHUC0r8mHwPrFdEwEBiw9FpYBuYBfqZJRau72EFSQgL
	+EmsnzaZHWLbZEaJBzMvgCU4BaIkdt3YCpTgAOrQk7h/UQskzCwgL7F5zVvmCYwCs5DsmIVQ
	NQtJ1QJG5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYITHwZQfj4mNWhxgFOBiVeHg9Tm8N
	EWJNLCuuzD3EKMHBrCTCu55pW4gQb0piZVVqUX58UWlOavEhRiYOTqkGxrW8Kz0zNCv/c+z3
	50o47fPR4/ksh851ofGvXjnr2L2ZaK8ixP5P1KKHf1LL5yPax4wnnz3U0l0xM31Z2efmrwkT
	9iXWhF29uiqhO+azRFfbOm6NbXxffY6I7hbVaEj+80v935/vXL7nHbd+3L7OMFbj/Zx3bZ5J
	zTebVzV++vic+ZhA5H6Jg0osxRmJhlrMRcWJAL71nZVfAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 10:12 PM, Paul Zimmerman wrote:
>> From: Robert Baldyga [mailto:r.baldyga@samsung.com]
>> Sent: Tuesday, January 13, 2015 2:58 AM
>>
>> This patch fixes bug described here:
>> https://lkml.org/lkml/2014/12/22/185
>>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>> ---
>>  drivers/usb/dwc2/core_intr.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
>> index ad43c5b..668c8dd 100644
>> --- a/drivers/usb/dwc2/core_intr.c
>> +++ b/drivers/usb/dwc2/core_intr.c
>> @@ -476,13 +476,13 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
>>  	u32 gintsts;
>>  	irqreturn_t retval = IRQ_NONE;
>>
>> +	spin_lock(&hsotg->lock);
>> +
>>  	if (!dwc2_is_controller_alive(hsotg)) {
>>  		dev_warn(hsotg->dev, "Controller is dead\n");
>>  		goto out;
> 
> This isn't right, now the spinlock isn't released if we take this path.
> 
> Besides, this patch doesn't really make sense. How could taking the
> spinlock affect the value returned from dwc2_is_controller_alive? All
> it does is read from the GSNPSID register, and that register is never
> written to.
> 
> Are you absolutely sure this is the fix?
> 

I also don't know how is it possible that reading from GSNPSID can break
data transfer, but it looks like it does.

The problem is not about value taken from GSNPSID. This value is always
proper, and dwc2_is_controller_alive() always returns true. The problem
is that the operation of reading this register affects data transmission
process, if it's not done under spinlock. I have no idea why can it be.

I will fix this patch to release spinlock in all cases.

Thanks,
Robert Baldyga
