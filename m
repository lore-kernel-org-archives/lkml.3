Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab3GKWSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:18:53 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46875 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab3GKWSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:18:51 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 0/8] Cpufreq, cpu hotplug, suspend/resume related fixes
To: rjw@sisk.pl, viresh.kumar@linaro.org, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com
Cc: stern@rowland.harvard.edu,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Jul 2013 03:45:17 +0530
Message-ID: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071209-3568-0000-0000-000003E9A0A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Commit a66b2e (cpufreq: Preserve sysfs files across suspend/resume) caused
some subtle regressions in the cpufreq subsystem during suspend/resume.
This patchset is aimed at rectifying those problems, by fixing the regression
as well as achieving the original goal of that commit in a proper way.

Patch 1 reverts the above commit, and is CC'ed to stable.

Patches 2 - 5 reorganize the code and have no functional impact, and can go
in as general cleanups as well. This reorganization builds a base that the
rest of the patches will make use of.

Patch 6 and 7 add a mechanism to perform light-weight init/tear-down of CPUs
in the cpufreq subsystem and finally patch 8 uses it to preserve sysfs files
across suspend/resume.

All the patches apply on current mainline.


Robert, Durgadoss, it would be great if you could try it out and see if it works
well for your usecase. I tested it locally and cpufreq related files did retain
their permissions across suspend/resume. Let me know if it works fine in your
setup too.

And I'd of course appreciate to hear from Dirk, Tianyu and Toralf to know
whether their systems work fine after:
a. applying only the first commit (this is what gets backported to stable)
b. applying all the commits

(Note: I had to use Michael's fix[1] to avoid CPU hotplug deadlock while
testing this patchset. Though that patch also touches cpufreq subsystem, it
doesn't affect this patchset in any way and there is absolutely no dependency
between the two in terms of code. That fix just makes basic CPU hotplug work
without locking up on current mainline).

[1]. https://lkml.org/lkml/2013/7/10/611


Thank you very much!


 Srivatsa S. Bhat (8):
      cpufreq: Revert commit a66b2e to fix cpufreq regression during suspend/resume
      cpufreq: Fix misplaced call to cpufreq_update_policy()
      cpufreq: Add helper to perform alloc/free of policy structure
      cpufreq: Extract non-interface related stuff from cpufreq_add_dev_interface
      cpufreq: Extract the handover of policy cpu to a helper function
      cpufreq: Introduce a flag ('frozen') to separate full vs temporary init/teardown
      cpufreq: Preserve policy structure across suspend/resume
      cpufreq: Perform light-weight init/teardown during suspend/resume

 drivers/cpufreq/cpufreq.c       |  297 ++++++++++++++++++++++++++-------------
 drivers/cpufreq/cpufreq_stats.c |   10 -
 2 files changed, 199 insertions(+), 108 deletions(-)


Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

