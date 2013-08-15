Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab3HOQx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:53:26 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13288 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab3HOQxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:53:24 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f5f6d000000ff6-9a-520d078247df
Message-id: <520D0779.4020903@samsung.com>
Date: Thu, 15 Aug 2013 19:53:13 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        dmitry.kasatkin@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] dev-core: fix build break when DEBUG is enabled
References: <71bb3fcd9f1a99aa7bd8f6dd1fb6267173db51d2.1376582695.git.d.kasatkin@samsung.com>
 <20130815163705.GA15688@kroah.com>
In-reply-to: <20130815163705.GA15688@kroah.com>
Content-transfer-encoding: 8bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xq7pN7LxBBot/8Fh8WVpn0bx4PZvF
	5V1z2CyaT5xitliw8RGjA6vHzll32T3mnQz02D93DbvH501yASxRXDYpqTmZZalF+nYJXBlH
	T0YVPBao+Ne9j7GBcSJfFyMnh4SAicSSvT0sELaYxIV769m6GLk4hASWMkp8v/UBLMErICjx
	Y/I9MJtZQF1i0rxFzBBFjUwS+76cY4JwFgJ1TNnADtGhJTHl0AQwm0VAVeL61KtMIDabgJ7E
	huYfYHFRgQiJlUsesILYIgIaEi+P3gLawAG0oUSi+X0USFhYwENiYec5qGXNjBLLDixkA0lw
	CuhLXDqyjxHiInmJg1eeg10nBLSre+1aNoh3FCVOTz7HPIFReBaSJ2YheWIWkvYFjMyrGEVT
	S5MLipPScw31ihNzi0vz0vWS83M3MUKi4csOxsXHrA4xCnAwKvHwRrRxBwmxJpYVV+YeYpTg
	YFYS4f16jydIiDclsbIqtSg/vqg0J7X4ECMTB6dUA6Pg8akdEWGfwlPSk+f9uaR/xHnTrknc
	LVPbzWqzpvZFBFjGHn8sEHMkjCtEOHer6sp6k3WB0wSrfvGeqrzOdFFhs7rMie1ZJWYZL7TU
	wrRVI+yOy/g6bVC8FvaztGGBbLW8gNczvWXml5wUJOPiZdrDes9p/zipKl3buPr4181/tq4N
	MI/5rMRSnJFoqMVcVJwIAEj51yZkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/08/13 19:37, Greg KH wrote:
> On Thu, Aug 15, 2013 at 07:04:54PM +0300, Dmitry Kasatkin wrote:
>> When DEBUG is defined, dev_dbg_ratelimited uses dynamic debug data
>> structures even when CONFIG_DYNAMIC_DEBUG is not defined.
>> It leads to build break.
>> For example, when I try to use dev_dbg_ratelimited in USB code and
>> CONFIG_USB_DEBUG is enabled, but CONFIG_DYNAMIC_DEBUG is not, I get:
>>
>>   CC [M]  drivers/usb/host/xhci-ring.o
>>   drivers/usb/host/xhci-ring.c: In function ‘xhci_queue_intr_tx’:
>>   drivers/usb/host/xhci-ring.c:3059:3: error: implicit declaration of function ‘DEFINE_DYNAMIC_DEBUG_METADATA’ [-Werror=implicit-function-declaration]
>>   drivers/usb/host/xhci-ring.c:3059:3: error: ‘descriptor’ undeclared (first use in this function)
>>   drivers/usb/host/xhci-ring.c:3059:3: note: each undeclared identifier is reported only once for each function it appears in
>>   drivers/usb/host/xhci-ring.c:3059:3: error: implicit declaration of function ‘__dynamic_pr_debug’ [-Werror=implicit-function-declaration]
>>   drivers/usb/host/xhci-ring.c: In function ‘xhci_queue_isoc_tx_prepare’:
>>   drivers/usb/host/xhci-ring.c:3847:3: error: ‘descriptor’ undeclared (first use in this function)
>>   cc1: some warnings being treated as errors
>>   make[2]: *** [drivers/usb/host/xhci-ring.o] Error 1
>>   make[1]: *** [drivers/usb/host] Error 2
>>   make: *** [drivers/usb/] Error 2
>>
>> This patch separates definition for CONFIG_DYNAMIC_DEBUG and DEBUG cases.
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> Cc: stable@vger.kernel.org
> How is this a stable issue?  I don't see how the rules listed in
> Documentation/stable_kernel_rules.txt apply here, what am I missing?
>
> Not to say your patch isn't correct, just that it's not stable material,
> right?
>
> thanks,
>
> greg k-h
>

There are few drivers which uses dev_dbg_ratelimited().
In the case someone tries to build kernel with those drivers with DEBUG
enabled and without CONFIG_DYNAMIC_DEBUG,
will get the build break. It will happen also on stable kernel.

- Dmitry

