Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaFSNFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:05:24 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:40425 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbaFSNFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:05:21 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <gnurou@gmail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Chris Ball <chris@printf.net>,
        Chen-Yu Tsai <wens@csie.org>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [RFC 0/2] pwrseq: Add subsystem for power sequences
Date: Thu, 19 Jun 2014 15:04:49 +0200
Message-Id: <1403183091-27876-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some background:

Subsystems using discoverable buses, sometimes requires to handle a complex
power sequence, to be able to initialize their devices.

Historically, there have been several attempts and posted patches to address
this problem. Here are a some links to a subset of discussions:

http://www.spinics.net/lists/linux-mmc/msg24411.html
http://www.spinics.net/lists/linux-mmc/msg26564.html
http://lwn.net/Articles/525422/
http://linux-kernel.2935.n7.nabble.com/PATCHv9-0-3-Runtime-Interpreted-Power-Sequences-td555721.html


What does the pwrseq subsystem do?

The pwrseq subsystem handles complex power sequences, typically useful
for subsystems that makes use of discoverable buses, like for example
MMC and I2C.

The pwrseq subsystem is dependant on CONFIG_OF to be able to parse a DT
childnode to find out what power sequence method to bind for a device.

>From the DT childnode, the pwrseq DT parser tries to locate a
"power-method" property, which string is matched towards the list of
supported pwrseq methods.

Each pwrseq method implements it's own power sequence and interfaces
the pwrseq core through a few callback functions.

To instantiate a pwrseq method, clients shall use the devm_pwrseq_get()
API. If needed, clients can explicity drop the references to a pwrseq
method using devm_pwrseq_put() API.

Besides instantiation, the pwrseq API provides clients opportunity to
select a certain power state. In this intial version, PWRSEQ_POWER_ON
and PWRSEQ_POWER_OFF are supported. Those are also mandatory for each
pwrseq method to support.


Ulf Hansson (2):
  pwrseq: Add subsystem to handle complex power sequences
  mmc: core: Add support for power sequences

 .../devicetree/bindings/pwrseq/pwrseq.txt          |   48 ++++++
 drivers/Makefile                                   |    2 +-
 drivers/mmc/core/core.c                            |    7 +
 drivers/mmc/core/host.c                            |    5 +
 drivers/pwrseq/Makefile                            |    2 +
 drivers/pwrseq/core.c                              |  175 ++++++++++++++++++++
 drivers/pwrseq/core.h                              |   37 +++++
 drivers/pwrseq/method.c                            |   38 +++++
 include/linux/mmc/host.h                           |    3 +
 include/linux/pwrseq.h                             |   50 ++++++
 10 files changed, 366 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/pwrseq/pwrseq.txt
 create mode 100644 drivers/pwrseq/Makefile
 create mode 100644 drivers/pwrseq/core.c
 create mode 100644 drivers/pwrseq/core.h
 create mode 100644 drivers/pwrseq/method.c
 create mode 100644 include/linux/pwrseq.h

-- 
1.7.9.5

