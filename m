Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3FEJWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:22:19 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:44892 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179Ab3FEJWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:22:17 -0400
Message-ID: <51AF0313.6000205@st.com>
Date: Wed, 05 Jun 2013 10:21:23 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] regmap: Add regmap_field APIs
References: <1369753080-1929-1-git-send-email-srinivas.kandagatla@st.com> <20130604210137.GV31367@sirena.org.uk>
In-Reply-To: <20130604210137.GV31367@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/13 22:01, Mark Brown wrote:
> On Tue, May 28, 2013 at 03:58:00PM +0100, Srinivas KANDAGATLA wrote:
> 
>> +#define REGMAP_FIELD_INIT(regmap, reg, lsb, msb) { 	\
>> +				.regmap = regmap, 	\
>> +				.reg = reg, 		\
>> +				.lsb = lsb, 		\
>> +				.msb = msb, 		\
>> +			}
> 
> Having a macro for this is really odd since macros are generally only
> used at compile time but the regmap is only available at runtime and
> this...
> 
Yes, I think the macro is bit over do.. I will remove it.

>> +static inline void regmap_field_init(struct regmap_field *field,
>> +	struct regmap *regmap,	unsigned int reg,
>> +	unsigned int lsb, unsigned int msb)
>> +{
>> +	field->regmap = regmap;
>> +	field->reg = reg;
>> +	field->lsb = lsb;
>> +	field->msb = msb;
>> +}
> 
> ...is a bit awkward since you can't use it with static data.  I think
> either the read/write/modify APIs should be changed to take both the map
> and the field as arguments (with the field only containing the bitfield
> definitions) or the init function should be something that allocates a
> new, runtime only structure from static data.
I agree with you and I think init function should allocate and
initialize the regmap_field and return it, and the read/write apis will
take the field and value. This approach looks neat.

Is it ok if we rename the regmap_field_init function to
regmap_field_alloc, as it will make it obvious that its allocating
memory which should be freed?
I also thought we could add devm version of it as well.

With this change here is what the init/alloc function would look like:

static void _regmap_field_init(struct regmap_field *field,
		struct regmap *regmap, unsigned int reg,
		unsigned int lsb, unsigned int msb)
{
	field->regmap = regmap;
	field->reg = reg;
	field->lsb = lsb;
	field->msb = msb;
}

struct regmap_field *devm_regmap_field_alloc(struct device *dev,
		struct regmap *regmap, unsigned int reg,
		unsigned int lsb, unsigned int msb)
{
	struct regmap_field *field = devm_kzalloc(dev,
					sizeof(*field),	GFP_KERNEL);
	if (!field)
		return ERR_PTR(-ENOMEM);

	_regmap_field_init(field, regmap, reg, lsb, msb);
	return field;

}
EXPORT_SYMBOL_GPL(devm_regmap_field_alloc);

struct regmap_field *regmap_field_alloc(struct regmap *regmap,
		unsigned int reg, unsigned int lsb, unsigned int msb)
{
	struct regmap_field *field = kzalloc(sizeof(*field), GFP_KERNEL);
	if (!field)
		return ERR_PTR(-ENOMEM);

	_regmap_field_init(field, regmap, reg, lsb, msb);
	return field;
}
EXPORT_SYMBOL_GPL(regmap_field_alloc);

In header file..
static void inline regmap_field_free(struct regmap_field *field)
{
	kfree(field);
}

static void inline devm_regmap_field_free(struct device *dev, struct
regmap_field *field)
{
	devm_kfree(dev, field);
}

Thanks,
srini
> 

