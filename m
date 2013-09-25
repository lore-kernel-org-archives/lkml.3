Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab3IYBJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:09:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab3IYAQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [ 050/110] x86, amd_nb: Clarify F15h, model 30h GART and L3 support
Date: Tue, 24 Sep 2013 17:14:48 -0700
Message-Id: <20130925001328.826906366@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

commit 7d64ac6422092adbbdaa279ab32f9d4c90a84558 upstream.

F15h, models 0x30 and later don't have a GART. Note that. Also check
CPUID leaf 0x80000006 for L3 prescence because there are models which
don't sport an L3 cache.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
[ Boris: rewrite commit message, cleanup comments. ]
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/amd_nb.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -20,6 +20,7 @@ const struct pci_device_id amd_nb_misc_i
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
 	{}
 };
@@ -27,6 +28,7 @@ EXPORT_SYMBOL(amd_nb_misc_ids);
 
 static const struct pci_device_id amd_nb_link_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
 	{}
 };
@@ -81,13 +83,20 @@ int amd_cache_northbridges(void)
 			next_northbridge(misc, amd_nb_misc_ids);
 		node_to_amd_nb(i)->link = link =
 			next_northbridge(link, amd_nb_link_ids);
-        }
+	}
 
+	/* GART present only on Fam15h upto model 0fh */
 	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
-	    boot_cpu_data.x86 == 0x15)
+	    (boot_cpu_data.x86 == 0x15 && boot_cpu_data.x86_model < 0x10))
 		amd_northbridges.flags |= AMD_NB_GART;
 
 	/*
+	 * Check for L3 cache presence.
+	 */
+	if (!cpuid_edx(0x80000006))
+		return 0;
+
+	/*
 	 * Some CPU families support L3 Cache Index Disable. There are some
 	 * limitations because of E382 and E388 on family 0x10.
 	 */


