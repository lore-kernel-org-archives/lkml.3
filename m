Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaHSObK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:31:10 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17884 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaHSObH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:31:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 19 Aug 2014 07:21:31 -0700
Message-ID: <53F35FA7.9010700@nvidia.com>
Date: Tue, 19 Aug 2014 17:31:03 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
CC: <edubezval@gmail.com>, <rui.zhang@intel.com>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <linux-pm@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Juha-Matti Tilli <jtilli@nvidia.com>
Subject: Re: [PATCH v4 4/4] thermal: Add Tegra SOCTHERM thermal management
 driver
References: <20140819140955.GA50475@sandfort.unics.fi>
In-Reply-To: <20140819140955.GA50475@sandfort.unics.fi>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/08/14 17:09, Juha-Matti Tilli wrote:
>> This adds support for the Tegra SOCTHERM thermal sensing and management
>> system found in the Tegra124 system-on-chip. This initial driver supports
>> temperature polling for four thermal zones.
>
> I have several comments about this patch. Overall, the code looks clean,
> way cleaner than NVIDIA's internal soc_therm driver. I adopted your code
> to run on the internal firmware of a Tegra124 SoC. Additionally, I
> tested the code as-is on a Jetson TK1.
>
> My test shows that the temperature readings look sane and do vary with
> load, so the code seems to work. However, I have some concerns about the
> calibration values calculated by this code and the error handling of the
> code.
>
> Originally, I thought the fuse offsets were incorrect but as it turns
> out, the official Linux kernel starts counting the fuses at a different
> location than NVIDIA's internal kernel.
>
> [snip]
>> +static int calculate_shared_calibration(struct tsensor_shared_calibration *r)
>> +{
>> +	u32 val;
>> +	u32 shifted_cp, shifted_ft;
>> +	int err;
>> +
>> +	err = tegra_fuse_readl(FUSE_TSENSOR8_CALIB, &val);
>> +	if (err)
>> +		return err;
>> +	r->base_cp = val & FUSE_TSENSOR8_CALIB_CP_TS_BASE_MASK;
>> +	r->base_ft = (val & FUSE_TSENSOR8_CALIB_FT_TS_BASE_MASK)
>> +		>> FUSE_TSENSOR8_CALIB_FT_TS_BASE_SHIFT;
>> +
>> +	err = tegra_fuse_readl(FUSE_SPARE_REALIGNMENT_REG_0, &val);
>> +	if (err)
>> +		return err;
>> +	shifted_cp = sign_extend32(val, 5);
>> +	val = ((val & FUSE_SPARE_REALIGNMENT_REG_SHIFT_FT_MASK)
>> +		>> FUSE_SPARE_REALIGNMENT_REG_SHIFT_FT_SHIFT);
>> +	shifted_ft = sign_extend32(val, 4);
>> +
>> +	r->actual_temp_cp = 2 * NOMINAL_CALIB_CP_T124 + shifted_cp;
>> +	r->actual_temp_ft = 2 * NOMINAL_CALIB_FT_T124 + shifted_ft;
>> +
>> +	return 0;
>> +}
>> +
>> +static int calculate_tsensor_calibration(
>> +	struct tegra_tsensor *sensor,
>> +	struct tsensor_shared_calibration shared,
>> +	u32 *calib
>> +)
>> +{
>> +	u32 val;
>> +	s32 actual_tsensor_ft, actual_tsensor_cp;
>> +	s32 delta_sens, delta_temp;
>> +	s32 mult, div;
>> +	s16 therma, thermb;
>> +	int err;
>> +
>> +	err = tegra_fuse_readl(sensor->calib_fuse_offset, &val);
>> +	if (err)
>> +		return err;
>> +
>> +	actual_tsensor_cp = (shared.base_cp * 64) + sign_extend32(val, 12);
>> +	val = (val & FUSE_TSENSOR_CALIB_FT_TS_BASE_MASK)
>> +		>> FUSE_TSENSOR_CALIB_FT_TS_BASE_SHIFT;
>> +	actual_tsensor_ft = (shared.base_ft * 32) + sign_extend32(val, 12);
>> +
>> +	delta_sens = actual_tsensor_ft - actual_tsensor_cp;
>> +	delta_temp = shared.actual_temp_ft - shared.actual_temp_cp;
>> +
>> +	mult = t124_tsensor_config.pdiv * t124_tsensor_config.tsample_ate;
>> +	div = t124_tsensor_config.tsample * t124_tsensor_config.pdiv_ate;
>> +
>> +	therma = div_s64((s64) delta_temp * (1LL << 13) * mult,
>> +		(s64) delta_sens * div);
>> +	thermb = div_s64(((s64) actual_tsensor_ft * shared.actual_temp_cp) -
>> +		((s64) actual_tsensor_cp * shared.actual_temp_ft),
>> +		(s64) delta_sens);
>> +
>> +	therma = div_s64((s64) therma * sensor->fuse_corr_alpha,
>> +		(s64) 1000000LL);
>> +	thermb = div_s64((s64) thermb * sensor->fuse_corr_alpha +
>> +		sensor->fuse_corr_beta,
>> +		(s64) 1000000LL);
>> +
>> +	*calib = ((u16)(therma) << SENSOR_CONFIG2_THERMA_SHIFT) |
>> +		((u16)thermb << SENSOR_CONFIG2_THERMB_SHIFT);
>> +
>> +	return 0;
>> +}
>> +
>> +static int enable_tsensor(struct tegra_soctherm *tegra,
>> +			  struct tegra_tsensor *sensor,
>> +			  struct tsensor_shared_calibration shared)
>> +{
>> +	void * __iomem base = tegra->regs + sensor->base;
>> +	unsigned int val;
>> +	u32 calib;
>> +	int err;
>> +
>> +	err = calculate_tsensor_calibration(sensor, shared, &calib);
>> +	if (err)
>> +		return err;
>> +
>> +	val = 0;
>> +	val |= t124_tsensor_config.tall << SENSOR_CONFIG0_TALL_SHIFT;
>> +	writel(val, base + SENSOR_CONFIG0);
>> +
>> +	val = 0;
>> +	val |= (t124_tsensor_config.tsample - 1) <<
>> +		SENSOR_CONFIG1_TSAMPLE_SHIFT;
>> +	val |= t124_tsensor_config.tiddq_en << SENSOR_CONFIG1_TIDDQ_EN_SHIFT;
>> +	val |= t124_tsensor_config.ten_count << SENSOR_CONFIG1_TEN_COUNT_SHIFT;
>> +	val |= SENSOR_CONFIG1_TEMP_ENABLE;
>> +	writel(val, base + SENSOR_CONFIG1);
>> +
>> +	writel(calib, base + SENSOR_CONFIG2);
>> +
>> +	return 0;
>> +}
>
> This code writes different values to SENSOR_CONFIG2 registers than what
> the NVIDIA's internal soc_therm driver does. Because the calibration
> value calculation should be based on the same fuses that NVIDIA's
> internal driver reads, I believe the value calculated and eventually
> written to SENSOR_CONFIG2 should be identical with NVIDIA's internal
> driver. That is not the case now.
>
> I first loaded the NVIDIA's internal soc_therm driver and then loaded
> code adopted from your driver running on Tegra's firmware. Here's a log
> of how the CONFIG2 values are changed by this code to different values
> than NVIDIA's internal soc_therm driver originally sets them to:
>
> CONFIG2: 5b0f813 -> 5c6f7fb
> CONFIG2: 5e8f7cd -> 5fff7b4
> CONFIG2: 5bdf7ce -> 5d3f7b5
> CONFIG2: 596f831 -> 5aaf81a
> CONFIG2: 675f6b5 -> 68cf698
> CONFIG2: 6d6f641 -> 6eff623
> CONFIG2: 641f72b -> 659f710
> CONFIG2: 590f861 -> 5a5f84a
>
> On the left, there's the value set by NVIDIA's internal soc_therm driver
> and on the right, there's the value set by code adopted from your
> driver. My modifications to the code are minor, and I don't think they
> could explain why the CONFIG2 values set are different.

The reason is that the downstream driver uses a function called 
div64_s64_precise to calculate the values. Apparently the results will 
be more accurate, but in my (admittedly brief) testing, the difference 
was somewhat negligible, so I opted for a simpler implementation. The 
precision of the sensors is not very high anyway (only 0.5C).

>
> If you want them, I can supply you the values of the fuses on my
> development board.
>
> The temperature readings look sane and do vary with load, but I think
> they're a bit different than what NVIDIA's internal soc_therm driver
> gives. I'm not entirely sure if the calibration values set by your
> driver or the calibration values set by NVIDIA's internal soc_therm
> driver are correct, but it seems to me that only one of these drivers
> can be correct.

How much do the readings differ in your tests?

>
> The values written to CONFIG1 and CONFIG0 do seem sane.
>
> Since there are divisions being done, some sort of explicit protection
> from divisions by zero should perhaps be considered, although this can
> happen only if the fuses for some reason read all zeroes. I'm not sure
> if that's possible with real hardware.

Even the earliest hardware should have something fused, so pretty much 
impossible, I'd think. Still, I guess I can throw in a check.

>
> Where does this code come from? It does not definitely come from
> NVIDIA's internal soc_therm driver, as it looks entirely different. And
> it calculates different calibration values. If you wrote the code, you
> should consider commenting it since there are a lot of complex
> calculations going on that are not obvious to the reader. For example,
> what do "cp" and "ft" mean? Are they acronyms? If so, they should be
> explained.

The calculation code does come from the downstream kernel; in the 
downstream kernel it's just split between multiple files. At least the 
soctherm driver and the tegra124 fuse code. I have simplified it quite a 
bit when porting over. As for the complex calculations or CP and FT, I 
don't really have a good picture of what they are doing, either.

>
> [snip]
>> +	for (i = 0; i < ARRAY_SIZE(tegra->thermctl_tzs); ++i) {
>> +		struct tegra_thermctl_zone *zone =
>> +			devm_kzalloc(&pdev->dev, sizeof(*zone), GFP_KERNEL);
>> +		if (!zone) {
>> +			err = -ENOMEM;
>
> Shouldn't this one have a --i line like the next IS_ERR block?

Well spotted!

>
>> +			goto unregister_tzs;
>> +		}
>> +
>> +		zone->temp_reg = tegra->regs + thermctl_temp_offsets[i];
>> +		zone->temp_shift = thermctl_temp_shifts[i];
>> +
>> +		tz = thermal_zone_of_sensor_register(
>> +			&pdev->dev, i, zone, tegra_thermctl_get_temp, NULL);
>> +		if (IS_ERR(tz)) {
>> +			err = PTR_ERR(tz);
>> +			dev_err(&pdev->dev, "failed to register sensor: %d\n",
>> +				err);
>> +			--i;
>> +			goto unregister_tzs;
>> +		}
>> +
>> +		tegra->thermctl_tzs[i] = tz;
>> +	}

Thanks,
Mikko
