Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaJ0IaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:30:00 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33596 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaJ0I37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:29:59 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: [PATCH 2/3] microblaze: Fix IO space breakage after of_pci_range_to_resource() change
Date: Mon, 27 Oct 2014 09:24:34 +0100
Message-Id: <70dcd942dc4af3cc6c3dcc2ba499cd841c7f65a7.1414398260.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <4cbbbb43d666468d87f99676cf05fb5154d1228b.1414398260.git.michal.simek@xilinx.com>
References: <4cbbbb43d666468d87f99676cf05fb5154d1228b.1414398260.git.michal.simek@xilinx.com>
In-Reply-To: <4cbbbb43d666468d87f99676cf05fb5154d1228b.1414398260.git.michal.simek@xilinx.com>
References: <4cbbbb43d666468d87f99676cf05fb5154d1228b.1414398260.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-25731-1414398285-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-25731-1414398285-0001

Commit 0b0b0893d49b "of/pci: Fix the conversion of IO ranges into IO
resources" changed the behaviour of of_pci_range_to_resource().

The issue is described here:
"powerpc/pci: Fix IO space breakage after of_pci_range_to_resource()
change"
(sha1: aeba3731b150188685225b510886f1370d8814de)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/microblaze/pci/pci-common.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 9037914f6985..b30e41c0c033 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -660,8 +660,13 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 			res = &hose->mem_resources[memno++];
 			break;
 		}
-		if (res != NULL)
-			of_pci_range_to_resource(&range, dev, res);
+		if (res != NULL) {
+			res->name = dev->full_name;
+			res->flags = range.flags;
+			res->start = range.cpu_addr;
+			res->end = range.cpu_addr + range.size - 1;
+			res->parent = res->child = res->sibling = NULL;
+		}
 	}

 	/* If there's an ISA hole and the pci_mem_offset is -not- matching
--
1.8.2.3


--=_mimegpg-monstr-desktop-25731-1414398285-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlROAU0ACgkQykllyylKDCE9LQCfZhIG5QFytSNPN9glHyI6jnbb
ZhwAnA5jqaItgKHAVCALg8KzjEDWs0yD
=R4ua
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-25731-1414398285-0001--
