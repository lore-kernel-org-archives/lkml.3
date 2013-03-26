Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933799Ab3CZCoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 22:44:16 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:1471 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab3CZCoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 22:44:15 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Tony Luck <tony.luck@intel.com>
CC: <linux-kernel@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v5 0/5] Fix aer_inject tool bug 
Date: Tue, 26 Mar 2013 10:43:34 +0800
Message-ID: <1364265819-6732-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,
   Can you pick up these bug fix patches into your ras tree? I sent them to PCI subsystem maillist, but Bjorn does not seem 
very interested in these aer_inject tool bug fix patches. Huang Ying <ying.huang@intel.com> is the author of aer_inject tool.
And I had a long discussion with Huang Ying about these patches, and got his reviewed-by. I do not know what people are really 
interested in these patches, So I try to send them to you. Thank you very much!

This series of patch mainly to fix the aer_inject bug described as below:

-+-[0000:40]-+-00.0-[0000:41]--
 |           +-01.0-[0000:42]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
 |           |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
 |           +-03.0-[0000:43]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
 |           +-04.0-[0000:44]--
 |           +-05.0-[0000:45]--
 |           +-07.0-[0000:46-49]----00.0-[0000:47-49]--+-02.0-[0000:48]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
 |           |                                         |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
 |           |                                         \-04.0-[0000:49]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
 |           |                                                           \-00.1  Intel Corporation 82576 Gigabit Network Connection

my steps:
1)modprobe aer_inject
2)inject aer errors to pcie device 0000:48:00.0
3)modprobe pciehp
4)hot remove Network Card in slot(port 0000:40:07.0)
5)hot add Network Card in slot(port 0000:40:07.0)
6)system panic

in step 2) the pci_ops of bus 0000:48 and bus 0000:40 will be assigned to pci_ops_aer
in step 5) the pci_ops of the newly created bus 0000:46 will be assigned to pci_ops_aer(inherited by parent pci_ops),
but this pci_ops(0000:46) is not tracked in pci_bus_ops_list in aer_inject module. So every access to pci_config space
by pci_ops of 0000:46 will cause system panic, Since pci_ops_aer cannot find its original pci_ops, thus , a NULL pci_ops return;

The first patch fix this bug by finding parent pci_ops(tracked in pci_ops_list) instead of returning NULL in step 5);
The second patch fix a small race condition window in aer_inject_exit;
The Third patch to find and clean all untracked pci_ops_aer in system when aer_inject module exit
The rest two patch mainly about to clean bus_ops;

Yijing Wang (5):
  PCI/AER: Fix pci_ops return NULL in pci_read/write_aer
  PCI/AER: use list_for_each_entry to avoid a small race condition
    window
  PCI/AER: clean all untracked pci_ops_aer when rmmod aer_inject
  PCI/AER: clean pci_bus_ops when related pci bus was removed
  PCI/AER: free pci_bus_ops_list and remove pci_bus_ops_pop

 drivers/pci/pcie/aer/aer_inject.c |  123 +++++++++++++++++++++++++++++++------
 1 files changed, 103 insertions(+), 20 deletions(-)


