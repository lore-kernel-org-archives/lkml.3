Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab3EVGjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:39:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28349 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab3EVGjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:39:07 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 0/8] PCI: Skip resource allocation for root bus without conresponding type resource
Date: Tue, 21 May 2013 23:38:40 -0700
Message-Id: <1369204728-11165-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367837311.15842.31.camel@pasglop>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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

Current retry logic is : try with must+optional at first, and if
it fails will try must then try to extend must with optional.
That will fail as mmio-non-pref and mmio-pref for bridge will
be next to each other. So we have no chance to extend mmio-non-pref.

This will be become more often when we have x86 8 sockets or 32 sockets
system, and those system will have one root bus per socket.
They will have some root buses do not have ioport range.

We should not fall into retry in this case, as root bus does
not io port range.

We check if the root bus has ioport range, and set bus_res_type_mask,
and pass it to assign_resources and don't add ioport res to failed list
for root bus that does not have ioport range.
So even BIOS set wrong value to pci devices and bridges will still
get cleared.

Then also check mmio-nonpref resource for root buses.

First five are for 3.10, and others are targeted to 3.11

-v4: split first patch into 4 patches per Bjorn.

 PCI: Don't use temp bus for pci_bus_release_bridge_resources
 PCI: Use pci_walk_bus to detect unassigned resources
 PCI: Introduce enable_local to prepare per root bus handling
 PCI: Split pci_assign_unassigned_resources to per root bus
 PCI: Skip IORESOURCE_IO allocation for root bus without ioport range
 PCI: Skip IORESOURCE_MMIO allocation for root bus without MMIO range
 PCI: Enable pci bridge when it is needed
 PCI: Retry assign unassigned resources for hotadd root bus

Thanks

Yinghai
