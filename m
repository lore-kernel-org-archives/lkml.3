Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3JVQio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:38:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:54744 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab3JVQin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:38:43 -0400
Message-ID: <5266AA0F.1030603@linutronix.de>
Date: Tue, 22 Oct 2013 18:38:39 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Zubair Lutfullah <zubair.lutfullah@gmail.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: fix spin lock and reg_cache
References: <1375729845-6992-1-git-send-email-zubair.lutfullah@gmail.com> <20130807084054.GA18668@lee--X1> <52667A6C.6000301@linutronix.de> <20131022160523.GB24024@lee--X1>
In-Reply-To: <20131022160523.GB24024@lee--X1>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 06:05 PM, Lee Jones wrote:
>> I added reg_se_cache to cache the content of REG_SE once and
>> synchronize it among TSC & ADC access. REG_SE is set to 0 by the HW
>> after "work" has been done. So you need to know the old value or TSC may
>> disable ADC and the other way around.
> 
> Yep, it's initialised as '0'.
> 
> 12.5.1.15 STEPENABLE Register (offset = 54h) [reset = 0h]

Ehm yes but!. After init it is set to 0, correct. The value was never
read from the HW. It was always set via  am335x_tsc_se_set() to "cache
| argument" and written to HW from both sides (TSC, ADC). This
initialization is done at ->probe() time in both drivers.

The value remains (remained) constant over the whole time
so both drivers only called am335x_tsc_se_update() to set the value
(the enabled steps of both sides) back to the register (because after
the conversation the value was 0 according to my memory) and since
32bit reads are atomic I didn't use a lock here.

Sebastian
