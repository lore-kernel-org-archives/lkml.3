Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaEUXSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:18:03 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:58047 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaEUXR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:17:59 -0400
Subject: [PATCH V5 0/4] x86/pci Fix numa_node info for AMD hostbridge and
 misc clean up
To: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Robert Richter <rric@kernel.org>, Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        linux-pci@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Myron Stowe <myron.stowe@redhat.com>
Date: Wed, 21 May 2014 17:17:57 -0600
Message-ID: <20140521231615.26447.38060.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <1399567461-15928-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1399567461-15928-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resending because I forgot to copy the lists, sorry guys]

Hi Suravee,

Sorry it took me so long to get to these patches.  Here's my proposal.  I
reordered them and added some comments in the code and changelogs, but I
think your patches look fine as-is.

So I just need comments on these two significant changes:

  1) I added a patch to stop enabling ECS after Fam16h, because that's
  another case of CPU-dependent code that we should not need to keep
  carrying.  I don't think there are any post-Fam16h CPUs yet, but I
  certainly don't want to do anything that will keep them from working when
  they do arrive.  It would be useful if somebody could test this on
  current platforms by tweaking the patch so we don't enable ECS on Fam15h.

  2) I dropped the quirk_amd_nb_node() removal.  I could be convinced
  otherwise, but I don't really object to the quirk because it is already
  explicitly limited to specific devices, and removing it will change
  things in sysfs.  I think the changes would be harmless as far as the
  kernel is concerned, since there are no drivers for these devices.  But
  Andreas added the quirk because of complaints, so apparently somebody is
  looking at what's in sysfs, and I don't want to get the same complaints
  again by removing it.  However, I will certainly ask questions if I see
  the quirk being extended to more devices.

The AMD BKDG does say the BIOS should provide an MCFG table (sec 2.8 of
42301), so I think it provides guidance matching the intent of my "stop
enabling ECS" patch.  But the BKDG doesn't mention _PXM at all.  Is there
any chance you could squeeze in a mention of that, so BIOS writers know
that they *should* provide it?  I want to avoid more fire-drills in the
future.

Bjorn

---

Bjorn Helgaas (1):
      x86/PCI: Stop enabling ECS for AMD CPUs after Fam16h

Myron Stowe (1):
      x86/PCI: Warn if we have to "guess" host bridge node information

Suravee Suthikulpanit (2):
      x86/PCI: Work around AMD Fam15h BIOSes that fail to provide _PXM
      x86/PCI: Clean up and mark early_root_info_init() as deprecated


 arch/x86/pci/acpi.c    |    6 +++
 arch/x86/pci/amd_bus.c |   87 +++++++++++++++++++++++++++++++-----------------
 2 files changed, 62 insertions(+), 31 deletions(-)
