Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbaGaIsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:48:07 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:41060 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247AbaGaIsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:48:04 -0400
Message-ID: <53DA02C0.2050606@mm-sol.com>
Date: Thu, 31 Jul 2014 11:48:00 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Collins <collinsd@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 1/4] mfd: pm8xxx-spmi: add support for Qualcomm SPMI
 PMICs
References: <1406205921-7452-1-git-send-email-svarbanov@mm-sol.com> <1406205921-7452-2-git-send-email-svarbanov@mm-sol.com> <53D8182A.5050204@codeaurora.org>
In-Reply-To: <53D8182A.5050204@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thanks for the comments!

On 07/30/2014 12:54 AM, David Collins wrote:
> On 07/24/2014 05:45 AM, Stanimir Varbanov wrote:
>> From: Josh Cartwright <joshc@codeaurora.org>
>>
>> The Qualcomm SPMI PMIC chips are components used with the
>> Snapdragon 800 series SoC family.  This driver exists
>> largely as a glue mfd component, it exists to be an owner
>> of an SPMI regmap for children devices described in
>> device tree.
>>
>> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> Acked-by: Lee Jones <lee.jones@linaro.org>
>> ---
>>  drivers/mfd/Kconfig       |   16 +++++++++++
>>  drivers/mfd/Makefile      |    1 +
>>  drivers/mfd/pm8xxx-spmi.c |   65 +++++++++++++++++++++++++++++++++++++++++++++
> 
> Would it be possible to rename this driver: qcom-spmi-pmic.c?  The driver
> will be supporting several PMICs that do not fit the pm8xxx naming scheme.
>  One of which is even specified in the compatible list of this driver
> (pma8084).  There is presently downstream support for the following PMICs:
> PM8019, PM8110, PM8226, PM8841, PM8916, PM8941, PM8994, PMA8084, PMD9635,
> PMI8962, and PMI8994 [1].  Four of these do not fit the "PM8XXX" template.

I haven't strong opinion on the file names. The qcom prefix is the one
which annoying me. If you look at /drivers/mfd the company name prefixes
are very few.

The *compatible* strings are the important thing here. So If MFD
maintainer is fine with this name I'm fine too.

> 
> If we can agree on changing the file name for the driver, then all other
> instances of "pm8xxx" would need to be renamed in this patch series (e.g.
> config options, function names, struct names, DT binding documentation, etc.)
> 
> It would probably be good to rename pm8xxx-ssbi.c to qcom-ssbi-pmic.c as
> well in order to maintain consistency.
> 
> (...)
>> +static const struct regmap_config pm8xxx_regmap_config = {
>> +	.reg_bits	= 16,
>> +	.val_bits	= 8,
>> +	.max_register	= 0xffff,
> 
> Can you please add the following line here?
> 
> 	.fast_io	= true;
> 
> This will cause a spinlock to be held during SPMI transactions instead of
> a mutex lock.  This is needed because several downstream peripheral
> drivers need to make SPMI read and write calls from atomic context.  I
> have commented on this point in a previous thread with specific examples [2].

OK, I understand the need of atomic context, but pmic_arb_read_cmd() and
pmic_arb_write_cmd() functions use raw_spin_lock_irqsave already. Isn't
those locks enough?

> 
>> +};
> 
> (...)
>> +static const struct of_device_id pm8xxx_id_table[] = {
>> +	{ .compatible = "qcom,pm8941" },
>> +	{ .compatible = "qcom,pm8841" },
>> +	{ .compatible = "qcom,pma8084" },
> 
> Would it be possible to add a generic compatible string as well?  Perhaps
> something like "qcom,spmi-pmic" could be used.  This driver is not doing
> anything with the PMIC specific compatible strings.  The generic
> compatible string could be specified in device tree in conjunction a PMIC
> specific string that is not present in this list.  That way, this driver
> file would not need to be touched as new PMIC chips are introduced unless
> some weird workaround is needed.  In that case, the PMIC specific
> compatible string could be added to the list along with whatever special
> function is needed to handle it.

OK, I'm fine with this suggestion.

-- 
regards,
Stan
