Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab3FAGDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 02:03:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25635 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3FAGDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 02:03:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 0/7] PCI: Change assign unassigned resources per root bus bassis
Date: Fri, 31 May 2013 23:03:06 -0700
Message-Id: <1370066593-22736-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367837311.15842.31.camel@pasglop>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BenH reported that there is some assign unassigned resource problem
in powerpc.

It turns out after
| commit 0c5be0cb0edfe3b5c4b62eac68aa2aa15ec681af
| Date:   Thu Feb 23 19:23:29 2012 -0800
|
|    PCI: Retry on IORESOURCE_IO type allocations

even the root bus does not have io port range, it will keep retrying
to realloc with mmio.

After checking the code, found that we bound io port and mmio fail
path together.
First patch fix the problem, that will not make mmio fall back to must-only
when only have io port fail with must+optional.

During we found the fix for that problem, found that we can separate assign
unassigned resources to per root bus.
that will make the code simple, also could reuse it for hotadd path.

These patches are targeted to 3.11

-v4: split first patch into 4 patches per Bjorn.
-v5: drop two patches that will pass root bus resource mask after we found
     simple and less intrusive way to fix the problem.

 PCI: Don't let mmio fallback to must-only, if ioport fails with must+optional
 PCI: Don't use temp bus for pci_bus_release_bridge_resources
 PCI: Use pci_walk_bus to detect unassigned resources
 PCI: Introduce enable_local to prepare per root bus handling
 PCI: Split pci_assign_unassigned_resources to per root bus
 PCI: Enable pci bridge when it is needed
 PCI: Retry assign unassigned resources for hotadd root bus

Thanks

Yinghai
