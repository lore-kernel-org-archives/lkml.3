Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3CYKYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:24:18 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:58858 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab3CYKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:24:14 -0400
MIME-Version: 1.0
In-Reply-To: <51501BD5.2070807@ti.com>
References: <2ece6d9fe8dfb6882a1c83a1cb2404bacc40b22d.1364138740.git.viresh.kumar@linaro.org>
	<07b96c5b68470001197445fb3d28786ad9acdbe0.1364138740.git.viresh.kumar@linaro.org>
	<51500C81.7040307@ti.com>
	<CAKohpomTt-ajNeh-OwV9X-HNBddJzL=JB+ggFY0msmsuZabvjA@mail.gmail.com>
	<51501BD5.2070807@ti.com>
Date: Mon, 25 Mar 2013 15:54:13 +0530
Message-ID: <CAKohpo=5RHRFw_OfVZHAoAR-3xnUTMot6z_h=cWsFFgn=Fzw2Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: drivers: Remove unnecessary assignments of
 policy-> members
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Sekhar Nori <nsekhar@ti.com>
Cc: rjw@sisk.pl, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Sascha Hauer <kernel@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: multipart/mixed; boundary=e89a8ff1c2d8dbd73704d8bd3423
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8ff1c2d8dbd73704d8bd3423
Content-Type: text/plain; charset=ISO-8859-1

On 25 March 2013 15:11, Sekhar Nori <nsekhar@ti.com> wrote:
> So down in the cpufreq driver probe below, we bail out if freq_table is
> not provided. So all this checking for freq_table in the code you pasted
> above is superfluous. If you can clean that part up and add checking for
> cpufreq_frequency_table_cpuinfo() as you proposed, I will be glad to
> test it out ;)

Attached is the complete patch and following is your fixup for davinci
(just to review):

diff --git a/arch/arm/mach-davinci/cpufreq.c b/arch/arm/mach-davinci/cpufreq.c
index ff46862..7c2e943 100644
--- a/arch/arm/mach-davinci/cpufreq.c
+++ b/arch/arm/mach-davinci/cpufreq.c
@@ -137,18 +137,17 @@ static int davinci_cpu_init(struct cpufreq_policy *policy)
                        return result;
        }

-       policy->cur = policy->min = policy->max = davinci_getspeed(0);
-
-       if (freq_table) {
-               result = cpufreq_frequency_table_cpuinfo(policy, freq_table);
-               if (!result)
-                       cpufreq_frequency_table_get_attr(freq_table,
-                                                       policy->cpu);
-       } else {
-               policy->cpuinfo.min_freq = policy->min;
-               policy->cpuinfo.max_freq = policy->max;
+       policy->cur = davinci_getspeed(0);
+
+       result = cpufreq_frequency_table_cpuinfo(policy, freq_table);
+       if (result) {
+               pr_err("%s: cpufreq_frequency_table_cpuinfo() failed",
+                               __func__);
+               return result;
        }

+       cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
+
        /*
         * Time measurement across the target() function yields ~1500-1800us
         * time taken with no drivers on notification list.

--e89a8ff1c2d8dbd73704d8bd3423
Content-Type: application/octet-stream; 
	name="0001-cpufreq-drivers-Remove-unnecessary-assignments-of-po.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-drivers-Remove-unnecessary-assignments-of-po.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hephnk9u0

RnJvbSAxZjc0MWM2ZTExNDMzMzkzNjFjMTIwMWNjYmEzMjM4YmNkOTliNTdkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8MWY3NDFjNmUxMTQzMzM5MzYxYzEyMDFjY2JhMzIz
OGJjZDk5YjU3ZC4xMzY0MjA3MDA5LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogU3VuLCAyNCBNYXIg
MjAxMyAyMDo1MTozMSArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IGRyaXZlcnM6IFJl
bW92ZSB1bm5lY2Vzc2FyeSBhc3NpZ25tZW50cyBvZiBwb2xpY3ktPgogbWVtYmVycwoKU29tZSBh
c3NpZ25tZW50cyBvZiBwb2xpY3ktPiBtaW4vbWF4L2N1ci9jcHVpbmZvLm1pbl9mcmVxL2NwdWlu
Zm8ubWF4X2ZyZXEKYXJlbid0IHJlcXVpcmVkIGFzIHBhcnQgb2YgaXQgaXMgZG9uZSBieSBjcHVm
cmVxIGRyaXZlciBvciBjcHVmcmVxIGNvcmUuCgpSZW1vdmUgdGhlbS4KCkF0IHNvbWUgcGxhY2Vz
IHdlIG1lcmdlIG11bHRpcGxlIGxpbmVzIHRvZ2V0aGVyIHRvby4KClNpZ25lZC1vZmYtYnk6IFZp
cmVzaCBLdW1hciA8dmlyZXNoLmt1bWFyQGxpbmFyby5vcmc+Ci0tLQogRG9jdW1lbnRhdGlvbi9j
cHUtZnJlcS9jcHUtZHJpdmVycy50eHQgfCAgNSArKystLQogYXJjaC9hcm0vbWFjaC1kYXZpbmNp
L2NwdWZyZXEuYyAgICAgICAgfCAyMSArKysrKysrKy0tLS0tLS0tLS0tLS0KIGFyY2gvYXJtL21h
Y2gtaW14L2NwdWZyZXEuYyAgICAgICAgICAgIHwgIDMgLS0tCiBhcmNoL3NoL2tlcm5lbC9jcHVm
cmVxLmMgICAgICAgICAgICAgICB8ICA5ICsrKy0tLS0tLQogZHJpdmVycy9jcHVmcmVxL2NwdWZy
ZXEtbmZvcmNlMi5jICAgICAgfCAgNiArKy0tLS0KIGRyaXZlcnMvY3B1ZnJlcS9vbWFwLWNwdWZy
ZXEuYyAgICAgICAgIHwgIDQgKy0tLQogNiBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCsp
LCAzMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2NwdS1mcmVxL2Nw
dS1kcml2ZXJzLnR4dCBiL0RvY3VtZW50YXRpb24vY3B1LWZyZXEvY3B1LWRyaXZlcnMudHh0Cmlu
ZGV4IDcyZjcwYjEuLmM5NDM4M2YgMTAwNjQ0Ci0tLSBhL0RvY3VtZW50YXRpb24vY3B1LWZyZXEv
Y3B1LWRyaXZlcnMudHh0CisrKyBiL0RvY3VtZW50YXRpb24vY3B1LWZyZXEvY3B1LWRyaXZlcnMu
dHh0CkBAIC0xMDgsOCArMTA4LDkgQEAgcG9saWN5LT5nb3Zlcm5vcgkJbXVzdCBjb250YWluIHRo
ZSAiZGVmYXVsdCBwb2xpY3kiIGZvcgogCQkJCWNwdWZyZXFfZHJpdmVyLnRhcmdldCBpcyBjYWxs
ZWQgd2l0aAogCQkJCXRoZXNlIHZhbHVlcy4KIAotRm9yIHNldHRpbmcgc29tZSBvZiB0aGVzZSB2
YWx1ZXMsIHRoZSBmcmVxdWVuY3kgdGFibGUgaGVscGVycyBtaWdodCBiZQotaGVscGZ1bC4gU2Vl
IHRoZSBzZWN0aW9uIDIgZm9yIG1vcmUgaW5mb3JtYXRpb24gb24gdGhlbS4KK0ZvciBzZXR0aW5n
IHNvbWUgb2YgdGhlc2UgdmFsdWVzIChjcHVpbmZvLm1pblttYXhdX2ZyZXEsIHBvbGljeS0+bWlu
W21heF0pLCB0aGUKK2ZyZXF1ZW5jeSB0YWJsZSBoZWxwZXJzIG1pZ2h0IGJlIGhlbHBmdWwuIFNl
ZSB0aGUgc2VjdGlvbiAyIGZvciBtb3JlIGluZm9ybWF0aW9uCitvbiB0aGVtLgogCiBTTVAgc3lz
dGVtcyBub3JtYWxseSBoYXZlIHNhbWUgY2xvY2sgc291cmNlIGZvciBhIGdyb3VwIG9mIGNwdXMu
IEZvciB0aGVzZSB0aGUKIC5pbml0KCkgd291bGQgYmUgY2FsbGVkIG9ubHkgb25jZSBmb3IgdGhl
IGZpcnN0IG9ubGluZSBjcHUuIEhlcmUgdGhlIC5pbml0KCkKZGlmZiAtLWdpdCBhL2FyY2gvYXJt
L21hY2gtZGF2aW5jaS9jcHVmcmVxLmMgYi9hcmNoL2FybS9tYWNoLWRhdmluY2kvY3B1ZnJlcS5j
CmluZGV4IDhmYjBjMmEuLjdjMmU5NDMgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtL21hY2gtZGF2aW5j
aS9jcHVmcmVxLmMKKysrIGIvYXJjaC9hcm0vbWFjaC1kYXZpbmNpL2NwdWZyZXEuYwpAQCAtMTM3
LDIxICsxMzcsMTYgQEAgc3RhdGljIGludCBkYXZpbmNpX2NwdV9pbml0KHN0cnVjdCBjcHVmcmVx
X3BvbGljeSAqcG9saWN5KQogCQkJcmV0dXJuIHJlc3VsdDsKIAl9CiAKLQlwb2xpY3ktPmN1ciA9
IHBvbGljeS0+bWluID0gcG9saWN5LT5tYXggPSBkYXZpbmNpX2dldHNwZWVkKDApOwotCi0JaWYg
KGZyZXFfdGFibGUpIHsKLQkJcmVzdWx0ID0gY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGVfY3B1aW5m
byhwb2xpY3ksIGZyZXFfdGFibGUpOwotCQlpZiAoIXJlc3VsdCkKLQkJCWNwdWZyZXFfZnJlcXVl
bmN5X3RhYmxlX2dldF9hdHRyKGZyZXFfdGFibGUsCi0JCQkJCQkJcG9saWN5LT5jcHUpOwotCX0g
ZWxzZSB7Ci0JCXBvbGljeS0+Y3B1aW5mby5taW5fZnJlcSA9IHBvbGljeS0+bWluOwotCQlwb2xp
Y3ktPmNwdWluZm8ubWF4X2ZyZXEgPSBwb2xpY3ktPm1heDsKKwlwb2xpY3ktPmN1ciA9IGRhdmlu
Y2lfZ2V0c3BlZWQoMCk7CisKKwlyZXN1bHQgPSBjcHVmcmVxX2ZyZXF1ZW5jeV90YWJsZV9jcHVp
bmZvKHBvbGljeSwgZnJlcV90YWJsZSk7CisJaWYgKHJlc3VsdCkgeworCQlwcl9lcnIoIiVzOiBj
cHVmcmVxX2ZyZXF1ZW5jeV90YWJsZV9jcHVpbmZvKCkgZmFpbGVkIiwKKwkJCQlfX2Z1bmNfXyk7
CisJCXJldHVybiByZXN1bHQ7CiAJfQogCi0JcG9saWN5LT5taW4gPSBwb2xpY3ktPmNwdWluZm8u
bWluX2ZyZXE7Ci0JcG9saWN5LT5tYXggPSBwb2xpY3ktPmNwdWluZm8ubWF4X2ZyZXE7Ci0JcG9s
aWN5LT5jdXIgPSBkYXZpbmNpX2dldHNwZWVkKDApOworCWNwdWZyZXFfZnJlcXVlbmN5X3RhYmxl
X2dldF9hdHRyKGZyZXFfdGFibGUsIHBvbGljeS0+Y3B1KTsKIAogCS8qCiAJICogVGltZSBtZWFz
dXJlbWVudCBhY3Jvc3MgdGhlIHRhcmdldCgpIGZ1bmN0aW9uIHlpZWxkcyB+MTUwMC0xODAwdXMK
ZGlmZiAtLWdpdCBhL2FyY2gvYXJtL21hY2gtaW14L2NwdWZyZXEuYyBiL2FyY2gvYXJtL21hY2gt
aW14L2NwdWZyZXEuYwppbmRleCBjZmNlNWUzLi4zODdkYzRjIDEwMDY0NAotLS0gYS9hcmNoL2Fy
bS9tYWNoLWlteC9jcHVmcmVxLmMKKysrIGIvYXJjaC9hcm0vbWFjaC1pbXgvY3B1ZnJlcS5jCkBA
IC0xNDQsMTQgKzE0NCwxMSBAQCBzdGF0aWMgaW50IG14Y19jcHVmcmVxX2luaXQoc3RydWN0IGNw
dWZyZXFfcG9saWN5ICpwb2xpY3kpCiAJaW14X2ZyZXFfdGFibGVbaV0uZnJlcXVlbmN5ID0gQ1BV
RlJFUV9UQUJMRV9FTkQ7CiAKIAlwb2xpY3ktPmN1ciA9IGNsa19nZXRfcmF0ZShjcHVfY2xrKSAv
IDEwMDA7Ci0JcG9saWN5LT5taW4gPSBwb2xpY3ktPmNwdWluZm8ubWluX2ZyZXEgPSBjcHVfZnJl
cV9raHpfbWluOwotCXBvbGljeS0+bWF4ID0gcG9saWN5LT5jcHVpbmZvLm1heF9mcmVxID0gY3B1
X2ZyZXFfa2h6X21heDsKIAogCS8qIE1hbnVhbCBzdGF0ZXMsIHRoYXQgUExMIHN0YWJpbGl6ZXMg
aW4gdHdvIENMSzMyIHBlcmlvZHMgKi8KIAlwb2xpY3ktPmNwdWluZm8udHJhbnNpdGlvbl9sYXRl
bmN5ID0gMiAqIE5BTk9TRUNPTkQgLyBDTEszMl9GUkVROwogCiAJcmV0ID0gY3B1ZnJlcV9mcmVx
dWVuY3lfdGFibGVfY3B1aW5mbyhwb2xpY3ksIGlteF9mcmVxX3RhYmxlKTsKLQogCWlmIChyZXQg
PCAwKSB7CiAJCXByaW50ayhLRVJOX0VSUiAiJXM6IGZhaWxlZCB0byByZWdpc3RlciBpLk1YQyBD
UFVmcmVxIHdpdGggZXJyb3IgY29kZSAlZFxuIiwKIAkJICAgICAgIF9fZnVuY19fLCByZXQpOwpk
aWZmIC0tZ2l0IGEvYXJjaC9zaC9rZXJuZWwvY3B1ZnJlcS5jIGIvYXJjaC9zaC9rZXJuZWwvY3B1
ZnJlcS5jCmluZGV4IDBmZGY2NGIuLjg4YzhmZWUgMTAwNjQ0Ci0tLSBhL2FyY2gvc2gva2VybmVs
L2NwdWZyZXEuYworKysgYi9hcmNoL3NoL2tlcm5lbC9jcHVmcmVxLmMKQEAgLTExNiw3ICsxMTYs
NyBAQCBzdGF0aWMgaW50IHNoX2NwdWZyZXFfY3B1X2luaXQoc3RydWN0IGNwdWZyZXFfcG9saWN5
ICpwb2xpY3kpCiAJCXJldHVybiBQVFJfRVJSKGNwdWNsayk7CiAJfQogCi0JcG9saWN5LT5jdXIg
PSBwb2xpY3ktPm1pbiA9IHBvbGljeS0+bWF4ID0gc2hfY3B1ZnJlcV9nZXQoY3B1KTsKKwlwb2xp
Y3ktPmN1ciA9IHNoX2NwdWZyZXFfZ2V0KGNwdSk7CiAKIAlmcmVxX3RhYmxlID0gY3B1Y2xrLT5u
cl9mcmVxcyA/IGNwdWNsay0+ZnJlcV90YWJsZSA6IE5VTEw7CiAJaWYgKGZyZXFfdGFibGUpIHsK
QEAgLTEyOSwxNSArMTI5LDEyIEBAIHN0YXRpYyBpbnQgc2hfY3B1ZnJlcV9jcHVfaW5pdChzdHJ1
Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSkKIAkJZGV2X25vdGljZShkZXYsICJubyBmcmVxdWVu
Y3kgdGFibGUgZm91bmQsIGZhbGxpbmcgYmFjayAiCiAJCQkgICAidG8gcmF0ZSByb3VuZGluZy5c
biIpOwogCi0JCXBvbGljeS0+Y3B1aW5mby5taW5fZnJlcSA9CisJCXBvbGljeS0+bWluID0gcG9s
aWN5LT5jcHVpbmZvLm1pbl9mcmVxID0KIAkJCShjbGtfcm91bmRfcmF0ZShjcHVjbGssIDEpICsg
NTAwKSAvIDEwMDA7Ci0JCXBvbGljeS0+Y3B1aW5mby5tYXhfZnJlcSA9CisJCXBvbGljeS0+bWF4
ID0gcG9saWN5LT5jcHVpbmZvLm1heF9mcmVxID0KIAkJCShjbGtfcm91bmRfcmF0ZShjcHVjbGss
IH4wVUwpICsgNTAwKSAvIDEwMDA7CiAJfQogCi0JcG9saWN5LT5taW4gPSBwb2xpY3ktPmNwdWlu
Zm8ubWluX2ZyZXE7Ci0JcG9saWN5LT5tYXggPSBwb2xpY3ktPmNwdWluZm8ubWF4X2ZyZXE7Ci0K
IAlwb2xpY3ktPmNwdWluZm8udHJhbnNpdGlvbl9sYXRlbmN5ID0gQ1BVRlJFUV9FVEVSTkFMOwog
CiAJZGV2X2luZm8oZGV2LCAiQ1BVIEZyZXF1ZW5jaWVzIC0gTWluaW11bSAldS4lMDN1IE1Ieiwg
IgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEtbmZvcmNlMi5jIGIvZHJpdmVy
cy9jcHVmcmVxL2NwdWZyZXEtbmZvcmNlMi5jCmluZGV4IDIyNGE0NzguLmFmMTU0MmQgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLW5mb3JjZTIuYworKysgYi9kcml2ZXJzL2Nw
dWZyZXEvY3B1ZnJlcS1uZm9yY2UyLmMKQEAgLTM1OSwxMiArMzU5LDEwIEBAIHN0YXRpYyBpbnQg
bmZvcmNlMl9jcHVfaW5pdChzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSkKIAkJbWluX2Zz
YiA9IE5GT1JDRTJfTUlOX0ZTQjsKIAogCS8qIGNwdWluZm8gYW5kIGRlZmF1bHQgcG9saWN5IHZh
bHVlcyAqLwotCXBvbGljeS0+Y3B1aW5mby5taW5fZnJlcSA9IG1pbl9mc2IgKiBmaWQgKiAxMDA7
Ci0JcG9saWN5LT5jcHVpbmZvLm1heF9mcmVxID0gbWF4X2ZzYiAqIGZpZCAqIDEwMDsKKwlwb2xp
Y3ktPm1pbiA9IHBvbGljeS0+Y3B1aW5mby5taW5fZnJlcSA9IG1pbl9mc2IgKiBmaWQgKiAxMDA7
CisJcG9saWN5LT5tYXggPSBwb2xpY3ktPmNwdWluZm8ubWF4X2ZyZXEgPSBtYXhfZnNiICogZmlk
ICogMTAwOwogCXBvbGljeS0+Y3B1aW5mby50cmFuc2l0aW9uX2xhdGVuY3kgPSBDUFVGUkVRX0VU
RVJOQUw7CiAJcG9saWN5LT5jdXIgPSBuZm9yY2UyX2dldChwb2xpY3ktPmNwdSk7Ci0JcG9saWN5
LT5taW4gPSBwb2xpY3ktPmNwdWluZm8ubWluX2ZyZXE7Ci0JcG9saWN5LT5tYXggPSBwb2xpY3kt
PmNwdWluZm8ubWF4X2ZyZXE7CiAKIAlyZXR1cm4gMDsKIH0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
Y3B1ZnJlcS9vbWFwLWNwdWZyZXEuYyBiL2RyaXZlcnMvY3B1ZnJlcS9vbWFwLWNwdWZyZXEuYwpp
bmRleCBiNjEwZWRkLi5hZDc1NDljIDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvb21hcC1j
cHVmcmVxLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL29tYXAtY3B1ZnJlcS5jCkBAIC0xNzcsNyAr
MTc3LDcgQEAgc3RhdGljIGludCBfX2NwdWluaXQgb21hcF9jcHVfaW5pdChzdHJ1Y3QgY3B1ZnJl
cV9wb2xpY3kgKnBvbGljeSkKIAkJZ290byBmYWlsX2NrOwogCX0KIAotCXBvbGljeS0+Y3VyID0g
cG9saWN5LT5taW4gPSBwb2xpY3ktPm1heCA9IG9tYXBfZ2V0c3BlZWQocG9saWN5LT5jcHUpOwor
CXBvbGljeS0+Y3VyID0gb21hcF9nZXRzcGVlZChwb2xpY3ktPmNwdSk7CiAKIAlpZiAoIWZyZXFf
dGFibGUpCiAJCXJlc3VsdCA9IG9wcF9pbml0X2NwdWZyZXFfdGFibGUobXB1X2RldiwgJmZyZXFf
dGFibGUpOwpAQCAtMTk2LDggKzE5Niw2IEBAIHN0YXRpYyBpbnQgX19jcHVpbml0IG9tYXBfY3B1
X2luaXQoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3kpCiAKIAljcHVmcmVxX2ZyZXF1ZW5j
eV90YWJsZV9nZXRfYXR0cihmcmVxX3RhYmxlLCBwb2xpY3ktPmNwdSk7CiAKLQlwb2xpY3ktPm1p
biA9IHBvbGljeS0+Y3B1aW5mby5taW5fZnJlcTsKLQlwb2xpY3ktPm1heCA9IHBvbGljeS0+Y3B1
aW5mby5tYXhfZnJlcTsKIAlwb2xpY3ktPmN1ciA9IG9tYXBfZ2V0c3BlZWQocG9saWN5LT5jcHUp
OwogCiAJLyoKLS0gCjEuNy4xMi5yYzIuMTguZzYxYjQ3MmUKCg==
--e89a8ff1c2d8dbd73704d8bd3423--
