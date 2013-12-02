Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3LBRnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:43:47 -0500
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:49542 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752668Ab3LBRnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:43:43 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1981:2194:2197:2199:2200:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3354:3503:3504:3505:3653:3865:3866:3867:3868:3870:3871:4250:4321:4605:5007:6119:7652:7875:10004:10400:10848:11026:11232:11473:11658:11914:12043:12114:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSB
X-HE-Tag: judge06_1fb84e6660437
X-Filterd-Recvd-Size: 4175
Message-ID: <1386006217.2680.13.camel@joe-AO722>
Subject: [PATCH] pci/checkpatch: Deprecate DEFINE_PCI_DEVICE_TABLE
From: Joe Perches <joe@perches.com>
To: Jonas Bonn <jonas@southpole.se>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Guenter Roeck'" <linux@roeck-us.net>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Andy Whitcroft'" <apw@canonical.com>, linux-serial@vger.kernel.org
Date: Mon, 02 Dec 2013 09:43:37 -0800
In-Reply-To: <529C6495.3020305@southpole.se>
References: <000601ceebdc$ee148de0$ca3da9a0$%han@samsung.com>
	 <20131128040750.GA29917@kroah.com>
	 <006001ceebfa$c85a1020$590e3060$%han@samsung.com>
	 <1385617213.12210.5.camel@joe-AO722> <20131128055328.GA565@kroah.com>
	 <1385619863.12210.14.camel@joe-AO722> <529C026E.2000302@roeck-us.net>
	 <000f01ceef11$a14acf00$e3e06d00$%han@samsung.com>
	 <529C04C7.9050506@roeck-us.net>
	 <001001ceef13$7fa3ee70$7eebcb50$%han@samsung.com>
	 <1385963295.2680.2.camel@joe-AO722> <529C6495.3020305@southpole.se>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prefer use of the direct definition of struct pci_device_id
instead of indirection via macro DEFINE_PCI_DEVICE_TABLE.

Update the PCI documentation to deprecate DEFINE_PCI_DEVICE_TABLE.
Update checkpatch adding --fix option.

Signed-off-by: Joe Perches <joe@perches.com>
---
 Documentation/PCI/pci.txt |  6 ++++--
 include/linux/pci.h       |  3 +--
 scripts/checkpatch.pl     | 11 +++++++----
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/Documentation/PCI/pci.txt b/Documentation/PCI/pci.txt
index 6f45856..9518006 100644
--- a/Documentation/PCI/pci.txt
+++ b/Documentation/PCI/pci.txt
@@ -123,8 +123,10 @@ initialization with a pointer to a structure describing the driver
 
 
 The ID table is an array of struct pci_device_id entries ending with an
-all-zero entry; use of the macro DEFINE_PCI_DEVICE_TABLE is the preferred
-method of declaring the table.  Each entry consists of:
+all-zero entry.  Definitions with static const are generally preferred.
+Use of the deprecated macro DEFINE_PCI_DEVICE_TABLE should be avoided.
+
+Each entry consists of:
 
 	vendor,device	Vendor and device ID to match (or PCI_ANY_ID)
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1084a15..88674b0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -634,8 +634,7 @@ struct pci_driver {
  * DEFINE_PCI_DEVICE_TABLE - macro used to describe a pci device table
  * @_table: device table name
  *
- * This macro is used to create a struct pci_device_id array (a device table)
- * in a generic manner.
+ * This macro is deprecated and should not be used in new code.
  */
 #define DEFINE_PCI_DEVICE_TABLE(_table) \
 	const struct pci_device_id _table[]
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 38be5d5..6f883f0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2643,10 +2643,13 @@ sub process {
 			}
 		}
 
-# check for declarations of struct pci_device_id
-		if ($line =~ /\bstruct\s+pci_device_id\s+\w+\s*\[\s*\]\s*\=\s*\{/) {
-			WARN("DEFINE_PCI_DEVICE_TABLE",
-			     "Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id\n" . $herecurr);
+# check for uses of DEFINE_PCI_DEVICE_TABLE
+		if ($line =~ /\bDEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=/) {
+			if (WARN("DEFINE_PCI_DEVICE_TABLE",
+				 "Prefer struct pci_device_id over deprecated DEFINE_PCI_DEVICE_TABLE\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/\b(?:static\s+|)DEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=\s*/static const struct pci_device_id $1\[\] = /;
+			}
 		}
 
 # check for new typedefs, only function parameters and sparse annotations


