Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbbAWRDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:03:31 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:43444 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbbAWRD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:03:27 -0500
Message-ID: <54C27ED9.9080403@mm-sol.com>
Date: Fri, 23 Jan 2015 19:03:21 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Gilad Avidov <gavidov@codeaurora.org>
CC: sdharia@codeaurora.org, mlocke@codeaurora.org,
        linux-arm-msm@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, iivanov@mm-sol.com, galak@codeaurora.org,
        agross@codeaurora.org
Subject: Re: [PATCH] spmi: pmic_arb: add support for hw version 2
References: <1421716210-14805-1-git-send-email-gavidov@codeaurora.org>
In-Reply-To: <1421716210-14805-1-git-send-email-gavidov@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gilad,

On 01/20/2015 03:10 AM, Gilad Avidov wrote:
> Qualcomm PMIC Arbiter version-2 changes from version-1 are:
> 
> - Some diffrent register offsets.
> - New channel register space, one per PMIC peripheral (ppid).
>   All tx tarffic uses these channels.
> - New observer register space. All rx trafic uses this space.
> - Diffrent command format for spmi command registers.
> 
> Signed-off-by: Gilad Avidov <gavidov@codeaurora.org>
> Acked-by: Sagar Dharia <sdharia@codeaurora.org>
> ---
>  .../bindings/spmi/qcom,spmi-pmic-arb.txt           |  11 +-
>  drivers/spmi/spmi-pmic-arb.c                       | 295 ++++++++++++++++++---
>  2 files changed, 263 insertions(+), 43 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
> index 715d099..827bd21 100644
> --- a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
> +++ b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
> @@ -1,11 +1,11 @@
>  Qualcomm SPMI Controller (PMIC Arbiter)
>  
> -The SPMI PMIC Arbiter is found on the Snapdragon 800 Series.  It is an SPMI
> +The SPMI PMIC Arbiter is found on Snapdragon chipsets.  It is an SPMI
>  controller with wrapping arbitration logic to allow for multiple on-chip
>  devices to control a single SPMI master.
>  
> -The PMIC Arbiter can also act as an interrupt controller, providing interrupts
> -to slave devices.
> +The PMIC Arbiter is also an interrupt controller, interrupting the Snapdragon
> +on dtection of a sequence initiated by a request-capable-slave to the master.
>  

<snip>

>  
> -/* Non-data command */
> -static int pmic_arb_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid)
> +static int
> +pmic_arb_non_data_cmd_v1(struct spmi_controller *ctrl, u8 opc, u8 sid)
>  {
>  	struct spmi_pmic_arb_dev *pmic_arb = spmi_controller_get_drvdata(ctrl);
>  	unsigned long flags;
>  	u32 cmd;
>  	int rc;
> -
> -	/* Check for valid non-data command */
> -	if (opc < SPMI_CMD_RESET || opc > SPMI_CMD_WAKEUP)
> -		return -EINVAL;
> +	u32 offset = pmic_arb->ver->offset(pmic_arb, sid, 0);
>  
>  	cmd = ((opc | 0x40) << 27) | ((sid & 0xf) << 20);
>  
>  	raw_spin_lock_irqsave(&pmic_arb->lock, flags);
> -	pmic_arb_base_write(pmic_arb, PMIC_ARB_CMD(pmic_arb->channel), cmd);
> -	rc = pmic_arb_wait_for_done(ctrl);
> +	pmic_arb_base_write(pmic_arb, offset + PMIC_ARB_CMD, cmd);
> +	rc = pmic_arb_wait_for_done(ctrl, pmic_arb->wr_base, sid, 0);
>  	raw_spin_unlock_irqrestore(&pmic_arb->lock, flags);
>  
>  	return rc;
>  }
>  
> +/* Unsupported by HW */
> +static int
> +pmic_arb_non_data_cmd_v2(struct spmi_controller *ctrl, u8 opc, u8 sid)
> +{
> +	return -EOPNOTSUPP;
> +}

Does pmic arbiter v2 supports SPMI_CMD_WAKEUP and SPMI_CMD_SHUTDOWN
commands? If so how we send those commands to the arbiter when the
.non_data_cmd operation returns EOPNOTSUPP. If we returning EOPNOTSUPP
the spmi bus .probe method will not call spmi driver .probe. See spmi.c
spmi_drv_probe().

<snip>


-- 
regards,
Stan
