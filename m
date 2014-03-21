Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965493AbaCUBjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:39:51 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:54310 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964953AbaCUBjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 21:39:46 -0400
Message-ID: <532B985A.7060505@hurleysoftware.com>
Date: Thu, 20 Mar 2014 21:39:38 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stanislav Meduna <stano@meduna.org>
CC: linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: mxs-auart gives data from previous run after close and reopen
References: <5323625B.4010203@meduna.org>
In-Reply-To: <5323625B.4010203@meduna.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 04:11 PM, Stanislav Meduna wrote:
> Hi,
>
> following scenario:
>
> - a Freescale i.MX28 machine
> - RS232 AUART looped back Rx - Tx or two different ports cross-connected
> - a test program sending data in one thread and receiving in the other:
>    thread A periodically sends "Quick brown fox jumps over the lazy dog",
>    thread B receives
> - stop the program using ctrl-C
> - restart
>
> => sometimes the receiving thread gets "dogQuick", receiving
>     characters from the previous transmission
>
> The extra characters definitely come from the receiver - the transmission
> is OK. This was verified by a scope.
>
> My theory is that this behaviour is caused by mxs_auart_shutdown
> function gating and mxs_auart_startup reenabling the clock instead
> of doing a soft reset. If the clock is gated while the AUART already
> has something in the FIFO, but did not generate the interrupt yet,
> the internal state machine is frozen in this state. As soon as it
> is reenabled, the characters are delivered to a new user.
>
> I am using a 3.4.77 kernel, but the relevant code looks the same in
> the recent kernels (when not using DMA). I also backported patches
> waiting for the transmission FIFO to clear at mxs_auart_shutdown.
>
> I did not find any possibility to fully clear the receiver - even
> if one disables the AUART and reads everything from the FIFO,
> the character currently in transmit might be still somewhere (the
> reference manual states that disabling is effective after the
> current character is received). Which might be 1 ms at 9600 and one
> has no clue whether it is the case.
>
> Also note that the function mxs_auart_reset is in fact not doing
> a reset - it just makes sure that the AUART comes out of one after
> the initialization. Maybe a full reset at startup is the solution...
>
> Pleas Cc: me when answering.

Does disabling the fifo on shutdown clear the fifo?


