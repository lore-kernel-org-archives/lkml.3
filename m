Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaIYLbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 07:31:49 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59543 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751368AbaIYLbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 07:31:46 -0400
Message-ID: <5423FD14.9060604@hurleysoftware.com>
Date: Thu, 25 Sep 2014 07:31:32 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Frans Klaver <frans.klaver@xsens.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <2cf997d9-e7de-465b-915d-3a0a5e7b95f7@email.android.com> <54129F6C.7040508@linutronix.de> <20140912094010.GE28458@ci00147.xsens-tech.local> <5412C21A.8020203@linutronix.de> <20140912102816.GF28458@ci00147.xsens-tech.local> <541716DC.9020904@linutronix.de> <20140917102812.GA20438@ci00147.xsens-tech.local> <20140921204100.GA10111@linutronix.de> <5421A7F7.3070109@hurleysoftware.com> <20140924075346.GB19565@linutronix.de> <20140925104208.GE19396@linutronix.de>
In-Reply-To: <20140925104208.GE19396@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 06:42 AM, Sebastian Andrzej Siewior wrote:
> * Sebastian Andrzej Siewior | 2014-09-24 09:53:46 [+0200]:
> 
>> * Peter Hurley | 2014-09-23 13:03:51 [-0400]:
>>
>>> But DMA is cheating if the UART driver's tx_empty() method is saying the
>>> transmitter is empty while TX DMA is still running.
>> This shouldn't be the case. But I will check this once I able to.
> 
> I added 
> 
> |#define BOTH_EMPTY      (UART_LSR_TEMT | UART_LSR_THRE)
> |    trace_printk("delay <%d>\n", (lsr & BOTH_EMPTY) == BOTH_EMPTY ? 1 : 0);
> 
> in my set_termios() and the trace shows
> |              vi-949   [000] d...    70.477002: omap8250_restore_regs: delay <0>
> 
> so no, it does not wait until TX FIFO is empty. It looks like it uses
> TCSANOW instead of TCSADRAIN. And since this looks "legal" I will delay
> it until TX-DMA is complete because it is known to stall the DMA operation.

I just verified that GNU readline6 uses ioctl(TCSETSW, ...) to do the set_termios
(which is the ioctl that libc should use for tcsetattr(TCSADRAIN)).

Maybe this userspace is using a readline()-alike that has a bug by not using the
correct tcsetattr() action?
Or maybe the glibc-equivalent has the bug, and tcsetattr(TCSADRAIN) is not using
ioctl(TCSETSW)?

Regards,
Peter Hurley
