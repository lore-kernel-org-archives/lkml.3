Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3FXNQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:16:41 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:49071 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3FXNQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:16:40 -0400
MIME-Version: 1.0
In-Reply-To: <11846442.bozySFIXTh@vostro.rjw.lan>
References: <cover.1371630975.git.viresh.kumar@linaro.org>
	<1894928.On8nI7rMdZ@vostro.rjw.lan>
	<CAKohpo=8oZKiq1ghuipitbfMp-bPxpWPQbGx5SLj9+_nGegCfA@mail.gmail.com>
	<11846442.bozySFIXTh@vostro.rjw.lan>
Date: Mon, 24 Jun 2013 18:46:39 +0530
Message-ID: <CAKohponQQphBGv9jUCF9_r2NQs7T=wkaWp_d5oO3RT=mY_zqcg@mail.gmail.com>
Subject: Re: [PATCH 13/13] cpufreq: make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com
Content-Type: multipart/mixed; boundary=089e011767bb0e2e8604dfe639e9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e011767bb0e2e8604dfe639e9
Content-Type: text/plain; charset=ISO-8859-1

On 24 June 2013 18:53, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> You can do
>
>         if (WARN(transition_ongoing, "<text>"))
>                 return;
>
> and below analogously.

Ahh.. stupid code.. Check if this fixup is fine (attached too)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6624694..6ca7eac 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -267,10 +267,9 @@ void __cpufreq_notify_transition(struct
cpufreq_policy *policy,
        switch (state) {

        case CPUFREQ_PRECHANGE:
-               if (transition_ongoing) {
-                       WARN(1, "In middle of another frequency transition\n");
+               if (WARN(transition_ongoing,
+                               "In middle of another frequency transition\n"))
                        return;
-               }

                transition_ongoing++;

@@ -293,10 +292,9 @@ void __cpufreq_notify_transition(struct
cpufreq_policy *policy,
                break;

        case CPUFREQ_POSTCHANGE:
-               if (!transition_ongoing) {
-                       WARN(1, "No frequency transition in progress\n");
+               if (WARN(!transition_ongoing,
+                               "No frequency transition in progress\n"))
                        return;
-               }

                transition_ongoing--;

--089e011767bb0e2e8604dfe639e9
Content-Type: application/octet-stream; 
	name="0001-cpufreq-make-sure-frequency-transitions-are-serializ.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-make-sure-frequency-transitions-are-serializ.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hibovtf40

RnJvbSAwMWE4NWM1ZTg2MGY0YjUyYTA5NDE4NTU5ZmQyN2Y0ODAzNTcyNzJmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8MDFhODVjNWU4NjBmNGI1MmEwOTQxODU1OWZkMjdm
NDgwMzU3MjcyZi4xMzcyMDc5NzgxLmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogV2VkLCAxOSBKdW4g
MjAxMyAxMDoxNjo1NSArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IG1ha2Ugc3VyZSBm
cmVxdWVuY3kgdHJhbnNpdGlvbnMgYXJlIHNlcmlhbGl6ZWQKCldoZW5ldmVyIHdlIGFyZSBjaGFu
Z2luZyBmcmVxdWVuY3kgb2YgYSBjcHUsIHdlIGFyZSBjYWxsaW5nIFBSRUNIQU5HRSBhbmQKUE9T
VENIQU5HRSBub3RpZmllcnMuIFRoZXkgbXVzdCBiZSBzZXJpYWxpemVkLiBpLmUuIFBSRUNIQU5H
RSBvciBQT1NUQ0hBTkdFCnNob3VsZG4ndCBiZSBjYWxsZWQgdHdpY2UgY29udGlndW91c2x5LgoK
VGhpcyBjYW4gaGFwcGVuIGR1ZSB0byBidWdzIGluIHVzZXJzIG9mIF9fY3B1ZnJlcV9kcml2ZXJf
dGFyZ2V0KCkgb3IgYWN0dWFsCmNwdWZyZXEgZHJpdmVycyB3aG8gYXJlIHNlbmRpbmcgdGhlc2Ug
bm90aWZpZXJzLgoKVGhpcyBwYXRjaCBhZGRzIHNvbWUgcHJvdGVjdGlvbiBhZ2FpbnN0IHRoaXMu
IE5vdywgd2Uga2VlcCB0cmFjayBvZiB0aGUgbGFzdAp0cmFuc2FjdGlvbiBhbmQgc2VlIGlmIHNv
bWV0aGluZyB3ZW50IHdyb25nLgoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2aXJlc2gu
a3VtYXJAbGluYXJvLm9yZz4KLS0tCiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIHwgMTcgKysr
KysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVx
LmMKaW5kZXggMmQ1M2Y0Ny4uNmNhN2VhYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVxL2Nw
dWZyZXEuYworKysgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jCkBAIC0xMDcsNiArMTA3LDkg
QEAgc3RhdGljIHZvaWQgaGFuZGxlX3VwZGF0ZShzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspOwog
c3RhdGljIEJMT0NLSU5HX05PVElGSUVSX0hFQUQoY3B1ZnJlcV9wb2xpY3lfbm90aWZpZXJfbGlz
dCk7CiBzdGF0aWMgc3RydWN0IHNyY3Vfbm90aWZpZXJfaGVhZCBjcHVmcmVxX3RyYW5zaXRpb25f
bm90aWZpZXJfbGlzdDsKIAorLyogVHJhY2tzIHN0YXR1cyBvZiB0cmFuc2l0aW9uICovCitzdGF0
aWMgaW50IHRyYW5zaXRpb25fb25nb2luZzsKKwogc3RhdGljIGJvb2wgaW5pdF9jcHVmcmVxX3Ry
YW5zaXRpb25fbm90aWZpZXJfbGlzdF9jYWxsZWQ7CiBzdGF0aWMgaW50IF9faW5pdCBpbml0X2Nw
dWZyZXFfdHJhbnNpdGlvbl9ub3RpZmllcl9saXN0KHZvaWQpCiB7CkBAIC0yNjQsNiArMjY3LDEy
IEBAIHZvaWQgX19jcHVmcmVxX25vdGlmeV90cmFuc2l0aW9uKHN0cnVjdCBjcHVmcmVxX3BvbGlj
eSAqcG9saWN5LAogCXN3aXRjaCAoc3RhdGUpIHsKIAogCWNhc2UgQ1BVRlJFUV9QUkVDSEFOR0U6
CisJCWlmIChXQVJOKHRyYW5zaXRpb25fb25nb2luZywKKwkJCQkiSW4gbWlkZGxlIG9mIGFub3Ro
ZXIgZnJlcXVlbmN5IHRyYW5zaXRpb25cbiIpKQorCQkJcmV0dXJuOworCisJCXRyYW5zaXRpb25f
b25nb2luZysrOworCiAJCS8qIGRldGVjdCBpZiB0aGUgZHJpdmVyIHJlcG9ydGVkIGEgdmFsdWUg
YXMgIm9sZCBmcmVxdWVuY3kiCiAJCSAqIHdoaWNoIGlzIG5vdCBlcXVhbCB0byB3aGF0IHRoZSBj
cHVmcmVxIGNvcmUgdGhpbmtzIGlzCiAJCSAqICJvbGQgZnJlcXVlbmN5Ii4KQEAgLTI4Myw2ICsy
OTIsMTIgQEAgdm9pZCBfX2NwdWZyZXFfbm90aWZ5X3RyYW5zaXRpb24oc3RydWN0IGNwdWZyZXFf
cG9saWN5ICpwb2xpY3ksCiAJCWJyZWFrOwogCiAJY2FzZSBDUFVGUkVRX1BPU1RDSEFOR0U6CisJ
CWlmIChXQVJOKCF0cmFuc2l0aW9uX29uZ29pbmcsCisJCQkJIk5vIGZyZXF1ZW5jeSB0cmFuc2l0
aW9uIGluIHByb2dyZXNzXG4iKSkKKwkJCXJldHVybjsKKworCQl0cmFuc2l0aW9uX29uZ29pbmct
LTsKKwogCQlhZGp1c3RfamlmZmllcyhDUFVGUkVRX1BPU1RDSEFOR0UsIGZyZXFzKTsKIAkJcHJf
ZGVidWcoIkZSRVE6ICVsdSAtIENQVTogJWx1IiwgKHVuc2lnbmVkIGxvbmcpZnJlcXMtPm5ldywK
IAkJCSh1bnNpZ25lZCBsb25nKWZyZXFzLT5jcHUpOwpAQCAtMTQ1OCw2ICsxNDczLDggQEAgaW50
IF9fY3B1ZnJlcV9kcml2ZXJfdGFyZ2V0KHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5LAog
CiAJaWYgKGNwdWZyZXFfZGlzYWJsZWQoKSkKIAkJcmV0dXJuIC1FTk9ERVY7CisJaWYgKHRyYW5z
aXRpb25fb25nb2luZykKKwkJcmV0dXJuIC1FQlVTWTsKIAogCS8qIE1ha2Ugc3VyZSB0aGF0IHRh
cmdldF9mcmVxIGlzIHdpdGhpbiBzdXBwb3J0ZWQgcmFuZ2UgKi8KIAlpZiAodGFyZ2V0X2ZyZXEg
PiBwb2xpY3ktPm1heCkKLS0gCjEuNy4xMi5yYzIuMTguZzYxYjQ3MmUKCg==
--089e011767bb0e2e8604dfe639e9--
