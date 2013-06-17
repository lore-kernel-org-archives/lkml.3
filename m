Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3FQSXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:23:10 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:44512
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043Ab3FQSXH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:23:07 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432I14ffIzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Mon, 17 Jun 2013 11:22:50 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        Jingoo Han <jg1.han@samsung.com>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the tty tree
References: <20130617164841.41561f78f3465bd4007411b6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130617164841.41561f78f3465bd4007411b6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <ed138cdb-8a20-4c84-95f4-6137e5803e36@CO9EHSMHS013.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 04:48:41PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/tty/serial/xilinx_uartps.c between commit 696faedd616e ("serial:
> use platform_{get,set}_drvdata()") from the tty tree and commit
> 30e1e28598c2 ("arm: zynq: Migrate platform to clock controller") from the
> arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/tty/serial/xilinx_uartps.c
> index 6c91745,a4a3028..0000000
> --- a/drivers/tty/serial/xilinx_uartps.c
> +++ b/drivers/tty/serial/xilinx_uartps.c
> @@@ -972,14 -1004,15 +1004,14 @@@ static int xuartps_probe(struct platfor
>   		port->mapbase = res->start;
>   		port->irq = res2->start;
>   		port->dev = &pdev->dev;
> - 		port->uartclk = clk_get_rate(clk);
> - 		port->private_data = clk;
> + 		port->uartclk = clk_get_rate(xuartps_data->refclk);
> + 		port->private_data = xuartps_data;
>  -		dev_set_drvdata(&pdev->dev, port);
>  +		platform_set_drvdata(pdev, port);
>   		rc = uart_add_one_port(&xuartps_uart_driver, port);
>   		if (rc) {
>   			dev_err(&pdev->dev,
>   				"uart_add_one_port() failed; err=%i\n", rc);
> - 			return rc;
>  -			dev_set_drvdata(&pdev->dev, NULL);
> + 			goto err_out_clk_disable;
>   		}
>   		return 0;
>   	}
> @@@ -993,14 -1039,19 +1038,18 @@@ err_out_free
>    **/
>   static int xuartps_remove(struct platform_device *pdev)
>   {
>  -	struct uart_port *port = dev_get_drvdata(&pdev->dev);
>  +	struct uart_port *port = platform_get_drvdata(pdev);
> - 	struct clk *clk = port->private_data;
> + 	struct xuartps *xuartps_data = port->private_data;
>   	int rc;
>   
>   	/* Remove the xuartps port from the serial core */
>   	rc = uart_remove_one_port(&xuartps_uart_driver, port);
>  -	dev_set_drvdata(&pdev->dev, NULL);
>   	port->mapbase = 0;
> - 	clk_disable_unprepare(clk);
> + 	clk_disable_unprepare(xuartps_data->refclk);
> + 	clk_disable_unprepare(xuartps_data->aperclk);
> + 	clk_put(xuartps_data->refclk);
> + 	clk_put(xuartps_data->aperclk);
> + 	kfree(xuartps_data);
>   	return rc;
>   }
Looks correct and boots fine on Zynq. Thanks.

	Sören


