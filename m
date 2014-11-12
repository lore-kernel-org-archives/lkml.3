Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaKLFDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 00:03:46 -0500
Received: from regular1.263xmail.com ([211.150.99.132]:43332 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaKLFDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 00:03:40 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <ff7106486335a7bf5682d0e6d67af49d>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com
Cc: zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dmitry.torokhov@gmail.com, huangtao@rock-chips.com,
        fzf@rock-chips.com, caesar.wang@rock-chips.com
Subject: [PATCH v18 0/5] Rockchip soc thermal driver
Date: Wed, 12 Nov 2014 13:02:37 +0800
Message-Id: <1415768562-9155-1-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series patchs tested on rk3288 SDK board and pinky-v1,v2 board.
I believe the driver can be used on the rk3288-evb board.

Add this driver, The system will shutdown when
the thermal temperture over 100C.If for some reason we are unable to
shut it down in orderly fashion (kernel is stuck holding a lock or similar)
then hardware will reset it.

This series patchs depend on patch by Mikko Perttunen adding support for
hardware-supported trip points. It allows us to reduce polling frequency
while still being able to react when we cross the tripping point.

See https://lkml.org/lkml/2014/6/27/76


otherwise thermal_zone_of_sensor_register() will compile error,
e.g:

CC [M]  drivers/thermal/rockchip_thermal.o
  drivers/thermal/rockchip_thermal.c: In function
  `rockchip_thermal_register_sensor':
  drivers/thermal/rockchip_thermal.c:482:7: error: too many arguments to
  function `thermal_zone_of_sensor_register'
         rockchip_thermal_set_trips);

Changes in v18:
	* address comments from Eduardo Valentin and Dmitry Torokhov..
	- we need reset tsadc-controller before enable tsadc auto mode,
	  when we add the thermal function in coreboot,we always enable tsadc controller.
	  So we need reset tsadc-controller to avoid the TSADC is abnormal.
	- put the document behind the driver.
	- Tested on pinky1,2,jeffy board,we will fix cooling-map temperature from 80C to 70C,
	  critical temperature from 100C to 90C.

Changes in v17:
	* address comments from Heiko Stubner and .
	- rename the tshut property
	- the critiacal temperature only indeed 100C when add the cooling map,
	  it's for the more secure,fix the temperature from 120C to 100C.

Changes in v16:
	* address comments from Dmitry Torokhov.
	- add thermal->chip->control(thermal->regs, false) in remove()
	- adjust TSHUT in resume().

Changes in v15:
	* address comments from Dmitry Torokhov.
	- enable TSHUT move into rk_tsadcv2_tshut_temp().
	- drop the id argument in rk_tsadcv2_control().

Changes in v14:
	* address comments from Dmitry Torokhov.
	- adjust-alarm-rate-depending-on-clock.
	- 0001-rockchip-thermal-do-not-register-cpufreq-cooling-dev.

Changes in v13:
	- add cooling-maps for cpu-thermal.
	- put tshut polarity in device tree.

Changes in v12:
	* address comments from Dmitry Torokhov and Vladimir Zapolskiy.
	- split-sensor-handling.
	- rename-rockchip_tsadc_platform_data.

Changes in v11:
	* address comments from Vladimir Zapolskiy.
	- fix cpufreq_cooling_unregister() to put in correct position.
	- fix "data->chn",at least can get valid Tsensor temp.

Changes in v10:
	* address comments from Doug Anderson.
	- fix TSHUT polarity,ensure support TSHUT.
	- add the decription for rk_tsadcv2_initialize().

Changes in v9:
	* address comments from Dmitry Torokhov.
	- fix some style be defined
	- remove some unused code.
	- clk_disable_unprepare->clk_disable in suspend()

Changes in v8:
	* address comments from Dmitry Torokhov and Doug Anderson.
	- add three Teperture Sensors.
	- support CRU and GPIO reset chip.
	- rename rk3xxx-cpu-thermal.dtsi as rk3288-thermal.dtsi
	- alarm-temp via set_trips() callback
	- remove "reset-gpios"

Changes in v7:
	- fix get data->clk=0 when in probe() function.
	- fix some style code.
	- modify dts,main add rk3xxx-cpu-thermal.dtsi

Changes in v6:
	* address comments from Tomeu Vizoso.
	- use thermal's generic framework.

Changes in v5:
	* address comments from Eduardo Valentin,rui.zhang and Heiko Stubner:
	- with BIT() macro
	- manage clocks in suspend/resume.
	- license is fixed as GPLv2.
	- #include "thermal_core.h"->#include <linux/thermal.h>
	- use the generic trip-points.the hw-shut-temp isn't generic trip-points.
	- The method of binding and unbinding be fixed.
	- The pin-name tsadc->otp_out

Changes in v4:
	* address comments from Jonathan Cameron,huangtao and zhaoyifeng:
	- this series thermal driver still be put in driver/thermal/
	- modify the thermal driver description.

Changes in v3:(add dts configure)
	* address comments from Dmitry Torokhov and Arnd Bergmann:
	- fix clock-names in rockchip-thermal.txt
	- remove rockchip_thermal_control() in rockchip_set_mode()
	- fix some code style.
	- add dts configure.

Changes in v2:
	* address comments from Heiko Stubner:
	- fix dt-bindings in rockchip-thermal.txt
	- remove Author mark
	- rename TSADC_XXX->TSADCV2_XXX,it eill ready to merge compatible other SoCs.
	- fix a identation
	- remove clk_set_rate(),it's no necessary.
	- fix the SIMPLE_DEV_PM_OPS() function  style.

Caesar Wang (5):
  thermal: rockchip: add driver for thermal
  dt-bindings: document Rockchip thermal
  ARM: dts: add RK3288 Thermal data
  ARM: dts: add main Thermal info to rk3288
  ARM: dts: enable Thermal on rk3288-evb board

 .../bindings/thermal/rockchip-thermal.txt          |  45 ++
 arch/arm/boot/dts/rk3288-evb.dtsi                  |   5 +
 arch/arm/boot/dts/rk3288-thermal.dtsi              |  58 ++
 arch/arm/boot/dts/rk3288.dtsi                      |  23 +
 drivers/thermal/Kconfig                            |   9 +
 drivers/thermal/Makefile                           |   1 +
 drivers/thermal/rockchip_thermal.c                 | 628 +++++++++++++++++++++
 7 files changed, 769 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
 create mode 100644 arch/arm/boot/dts/rk3288-thermal.dtsi
 create mode 100644 drivers/thermal/rockchip_thermal.c

-- 
1.9.1


