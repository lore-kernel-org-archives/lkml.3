Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaJAQsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:48:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbaJAQsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:48:22 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/3] Revert MSI msg API churn
To: linux-pci@vger.kernel.org, bhelgaas@google.com
Cc: linux-kernel@vger.kernel.org, wangyijing@huawei.com
Date: Wed, 01 Oct 2014 10:48:16 -0600
Message-ID: <20141001163814.2709.92885.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSI message API has gone through some churn, that I think results
in an inconsistent interface.  We now have this:

void read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
void get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
void write_msi_msg(unsigned int irq, struct msi_msg *msg);

write_msi_msg() takes an irq arg, but read_msi_msg() takes an
msi_desc.  Presumably write_msi_msg() was not converted because it
has a much larger user base, but this sort of inconsitency results
in a poor API.

This series reverts a selection of commits to return us to:

void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg);
void write_msi_msg(unsigned int irq, struct msi_msg *msg);

I've left the removal of read_msi_msg() since it has no users, but
restored get_cached_msi_msg() since it has an imminent user.  This
will also cleanup the upcoming merge conflicts in next.  Thanks,

Alex

---

Alex Williamson (3):
      Revert "PCI/MSI: Remove unused get_cached_msi_msg()"
      Revert "PCI/MSI: Rename __get_cached_msi_msg() to get_cached_msi_msg()"
      Revert "PCI/MSI: Rename __read_msi_msg() to read_msi_msg()"


 arch/ia64/kernel/msi_ia64.c          |    2 +-
 arch/ia64/sn/kernel/msi_sn.c         |    2 +-
 arch/powerpc/platforms/pseries/msi.c |    2 +-
 arch/x86/kernel/apic/io_apic.c       |    2 +-
 arch/x86/pci/xen.c                   |    2 +-
 drivers/pci/msi.c                    |   11 +++++++++--
 include/linux/msi.h                  |    5 +++--
 7 files changed, 17 insertions(+), 9 deletions(-)
