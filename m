Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaILQi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:38:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55050 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaILQiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:38:25 -0400
X-AuditID: cbfee61b-f79f86d00000144c-10-5413217faa9b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dinguyen@opensource.altera.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, balbi@ti.com,
        dinh.linux@gmail.com, swarren@wwwdotorg.org, matthijs@stdin.nl,
        r.baldyga@samsung.com, jg1.han@samsung.com, sachin.kamat@linaro.org,
        ben-linux@fluff.org, dianders@chromium.org, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 11/12] usb: dwc2: check that the host work queue is valid
Date: Fri, 12 Sep 2014 18:38:21 +0200
Message-id: <1500416.dOxylvymks@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1409070003-21195-12-git-send-email-dinguyen@opensource.altera.com>
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com>
 <1409070003-21195-12-git-send-email-dinguyen@opensource.altera.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t9jQd16ReEQgwW9WhYH79dbTFp3gMni
	7LKDbBarPq1htlh5UtuiefF6NovLCy+xWmyb/hPI2jWHzWLRslZmi4Wvr7FYbJ8yncniweGd
	7BYn//QyWrw62MbiwO8xu+Eii8ffVS+YPXbOusvucefaHjaP/XPXsHv0X5vE7vF31n4Wj74t
	qxg9vvz4x+KxZf9nRo/jN7YzeXzeJOexcW5oAG8Ul01Kak5mWWqRvl0CV0bHpO1sBc+4K5ZO
	us/WwPiIs4uRk0NCwETi8uWTzBC2mMSFe+vZuhi5OIQEpjNKXJnXywzhtDBJHH98ixWkik3A
	SmJi+ypGEFtEQEmid9VLFpAiZoGzTBIrdq0FGyUs4C/xtOMLC4jNIqAqcWfXKyYQm1dAU+Lv
	nS1gNaICnhI7tq9kA7E5BQIk9vfcYYLYNoVR4tbKxSwQDYISPybfA7OZBeQl9u2fygph60js
	b53GNoFRYBaSsllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgKn0nvYFzV
	YHGIUYCDUYmHt5JFMESINbGsuDL3EKMEB7OSCK+iqHCIEG9KYmVValF+fFFpTmrxIUZpDhYl
	cd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBsZqq0ly70Rm5hy/YBOb58V8cNNEh7Yvf4QnTs1v
	DAhbP0U6Kc8nN67nSePz5P+z3rr/Uj4X4PJkyonEO+LyS80DYzrMq3KPKt8yjW2S7oz2ixRI
	dOSe06ccsuFQ/1xnLZWbMtXXOZq32v3/knxJWMImc0Pa3fxfjtofv7I4bnNz/WGQsjNCWoml
	OCPRUIu5qDgRAMfEhiG+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added linux-kernel ML to cc: ]

Hi,

On Tuesday, August 26, 2014 11:20:02 AM dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> The Host workqueue will not get initialized if the driver is configured for
> peripheral mode only. Thus we need to check for wq_otg before calling
> queue_work().

This should be done at the same time that gadget/host probing is merged
to preserve bisectability.

> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> ---
>  drivers/usb/dwc2/core_intr.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
> index 651785d..1240875 100644
> --- a/drivers/usb/dwc2/core_intr.c
> +++ b/drivers/usb/dwc2/core_intr.c
> @@ -287,9 +287,11 @@ static void dwc2_handle_conn_id_status_change_intr(struct dwc2_hsotg *hsotg)
>  	 * Release lock before scheduling workq as it holds spinlock during
>  	 * scheduling.
>  	 */
> -	spin_unlock(&hsotg->lock);
> -	queue_work(hsotg->wq_otg, &hsotg->wf_otg);
> -	spin_lock(&hsotg->lock);
> +	if (hsotg->wq_otg) {
> +		spin_unlock(&hsotg->lock);
> +		queue_work(hsotg->wq_otg, &hsotg->wf_otg);
> +		spin_lock(&hsotg->lock);
> +	}
>  
>  	/* Clear interrupt */
>  	writel(GINTSTS_CONIDSTSCHNG, hsotg->regs + GINTSTS);

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

