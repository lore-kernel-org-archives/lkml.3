Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaLEIdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:33:25 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:50674 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbaLEIdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:33:22 -0500
MIME-Version: 1.0
In-Reply-To: <1417766884-8383-3-git-send-email-harinik@xilinx.com>
References: <1417766884-8383-1-git-send-email-harinik@xilinx.com>
	<1417766884-8383-3-git-send-email-harinik@xilinx.com>
Date: Fri, 5 Dec 2014 14:03:21 +0530
Message-ID: <CAA7nrtg7xG5NekMMPLH-XLV+KEurX+akubhLqc3o6DA9R1bd9Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] i2c: cadence: Check for errata condition involving
 master receive
From: rajeev kumar <rajeevkumar.linux@gmail.com>
To: Harini Katakam <harinik@xilinx.com>
Cc: wsa@the-dreams.de, mark.rutland@arm.com, michal.simek@xilinx.com,
        soren.brinkmann@xilinx.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harini Katakam <harinikatakamlinux@gmail.com>,
        Vishnu Motghare <vishnum@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 1:38 PM, Harini Katakam <harinik@xilinx.com> wrote:
> Cadence I2C controller has the following bugs:
> - completion indication is not given to the driver at the end of
> a read/receive transfer with HOLD bit set.
> - Invalid read transaction are generated on the bus when HW timeout
> condition occurs with HOLD bit set.
>
> As a result of the above, if a set of messages to be transferred with
> repeated start includes any transfer following a read transfer,
> completion is never indicated and timeout occurs.
> Hence a check is implemented to return -EOPNOTSUPP for such sequences.
>
> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> Signed-off-by: Vishnu Motghare <vishnum@xilinx.com>
> ---
>
> v3:
> Add warning in case of unsupported transfer.
>

Reviewed-by: Rajeev Kumar <rajeevkumar.linux@gmail.com>

> v2:
> Dont defeteature repeated start. Just check for unsupported conditions in the
> driver and return error.
>
> ---
>  drivers/i2c/busses/i2c-cadence.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
> index 5f5d4fa..3ea3b7a 100644
> --- a/drivers/i2c/busses/i2c-cadence.c
> +++ b/drivers/i2c/busses/i2c-cadence.c
> @@ -541,6 +541,21 @@ static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
>          * processed with a repeated start.
>          */
>         if (num > 1) {
> +               /*
> +                * This controller does not give completion interrupt after a
> +                * master receive transfer if HOLD bit is set (repeated start),
> +                * resulting in SW timeout. Hence, if a receive transfer is
> +                * followed by any other transfer, an error is returned
> +                * indicating that this sequence is not supported.
> +                */
> +               for (count = 0; count < num-1; count++) {
> +                       if (msgs[count].flags & I2C_M_RD)
> +                               dev_warn(adap->dev.parent,
> +                                       "No support for repeated start when\t");
> +                               dev_warn(adap->dev.parent,
> +                                       "receive is followed by a transfer\n");
> +                               return -EOPNOTSUPP;
> +               }
>                 id->bus_hold_flag = 1;
>                 reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
>                 reg |= CDNS_I2C_CR_HOLD;
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
