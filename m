Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbaFLQZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:25:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39806 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbaFLQZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:25:55 -0400
From: Borislav Petkov <bp@alien8.de>
To: linux-edac <linux-edac@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH -v2 0/3] RAS: Correctable Errors Collector thing
Date: Thu, 12 Jun 2014 18:22:27 +0200
Message-Id: <1402590150-9798-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi all,

so here's v2 with the feedback from last time addressed (... hopefully).
This is ontop of Gong's extlog stuff which is currently a moving target
but I've based this stuff on it as we're starting slowly to relocate
generic RAS stuff into drivers/ras/.

A couple of points I was thinking about which we should talk about:

* This version automatically removes the oldest element from the array
when it gets full. With 512 PFNs max size, I think we should be ok.

* If CEC (let's call this thing that) can perform all RAS actions
needed/required, we should not forward correctable errors to userspace
because it simply doesn't need to. Unless there is something more we
want to do in userspace... we could make it configurable, dunno.
This version simply collects the errors and does the soft offlining,
thus issuing to dmesg something like this:

[  520.872376] RAS: Soft-offlining pfn: 0xdead
[  520.874384] soft offline: 0xdead page already poisoned

I'm not sure what we want to do with this info - we need to think about
it more but we're flexible there so... :-)

My main reasoning behind not forwarding each single correctable error
is that we don't want to upset the user unnecessarily and cause those
expensive support calls.

* Concerning policy and at which error count we should soft-offline a
page and whether we should make it configurable or not and what the
interface would be: we still don't know and we probably need to talk
about it too. Right now, using 10 bits for that count feels right. The
count gets decayed anyway.

But, do we need to run it on lotsa live systems and hear feedback?
Definitely.

* As to why we're putting this in the kernel and enabling it by default:
a userspace daemon is much more fragile than doing this in the kernel.
And regardless of distro, everyone gets this.

Constructive feedback is, as always, appreciated.

Thanks.

Borislav Petkov (3):
  MCE, CE: Corrected errors collecting thing
  MCE, CE: Wire in the CE collector
  MCE, CE: Add debugging glue

 arch/x86/kernel/cpu/mcheck/mce.c |  87 ++++++++++-
 drivers/ras/Kconfig              |  11 ++
 drivers/ras/Makefile             |   3 +-
 drivers/ras/ce.c                 | 309 +++++++++++++++++++++++++++++++++++++++
 include/linux/ras.h              |   2 +
 5 files changed, 403 insertions(+), 9 deletions(-)
 create mode 100644 drivers/ras/ce.c

-- 
2.0.0

