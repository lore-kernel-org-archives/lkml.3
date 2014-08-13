Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaHMHx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:53:59 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:42286 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaHMHx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:53:58 -0400
Date: Wed, 13 Aug 2014 09:53:54 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: swarren@wwwdotorg.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: tegra: Add thermal reset (thermtrip) support to
 PMC
Message-ID: <20140813075353.GA7735@ulmo>
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
 <1407226380-747-4-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <1407226380-747-4-git-send-email-mperttunen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 05, 2014 at 11:13:00AM +0300, Mikko Perttunen wrote:
> This adds a device tree controlled option to enable PMC-based
> thermal reset in overheating situations. Thermtrip is supported on
> Tegra114 and Tegra124. The thermal reset only works when the thermal

The binding updates in patch 1/3 say that Tegra30 supports thermtrip as
well.

> +void tegra_pmc_init_thermal_reset(struct device_node *np)

It would be good for this to take a struct device * so that dev_*() can
be used instead of pr_*().

> +{
> +	u32 pmu_i2c_addr, i2c_ctrl_id, reg_addr, reg_data, pinmux;
> +	bool pmu_16bit_ops;
> +	u32 val, checksum;

Nit: All other register accesses use "value" instead of "val" as the
name for this variable.

> +	const struct of_device_id *match = of_match_node(tegra_pmc_match, np);
> +	const struct tegra_pmc_soc *data = match->data;
> +
> +	if (!data->has_thermal_reset)
> +		return;
> +
> +	pmu_16bit_ops =
> +		of_property_read_bool(np, "nvidia,thermtrip-pmu-16bit-ops");

The formatting here (and below) is weird. I think this could be made
more readable by shortening both property name and/or variable name:

	pmu_16bit = of_property_read_bool(np, "nvidia,thermtrip-pmu-16bit");

And similarily for below.

> +	if (of_property_read_u32(
> +		np, "nvidia,thermtrip-pmu-i2c-addr", &pmu_i2c_addr))
> +		goto disabled;
> +	if (of_property_read_u32(
> +		np, "nvidia,thermtrip-i2c-controller", &i2c_ctrl_id))
> +		goto disabled;
> +	if (of_property_read_u32(
> +		np, "nvidia,thermtrip-reg-addr", &reg_addr))
> +		goto disabled;
> +	if (of_property_read_u32(
> +		np, "nvidia,thermtrip-reg-data", &reg_data))
> +		goto disabled;
> +	if (of_property_read_u32(
> +		np, "nvidia,thermtrip-pinmux", &pinmux))
> +		pinmux = 0;
> +
> +	val = tegra_pmc_readl(PMC_SENSOR_CTRL);
> +	val |= PMC_SENSOR_CTRL_SCRATCH_WRITE | PMC_SENSOR_CTRL_ENABLE_RST;
> +	tegra_pmc_writel(val, PMC_SENSOR_CTRL);

It's not immediately clear to me what this does (therefore it would be
good to annotate it with a comment), but if this enables thermal
tripping, shouldn't this be done *after* the registers below have been
set up?

> +
> +	val = (reg_data << PMC_SCRATCH54_DATA_SHIFT) |
> +	      (reg_addr << PMC_SCRATCH54_ADDR_SHIFT);
> +	tegra_pmc_writel(val, PMC_SCRATCH54);
> +
> +	val = 0;
> +	val |= PMC_SCRATCH55_RESET_TEGRA;
> +	val |= i2c_ctrl_id << PMC_SCRATCH55_CNTRL_ID_SHIFT;
> +	val |= pinmux << PMC_SCRATCH55_PINMUX_SHIFT;
> +	if (pmu_16bit_ops)
> +		val |= PMC_SCRATCH55_16BITOP;
> +	val |= pmu_i2c_addr << PMC_SCRATCH55_I2CSLV1_SHIFT;
> +
> +	checksum = reg_addr + reg_data + (val & 0xFF) + ((val >> 8) & 0xFF) +
> +		((val >> 24) & 0xFF);
> +	checksum &= 0xFF;

I'd prefer lower-case hexadecimals. Also, what about bits 23:16? Are
they not needed for the checksum? Again, a comment may help to explain
this.

> +	checksum = 0x100 - checksum;
> +
> +	val |= checksum << PMC_SCRATCH55_CHECKSUM_SHIFT;
> +
> +	tegra_pmc_writel(val, PMC_SCRATCH55);
> +
> +	pr_info("Tegra: PMC thermal reset enabled\n");
> +
> +	return;
> +
> +disabled:
> +	pr_warn("Tegra: PMC thermal reset disabled\n");

You're not giving anyone a clue about what went wrong, so when they see
this warning they don't know what to do about it. Maybe all paths
leading here should have a more specific warning message themselves.

Thierry

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6xmRAAoJEN0jrNd/PrOhZ9gP/1PwqLDIC1tGq6x+gPItQPCd
og6j5kjobiqSCJeLZeg4FiXslRexEipIZCjvKMSvgnwuVb0EYev4FC1fVriCw/dD
kJkiT4P1qgtxyy348C8yxEByYnjaTUsg7L9yM9x7odLIEvibYCxk3F9at/CxyOL4
hxwSLhrsb8UEdU+aK0o0Z1ce8xNR8mlq0C1MEhNkxvzSlk9gLRBOMC1OZIYv2RvK
A/sjVHxR5U2ui4fMzSsgk+yFzsxHS5YoD08CJiyAeLxNPTCp2y/+X/LQ2ns5+nS2
9T9dGMXHZ4maF1AZiL1Ea7nIr+VnPZHYoasJGdN0MsCwVLIJ6YC93zSGVQN2X2rs
Ze82sIqcV9xZ4qB8JpE27WD3/XXhPhzcA1j4YVj07xuXijqOoKo1O3ZQ33rIOiUS
CC/T8FGB+evy+1agotQnItHlnxMEVA+c9I3uL5azgZpaKDklMqI4/pML1c2cZd6Q
ntc+IsqmDCX9gfoUo/TM52ZhZU5nLrrQOXq+oBt0Ki/wvJOegq5eyGMHK4BJZqNf
DVL7iBqpIS8i+cF+zg6bnbvI11TafXmqjhy7Z0+gRiqWguUTSeR//Pc/NOy+lcrf
Dw3cNf4TFwbT064x5083EiIhQDTZdz57mu5rbA87sIApP+iNdimJmLx0PO/a77gi
bmU//xQ0FzuKN6lQAHws
=OBSZ
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
