Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaIIWMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:12:30 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47742 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaIIWM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:12:28 -0400
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: dirk.j.brandewie@intel.com
Cc: rjw@rjwysocki.net, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>
Subject: [RFC v1 0/6] CPPC as a PID backend
Date: Tue,  9 Sep 2014 18:12:02 -0400
Message-Id: <1410300728-26637-1-git-send-email-ashwin.chaugule@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces CPPC(Collaborative Processor Performance Control) as a backend
to the PID governor. The PID governor from intel_pstate.c maps cleanly onto some CPPC
interfaces.
e.g. The CPU performance requests are made on a continuous scale as against discrete pstate
levels. The CPU performance feedback over an interval is gauged using platform specific
counters which are also described by CPPC.

Although CPPC describes several other registers to provide more hints to the platform,
Linux as of today does not have the infrastructure to make use of those registers.
Some of the CPPC specific information could be made available from the scheduler as
part of the CPUfreq and Scheduler intergration work. Until then PID can be used as the
front end for CPPC.

Beyond code restructuring and renaming, this patchset does not change the logic from the
intel_pstate.c driver. Kernel compilation times were compared with the original intel_pstate.c,
intel backend(intel_pid_ctrl.c) and the CPPC backend and no significant overheads were noticed.

Testing was performed on a Thinkpad X240 laptop.

PID_CTRL + INTEL_PSTATE:
=======================
real	5m37.742s
user	18m42.575s
sys	1m0.521s


PID_CTRL + CPPC_PID_CTRL:
========================
real	5m48.321s
user	18m24.487s
sys	0m59.327s


ORIGINAL INTEL_PSTATE:
======================
real	5m40.642s
user	18m37.411s
sys	1m0.185s


The complete patchset including the PCC hacks used for testing is available in [4].


Changes since V0: [1]
-	Split intel_pstate.c into a generic PID governor and platform specific backend.
-	Add CPPC accessors as PID backend.


CPPC:
====

CPPC (Collaborative Processor Performance Control) is a new way to control CPU
performance using an abstract continous scale as against a discretized P-state scale
which is tied to CPU frequency only. It is defined in the ACPI 5.0+ spec. In brief,
the basic operation involves:
- OS makes a CPU performance request. (Can provide min and max tolerable bounds)

- Platform (such as BMC) is free to optimize request within requested bounds depending
on power/thermal budgets etc.

- Platform conveys its decision back to OS

The communication between OS and platform occurs through another medium called (PCC)
Platform communication Channel. This is a generic mailbox like mechanism which includes
doorbell semantics to indicate register updates. The PCC driver is being discussed in a
separate patchset [3] and is not included here, since CPPC is only one client of PCC.

Finer details about the PCC and CPPC spec are available in the latest ACPI 5.1
specification.[2]

[1] - http://lwn.net/Articles/608715/
[2] - http://www.uefi.org/sites/default/files/resources/ACPI_5_1release.pdf
[3] - http://comments.gmane.org/gmane.linux.acpi.devel/70299
[4] - http://git.linaro.org/people/ashwin.chaugule/leg-kernel.git/shortlog/refs/heads/cppc-pid-no_freq_domain



Ashwin Chaugule (6):
  PID Controller governor
  PID: Move Turbo detection into backend driver
  PID: Move Baytrail specific accessors into backend driver
  PID: Add new function pointers to read multiple registers
  PID: Rename counters to make them more generic
  PID: Add CPPC (Collaborative Processor Performance) backend driver

 Documentation/cpu-freq/intel-pstate.txt |   43 --
 Documentation/cpu-freq/pid_ctrl.txt     |   41 ++
 drivers/cpufreq/Kconfig                 |   19 +
 drivers/cpufreq/Kconfig.x86             |    2 +-
 drivers/cpufreq/Makefile                |    4 +-
 drivers/cpufreq/cppc_pid_ctrl.c         |  406 +++++++++++++
 drivers/cpufreq/intel_pid_ctrl.c        |  408 +++++++++++++
 drivers/cpufreq/intel_pstate.c          | 1012 -------------------------------
 drivers/cpufreq/pid_ctrl.c              |  615 +++++++++++++++++++
 drivers/cpufreq/pid_ctrl.h              |  113 ++++
 10 files changed, 1606 insertions(+), 1057 deletions(-)
 delete mode 100644 Documentation/cpu-freq/intel-pstate.txt
 create mode 100644 Documentation/cpu-freq/pid_ctrl.txt
 create mode 100644 drivers/cpufreq/cppc_pid_ctrl.c
 create mode 100644 drivers/cpufreq/intel_pid_ctrl.c
 delete mode 100644 drivers/cpufreq/intel_pstate.c
 create mode 100644 drivers/cpufreq/pid_ctrl.c
 create mode 100644 drivers/cpufreq/pid_ctrl.h

-- 
1.9.1

