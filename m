Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaJMIQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:16:11 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:54125 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbaJMIQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:16:08 -0400
MIME-Version: 1.0
In-Reply-To: <15685.1412018368@turing-police.cc.vt.edu>
References: <1411721657-9924-1-git-send-email-gabriel.fernandez@linaro.org>
	<1411721657-9924-7-git-send-email-gabriel.fernandez@linaro.org>
	<15685.1412018368@turing-police.cc.vt.edu>
Date: Mon, 13 Oct 2014 10:16:06 +0200
Message-ID: <CAG374jBJcX00S4nSugWXaUxAQV3Bwp+OxY0c2GJ-+rskzDzpGw@mail.gmail.com>
Subject: Re: [PATCH v3 6/8] phy: miphy28lp: Add SSC support for PCIE
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Valdis.Kletnieks@vt.edu
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>, Harsh Gupta <harsh.gupta@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Valdis,
Thanks for your remark.

Concerning multiple writing in MIPHY_PLL_SBR_1, the writing of the
first 0 it's to be sure there is no previous request.
Then we take account new setting by writing 0x02.
And then we make it 0 to make sure there is no other pending requests.

I added comments and macro to be more clear (see the code below).


Hi Kishon,

Do you want a new patch set (v4),  or i wait other remarks from you ?


    for (val = 0; val < 2; val++) {
        writeb_relaxed(val, miphy_phy->base + MIPHY_CONF);

        /* Validate Step component */
        writeb_relaxed(0x69, miphy_phy->base + MIPHY_PLL_SBR_3);
        writeb_relaxed(0x21, miphy_phy->base + MIPHY_PLL_SBR_4);

        /* Validate Period component */
        writeb_relaxed(0x3c, miphy_phy->base + MIPHY_PLL_SBR_2);
        writeb_relaxed(0x21, miphy_phy->base + MIPHY_PLL_SBR_4);

        /* Clear any previous request */
        writeb_relaxed(0x00, miphy_phy->base + MIPHY_PLL_SBR_1);

        /* requests the PLL to take in account new parameters */
        writeb_relaxed(SET_NEW_CHANGE, base + MIPHY_PLL_SBR_1);

        /* To be sure there is no other pending requests */
        writeb_relaxed(0x00, miphy_phy->base + MIPHY_PLL_SBR_1);
    }


Best regards

Gabriel.


On 29 September 2014 21:19,  <Valdis.Kletnieks@vt.edu> wrote:
> On Fri, 26 Sep 2014 10:54:15 +0200, Gabriel FERNANDEZ said:
>> SSC is the technique of modulating the operating frequency of a signal
>> slightly to spread its radiated emissions over a range of frequencies.
>> This reduction in the maximum emission for a given frequency helps meet
>> radiated emission requirements.
>> These settings are applicable for PCIE with Internal clock.
>
>> +             writeb_relaxed(0x69, miphy_phy->base + MIPHY_PLL_SBR_3);
>> +             writeb_relaxed(0x21, miphy_phy->base + MIPHY_PLL_SBR_4);
>> +             writeb_relaxed(0x3c, miphy_phy->base + MIPHY_PLL_SBR_2);
>> +             writeb_relaxed(0x21, miphy_phy->base + MIPHY_PLL_SBR_4);
>> +             writeb_relaxed(0x00, miphy_phy->base + MIPHY_PLL_SBR_1);
>> +             writeb_relaxed(0x02, miphy_phy->base + MIPHY_PLL_SBR_1);
>> +             writeb_relaxed(0x00, miphy_phy->base + MIPHY_PLL_SBR_1);
>
> I'd feel a lot better about all these magic numbers (and the triple write
> to SBR_1) if the Changelog or something referenced where they came from....
