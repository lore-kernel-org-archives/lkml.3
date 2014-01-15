Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbaAOWZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:25:41 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:54460 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbaAOWZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:25:37 -0500
Date: Wed, 15 Jan 2014 23:25:28 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1524137311.20140115232528@eikelenboom.it>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: eiichiro.oiwa.nm@hitachi.com, Dave Airlie <airlied@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: In "pci_fixup_video" check if this is or should be the primary video devi
In-Reply-To: <CAErSpo7Bjo3rVCnuf9fkKc=T33Z5ZBzS+nHOBqDDKt1j4u0yWg@mail.gmail.com>
References: <1389499841-6097-1-git-send-email-linux@eikelenboom.it> <XNM1$9$0$4$$3$3$7$A$9006858U52d4d109@hitachi.com> <6310129377.20140114162641@eikelenboom.it> <XNM1$9$0$4$$3$3$7$A$9006860U52d614ca@hitachi.com> <126550032.20140115203605@eikelenboom.it> <CAErSpo7Bjo3rVCnuf9fkKc=T33Z5ZBzS+nHOBqDDKt1j4u0yWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="----------07610903A018D5D52"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------07610903A018D5D52
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Wednesday, January 15, 2014, 10:50:09 PM, you wrote:

> On Wed, Jan 15, 2014 at 12:36 PM, Sander Eikelenboom
> <linux@eikelenboom.it> wrote:
>> ...
>> And that's just what my patch does ..
>>
>> +       if (!vga_default_device() || pdev == vga_default_device()) {
>>
>> If we don't know the vga_default_device ... because we don't have that knowlegde
>> or
>> if this is actually the vga_default_device  ... because we do have that knowledge ..
>>
>> and only then .. run the fixup code and set this device as the vga_default_device
>>
>>
>> So this change actually makes the code adhere to the comment already above it .. saying it should only be applied to the vga_default_device aka
>> boot video device.
>>
>> Also added Bjorn and linux-pci to the CC .. should have done that right away ..
>> sorry for that.

> Can you resend your patch to linux-pci?  I don't think it made it there.

> Bjorn


Sure .. also attached for the case it gets mangled ..

Date: Sun, 12 Jan 2014 04:49:44 +0100
Subject: [PATCH] In "pci_fixup_video" check if this is or should be the
 primary video device to prevent setting the
 IORESOURCE_ROM_SHADOW flag on a secondary VGA card
To: Dave Airlie <airlied@redhat.com>,
    Eiichiro Oiwa <eiichiro.oiwa.nm@hitachi.com>,
    Greg Kroah-Hartman <gregkh@suse.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
    linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>

Setting the IORESOURCE_ROM_SHADOW flag on a secondary VGA card prevents if from
reading it's own rom. It will get the content of the shadowrom at C000 instead,
which is of the primary VGA card and the driver of the secondary card will bail
out.

Fix this by checking if this is or should be the primary video device before
applying the fix and let the comment reflect this.

Signed-off-by: Sander Eikelenboom <linux@eikelenboom.it>
---
 arch/x86/pci/fixup.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index b046e07..525e49a 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -314,9 +314,9 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,        PCI_DEVICE_ID_INTEL_MCH_PC1,    pcie_r
  * IORESOURCE_ROM_SHADOW is used to associate the boot video
  * card with this copy. On laptops this copy has to be used since
  * the main ROM may be compressed or combined with another image.
- * See pci_map_rom() for use of this flag. IORESOURCE_ROM_SHADOW
- * is marked here since the boot video device will be the only enabled
- * video device at this point.
+ * See pci_map_rom() for use of this flag. Before we mark the device
+ * with IORESOURCE_ROM_SHADOW we have to check if this is or should become
+ * the primary video card, since this quirk is ran for all video devices.
  */
 
 static void pci_fixup_video(struct pci_dev *pdev)
@@ -347,12 +347,13 @@ static void pci_fixup_video(struct pci_dev *pdev)
                }
                bus = bus->parent;
        }
-       pci_read_config_word(pdev, PCI_COMMAND, &config);
-       if (config & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
-               pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
-               dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
-               if (!vga_default_device())
+       if (!vga_default_device() || pdev == vga_default_device()) {
+               pci_read_config_word(pdev, PCI_COMMAND, &config);
+               if (config & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
+                       pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
+                       dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
                        vga_set_default_device(pdev);
+               }
        }
 }
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
-- 
1.7.10.4

------------07610903A018D5D52
Content-Type: application/octet-stream;
 name="0001-In-pci_fixup_video-check-if-this-is-or-should-be-the.patch"
Content-transfer-encoding: base64
Content-Disposition: attachment;
 filename="0001-In-pci_fixup_video-check-if-this-is-or-should-be-the.patch"

RnJvbSA1OWIyOTI4ZmJkZjExOTdmODc0ZjllZTA2YTQyY2NkNjNkYWYxMzQwIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBTYW5kZXIgRWlrZWxlbmJvb20gPGxpbnV4QGVpa2Vs
ZW5ib29tLml0PgpEYXRlOiBTdW4sIDEyIEphbiAyMDE0IDA0OjQ5OjQ0ICswMTAwClN1Ympl
Y3Q6IFtQQVRDSF0gSW4gInBjaV9maXh1cF92aWRlbyIgY2hlY2sgaWYgdGhpcyBpcyBvciBz
aG91bGQgYmUgdGhlCiBwcmltYXJ5IHZpZGVvIGRldmljZSB0byBwcmV2ZW50IHNldHRpbmcg
dGhlCiBJT1JFU09VUkNFX1JPTV9TSEFET1cgZmxhZyBvbiBhIHNlY29uZGFyeSBWR0EgY2Fy
ZApUbzogRGF2ZSBBaXJsaWUgPGFpcmxpZWRAcmVkaGF0LmNvbT4sCiAgICBFaWljaGlybyBP
aXdhIDxlaWljaGlyby5vaXdhLm5tQGhpdGFjaGkuY29tPiwKICAgIEdyZWcgS3JvYWgtSGFy
dG1hbiA8Z3JlZ2toQHN1c2UuZGU+CkNjOiBLb25yYWQgUnplc3p1dGVrIFdpbGsgPGtvbnJh
ZC53aWxrQG9yYWNsZS5jb20+LAogICAgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZyA8
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz4KClNldHRpbmcgdGhlIElPUkVTT1VSQ0Vf
Uk9NX1NIQURPVyBmbGFnIG9uIGEgc2Vjb25kYXJ5IFZHQSBjYXJkIHByZXZlbnRzIGlmIGZy
b20KcmVhZGluZyBpdCdzIG93biByb20uIEl0IHdpbGwgZ2V0IHRoZSBjb250ZW50IG9mIHRo
ZSBzaGFkb3dyb20gYXQgQzAwMCBpbnN0ZWFkLAp3aGljaCBpcyBvZiB0aGUgcHJpbWFyeSBW
R0EgY2FyZCBhbmQgdGhlIGRyaXZlciBvZiB0aGUgc2Vjb25kYXJ5IGNhcmQgd2lsbCBiYWls
Cm91dC4KCkZpeCB0aGlzIGJ5IGNoZWNraW5nIGlmIHRoaXMgaXMgb3Igc2hvdWxkIGJlIHRo
ZSBwcmltYXJ5IHZpZGVvIGRldmljZSBiZWZvcmUKYXBwbHlpbmcgdGhlIGZpeCBhbmQgbGV0
IHRoZSBjb21tZW50IHJlZmxlY3QgdGhpcy4KClNpZ25lZC1vZmYtYnk6IFNhbmRlciBFaWtl
bGVuYm9vbSA8bGludXhAZWlrZWxlbmJvb20uaXQ+Ci0tLQogYXJjaC94ODYvcGNpL2ZpeHVw
LmMgfCAgIDE3ICsrKysrKysrKy0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRp
b25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L3BjaS9maXh1
cC5jIGIvYXJjaC94ODYvcGNpL2ZpeHVwLmMKaW5kZXggYjA0NmUwNy4uNTI1ZTQ5YSAxMDA2
NDQKLS0tIGEvYXJjaC94ODYvcGNpL2ZpeHVwLmMKKysrIGIvYXJjaC94ODYvcGNpL2ZpeHVw
LmMKQEAgLTMxNCw5ICszMTQsOSBAQCBERUNMQVJFX1BDSV9GSVhVUF9GSU5BTChQQ0lfVkVO
RE9SX0lEX0lOVEVMLAlQQ0lfREVWSUNFX0lEX0lOVEVMX01DSF9QQzEsCXBjaWVfcgogICog
SU9SRVNPVVJDRV9ST01fU0hBRE9XIGlzIHVzZWQgdG8gYXNzb2NpYXRlIHRoZSBib290IHZp
ZGVvCiAgKiBjYXJkIHdpdGggdGhpcyBjb3B5LiBPbiBsYXB0b3BzIHRoaXMgY29weSBoYXMg
dG8gYmUgdXNlZCBzaW5jZQogICogdGhlIG1haW4gUk9NIG1heSBiZSBjb21wcmVzc2VkIG9y
IGNvbWJpbmVkIHdpdGggYW5vdGhlciBpbWFnZS4KLSAqIFNlZSBwY2lfbWFwX3JvbSgpIGZv
ciB1c2Ugb2YgdGhpcyBmbGFnLiBJT1JFU09VUkNFX1JPTV9TSEFET1cKLSAqIGlzIG1hcmtl
ZCBoZXJlIHNpbmNlIHRoZSBib290IHZpZGVvIGRldmljZSB3aWxsIGJlIHRoZSBvbmx5IGVu
YWJsZWQKLSAqIHZpZGVvIGRldmljZSBhdCB0aGlzIHBvaW50LgorICogU2VlIHBjaV9tYXBf
cm9tKCkgZm9yIHVzZSBvZiB0aGlzIGZsYWcuIEJlZm9yZSB3ZSBtYXJrIHRoZSBkZXZpY2UK
KyAqIHdpdGggSU9SRVNPVVJDRV9ST01fU0hBRE9XIHdlIGhhdmUgdG8gY2hlY2sgaWYgdGhp
cyBpcyBvciBzaG91bGQgYmVjb21lCisgKiB0aGUgcHJpbWFyeSB2aWRlbyBjYXJkLCBzaW5j
ZSB0aGlzIHF1aXJrIGlzIHJhbiBmb3IgYWxsIHZpZGVvIGRldmljZXMuCiAgKi8KIAogc3Rh
dGljIHZvaWQgcGNpX2ZpeHVwX3ZpZGVvKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQpAQCAtMzQ3
LDEyICszNDcsMTMgQEAgc3RhdGljIHZvaWQgcGNpX2ZpeHVwX3ZpZGVvKHN0cnVjdCBwY2lf
ZGV2ICpwZGV2KQogCQl9CiAJCWJ1cyA9IGJ1cy0+cGFyZW50OwogCX0KLQlwY2lfcmVhZF9j
b25maWdfd29yZChwZGV2LCBQQ0lfQ09NTUFORCwgJmNvbmZpZyk7Ci0JaWYgKGNvbmZpZyAm
IChQQ0lfQ09NTUFORF9JTyB8IFBDSV9DT01NQU5EX01FTU9SWSkpIHsKLQkJcGRldi0+cmVz
b3VyY2VbUENJX1JPTV9SRVNPVVJDRV0uZmxhZ3MgfD0gSU9SRVNPVVJDRV9ST01fU0hBRE9X
OwotCQlkZXZfcHJpbnRrKEtFUk5fREVCVUcsICZwZGV2LT5kZXYsICJCb290IHZpZGVvIGRl
dmljZVxuIik7Ci0JCWlmICghdmdhX2RlZmF1bHRfZGV2aWNlKCkpCisJaWYgKCF2Z2FfZGVm
YXVsdF9kZXZpY2UoKSB8fCBwZGV2ID09IHZnYV9kZWZhdWx0X2RldmljZSgpKSB7CisJCXBj
aV9yZWFkX2NvbmZpZ193b3JkKHBkZXYsIFBDSV9DT01NQU5ELCAmY29uZmlnKTsKKwkJaWYg
KGNvbmZpZyAmIChQQ0lfQ09NTUFORF9JTyB8IFBDSV9DT01NQU5EX01FTU9SWSkpIHsKKwkJ
CXBkZXYtPnJlc291cmNlW1BDSV9ST01fUkVTT1VSQ0VdLmZsYWdzIHw9IElPUkVTT1VSQ0Vf
Uk9NX1NIQURPVzsKKwkJCWRldl9wcmludGsoS0VSTl9ERUJVRywgJnBkZXYtPmRldiwgIkJv
b3QgdmlkZW8gZGV2aWNlXG4iKTsKIAkJCXZnYV9zZXRfZGVmYXVsdF9kZXZpY2UocGRldik7
CisJCX0KIAl9CiB9CiBERUNMQVJFX1BDSV9GSVhVUF9DTEFTU19GSU5BTChQQ0lfQU5ZX0lE
LCBQQ0lfQU5ZX0lELAotLSAKMS43LjEwLjQKCg==
------------07610903A018D5D52--

