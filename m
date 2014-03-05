Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaCEHe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:34:57 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65459 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbaCEHez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:34:55 -0500
Date: Wed, 5 Mar 2014 07:34:22 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 1/4] phy: miphy365x: Add Device Tree bindings for the
 MiPHY365x
Message-ID: <20140305073422.GD20016@e106331-lin.cambridge.arm.com>
References: <1392377036-12816-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392377036-12816-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 11:23:53AM +0000, Lee Jones wrote:
> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> devices. It has 2 ports which it can use for either; both SATA, both
> PCIe or one of each in any configuration.
> 
> Cc: devicetree@vger.kernel.org
> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  .../devicetree/bindings/phy/phy-miphy365x.txt      | 54 ++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> 
> diff --git a/Documentation/devicetree/bindings/phy/phy-miphy365x.txt b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> new file mode 100644
> index 0000000..96f269f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> @@ -0,0 +1,54 @@
> +STMicroelectronics STi MIPHY365x PHY binding
> +============================================
> +
> +This binding describes a miphy device that is used to control PHY hardware
> +for SATA and PCIe.
> +
> +Required properties:
> +- compatible: Should be "st,miphy365x-phy"
> +- #phy-cells: Should be 2 (See second example)
> +		First cell is the port number; MIPHY_PORT_{0,1}
> +		Second cell is device type; MIPHY_TYPE_{SATA,PCI}

Either this should refer to the header file, or specific values should
be given in the binding document.

> +- reg:	      Address and length of the register set for the device
> +- reg-names:  The names of the register addresses corresponding to the
> +	      registers filled in "reg"
> +		Options are; sata{0,1} and pcie{0,1} (See first example)

How about something like:

- reg: a list of offset + length pairs, one for each entry in reg-names
- reg-names: should contain some of:
  * "sata0" for ...
  * "sata1" for ...
  * "pcie0" for ...
  * "pcie1" for ...

Where ... might just be "the sata port 0 registers"

> +- st,syscfg : Should be a phandle of the system configuration register group
> +	      which contain the SATA, PCIe mode setting bits

I'll assume this is well-defined by some other binding.

> +
> +Optional properties:
> +- st,sata-gen	     : Generation of locally attached SATA IP. Expected values
> +		       are {1,2,3). If not supplied generation 1 hardware will
> +		       be expected
> +- st,pcie-tx-pol-inv : Bool property to invert the polarity PCIe Tx (Txn/Txp)
> +- st,sata-tx-pol-inv : Bool property to invert the polarity SATA Tx (Txn/Txp)

It might just be me, but the phrase "invert the polarity {SATA,PCIe} Tx"
sounds odd. What exactly is being inverted?

> +
> +Example:
> +
> +	miphy365x_phy: miphy365x@0 {
> +		compatible = "st,miphy365x-phy";
> +		#phy-cells = <2>;
> +		reg =	<0xfe382000 0x100>,
> +			<0xfe38a000 0x100>,
> +			<0xfe394000 0x100>,
> +			<0xfe804000 0x100>;
> +		reg-names = "sata0", "sata1", "pcie0", "pcie1";
> +		st,syscfg= <&syscfg_rear>;

Nit: missing space before '='.

> +	};
> +
> +Specifying phy control of devices
> +=================================
> +
> +Device nodes should specify the configuration required in their "phys"
> +property, containing a phandle to the miphy device node, a port number
> +and a device type.
> +
> +Example:
> +
> +#include <dt-bindings/phy/phy-miphy365x.h>
> +
> +	sata0: sata@fe380000 {
> +		...
> +		phys	  = <&miphy365x_phy MIPHY_PORT_0 MIPHY_TYPE_SATA>;
> +		...
> +	};

Is there not a generic phy binding we can point to? It seems a bit
redundant to do this in each phy binding.

Cheers,
Mark.
