Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3IQNEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:04:11 -0400
Received: from lmv.inov.pt ([146.193.64.2]:43369 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab3IQNEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:04:08 -0400
Message-ID: <52385327.9020706@inov.pt>
Date: Tue, 17 Sep 2013 14:03:35 +0100
From: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Subject: Re: [PATCH] serial: samsung: add support for manual RTS setting
References: <1378894107-7904-1-git-send-email-jose.goncalves@inov.pt> <35383907.gKXZyKLrYq@amdc1227>
In-Reply-To: <35383907.gKXZyKLrYq@amdc1227>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 17-09-2013 11:18, Tomasz Figa wrote:
> Hi José,
>
> Please see my comments below.
>
> On Wednesday 11 of September 2013 11:08:27 José Miguel Gonçalves wrote:
>> The Samsung serial driver currently does not support setting the
>> RTS pin with an ioctl(TIOCMSET) call. This patch adds this support.
>>
>> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
>> ---
>>   drivers/tty/serial/samsung.c |   17 ++++++++++++++---
>>   1 file changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
>> index f3dfa19..e5dd808 100644
>> --- a/drivers/tty/serial/samsung.c
>> +++ b/drivers/tty/serial/samsung.c
>> @@ -407,7 +407,14 @@ static unsigned int s3c24xx_serial_get_mctrl(struct
>> uart_port *port)
>>
>>   static void s3c24xx_serial_set_mctrl(struct uart_port *port, unsigned
>> int mctrl) {
>> -	/* todo - possibly remove AFC and do manual CTS */
>> +	unsigned int umcon = rd_regl(port, S3C2410_UMCON);
>> +
>> +	if (mctrl & TIOCM_RTS)
>> +		umcon |= S3C2410_UMCOM_RTS_LOW;
>> +	else
>> +		umcon &= ~S3C2410_UMCOM_RTS_LOW;
>> +
>> +	wr_regl(port, S3C2410_UMCON, umcon);
> I wonder if port capability shouldn't be considered here. Depending on SoC,
> only selected ports provide modem control capability.
>
> For example on S3C64xx only ports 0 and 1 support modem control, while
> ports 2 and 3 don't.

Same for S3C2416. I also wondered that, but while I have information for 
all S3C24xx chips and for those a simple test ( port->line < 2) would 
validate this, I don't know about other SoCs this driver supports. 
Bearing this in mind and also that the current implementation of 
s3c24xx_serial_get_mctrl() does not check also for which port it 
applies, I opted for this solution.

>
>>   }
>>
>>   static void s3c24xx_serial_break_ctl(struct uart_port *port, int
>> break_state) @@ -774,8 +781,6 @@ static void
>> s3c24xx_serial_set_termios(struct uart_port *port, if (termios->c_cflag
>> & CSTOPB)
>>   		ulcon |= S3C2410_LCON_STOPB;
>>
>> -	umcon = (termios->c_cflag & CRTSCTS) ? S3C2410_UMCOM_AFC : 0;
>> -
>>   	if (termios->c_cflag & PARENB) {
>>   		if (termios->c_cflag & PARODD)
>>   			ulcon |= S3C2410_LCON_PODD;
>> @@ -792,6 +797,12 @@ static void s3c24xx_serial_set_termios(struct
>> uart_port *port,
>>
>>   	wr_regl(port, S3C2410_ULCON, ulcon);
>>   	wr_regl(port, S3C2410_UBRDIV, quot);
>> +
>> +	if (termios->c_cflag & CRTSCTS)
>> +		umcon = S3C2410_UMCOM_AFC;
> Is it correct to override the last manual RTS value set to this register
> when activating manual flow control?
>
> Shouldn't the code be more like the following:
>
> 	umcon = rd_regb(port, S3C2410_UMCON);
> 	if (termios->c_cflag & CRTSCTS)
> 		umcon |= S3C2410_UMCOM_AFC;
> 	else
> 		umcon &= ~S3C2410_UMCOM_AFC;
> 	wr_regl(port, S3C2410_UMCON, umcon);
>
> Probably port capability should be considered here as well.
>

Looking at the S3C24xx user manuals I've seen that if you set the 
automatic flow control (AFC) with the S3C2410_UMCOM_AFC mask, the UART 
controller ignores the manual RTS setting value with the 
S3C2410_UMCOM_RTS_LOW bitmask, so it is not necessary to do that. Also, 
the upper bits of UMCON control the FIFO level to trigger the AFC and 
you should initialize these bits when using AFC (I've set these to 0 to 
use full FIFO, as it was previously).

Regarding port capability, if it's decided to validate it in 
s3c24xx_serial_get_mctrl() and s3c24xx_serial_set_mctrl() it should also 
be validated here. The question is how to validate for the full spectrum 
of SoCs that this driver supports?

Best regards,
José Gonçalves
