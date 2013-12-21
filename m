Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3LUBTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 20:19:40 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:51265 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab3LUBTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 20:19:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7THxjUQ=EWxicPYCwQCHReJ=sxPyPPRFv4QQ=ex6wmOA@mail.gmail.com>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
	<1385429290-25397-11-git-send-email-yinghai@kernel.org>
	<CAErSpo7THxjUQ=EWxicPYCwQCHReJ=sxPyPPRFv4QQ=ex6wmOA@mail.gmail.com>
Date: Fri, 20 Dec 2013 17:19:38 -0800
X-Google-Sender-Auth: IHNhrsUklJ4kwpGpITyAGs68ER4
Message-ID: <CAE9FiQUDkuBnuYo4OfZncFw6k22PcapgjqzapVFt5UneiqoVDQ@mail.gmail.com>
Subject: Re: [PATCH v2 10/10] intel-gtt: Read 64bit for gmar_bus_addr
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>
Content-Type: multipart/mixed; boundary=089e0158b2c43f2dcc04ee013031
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0158b2c43f2dcc04ee013031
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Dec 20, 2013 at 4:27 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:

> Why are we reading these BARs directly anyway?  These look like
> standard PCI BARs (I810_GMADDR == 0x10 and I915_GMADDR == 0x18), so
> the PCI core should already be reading them correctly, shouldn't it?
> Can't we just use pcibios_resource_to_bus(pci_resource_start())?
>
> It looks like i810_setup(), i830_setup(), and i9xx_setup() have the
> same problem and should also be using pci_resource_start() or
> something similar.

Agreed.

should be sth like:


Index: linux-2.6/drivers/char/agp/intel-gtt.c
===================================================================
--- linux-2.6.orig/drivers/char/agp/intel-gtt.c
+++ linux-2.6/drivers/char/agp/intel-gtt.c
@@ -608,9 +608,9 @@ static bool intel_gtt_can_wc(void)

 static int intel_gtt_init(void)
 {
-       u32 gma_addr;
+       struct pci_bus_region r;
        u32 gtt_map_size;
-       int ret;
+       int ret, idx;

        ret = intel_private.driver->setup();
        if (ret != 0)
@@ -660,13 +660,14 @@ static int intel_gtt_init(void)
        }

        if (INTEL_GTT_GEN <= 2)
-               pci_read_config_dword(intel_private.pcidev, I810_GMADDR,
-                                     &gma_addr);
+               idx = 0; /* I810_GMADDR */
        else
-               pci_read_config_dword(intel_private.pcidev, I915_GMADDR,
-                                     &gma_addr);
+               idx = 2; /* I915_GMADDR */

-       intel_private.gma_bus_addr = (gma_addr & PCI_BASE_ADDRESS_MEM_MASK);
+       pcibios_resource_to_bus(intel_private.pcidev->bus, &r,
+                               &intel_private.pcidev->resource[idx]);
+
+       intel_private.gma_bus_addr = r.start;

        return 0;
 }

--089e0158b2c43f2dcc04ee013031
Content-Type: text/x-patch; charset=US-ASCII; name="intel_gma_bus_addr_resource_bus.patch"
Content-Disposition: attachment; 
	filename="intel_gma_bus_addr_resource_bus.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hpg6imnp0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hhci9hZ3AvaW50ZWwtZ3R0LmMgYi9kcml2ZXJzL2NoYXIv
YWdwL2ludGVsLWd0dC5jCmluZGV4IGI4ZTIwMTQuLjAyNTAwMTcgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvY2hhci9hZ3AvaW50ZWwtZ3R0LmMKKysrIGIvZHJpdmVycy9jaGFyL2FncC9pbnRlbC1ndHQu
YwpAQCAtNjA4LDkgKzYwOCw5IEBAIHN0YXRpYyBib29sIGludGVsX2d0dF9jYW5fd2Modm9pZCkK
IAogc3RhdGljIGludCBpbnRlbF9ndHRfaW5pdCh2b2lkKQogewotCXUzMiBnbWFfYWRkcjsKKwlz
dHJ1Y3QgcGNpX2J1c19yZWdpb24gcjsKIAl1MzIgZ3R0X21hcF9zaXplOwotCWludCByZXQ7CisJ
aW50IHJldCwgaWR4OwogCiAJcmV0ID0gaW50ZWxfcHJpdmF0ZS5kcml2ZXItPnNldHVwKCk7CiAJ
aWYgKHJldCAhPSAwKQpAQCAtNjYwLDEzICs2NjAsMTQgQEAgc3RhdGljIGludCBpbnRlbF9ndHRf
aW5pdCh2b2lkKQogCX0KIAogCWlmIChJTlRFTF9HVFRfR0VOIDw9IDIpCi0JCXBjaV9yZWFkX2Nv
bmZpZ19kd29yZChpbnRlbF9wcml2YXRlLnBjaWRldiwgSTgxMF9HTUFERFIsCi0JCQkJICAgICAg
JmdtYV9hZGRyKTsKKwkJaWR4ID0gMDsgLyogSTgxMF9HTUFERFIgKi8KIAllbHNlCi0JCXBjaV9y
ZWFkX2NvbmZpZ19kd29yZChpbnRlbF9wcml2YXRlLnBjaWRldiwgSTkxNV9HTUFERFIsCi0JCQkJ
ICAgICAgJmdtYV9hZGRyKTsKKwkJaWR4ID0gMjsgLyogSTkxNV9HTUFERFIgKi8KKworCXBjaWJp
b3NfcmVzb3VyY2VfdG9fYnVzKGludGVsX3ByaXZhdGUucGNpZGV2LT5idXMsICZyLAorCQkJCSZp
bnRlbF9wcml2YXRlLnBjaWRldi0+cmVzb3VyY2VbaWR4XSk7CiAKLQlpbnRlbF9wcml2YXRlLmdt
YV9idXNfYWRkciA9IChnbWFfYWRkciAmIFBDSV9CQVNFX0FERFJFU1NfTUVNX01BU0spOworCWlu
dGVsX3ByaXZhdGUuZ21hX2J1c19hZGRyID0gci5zdGFydDsKIAogCXJldHVybiAwOwogfQo=
--089e0158b2c43f2dcc04ee013031--
