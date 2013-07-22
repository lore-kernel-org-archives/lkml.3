Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab3GVLco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:32:44 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36142 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab3GVLck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:32:40 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com, Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v3 00/16] DT/core: update cpu device of_node
Date: Mon, 22 Jul 2013 12:32:11 +0100
Message-Id: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 22 Jul 2013 11:32:34.0046 (UTC) FILETIME=[28C1B9E0:01CE86CF]
X-MC-Unique: 113072212323602401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6MBaTA6009689

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

As more and more information is getting added into the cpu node, the number
of drivers needing to parse the device tree for CPU nodes are increasing.
Most of the time, the information needed from the cpu node is preferred
in the logical CPU order. Hence many drivers first parse and search the
CPU node, match them to logical index if needed and then search for the
required property inside a particular cpu node. Some of them assume the
logical and physical CPU ordering to be same which is incorrect.

This patch series initialises the of_node in all the cpu devices when
registering the CPU device.
1. This avoids different drivers having to parse the cpu nodes to obtain
   different attributes like operating points, latency,...etc.
2. This handles different physical and logical cpu ordering which is not
   the case in current code.
3. Also all the cpu nodes will have their of_node initialised correctly.
   Currently different drivers assign them partially and incorrectly.
4. Removes all the reduntant parsing in various drivers.

Changes v2->v3:
1. Added new OF helper to get of_node from the cpu logical index.
   With the use of this help, removed lots of duplicated code from
   cpufreq drivers.
2. Fixed issue with property length calculation in of_get_cpu_node.
   (previously had assumed of_get_property returns number of cells)
3. Changed return type of arch_match_cpu_phys_id to bool(as suggested by Nico)
4. Re-ordered patch 2 and 3, and few typo fixes.
5. Rebased on v3.11-rc2(to avoid any conflicts with __cpuinit* deletion)

Changes v1->v2:
1. Moved most of arch_of_get_cpu_node to OF/DT core as of_get_cpu_node
   adding a provision for architecture specific hooks for matching
   logical and physical ids.
2. Extended removal of DT cpu node parsing to PPC cpufreq drivers
3. Added Acks from Viresh and Shawn

Regards,
Sudeep

Sudeep KarkadaNagesha (16):
  of: add support for retrieving cpu node for a given logical cpu index
  ARM: DT/kernel: define ARM specific arch_match_cpu_phys_id
  driver/core: cpu: initialize of_node in cpu's device struture
  ARM: topology: remove hwid/MPIDR dependency from cpu_capacity
  ARM: mvebu: remove device tree parsing for cpu nodes
  drivers/bus: arm-cci: avoid parsing DT for cpu device nodes
  of/device: add helper to get cpu device node from logical cpu index
  cpufreq: imx6q-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: cpufreq-cpu0: remove device tree parsing for cpu nodes
  cpufreq: highbank-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: spear-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: kirkwood-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: arm_big_little: remove device tree parsing for cpu nodes
  cpufreq: maple-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: pmac64-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: pmac32-cpufreq: remove device tree parsing for cpu nodes

 arch/arm/kernel/devtree.c           |  5 +++
 arch/arm/kernel/topology.c          | 61 ++++++++++---------------------
 arch/arm/mach-imx/mach-imx6q.c      |  3 +-
 arch/arm/mach-mvebu/platsmp.c       | 52 +++++++++++++--------------
 drivers/base/cpu.c                  |  2 ++
 drivers/bus/arm-cci.c               | 28 ++++-----------
 drivers/cpufreq/arm_big_little_dt.c | 40 ++++++++-------------
 drivers/cpufreq/cpufreq-cpu0.c      | 23 +++---------
 drivers/cpufreq/highbank-cpufreq.c  | 18 ++++------
 drivers/cpufreq/imx6q-cpufreq.c     |  4 +--
 drivers/cpufreq/kirkwood-cpufreq.c  |  8 +++--
 drivers/cpufreq/maple-cpufreq.c     | 23 ++----------
 drivers/cpufreq/pmac32-cpufreq.c    |  5 +--
 drivers/cpufreq/pmac64-cpufreq.c    | 47 ++++++------------------
 drivers/cpufreq/spear-cpufreq.c     |  4 +--
 drivers/of/base.c                   | 72 +++++++++++++++++++++++++++++++++++++
 include/linux/of.h                  |  6 ++++
 include/linux/of_device.h           | 15 ++++++++
 18 files changed, 200 insertions(+), 216 deletions(-)

-- 
1.8.1.2


