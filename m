Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaIZV5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:57:23 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63847 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbaIZV5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:57:21 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, tiwai@suse.de,
        tj@kernel.org, arjan@linux.intel.com
Cc: teg@jklm.no, rmilasan@suse.com, werner@suse.com, oleg@redhat.com,
        hare@suse.com, bpoirier@suse.de, santosh@chelsio.com, pmladek@suse.cz,
        dbueso@suse.com, mcgrof@suse.com, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/5] driver-core: async probe support
Date: Fri, 26 Sep 2014 14:57:12 -0700
Message-Id: <1411768637-6809-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

What started off as a witch hunt for a solution to the systemd
kernel-module-loading-timeout-and-it-killing-drivers-issue (TM)
ended up in our last discussions [0] agreement for us to add to the
kernel what systemd expected us to be doing: asynchronous probing.

This implements support for that, but please note that upon further
inspection of what the timeout is doing and implicating (documented on
patch number 5 in this series) its also recommended that systemd
revisit its timeout and perhaps consider simply not killing kmod
workers. Even if the killing goes away this framework can still be
desirable, and its expected this will be expanded to support
built-in drivers as well later.

This goes build tested with allmodconfig, and run time tested
with and without bus.safe_mod_async_probe=1 on 4 different systems.
As noted on patch #5 systemd should not use bus.safe_mod_async_probe=1
but instead issue a request per module so that in other cases where
its not advisable to use async probe (also documented on patch #5)
it can avoid it. We also enable a flag to let drivers specify if
they never want to enable async probe for whatever reason and an
example is provided on how to do this.

This should have 0 impact unless userspace is issuing the module
parameter for modules, or if any of the new module parameters are
used to help test things.

[0] https://lkml.org/lkml/2014/9/12/625

Luis R. Rodriguez (5):
  module: add extra argument for parse_params() callback
  driver-core: enable drivers to opt-out of async probe
  amd64_edac: enforce synchronous probe
  driver-core: generalize freeing driver private member
  driver-core: add driver asynchronous probe support

 arch/powerpc/mm/hugetlbpage.c |   4 +-
 drivers/base/base.h           |   6 ++
 drivers/base/bus.c            | 150 ++++++++++++++++++++++++++++++++++++++++--
 drivers/base/dd.c             |   7 ++
 drivers/edac/amd64_edac.c     |   1 +
 include/linux/device.h        |   5 ++
 include/linux/module.h        |   2 +
 include/linux/moduleparam.h   |   3 +-
 init/main.c                   |  25 ++++---
 kernel/module.c               |  16 ++++-
 kernel/params.c               |  11 ++--
 lib/dynamic_debug.c           |   4 +-
 12 files changed, 206 insertions(+), 28 deletions(-)

-- 
2.1.0

