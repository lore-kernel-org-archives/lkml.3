Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbaJaUiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:38:01 -0400
Received: from mail-bl2on0071.outbound.protection.outlook.com ([65.55.169.71]:33328
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751050AbaJaUiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:38:00 -0400
Message-ID: <5453F23D.1000608@opensource.altera.com>
Date: Fri, 31 Oct 2014 15:34:05 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <p.zabel@pengutronix.de>
CC: <dinh.linux@gmail.com>, <s.trumtrar@pengutronix.de>,
        <atull@opensource.altera.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reset: add socfpga_reset_status
References: <1414165990-23958-1-git-send-email-dinguyen@opensource.altera.com>
In-Reply-To: <1414165990-23958-1-git-send-email-dinguyen@opensource.altera.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CO2PR03CA0025.namprd03.prod.outlook.com (10.141.194.152) To
 BN3PR0301MB1186.namprd03.prod.outlook.com (25.160.156.148)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1186;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(189002)(51704005)(24454002)(164054003)(199003)(479174003)(377454003)(92726001)(33656002)(80316001)(19580395003)(19580405001)(92566001)(50466002)(110136001)(86362001)(46102003)(99396003)(50986999)(102836001)(87266999)(20776003)(77156002)(122386002)(40100003)(87976001)(76176999)(64126003)(47776003)(101416001)(31966008)(64706001)(54356999)(23746002)(66066001)(65806001)(65956001)(42186005)(105586002)(97736003)(4396001)(83506001)(120916001)(65816999)(2351001)(107046002)(106356001)(95666004)(62966003)(77096003)(21056001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1186;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1249;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On 10/24/2014 10:53 AM, dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Populate the reset_status callback for SOCFPGA.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> ---
>  drivers/reset/reset-socfpga.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/reset/reset-socfpga.c b/drivers/reset/reset-socfpga.c
> index 79c32ca..cd37849 100644
> --- a/drivers/reset/reset-socfpga.c
> +++ b/drivers/reset/reset-socfpga.c
> @@ -76,9 +76,27 @@ static int socfpga_reset_deassert(struct reset_controller_dev *rcdev,
>  	return 0;
>  }
>  
> +static int socfpga_reset_status(struct reset_controller_dev *rcdev,
> +				unsigned long id)
> +{
> +	struct socfpga_reset_data *data = container_of(rcdev,
> +						struct socfpga_reset_data, rcdev);
> +	int bank = id / BITS_PER_LONG;
> +	int offset = id % BITS_PER_LONG;
> +	unsigned long flags;
> +	u32 reg;
> +
> +	spin_lock_irqsave(&data->lock, flags);
> +	reg = readl(data->membase + OFFSET_MODRST + (bank * NR_BANKS));
> +	spin_unlock_irqrestore(&data->lock, flags);
> +
> +	return !(reg & BIT(offset));
> +}
> +
>  static struct reset_control_ops socfpga_reset_ops = {
>  	.assert		= socfpga_reset_assert,
>  	.deassert	= socfpga_reset_deassert,
> +	.status		= socfpga_reset_status,
>  };
>  
>  static int socfpga_reset_probe(struct platform_device *pdev)
> 

Just wondering if you had a chance to review this patch?

Thanks,
Dinh
