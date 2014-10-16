Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaJPNHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:07:48 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:50524 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751324AbaJPNHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:07:47 -0400
Message-ID: <543FC31E.3000702@hurleysoftware.com>
Date: Thu, 16 Oct 2014 09:07:42 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>,
        linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: Div-by-zero in the 8250 serial driver (3.17-rc5)
References: <CAP145pg75hFKi2S9SVywRfex_A5=yRpe0p4Dzri8+Q=7YWoXfg@mail.gmail.com> <541C27E8.6090000@hurleysoftware.com>
In-Reply-To: <541C27E8.6090000@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I noticed this patch didn't make it into 3.18-rc1 or -next.
Do I need to resend this?

Regards,
Peter Hurley


On 09/19/2014 08:56 AM, Peter Hurley wrote:
> [ +cc Greg Kroah-Hartman, AlanC ]
> 
> On 09/18/2014 10:57 AM, Robert Święcki wrote:
>> Hi,
>>
>> # setserial /dev/ttyS0 spd_hi baud_base 38400
>>
>> Entering kdb (current=0xffff8805ee033200, pid 1798) on processor 9 Oops: (null)
>> due to oops @ 0xffffffff8149c01e
>> CPU: 9 PID: 1798 Comm: setserial Tainted: G        W I
>> 3.17.0-031700rc5-generic-201409151105
>> task: ffff8805ee033200 ti: ffff8800e39e0000 task.ti: ffff8800e39e0000
>> RIP: 0010:[<ffffffff8149c01e>]  [<ffffffff8149c01e>] uart_get_divisor+0x1e/0x40
>> RSP: 0018:ffff8800e39e3c30  EFLAGS: 00010206
>> RAX: 0000000000096000 RBX: ffffffff81fab060 RCX: 0000000000000006
>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81fab060
>> RBP: ffff8800e39e3c78 R08: 000000000000000a R09: 00000000000003d2
>> R10: 0000000000000000 R11: 00000000000003d1 R12: 0000000000000013
>> R13: ffff8805f0748d2c R14: 0000000000000000 R15: 0000000000000010
>> FS:  00007f0fa653d740(0000) GS:ffff880613920000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f0fa6003330 CR3: 00000000365f8000 CR4: 00000000000007e0
>> Stack:
>>  ffffffff814a2978 ffffffff81fab060 0000000000000010 ffff8800e39e3ca8
>>  ffff8805eca08000 ffff8805f0748c00 ffff8800e39e3dc0 ffffffff81fab060
>>  0000000000000010 ffff8800e39e3c88 ffffffff814a2d55 ffff8800e39e3ca8
>> Call Trace:
>>  [<ffffffff814a2978>] ? serial8250_do_set_termios+0xd8/0x490
>>  [<ffffffff814a2d55>] serial8250_set_termios+0x25/0x30
>>  [<ffffffff8149dce2>] uart_change_speed+0x52/0xb0
>>  [<ffffffff8149ec9c>] uart_set_info+0x20c/0x5f0
>>  [<ffffffff8149c75a>] ? do_uart_get_info+0xfa/0x1a0
>>  [<ffffffff8149fbdf>] uart_ioctl+0x14f/0x220
>>  [<ffffffff814804d8>] tty_ioctl+0x298/0x8f0
>>  [<ffffffff811fc025>] do_vfs_ioctl+0x75/0x2c0
>>  [<ffffffff811fc301>] SyS_ioctl+0x91/0xb0
>>  [<ffffffff817a436d>] system_call_fastpath+0x1a/0x1f
>> Code: c0 00 00 00 c3 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 81 fe
>> 00 96 00 00 48 89 e5 74 17 c1 e6 04 31 d2 89 f0 d1 e8 03 47 58 5d <f7>
>> f6 c3 0f 1f 80 00 00 00 00 8b 87 b8 00 00 00 25 30 10 00 00
> 
> Hi Robert,
> 
> Thanks for the report.
> 
> I was able to reproduce this crash on all recent kernels I tested. The
> patch below fixed the problem for me. If possible, please test the patch
> on your system.
> 
> Regards,
> Peter Hurley
> 
> --- >% ---
> Subject: [PATCH] serial: Fix divide-by-zero fault in uart_get_divisor()
> 
> uart_get_baud_rate() will return baud == 0 if the max rate is set
> to the "magic" 38400 rate and the SPD_* flags are also specified.
> On the first iteration, if the current baud rate is higher than the
> max, the baud rate is clamped at the max (which in the degenerate
> case is 38400). On the second iteration, the now-"magic" 38400 baud
> rate selects the possibly higher alternate baud rate indicated by
> the SPD_* flag. Since only two loop iterations are performed, the
> loop is exited, a kernel WARNING is generated and a baud rate of
> 0 is returned.
> 
> Reproducible with:
>  setserial /dev/ttyS0 spd_hi base_baud 38400
> 
> Only perform the "magic" 38400 -> SPD_* baud transform on the first
> loop iteration, which prevents the degenerate case from recognizing
> the clamped baud rate as the "magic" 38400 value.
> 
> Reported-by: Robert Święcki <robert@swiecki.net>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/serial/serial_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 66e2de6..d0a5fc9 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -359,7 +359,7 @@ uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
>  		 * The spd_hi, spd_vhi, spd_shi, spd_warp kludge...
>  		 * Die! Die! Die!
>  		 */
> -		if (baud == 38400)
> +		if (try == 0 && baud == 38400)
>  			baud = altbaud;
>  
>  		/*
> 

