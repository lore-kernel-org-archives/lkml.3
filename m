Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaJTVJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:09:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51068 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbaJTVI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:08:57 -0400
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux@arm.linux.org.uk, pratikp@codeaurora.org, varshney@ti.com,
        Al.Grant@arm.com, jonas.svennebring@avagotech.com,
        james.king@linaro.org, kaixu.xia@linaro.org, marcin.jabrzyk@gmail.com,
        r.sengupta@samsung.com, robbelibobban@gmail.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH v8 00/11] Coresight framework and drivers 
Date: Mon, 20 Oct 2014 15:08:01 -0600
Message-Id: <1413839292-19135-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Coresight is an umbrella of technologies allowing for the debugging of ARM
based SoCs.  It includes solutions for JTAG and HW assisted tracing.  This
patchset is concerned with the latter.

Coresight components are cathegorised as source, link and sinks and are
(usually) discovered using the AMBA bus.

"Sources" generate a compressed stream representing the processor instruction
path based on tracing scenarios as configured by users.  From there the stream
flows through the coresight system (via ATB bus) using links that are connecting
the emanating source to a sink(s).  Sinks serve as endpoints to the coresight
implementation, either storing the compressed stream in a memory buffer or
creating an interface to the outside world where data can be transfered to a
host without fear of filling up the onboard coresight memory buffer.

At typical coresight system would look like this:

  *****************************************************************
 **************************** AMBA AXI  ****************************===||
  *****************************************************************    ||
        ^                    ^                            |            ||
        |                    |                            *            **
     0000000    :::::     0000000    :::::    :::::    @@@@@@@    ||||||||||||
     0 CPU 0<-->: C :     0 CPU 0<-->: C :    : C :    @ STM @    || System ||
  |->0000000    : T :  |->0000000    : T :    : T :<--->@@@@@     || Memory ||
  |  #######<-->: I :  |  #######<-->: I :    : I :      @@@<-|   ||||||||||||
  |  # ETM #    :::::  |  # PTM #    :::::    :::::       @   |
  |   #####      ^ ^   |   #####      ^ !      ^ !        .   |   |||||||||
  | |->###       | !   | |->###       | !      | !        .   |   || DAP ||
  | |   #        | !   | |   #        | !      | !        .   |   |||||||||
  | |   .        | !   | |   .        | !      | !        .   |      |  |
  | |   .        | !   | |   .        | !      | !        .   |      |  *
  | |   .        | !   | |   .        | !      | !        .   |      | SWD/
  | |   .        | !   | |   .        | !      | !        .   |      | JTAG
  *****************************************************************<-|
 *************************** AMBA Debug ABP ************************
  *****************************************************************
   |    .          !         .          !        !        .    |
   |    .          *         .          *        *        .    |
  *****************************************************************
 ******************** Cross Trigger Matrix (CTM) *******************
  *****************************************************************
   |    .     ^              .                            .    |
   |    *     !              *                            *    |
  *****************************************************************
 ****************** AMBA Advanced Trace Bus (ATB) ******************
  *****************************************************************
   |          !                        ===============         |
   |          *                         ===== F =====<---------|
   |   :::::::::                         ==== U ====
   |-->:: CTI ::<!!                       === N ===
   |   :::::::::  !                        == N ==
   |    ^         *                        == E ==
   |    !  &&&&&&&&&       IIIIIII         == L ==
   |------>&& ETB &&<......II     I        =======
   |    !  &&&&&&&&&       II     I           .
   |    !                    I     I          .
   |    !                    I REP I<..........
   |    !                    I     I
   |    !!>&&&&&&&&&       II     I           *Source: ARM ltd.
   |------>& TPIU  &<......II    I            DAP = Debug Access Port
           &&&&&&&&&       IIIIIII            ETM = Embedded Trace Macrocell
               ;                              PTM = Program Trace Macrocell
               ;                              CTI = Cross Trigger Interface
               *                              ETB = Embedded Trace Buffer
          To trace port                       TPIU= Trace Port Interface Unit
                                              SWD = Serial Wire Debug

While on target configuration of the components is done via the ABP bus,
all trace data are carried out-of-band on the ATB bus.  The CTM provides
a way to aggregate and distribute signals between CoreSight components.

The coresight framework provides a central point to represent, configure and
manage coresight devices on a platform.  This first wave centers on the basic
tracing functionnality, enabling components such ETM/PTM, funnel, replicator, TMC,
TPIU and ETB.  Subsequent submissions will enable more intricate IP blocks such
as STM and CTI.

Generated traces are encoded in a PFTv1.1 format and can be interpreted
using the procedure detailed here [1] or ptm2human [2]. STM abides to the
widely available STPv2 standard.

Bindings for the driver have been sent separately to the devicetree list.

[1].https://wiki.linaro.org/WorklingGroups/Kernel/Coresight/traceDecodingWithDS5
[2].https://github.com/hwangcc23/ptm2human

New in this patchset:
. Rebased on v3.18-rc1
. Added coresight entry to MAINTAINERS file
. Typo fixes to documentation
. Re-arranged configuration of link and sinks in Kconfig and Makefile
  for grater configuration flexibility

Mathieu Poirier (4):
  coresight: documentation for coresight framework and drivers
  coresight: adding support for beagle and beagleXM
  coresight: adding basic support for Vexpress TC2
  ARM: removing support for etb/etm in "arch/arm/kernel/"

Pratik Patel (7):
  coresight: add CoreSight core layer framework
  coresight-tmc: add CoreSight TMC driver
  coresight-tpiu: add CoreSight TPIU driver
  coresight-etb: add CoreSight ETB driver
  coresight-funnel: add CoreSight Funnel driver
  coresight-replicator: add CoreSight Replicator driver
  coresight-etm: add CoreSight ETM/PTM driver

 Documentation/trace/coresight.txt          |  299 +++++
 MAINTAINERS                                |    8 +
 arch/arm/Kconfig.debug                     |   63 +-
 arch/arm/boot/dts/omap3-beagle-xm.dts      |   28 +
 arch/arm/boot/dts/omap3-beagle.dts         |   28 +
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts |  199 +++
 arch/arm/include/asm/hardware/coresight.h  |  157 ---
 arch/arm/include/asm/hardware/cp14.h       |  542 ++++++++
 arch/arm/kernel/Makefile                   |    1 -
 arch/arm/kernel/etm.c                      |  654 ----------
 arch/arm/kernel/hw_breakpoint.c            |    4 +-
 arch/arm/mach-omap2/Kconfig                |    8 -
 arch/arm/mach-omap2/Makefile               |    1 -
 arch/arm/mach-omap2/emu.c                  |   50 -
 drivers/Makefile                           |    1 +
 drivers/amba/bus.c                         |    2 +-
 drivers/coresight/Makefile                 |   11 +
 drivers/coresight/coresight-etb10.c        |  537 ++++++++
 drivers/coresight/coresight-etm-cp14.c     |  591 +++++++++
 drivers/coresight/coresight-etm.h          |  251 ++++
 drivers/coresight/coresight-etm3x.c        | 1926 ++++++++++++++++++++++++++++
 drivers/coresight/coresight-funnel.c       |  268 ++++
 drivers/coresight/coresight-priv.h         |   63 +
 drivers/coresight/coresight-replicator.c   |  138 ++
 drivers/coresight/coresight-tmc.c          |  776 +++++++++++
 drivers/coresight/coresight-tpiu.c         |  217 ++++
 drivers/coresight/coresight.c              |  717 +++++++++++
 drivers/coresight/of_coresight.c           |  204 +++
 include/linux/amba/bus.h                   |    1 +
 include/linux/coresight.h                  |  263 ++++
 30 files changed, 7126 insertions(+), 882 deletions(-)
 create mode 100644 Documentation/trace/coresight.txt
 delete mode 100644 arch/arm/include/asm/hardware/coresight.h
 create mode 100644 arch/arm/include/asm/hardware/cp14.h
 delete mode 100644 arch/arm/kernel/etm.c
 delete mode 100644 arch/arm/mach-omap2/emu.c
 create mode 100644 drivers/coresight/Makefile
 create mode 100644 drivers/coresight/coresight-etb10.c
 create mode 100644 drivers/coresight/coresight-etm-cp14.c
 create mode 100644 drivers/coresight/coresight-etm.h
 create mode 100644 drivers/coresight/coresight-etm3x.c
 create mode 100644 drivers/coresight/coresight-funnel.c
 create mode 100644 drivers/coresight/coresight-priv.h
 create mode 100644 drivers/coresight/coresight-replicator.c
 create mode 100644 drivers/coresight/coresight-tmc.c
 create mode 100644 drivers/coresight/coresight-tpiu.c
 create mode 100644 drivers/coresight/coresight.c
 create mode 100644 drivers/coresight/of_coresight.c
 create mode 100644 include/linux/coresight.h

-- 
1.9.1

