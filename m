Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3I1HOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 03:14:06 -0400
Received: from nm20-vm2.access.bullet.mail.gq1.yahoo.com ([216.39.63.48]:41821
	"EHLO nm20-vm2.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557Ab3I1HOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 03:14:03 -0400
X-Yahoo-Newman-Id: 809565.78504.bm@smtp111.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4pe2_m4VM1m2YkSSdZ9he3sPWdTyJDiOH1YwFdmiHS1nwhm
 d8sgtjelM6wSrt3V8tAUYI84gSpR9Sk_XbxzvTVBd5X_Oj7IRSV8lwogdZh4
 dDNDTnPCWIgi796RLhEnwz33OIGu2a_cd5LvOpEbfugXy1.PWWJ3plNo3H2M
 GBS9IwVFPWOnVVYWZWUq0Trf7ecJh8wViifPN4tthM8bLbpeEZ9B1W55sqAk
 VbGmey0qBjNGE8onABwScPYbNtzLPMw.tWZDOs0AUqeyjY4GwPQmNutsQpvf
 J3bI7ijROGUqfbq7AhtT.TJNROEE.Qi0Dog894dItMOtmIyyTDMyI7l0N9Ul
 ij1_.Sz6KnunauicIjsXP2Nd0NYBWHaouDIJl47wx6DJIiLNW.yzdILBNYQu
 DRLoSDaXCvZ1r7GIdSe3i3wIZADbeF5yLJpSDwhCQ0gJ.5kJIkoEcqY.w6t1
 p7d81TjdnYqas8o_r4Gi4MqUGRJuyIR3PlyXpPH24ZYQmCKSXwcY_uScpc7h
 DK4LT7VdsZUU1buEf4Ba49DCm0L3Cu66RdHCIJvi0eVns.w--
X-Yahoo-SMTP: 0h0Q7euswBD_g.kcEqbzJWRFfrba801gq1M1
X-Rocket-Received: from mistral.localnet (stilor@107.201.4.7 with )
        by smtp111.sbc.mail.gq1.yahoo.com with SMTP; 28 Sep 2013 07:12:49 +0000 UTC
From: Alexey Neyman <stilor@att.net>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Feng Tang <feng.tang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix coalescing host bridge windows in arch/x86/pci/acpi.c
Date: Sat, 28 Sep 2013 00:12:48 -0700
Message-ID: <5636839.b8jCOluuC9@mistral>
User-Agent: KMail/4.10.4 (Linux/3.8.0-25-generic; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52410B49.3050306@huawei.com>
References: <6362938.J7ZtNEOFpc@mistral> <52410B49.3050306@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1517953.bn3pKdYLIi"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart1517953.bn3pKdYLIi
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday, September 24, 2013 11:47:21 AM Yijing Wang wrote:
> On 2013/9/23 14:15, Alexey Neyman wrote:
> > [Resending due to no response to the original message in a week]
> > 
> > Hi all,
> > 
> > I have a board with a BIOS bug that reports the following I/O port regions
> > in _CRS on one of the host bridges:
> > 
> > 0x0000-0x03af // #0
> > 0x03e0-0x0cf7 // #1
> > 0x03b0-0x03bb // #2
> > 0x03c0-0x03df // #3
> > 0x0000-0xdfff // #4
> > 0xf000-0xffff // #5
> > 
> > Obviously, region number #4 is erroneous as it overlaps with regions
> > #0..3.
> > The code in coalesce_windows() in arch/x86/pci/acpi.c attempts to recover
> > from such kind of BIOS bugs by merging the overlapping regions. Current
> > code expands region #0 to 0x0000-0xdffff and makes region #4 ignored. As
> > a result, overlap of the expanded region #0 with regions #1..3 remains
> > undetected (as the inner loop already compared them with region #0). As a
> > result, regions #1..3 are inserted into the resource tree even though
> > they overlap with adjusted region #0 - which later results in resource
> > conflicts for PCI devices with IO ports in one of those regions (e.g.,
> > for an PCI IDE controller in legacy mode - which has port 0x3f6). The
> > kernel then refuses to initialize these devices.
> > 
> > The fix: instead of expanding res1 and ignoring res2, do the opposite. The
> > res2 window is yet to be compared against all windows between res1 and
> > res2
> > (regions #1..3 in the above example), so the resulting resource map will
> > include just the expanded region - and will ignore any overlapping ones.
> > 
> > Signed-off-by: Alexey Neyman <stilor@att.net>
> 
> It looks fine to me, but I have no platform to test it. :)

Thanks for a review. Could anybody push it into the tree? :)
For convenience, patch attached again.

Regards,
Alexey.
--nextPart1517953.bn3pKdYLIi
Content-Disposition: attachment; filename="acpi.c.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="acpi.c.diff"

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

--nextPart1517953.bn3pKdYLIi--

