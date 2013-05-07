Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3EGWSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 18:18:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29382 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3EGWSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 18:18:05 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 0/5] PCI: Skip resource allocation for root bus without conresponding type resource
Date: Tue,  7 May 2013 15:17:29 -0700
Message-Id: <1367965054-9013-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367837311.15842.31.camel@pasglop>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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

First two are for 3.10, and others are targeted to 3.11

 PCI: Split pci_assign_unassigned_resources to per root bus
 PCI: Skip IORESOURCE_IO allocation for root bus without ioport range
 PCI: Skip IORESOURCE_MMIO allocation for root bus without MMIO range
 PCI: Enable pci bridge when it is needed
 PCI: Retry assign unassigned resources for hotadd root bus

Thanks

Yinghai
