Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3HVRpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:45:52 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:35962 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3HVRpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:45:50 -0400
Message-ID: <52164E53.9000700@cogentembedded.com>
Date: Thu, 22 Aug 2013 21:45:55 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rupesh Gujare <rupesh.gujare@atmel.com>
CC: devel@linuxdriverproject.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 4/4] staging: ozwpan: Create deferred work to destroy
 PD object.
References: <1377189531-24950-1-git-send-email-rupesh.gujare@atmel.com> <1377189531-24950-4-git-send-email-rupesh.gujare@atmel.com>
In-Reply-To: <1377189531-24950-4-git-send-email-rupesh.gujare@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/22/2013 08:38 PM, Rupesh Gujare wrote:

> Currently we call oz_pd_destroy() from softirq context, where we
> try to destroy relevant data structures, as well we kill a tasklet
> which always result in following kernel warning.

> [12279.262194] Attempt to kill tasklet from interrupt
> [12279.262202] Attempt to kill tasklet from interrupt

> This patch defers deallocation of data structures to work queue.

> Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
> ---
>   drivers/staging/ozwpan/ozpd.c |   28 +++++++++++++++++++++++-----
>   drivers/staging/ozwpan/ozpd.h |    1 +
>   2 files changed, 24 insertions(+), 5 deletions(-)

> diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
> index 2514d79..06004c8 100644
> --- a/drivers/staging/ozwpan/ozpd.c
> +++ b/drivers/staging/ozwpan/ozpd.c
[...]
> @@ -259,6 +257,26 @@ void oz_pd_destroy(struct oz_pd *pd)
>   }
>
>   /*------------------------------------------------------------------------------
> + * Context: softirq or Process
> + */
> +void oz_pd_destroy(struct oz_pd *pd)
> +{
> +	int ret;
> +
> +	if (hrtimer_active(&pd->timeout))
> +		hrtimer_cancel(&pd->timeout);
> +	if (hrtimer_active(&pd->heartbeat))
> +		hrtimer_cancel(&pd->heartbeat);
> +
> +	memset(&pd->workitem, 0, sizeof(pd->workitem));
> +	INIT_WORK(&pd->workitem, oz_pd_free);

    Hm, memset(), then INIT_WORK()? Is memset() necessary?

> +	ret = schedule_work(&pd->workitem);
> +

    Don't think empty line is needed here.

> +	if (ret)
> +		oz_pd_dbg(pd, ON, "failed to schedule workitem\n");
> +}
> +
> +/*------------------------------------------------------------------------------
>    * Context: softirq-serialized
>    */
>   int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
> diff --git a/drivers/staging/ozwpan/ozpd.h b/drivers/staging/ozwpan/ozpd.h
> index 996ef65..12c7129 100644
> --- a/drivers/staging/ozwpan/ozpd.h
> +++ b/drivers/staging/ozwpan/ozpd.h
> @@ -99,6 +99,7 @@ struct oz_pd {
>   	u8      timeout_type;
>   	struct tasklet_struct   heartbeat_tasklet;
>   	struct tasklet_struct   timeout_tasklet;
> +	struct work_struct workitem;

    Er, other field names seem aligned, what about this one?

>   };

WBR, Sergei

