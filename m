Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab3DVQzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 12:55:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39362 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab3DVQzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 12:55:37 -0400
Message-ID: <51756A21.3020405@ti.com>
Date: Mon, 22 Apr 2013 19:49:37 +0300
From: Taras Kondratiuk <taras@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <rjw@sisk.pl>, <viresh.kumar@linaro.org>,
        <shawn.guo@linaro.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Philip Rakity <prakity@nvidia.com>, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [RFC PATCH 1/2] regulator: core: Add regulator_set_voltage_min()
References: <1366372554-20866-1-git-send-email-taras@ti.com> <1366372554-20866-2-git-send-email-taras@ti.com> <20130422131904.GL30351@opensource.wolfsonmicro.com>
In-Reply-To: <20130422131904.GL30351@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 04:19 PM, Mark Brown wrote:
> On Fri, Apr 19, 2013 at 02:55:53PM +0300, Taras Kondratiuk wrote:
>> Sometimes it is a need to constrain only a minimum voltage
>> and let system constraints to limit maximum.
>> Add a new function regulator_set_voltage_min() for this.
> I don't believe you on this one.  It is going to be a very unusual
> system which has a maximum supply voltage specified at over 4kV (or
> more) which is what INT_MAX will come out as - there will be some
> electrical specs for what voltages can be tolerated sustainably.
Yeah. Sure 4kV is not a real request, but
max will be limited by system constrains.
According to regulator_set_voltage() documentation
system constraints should be set before calling this function,
so I assume I can rely on them. No?

Another possible implementation is below, but prefer initial one.

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e3661c2..28c1be3 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2355,6 +2355,19 @@ out2:
  }
  EXPORT_SYMBOL_GPL(regulator_set_voltage);

+int regulator_set_voltage_min(struct regulator *regulator, int min_uV)
+{
+       struct regulator_dev *rdev = regulator->rdev;
+       int max_uV;
+
+       mutex_lock(&rdev->mutex);
+       max_uV = rdev->constraints->max_uV;
+       mutex_unlock(&rdev->mutex);
+       return regulator_set_voltage(regulator, min_uV, max_uV);
+}
+EXPORT_SYMBOL_GPL(regulator_set_voltage_min);
+
+
  /**
   * regulator_set_voltage_time - get raise/fall time
   * @regulator: regulator source


-- 
BR
Taras Kondratiuk | GlobalLogic

