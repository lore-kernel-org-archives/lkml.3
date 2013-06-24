Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135Ab3FXNIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:08:22 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:54127 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3FXNIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:08:19 -0400
MIME-Version: 1.0
In-Reply-To: <1894928.On8nI7rMdZ@vostro.rjw.lan>
References: <cover.1371630975.git.viresh.kumar@linaro.org>
	<0bebf56a27f799a282cc00d0c17c187f9941f122.1371630975.git.viresh.kumar@linaro.org>
	<1894928.On8nI7rMdZ@vostro.rjw.lan>
Date: Mon, 24 Jun 2013 18:38:17 +0530
Message-ID: <CAKohpo=8oZKiq1ghuipitbfMp-bPxpWPQbGx5SLj9+_nGegCfA@mail.gmail.com>
Subject: Re: [PATCH 13/13] cpufreq: make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com
Content-Type: multipart/mixed; boundary=047d7b33caf82b262504dfe61b4a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b33caf82b262504dfe61b4a
Content-Type: text/plain; charset=ISO-8859-1

On 24 June 2013 17:13, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, June 19, 2013 02:23:07 PM Viresh Kumar wrote:
>>       case CPUFREQ_POSTCHANGE:
>> +             WARN_ON(!transition_ongoing--);
>
> Shouldn't we try to avoid going into the negative range here?

What about this patch? Find it attached to apply.

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2d53f47..6624694 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -107,6 +107,9 @@ static void handle_update(struct work_struct *work);
 static BLOCKING_NOTIFIER_HEAD(cpufreq_policy_notifier_list);
 static struct srcu_notifier_head cpufreq_transition_notifier_list;

+/* Tracks status of transition */
+static int transition_ongoing;
+
 static bool init_cpufreq_transition_notifier_list_called;
 static int __init init_cpufreq_transition_notifier_list(void)
 {
@@ -264,6 +267,13 @@ void __cpufreq_notify_transition(struct
cpufreq_policy *policy,
        switch (state) {

        case CPUFREQ_PRECHANGE:
+               if (transition_ongoing) {
+                       WARN(1, "In middle of another frequency transition\n");
+                       return;
+               }
+
+               transition_ongoing++;
+
                /* detect if the driver reported a value as "old frequency"
                 * which is not equal to what the cpufreq core thinks is
                 * "old frequency".
@@ -283,6 +293,13 @@ void __cpufreq_notify_transition(struct
cpufreq_policy *policy,
                break;

        case CPUFREQ_POSTCHANGE:
+               if (!transition_ongoing) {
+                       WARN(1, "No frequency transition in progress\n");
+                       return;
+               }
+
+               transition_ongoing--;
+
                adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
                pr_debug("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
                        (unsigned long)freqs->cpu);
@@ -1458,6 +1475,8 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,

        if (cpufreq_disabled())
                return -ENODEV;
+       if (transition_ongoing)
+               return -EBUSY;

        /* Make sure that target_freq is within supported range */
        if (target_freq > policy->max)

--047d7b33caf82b262504dfe61b4a
Content-Type: application/octet-stream; 
	name="0001-cpufreq-make-sure-frequency-transitions-are-serializ.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-make-sure-frequency-transitions-are-serializ.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hibojz1k0

RnJvbSAyNWZiNmU2MTY0YjEwN2YxNjc0ZWMzMmYwZDBlNDczMjhjMmMxMWE2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8MjVmYjZlNjE2NGIxMDdmMTY3NGVjMzJmMGQwZTQ3
MzI4YzJjMTFhNi4xMzcyMDc5MjM0LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
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
a3VtYXJAbGluYXJvLm9yZz4KLS0tCiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIHwgMTkgKysr
KysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKykKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZy
ZXEuYwppbmRleCAyZDUzZjQ3Li42NjI0Njk0IDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEv
Y3B1ZnJlcS5jCisrKyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMKQEAgLTEwNyw2ICsxMDcs
OSBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfdXBkYXRlKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yayk7
CiBzdGF0aWMgQkxPQ0tJTkdfTk9USUZJRVJfSEVBRChjcHVmcmVxX3BvbGljeV9ub3RpZmllcl9s
aXN0KTsKIHN0YXRpYyBzdHJ1Y3Qgc3JjdV9ub3RpZmllcl9oZWFkIGNwdWZyZXFfdHJhbnNpdGlv
bl9ub3RpZmllcl9saXN0OwogCisvKiBUcmFja3Mgc3RhdHVzIG9mIHRyYW5zaXRpb24gKi8KK3N0
YXRpYyBpbnQgdHJhbnNpdGlvbl9vbmdvaW5nOworCiBzdGF0aWMgYm9vbCBpbml0X2NwdWZyZXFf
dHJhbnNpdGlvbl9ub3RpZmllcl9saXN0X2NhbGxlZDsKIHN0YXRpYyBpbnQgX19pbml0IGluaXRf
Y3B1ZnJlcV90cmFuc2l0aW9uX25vdGlmaWVyX2xpc3Qodm9pZCkKIHsKQEAgLTI2NCw2ICsyNjcs
MTMgQEAgdm9pZCBfX2NwdWZyZXFfbm90aWZ5X3RyYW5zaXRpb24oc3RydWN0IGNwdWZyZXFfcG9s
aWN5ICpwb2xpY3ksCiAJc3dpdGNoIChzdGF0ZSkgewogCiAJY2FzZSBDUFVGUkVRX1BSRUNIQU5H
RToKKwkJaWYgKHRyYW5zaXRpb25fb25nb2luZykgeworCQkJV0FSTigxLCAiSW4gbWlkZGxlIG9m
IGFub3RoZXIgZnJlcXVlbmN5IHRyYW5zaXRpb25cbiIpOworCQkJcmV0dXJuOworCQl9CisKKwkJ
dHJhbnNpdGlvbl9vbmdvaW5nKys7CisKIAkJLyogZGV0ZWN0IGlmIHRoZSBkcml2ZXIgcmVwb3J0
ZWQgYSB2YWx1ZSBhcyAib2xkIGZyZXF1ZW5jeSIKIAkJICogd2hpY2ggaXMgbm90IGVxdWFsIHRv
IHdoYXQgdGhlIGNwdWZyZXEgY29yZSB0aGlua3MgaXMKIAkJICogIm9sZCBmcmVxdWVuY3kiLgpA
QCAtMjgzLDYgKzI5MywxMyBAQCB2b2lkIF9fY3B1ZnJlcV9ub3RpZnlfdHJhbnNpdGlvbihzdHJ1
Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKIAkJYnJlYWs7CiAKIAljYXNlIENQVUZSRVFfUE9T
VENIQU5HRToKKwkJaWYgKCF0cmFuc2l0aW9uX29uZ29pbmcpIHsKKwkJCVdBUk4oMSwgIk5vIGZy
ZXF1ZW5jeSB0cmFuc2l0aW9uIGluIHByb2dyZXNzXG4iKTsKKwkJCXJldHVybjsKKwkJfQorCisJ
CXRyYW5zaXRpb25fb25nb2luZy0tOworCiAJCWFkanVzdF9qaWZmaWVzKENQVUZSRVFfUE9TVENI
QU5HRSwgZnJlcXMpOwogCQlwcl9kZWJ1ZygiRlJFUTogJWx1IC0gQ1BVOiAlbHUiLCAodW5zaWdu
ZWQgbG9uZylmcmVxcy0+bmV3LAogCQkJKHVuc2lnbmVkIGxvbmcpZnJlcXMtPmNwdSk7CkBAIC0x
NDU4LDYgKzE0NzUsOCBAQCBpbnQgX19jcHVmcmVxX2RyaXZlcl90YXJnZXQoc3RydWN0IGNwdWZy
ZXFfcG9saWN5ICpwb2xpY3ksCiAKIAlpZiAoY3B1ZnJlcV9kaXNhYmxlZCgpKQogCQlyZXR1cm4g
LUVOT0RFVjsKKwlpZiAodHJhbnNpdGlvbl9vbmdvaW5nKQorCQlyZXR1cm4gLUVCVVNZOwogCiAJ
LyogTWFrZSBzdXJlIHRoYXQgdGFyZ2V0X2ZyZXEgaXMgd2l0aGluIHN1cHBvcnRlZCByYW5nZSAq
LwogCWlmICh0YXJnZXRfZnJlcSA+IHBvbGljeS0+bWF4KQotLSAKMS43LjEyLnJjMi4xOC5nNjFi
NDcyZQoK
--047d7b33caf82b262504dfe61b4a--
