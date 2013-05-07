Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab3EGPcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:32:48 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:57148 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757507Ab3EGPc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:32:29 -0400
From: Andrew Murray <Andrew.Murray@arm.com>
To: robherring2@gmail.com
Cc: benh@kernel.crashing.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, jgunthorpe@obsidianresearch.com,
        linux@arm.linux.org.uk, siva.kallam@samsung.com,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        jg1.han@samsung.com, Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        bhelgaas@google.com, suren.reddy@samsung.com,
        linux-arm-kernel@lists.infradead.org, monstr@monstr.eu,
        paulus@samba.org, thomas.petazzoni@free-electrons.com,
        thierry.reding@avionic-design.de, thomas.abraham@linaro.org,
        arnd@arndb.de, linus.walleij@linaro.org, juhosg@openwrt.org,
        grant.likely@linaro.org, Andrew Murray <Andrew.Murray@arm.com>
Subject: [PATCH v9 0/3] of/pci: Provide common support for PCI DT parsing
Date: Tue,  7 May 2013 16:31:11 +0100
Message-Id: <1367940674-11987-1-git-send-email-Andrew.Murray@arm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset factors out duplicated code associated with parsing PCI
DT "ranges" properties across the architectures and introduces a
"ranges" parser. This parser "of_pci_range_parser" can be used directly
by ARM host bridge drivers enabling them to obtain ranges from device
trees.

I've included the Reviewed-by, Tested-by and Acked-by's received from
v5/v6/v7/v8 in this patchset, earlier versions of this patchset (v3) have been
tested-by:

Thierry Reding <thierry.reding@avionic-design.de>
Jingoo Han <jg1.han@samsung.com>

I've tested that this patchset builds and runs on ARM and that it builds on
PowerPC, x86_64, MIPS and Microblaze.

Compared to the v8 sent by Andrew Murray, the following changes have been made
(please note that the MIPS patch is unchanged from v8):

 * Remove the unification of pci_process_bridge_OF_ranges between PowerPC and
   Microblaze. Feedback from Bjorn and Benjamin (along with a NAK) suggested
   that this goes against their future direction (using more of struct
   pci_host_bridge and less of arch specific struct pci_controller).

Compared to the v7 sent by Andrew Murray, the following changes have been made
(please note that the first patch is unchanged from v7):

 * Rename of_pci_range_parser to of_pci_range_parser_init and
   of_pci_process_ranges to of_pci_range_parser_one as suggested by Grant
   Likely.

 * Reverted back to using a switch statement instead of if/else in
   pci_process_bridge_OF_ranges. Grant Likely highlighted this change from
   the original code which was unnecessary.

 * Squashed in a patch provided by Gabor Juhos which fixes build errors on
   MIPS found in the last patchset.

Compared to the v6 sent by Andrew Murray, the following changes have
been made in response to build errors/warnings:

 * Inclusion of linux/of_address.h in of_pci.c as suggested by Michal
   Simek to prevent compilation failures on Microblaze (and others) and his
   ack.

 * Use of externs, static inlines and a typo in linux/of_address.h in response
   to linker errors (multiple defination) on x86_64 as spotted by a kbuild test
   robot on (jcooper/linux.git mvebu/drivers)

 * Add EXPORT_SYMBOL_GPL to of_pci_range_parser function to be consistent
   with of_pci_process_ranges function

Compared to the v5 sent by Andrew Murray, the following changes have
been made:

 * Use of CONFIG_64BIT instead of CONFIG_[a32bitarch] as suggested by
   Rob Herring in drivers/of/of_pci.c

 * Added forward declaration of struct pci_controller in linux/of_pci.h
   to prevent compiler warning as suggested by Thomas Petazzoni

 * Improved error checking (!range check), removal of unnecessary be32_to_cpup
   call, improved formatting of struct of_pci_range_parser layout and
   replacement of macro with a static inline. All suggested by Rob Herring.

Compared to the v4 (incorrectly labelled v3) sent by Andrew Murray,
the following changes have been made:

 * Split the patch as suggested by Rob Herring

Compared to the v3 sent by Andrew Murray, the following changes have
been made:

 * Unify and move duplicate pci_process_bridge_OF_ranges functions to
   drivers/of/of_pci.c as suggested by Rob Herring

 * Fix potential build errors with Microblaze/MIPS

Compared to "[PATCH v5 01/17] of/pci: Provide support for parsing PCI DT
ranges property", the following changes have been made:

 * Correct use of IORESOURCE_* as suggested by Russell King

 * Improved interface and naming as suggested by Thierry Reding

Compared to the v2 sent by Andrew Murray, Thomas Petazzoni did:

 * Add a memset() on the struct of_pci_range_iter when starting the
   for loop in for_each_pci_range(). Otherwise, with an uninitialized
   of_pci_range_iter, of_pci_process_ranges() may crash.

 * Add parenthesis around 'res', 'np' and 'iter' in the
   for_each_of_pci_range macro definitions. Otherwise, passing
   something like &foobar as 'res' didn't work.

 * Rebased on top of 3.9-rc2, which required fixing a few conflicts in
   the Microblaze code.

v2:
  This follows on from suggestions made by Grant Likely
  (marc.info/?l=linux-kernel&m=136079602806328)

Andrew Murray (3):
  of/pci: Provide support for parsing PCI DT ranges property
  of/pci: mips: convert to common of_pci_range_parser
  of/pci: microblaze: convert to common of_pci_range_parser

 arch/microblaze/pci/pci-common.c |  106 ++++++++++++++------------------------
 arch/mips/pci/pci.c              |   50 ++++++-----------
 drivers/of/address.c             |   67 ++++++++++++++++++++++++
 include/linux/of_address.h       |   48 +++++++++++++++++
 4 files changed, 171 insertions(+), 100 deletions(-)

