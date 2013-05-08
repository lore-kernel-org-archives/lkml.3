Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3EHCpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:45:22 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:46560 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3EHCpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:45:20 -0400
MIME-Version: 1.0
From: Lianwei Wang <lianwei.wang@gmail.com>
Date: Wed, 8 May 2013 10:44:59 +0800
Message-ID: <CAJFUiJiMMAgLGF3tiG1V59dx+KOpTBCEL3ctHUosjMDkBagbJg@mail.gmail.com>
Subject: [PATCH] cpuidle: don't wakeup processor when set a longer latency
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Content-Type: multipart/mixed; boundary=089e0149c552baf38c04dc2bec51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0149c552baf38c04dc2bec51
Content-Type: text/plain; charset=ISO-8859-1

When a PM-Qos is updated, the cpuidle driver will wakeup all the CPUs
no matter what a latency is set. But actually it only need to wakeup
the CPUs when a shorter latency is set. In this way we can reduce the
cpu wakeup count and save battery.

So we can pass the prev_value to the notifier callback and check the
latency curr_value and prev_value in the cpuidle latency notifier
callback. It modify a common interface(dummy --> prev_value) but shall
be safe since no one use the dummy parameter currently.

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index e1f6860..1e1758c 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -498,7 +498,11 @@ static void smp_callback(void *v)
 static int cpuidle_latency_notify(struct notifier_block *b,
                unsigned long l, void *v)
 {
-       smp_call_function(smp_callback, NULL, 1);
+       unsigned long prev_value = (unsigned long) v;
+
+       /* Dont't waktup processor when set a longer latency */
+       if (l < prev_value)
+               smp_call_function(smp_callback, NULL, 1);
        return NOTIFY_OK;
 }

diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index 9322ff7..533b8bc 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -205,7 +205,7 @@ int pm_qos_update_target(struct pm_qos_constraints
*c, struct plist_node *node,
        if (prev_value != curr_value) {
                blocking_notifier_call_chain(c->notifiers,
                                             (unsigned long)curr_value,
-                                            NULL);
+                                            (void *)prev_value);
                return 1;
        } else {
                return 0;

--089e0149c552baf38c04dc2bec51
Content-Type: application/octet-stream; 
	name="0001-cpuidle-don-t-wakeup-processor-when-set-a-longer-lat.patch"
Content-Disposition: attachment; 
	filename="0001-cpuidle-don-t-wakeup-processor-when-set-a-longer-lat.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hgfwd46d0

RnJvbSAwMGQ1ZTJkZGIxYzU2ZjM2MzU4YmUyOTBjMjEwNGU5ZmVlYzg0NDY1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaWFud2VpIFdhbmcgPGxpYW53ZWkud2FuZ0BnbWFpbC5jb20+
CkRhdGU6IEZyaSwgMjYgQXByIDIwMTMgMTA6NTk6MjQgKzA4MDAKU3ViamVjdDogW1BBVENIXSBj
cHVpZGxlOiBkb24ndCB3YWtldXAgcHJvY2Vzc29yIHdoZW4gc2V0IGEgbG9uZ2VyIGxhdGVuY3kK
CldlIGRvbid0IG5lZWQgd2FrZXVwIHRoZSBvdGhlciBDUFVzIGltbWVkaWF0ZWx5IGlmIGEgbG9u
Z2VyIGxhdGVuY3kKaXMgc2V0LiBQYXNzIHRoZSBwcmV2X3ZhbHVlIHRvIHRoZSBub3RpZmllciBj
YWxsYmFjayBzbyB0aGUgbGF0ZW5jeQpjYW4gYmUgY2hlY2tlZCBpbiBjcHVpZGxlIGRyaXZlciBh
bmQgb25seSB3YWtldXAgYWxsIHRoZSBvdGhlciBDUFVzCndoZW4gYSBzaG9ydGVyIGxhdGVuY3kg
aXMgc2V0LgoKQ2hhbmdlLUlkOiBJZjU2NGZkMGQ5YzUzY2YxMDBiZDg1MjQ3YmZkNTA5ZGZlYWY1
NGMxMwpTaWduZWQtb2ZmLWJ5OiBMaWFud2VpIFdhbmcgPGxpYW53ZWkud2FuZ0BnbWFpbC5jb20+
Ci0tLQogZHJpdmVycy9jcHVpZGxlL2NwdWlkbGUuYyB8ICAgIDYgKysrKystCiBrZXJuZWwvcG93
ZXIvcW9zLmMgICAgICAgIHwgICAgMiArLQogMiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVpZGxlL2NwdWlkbGUu
YyBiL2RyaXZlcnMvY3B1aWRsZS9jcHVpZGxlLmMKaW5kZXggZTFmNjg2MC4uMWUxNzU4YyAxMDA2
NDQKLS0tIGEvZHJpdmVycy9jcHVpZGxlL2NwdWlkbGUuYworKysgYi9kcml2ZXJzL2NwdWlkbGUv
Y3B1aWRsZS5jCkBAIC00OTgsNyArNDk4LDExIEBAIHN0YXRpYyB2b2lkIHNtcF9jYWxsYmFjayh2
b2lkICp2KQogc3RhdGljIGludCBjcHVpZGxlX2xhdGVuY3lfbm90aWZ5KHN0cnVjdCBub3RpZmll
cl9ibG9jayAqYiwKIAkJdW5zaWduZWQgbG9uZyBsLCB2b2lkICp2KQogewotCXNtcF9jYWxsX2Z1
bmN0aW9uKHNtcF9jYWxsYmFjaywgTlVMTCwgMSk7CisJdW5zaWduZWQgbG9uZyBwcmV2X3ZhbHVl
ID0gKHVuc2lnbmVkIGxvbmcpIHY7CisKKwkvKiBEb250J3Qgd2FrdHVwIHByb2Nlc3NvciB3aGVu
IHNldCBhIGxvbmdlciBsYXRlbmN5ICovCisJaWYgKGwgPCBwcmV2X3ZhbHVlKQorCQlzbXBfY2Fs
bF9mdW5jdGlvbihzbXBfY2FsbGJhY2ssIE5VTEwsIDEpOwogCXJldHVybiBOT1RJRllfT0s7CiB9
CiAKZGlmZiAtLWdpdCBhL2tlcm5lbC9wb3dlci9xb3MuYyBiL2tlcm5lbC9wb3dlci9xb3MuYwpp
bmRleCA5MzIyZmY3Li41MzNiOGJjIDEwMDY0NAotLS0gYS9rZXJuZWwvcG93ZXIvcW9zLmMKKysr
IGIva2VybmVsL3Bvd2VyL3Fvcy5jCkBAIC0yMDUsNyArMjA1LDcgQEAgaW50IHBtX3Fvc191cGRh
dGVfdGFyZ2V0KHN0cnVjdCBwbV9xb3NfY29uc3RyYWludHMgKmMsIHN0cnVjdCBwbGlzdF9ub2Rl
ICpub2RlLAogCWlmIChwcmV2X3ZhbHVlICE9IGN1cnJfdmFsdWUpIHsKIAkJYmxvY2tpbmdfbm90
aWZpZXJfY2FsbF9jaGFpbihjLT5ub3RpZmllcnMsCiAJCQkJCSAgICAgKHVuc2lnbmVkIGxvbmcp
Y3Vycl92YWx1ZSwKLQkJCQkJICAgICBOVUxMKTsKKwkJCQkJICAgICAodm9pZCAqKXByZXZfdmFs
dWUpOwogCQlyZXR1cm4gMTsKIAl9IGVsc2UgewogCQlyZXR1cm4gMDsKLS0gCjEuNy40LjEKCg==
--089e0149c552baf38c04dc2bec51--
