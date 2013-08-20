Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab3HTKWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:22:38 -0400
Received: from 5.mo4.mail-out.ovh.net ([188.165.44.50]:56258 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751214Ab3HTKWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:22:36 -0400
Message-ID: <52134321.8000806@overkiz.com>
Date: Tue, 20 Aug 2013 12:21:21 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Boris BREZILLON <b.brezillon@overkiz.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH v3 00/19] ARM: at91: move to common clk framework
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 4837428951631689756
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrfeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrfeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

Could you take a look at this patch series ?

I'd like to have your opinion on some key points:

- at91 clk dt bindings
- in some clk_prepare (pll clks, main clk) callbacks I make use of 
wait_event to wait for an interrupt.
   Should I do it this way or instead use the cpu_relax function ?
- some clks define clk_prepare but not clk_enable (enabling work is done 
in clk_prepare).
   Is it okay to leave this callback empty and rely on the default 
behaviour (enable count increment) ?
- at91 clk implemetation in its whole


Best Regards,

Boris

On 08/08/2013 06:53, Boris BREZILLON wrote:
> Hello,
>
> This patch series is the 3rd version of the new at91 clock implementation
> (using common clk framework).
>
> Most of the clock provided by the PMC (Power Management Controller) are
> implemented :
> - main clock (main oscillator)
> - pll clocks
> - master clock
> - programmable clocks
> - utmi clock
> - peripheral clocks
> - system clocks
>
> This implementation is only compatible with device tree definition.
> The goal is to define the whole clock tree in the device tree.
>
> Please feel free to comment the dt bindinds.
>
> This patch series is based on linux-next and has been tested on sama5d31ek
> board using device tree. It compiles for other SoCs and both with and
> but it has not been tested (Richard, I did not add your Tested-by because
> a lot of things have changed since v2).
>
> BTW could other people test it on other boards (I only have a kizbox and
> a sama5d31ek dev kit).
>
> Best Regards,
> Boris
>
> Changes since v2:
>   - fix several bugs in clk implementations
>   - drop non-dt boards support
>   - split the series to ease review and tests:
>     * 1 patch series for new clk implementations (this series)
>     * 1 patch series to move each at91 SoC to common clk framework (coming soon)
>   - modify dt-bindings (add atmel,clk- prefix to atmel specific properties)
>   - add clk macros for dt-bindings
>   - add pmc framework (helper function to access pmc registers)
>   - add interrupt support to enable passive wait in clk_prepare functions
>
> Changes since v1:
>   - fix bugs in pll, programmable and system clock implementations
>     (wrong bit position).
>   - add usb clock configuration support (ohci and udc drivers +
>     clk_lookup for non dt boards)
>   - rework of the system clock interfaces (no need to define a parent clock,
>     system clock is a gate with no rate info)
>   - change system, peripheral and programmable clk dt bindings (1 master node
>     and multiple child nodes each defining a system/peripheral or prog clock)
>   - fix bugs in sama5 dt definition
>
> Boris BREZILLON (19):
>    ARM: at91: move at91_pmc.h to include/linux/clk/at91_pmc.h
>    ARM: at91: add Kconfig options for common clk support
>    clk: at91: add PMC base support
>    clk: at91: add PMC macro file for dt definitions
>    clk: at91: add PMC main clock
>    clk: at91: add PMC pll clocks
>    clk: at91: add pll id macros for pll dt bindings
>    clk: at91: add PMC master clock
>    clk: at91: add PMC system clocks
>    ARM: at91/dt: add system clk id definitions in dt-bindings include
>      dir
>    clk: at91: add PMC peripheral clocks
>    clk: at91: add peripheral clk macros for peripheral clk dt bindings
>    clk: at91: add PMC programmable clocks
>    clk: at91: add PMC utmi clock
>    clk: at91: add PMC usb clock
>    clk: at91: add PMC smd clock
>    clk: at91: add PMC clk device tree binding doc.
>    ARM: at91: move pit timer to common clk framework
>    ARM: at91: add new compatible strings for pmc driver
>
>   .../devicetree/bindings/clock/at91-clock.txt       |  312 ++++++++++++
>   arch/arm/mach-at91/Kconfig                         |   44 ++
>   arch/arm/mach-at91/Kconfig.non_dt                  |    6 +
>   arch/arm/mach-at91/Makefile                        |    2 +-
>   arch/arm/mach-at91/at91rm9200.c                    |    2 +-
>   arch/arm/mach-at91/at91sam9260.c                   |    2 +-
>   arch/arm/mach-at91/at91sam9261.c                   |    2 +-
>   arch/arm/mach-at91/at91sam9263.c                   |    2 +-
>   arch/arm/mach-at91/at91sam926x_time.c              |   14 +-
>   arch/arm/mach-at91/at91sam9g45.c                   |    2 +-
>   arch/arm/mach-at91/at91sam9n12.c                   |    2 +-
>   arch/arm/mach-at91/at91sam9rl.c                    |    2 +-
>   arch/arm/mach-at91/at91sam9x5.c                    |    2 +-
>   arch/arm/mach-at91/clock.c                         |    8 +-
>   arch/arm/mach-at91/generic.h                       |    3 +-
>   arch/arm/mach-at91/pm.c                            |    2 +-
>   arch/arm/mach-at91/pm_slowclock.S                  |    2 +-
>   arch/arm/mach-at91/sama5d3.c                       |    2 +-
>   arch/arm/mach-at91/setup.c                         |    8 +-
>   drivers/clk/Makefile                               |    1 +
>   drivers/clk/at91/Makefile                          |   12 +
>   drivers/clk/at91/clk-main.c                        |  171 +++++++
>   drivers/clk/at91/clk-master.c                      |  386 +++++++++++++++
>   drivers/clk/at91/clk-peripheral.c                  |  401 ++++++++++++++++
>   drivers/clk/at91/clk-pll.c                         |  506 ++++++++++++++++++++
>   drivers/clk/at91/clk-plldiv.c                      |  137 ++++++
>   drivers/clk/at91/clk-programmable.c                |  419 ++++++++++++++++
>   drivers/clk/at91/clk-smd.c                         |  171 +++++++
>   drivers/clk/at91/clk-system.c                      |  191 ++++++++
>   drivers/clk/at91/clk-usb.c                         |  323 +++++++++++++
>   drivers/clk/at91/clk-utmi.c                        |  161 +++++++
>   drivers/clk/at91/pmc.c                             |  387 +++++++++++++++
>   drivers/clk/at91/pmc.h                             |  111 +++++
>   drivers/usb/gadget/atmel_usba_udc.c                |    2 +-
>   .../dt-bindings/clk/at91/at91rm9200/clk-system.h   |   16 +
>   .../dt-bindings/clk/at91/at91sam9261/clk-system.h  |   15 +
>   .../clk/at91/at91sam9x5/clk-peripheral.h           |   15 +
>   include/dt-bindings/clk/at91/common/clk-pll.h      |   13 +
>   include/dt-bindings/clk/at91/common/clk-system.h   |   21 +
>   include/dt-bindings/clk/at91/common/pmc.h          |   20 +
>   .../include/mach => include/linux/clk}/at91_pmc.h  |    4 +-
>   41 files changed, 3882 insertions(+), 20 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/clock/at91-clock.txt
>   create mode 100644 drivers/clk/at91/Makefile
>   create mode 100644 drivers/clk/at91/clk-main.c
>   create mode 100644 drivers/clk/at91/clk-master.c
>   create mode 100644 drivers/clk/at91/clk-peripheral.c
>   create mode 100644 drivers/clk/at91/clk-pll.c
>   create mode 100644 drivers/clk/at91/clk-plldiv.c
>   create mode 100644 drivers/clk/at91/clk-programmable.c
>   create mode 100644 drivers/clk/at91/clk-smd.c
>   create mode 100644 drivers/clk/at91/clk-system.c
>   create mode 100644 drivers/clk/at91/clk-usb.c
>   create mode 100644 drivers/clk/at91/clk-utmi.c
>   create mode 100644 drivers/clk/at91/pmc.c
>   create mode 100644 drivers/clk/at91/pmc.h
>   create mode 100644 include/dt-bindings/clk/at91/at91rm9200/clk-system.h
>   create mode 100644 include/dt-bindings/clk/at91/at91sam9261/clk-system.h
>   create mode 100644 include/dt-bindings/clk/at91/at91sam9x5/clk-peripheral.h
>   create mode 100644 include/dt-bindings/clk/at91/common/clk-pll.h
>   create mode 100644 include/dt-bindings/clk/at91/common/clk-system.h
>   create mode 100644 include/dt-bindings/clk/at91/common/pmc.h
>   rename {arch/arm/mach-at91/include/mach => include/linux/clk}/at91_pmc.h (98%)
>

