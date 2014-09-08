Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaIHPQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:16:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53655 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaIHPQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:16:45 -0400
Message-ID: <540DC81F.6000901@ti.com>
Date: Mon, 8 Sep 2014 20:45:43 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Harsh Gupta <harsh.gupta@st.com>,
        Gabriel Fernandez <gabriel.fernandez@linaro.orgm>
Subject: Re: [PATCH v2 7/8] phy: miphy28lp: Add SSC support for PCIE
References: <1409758637-28654-1-git-send-email-gabriel.fernandez@linaro.org> <1409758637-28654-8-git-send-email-gabriel.fernandez@linaro.org>
In-Reply-To: <1409758637-28654-8-git-send-email-gabriel.fernandez@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wednesday 03 September 2014 09:07 PM, Gabriel FERNANDEZ wrote:
> SSC is the technique of modulating the operating frequency of a signal
> slightly to spread its radiated emissions over a range of frequencies.
> This reduction in the maximum emission for a given frequency helps meet
> radiated emission requirements.
> These settings are applicable for PCIE with Internal clock.
> 
> Signed-off-by: Harsh Gupta <harsh.gupta@st.com>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.orgm>
> ---
>  drivers/phy/phy-miphy28lp.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/phy/phy-miphy28lp.c b/drivers/phy/phy-miphy28lp.c
> index b36e737..976fdda 100644
> --- a/drivers/phy/phy-miphy28lp.c
> +++ b/drivers/phy/phy-miphy28lp.c
> @@ -679,6 +679,36 @@ static int miphy28lp_init_sata(struct miphy28lp_phy *miphy_phy)
>  	return miphy_is_ready(miphy_phy);
>  }
>  
> +static void miphy_pcie_tune_ssc(struct miphy28lp_phy *miphy_phy)
> +{
> +	u8 val;
> +
> +	/* Compensate Tx impedance to avoid out of range values */
> +	if (miphy_phy->ssc) {
> +		/*
> +		 * Enable the SSC on PLL for all banks
> +		 * SSC Modulation @ 31 KHz and 4000 ppm modulation amp
> +		 */
> +		val = readb_relaxed(miphy_phy->base + 0x0c);
> +		val |= 0x04;
> +		writeb_relaxed(val, miphy_phy->base + 0x0c);
> +		val = readb_relaxed(miphy_phy->base + 0x0a);
> +		val |= 0x10;
> +		writeb_relaxed(val, miphy_phy->base + 0x0a);

macros for these registers and values is needed. Or else it's difficult to review.
> +
> +		for (val = 0; val < 2; val++) {
> +			writeb_relaxed(val, miphy_phy->base + 0x0f);
> +			writeb_relaxed(0x69, miphy_phy->base + 0xe5);

Do these registers have to be written for every iteration?

Thanks
Kishon
