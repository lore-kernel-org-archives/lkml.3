Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaCALr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 06:47:27 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:52413 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaCALr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 06:47:26 -0500
Message-ID: <5311C8FB.4000301@kernel.org>
Date: Sat, 01 Mar 2014 11:48:11 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Marek Belisko <marek@goldelico.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [RFCv4 4/7] mfd: twl-core: Add twl_i2c_read/write_u16
References: <1393374270-20079-1-git-send-email-sre@debian.org> <1393444990-28140-1-git-send-email-sre@debian.org> <1393444990-28140-5-git-send-email-sre@debian.org>
In-Reply-To: <1393444990-28140-5-git-send-email-sre@debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/14 20:03, Sebastian Reichel wrote:
> Add a simple twl_i2c_read/write_u16 wrapper over
> the twl_i2c_read/write, which is similar to the
> twl_i2c_read/write_u8 wrapper.
>
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Jonathan Cameron <jic23@kernel.org>

(I'll start a separate conversation about who will take this series in a mo).

> ---
>   include/linux/i2c/twl.h | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
> index ade1c06..d2b1670 100644
> --- a/include/linux/i2c/twl.h
> +++ b/include/linux/i2c/twl.h
> @@ -195,6 +195,18 @@ static inline int twl_i2c_read_u8(u8 mod_no, u8 *val, u8 reg) {
>   	return twl_i2c_read(mod_no, val, reg, 1);
>   }
>
>
Hmm. This had me confused for a few mins given word rights in i2c are guaranteed
to be little endian unless the swapped versions are used.  I see that the twl
driver is using a generic i2c bulk write.  Ah well, I can see that simplifies
the regmap i2c code and works in most cases...
+static inline int twl_i2c_write_u16(u8 mod_no, u16 val, u8 reg) {
> +	val = cpu_to_le16(val);
> +	return twl_i2c_write(mod_no, (u8*) &val, reg, 2);
> +}
> +
> +static inline int twl_i2c_read_u16(u8 mod_no, u16 *val, u8 reg) {
> +	int ret;
> +	ret = twl_i2c_read(mod_no, (u8*) val, reg, 2);
> +	*val = le16_to_cpu(*val);
> +	return ret;
> +}
> +
>   int twl_get_type(void);
>   int twl_get_version(void);
>   int twl_get_hfclk_rate(void);
>

