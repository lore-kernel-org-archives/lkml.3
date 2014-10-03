Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbaJDATk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:19:40 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42580 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbaJCVou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:44:50 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, tiwai@suse.de,
        tj@kernel.org, arjan@linux.intel.com
Cc: teg@jklm.no, rmilasan@suse.com, werner@suse.com, oleg@redhat.com,
        hare@suse.com, bpoirier@suse.de, santosh@chelsio.com, pmladek@suse.cz,
        dbueso@suse.com, mcgrof@suse.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] driver-core: async probe support
Date: Fri,  3 Oct 2014 14:44:36 -0700
Message-Id: <1412372683-2003-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This second series addresses all comments from the v1 series, it
removed the white list, tidies up the commit logs, adds documentation
for the kernel parameters, adds a new debug taint flag and uses it
for the testing kernel parameters we have added. This series also
now goes with built-in async probe support by defining a kernel
parameter bus.enable_kern_async=1 userspace can set to indicate to the
kernel userspace has been vetted for async probe support. This essentially
means you will verify your userspace will not depend on sync probe
on scripts / daemons, and if such issues exist you're willing
to fix this in userspace. All of these features require userspace
intervention so by default synchronous probe is used just as before.
Both mechanisms allow us to create a new async probe universe safely
without affecting old userspace.

Folks wanting to do immediate testing can compile and just load
modules manually with async_probe=1 as a module parameter for
any module they wish to probe asynchrounously. Folks wishing to
test a debug feature to enable *all* modules to be probed
asynchronously can enable bus.__DEBUG__module_force_mod_async_probe=1
Likewise to test all built-in drivers with async probe folks can use
both bus.enable_kern_async=1 and bus.__DEBUG__kernel_force_mod_async_probe=1.
Any of these new __DEBUG__ kernel parameters will taint your kernel, in
practice for now folks should not be surprised if they run into issues
with any of these parameters until async probe gets widely tested and
drivers which require sync probe are found. This series goes with one
example driver where sync probe was required, a fix to the driver is
pending to enable async probe but the issue has already been identified
and should be easy to fix.

Folks wishing to test built-in drivers can enable

bus.enable_kern_async=1

and then modify their driver with something like this:

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 247335d..9f0b636 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7241,6 +7241,7 @@ static struct pci_driver e1000_driver = {
 	.remove   = e1000_remove,
 	.driver   = {
 		.pm = &e1000_pm_ops,
+		.prefer_async_probe = true,
 	},
 	.shutdown = e1000_shutdown,
 	.err_handler = &e1000_err_handler

This will *not* taint your kernel. Folks wishing to go all out and use
async probe for *all* device drivers, whether built-in or not can enable
the following and start debugging drivers as their heart pleases:

bus.enable_kern_async=1 bus.__DEBUG__module_force_mod_async_probe=1 bus.__DEBUG__kernel_force_mod_async_probe=1

I've given this a whirl on 3 different machines now, bus.__DEBUG__module_force_mod_async_probe=1
is actually fine for all 3 systems however bus.__DEBUG__kernel_force_mod_async_probe=1
requires quite a bit of drivers identified / annotated for sync probe.

Luis R. Rodriguez (7):
  taint: add TAINT_DEBUG for invasive debugging features
  module: add extra argument for parse_params() callback
  driver-core: enable drivers to opt-out of async probe
  amd64_edac: enforce synchronous probe
  driver-core: generalize freeing driver private member
  driver-core: add driver module asynchronous probe support
  driver-core: add preferred async probe option for built-in and modules

 Documentation/kernel-parameters.txt |  16 ++++
 Documentation/sysctl/kernel.txt     |   1 +
 arch/powerpc/mm/hugetlbpage.c       |   4 +-
 drivers/base/base.h                 |   6 ++
 drivers/base/bus.c                  | 149 ++++++++++++++++++++++++++++++++++--
 drivers/base/dd.c                   |   7 ++
 drivers/edac/amd64_edac.c           |   1 +
 include/linux/device.h              |  12 +++
 include/linux/kernel.h              |   1 +
 include/linux/module.h              |   2 +
 include/linux/moduleparam.h         |   3 +-
 init/main.c                         |  25 +++---
 kernel/module.c                     |  20 +++--
 kernel/panic.c                      |   2 +
 kernel/params.c                     |  11 ++-
 lib/dynamic_debug.c                 |   4 +-
 16 files changed, 234 insertions(+), 30 deletions(-)

-- 
2.1.1

