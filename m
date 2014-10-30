Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbaJ3N3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:29:09 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:38018 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759695AbaJ3N3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:29:07 -0400
Message-ID: <54523D1C.6080803@hurleysoftware.com>
Date: Thu, 30 Oct 2014 09:29:00 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Thompson <daniel.thompson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Frank Rowand <frank.rowand@sonymobile.com>
Subject: Re: [PATCH 1/2] tty: serial: msm: Fix sysrq spinlock recursion on
 non-DM
References: <1414606478-13709-1-git-send-email-sboyd@codeaurora.org> <1414606478-13709-2-git-send-email-sboyd@codeaurora.org> <5452204F.9090800@linaro.org>
In-Reply-To: <5452204F.9090800@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 07:26 AM, Daniel Thompson wrote:
> On 29/10/14 18:14, Stephen Boyd wrote:
>> The handle_rx() path calls uart_handle_sysrq_char() with the port
>> lock held. This causes a spinlock recursion. Release and
>> reacquire the lock here to avoid this.
>>
>> BUG: spinlock recursion on CPU#0, swapper/0
>>  lock: msm_uart_ports+0x1e0/0x2d0, .magic: dead4ead, .owner: swapper/0, .owner_cpu: 0
>> CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-rc7-00012-gb38ee8265941 #69
>> [<c0013964>] (unwind_backtrace) from [<c0011f74>] (show_stack+0x10/0x14)
>> [<c0011f74>] (show_stack) from [<c004ed1c>] (do_raw_spin_lock+0x11c/0x13c)
>> [<c004ed1c>] (do_raw_spin_lock) from [<c02d44c0>] (msm_console_write+0x78/0x188)
>> [<c02d44c0>] (msm_console_write) from [<c0052880>] (call_console_drivers.constprop.22+0xb4/0x144)
>> [<c0052880>] (call_console_drivers.constprop.22) from [<c0053570>] (console_unlock+0x27c/0x4ac)
>> [<c0053570>] (console_unlock) from [<c0053bb4>] (vprintk_emit+0x1f4/0x5a8)
>> [<c0053bb4>] (vprintk_emit) from [<c04ad0ac>] (printk+0x30/0x40)
>> [<c04ad0ac>] (printk) from [<c02c2990>] (__handle_sysrq+0x58/0x1b8)
>> [<c02c2990>] (__handle_sysrq) from [<c02d41b0>] (msm_irq+0x694/0x6f8)
>> [<c02d41b0>] (msm_irq) from [<c0055740>] (handle_irq_event_percpu+0x58/0x270)
>> [<c0055740>] (handle_irq_event_percpu) from [<c0055994>] (handle_irq_event+0x3c/0x5c)
>> [<c0055994>] (handle_irq_event) from [<c0057e84>] (handle_level_irq+0x9c/0x138)
>> [<c0057e84>] (handle_level_irq) from [<c005509c>] (generic_handle_irq+0x24/0x38)
>> [<c005509c>] (generic_handle_irq) from [<c000f730>] (handle_IRQ+0x44/0xb0)
>> [<c000f730>] (handle_IRQ) from [<c0008518>] (msm_vic_handle_irq+0x44/0x64)
>> [<c0008518>] (msm_vic_handle_irq) from [<c04b5ac4>] (__irq_svc+0x44/0x7c)
>> Exception stack(0xc0719f68 to 0xc0719fb0)
>> 9f60:                   00000001 00000001 00000000 c0722938 c0718000 c0769acc
>> 9f80: 00000000 c0720098 c0769305 4117b362 c0769acc 00000000 01000000 c0719fb0
>> 9fa0: c004cab0 c000f880 20000013 ffffffff
>> [<c04b5ac4>] (__irq_svc) from [<c000f880>] (arch_cpu_idle+0x20/0x30)
>> [<c000f880>] (arch_cpu_idle) from [<c004691c>] (cpu_startup_entry+0xf4/0x23c)
>> [<c004691c>] (cpu_startup_entry) from [<c06d8b70>] (start_kernel+0x32c/0x394)
>>
>> Cc: Frank Rowand <frank.rowand@sonymobile.com>
>> Cc: Daniel Thompson <daniel.thompson@linaro.org>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>  drivers/tty/serial/msm_serial.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
>> index 4b6c78331a64..cedcc36762a2 100644
>> --- a/drivers/tty/serial/msm_serial.c
>> +++ b/drivers/tty/serial/msm_serial.c
>> @@ -174,6 +174,7 @@ static void handle_rx(struct uart_port *port)
>>  	while ((sr = msm_read(port, UART_SR)) & UART_SR_RX_READY) {
>>  		unsigned int c;
>>  		char flag = TTY_NORMAL;
>> +		int sysrq;
>>  
>>  		c = msm_read(port, UART_RF);
>>  
>> @@ -195,7 +196,10 @@ static void handle_rx(struct uart_port *port)
>>  		else if (sr & UART_SR_PAR_FRAME_ERR)
>>  			flag = TTY_FRAME;
>>  
>> -		if (!uart_handle_sysrq_char(port, c))
>> +		spin_unlock(&port->lock);
>> +		sysrq = uart_handle_sysrq_char(port, c);
>> +		spin_lock(&port->lock);
>> +		if (!sysrq)
>>  			tty_insert_flip_char(tport, c, flag);
> 
> Does tty_insert_flip_char() need the port to be locked?


No.

It does not serialize internally, so concurrent use will blow up, but
that doesn't look possible here.

Can bad things happen if a well-timed set_termios() happens while the
lock is dropped?

Regards,
Peter Hurley
