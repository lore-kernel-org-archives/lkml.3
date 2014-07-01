Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbaGATXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:23:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44278 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaGATXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:23:50 -0400
From: Borislav Petkov <bp@alien8.de>
To: linux-edac <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -v3 0/4] RAS: Correctable Errors Collector thing
Date: Tue,  1 Jul 2014 21:23:39 +0200
Message-Id: <1404242623-10094-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Ok,

the next version.

Main changes from the last one are that we have a ce_ring now to which
MCEs get logged in atomic context first and then, in process context,
put into the CEC, just like this is done with the mce_ring.

Also, the decay of the elements in the CEC happens not after CLEAN_ELEMS
insertions of new elements only but the incrementation of an already
inserted element counts too. We want to do that because otherwise we're
not fair in aging the elements.

Constructive feedback is, as always, appreciated.

Thanks.

Changelog:

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

Borislav Petkov (4):
  x86, MCE: Make the mce_ring explicit
  RAS: Add a Corrected Errors Collector
  MCE, CE: Wire in the CE collector
  MCE, CE: Add debugging glue

 arch/x86/kernel/cpu/mcheck/mce.c | 132 +++++++++++++---
 drivers/ras/Kconfig              |  11 ++
 drivers/ras/Makefile             |   3 +-
 drivers/ras/ce.c                 | 322 +++++++++++++++++++++++++++++++++++++++
 include/linux/ras.h              |   3 +
 5 files changed, 450 insertions(+), 21 deletions(-)
 create mode 100644 drivers/ras/ce.c

-- 
2.0.0

