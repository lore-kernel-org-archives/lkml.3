Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbaCSXNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:13:52 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:55022 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758575AbaCSXNs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:13:48 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(z579eh1039mz98dIc89bh936eI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h2668h906i2673i1155h)
Date: Wed, 19 Mar 2014 16:13:41 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: <linux-pm@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Len Brown <len.brown@intel.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Tomasz Figa <t.figa@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 01/11] base: power: Add generic OF-based power domain
 look-up
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
 <1393862536-9842-2-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1393862536-9842-2-git-send-email-tomasz.figa@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <7e54f23f-1e11-4e17-ad29-13b497d7055a@TX2EHSMHS041.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-03 at 05:02PM +0100, Tomasz Figa wrote:
> This patch introduces generic code to perform power domain look-up using
> device tree and automatically bind devices to their power domains.
> Generic device tree binding is introduced to specify power domains of
> devices in their device tree nodes.
> 
> Backwards compatibility with legacy Samsung-specific power domain
> bindings is provided, but for now the new code is not compiled when
> CONFIG_ARCH_EXYNOS is selected to avoid collision with legacy code. This
> will change as soon as Exynos power domain code gets converted to use
> the generic framework in further patch.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> ---
>  .../devicetree/bindings/power/power_domain.txt     |  51 ++++
>  drivers/base/power/domain.c                        | 298 +++++++++++++++++++++
>  include/linux/pm_domain.h                          |  46 ++++
>  kernel/power/Kconfig                               |   4 +
>  4 files changed, 399 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power/power_domain.txt
> 
> diff --git a/Documentation/devicetree/bindings/power/power_domain.txt b/Documentation/devicetree/bindings/power/power_domain.txt
> new file mode 100644
> index 0000000..93be5d9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power/power_domain.txt
> @@ -0,0 +1,51 @@
> +* Generic power domains
> +
> +System on chip designs are often divided into multiple power domains that
> +can be used for power gating of selected IP blocks for power saving by
> +reduced leakage current.
> +
> +This device tree binding can be used to bind power domain consumer devices
> +with their power domains provided by power domain providers. A power domain
> +provider can be represented by any node in the device tree and can provide
> +one or more power domains. A consumer node can refer to the provider by
> +a phandle and a set of phandle arguments (so called power domain specifier)
> +of length specified by #power-domain-cells property in the power domain
> +provider node.
> +
> +==Power domain providers==
> +
> +Required properties:
> + - #power-domain-cells : Number of cells in a power domain specifier;
> +   Typically 0 for nodes representing a single power domain and 1 for nodes
> +   providing multiple power domains (e.g. power controllers), but can be
> +   any value as specified by device tree binding documentation of particular
> +   provider.
> +
> +Example:
> +
> +	power: power-controller@12340000 {
> +		compatible = "foo,power-controller";
> +		reg = <0x12340000 0x1000>;
> +		#power-domain-cells = <1>;
> +	};
> +
> +The node above defines a power controller that is a power domain provider
> +and expects one cell as its phandle argument.
> +
> +==Power domain consumers==
> +
> +Required properties:
> + - power-domain : A phandle and power domain specifier as defined by bindings
> +                  of power controller specified by phandle.
> +
> +Example:
> +
> +	leaky-device@12350000 {
> +		compatible = "foo,i-leak-current";
> +		reg = <0x12350000 0x1000>;
> +		power-domain = <&power 0>;
> +	};
> +
> +The node above defines a typical power domain consumer device, which is located
> +inside power domain with index 0 of power controller represented by node with
> +label "power".

Does this allow nesting of power domains? E.g. you have a PD which is
represented by some programmable power supply, and within this domain
smaller islands/domains that can be gated independently.

	Thanks,
	Sören


