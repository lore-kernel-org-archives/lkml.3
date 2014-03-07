Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaCGTju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:39:50 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:55135 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaCGTjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:39:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5fkaFNq_qTZ+gTDMV554f4diOXQ7_4bsHqj06iAGTpHg@mail.gmail.com>
References: <CAMxnaaXd9-VbxSYa9q1YVT+fwfDFYKGG2Hq-1jkc-awLX-HwtQ@mail.gmail.com>
	<CAErSpo5fkaFNq_qTZ+gTDMV554f4diOXQ7_4bsHqj06iAGTpHg@mail.gmail.com>
Date: Fri, 7 Mar 2014 11:39:48 -0800
X-Google-Sender-Auth: xy9MTxTpmgTukB7lIzSxSARcKn0
Message-ID: <CAE9FiQVNFqTw+92qy8zcwG1haiSZzU+KE3oh4YnjNc_aE6KUnA@mail.gmail.com>
Subject: Re: [Bug] PCI: Enable INTx if BIOS left them disabled - triggers
 during rescan
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andreas Noever <andreas.noever@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rajat Jain <rajatxjain@gmail.com>
Content-Type: multipart/mixed; boundary=001a11c323bcac305404f4096af5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c323bcac305404f4096af5
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Mar 7, 2014 at 8:45 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> I opened a bugzilla report at https://bugzilla.kernel.org/show_bug.cgi?id=71691
>
> It seems like clearing DisINTx has some effect on MSI.  I don't see
> anything in the spec that would suggest this (I'm looking at the PCIe
> r3.0 spec, sec 7.5.1.1).
>
> Can somebody point out a connection between DisINTx and MSI?  If not,
> maybe we'll need some sort of quirk to deal with this.

I had different impression: if you disable INTx in some chipset, MSI will not
work anymore.

so we have

static void pci_intx_for_msi(struct pci_dev *dev, int enable)
{
        if (!(dev->dev_flags & PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG))
                pci_intx(dev, enable);
}

and have quirks for ati and broadcom chip to set that FLAG.

regarding the regression: i would suggest move out
do_pci_enable_intx() from re-enable path.

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 5a24cb3..92718c9 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1190,11 +1190,22 @@ int __weak pcibios_enable_device(struct
pci_dev *dev, int bars)
     return pci_enable_resources(dev, bars);
 }

+static void do_pci_enable_intx(struct pci_dev *dev)
+{
+    u8 pin;
+    pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
+    if (pin) {
+        pci_read_config_word(dev, PCI_COMMAND, &cmd);
+        if (cmd & PCI_COMMAND_INTX_DISABLE)
+            pci_write_config_word(dev, PCI_COMMAND,
+                          cmd & ~PCI_COMMAND_INTX_DISABLE);
+    }
+}
+
 static int do_pci_enable_device(struct pci_dev *dev, int bars)
 {
     int err;
     u16 cmd;
-    u8 pin;

     err = pci_set_power_state(dev, PCI_D0);
     if (err < 0 && err != -EIO)
@@ -1204,14 +1215,6 @@ static int do_pci_enable_device(struct pci_dev
*dev, int bars)
         return err;
     pci_fixup_device(pci_fixup_enable, dev);

-    pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
-    if (pin) {
-        pci_read_config_word(dev, PCI_COMMAND, &cmd);
-        if (cmd & PCI_COMMAND_INTX_DISABLE)
-            pci_write_config_word(dev, PCI_COMMAND,
-                          cmd & ~PCI_COMMAND_INTX_DISABLE);
-    }
-
     return 0;
 }

@@ -1287,6 +1290,8 @@ static int pci_enable_device_flags(struct
pci_dev *dev, unsigned long flags)
     err = do_pci_enable_device(dev, bars);
     if (err < 0)
         atomic_dec(&dev->enable_cnt);
+    else
+        do_pci_enable_intx(dev);
     return err;
 }

--001a11c323bcac305404f4096af5
Content-Type: text/x-patch; charset=US-ASCII; name="do_not_enable_intx_again.patch"
Content-Disposition: attachment; filename="do_not_enable_intx_again.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hshvcb3i0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3BjaS5jIGIvZHJpdmVycy9wY2kvcGNpLmMKaW5kZXgg
NWEyNGNiMy4uOTI3MThjOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9wY2kvcGNpLmMKKysrIGIvZHJp
dmVycy9wY2kvcGNpLmMKQEAgLTExOTAsMTEgKzExOTAsMjIgQEAgaW50IF9fd2VhayBwY2liaW9z
X2VuYWJsZV9kZXZpY2Uoc3RydWN0IHBjaV9kZXYgKmRldiwgaW50IGJhcnMpCiAJcmV0dXJuIHBj
aV9lbmFibGVfcmVzb3VyY2VzKGRldiwgYmFycyk7CiB9CiAKK3N0YXRpYyB2b2lkIGRvX3BjaV9l
bmFibGVfaW50eChzdHJ1Y3QgcGNpX2RldiAqZGV2KQoreworCXU4IHBpbjsKKwlwY2lfcmVhZF9j
b25maWdfYnl0ZShkZXYsIFBDSV9JTlRFUlJVUFRfUElOLCAmcGluKTsKKwlpZiAocGluKSB7CisJ
CXBjaV9yZWFkX2NvbmZpZ193b3JkKGRldiwgUENJX0NPTU1BTkQsICZjbWQpOworCQlpZiAoY21k
ICYgUENJX0NPTU1BTkRfSU5UWF9ESVNBQkxFKQorCQkJcGNpX3dyaXRlX2NvbmZpZ193b3JkKGRl
diwgUENJX0NPTU1BTkQsCisJCQkJCSAgICAgIGNtZCAmIH5QQ0lfQ09NTUFORF9JTlRYX0RJU0FC
TEUpOworCX0KK30KKwogc3RhdGljIGludCBkb19wY2lfZW5hYmxlX2RldmljZShzdHJ1Y3QgcGNp
X2RldiAqZGV2LCBpbnQgYmFycykKIHsKIAlpbnQgZXJyOwogCXUxNiBjbWQ7Ci0JdTggcGluOwog
CiAJZXJyID0gcGNpX3NldF9wb3dlcl9zdGF0ZShkZXYsIFBDSV9EMCk7CiAJaWYgKGVyciA8IDAg
JiYgZXJyICE9IC1FSU8pCkBAIC0xMjA0LDE0ICsxMjE1LDYgQEAgc3RhdGljIGludCBkb19wY2lf
ZW5hYmxlX2RldmljZShzdHJ1Y3QgcGNpX2RldiAqZGV2LCBpbnQgYmFycykKIAkJcmV0dXJuIGVy
cjsKIAlwY2lfZml4dXBfZGV2aWNlKHBjaV9maXh1cF9lbmFibGUsIGRldik7CiAKLQlwY2lfcmVh
ZF9jb25maWdfYnl0ZShkZXYsIFBDSV9JTlRFUlJVUFRfUElOLCAmcGluKTsKLQlpZiAocGluKSB7
Ci0JCXBjaV9yZWFkX2NvbmZpZ193b3JkKGRldiwgUENJX0NPTU1BTkQsICZjbWQpOwotCQlpZiAo
Y21kICYgUENJX0NPTU1BTkRfSU5UWF9ESVNBQkxFKQotCQkJcGNpX3dyaXRlX2NvbmZpZ193b3Jk
KGRldiwgUENJX0NPTU1BTkQsCi0JCQkJCSAgICAgIGNtZCAmIH5QQ0lfQ09NTUFORF9JTlRYX0RJ
U0FCTEUpOwotCX0KLQogCXJldHVybiAwOwogfQogCkBAIC0xMjg3LDYgKzEyOTAsOCBAQCBzdGF0
aWMgaW50IHBjaV9lbmFibGVfZGV2aWNlX2ZsYWdzKHN0cnVjdCBwY2lfZGV2ICpkZXYsIHVuc2ln
bmVkIGxvbmcgZmxhZ3MpCiAJZXJyID0gZG9fcGNpX2VuYWJsZV9kZXZpY2UoZGV2LCBiYXJzKTsK
IAlpZiAoZXJyIDwgMCkKIAkJYXRvbWljX2RlYygmZGV2LT5lbmFibGVfY250KTsKKwllbHNlCisJ
CWRvX3BjaV9lbmFibGVfaW50eChkZXYpOwogCXJldHVybiBlcnI7CiB9CiAK
--001a11c323bcac305404f4096af5--
