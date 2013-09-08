Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab3IHXi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 19:38:27 -0400
Received: from mout.gmx.net ([212.227.17.20]:55649 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab3IHXi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 19:38:26 -0400
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Kosina <jkosina@suse.cz>
Subject: drivers/net/ethernet/nvidia/forcedeth.c saved_config_space[size] access patch
From: Marc Weber <marco-oweber@gmx.de>
To: netdev@vger.kernel.org
Date: Mon, 09 Sep 2013 01:39:15 +0200
Message-Id: <1378682421-sup-4422@nixos>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-1378683555-269612-11122-8933-1-="
X-Provags-ID: V03:K0:TqLnfS+ONKWYrDphKHnC1WQaNEYYFCNiJSHRdfe2UUnvRujEwxa
 JeqMSiO8XXKMfxGSEIQ0PX8JRWoXZSRXK8bTUI41LllJ7m8f1NmWaOFRJDGvJ7o1SOzeTj8
 hPDKzL/ybkQP5FO7vg7w/6V8Un+oK4IU/nIyP0pra0IC7z3YHyRAkEfHHgKigkifUeeH08G
 0AsyC+xtBZ1LaTjrWH0dQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1378683555-269612-11122-8933-1-=
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline

  1) VER3 and _MAX are of same size:
  #define NV_PCI_REGSZ_VER3       0x604
  #define NV_PCI_REGSZ_MAX        0x604


  2) It looks like there is a case where VER3 get's assigned to
      register_size:

  if (id->driver_data &
  (DEV_HAS_VLAN|DEV_HAS_MSI_X|DEV_HAS_POWER_CNTRL|DEV_HAS_STATISTICS_V2|DEV_HAS_STATISTICS_V
                  np->register_size = NV_PCI_REGSZ_VER3;

  3) the definition of saved_config_space is MAX divided by 4 (size of u32)
  struct fe_priv {
    [...]
    u32 saved_config_space[NV_PCI_REGSZ_MAX/4]

  4) This doesn't stop loop at [size-1]:
    Thus there is the risk that it overrides the field after
    saved_config_space. If that's desired behaviour at least a comment
    is missing IMHO:

  for (i = 0; i <= np->register_size/sizeof(u32); i++)
     np->saved_config_space[i] = readl(base + i*sizeof(u32));

  Such for loop is used twice in forcedeth.c

Patch againstn 4de9ad9bc08 (Fri Sep 6 11:14:33) attached fixing both
using < instead of <=.

If you think I've hit a small bug just fix and commit.
I don't care much about my ownership of this patch.

I didn't test this patch because I don't have the hardware and I think
its a trivial case.

Marc Weber

--=-1378683555-269612-11122-8933-1-=
Content-Disposition: attachment; filename="0001-forcedepth-fix-possible-out-of-bounds-access.patch"
Content-Type: application/octet-stream; name="0001-forcedepth-fix-possible-out-of-bounds-access.patch"
Content-Transfer-Encoding: base64

RnJvbSAyN2NiM2VmMmUwNzk3NTk3YjY0NzczMDk4YWUwZTRkMTY4MGM1NWNm
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJjIFdlYmVyIDxt
YXJjLW93ZWJlckBnbXguZGU+CkRhdGU6IFN1biwgOCBTZXAgMjAxMyAyMzoz
NToyOCArMDIwMApTdWJqZWN0OiBbUEFUQ0hdIGZvcmNlZGVwdGg6IGZpeCBw
b3NzaWJsZSBvdXQgb2YgYm91bmRzIGFjY2VzcwoKLS0tCiBkcml2ZXJzL25l
dC9ldGhlcm5ldC9udmlkaWEvZm9yY2VkZXRoLmMgfCA0ICsrLS0KIDEgZmls
ZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbnZpZGlhL2ZvcmNl
ZGV0aC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbnZpZGlhL2ZvcmNlZGV0
aC5jCmluZGV4IDA5OGI5NmQuLmQwOGY2ZWYgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L252aWRpYS9mb3JjZWRldGguYworKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9udmlkaWEvZm9yY2VkZXRoLmMKQEAgLTYxMDYs
NyArNjEwNiw3IEBAIHN0YXRpYyBpbnQgbnZfc3VzcGVuZChzdHJ1Y3QgZGV2
aWNlICpkZXZpY2UpCiAJbmV0aWZfZGV2aWNlX2RldGFjaChkZXYpOwogCiAJ
Lyogc2F2ZSBub24tcGNpIGNvbmZpZ3VyYXRpb24gc3BhY2UgKi8KLQlmb3Ig
KGkgPSAwOyBpIDw9IG5wLT5yZWdpc3Rlcl9zaXplL3NpemVvZih1MzIpOyBp
KyspCisJZm9yIChpID0gMDsgaSA8IG5wLT5yZWdpc3Rlcl9zaXplL3NpemVv
Zih1MzIpOyBpKyspCiAJCW5wLT5zYXZlZF9jb25maWdfc3BhY2VbaV0gPSBy
ZWFkbChiYXNlICsgaSpzaXplb2YodTMyKSk7CiAKIAlyZXR1cm4gMDsKQEAg
LTYxMjEsNyArNjEyMSw3IEBAIHN0YXRpYyBpbnQgbnZfcmVzdW1lKHN0cnVj
dCBkZXZpY2UgKmRldmljZSkKIAlpbnQgaSwgcmMgPSAwOwogCiAJLyogcmVz
dG9yZSBub24tcGNpIGNvbmZpZ3VyYXRpb24gc3BhY2UgKi8KLQlmb3IgKGkg
PSAwOyBpIDw9IG5wLT5yZWdpc3Rlcl9zaXplL3NpemVvZih1MzIpOyBpKysp
CisJZm9yIChpID0gMDsgaSA8IG5wLT5yZWdpc3Rlcl9zaXplL3NpemVvZih1
MzIpOyBpKyspCiAJCXdyaXRlbChucC0+c2F2ZWRfY29uZmlnX3NwYWNlW2ld
LCBiYXNlK2kqc2l6ZW9mKHUzMikpOwogCiAJaWYgKG5wLT5kcml2ZXJfZGF0
YSAmIERFVl9ORUVEX01TSV9GSVgpCi0tIAoxLjguMy40Cgo=

--=-1378683555-269612-11122-8933-1-=--
