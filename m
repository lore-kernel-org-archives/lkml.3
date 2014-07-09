Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaGIOa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:30:27 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:53370 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbaGIOa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:30:26 -0400
MIME-Version: 1.0
In-Reply-To: <1404906074-31992-2-git-send-email-lee.jones@linaro.org>
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
	<1404906074-31992-2-git-send-email-lee.jones@linaro.org>
Date: Wed, 9 Jul 2014 16:30:25 +0200
Message-ID: <CAG374jBLq8YShOakBJtf2U47wuKGYNM7vSTn4PjzHsvjaYjmNQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] phy: miphy365x: Add Device Tree bindings for the MiPHY365x
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon <kishon@ti.com>, "kernel@stlinux.com" <kernel@stlinux.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee

One question below,

On 9 July 2014 13:41, Lee Jones <lee.jones@linaro.org> wrote:
> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> devices. It has 2 ports which it can use for either; both SATA, both
> PCIe or one of each in any configuration.
>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  .../devicetree/bindings/phy/phy-miphy365x.txt      | 76 ++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy365x.txt
>
> diff --git a/Documentation/devicetree/bindings/phy/phy-miphy365x.txt b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> new file mode 100644
> index 0000000..7337ac2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
> @@ -0,0 +1,76 @@
> +STMicroelectronics STi MIPHY365x PHY binding
> +============================================
> +
> +This binding describes a miphy device that is used to control PHY hardware
> +for SATA and PCIe.
> +
> +Required properties (controller (parent) node):
> +- compatible    : Should be "st,miphy365x-phy"
> +- st,syscfg     : Should be a phandle of the system configuration register group
> +                 which contain the SATA, PCIe mode setting bits
> +
> +Required nodes :  A sub-node is required for each channel the controller
> +                  provides. Address range information including the usual
> +                  'reg' and 'reg-names' properties are used inside these
> +                  nodes to describe the controller's topology. These nodes
> +                  are translated by the driver's .xlate() function.
> +
> +Required properties (port (child) node):
> +- #phy-cells   : Should be 1 (See second example)
> +                 Cell after port phandle is device type from:
> +                       - MIPHY_TYPE_SATA
> +                       - MIPHY_TYPE_PCI
> +- reg          : Address and length of register sets for each device in
> +                 "reg-names"
> +- reg-names     : The names of the register addresses corresponding to the
> +                 registers filled in "reg":
> +                       - sata:   For SATA devices
> +                       - pcie:   For PCIe devices
> +                       - syscfg: To specify the syscfg based config register
> +
> +Optional properties (port (child) node):
> +- st,sata-gen       :  Generation of locally attached SATA IP. Expected values
> +                       are {1,2,3). If not supplied generation 1 hardware will
> +                       be expected
> +- st,pcie-tx-pol-inv : Bool property to invert the polarity PCIe Tx (Txn/Txp)
> +- st,sata-tx-pol-inv : Bool property to invert the polarity SATA Tx (Txn/Txp)
> +
> +Example:
> +
> +       miphy365x_phy: miphy365x@fe382000 {
> +               compatible      = "st,miphy365x-phy";
> +               st,syscfg       = <&syscfg_rear>;
> +               #address-cells  = <1>;
> +               #size-cells     = <1>;
> +               ranges;
> +
> +               phy_port0: port@fe382000 {
> +                       reg = <0xfe382000 0x100>, <0xfe394000 0x100>, <0x824 0x4>;
> +                       reg-names = "sata", "pcie", "syscfg";
> +                       #phy-cells = <1>;
> +                       st,sata-gen = <3>;
> +               };
> +
> +               phy_port1: port@fe38a000 {
> +                       reg = <0xfe38a000 0x100>, <0xfe804000 0x100>, <0x828 0x4>;;
> +                       reg-names = "sata", "pcie", "syscfg";
> +                       #phy-cells = <1>;
> +                       st,pcie-tx-pol-inv;
> +               };
> +       };
> +
> +Specifying phy control of devices
> +=================================
> +
> +Device nodes should specify the configuration required in their "phys"
> +property, containing a phandle to the phy port node and a device type.
> +
> +Example:
> +
> +#include <dt-bindings/phy/phy-miphy365x.h>
> +
> +       sata0: sata@fe380000 {
> +               ...
> +               phys      = <&miphy365x_phy MIPHY_TYPE_SATA>;
> +               ...

In this example you select the type (SATA) but I don't understand how
do you select
the port (phy_port0 or phy_port1)

BR
Gabriel

> +       };
> --
> 1.8.3.2
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
