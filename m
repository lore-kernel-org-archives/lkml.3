Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab3JIXZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:25:10 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:48094 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab3JIXZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:25:07 -0400
Date: Wed, 9 Oct 2013 17:25:02 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexey Neyman <stilor@att.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Feng Tang <feng.tang@intel.com>, Yijing Wang <wangyijing@huawei.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] Fix coalescing host bridge windows in arch/x86/pci/acpi.c
Message-ID: <20131009232502.GA3837@google.com>
References: <6362938.J7ZtNEOFpc@mistral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6362938.J7ZtNEOFpc@mistral>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Sun, Sep 22, 2013 at 11:15:46PM -0700, Alexey Neyman wrote:
> [Resending due to no response to the original message in a week]
> 
> Hi all,
> 
> I have a board with a BIOS bug that reports the following I/O port regions in 
> _CRS on one of the host bridges:
> 
> 0x0000-0x03af // #0
> 0x03e0-0x0cf7 // #1
> 0x03b0-0x03bb // #2
> 0x03c0-0x03df // #3
> 0x0000-0xdfff // #4
> 0xf000-0xffff // #5
> 
> Obviously, region number #4 is erroneous as it overlaps with regions #0..3. 
> The code in coalesce_windows() in arch/x86/pci/acpi.c attempts to recover from 
> such kind of BIOS bugs by merging the overlapping regions. Current code 
> expands region #0 to 0x0000-0xdffff and makes region #4 ignored. As a result, 
> overlap of the expanded region #0 with regions #1..3 remains undetected (as 
> the inner loop already compared them with region #0). As a result, regions 
> #1..3 are inserted into the resource tree even though they overlap with 
> adjusted region #0 - which later results in resource conflicts for PCI devices 
> with IO ports in one of those regions (e.g., for an PCI IDE controller in 
> legacy mode - which has port 0x3f6). The kernel then refuses to initialize 
> these devices.
> 
> The fix: instead of expanding res1 and ignoring res2, do the opposite. The 
> res2 window is yet to be compared against all windows between res1 and res2 
> (regions #1..3 in the above example), so the resulting resource map will 
> include just the expanded region - and will ignore any overlapping ones.
> 
> Signed-off-by: Alexey Neyman <stilor@att.net>

I added the bugzilla reference (thanks for that) and applied the
following patch to my pci/misc branch for v3.13.

Sorry this took so long; part of the reason was that it wasn't on
linux-pci, so it didn't show up in the PCI patchwork.  I also added
a MAINTAINERS patch so in the future, get_maintainers.pl will include
linux-pci and me as co-maintainer of arch/x86/pci/*.  Also, it helps
if you include the patch in-line rather than as an attachment because
I have to manually combine the in-line changelog with the attached
patch.

Thanks for the fix and your persistence!

Bjorn


x86/PCI: Coalesce multiple overlapping host bridge windows

From: Alexey Neyman <stilor@att.net>

Previously we coalesced windows by expanding the first overlapping one and
making the second invalid.  But we never look at the expanded first window
again, so we fail to notice other windows that overlap it.  For example, we
coalesced these:

  [io  0x0000-0x03af] // #0
  [io  0x03e0-0x0cf7] // #1
  [io  0x0000-0xdfff] // #2

into these, which still overlap:

  [io  0x0000-0xdfff] // #0
  [io  0x03e0-0x0cf7] // #1

The fix is to expand the *second* overlapping resource and ignore the
first, so we get this instead with no overlaps:

  [io  0x0000-0xdfff] // #2

[bhelgaas: changelog]
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=62511
Signed-off-by: Alexey Neyman <stilor@att.net>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/pci/acpi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index b30e937..7fb24e5 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -354,12 +354,12 @@ static void coalesce_windows(struct pci_root_info *info, unsigned long type)
 			 * the kernel resource tree doesn't allow overlaps.
 			 */
 			if (resource_overlaps(res1, res2)) {
-				res1->start = min(res1->start, res2->start);
-				res1->end = max(res1->end, res2->end);
+				res2->start = min(res1->start, res2->start);
+				res2->end = max(res1->end, res2->end);
 				dev_info(&info->bridge->dev,
 					 "host bridge window expanded to %pR; %pR ignored\n",
-					 res1, res2);
-				res2->flags = 0;
+					 res2, res1);
+				res1->flags = 0;
 			}
 		}
 	}
