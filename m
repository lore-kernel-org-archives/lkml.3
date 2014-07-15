Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbaGOUXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:23:47 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15951 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701AbaGOUXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:23:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Jul 2014 13:12:27 -0700
Message-ID: <53C58DCB.90502@nvidia.com>
Date: Tue, 15 Jul 2014 23:23:39 +0300
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Thierry Reding <thierry.reding@gmail.com>
CC: Andrew Bresticker <abrestic@chromium.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 01/13] clk: tegra: Add binding for the Tegra124 DFLL clocksource
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com> <1405028569-14253-2-git-send-email-ttynkkynen@nvidia.com> <CAL1qeaFF0ZpUFovxTuLXrBPRg2Lbf-754Z=ztD5HFZPbfnDsAw@mail.gmail.com> <53C01558.3090607@nvidia.com> <CAL1qeaHETQ7kSGNjPiwi_9WNMtr9qZp0KwjZCCxY29+_N4AcuA@mail.gmail.com> <53C01D17.2050906@nvidia.com> <20140714083854.GO2081@ulmo> <20140714091233.GC6800@sirena.org.uk> <20140714092434.GA9755@ulmo> <20140714102203.GD6800@sirena.org.uk>
In-Reply-To: <20140714102203.GD6800@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/07/14 13:22, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Mon, Jul 14, 2014 at 11:24:35AM +0200, Thierry Reding wrote:
>> On Mon, Jul 14, 2014 at 10:12:33AM +0100, Mark Brown wrote:
> 
>>> The selector value is opaque, it's entirely up to the driver to define
>>> it.  If you could tell me what "this" is I might be able to advise on
>>> how to do it.
> 
>> Tegra124 (and later, also some earlier variants) have this DFLL clock
>> that can program a PMIC automatically depending on the CPU frequency.
>> This DT binding did propose putting this into device tree as a table of
>> <frequency value> pairs where the frequency corresponds to the CPU
>> frequency and the value is the register value to be programmed into the
>> PMIC by the DFLL hardware (there are two additional properties to define
>> the slave address and the register offset).
> 
>> Andrew proposed that this table could instead be built by using
>> regulator_list_voltage() instead. However, due to the fact that the DFLL
>> hardware needs to know the immediate value to write into a register, the
>> requirement would be for a 1:1 mapping between selector and register
>> value. Given that the API needs to cover the general case I don't see
>> how it could practically ensure this.
> 
> Well, if you're going to do that you've already created a private API
> between the regulator driver and the device since you're assuming that
> the device is controlled only by register writes to a single register
> bitfield which isn't always the case.
> 
> As with all these things it would also be better to extend the regulator
> API so that users like this can discover the register address and so on
> too rather than having to replicate that information in the device tree.
> No sense in having to specify this information multiple times.
> 

That sounds indeed useful for this case. How'd the following interface
sound for the register offset / selector-to-register-value conversion?
The I2C address would be a bit trickier to get as it would touch the
regmap stuff as well, but perhaps it would be a good idea to have a
phandle to the I2C device itself, and then parse the reg field for
the address.

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c563d93..a5efb96 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2228,6 +2228,63 @@ int regulator_list_voltage(struct regulator *regulator, unsigned selector)
 EXPORT_SYMBOL_GPL(regulator_list_voltage);

 /**
+ * regulator_get_hardware_vsel_register - get the HW voltage selector register
+ * @regulator: regulator source
+ * @vsel_reg: voltage selector register, output parameter
+ * @vsel_mask: mask for voltage selector bitfield, output parameter
+ *
+ * Returns the hardware register offset and bitmask used for setting the
+ * regulator voltage. This might be useful when configuring voltage-scaling
+ * hardware or firmware that can make I2C requests behind the kernel's back,
+ * for example.
+ *
+ * On success, the output parameters @vsel_reg and @vsel_mask are filled in
+ * and 0 is returned, otherwise a negative errno is returned.
+ */
+int regulator_get_hardware_vsel_register(struct regulator *regulator,
+					 unsigned *vsel_reg,
+					 unsigned *vsel_mask)
+{
+	struct regulator_dev	*rdev = regulator->rdev;
+	struct regulator_ops	*ops = rdev->desc->ops;
+
+	if (ops->set_voltage_sel != regulator_set_voltage_sel_regmap)
+		return -EOPNOTSUPP;
+
+	 *vsel_reg = rdev->desc->vsel_reg;
+	 *vsel_mask = rdev->desc->vsel_mask;
+
+	 return 0;
+}
+EXPORT_SYMBOL_GPL(regulator_get_hardware_vsel_register);
+
+/**
+ * regulator_list_hardware_vsel - get the HW-specific register value for a selector
+ * @regulator: regulator source
+ * @selector: identify voltage to list
+ *
+ * Converts the selector to a hardware-specific voltage selector that can be
+ * directly written to the regulator registers. The address of the voltage
+ * register can be determined by calling @regulator_get_hardware_vsel_register.
+ *
+ * On error a negative errno is returned.
+ */
+int regulator_list_hardware_vsel(struct regulator *regulator,
+				 unsigned selector)
+{
+	struct regulator_dev	*rdev = regulator->rdev;
+	struct regulator_ops	*ops = rdev->desc->ops;
+
+	if (selector >= rdev->desc->n_voltages)
+		return -EINVAL;
+	if (ops->set_voltage_sel != regulator_set_voltage_sel_regmap)
+		return -EOPNOTSUPP;
+
+	return selector;
+}
+EXPORT_SYMBOL_GPL(regulator_list_hardware_vsel);
+
+/**
  * regulator_get_linear_step - return the voltage step size between VSEL values
  * @regulator: regulator source
  *
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 14ec18d..fe4cdb2 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -215,6 +215,12 @@ int regulator_set_optimum_mode(struct regulator *regulator, int load_uA);

 int regulator_allow_bypass(struct regulator *regulator, bool allow);

+int regulator_get_hardware_vsel_register(struct regulator *regulator,
+					 unsigned *vsel_reg,
+					 unsigned *vsel_mask);
+int regulator_list_hardware_vsel(struct regulator *regulator,
+				 unsigned selector);
+
 /* regulator notifier block */
 int regulator_register_notifier(struct regulator *regulator,
 			      struct notifier_block *nb);

-- 
nvpublic
