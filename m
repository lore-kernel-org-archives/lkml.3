Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbaIQO7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:59:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621AbaIQO7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:59:45 -0400
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, jbeulich@suse.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V3] xen: remove some memory limits from pv-domains
Date: Wed, 17 Sep 2014 16:59:40 +0200
Message-Id: <1410965981-15444-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a Xen pv-domain is booted the initial memory map contains multiple
objects in the top 2 GB including the initrd and the p2m list. This
limits the supported maximum size of the initrd and the maximum
memory size the p2m list can span is limited to about 500 GB.

Xen however supports loading the initrd without mapping it and the
initial p2m list can be mapped by Xen to an arbitrary selected virtual
address. The following patches activate those options and thus remove
the limitations.

It should be noted that the p2m list limitation isn't only affecting
the amount of memory a pv domain can use, but it also hinders Dom0 to
be started on physical systems with larger memory without reducing it's
memory via a Xen boot parameter. By mapping the initial p2m list to
an area not in the top 2 GB it is now possible to boot Dom0 on such
systems.

It would be desirable to be able to use more than 512 GB in a pv
domain, but this would require a reorganization of the p2m tree built 
by the kernel at boot time. As this reorganization would affect the
Xen tools and kexec, too, it is not included in this patch set. This
topic can be addressed later.

Changes since V2:
- 2 patches dropped, as they are already applied
- added helper function and updated comment and patch description as
  requested by David Vrabel

Juergen Gross (1):
  xen: eliminate scalability issues from initial mapping setup

 arch/x86/xen/mmu.c      | 119 +++++++++++++++++++++++++++++++++++++++++++++---
 arch/x86/xen/setup.c    |  65 ++++++++++++++------------
 arch/x86/xen/xen-head.S |   2 +
 3 files changed, 151 insertions(+), 35 deletions(-)

-- 
1.8.4.5

