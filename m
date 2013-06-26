Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab3FZIIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:08:34 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:51118 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3FZIHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:07:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7b7=E8uG-TzcNinE1F9QUX2xyC-WFGXKVv5svcrZ9aGQ@mail.gmail.com>
References: <1370066593-22736-1-git-send-email-yinghai@kernel.org>
	<1370066593-22736-3-git-send-email-yinghai@kernel.org>
	<20130625211516.GA8494@google.com>
	<1372196295.3944.221.camel@pasglop>
	<CAErSpo7b7=E8uG-TzcNinE1F9QUX2xyC-WFGXKVv5svcrZ9aGQ@mail.gmail.com>
Date: Wed, 26 Jun 2013 01:07:53 -0700
X-Google-Sender-Auth: OZROFmSSXTS5zhgcIBEkI1Yadho
Message-ID: <CAE9FiQWrxjg=mOP7JjiOdHK8m8V7Yo6a-LXCEY0B96P6S7n6fA@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] PCI: Use pci_walk_bus to detect unassigned resources
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf3010ecc97bb5ee04e00a2454
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3010ecc97bb5ee04e00a2454
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jun 25, 2013 at 2:46 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Jun 25, 2013 at 3:38 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>> On Tue, 2013-06-25 at 15:15 -0600, Bjorn Helgaas wrote:
>>> -     for_each_pci_dev(dev) {
>>> > -             int i;
>>> > +             /* Not assigned, or rejected by kernel ? */
>>> > +             if (r->flags && !r->start) {
>>> > +                     (*unassigned)++;
>>> > +                     return 1; /* return early from pci_walk_bus */
>>> > +             }
>>> > +     }
>>
>> BTW. I'm aware you didn't change that logic but ... it's somewhat broken
>> in the case where the aperture has an offset. You should compare
>> r->start with the offset, not with 0.
>
> Yes, please fix that in a separate patch that contains only the bugfix.

Please check inline word warped patch.

Subject: [PATCH] PCI: check pci bus address for unassigned res

We should compare res->start with root bus window offset.
Otherwise will have problem with arch that support hostbridge
resource offset.

BenH pointed out that during reviewing patchset that separate
assign unassigned to per root buses.

According to Bjorn, have it in separated patch.

Use pcibios_resource_to_bus to get region at first, and check
region.start instead.

Suggested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -1420,9 +1420,14 @@ static int check_unassigned_resources(st

     for (i = PCI_IOV_RESOURCES; i <= PCI_IOV_RESOURCE_END; i++) {
         struct resource *r = &dev->resource[i];
+        struct pci_bus_region region;

         /* Not assigned, or rejected by kernel ? */
-        if (r->flags && !r->start) {
+        if (!r->flags)
+            continue;
+
+        pcibios_resource_to_bus(dev, &region, res);
+        if (!region.start) {
             (*unassigned)++;
             return 1; /* return early from pci_walk_bus */
         }

--20cf3010ecc97bb5ee04e00a2454
Content-Type: application/octet-stream; 
	name="root_bus_ioport_skip_2_a.patch"
Content-Disposition: attachment; filename="root_bus_ioport_skip_2_a.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hie8qcm10

U3ViamVjdDogW1BBVENIXSBQQ0k6IGNoZWNrIHBjaSBidXMgYWRkcmVzcyBmb3IgdW5hc3NpZ25l
ZCByZXMKCldlIHNob3VsZCBjb21wYXJlIHJlcy0+c3RhcnQgd2l0aCByb290IGJ1cyB3aW5kb3cg
b2Zmc2V0LgpPdGhlcndpc2Ugd2lsbCBoYXZlIHByb2JsZW0gd2l0aCBhcmNoIHRoYXQgc3VwcG9y
dCBob3N0YnJpZGdlCnJlc291cmNlIG9mZnNldC4KCkJlbkggcG9pbnRlZCBvdXQgdGhhdCBkdXJp
bmcgcmV2aWV3aW5nIHBhdGNoc2V0IHRoYXQgc2VwYXJhdGUKYXNzaWduIHVuYXNzaWduZWQgdG8g
cGVyIHJvb3QgYnVzZXMuCgpBY2NvcmRpbmcgdG8gQmpvcm4sIGhhdmUgaXQgaW4gc2VwYXJhdGVk
IHBhdGNoLgoKVXNlIHBjaWJpb3NfcmVzb3VyY2VfdG9fYnVzIHRvIGdldCByZWdpb24gYXQgZmly
c3QsIGFuZCBjaGVjawpyZWdpb24uc3RhcnQgaW5zdGVhZC4KClN1Z2dlc3RlZC1ieTogQmVuamFt
aW4gSGVycmVuc2NobWlkdCA8YmVuaEBrZXJuZWwuY3Jhc2hpbmcub3JnPgpTaWduZWQtb2ZmLWJ5
OiBZaW5naGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+CgotLS0KIGRyaXZlcnMvcGNpL3NldHVw
LWJ1cy5jIHwgICAgNyArKysrKystCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvcGNpL3NldHVwLWJ1cy5jCj09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvcGNpL3NldHVwLWJ1cy5jCisrKyBs
aW51eC0yLjYvZHJpdmVycy9wY2kvc2V0dXAtYnVzLmMKQEAgLTE0MjAsOSArMTQyMCwxNCBAQCBz
dGF0aWMgaW50IGNoZWNrX3VuYXNzaWduZWRfcmVzb3VyY2VzKHN0CiAKIAlmb3IgKGkgPSBQQ0lf
SU9WX1JFU09VUkNFUzsgaSA8PSBQQ0lfSU9WX1JFU09VUkNFX0VORDsgaSsrKSB7CiAJCXN0cnVj
dCByZXNvdXJjZSAqciA9ICZkZXYtPnJlc291cmNlW2ldOworCQlzdHJ1Y3QgcGNpX2J1c19yZWdp
b24gcmVnaW9uOwogCiAJCS8qIE5vdCBhc3NpZ25lZCwgb3IgcmVqZWN0ZWQgYnkga2VybmVsID8g
Ki8KLQkJaWYgKHItPmZsYWdzICYmICFyLT5zdGFydCkgeworCQlpZiAoIXItPmZsYWdzKQorCQkJ
Y29udGludWU7CisKKwkJcGNpYmlvc19yZXNvdXJjZV90b19idXMoZGV2LCAmcmVnaW9uLCByZXMp
OworCQlpZiAoIXJlZ2lvbi5zdGFydCkgewogCQkJKCp1bmFzc2lnbmVkKSsrOwogCQkJcmV0dXJu
IDE7IC8qIHJldHVybiBlYXJseSBmcm9tIHBjaV93YWxrX2J1cyAqLwogCQl9Cg==
--20cf3010ecc97bb5ee04e00a2454--
