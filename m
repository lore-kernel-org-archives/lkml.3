Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab3GVRZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:25:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52009 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab3GVRZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:25:10 -0400
Message-ID: <51ED6AF1.9070605@ti.com>
Date: Mon, 22 Jul 2013 20:25:05 +0300
From: Illia Smyrnov <x0194613@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Illia Smyrnov <illia.smyrnov@globallogic.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/2] Input: omap-keypad: Cleanup - remove unnecessary
 IRQ enabling/disabling
References: <1374239027-3927-1-git-send-email-illia.smyrnov@globallogic.com> <1374239027-3927-3-git-send-email-illia.smyrnov@globallogic.com> <20130719132648.GB17188@arwen.pp.htv.fi>
In-Reply-To: <20130719132648.GB17188@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.193]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/19/2013 04:26 PM, Felipe Balbi wrote:
> Hi,
>
> [...]
> please don't remove this code. It'll be good to have this around when we
> move the driver to threaded IRQs without IRQF_ONESHOT. In fact, it would
> be very simple to implement such a change, wanna take it up ?
>
> It should be doable in few patches:
>
> 1) switch over to request_threaded_irq()
>
> 	just blind move to a thread, without hardirq handler, so
> 	IRQF_ONESHOT is mandatory.
>
> 2) add hardirq handler
>
> 	read IRQSTATUS to check if our device has generated IRQs
> 	returning IRQ_WAKE_THREAD if true
>
> 3) move 'IRQ masking logic' to hardirq handler, before returning
> IRQ_WAKE_THREAD
>
> 	this will let you remove IRQF_ONESHOT
>
> 4) finally remove IRQF_ONESHOT
>
> 	this makes sure that IRQs aren't kept disabled until we have
> 	time to iterate over the entire keypad matrix. Only the keypad
> 	IRQ will be masked.
>

Ok, but why we need to remove IRQF_ONESHOT flag for omap keypad driver?

The keypad IRQ isn't shared IRQ and in our case hardirq handler will 
always return IRQ_WAKE_THREAD like default irq_default_primary_handler 
do. With IRQF_ONESHOT flag IRQ line will be masked until the threaded
handler finished, but there is only keypad on this line.

I tested two versions:
the first one - just threaded IRQs with IRQF_ONESHOT and without 
specific hardirq handler.
the second version - threaded IRQs without IRQF_ONESHOT as you described.
Both versions was successfully tested on Blaze's keypad.
