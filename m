Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab3ANNhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 08:37:25 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:33997 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3ANNhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 08:37:24 -0500
Message-ID: <50F409FD.9070700@mvista.com>
Date: Mon, 14 Jan 2013 17:37:01 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] serial: vt8500: ioremap'd resource is never freed
References: <1358129060-9399-1-git-send-email-linux@prisktech.co.nz> <1358129060-9399-3-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1358129060-9399-3-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 14-01-2013 6:04, Tony Prisk wrote:

> Memory mapped via ioremap call is never released. Rather than add an
> iounmap call, change allocation function to devm_request_and_ioremap.

> Also, change the error on failure for this call to -EBUSY rather than
> -ENOMEM.

    Not really well justified. See below.

> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
>   drivers/tty/serial/vt8500_serial.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

> diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
> index 4c4a58d..8865afd 100644
> --- a/drivers/tty/serial/vt8500_serial.c
> +++ b/drivers/tty/serial/vt8500_serial.c
> @@ -615,9 +615,9 @@ static int vt8500_serial_probe(struct platform_device *pdev)
>   	snprintf(vt8500_port->name, sizeof(vt8500_port->name),
>   		 "VT8500 UART%d", pdev->id);
>
> -	vt8500_port->uart.membase = ioremap(mmres->start, resource_size(mmres));
> +	vt8500_port->uart.membase = devm_request_and_ioremap(&pdev->dev, mmres);
>   	if (!vt8500_port->uart.membase) {
> -		ret = -ENOMEM;
> +		ret = -EBUSY;

    According to the comment to devm_request_and_ioremap(), the recommended 
return code on its failure -EADDRNOTAVAIL.

WBR, Sergei

