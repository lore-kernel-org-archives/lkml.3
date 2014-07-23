Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbaGWXdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:33:19 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:62212 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312AbaGWXdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:33:17 -0400
Message-ID: <1406158393.13064.1.camel@gmail.com>
Subject: [BUG?] 3.16-rc6 ... at drivers/gpu/drm/i915/intel_pm.c:5997
 intel_display_power_put+0x12d/0x160()
From: Ian Kumlien <ian.kumlien@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: intel-gfx@lists.freedesktop.org
Date: Thu, 24 Jul 2014 01:33:13 +0200
Content-Type: multipart/mixed; boundary="=-uCYhdq203uS4V1a37Tg/"
X-Mailer: Evolution 3.12.4 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uCYhdq203uS4V1a37Tg/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Try four, now including CC lists for the intel driver...

---

Hi again,


Playing some more with the new kernel release i noticed this:
[ 9064.008821] WARNING: CPU: 3 PID: 22929 at drivers/gpu/drm/i915/intel_pm.c:5997 intel_display_power_put+0x12d/0x160()
[ 9064.008822] Modules linked in: uas bnep b43 mac80211 cfg80211 snd_hda_codec_hdmi btusb bluetooth 6lowpan_iphc rfkill snd_hda_codec_cirrus uvcvideo snd_hda_codec_generic videobuf2_vmalloc videobuf2_memops videobuf2_core snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer sdhci_pci snd sdhci soundcore mmc_core bcma
[ 9064.008839] CPU: 3 PID: 22929 Comm: kworker/3:2 Tainted: G        W     3.16.0-rc6 #23
[ 9064.008840] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B03.1211161133 11/16/2012
[ 9064.008843] Workqueue: events edp_panel_vdd_work
[ 9064.008844]  0000000000000009 ffff88015ba77d28 ffffffff8198ea2d 0000000000000000
[ 9064.008846]  ffff88015ba77d60 ffffffff810cbac8 ffff8802610b002c 00000000000c7204
[ 9064.008848]  0000000000000001 ffff8802610b80f0 ffff8802610b0000 ffff88015ba77d70
[ 9064.008850] Call Trace:
[ 9064.008854]  [<ffffffff8198ea2d>] dump_stack+0x4e/0x7a
[ 9064.008857]  [<ffffffff810cbac8>] warn_slowpath_common+0x78/0xa0
[ 9064.008858]  [<ffffffff810cbba5>] warn_slowpath_null+0x15/0x20
[ 9064.008860]  [<ffffffff815bdb3d>] intel_display_power_put+0x12d/0x160
[ 9064.008862]  [<ffffffff8161e084>] edp_panel_vdd_off_sync+0xf4/0x1c0
[ 9064.008863]  [<ffffffff8161e17f>] edp_panel_vdd_work+0x2f/0x40
[ 9064.008866]  [<ffffffff810e63be>] process_one_work+0x16e/0x480
[ 9064.008868]  [<ffffffff810e6cbb>] worker_thread+0x11b/0x520
[ 9064.008870]  [<ffffffff810e6ba0>] ? create_and_start_worker+0x50/0x50
[ 9064.008872]  [<ffffffff810ecb24>] kthread+0xc4/0xe0
[ 9064.008874]  [<ffffffff810eca60>] ? kthread_create_on_node+0x170/0x170
[ 9064.008877]  [<ffffffff81997e6c>] ret_from_fork+0x7c/0xb0
[ 9064.008878]  [<ffffffff810eca60>] ? kthread_create_on_node+0x170/0x170
[ 9064.008880] ---[ end trace 17f9738f20aec288 ]---
----


I had multiples of them in my dmesg, however, this seems to fix it:
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 8a1a4fb..4c3249d 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1252,6 +1252,7 @@ static void edp_panel_vdd_off_sync(struct intel_dp *intel_dp)
                        intel_dp->last_power_cycle = jiffies;
 
                power_domain = intel_display_port_power_domain(intel_encoder);
+               intel_display_power_get(dev_priv, power_domain);
                intel_display_power_put(dev_priv, power_domain);
        }
 }
@@ -1371,6 +1372,7 @@ void intel_edp_panel_off(struct intel_dp *intel_dp)
 
        /* We got a reference when we enabled the VDD. */
        power_domain = intel_display_port_power_domain(intel_encoder);
+       intel_display_power_get(dev_priv, power_domain);
        intel_display_power_put(dev_priv, power_domain);
 }
---


The question however is: Is this the correct approach? Should it be done
differently?
(This handles the "close and open lid" usecase, i don't know if there
are others, a grep indicated that there might be two more missing...)





--=-uCYhdq203uS4V1a37Tg/
Content-Disposition: attachment; filename="intel_pm.patch"
Content-Type: text/x-patch; name="intel_pm.patch"; charset="UTF-8"
Content-Transfer-Encoding: base64

Y29tbWl0IDQyM2QwMWUxOTI1MDQ3NjRkNWNiNTllZmZlNWRhNjhiMDM1YTBkNDEKQXV0aG9yOiBJ
YW4gS3VtbGllbiA8aWFuLmt1bWxpZW5AZ21haWwuY29tPgpEYXRlOiAgIFR1ZSBKdWwgMjIgMjE6
MTA6NTAgMjAxNCArMDIwMAoKICAgIEFkZCBpbnRlbF9kaXNwbGF5X3Bvd2VyX2dldCBiZWZvcmUg
X3B1dAogICAgCiAgICBXaGVuIGNsb3NpbmcgdGhlIGxpZCB3aGVuIHVzaW5nIDMuMTYtcmM2IG9u
IG15IGxhcHRvcCBpIGdvdAogICAgdGhyZWUgIldBUk5fT04iIGJhY2sgdHJhY2VzLgogICAgCiAg
ICBFeGFtcGxlOgogICAgWyA5MDY0LjAwODgyMV0gV0FSTklORzogQ1BVOiAzIFBJRDogMjI5Mjkg
YXQKICAgIGRyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX3BtLmM6NTk5NwogICAgaW50ZWxfZGlz
cGxheV9wb3dlcl9wdXQrMHgxMmQvMHgxNjAoKQogICAgWyA5MDY0LjAwODgyMl0gTW9kdWxlcyBs
aW5rZWQgaW46IHVhcyBibmVwIGI0MyBtYWM4MDIxMSBjZmc4MDIxMQogICAgc25kX2hkYV9jb2Rl
Y19oZG1pIGJ0dXNiIGJsdWV0b290aCA2bG93cGFuX2lwaGMgcmZraWxsCiAgICBzbmRfaGRhX2Nv
ZGVjX2NpcnJ1cyB1dmN2aWRlbyBzbmRfaGRhX2NvZGVjX2dlbmVyaWMgdmlkZW9idWYyX3ZtYWxs
b2MKICAgIHZpZGVvYnVmMl9tZW1vcHMgdmlkZW9idWYyX2NvcmUgc25kX2hkYV9pbnRlbCBzbmRf
aGRhX2NvbnRyb2xsZXIKICAgIHNuZF9oZGFfY29kZWMgc25kX2h3ZGVwIHNuZF9wY20gc25kX3Rp
bWVyIHNkaGNpX3BjaSBzbmQgc2RoY2kgc291bmRjb3JlCiAgICBtbWNfY29yZSBiY21hCiAgICBb
IDkwNjQuMDA4ODM5XSBDUFU6IDMgUElEOiAyMjkyOSBDb21tOiBrd29ya2VyLzM6MiBUYWludGVk
OiBHICAgICAgICBXCiAgICAzLjE2LjAtcmM2ICMyMwogICAgWyA5MDY0LjAwODg0MF0gSGFyZHdh
cmUgbmFtZTogQXBwbGUgSW5jLgogICAgTWFjQm9va1BybzEwLDIvTWFjLUFGRDhBOUQ5NDRFQTQ4
NDMsIEJJT1MgTUJQMTAyLjg4Wi4wMTA2LkIwMy4xMjExMTYxMTMzCiAgICAxMS8xNi8yMDEyCiAg
ICBbIDkwNjQuMDA4ODQzXSBXb3JrcXVldWU6IGV2ZW50cyBlZHBfcGFuZWxfdmRkX3dvcmsKICAg
IFsgOTA2NC4wMDg4NDRdICAwMDAwMDAwMDAwMDAwMDA5IGZmZmY4ODAxNWJhNzdkMjggZmZmZmZm
ZmY4MTk4ZWEyZAogICAgMDAwMDAwMDAwMDAwMDAwMAogICAgWyA5MDY0LjAwODg0Nl0gIGZmZmY4
ODAxNWJhNzdkNjAgZmZmZmZmZmY4MTBjYmFjOCBmZmZmODgwMjYxMGIwMDJjCiAgICAwMDAwMDAw
MDAwMGM3MjA0CiAgICBbIDkwNjQuMDA4ODQ4XSAgMDAwMDAwMDAwMDAwMDAwMSBmZmZmODgwMjYx
MGI4MGYwIGZmZmY4ODAyNjEwYjAwMDAKICAgIGZmZmY4ODAxNWJhNzdkNzAKICAgIFsgOTA2NC4w
MDg4NTBdIENhbGwgVHJhY2U6CiAgICBbIDkwNjQuMDA4ODU0XSAgWzxmZmZmZmZmZjgxOThlYTJk
Pl0gZHVtcF9zdGFjaysweDRlLzB4N2EKICAgIFsgOTA2NC4wMDg4NTddICBbPGZmZmZmZmZmODEw
Y2JhYzg+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDc4LzB4YTAKICAgIFsgOTA2NC4wMDg4NThd
ICBbPGZmZmZmZmZmODEwY2JiYTU+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgxNS8weDIwCiAgICBb
IDkwNjQuMDA4ODYwXSAgWzxmZmZmZmZmZjgxNWJkYjNkPl0gaW50ZWxfZGlzcGxheV9wb3dlcl9w
dXQrMHgxMmQvMHgxNjAKICAgIFsgOTA2NC4wMDg4NjJdICBbPGZmZmZmZmZmODE2MWUwODQ+XSBl
ZHBfcGFuZWxfdmRkX29mZl9zeW5jKzB4ZjQvMHgxYzAKICAgIFsgOTA2NC4wMDg4NjNdICBbPGZm
ZmZmZmZmODE2MWUxN2Y+XSBlZHBfcGFuZWxfdmRkX3dvcmsrMHgyZi8weDQwCiAgICBbIDkwNjQu
MDA4ODY2XSAgWzxmZmZmZmZmZjgxMGU2M2JlPl0gcHJvY2Vzc19vbmVfd29yaysweDE2ZS8weDQ4
MAogICAgWyA5MDY0LjAwODg2OF0gIFs8ZmZmZmZmZmY4MTBlNmNiYj5dIHdvcmtlcl90aHJlYWQr
MHgxMWIvMHg1MjAKICAgIFsgOTA2NC4wMDg4NzBdICBbPGZmZmZmZmZmODEwZTZiYTA+XSA/IGNy
ZWF0ZV9hbmRfc3RhcnRfd29ya2VyKzB4NTAvMHg1MAogICAgWyA5MDY0LjAwODg3Ml0gIFs8ZmZm
ZmZmZmY4MTBlY2IyND5dIGt0aHJlYWQrMHhjNC8weGUwCiAgICBbIDkwNjQuMDA4ODc0XSAgWzxm
ZmZmZmZmZjgxMGVjYTYwPl0gPwogICAga3RocmVhZF9jcmVhdGVfb25fbm9kZSsweDE3MC8weDE3
MAogICAgWyA5MDY0LjAwODg3N10gIFs8ZmZmZmZmZmY4MTk5N2U2Yz5dIHJldF9mcm9tX2Zvcmsr
MHg3Yy8weGIwCiAgICBbIDkwNjQuMDA4ODc4XSAgWzxmZmZmZmZmZjgxMGVjYTYwPl0gPwogICAg
a3RocmVhZF9jcmVhdGVfb25fbm9kZSsweDE3MC8weDE3MAogICAgWyA5MDY0LjAwODg4MF0gLS0t
WyBlbmQgdHJhY2UgMTdmOTczOGYyMGFlYzI4OCBdLS0tCiAgICAKICAgIFRoaXMgZml4ZXMgdGhl
IGNhc2VzIEkgZm91bmQgZm9yIG15IHVzZWNhc2U6IGNsb3NpbmcgYW5kIG9wZW5pbmcgdGhlCiAg
ICBsaWQuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IElhbiBLdW1saWVuIDxpYW4ua3VtbGllbkBn
bWFpbC5jb20+CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfZHAuYyBi
L2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVsX2RwLmMKaW5kZXggOGExYTRmYi4uNGMzMjQ5ZCAx
MDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvaW50ZWxfZHAuYworKysgYi9kcml2ZXJz
L2dwdS9kcm0vaTkxNS9pbnRlbF9kcC5jCkBAIC0xMjUyLDYgKzEyNTIsNyBAQCBzdGF0aWMgdm9p
ZCBlZHBfcGFuZWxfdmRkX29mZl9zeW5jKHN0cnVjdCBpbnRlbF9kcCAqaW50ZWxfZHApCiAgICAg
ICAgICAgICAgICAgICAgICAgIGludGVsX2RwLT5sYXN0X3Bvd2VyX2N5Y2xlID0gamlmZmllczsK
IAogICAgICAgICAgICAgICAgcG93ZXJfZG9tYWluID0gaW50ZWxfZGlzcGxheV9wb3J0X3Bvd2Vy
X2RvbWFpbihpbnRlbF9lbmNvZGVyKTsKKyAgICAgICAgICAgICAgIGludGVsX2Rpc3BsYXlfcG93
ZXJfZ2V0KGRldl9wcml2LCBwb3dlcl9kb21haW4pOwogICAgICAgICAgICAgICAgaW50ZWxfZGlz
cGxheV9wb3dlcl9wdXQoZGV2X3ByaXYsIHBvd2VyX2RvbWFpbik7CiAgICAgICAgfQogfQpAQCAt
MTM3MSw2ICsxMzcyLDcgQEAgdm9pZCBpbnRlbF9lZHBfcGFuZWxfb2ZmKHN0cnVjdCBpbnRlbF9k
cCAqaW50ZWxfZHApCiAKICAgICAgICAvKiBXZSBnb3QgYSByZWZlcmVuY2Ugd2hlbiB3ZSBlbmFi
bGVkIHRoZSBWREQuICovCiAgICAgICAgcG93ZXJfZG9tYWluID0gaW50ZWxfZGlzcGxheV9wb3J0
X3Bvd2VyX2RvbWFpbihpbnRlbF9lbmNvZGVyKTsKKyAgICAgICBpbnRlbF9kaXNwbGF5X3Bvd2Vy
X2dldChkZXZfcHJpdiwgcG93ZXJfZG9tYWluKTsKICAgICAgICBpbnRlbF9kaXNwbGF5X3Bvd2Vy
X3B1dChkZXZfcHJpdiwgcG93ZXJfZG9tYWluKTsKIH0KCg==


--=-uCYhdq203uS4V1a37Tg/--

