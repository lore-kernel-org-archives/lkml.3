Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaJKDha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 23:37:30 -0400
Received: from mail-bn1bn0103.outbound.protection.outlook.com ([157.56.110.103]:54528
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750795AbaJKDh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 23:37:29 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Peter Hurley <peter@hurleysoftware.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joseph Lo <josephl@nvidia.com>
Subject: RE: [PATCH] serial: of-serial: fix up PM ops on no_console_suspend
Thread-Topic: [PATCH] serial: of-serial: fix up PM ops on no_console_suspend
Thread-Index: AQHP46dGRJKFTuLoMU2a/EicZwVioJwpNluAgADySHA=
Date: Sat, 11 Oct 2014 03:37:26 +0000
Message-ID: <cc12558a8c7747e08267544fcba16227@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1412845852-26157-1-git-send-email-jingchang.lu@freescale.com>
 <5437C569.3030404@hurleysoftware.com>
In-Reply-To: <5437C569.3030404@hurleysoftware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB468;
x-exchange-antispam-report-test: UriScan:;
x-forefront-prvs: 0361212EA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(479174003)(377454003)(189002)(13464003)(24454002)(51704005)(106116001)(50986999)(46102003)(76576001)(105586002)(99286002)(95666004)(108616004)(92566001)(19580395003)(19580405001)(85306004)(66066001)(80022003)(86362001)(106356001)(54356999)(4396001)(122556002)(101416001)(40100003)(76176999)(107046002)(33646002)(87936001)(76482002)(2656002)(99396003)(21056001)(31966008)(120916001)(2501002)(20776003)(85852003)(97736003)(64706001)(74316001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB468;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9B3bkvV009123

>-----Original Message-----
>From: Peter Hurley [mailto:peter@hurleysoftware.com]
>Sent: Friday, October 10, 2014 7:39 PM
>To: Lu Jingchang-B35083; gregkh@linuxfoundation.org
>Cc: arnd@arndb.de; linux-serial@vger.kernel.org; linux-arm-
>kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Joseph Lo
>Subject: Re: [PATCH] serial: of-serial: fix up PM ops on
>no_console_suspend
>
>Hi Jingchang,
>
>On 10/09/2014 05:10 AM, Jingchang Lu wrote:
>> Mandatorily disabling the uart clock will cause register access hung
>> on "no_console_suspend". This patch add condition check on it and only
>> disable the clock with console_suspend_enabled true.
>>
>> Signed-off-by: Joseph Lo <josephl@nvidia.com>
>> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
>> ---
>>  drivers/tty/serial/of_serial.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/tty/serial/of_serial.c
>> b/drivers/tty/serial/of_serial.c index 8bc2563..a765399 100644
>> --- a/drivers/tty/serial/of_serial.c
>> +++ b/drivers/tty/serial/of_serial.c
>> @@ -246,7 +246,7 @@ static int of_serial_suspend(struct device *dev)
>>  	struct of_serial_info *info = dev_get_drvdata(dev);
>>
>>  	serial8250_suspend_port(info->line);
>> -	if (info->clk)
>> +	if (info->clk && console_suspend_enabled)
>>  		clk_disable_unprepare(info->clk);
>
>This needs to check that _this_ port is the console port, like:
>
>	if (info->clk && uart_console(port) && and console_suspend_enabled)
>		clk_disable_unprepare(info->clk);
>
>which means you need something like:
>
>	struct uart_8250_port *uart = serial8250_get_port(info->line);
>	struct uart_port *port = &uart->port;
>
>Also, there's another problem with your original patch:
>not every of_serial device is an 8250, right?
>serial8250_suspend_port() on a port that's not registered with 8250 core
>is probably going to blow up.
>
>Which means the body of of_platform_suspend() and of_platform_resume()
>should probably look like
>
>	switch (info->type) {
>#ifdef CONFIG_SERIAL_8250
>	case PORT_8250 ... PORT_MAX_8250:
>	{
>		/* current body of function */
>	}
>#endif
>	default:
>	}
>
Yes, this should be considered, then serial8250_get_port(info->line) for uart_console() also
should be put in this type switch,  Thanks.

Best Regards,
Jingchang

>Regards,
>Peter Hurley
>
>
>>
>>  	return 0;
>> @@ -256,7 +256,7 @@ static int of_serial_resume(struct device *dev)  {
>>  	struct of_serial_info *info = dev_get_drvdata(dev);
>>
>> -	if (info->clk)
>> +	if (info->clk && console_suspend_enabled)
>>  		clk_prepare_enable(info->clk);
>>
>>  	serial8250_resume_port(info->line);
>>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
