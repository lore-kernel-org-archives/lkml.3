Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbaKDP0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:26:54 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:46576 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbaKDP0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:26:52 -0500
Message-ID: <5458F039.3030809@mm-sol.com>
Date: Tue, 04 Nov 2014 17:26:49 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] mfd: qcom-spmi-pmic: Add support for more chips versions
References: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>  <5458EB64.3030203@mm-sol.com> <1415114567.29957.14.camel@mm-sol.com>
In-Reply-To: <1415114567.29957.14.camel@mm-sol.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 05:22 PM, Ivan T. Ivanov wrote:
> 
> On Tue, 2014-11-04 at 17:06 +0200, Stanimir Varbanov wrote:
>> Hi Ivan,
>>
>>
> +
>>> +       switch (subtype) {
>>> +       case PM8941_SUBTYPE:
>>> +       *name = "pm8941";
>>> +       break;
>>
>> The XXX_SUBTYPE seems are continuous why not make it an const array and
>> get the name by index in this array?
>>
> 
> Yep, it _seems_ to be continuous. But, yes. probably using array will
> more compact way to represent this.
> 
> <snip>
> 
>>> @@ -28,11 +144,27 @@ static int pmic_spmi_probe(struct spmi_device *sdev)
>>>  {
>>>         struct device_node *root = sdev->dev.of_node;
>>>         struct regmap *regmap;
>>> +       struct property *prop;
>>> +       int major, minor, ret;
>>> +       char *name, compatible[32];
>>>
>>>         regmap = devm_regmap_init_spmi_ext(sdev, &spmi_regmap_config);
>>>         if (IS_ERR(regmap))
>>>         return PTR_ERR(regmap);
>>>
>>> +       ret = pmic_spmi_read_revid(regmap, &name, &major, &minor);
>>> +       if (!ret) {
>>
>> Are you sure that we want to continue if we can't read the revision id
>> and therefore will not be able to construct properly the compatible
>> property?
>>
> 
> Yes. Driver is working fine even without exact chip version
> appended to compatible string.
> 
>>> +       snprintf(compatible, ARRAY_SIZE(compatible), "qcom,%s-v%d.%d",
>>> +       name, major, minor);
>>> +       prop = kzalloc(sizeof(*prop), GFP_KERNEL);
>>> +       if (prop) {
>>> +       prop->name = kstrdup("compatible", GFP_KERNEL);
>>> +       prop->value = kstrdup(compatible, GFP_KERNEL);
>>> +       prop->length = strlen(prop->value);
>>> +       of_update_property(root, prop);
>>
>> of_update_property can fail, check the returned value.
> 
> Same thing as above, but probably allocated memory at least can be freed.

might be better idea to use devm_kzalloc and devm_kstrdup?

-- 
regards,
Stan
