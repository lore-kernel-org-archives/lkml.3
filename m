Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbaGIRJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:09:45 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:56087 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605AbaGIRJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:09:43 -0400
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, Havard Skinnemoen <hskinnemoen@google.com>,
        Ewout van Bekkum <ewout@google.com>
Subject: [PATCH 0/6] x86 mce fixes
Date: Wed,  9 Jul 2014 10:09:20 -0700
Message-Id: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series contains a few fixes we came up with while testing the MCE
handling on our servers in the lab. These should fix the following symptoms:

  - Once entering CMCI storm mode, we would never exit. This was because we set
    the check_interval to be shorter than 30 seconds, so the condition to exit
    storm mode could never become true.
  - After a storm, the MCE banks previously handled by a CPU could not be
    reclaimed.
  - After a kexec reboot, none of the MCE banks could be claimed by any CPU.
  - Duplicate MCEs were being reported in some circumstances (e.g. with
    mce=no_cmci and/or mce=3).
  - Crashes because the polling timer was added multiple times.

We're not sure if these patches are the best way to fix these issues, and they
may introduce new, subtle bugs, but it's the best we managed to come up with.
Please take a good look and tell us what we got wrong.

Ewout did all the leg work in getting this implemented and tested, while I've
been providing advice and reviews.

Signed-off-by: Ewout van Bekkum <ewout@google.com>
Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>

Ewout van Bekkum (6):
  x86-mce: Modify CMCI poll interval to adjust for small check_interval
    values.
  x86-mce: Modify CMCI storm exit to reenable instead of rediscover
    banks.
  x86-mce: Clear CMCI enable on all claimed CMCI banks before reboot.
  x86-mce: Add spinlocks to prevent duplicated MCP and CMCI reports.
  x86-mce: check if no_way_out applies before deciding not to clear MCE
    banks.
  x86-mce: ensure the MCP timer is not already set in the mce_timer_fn.

 arch/x86/kernel/cpu/mcheck/mce-internal.h |  2 +
 arch/x86/kernel/cpu/mcheck/mce.c          | 39 +++++++++++--
 arch/x86/kernel/cpu/mcheck/mce_intel.c    | 95 ++++++++++++++++++++++++-------
 3 files changed, 111 insertions(+), 25 deletions(-)

-- 
2.0.0.526.g5318336

