Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaI3Aen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:34:43 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:10839 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411AbaI3Aem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:34:42 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 0/7] Qualcomm SMEM, SMD, RPM and regulators
Date: Mon, 29 Sep 2014 17:34:44 -0700
Message-ID: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All Qualcomm platforms implements a shared heap among the processors in the
SoC, used for sharing data with other parts of the system.

One consumer of items from this heap is the "Shared Memory Driver", a ring
buffer based point-to-point communication mechanism used to send either stream
or packet based data to remote processors.

Starting with 8x74 this system is used to talk to the Resource Power Manager
(RPM), a power efficient "coprocessor" with responsibility of aggregate votes
from the various systems in the SoC related to regulators, clocks and bus
frequencies.

The PMIC regulators and root clocks in these platforms are only accessible via
the RPM, so to get access to these we need the full chain of smem, smd, rpm and
a regulator driver implemented. And that is exactly what this series provides.


A key outstanding question is where in the tree we should put the
implementation, for now I dropped them in drivers/soc/qcom but that's only
because I don't know where to put it otherwise. I have not found any equivalent
of the SMEM driver, SMD resembles mailbox and rpmsg - but comments in that
patch on why it's neither.

RPM is a mfd and regulator is a regulator :)


Part from the rpm regulators I've tested this by hacking up a firmware loader
and making some adoptions to the wcn36xx WiFi driver and I can indeed
communicate with this system as well. Missing for that part is the coupling
with remoteproc to reset smd channels when a remote system goes down.  But that
is indeed a separate set of patches.

Bjorn Andersson (7):
  soc: qcom: Add device tree binding for SMEM
  soc: qcom: Add device tree binding for SMD
  mfd: devicetree: bindings: Add Qualcomm SMD based RPM DT binding
  soc: qcom: Add Shared Memory Manager driver
  soc: qcom: Add Shared Memory Driver
  mfd: qcom-smd-rpm: Driver for the Qualcomm RPM over SMD
  regulator: qcom-smd-rpm: Regulator driver for the Qualcomm RPM

 .../devicetree/bindings/mfd/qcom-rpm-smd.txt       |  122 +++
 .../devicetree/bindings/soc/qcom/qcom,smd.txt      |   82 ++
 .../devicetree/bindings/soc/qcom/qcom,smem.txt     |   34 +
 drivers/mfd/Kconfig                                |   14 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/qcom-smd-rpm.c                         |  299 ++++++
 drivers/regulator/Kconfig                          |   12 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/qcom_smd-regulator.c             |  229 +++++
 drivers/soc/qcom/Kconfig                           |   16 +
 drivers/soc/qcom/Makefile                          |    2 +
 drivers/soc/qcom/qcom_smd.c                        | 1043 ++++++++++++++++++++
 drivers/soc/qcom/qcom_smem.c                       |  328 ++++++
 include/dt-bindings/mfd/qcom-rpm.h                 |   36 +
 include/linux/mfd/qcom-smd-rpm.h                   |    9 +
 include/linux/soc/qcom/qcom_smd.h                  |   47 +
 include/linux/soc/qcom/qcom_smem.h                 |   14 +
 17 files changed, 2289 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/qcom-rpm-smd.txt
 create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,smd.txt
 create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,smem.txt
 create mode 100644 drivers/mfd/qcom-smd-rpm.c
 create mode 100644 drivers/regulator/qcom_smd-regulator.c
 create mode 100644 drivers/soc/qcom/qcom_smd.c
 create mode 100644 drivers/soc/qcom/qcom_smem.c
 create mode 100644 include/linux/mfd/qcom-smd-rpm.h
 create mode 100644 include/linux/soc/qcom/qcom_smd.h
 create mode 100644 include/linux/soc/qcom/qcom_smem.h

-- 
1.7.9.5

