Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbaCTSzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:55:11 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:47819 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755653AbaCTSzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:55:05 -0400
Message-ID: <532B3983.6040706@hurleysoftware.com>
Date: Thu, 20 Mar 2014 14:54:59 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>, Alan Cox <alan@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Muralidharan Karicheri <m-karicheri2@ti.com>,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: Re: hci_ldsic nested locking problem
References: <20140320163435.GH32692@saruman.home> <1395333736.22077.32.camel@acox1-desk.ger.corp.intel.com> <20140320171621.GA2827@saruman.home> <20140320172920.GC2827@saruman.home> <532B26C1.8080806@hurleysoftware.com> <20140320173518.GD2827@saruman.home> <20140320184544.GA1113@kroah.com>
In-Reply-To: <20140320184544.GA1113@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 02:45 PM, Greg KH wrote:
> On Thu, Mar 20, 2014 at 12:35:18PM -0500, Felipe Balbi wrote:
>> On Thu, Mar 20, 2014 at 01:34:57PM -0400, Peter Hurley wrote:
>>> [ +cc Huang Shijie ]
>>>
>>> On 03/20/2014 01:29 PM, Felipe Balbi wrote:
>>>> then we need updates to Documentation:
>>>>
>>>> Documentation/serial/tty.txt::
>>>>
>>>> |  Driver Side Interfaces:
>>>> |
>>>> |  receive_buf()	-	Hand buffers of bytes from the driver to the ldisc
>>>> |  			for processing. Semantics currently rather
>>>> |  			mysterious 8(
>>>> |
>>>> |  write_wakeup()	-	May be called at any point between open and close.
>>>> |  			The TTY_DO_WRITE_WAKEUP flag indicates if a call
>>>> |  			is needed but always races versus calls. Thus the
>>>> |  			ldisc must be careful about setting order and to
>>>> |  			handle unexpected calls. Must not sleep.
>>>> |
>>>> |  			The driver is forbidden from calling this directly
>>>> |  			from the ->write call from the ldisc as the ldisc
>>>> |  			is permitted to call the driver write method from
>>>> |  			this function. In such a situation defer it.
>>>>
>>>> documentation says ldisc is allowed to call ->write() from
>>>> ->write_wakeup(). huh ?
>>>
>>> Patch submitted but never applied.
>>>
>>> http://www.spinics.net/lists/linux-serial/msg11144.html
>>
>> Thank you. For that patch:
>>
>> Acked-by: Felipe Balbi <balbi@ti.com>
>
> Can someone resend it, this is lost in my tree for some reason...

Apologies if my mailer mangles this.

--- >% ---
From: Huang Shijie <b32955@freescale.com>

In the uart_handle_cts_change(), uart_write_wakeup() is called after
we call @uart_port->ops->start_tx().

The Documentation/serial/driver tells us:
-----------------------------------------------
   start_tx(port)
	Start transmitting characters.

	Locking: port->lock taken.
	Interrupts: locally disabled.
-----------------------------------------------

So when the uart_write_wakeup() is called, the port->lock is taken by
the upper. See the following callstack:

	|_ uart_write_wakeup
	   |_ tty_wakeup
	      |_ ld->ops->write_wakeup

With the port->lock held, we call the @write_wakeup. Some implemetation of
the @write_wakeup does not notice that the port->lock is held, and it still
tries to send data with uart_write() which will try to grab the prot->lock.
A dead lock occurs, see the following log caught in the Bluetooth by uart:

--------------------------------------------------------------------
BUG: spinlock lockup suspected on CPU#0, swapper/0/0
  lock: 0xdc3f4410, .magic: dead4ead, .owner: swapper/0/0, .owner_cpu: 0
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.10.17-16839-ge4a1bef #1320
[<80014cbc>] (unwind_backtrace+0x0/0x138) from [<8001251c>] (show_stack+0x10/0x14)
[<8001251c>] (show_stack+0x10/0x14) from [<802816ac>] (do_raw_spin_lock+0x108/0x184)
[<802816ac>] (do_raw_spin_lock+0x108/0x184) from [<806a22b0>] (_raw_spin_lock_irqsave+0x54/0x60)
[<806a22b0>] (_raw_spin_lock_irqsave+0x54/0x60) from [<802f5754>] (uart_write+0x38/0xe0)
[<802f5754>] (uart_write+0x38/0xe0) from [<80455270>] (hci_uart_tx_wakeup+0xa4/0x168)
[<80455270>] (hci_uart_tx_wakeup+0xa4/0x168) from [<802dab18>] (tty_wakeup+0x50/0x5c)
[<802dab18>] (tty_wakeup+0x50/0x5c) from [<802f81a4>] (imx_rtsint+0x50/0x80)
[<802f81a4>] (imx_rtsint+0x50/0x80) from [<802f88f4>] (imx_int+0x158/0x17c)
[<802f88f4>] (imx_int+0x158/0x17c) from [<8007abe0>] (handle_irq_event_percpu+0x50/0x194)
[<8007abe0>] (handle_irq_event_percpu+0x50/0x194) from [<8007ad60>] (handle_irq_event+0x3c/0x5c)
--------------------------------------------------------------------

This patch adds more limits to the @write_wakeup, the one who wants to
implemet the @write_wakeup should follow the limits which avoid the deadlock.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
  include/linux/tty_ldisc.h |    5 ++++-
  1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index f15c898..539ccc5 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -91,7 +91,10 @@
   *	This function is called by the low-level tty driver to signal
   *	that line discpline should try to send more characters to the
   *	low-level driver for transmission.  If the line discpline does
- *	not have any more data to send, it can just return.
+ *	not have any more data to send, it can just return. If the line
+ *	discipline does have some data to send, please arise a tasklet
+ *	or workqueue to do the real data transfer. Do not send data in
+ *	this hook, it may leads to a deadlock.
   *
   * int (*hangup)(struct tty_struct *)
   *
-- 1.7.2.rc3
