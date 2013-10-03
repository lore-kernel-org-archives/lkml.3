Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3JCSo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:44:27 -0400
Received: from nm4-vm2.access.bullet.mail.gq1.yahoo.com ([216.39.63.32]:21864
	"EHLO nm4-vm2.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754593Ab3JCSoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:44:25 -0400
X-Yahoo-Newman-Id: 504065.51186.bm@smtp114.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: JsoaVmgVM1lQ2cSUUmiPXT0uRMRsONnVQEOT1c5GRsf6Gvc
 4gNVVnu.JxrwQOcYpG8igTOR87GpYtA0regvASv10VKCjW3Mj0JBrlBHaQlc
 uzEUMhd5igMlgKVgXDhJ7APLJiAVdYIekCrh89Pt0t8aEEtYpX8MjrlBXZXq
 3p_FofCSkGG1Z5SMZ0zl8RV4tgz7akm1a7tMWJxIH_G5H4OtMLNTcsEkckfJ
 dKXZ5lbnU9MQaIG_RWKbIMJWzD2iiKWAFdo3rH8fVU9In6hhTbkVe0Sk5wPx
 j1Gf.IL7oIKKPAf7Rt0txoO1D3xYdMqDLlsBWfLc8HkQ3VmfE9JSAywNIE8Q
 Dt1w5gU.b8Vlsm_tJ3OsVO_PgMNqlkddv8tzbcZXPSd_5sBj2Si3FqQblBS3
 r7eXxr85KxByAaL4XyTzG1M0q6oP34GqFa5UZoqv4T6_vvS7iRm4i.P9Hq7a
 _DqRFXC3Y4gu14RbbTm6nQK3ziGFS5GKn63To8xkqciNjmUXR9CEwk0dc4.K
 Fs0MZFp62ma.3HULEJ1W8A65Cg76y254XC9wtCNG5ciGCjm4rNRVpxJcCCQ-
 -
X-Yahoo-SMTP: 0h0Q7euswBD_g.kcEqbzJWRFfrba801gq1M1
X-Rocket-Received: from mistral.localnet (stilor@216.100.252.242 with )
        by smtp114.sbc.mail.gq1.yahoo.com with SMTP; 03 Oct 2013 11:44:24 -0700 PDT
From: Alexey Neyman <stilor@att.net>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Feng Tang <feng.tang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] Fix coalescing host bridge windows in arch/x86/pci/acpi.c
Date: Thu, 03 Oct 2013 11:44:23 -0700
Message-ID: <1569389.72Ab6LcEbn@mistral>
User-Agent: KMail/4.10.4 (Linux/3.8.0-25-generic; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52410B49.3050306@huawei.com>
References: <6362938.J7ZtNEOFpc@mistral> <52410B49.3050306@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2999110.gUrYDbNVgY"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart2999110.gUrYDbNVgY
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

[Patch ping #4...]

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
--nextPart2999110.gUrYDbNVgY
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

--nextPart2999110.gUrYDbNVgY--

