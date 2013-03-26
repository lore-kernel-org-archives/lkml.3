Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3CZSTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:19:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3CZSS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:18:59 -0400
Subject: [PATCH 0/2] vfio-pci: Enable devices using unassigned config space
To: alex.williamson@redhat.com, shangw@linux.vnet.ibm.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Tue, 26 Mar 2013 12:16:56 -0600
Message-ID: <20130326180454.27467.7011.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gavin Shan reported that be2net devices don't work under vfio-pci
because they attempt to make use of device registers hidden among the
gaps in PCI config space.  I imagine this is a violation of the PCI
specification, but if we want to allow such devices to work we need
to enable access.  In reality, config space registers are no different
from MMIO or I/O port registers, which are already unregulated.

The trouble is that we map config space regions using a byte per dword
because everything in config space is dword aligned... everything
except the length.  This leads to a latent bug where capabilities that
do not end at a dword boundary get rounded down, preventing access to
those last few bytes.  Therefore, we first need to enable byte
granularity of config space, then add an accessor for unassigned
regions.

Gavin, I'd appreciate if you're able to test this against the be2net
to verify that it resolves the problem.  Thanks,

Alex

---

Alex Williamson (2):
      vfio-pci: Use byte granularity in config map
      vfio-pci: Enable raw access to unassigned config space


 drivers/vfio/pci/vfio_pci_config.c |  166 ++++++++++++++++++++----------------
 1 file changed, 93 insertions(+), 73 deletions(-)
