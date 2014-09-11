Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbaIKMtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:49:01 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:40325 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755192AbaIKMs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:48:58 -0400
Message-ID: <54119A36.5000001@hurleysoftware.com>
Date: Thu, 11 Sep 2014 08:48:54 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] tty: serial: core: Only invoke ->start_tx() if there
 is data to send
References: <1410377601-26794-1-git-send-email-bigeasy@linutronix.de> <5410AC1B.9000700@hurleysoftware.com> <5411576E.204@linutronix.de>
In-Reply-To: <5411576E.204@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 04:03 AM, Sebastian Andrzej Siewior wrote:
> On 09/10/2014 09:52 PM, Peter Hurley wrote:
>> The serial core can't assume that start_tx() does not need invoking
>> because hardware that can stop_tx() with data in the transmitter
>> won't restart if the ring buffer is empty but data is still in the
>> transmitter. [Note that the 16C950 port type does this in the 8250 driver.]
> 
> oh, not sure how I missed this… But now that I look at this, it is also
> that ->x_char that could be use for flow control which would have to be
> sent even with an empty xmit buffer.
> And 8250 in DMA mode does not look at x_char at all. But it would be
> better if it would, right? However if the TX side does a 2 KiB transfer
> not sure what should be done…

Yeah, 8250 dma doesn't send x_char at all; at a minimum 8250 dma should
at least send the x_char.

The preferred solution is to:
1. Stop DMA
2. Enable interrupt mode, which will automatically send the x_char
3. Restart DMA (presumably from the interrupt handler if UART_LSR_THRE)

The issue is whether 8250 dma hardware in general can stop and restart
dma without losing where the dma transfer was.

Regards,
Peter Hurley
