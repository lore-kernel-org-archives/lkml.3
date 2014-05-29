Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbaE2VDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:03:44 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:59984 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397AbaE2VDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:03:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140528165529.GC5099@sirena.org.uk>
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1401211721-19712-4-git-send-email-bjorn.andersson@sonymobile.com>
	<20140528165529.GC5099@sirena.org.uk>
Date: Thu, 29 May 2014 14:03:40 -0700
Message-ID: <CAJAp7OgY-99jRqvBOPbkj=Nrt7vW=0Ae+Xvf3J7JrDS1eoigWw@mail.gmail.com>
Subject: Re: [PATCH 3/3] regulator: qcom-rpm: Regulator driver for the
 Qualcomm RPM
From: Bjorn Andersson <bjorn@kryo.se>
To: Mark Brown <broonie@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 9:55 AM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, May 27, 2014 at 10:28:41AM -0700, Bjorn Andersson wrote:
>
>> +static int rpm_reg_set_voltage(struct regulator_dev *rdev,
>> +                            int min_uV, int max_uV,
>> +                            unsigned *selector)
>> +{
>> +     struct qcom_rpm_reg *vreg = rdev_get_drvdata(rdev);
>> +     const struct rpm_reg_parts *parts = vreg->parts;
>> +     const struct request_member *req;
>> +     int ret = 0;
>> +     int sel;
>> +     int val;
>> +     int uV;
>> +
>> +     dev_dbg(vreg->dev, "set_voltage(%d, %d)\n", min_uV, max_uV);
>> +
>> +     if (parts->uV.mask == 0 && parts->mV.mask == 0)
>> +             return -EINVAL;
>> +
>> +     /*
>> +      * Snap to the voltage to a supported level.
>> +      */
>
> What is "snapping" a voltage?
>

I pass the requested voltage to the RPM, but it's only allowed to have valid
values, so I need to "clamp"/"snap"/"round" the voltage to a valid number.

>> +     sel = regulator_map_voltage_linear_range(rdev, min_uV, max_uV);
>
> Don't open code mapping the voltage, just implement set_voltage_sel().
>

I used ot open code this part, but changed it to
regulator_map_voltage_linear_range once I had implemented list_voltages. But as
you say I should be able to replace the first half of my set_voltage with
set_voltage_sel; and then do the transition from sel to requested voltage and
send that over.

[...]

>> +     mutex_lock(&vreg->lock);
>> +     if (parts->uV.mask)
>> +             req = &parts->uV;
>> +     else if (parts->mV.mask)
>> +             req = &parts->mV;
>> +     else
>> +             req = &parts->enable_state;
>
> Just implement separate operations for the regulators with different
> register definitions.  It's going to simplify the code.
>

Currently I can use e.g. ldo_ops for all the different ldos, if I split this I
need to split the ops as well. So it will for sure be more code, but I will
give it a spin and see how it looks like.

>> +static int rpm_reg_set_mode(struct regulator_dev *rdev, unsigned int mode)
>> +{
>> +     struct qcom_rpm_reg *vreg = rdev_get_drvdata(rdev);
>> +     const struct rpm_reg_parts *parts = vreg->parts;
>> +     int max_mA = parts->ip.mask >> parts->ip.shift;
>> +     int load_mA;
>> +     int ret;
>> +
>> +     if (mode == REGULATOR_MODE_IDLE)
>> +             load_mA = vreg->idle_uA / 1000;
>> +     else
>> +             load_mA = vreg->normal_uA / 1000;
>> +
>> +     if (load_mA > max_mA)
>> +             load_mA = max_mA;
>> +
>> +     mutex_lock(&vreg->lock);
>> +     ret = rpm_reg_write(vreg, &parts->ip, load_mA);
>> +     if (!ret)
>> +             vreg->mode = mode;
>> +     mutex_unlock(&vreg->lock);
>
> I'm not entirely sure what this is intended to do.  It looks like it's
> doing something to do with current limits but it's a set_mode().  Some
> documentation might help.  It should also be implementing only specific
> modes and rejecting unsupported modes, if we do the same operation to
> the device for two different modes that seems wrong.
>

The hardware in this case is a "pmic" shared by all cpus in the system, so when
we set the voltage, state or load of a regulator we merely case a vote. For
voltage and state this is not an issue, but for load the value that's
interesting for the "pmic" is the sum of the votes; i.e. the sum of the loads
from all systems on a single regulator.

What the code does here is to follow the hack found at codeaurora, that upon
get_optimum_mode we guess that the client will call get_optimum_mode followed
my set_mode. We keep the track of what load was last requested and use that in
our vote.


One alternative might be to use "force-mode" to actually set the mode of the
regulator, but I will need to run that by the Qualcomm guys to get an answer if
that would work (as it's not used by codeaurora).

>> +static unsigned int rpm_reg_get_optimum_mode(struct regulator_dev *rdev,
>> +                                          int input_uV,
>> +                                          int output_uV,
>> +                                          int load_uA)
>> +{
>> +     struct qcom_rpm_reg *vreg = rdev_get_drvdata(rdev);
>> +
>> +     load_uA += vreg->load_bias_uA;
>> +
>> +     if (load_uA < vreg->hpm_threshold_uA) {
>> +             vreg->idle_uA = load_uA;
>> +             return REGULATOR_MODE_IDLE;
>> +     } else {
>> +             vreg->normal_uA = load_uA;
>> +             return REGULATOR_MODE_NORMAL;
>> +     }
>> +}
>
> This looks very broken - why are we storing anything here?  What is the
> stored value supposed to do?
>

See above.

>> +     if (vreg->parts->ip.mask) {
>> +             initdata->constraints.valid_ops_mask |= REGULATOR_CHANGE_DRMS;
>> +             initdata->constraints.valid_ops_mask |= REGULATOR_CHANGE_MODE;
>> +             initdata->constraints.valid_modes_mask |= REGULATOR_MODE_NORMAL;
>> +             initdata->constraints.valid_modes_mask |= REGULATOR_MODE_IDLE;
>
> No, this is just plain broken.  Constraints are set by the *board*, you
> don't know if these settings are safe on any given board.
>

I can see that these are coming from board files, but I didn't find any example
of how these are supposed to be set when using DT only.

What's happening here is that given what compatible you use, different "parts"
will be selected and based on that this code will or will not be executed;
hence this is defined by what compatible you're using.

But this is of course not obvious, so unless I've missed something I can clean
this up slightly and make the connection to compatible more obvious. Okay?

>> +static int __init rpm_reg_init(void)
>> +{
>> +     return platform_driver_register(&rpm_reg_driver);
>> +}
>> +arch_initcall(rpm_reg_init);
>> +
>> +static void __exit rpm_reg_exit(void)
>> +{
>> +     platform_driver_unregister(&rpm_reg_driver);
>> +}
>> +module_exit(rpm_reg_exit)
>
> module_platform_driver() or if you must bodge the init order at least
> use subsys_initcall() like everyone else.

Okay

Thanks for the review!

Regards,
Bjorn
