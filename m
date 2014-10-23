Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaJWPFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:05:45 -0400
Received: from mail-bn1bon0087.outbound.protection.outlook.com ([157.56.111.87]:22992
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752703AbaJWPFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:05:43 -0400
Message-ID: <54491859.5010007@opensource.altera.com>
Date: Thu, 23 Oct 2014 10:01:45 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <p.zabel@pengutronix.de>
CC: <dinh.linux@gmail.com>, <atull@opensource.altera.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3] reset: add reset_control_status helper function
References: <1412954474-25775-1-git-send-email-dinguyen@opensource.altera.com>
In-Reply-To: <1412954474-25775-1-git-send-email-dinguyen@opensource.altera.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: SIXPR03CA013.apcprd03.prod.outlook.com (10.141.119.23) To
 BN3PR0301MB1186.namprd03.prod.outlook.com (25.160.156.148)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1186;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(189002)(479174003)(377454003)(51704005)(24454002)(164054003)(199003)(19580395003)(19580405001)(101416001)(2351001)(105586002)(86362001)(42186005)(77096002)(87976001)(20776003)(47776003)(102836001)(95666004)(23746002)(4396001)(64706001)(65956001)(92566001)(92726001)(107046002)(85852003)(106356001)(64126003)(31966008)(110136001)(83506001)(50466002)(99136001)(76482002)(21056001)(122386002)(66066001)(97736003)(59896002)(40100003)(76176999)(50986999)(65816999)(54356999)(99396003)(46102003)(85306004)(117636001)(120916001)(80022003)(87266999);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1186;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On 10/10/2014 10:21 AM, dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> There are cases where a system will want to read a reset status bit before
> doing any other toggling. Add a reset_control_status helper function to the
> reset controller API.
> 
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> ---
> v3: Remove last unsigned int and update comment
> v2: reset_control_status should be returning an int, and add a comment about
>     status in reset-controller.h
> ---
>  drivers/reset/core.c             | 15 +++++++++++++++
>  include/linux/reset-controller.h |  2 ++
>  include/linux/reset.h            |  7 +++++++
>  3 files changed, 24 insertions(+)
> 
> diff --git a/drivers/reset/core.c b/drivers/reset/core.c
> index baeaf82..7955e00 100644
> --- a/drivers/reset/core.c
> +++ b/drivers/reset/core.c
> @@ -126,6 +126,21 @@ int reset_control_deassert(struct reset_control *rstc)
>  EXPORT_SYMBOL_GPL(reset_control_deassert);
>  
>  /**
> + * reset_control_status - returns a negative errno if not supported, a
> + * positive value if the reset line is asserted, or zero if the reset
> + * line is not asserted.
> + * @rstc: reset controller
> + */
> +int reset_control_status(struct reset_control *rstc)
> +{
> +	if (rstc->rcdev->ops->status)
> +		return rstc->rcdev->ops->status(rstc->rcdev, rstc->id);
> +
> +	return -ENOSYS;
> +}
> +EXPORT_SYMBOL_GPL(reset_control_status);
> +
> +/**
>   * of_reset_control_get - Lookup and obtain a reference to a reset controller.
>   * @node: device to be reset by the controller
>   * @id: reset line name
> diff --git a/include/linux/reset-controller.h b/include/linux/reset-controller.h
> index 41a4695..ce6b962 100644
> --- a/include/linux/reset-controller.h
> +++ b/include/linux/reset-controller.h
> @@ -12,11 +12,13 @@ struct reset_controller_dev;
>   *         things to reset the device
>   * @assert: manually assert the reset line, if supported
>   * @deassert: manually deassert the reset line, if supported
> + * @status: return the status of the reset line, if supported
>   */
>  struct reset_control_ops {
>  	int (*reset)(struct reset_controller_dev *rcdev, unsigned long id);
>  	int (*assert)(struct reset_controller_dev *rcdev, unsigned long id);
>  	int (*deassert)(struct reset_controller_dev *rcdev, unsigned long id);
> +	int (*status)(struct reset_controller_dev *rcdev, unsigned long id);
>  };
>  
>  struct module;
> diff --git a/include/linux/reset.h b/include/linux/reset.h
> index 349f150..da5602b 100644
> --- a/include/linux/reset.h
> +++ b/include/linux/reset.h
> @@ -10,6 +10,7 @@ struct reset_control;
>  int reset_control_reset(struct reset_control *rstc);
>  int reset_control_assert(struct reset_control *rstc);
>  int reset_control_deassert(struct reset_control *rstc);
> +int reset_control_status(struct reset_control *rstc);
>  
>  struct reset_control *reset_control_get(struct device *dev, const char *id);
>  void reset_control_put(struct reset_control *rstc);
> @@ -57,6 +58,12 @@ static inline int reset_control_deassert(struct reset_control *rstc)
>  	return 0;
>  }
>  
> +static inline int reset_control_status(struct reset_control *rstc)
> +{
> +	WARN_ON(1);
> +	return 0;
> +}
> +
>  static inline void reset_control_put(struct reset_control *rstc)
>  {
>  	WARN_ON(1);
> 

Do you have any further comments on this version of that patch? If not,
can I get an Ack-by?

Thanks,
Dinh
