Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3BEVtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:49:14 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:42785 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab3BEVtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:49:12 -0500
Subject: [PATCH 0/4] Alter steal-time reporting in the guest
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mtosatti@redhat.com, glommer@parallels.com,
        mingo@redhat.com, anthony@codemonkey.ws
Date: Tue, 05 Feb 2013 15:49:00 -0600
Message-ID: <20130205214818.4615.12937.stgit@lambeau>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020521-2674-0000-0000-000007BBA5AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of where you have a system that is running in a
capped or overcommitted environment the user may see steal time
being reported in accounting tools such as top or vmstat.  This can
cause confusion for the end user.  To ease the confusion this patch set
adds the idea of consigned (expected steal) time.  The host will separate
the consigned time from the steal time.  Tthe steal time will only be altered
if hard limits (cfs bandwidth control) is used.  The period and the quota used
to separate the consigned time (expected steal) from the steal time are taken
from the cfs bandwidth control settings. Any other steal time accruing during
that period will show as the traditional steal time.

Changes from V2:
* Dropped the ioctl that allowed qemu to send the entitlement value to
  the guest.
* Added code to get the entitlement period and quota from cfs bandwidth.

Changes from V1:
* Removed the steal time allowed percentage from the guest
* Moved the separation of consigned (expected steal) and steal time to the
  host.
* No longer include a sysctl interface.

---

Michael Wolf (4):
      Alter the amount of steal time reported by the guest.
      Expand the steal time msr to also contain the consigned time.
      Add the code to send the consigned time from the host to the guest
      Add a timer to allow the separation of consigned from steal time.


 arch/x86/include/asm/kvm_host.h       |   10 +++++
 arch/x86/include/asm/paravirt.h       |    4 +-
 arch/x86/include/asm/paravirt_types.h |    2 +
 arch/x86/include/uapi/asm/kvm_para.h  |    3 +-
 arch/x86/kernel/kvm.c                 |    8 ++--
 arch/x86/kernel/paravirt.c            |    4 +-
 arch/x86/kvm/x86.c                    |   64 ++++++++++++++++++++++++++++++++-
 fs/proc/stat.c                        |    9 ++++-
 include/linux/kernel_stat.h           |    2 +
 kernel/sched/core.c                   |   30 +++++++++++++++
 kernel/sched/cputime.c                |   21 ++++++++++-
 kernel/sched/sched.h                  |    2 +
 12 files changed, 142 insertions(+), 17 deletions(-)

-- 
Signature

