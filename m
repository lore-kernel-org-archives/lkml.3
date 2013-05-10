Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3EJOBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:01:14 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55985 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3EJOBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:01:13 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.153.142]
In-Reply-To: <1368192769-24067-2-git-send-email-fery@cypress.com>
References: <1368192769-24067-1-git-send-email-fery@cypress.com>
	<1368192769-24067-2-git-send-email-fery@cypress.com>
Date: Fri, 10 May 2013 16:01:11 +0200
Message-ID: <CABxcv==KdTbXsiUtkws-CJp9qtnJx4D_ruLCrHn_ZLi4XawitQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Input: cyttsp - add missing handshake
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Ferruh Yigit <fery@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, ttdrivers@cypress.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 3:32 PM, Ferruh Yigit <fery@cypress.com> wrote:
> For the devices that has blocking with timeout communication, these
> extra handshakes will prevent one timeout delay in startup sequence
>
> Tested-by: Ferruh Yigit <fery@cypress.com> on TMA300-DVK
> Signed-off-by: Ferruh Yigit <fery@cypress.com>
> ---
>  drivers/input/touchscreen/cyttsp_core.c |   24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/input/touchscreen/cyttsp_core.c b/drivers/input/touchscreen/cyttsp_core.c
> index 97ba891..7007f58 100644
> --- a/drivers/input/touchscreen/cyttsp_core.c
> +++ b/drivers/input/touchscreen/cyttsp_core.c
> @@ -116,6 +116,13 @@ static int ttsp_send_command(struct cyttsp *ts, u8 cmd)
>         return ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd), &cmd);
>  }
>
> +static int _cyttsp_hndshk(struct cyttsp *ts, u8 hst_mode)
> +{
> +       if (ts->pdata->use_hndshk)
> +               return ttsp_send_command(ts, hst_mode ^ CY_HNDSHK_BIT);
> +       return 0;
> +}
> +
>  static int cyttsp_load_bl_regs(struct cyttsp *ts)
>  {
>         memset(&ts->bl_data, 0, sizeof(ts->bl_data));
> @@ -167,6 +174,10 @@ static int cyttsp_set_operational_mode(struct cyttsp *ts)
>         if (error)
>                 return error;
>
> +       error = _cyttsp_hndshk(ts, ts->xy_data.hst_mode);
> +       if (error)
> +               return error;
> +
>         return ts->xy_data.act_dist == CY_ACT_DIST_DFLT ? -EIO : 0;
>  }
>
> @@ -188,6 +199,10 @@ static int cyttsp_set_sysinfo_mode(struct cyttsp *ts)
>         if (error)
>                 return error;
>
> +       error = _cyttsp_hndshk(ts, ts->sysinfo_data.hst_mode);
> +       if (error)
> +               return error;
> +
>         if (!ts->sysinfo_data.tts_verh && !ts->sysinfo_data.tts_verl)
>                 return -EIO;
>
> @@ -344,12 +359,9 @@ static irqreturn_t cyttsp_irq(int irq, void *handle)
>                 goto out;
>
>         /* provide flow control handshake */
> -       if (ts->pdata->use_hndshk) {
> -               error = ttsp_send_command(ts,
> -                               ts->xy_data.hst_mode ^ CY_HNDSHK_BIT);
> -               if (error)
> -                       goto out;
> -       }
> +       error = _cyttsp_hndshk(ts, ts->xy_data.hst_mode);
> +       if (error)
> +               goto out;
>
>         if (unlikely(ts->state == CY_IDLE_STATE))
>                 goto out;
> --
> 1.7.9.5
>
> This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

Acked-by: Javier Martinez Canillas <javier@dowhile0.org>
