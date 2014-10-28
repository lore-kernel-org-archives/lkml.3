Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657AbaJ1HMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:12:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45349 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaJ1DpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:45:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3.16 059/127] PCI: mvebu: Fix uninitialized variable in mvebu_get_tgt_attr()
Date: Tue, 28 Oct 2014 11:34:54 +0800
Message-Id: <20141028033423.452644850@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 56fab6e189441d714a2bfc8a64f3df9c0749dff7 upstream.

Geert Uytterhoeven reported a warning when building pci-mvebu:

  drivers/pci/host/pci-mvebu.c: In function 'mvebu_get_tgt_attr':
  drivers/pci/host/pci-mvebu.c:887:39: warning: 'rtype' may be used uninitialized in this function [-Wmaybe-uninitialized]
     if (slot == PCI_SLOT(devfn) && type == rtype) {
					 ^

And indeed, the code of mvebu_get_tgt_attr() may lead to the usage of rtype
when being uninitialized, even though it would only happen if we had
entries other than I/O space and 32 bits memory space.

This commit fixes that by simply skipping the current DT range being
considered, if it doesn't match the resource type we're looking for.

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/host/pci-mvebu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -873,7 +873,7 @@ static int mvebu_get_tgt_attr(struct dev
 	rangesz = pna + na + ns;
 	nranges = rlen / sizeof(__be32) / rangesz;
 
-	for (i = 0; i < nranges; i++) {
+	for (i = 0; i < nranges; i++, range += rangesz) {
 		u32 flags = of_read_number(range, 1);
 		u32 slot = of_read_number(range + 1, 1);
 		u64 cpuaddr = of_read_number(range + na, pna);
@@ -883,14 +883,14 @@ static int mvebu_get_tgt_attr(struct dev
 			rtype = IORESOURCE_IO;
 		else if (DT_FLAGS_TO_TYPE(flags) == DT_TYPE_MEM32)
 			rtype = IORESOURCE_MEM;
+		else
+			continue;
 
 		if (slot == PCI_SLOT(devfn) && type == rtype) {
 			*tgt = DT_CPUADDR_TO_TARGET(cpuaddr);
 			*attr = DT_CPUADDR_TO_ATTR(cpuaddr);
 			return 0;
 		}
-
-		range += rangesz;
 	}
 
 	return -ENOENT;


