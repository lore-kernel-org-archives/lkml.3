Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaKLWBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:01:47 -0500
Received: from regular1.263xmail.com ([211.150.99.140]:32799 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaKLWBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:01:43 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: linus.walleij@linaro.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <68ca6633e933a37cbd1a41b3c673e660>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, fzf@rock-chips.com,
        cf@rock-chips.com, caesar.wang@rock-chips.com,
        "jinkun.hong" <jinkun.hong@rock-chips.com>,
        Jack Dai <jack.dai@rock-chips.com>
Subject: [PATCH v11 0/3] ARM: rk3288: Add PM Domain support
Date: Thu, 13 Nov 2014 06:01:27 +0800
Message-Id: <1415829690-20236-1-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Add power domain drivers based on generic power domain for
    Rockchip platform, and support RK3288.

    https://chromium-review.googlesource.com/#/c/220253/9
    This is the GPU driver, add the following information in DT,
    and it can support the PMDOMAIN

gpu: gpu@ffa30000 {
    compatible = "arm,malit764",
                 "arm,malit76x",
                 "arm,malit7xx",
                 "arm,mali-midgard";
    reg = <0xffa30000 0x10000>;
    interrupts = <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>,
                 <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
                 <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
    interrupt-names = "JOB", "MMU", "GPU";
    clocks = <&cru ACLK_GPU>;
    clock-names = "aclk_gpu";
    operating-points = <
                /* KHz uV */
                100000 800000
                200000 850000
                300000 950000
                400000 1000000
                600000 1150000
    >;
    power-domains = <&power RK3288_PD_GPU>;
    status = "disabled";
};

Based on:
    - [PATCH v1 1/4] PM / clock_ops: Add pm_clk_add_clk()
    http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg735599.html

Changes in v11:
    - fix pm_genpd_init(&pd->genpd, NULL, false);

Changes in v10:
    - this switches over domain infos to use masks instead of recomputing
      them each time and also gets rid of custom domain translator and
      uses standard onecell on.
    - fix missing the #include <dt-bindings/power-domain/rk3288.h>
    - remove the notes

Changes in v9:
    - add document decription
    - fix v8 changes as follows:
    - This reconciles the v2 and v7 code so that we power domain have
      lists of clocks they toggle on and off during power transitions and
      independently from power domains clocks we attach clocks to devices
      comprising power domain and prepare them so they are turn on and off
      by runtime PM.
    - add rockchip_pm_add_one_domain() to control domains.
    - add pd_start/pd_stop interface to control clocks
    - add decription for power-doamin node

Changes in v8:
    - document go back to v2
    - This reconciles the v2 and v7 code so that we power domain have
      lists of clocks they toggle on and off during power transitions and
      independently from power domains clocks we attach clocks to devices
      comprising power domain and prepare them so they are turn on and off
      by runtime PM.
    - DTS go back to v2

Changes in v7:
    - Delete unused variables

Changes in v6:
    - delete pmu_lock
    - modify dev_lock using mutex
    - pm_clk_resume(pd->dev) change to pm_clk_resume(ed->dev)
    - pm_clk_suspend(pd->dev) change to pm_clk_suspend(ed->dev)
    - add devm_kfree(pd->dev, de) in rockchip_pm_domain_detach_dev

Changes in v5:
    - delete idle_lock
    - add timeout in rockchip_pmu_set_idle_request()

Changes in v4:
    - use list storage dev

Changes in v3:
    - DT structure has changed
    - change use pm_clk_resume() and pm_clk_suspend()
    - Decomposition power-controller, changed to multiple controller
    (gpu-power-controller, hevc-power-controller)

Changes in v2:
    - move clocks to "optional"
    - remove the "pd->pd.of_node = np"
    - make pd_vio clocks all one entry per line and alphabetize.
    - power: power-controller move back to pinctrl: pinctrl.

Caesar Wang (3):
  dt-bindings: add document of Rockchip power domain
  power-domain: rockchip: add power doamin driver
  ARM: dts: add rk3288 power-domain node

 .../bindings/arm/rockchip/power_domain.txt         |  48 +++
 arch/arm/boot/dts/rk3288.dtsi                      |  66 +++
 arch/arm/mach-rockchip/Kconfig                     |   1 +
 arch/arm/mach-rockchip/Makefile                    |   1 +
 arch/arm/mach-rockchip/pm_domains.c                | 471 +++++++++++++++++++++
 include/dt-bindings/power-domain/rk3288.h          |  11 +
 6 files changed, 598 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/power_domain.txt
 create mode 100644 arch/arm/mach-rockchip/pm_domains.c
 create mode 100644 include/dt-bindings/power-domain/rk3288.h

-- 
1.9.1


