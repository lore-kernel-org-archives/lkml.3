Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaIJPoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:44:22 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42639 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaIJPoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:44:19 -0400
Message-ID: <541071CF.9030901@gmail.com>
Date: Wed, 10 Sep 2014 08:44:15 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ashwin Chaugule <ashwin.chaugule@linaro.org>
CC: dirk.brandewie@gmail.com, rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [RFC v1 0/6] CPPC as a PID backend
References: <1410300728-26637-1-git-send-email-ashwin.chaugule@linaro.org>
In-Reply-To: <1410300728-26637-1-git-send-email-ashwin.chaugule@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashwin,

I think the CPPC based driver should be a separate driver.

We made the conscious decision to not use any of the ACPI mechanisms
to enumerate or control P state selection.  Experience over the years
has shown that the quality/accuracy of the BIOS/ACPI implementations
vary widely across OEM's and platform types from a single OEM. Features
that always work on a server platform from a given OEM may not work or
provide bad information on client platforms for example.

Another reason for doing intel_pstate was to be able to land intel specific
features and fixes without breaking other architectures as the power
management capabilities of the platform evolve. As processors that support
Hardware P states (HWP) as described in section 14.4 of the current SDM
come into the market intel_pstate will change to not doing much other
than enabling HWP and providing an interface to forward user configuration
requests to the processor if the user chooses to enable HWP otherwise the
current mechanisms will be used.  This is why the intel_pstate sysfs
interface is the way it is to be able to map cleanly to HWP and provide
an abstract interface going forward.

Having separate drivers allows the system integrator/user to select the
most appropriate mechanism for their system.

--Dirk

On 09/09/2014 03:12 PM, Ashwin Chaugule wrote:
> This patchset introduces CPPC(Collaborative Processor Performance Control) as a backend
> to the PID governor. The PID governor from intel_pstate.c maps cleanly onto some CPPC
> interfaces.
> e.g. The CPU performance requests are made on a continuous scale as against discrete pstate
> levels. The CPU performance feedback over an interval is gauged using platform specific
> counters which are also described by CPPC.
>
> Although CPPC describes several other registers to provide more hints to the platform,
> Linux as of today does not have the infrastructure to make use of those registers.
> Some of the CPPC specific information could be made available from the scheduler as
> part of the CPUfreq and Scheduler intergration work. Until then PID can be used as the
> front end for CPPC.
>
> Beyond code restructuring and renaming, this patchset does not change the logic from the
> intel_pstate.c driver. Kernel compilation times were compared with the original intel_pstate.c,
> intel backend(intel_pid_ctrl.c) and the CPPC backend and no significant overheads were noticed.
>
> Testing was performed on a Thinkpad X240 laptop.
>
> PID_CTRL + INTEL_PSTATE:
> =======================
> real	5m37.742s
> user	18m42.575s
> sys	1m0.521s
>
>
> PID_CTRL + CPPC_PID_CTRL:
> ========================
> real	5m48.321s
> user	18m24.487s
> sys	0m59.327s
>
>
> ORIGINAL INTEL_PSTATE:
> ======================
> real	5m40.642s
> user	18m37.411s
> sys	1m0.185s
>
>
> The complete patchset including the PCC hacks used for testing is available in [4].
>
>
> Changes since V0: [1]
> -	Split intel_pstate.c into a generic PID governor and platform specific backend.
> -	Add CPPC accessors as PID backend.
>
>
> CPPC:
> ====
>
> CPPC (Collaborative Processor Performance Control) is a new way to control CPU
> performance using an abstract continous scale as against a discretized P-state scale
> which is tied to CPU frequency only. It is defined in the ACPI 5.0+ spec. In brief,
> the basic operation involves:
> - OS makes a CPU performance request. (Can provide min and max tolerable bounds)
>
> - Platform (such as BMC) is free to optimize request within requested bounds depending
> on power/thermal budgets etc.
>
> - Platform conveys its decision back to OS
>
> The communication between OS and platform occurs through another medium called (PCC)
> Platform communication Channel. This is a generic mailbox like mechanism which includes
> doorbell semantics to indicate register updates. The PCC driver is being discussed in a
> separate patchset [3] and is not included here, since CPPC is only one client of PCC.
>
> Finer details about the PCC and CPPC spec are available in the latest ACPI 5.1
> specification.[2]
>
> [1] - http://lwn.net/Articles/608715/
> [2] - http://www.uefi.org/sites/default/files/resources/ACPI_5_1release.pdf
> [3] - http://comments.gmane.org/gmane.linux.acpi.devel/70299
> [4] - http://git.linaro.org/people/ashwin.chaugule/leg-kernel.git/shortlog/refs/heads/cppc-pid-no_freq_domain
>
>
>
> Ashwin Chaugule (6):
>    PID Controller governor
>    PID: Move Turbo detection into backend driver
>    PID: Move Baytrail specific accessors into backend driver
>    PID: Add new function pointers to read multiple registers
>    PID: Rename counters to make them more generic
>    PID: Add CPPC (Collaborative Processor Performance) backend driver
>
>   Documentation/cpu-freq/intel-pstate.txt |   43 --
>   Documentation/cpu-freq/pid_ctrl.txt     |   41 ++
>   drivers/cpufreq/Kconfig                 |   19 +
>   drivers/cpufreq/Kconfig.x86             |    2 +-
>   drivers/cpufreq/Makefile                |    4 +-
>   drivers/cpufreq/cppc_pid_ctrl.c         |  406 +++++++++++++
>   drivers/cpufreq/intel_pid_ctrl.c        |  408 +++++++++++++
>   drivers/cpufreq/intel_pstate.c          | 1012 -------------------------------
>   drivers/cpufreq/pid_ctrl.c              |  615 +++++++++++++++++++
>   drivers/cpufreq/pid_ctrl.h              |  113 ++++
>   10 files changed, 1606 insertions(+), 1057 deletions(-)
>   delete mode 100644 Documentation/cpu-freq/intel-pstate.txt
>   create mode 100644 Documentation/cpu-freq/pid_ctrl.txt
>   create mode 100644 drivers/cpufreq/cppc_pid_ctrl.c
>   create mode 100644 drivers/cpufreq/intel_pid_ctrl.c
>   delete mode 100644 drivers/cpufreq/intel_pstate.c
>   create mode 100644 drivers/cpufreq/pid_ctrl.c
>   create mode 100644 drivers/cpufreq/pid_ctrl.h
>

