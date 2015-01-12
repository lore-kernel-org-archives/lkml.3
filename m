Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbbALNPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:15:36 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39637 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbbALNPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:15:33 -0500
MIME-Version: 1.0
In-Reply-To: <1420824103-24169-3-git-send-email-wsa@the-dreams.de>
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
	<1420824103-24169-3-git-send-email-wsa@the-dreams.de>
Date: Mon, 12 Jan 2015 14:15:32 +0100
Message-ID: <CABuKBe++yut6ZfhPrsWXGA4fZRvum6WOuRxHucM0gBJCGuou5A@mail.gmail.com>
Subject: Re: [RFC 02/11] i2c: add quirk checks to core
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        linuxppc-dev@lists.ozlabs.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-09 18:21 GMT+01:00 Wolfram Sang <wsa@the-dreams.de>:
> Let the core do the checks if HW quirks prevent a transfer. Saves code
> from drivers and adds consistency.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/i2c/i2c-core.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
>
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 39d25a8cb1ad..7b10a19abf5b 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -2063,6 +2063,56 @@ module_exit(i2c_exit);
>   * ----------------------------------------------------
>   */
>
> +/* Check if val is exceeding the quirk IFF quirk is non 0 */
> +#define i2c_quirk_exceeded(val, quirk) ((quirk) && ((val) > (quirk)))
> +
> +static int i2c_quirk_error(struct i2c_adapter *adap, struct i2c_msg *msg, char *err_msg)
> +{
> +       dev_err(&adap->dev, "quirk: %s (addr 0x%04x, size %u)\n", err_msg, msg->addr, msg->len);
> +       return -EOPNOTSUPP;
> +}
> +
> +static int i2c_check_for_quirks(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
> +{
> +       struct i2c_adapter_quirks *q = adap->quirks;
> +       u16 max_read = q->max_read_len, max_write = q->max_write_len;
> +       int max_num = q->max_num_msgs, i;
> +
> +       if (q->flags & I2C_ADAPTER_QUIRK_COMB_WRITE_THEN_READ)
> +               max_num = 2;
> +
> +       if (i2c_quirk_exceeded(num, max_num))
> +               return i2c_quirk_error(adap, &msgs[0], "too many messages");
> +
> +       if (num == 2 && q->flags & I2C_ADAPTER_QUIRK_COMB_WRITE_FIRST) {
> +               if (msgs[0].flags & I2C_M_RD)
> +                       return i2c_quirk_error(adap, &msgs[0], "invalid first write msg");
> +
> +               max_write = q->max_comb_write_len;
> +       }
> +
> +       if (num == 2 && q->flags & I2C_ADAPTER_QUIRK_COMB_READ_SECOND) {
> +               if (!(msgs[1].flags & I2C_M_RD) || msgs[0].addr != msgs[1].addr)
> +                       return i2c_quirk_error(adap, &msgs[1], "invalid second read msg");
> +
> +               max_read = q->max_comb_read_len;
> +       }
> +
> +       for (i = 0; i < num; i++) {
> +               u16 len = msgs[i].len;
> +
> +               if (msgs[i].flags & I2C_M_RD) {
> +                       if (i2c_quirk_exceeded(len, max_read))
> +                               return i2c_quirk_error(adap, &msgs[i], "msg too long");
> +               } else {
> +                       if (i2c_quirk_exceeded(len, max_write))
> +                               return i2c_quirk_error(adap, &msgs[i], "msg too long");
> +               }

What about being more verbose in the error message, specifying if it
was a read or a write message that failed?

> +       }
> +
> +       return 0;
> +}
> +
>  /**
>   * __i2c_transfer - unlocked flavor of i2c_transfer
>   * @adap: Handle to I2C bus
> @@ -2080,6 +2130,9 @@ int __i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
>         unsigned long orig_jiffies;
>         int ret, try;
>
> +       if (adap->quirks && i2c_check_for_quirks(adap, msgs, num))
> +               return -EOPNOTSUPP;
> +
>         /* i2c_trace_msg gets enabled when tracepoint i2c_transfer gets
>          * enabled.  This is an efficient way of keeping the for-loop from
>          * being executed when not needed.
> --
> 2.1.3
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
motzblog.wordpress.com
