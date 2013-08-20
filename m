Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093Ab3HTJaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:30:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34237 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3HTJaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:30:11 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Sudeep.KarkadaNagesha@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v4 00/19] DT/core: update cpu device of_node
Date: Tue, 20 Aug 2013 10:30:02 +0100
Message-Id: <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 20 Aug 2013 09:30:06.0943 (UTC) FILETIME=[DB8586F0:01CE9D87]
X-MC-Unique: 113082010300811401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7K9Zl6A012365

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

Changes v3->v4:
1. There was a conflict with the generic definition of of_get_cpu_node
   with the one defined in PPC with the same name but different arguments.
   This version refactored the PPC definition to support other architectures
   before moving the code to DT core. This part was separately posted and
   reviewed[1].
2. Updated the users of of_get_cpu_node with second argument(i.e. thread id
   mostly NULL as its currently used only in PPC).

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

v1: https://lkml.org/lkml/2013/7/15/128
v2: https://lkml.org/lkml/2013/7/17/341
v3: https://lkml.org/lkml/2013/7/22/219
[1] https://lkml.org/lkml/2013/8/15/319 (PPC refactoring)

Sudeep KarkadaNagesha (19):
  microblaze: remove undefined of_get_cpu_node declaration
  openrisc: remove undefined of_get_cpu_node declaration
  powerpc: refactor of_get_cpu_node to support other architectures
  of: move of_get_cpu_node implementation to DT core library
  ARM: DT/kernel: define ARM specific arch_match_cpu_phys_id
  driver/core: cpu: initialize of_node in cpu's device struture
  of/device: add helper to get cpu device node from logical cpu index
  ARM: topology: remove hwid/MPIDR dependency from cpu_capacity
  ARM: mvebu: remove device tree parsing for cpu nodes
  drivers/bus: arm-cci: avoid parsing DT for cpu device nodes
  cpufreq: imx6q-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: cpufreq-cpu0: remove device tree parsing for cpu nodes
  cpufreq: highbank-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: spear-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: kirkwood-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: arm_big_little: remove device tree parsing for cpu nodes
  cpufreq: maple-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: pmac64-cpufreq: remove device tree parsing for cpu nodes
  cpufreq: pmac32-cpufreq: remove device tree parsing for cpu nodes

 arch/arm/kernel/devtree.c           |  5 ++
 arch/arm/kernel/topology.c          | 61 ++++++++----------------
 arch/arm/mach-imx/mach-imx6q.c      |  3 +-
 arch/arm/mach-mvebu/platsmp.c       | 51 +++++++++-----------
 arch/microblaze/include/asm/prom.h  |  3 --
 arch/openrisc/include/asm/prom.h    |  3 --
 arch/powerpc/include/asm/prom.h     |  3 --
 arch/powerpc/kernel/prom.c          | 43 +----------------
 drivers/base/cpu.c                  |  2 +
 drivers/bus/arm-cci.c               | 28 +++--------
 drivers/cpufreq/arm_big_little_dt.c | 40 ++++++----------
 drivers/cpufreq/cpufreq-cpu0.c      | 23 ++-------
 drivers/cpufreq/highbank-cpufreq.c  | 18 +++----
 drivers/cpufreq/imx6q-cpufreq.c     |  4 +-
 drivers/cpufreq/kirkwood-cpufreq.c  |  8 ++--
 drivers/cpufreq/maple-cpufreq.c     | 23 ++-------
 drivers/cpufreq/pmac32-cpufreq.c    |  5 +-
 drivers/cpufreq/pmac64-cpufreq.c    | 47 +++++-------------
 drivers/cpufreq/spear-cpufreq.c     |  4 +-
 drivers/of/base.c                   | 95 +++++++++++++++++++++++++++++++++++++
 include/linux/cpu.h                 |  1 +
 include/linux/of.h                  |  7 +++
 include/linux/of_device.h           | 15 ++++++
 23 files changed, 226 insertions(+), 266 deletions(-)

-- 
1.8.1.2


