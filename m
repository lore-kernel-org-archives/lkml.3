Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaHGSd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 14:33:59 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:44822 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750796AbaHGSd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 14:33:57 -0400
Message-ID: <53E3C685.5010600@hurleysoftware.com>
Date: Thu, 07 Aug 2014 14:33:41 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Jiri Slaby <jslaby@suse.cz>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH v2] serial: uart: add hw flow control support configuration
References: <1398971093-17164-1-git-send-email-m-karicheri2@ti.com> <53E39B44.60406@hurleysoftware.com> <53E3A67B.6070709@ti.com> <20140807171254.GA13097@kroah.com> <53E3B67E.80705@hurleysoftware.com> <53E3B88C.2000209@ti.com>
In-Reply-To: <53E3B88C.2000209@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 01:34 PM, Murali Karicheri wrote:
> On 08/07/2014 01:25 PM, Peter Hurley wrote:
>> On 08/07/2014 01:12 PM, Greg Kroah-Hartman wrote:
>>> On Thu, Aug 07, 2014 at 12:16:59PM -0400, Murali Karicheri wrote:
>>>> On 08/07/2014 11:29 AM, Peter Hurley wrote:
>>>>> On 05/01/2014 03:04 PM, Murali Karicheri wrote:
>>>>>> 8250 uart driver currently supports only software assisted hw flow
>>>>>> control. The software assisted hw flow control maintains a hw_stopped
>>>>>> flag in the tty structure to stop and start transmission and use modem
>>>>>> status interrupt for the event to drive the handshake signals. This is
>>>>>> not needed if hw has flow control capabilities. This patch adds a
>>>>>> DT attribute for enabling hw flow control for a uart port. Also skip
>>>>>> stop and start if this flag is present in flag field of the port
>>>>>> structure.
>>>>>>
>>>>>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>>>>>>
>>>>>> CC: Rob Herring<robh+dt@kernel.org>
>>>>>> CC: Pawel Moll<pawel.moll@arm.com>
>>>>>> CC: Mark Rutland<mark.rutland@arm.com>
>>>>>> CC: Ian Campbell<ijc+devicetree@hellion.org.uk>
>>>>>> CC: Kumar Gala<galak@codeaurora.org>
>>>>>> CC: Randy Dunlap<rdunlap@infradead.org>
>>>>>> CC: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>>>>>> CC: Jiri Slaby<jslaby@suse.cz>
>>>>>> CC: Santosh Shilimkar<santosh.shilimkar@ti.com>
>>>>>> ---
>>>>>>   .../devicetree/bindings/serial/of-serial.txt       |    1 +
>>>>>>   drivers/tty/serial/8250/8250_core.c                |    6 ++++--
>>>>>>   drivers/tty/serial/of_serial.c                     |    4 ++++
>>>>>>   drivers/tty/serial/serial_core.c                   |   12 +++++++++---
>>>>>>   4 files changed, 18 insertions(+), 5 deletions(-)
>>>>>>
>>>>> [...]
>>>>>
>>>>>> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
>>>>>> index b68550d..851707a 100644
>>>>>> --- a/drivers/tty/serial/serial_core.c
>>>>>> +++ b/drivers/tty/serial/serial_core.c
>>>>>> @@ -174,8 +174,12 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
>>>>>>               if (tty->termios.c_cflag&   CBAUD)
>>>>>>                   uart_set_mctrl(uport, TIOCM_RTS | TIOCM_DTR);
>>>>>>           }
>>>>>> -
>>>>>> -        if (tty_port_cts_enabled(port)) {
>>>>>> +        /*
>>>>>> +         * if hw support flow control without software intervention,
>>>>>> +         * then skip the below check
>>>>>> +         */
>>>>>> +        if (tty_port_cts_enabled(port)&&
>>>>>> +            !(uport->flags&   UPF_HARD_FLOW)) {
>>>>>>               spin_lock_irq(&uport->lock);
>>>>>>               if (!(uport->ops->get_mctrl(uport)&   TIOCM_CTS))
>>>>>>                   tty->hw_stopped = 1;
>>>>>> @@ -2772,7 +2776,9 @@ void uart_handle_cts_change(struct uart_port *uport, unsigned int status)
>>>>>>
>>>>>>       uport->icount.cts++;
>>>>>>
>>>>>> -    if (tty_port_cts_enabled(port)) {
>>>>>> +    /* skip below code if the hw flow control is supported */
>>>>>> +    if (tty_port_cts_enabled(port)&&
>>>>>> +        !(uport->flags&   UPF_HARD_FLOW)) {
>>>>> Why is a modem status interrupt being generated for DCTS
>>>>> if autoflow control is enabled?
>>>>>
>>>>> This should be:
>>>>>
>>>>>     WARN_ON_ONCE(uport->flags&   UPF_HARD_FLOW);
>>>>>
>>>>> to indicate a mis-configured driver/device.
>>>> This patch is already merged to the upstream branch and if you see any
>>>> issue, please
>>>> post a patch for review.
>>>
>>> If someone points out a problem in a patch of yours that is accepted
>>> upstream, it is nice to provide a fix, otherwise I will just revert it
>>> upstream, as it looks to be incorrect.
>>>
>>> So, should I just revert it?
>>
>> Greg,
>>
>> As I look this patch over further, this should just be reverted.
> 
> Sorry, I would suggest to fix it rather revert it.
> 
>>
>> 1. The patch enables UPF_HARD_FLOW, but provides no throttle() and unthrottle()
>> methods for 8250, which is guaranteed to blow-up when either uart_throttle() or
>> uart_unthrottle() is called.
>>
>> 2. The patch adds capabilities which already exist, namely UART_CAP_AFE.

> AFAIK, UART_CAP_AFE is a software assisted hw flow control and it was described in my commit log as well where as this patch add support for pure h/w controlled flow  control and no software intervention is needed. Do you think uart_throttle() or  uart_unthrottle() is applicable
> in this case?

UART_CAP_AFE is used to indicate 16750-compatible hw flow control, which is
auto-CTS and auto-RTS flow control as described in the TI datasheet at
http://www.ti.com/lit/ds/symlink/tl16c750.pdf

uart_throttle() and uart_unthrottle() are used indirectly by line disciplines
for high-level rx flow control, such as when a read buffer fills up because
there is no userspace reader. The 8250 core doesn't define a throttle/unthrottle
method because writing MCR to drop RTS is sufficient to disable auto-RTS.

Regards,
Peter Hurley

