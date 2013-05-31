Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab3EaGkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 02:40:41 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:46313 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab3EaGke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 02:40:34 -0400
Message-ID: <51A843D4.9010001@st.com>
Date: Fri, 31 May 2013 07:31:48 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC] regmap: Add regmap_field APIs
References: <1369753080-1929-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1369753080-1929-1-git-send-email-srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

We have pretty much completed reworking the patch-set we sent recently
for the STiH41x SOC support. We are waiting for your feedback on this patch.

Thanks,
srini

On 28/05/13 15:58, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> It is common to access regmap registers at bit level, using
> regmap_update_bits or regmap_read functions, however the end user has to
> take care of a mask or shifting. This becomes overhead when such use
> cases are high. Having a common function to do this is much convient and less
> error prone.
> 
> The idea of regmap_field is simple, regmap_field gives a logical structure to
> bits of the regmap register, and the driver can use this logical entity without
> the knowledge of the bit postions and masks all over the code. This way code
> looks much neat and it need not handle the masks, shifts every time it access
> the those entities.
> 
> With this new regmap_field_read/write apis the end user can setup a
> regmap field using regmap_field_init and use the return regmap_field to
> read write the register field without worrying about the masks or
> shifts.
> Also this apis will be usefull for drivers which are based on regmaps,
> like some clocks or pinctrls which can work on the regmap_fields
> directly without having to worry about bit positions.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---
> Hi Mark,
> 
> I have been looking at using regmap mmio directly for ST "System Configuration
> registers". One thing which we discussed 2 weeks back in syscon patch was, if
> this new functionality would benifit others. Having thought about it, I think
> that if regmap had a concept like regmap_field we would have used it straight way
> without a new driver.
> 
> I generated this patch mainly to get your opinion on these new APIs, Is this the
> right place for these APIs, or do you suggest that these APIs should go in SOC
> Specific driver?
> 
> Comments?
> 
> Thanks,
> srini
> 
> 
> 
>  drivers/base/regmap/regmap.c |   47 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/regmap.h       |   28 +++++++++++++++++++++++++
>  2 files changed, 75 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index a941dcf..4512df7 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -1249,6 +1249,27 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
>  }
>  EXPORT_SYMBOL_GPL(regmap_raw_write);
>  
> +/**
> + * regmap_field_write(): Write a value to a single register field
> + *
> + * @field: Register field to write to
> + * @val: Value to be written
> + *
> + * A value of zero will be returned on success, a negative errno will
> + * be returned in error cases.
> + */
> +
> +int regmap_field_write(struct regmap_field *field, unsigned int val)
> +{
> +	int field_bits;
> +	unsigned int reg_mask;
> +	field_bits = field->msb - field->lsb + 1;
> +	reg_mask = ((BIT(field_bits) - 1) << field->lsb);
> +	return regmap_update_bits(field->regmap, field->reg,
> +				reg_mask, val << field->lsb);
> +}
> +EXPORT_SYMBOL_GPL(regmap_field_write);
> +
>  /*
>   * regmap_bulk_write(): Write multiple registers to the device
>   *
> @@ -1532,6 +1553,32 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
>  EXPORT_SYMBOL_GPL(regmap_raw_read);
>  
>  /**
> + * regmap_field_read(): Read a value to a single register field
> + *
> + * @field: Register field to read from
> + * @val: Pointer to store read value
> + *
> + * A value of zero will be returned on success, a negative errno will
> + * be returned in error cases.
> + */
> +
> +int regmap_field_read(struct regmap_field *field, unsigned int *val)
> +{
> +	int field_bits;
> +	int ret;
> +	ret = regmap_read(field->regmap, field->reg, val);
> +	if (ret != 0)
> +		return ret;
> +
> +	field_bits = field->msb - field->lsb + 1;
> +	*val >>= field->lsb;
> +	*val &= (BIT(field_bits) - 1);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(regmap_field_read);
> +
> +/**
>   * regmap_bulk_read(): Read multiple registers from the device
>   *
>   * @map: Register map to write to
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> index 02d84e2..f8dba11 100644
> --- a/include/linux/regmap.h
> +++ b/include/linux/regmap.h
> @@ -411,6 +411,34 @@ bool regmap_reg_in_ranges(unsigned int reg,
>  			  const struct regmap_range *ranges,
>  			  unsigned int nranges);
>  
> +struct regmap_field {
> +	struct regmap *regmap;
> +	unsigned int reg;
> +	unsigned int lsb;
> +	unsigned int msb;
> +};
> +
> +#define REGMAP_FIELD_INIT(regmap, reg, lsb, msb) { 	\
> +				.regmap = regmap, 	\
> +				.reg = reg, 		\
> +				.lsb = lsb, 		\
> +				.msb = msb, 		\
> +			}
> +
> +/* dynamic version of regmap_field intialization */
> +static inline void regmap_field_init(struct regmap_field *field,
> +	struct regmap *regmap,	unsigned int reg,
> +	unsigned int lsb, unsigned int msb)
> +{
> +	field->regmap = regmap;
> +	field->reg = reg;
> +	field->lsb = lsb;
> +	field->msb = msb;
> +}
> +
> +int regmap_field_read(struct regmap_field *field, unsigned int *val);
> +int regmap_field_write(struct regmap_field *field, unsigned int val);
> +
>  /**
>   * Description of an IRQ for the generic regmap irq_chip.
>   *
> 

