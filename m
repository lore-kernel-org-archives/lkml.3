Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaAICYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 21:24:20 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38959 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaAICYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 21:24:17 -0500
Message-ID: <52CE0850.4010206@codeaurora.org>
Date: Wed, 08 Jan 2014 18:24:16 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Courtney Cavin <courtney.cavin@sonymobile.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 4/7] mfd: ssbi: Add regmap read/write helpers
References: <1389206270-3728-1-git-send-email-sboyd@codeaurora.org> <1389206270-3728-5-git-send-email-sboyd@codeaurora.org> <20140109011327.GC23276@sonymobile.com>
In-Reply-To: <20140109011327.GC23276@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/14 17:13, Courtney Cavin wrote:
> On Wed, Jan 08, 2014 at 07:37:47PM +0100, Stephen Boyd wrote:
>> --- a/include/linux/ssbi.h
>> +++ b/include/linux/ssbi.h
>> @@ -20,4 +20,17 @@
>>  int ssbi_write(struct device *dev, u16 addr, const u8 *buf, int len);
>>  int ssbi_read(struct device *dev, u16 addr, u8 *buf, int len);
>>  
>> +static inline int
>> +ssbi_reg_read(void *context, unsigned int reg, unsigned int *val)
>> +{
>> +	*val = 0;
>> +	return ssbi_read(context, reg, (u8 *)val, 1);
>> +}
>> +
>> +static inline int
>> +ssbi_reg_write(void *context, unsigned int reg, unsigned int val)
>> +{
>> +	return ssbi_write(context, reg, (u8 *)&val, 1);
>> +}
> These functions are endian specific and just generally ugly. I
> understand that these functions may make the ssbi regmap code cleaner,
> but that's not really a good excuse for functions which by themselves
> look horribly broken.
>
> If these are really needed, perhaps something like the following would
> be acceptable?
>
> +static inline int
> +ssbi_reg_read(void *context, unsigned int reg, unsigned int *val)
> +{
> +	int rc;
> +	u8 b;
> +	rc = ssbi_read(context, reg, &b, 1);
> +	if (rc == 1)
> +		*val = b;
> +	return rc;
> +}
> +
> +static inline int
> +ssbi_reg_write(void *context, unsigned int reg, unsigned int val)
> +{
> +	u8 b = val;
> +	return ssbi_write(context, reg, &b, 1);
> +}

Sure. I think you meant to check for a 0 return value from ssbi_read
though? Lee can you use this replacement patch please?

---8<---
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH] mfd: ssbi: Add regmap read/write helpers

Add read and write helper functions that the pm8921-core driver
can use to read and write ssbi regsiters via a "no-bus" regmap.

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/linux/ssbi.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/ssbi.h b/include/linux/ssbi.h
index bcbb642a7641..087b08a4d333 100644
--- a/include/linux/ssbi.h
+++ b/include/linux/ssbi.h
@@ -20,4 +20,24 @@
 int ssbi_write(struct device *dev, u16 addr, const u8 *buf, int len);
 int ssbi_read(struct device *dev, u16 addr, u8 *buf, int len);
 
+static inline int
+ssbi_reg_read(void *context, unsigned int reg, unsigned int *val)
+{
+	int ret;
+	u8 v;
+
+	ret = ssbi_read(context, reg, &v, 1);
+	if (!ret)
+		*val = v;
+
+	return ret;
+}
+
+static inline int
+ssbi_reg_write(void *context, unsigned int reg, unsigned int val)
+{
+	u8 v = val;
+	return ssbi_write(context, reg, &v, 1);
+}
+
 #endif

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

