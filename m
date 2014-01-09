Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbaAIBLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 20:11:55 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:11371 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbaAIBLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 20:11:53 -0500
Date: Wed, 8 Jan 2014 17:13:27 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 4/7] mfd: ssbi: Add regmap read/write helpers
Message-ID: <20140109011327.GC23276@sonymobile.com>
References: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org>
 <1389206270-3728-5-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1389206270-3728-5-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 07:37:47PM +0100, Stephen Boyd wrote:
> Add read and write helper functions that the pm8921-core driver
> can use to read and write ssbi regsiters via a "no-bus" regmap.
> 

Nit: s/regsiters/registers/

> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  include/linux/ssbi.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/ssbi.h b/include/linux/ssbi.h
> index bcbb642a7641..3ffc02e479d2 100644
> --- a/include/linux/ssbi.h
> +++ b/include/linux/ssbi.h
> @@ -20,4 +20,17 @@
>  int ssbi_write(struct device *dev, u16 addr, const u8 *buf, int len);
>  int ssbi_read(struct device *dev, u16 addr, u8 *buf, int len);
>  
> +static inline int
> +ssbi_reg_read(void *context, unsigned int reg, unsigned int *val)
> +{
> +	*val = 0;
> +	return ssbi_read(context, reg, (u8 *)val, 1);
> +}
> +
> +static inline int
> +ssbi_reg_write(void *context, unsigned int reg, unsigned int val)
> +{
> +	return ssbi_write(context, reg, (u8 *)&val, 1);
> +}

These functions are endian specific and just generally ugly. I
understand that these functions may make the ssbi regmap code cleaner,
but that's not really a good excuse for functions which by themselves
look horribly broken.

If these are really needed, perhaps something like the following would
be acceptable?

+static inline int
+ssbi_reg_read(void *context, unsigned int reg, unsigned int *val)
+{
+	int rc;
+	u8 b;
+	rc = ssbi_read(context, reg, &b, 1);
+	if (rc == 1)
+		*val = b;
+	return rc;
+}
+
+static inline int
+ssbi_reg_write(void *context, unsigned int reg, unsigned int val)
+{
+	u8 b = val;
+	return ssbi_write(context, reg, &b, 1);
+}

-Courtney
