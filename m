Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbaHVAuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 20:50:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60300 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbaHVAur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 20:50:47 -0400
Message-ID: <a97b7b39f243133f7e7272bfbea09889.squirrel@www.codeaurora.org>
Date: Fri, 22 Aug 2014 00:50:46 -0000
Subject: Re: [PATCH v3] scsi: ufs-msm: add UFS controller support for
 Qualcomm MSM chips
From: subhashj@codeaurora.org
To: ygardi@codeaurora.org
Cc: "Kumar Gala" <galak@codeaurora.org>, "Yaniv Gardi" <ygardi@codeaurora.org>,
        james.bottomley@hansenpartnership.com, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, santoshsy@gmail.com,
        linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org,
        noag@codeaurora.org, draviv@codeaurora.org,
        "Rob Herring" <robh+dt@kernel.org>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Vinayak Holikatti" <vinholikatti@gmail.com>,
        "James E.J. Bottomley" <jbottomley@parallels.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Sujit Reddy Thumma" <sthumma@codeaurora.org>,
        "Sahitya Tummala" <stummala@codeaurora.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Aug 14, 2014, at 9:22 AM, Yaniv Gardi <ygardi@codeaurora.org> wrote:
>>> The files in this change implement the UFS HW (controller & PHY) specific
>>> behavior in Qualcomm MSM chips.
>>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>> ---
>>> Documentation/devicetree/bindings/ufs/ufs-msm.txt  |   37 +
>>> .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |    4 +
>>> drivers/scsi/ufs/Kconfig                           |   12 +
>>> drivers/scsi/ufs/Makefile                          |    4 +
>>> drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.c            |  254 +++++
drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.h            |  216 ++++
drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.c            |  368 +++++++
drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.h            |  735
+++++++++++++
>>> drivers/scsi/ufs/ufs-msm-phy.c                     |  646 ++++++++++++
drivers/scsi/ufs/ufs-msm-phy.h                     |  193 ++++
>> Any reason not to put the phy driver in drivers/phy ?
> Yes. Phy driver introduces a generic phy framework.
> And as a framework it provides with API's, callbacks,
> And data structures.
> I think the right place to have the >implementation< of the ufs-msm-phy
code
> Is under drivers/scsi/ufs as it's more related to ufs than it's related
to
> the framework itself.

I would agree with Kumar that PHY specific platform driver (which uses the
generic PHY framwork) can actually go under drivers/phy/*, if i look at
the 3.17-rc1, there are many platform specific phy drivers under
drivers/phy/.

>>> drivers/scsi/ufs/ufs-msm.c                         | 1105
>>> ++++++++++++++++++++
>>> drivers/scsi/ufs/ufs-msm.h                         |  158 +++
>>> 12 files changed, 3732 insertions(+)
>>> create mode 100644 Documentation/devicetree/bindings/ufs/ufs-msm.txt
create mode 100644 drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.c
>>> create mode 100644 drivers/scsi/ufs/ufs-msm-phy-qmp-20nm.h
>>> create mode 100644 drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.c
>>> create mode 100644 drivers/scsi/ufs/ufs-msm-phy-qmp-28nm.h
>>> create mode 100644 drivers/scsi/ufs/ufs-msm-phy.c
>>> create mode 100644 drivers/scsi/ufs/ufs-msm-phy.h
>>> create mode 100644 drivers/scsi/ufs/ufs-msm.c
>>> create mode 100644 drivers/scsi/ufs/ufs-msm.h
>> Seems like we should spit this into two patches, one for the phy and
one
>> for the UFS driver itself.  Maybe even three, one for the 20nm phy, one
for the 28nm phy, and one for ufs-msm.c,h.
> we could try to split it, but since we didn't split this change into
functional sub-changes, we decided to upload this change as a whole, as
one change without the other wouldn't work anyhow, and they are both
needed for proper functionality.
>>> diff --git a/Documentation/devicetree/bindings/ufs/ufs-msm.txt
b/Documentation/devicetree/bindings/ufs/ufs-msm.txt
>>> new file mode 100644
>>> index 0000000..b5caace
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/ufs/ufs-msm.txt
>> This should probably be bindings/phy/qcom-ufs-phy.txt

If Yaniv also agrees that Qualcomm UFS MSM PHY specific driver should move
under drivers/phy then yes, "ufs-msm.txt" should also move under
bindings/phy/.

Btw, regarding using "qcom-ufs-phy.txt" instead "ufs-msm.txt", i would
agree that we need to add "phy" in file name but not sure we would like to
replace "msm" with "qcom" because we used "msm" prefix/postfix almost
everywhere.



>>> @@ -0,0 +1,37 @@
>>> +* MSM Universal Flash Storage (UFS) PHY
>>> +
>>> +UFSPHY nodes are defined to describe on-chip UFS PHY hardware macro.
+Each UFS PHY node should have its own node.
>>> +
>>> +To bind UFS PHY with UFS host controller, the controller node should
+contain a phandle reference to UFS PHY node.
>>> +
>>> +Required properties:
>>> +- compatible        : compatible list, contains
>>> "qcom,ufs-msm-phy-qmp-28nm"
>>> +                      or "qcom,ufs-msm-phy-qmp-20nm" according to the
relevant
>>> +                      phy in use
>> Do we really need ‘-msm’ in the compat name?

That's the convention we followed for all file names and hence carry
forwarded to compatible name as well. Any specific issues with it?

>>> +- reg               : <registers mapping>
>>> +- #phy-cells         : This property shall be set to 0
>>> +- vdda-phy-supply   : phandle to main PHY supply for analog domain +-
vdda-pll-supply   : phandle to PHY PLL and Power-Gen block power
supply
>>> +
>>> +Optional properties:
>>> +- vdda-phy-max-microamp : specifies max. load that can be drawn from
phy supply
>>> +- vdda-pll-max-microamp : specifies max. load that can be drawn from
pll supply
>>> +
>>> +Example:
>>> +
>>> +	ufsphy1: ufsphy@0xfc597000 {
>>> +		compatible = "qcom,ufs-msm-phy-qmp-28nm";
>>> +		reg = <0xfc597000 0x800>;
>>> +		#phy-cells = <0>;
>>> +		vdda-phy-supply = <&pma8084_l4>;
>>> +		vdda-pll-supply = <&pma8084_l12>;
>>> +		vdda-phy-max-microamp = <50000>;
>>> +		vdda-pll-max-microamp = <1000>;
>>> +	};
>>> +
>>> +	ufshc@0xfc598000 {
>>> +		...
>>> +		phys = <&ufsphy1>;
>>> +	};
>>> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>> index e73a619..378585c 100644
>>> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
>>> @@ -9,6 +9,9 @@ Required properties:
>>> - reg               : <registers mapping>
>>> Optional properties:
>>> +- phys			: phandle to UFS PHY node
>>> +- phy-names		: the string "ufs_msm_phy" when is found in a node,
along
>>> +			  with "phys" attribute, provides phandle to UFS PHY node
>> seems like the phy-names should be more generic like “ufsphy"

Agreed, in facts this "phy-names" property is no longer required. Yaniv,
can you please remove this.

>>> - vcc-supply            : phandle to VCC supply regulator node -
vccq-supply           : phandle to VCCQ supply regulator node -
vccq2-supply          : phandle to VCCQ2 supply regulator node @@
-39,6 +42,7 @@ Example:
>>> 		reg = <0xfc598000 0x800>;
>>> 		interrupts = <0 28 0>;
>>> +		ufs-phy = <&ufsphy>;
>>> 		vcc-supply = <&xxx_reg1>;
>>> 		vcc-supply-1p8;
>>> 		vccq-supply = <&xxx_reg2>;
>>> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig index
6e07b2a..a8259e0 100644
>>> --- a/drivers/scsi/ufs/Kconfig
>>> +++ b/drivers/scsi/ufs/Kconfig
>>> @@ -70,3 +70,15 @@ config SCSI_UFSHCD_PLATFORM
>>> 	If you have a controller with this interface, say Y or M here.
>>> 	  If unsure, say N.
>>> +
>>> +config SCSI_UFS_MSM
>>> +	bool "MSM specific hooks to UFS controller platform driver"
>>> +	depends on SCSI_UFSHCD_PLATFORM && ARCH_MSM
>> This should probably be ARCH_QCOM instead of ARCH_MSM

ok. will check this. Thanks.

>>> +	help
>>> +	  This selects the MSM specific additions to UFSHCD platform driver.
+	  UFS host on MSM needs some vendor specific configuration before +	
 accessing the hardware which includes PHY configuration and vendor +	
 specific registers.
>>> +
>>> +	  Select this if you have UFS controller on MSM chipset.
>>> +	  If unsure, say N.
>> [ snip ]
>> - k
>> --
>> Employee of Qualcomm Innovation Center, Inc.
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted
>> by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




