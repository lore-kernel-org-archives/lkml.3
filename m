Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaJMKDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:03:51 -0400
Received: from mail-bl2on0102.outbound.protection.outlook.com ([65.55.169.102]:39719
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753123AbaJMKDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:03:49 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Joseph Lo <josephl@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCHv2] serial: of-serial: fix up PM ops on no_console_suspend
 and port type
Thread-Topic: [PATCHv2] serial: of-serial: fix up PM ops on no_console_suspend
 and port type
Thread-Index: AQHP5r7v06rw5nfyDUazCzUjUR8xTpwtxjYAgAABp/A=
Date: Mon, 13 Oct 2014 09:49:36 +0000
Message-ID: <32093fd7578143668ceb84feccecd21d@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1413185820-5920-1-git-send-email-jingchang.lu@freescale.com>
 <543B9E44.109@nvidia.com>
In-Reply-To: <543B9E44.109@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB467;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-forefront-prvs: 03630A6A4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(66654002)(479174003)(199003)(51704005)(189002)(24454002)(13464003)(4396001)(66066001)(85852003)(101416001)(74316001)(19580405001)(19580395003)(64706001)(2656002)(122556002)(21056001)(87936001)(86362001)(92566001)(33646002)(31966008)(108616004)(85306004)(76482002)(95666004)(99286002)(20776003)(76176999)(120916001)(54356999)(99396003)(76576001)(106116001)(40100003)(46102003)(97736003)(50986999)(107046002)(2501002)(106356001)(105586002)(80022003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB467;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB516;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9DA3u5W018304

My mistake, I will fix it, many thanks.

Best Regards,
Jingchang

>-----Original Message-----
>From: Joseph Lo [mailto:josephl@nvidia.com]
>Sent: Monday, October 13, 2014 5:41 PM
>To: Lu Jingchang-B35083; gregkh@linuxfoundation.org
>Cc: devicetree@vger.kernel.org; peter@hurleysoftware.com; arnd@arndb.de;
>linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org; linux-arm-
>kernel@lists.infradead.org
>Subject: Re: [PATCHv2] serial: of-serial: fix up PM ops on
>no_console_suspend and port type
>
>Hi,
>
>On 10/13/2014 03:37 PM, Jingchang Lu wrote:
>> This patch fixes commit 2dea53bf57783f243c892e99c10c6921e956aa7e,
>> "serial: of-serial: add PM suspend/resume support", which disables
>> the uart clock on suspend, but also causes a hardware hang on register
>> access if no_console_suspend command line option is used.
>>
>> Also, not every of_serial device is an 8250 port, so the serial8250
>> suspend/resume functions should only be applied to a real 8250 port.
>>
>> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
>> ---
>> changes in v2:
>>   add switch selection on uart type.
>
>After apply this, it can't build for me. I still need to apply the fix
>like something below.
>
>diff --git a/drivers/tty/serial/of_serial.c
>b/drivers/tty/serial/of_serial.c
>index e535f9c1563d..14c1ff4e7816 100644
>--- a/drivers/tty/serial/of_serial.c
>+++ b/drivers/tty/serial/of_serial.c
>@@ -9,6 +9,7 @@
>   *  2 of the License, or (at your option) any later version.
>   *
>   */
>+#include <linux/console.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
>@@ -248,13 +249,13 @@ static int of_serial_suspend(struct device *dev)
>  #ifdef CONFIG_SERIAL_8250
>         case PORT_8250 ... PORT_MAX_8250:
>         {
>-               struct uart_8250_port port8250;
>+               struct uart_8250_port *port8250;
>                 port8250 = serial8250_get_port(info->line);
>
>                 serial8250_suspend_port(info->line);
>                 if (info->clk &&
>-                   (!uart_console(port8250) ||
>-                    (uart_console(port8250) && console_suspend_enabled)))
>+                   (!uart_console(&port8250->port) ||
>+                    (uart_console(&port8250->port) &&
>console_suspend_enabled)))
>                         clk_disable_unprepare(info->clk);
>                 break;
>         }
>@@ -274,12 +275,12 @@ static int of_serial_resume(struct device *dev)
>  #ifdef CONFIG_SERIAL_8250
>         case PORT_8250 ... PORT_MAX_8250:
>         {
>-               struct uart_8250_port port8250;
>+               struct uart_8250_port *port8250;
>                 port8250 = serial8250_get_port(info->line);
>
>                 if (info->clk &&
>-                   (!uart_console(port8250) ||
>-                    (uart_console(port8250) && console_suspend_enabled)))
>+                   (!uart_console(&port8250->port) ||
>+                    (uart_console(&port8250->port) &&
>console_suspend_enabled)))
>                         clk_prepare_enable(info->clk);
>
>                 serial8250_resume_port(info->line);
>
>-Joseph
>
>>
>>   drivers/tty/serial/of_serial.c | 42
>++++++++++++++++++++++++++++++++++++------
>>   1 file changed, 36 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/tty/serial/of_serial.c
>b/drivers/tty/serial/of_serial.c
>> index 8bc2563..b525383 100644
>> --- a/drivers/tty/serial/of_serial.c
>> +++ b/drivers/tty/serial/of_serial.c
>> @@ -245,9 +245,24 @@ static int of_serial_suspend(struct device *dev)
>>   {
>>   	struct of_serial_info *info = dev_get_drvdata(dev);
>>
>> -	serial8250_suspend_port(info->line);
>> -	if (info->clk)
>> -		clk_disable_unprepare(info->clk);
>> +	switch(info->type) {
>> +#ifdef CONFIG_SERIAL_8250
>> +	case PORT_8250 ... PORT_MAX_8250:
>> +	{
>> +		struct uart_8250_port port8250;
>> +		port8250 = serial8250_get_port(info->line);
>> +
>> +		serial8250_suspend_port(info->line);
>> +		if (info->clk &&
>> +		    (!uart_console(port8250) ||
>> +		     (uart_console(port8250) && console_suspend_enabled)))
>> +			clk_disable_unprepare(info->clk);
>> +		break;
>> +	}
>> +#endif
>> +	default:
>> +		break;
>> +	}
>>
>>   	return 0;
>>   }
>> @@ -256,10 +271,25 @@ static int of_serial_resume(struct device *dev)
>>   {
>>   	struct of_serial_info *info = dev_get_drvdata(dev);
>>
>> -	if (info->clk)
>> -		clk_prepare_enable(info->clk);
>> +	switch(info->type) {
>> +#ifdef CONFIG_SERIAL_8250
>> +	case PORT_8250 ... PORT_MAX_8250:
>> +	{
>> +		struct uart_8250_port port8250;
>> +		port8250 = serial8250_get_port(info->line);
>> +
>> +		if (info->clk &&
>> +		    (!uart_console(port8250) ||
>> +		     (uart_console(port8250) && console_suspend_enabled)))
>> +			clk_prepare_enable(info->clk);
>>
>> -	serial8250_resume_port(info->line);
>> +		serial8250_resume_port(info->line);
>> +		break;
>> +	}
>> +#endif
>> +	default:
>> +		break;
>> +	}
>>
>>   	return 0;
>>   }
>>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
