Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3F0E4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 00:56:30 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35642 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3F0E42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 00:56:28 -0400
MIME-Version: 1.0
In-Reply-To: <2081161.dnl1xTqcUT@vostro.rjw.lan>
References: <cover.1371630975.git.viresh.kumar@linaro.org>
	<2165396.dF1lQyPRVT@vostro.rjw.lan>
	<CAKohponyMG-uA93ZpH-KD+EOQPmk5tT_QoaQ7+NCEf48vYj5-w@mail.gmail.com>
	<2081161.dnl1xTqcUT@vostro.rjw.lan>
Date: Thu, 27 Jun 2013 10:26:27 +0530
Message-ID: <CAKohpomGNSA4Pyg6Pn2SiawXPe=wMU7hx0Y7phjfNDV8J+JrLw@mail.gmail.com>
Subject: Re: [PATCH 13/13] cpufreq: make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com
Content-Type: multipart/mixed; boundary=047d7b4728b4b9478104e01b957c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b4728b4b9478104e01b957c
Content-Type: text/plain; charset=ISO-8859-1

On 27 June 2013 03:27, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Well, now, seeing that the locking around this seems to be kind of haphazard,
> I'm wondering what prevents two different threads from doing CPUFREQ_PRECHANGE
> concurrently in such a way that thread A will check transition_ongoing
> and thread B will check transition_ongoing and then both will set it if it
> was 'false' before.  And then one of them will trigger the WARN() in
> CPUFREQ_POSTCHANGE.
>
> Is there any protection in place and if so then how does it work?

cpufreq_notify_transition() is called from driver->target() which is
called from __cpufreq_driver_target(). __cpufreq_driver_target()
is called directly by governors and cpufreq_driver_target() otherwise.

cpufreq_driver_target() implements proper locking and so it is fine.
__cpufreq_driver_target() is called from governors. From governors
it is is serialized in the sense two threads wouldn't call it at the same
time.

And so I thought this will work. But I just found a mistake in my code.
For multi-socket platforms with clock domains for sockets/clusters,
a single instance of transition_ongoing isn't enough and so this must
be embedded in struct cpufreq_policy.

Below patch must get this fixed (Attached).

-------------x---------------------x-----------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Wed, 19 Jun 2013 10:16:55 +0530
Subject: [PATCH] cpufreq: make sure frequency transitions are serialized

Whenever we are changing frequency of a cpu, we are calling PRECHANGE and
POSTCHANGE notifiers. They must be serialized. i.e. PRECHANGE or POSTCHANGE
shouldn't be called twice contiguously.

This can happen due to bugs in users of __cpufreq_driver_target() or actual
cpufreq drivers who are sending these notifiers.

This patch adds some protection against this. Now, we keep track of the last
transaction and see if something went wrong.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 14 ++++++++++++++
 include/linux/cpufreq.h   |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2d53f47..75715f1 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -264,6 +264,12 @@ void __cpufreq_notify_transition(struct
cpufreq_policy *policy,
 	switch (state) {

 	case CPUFREQ_PRECHANGE:
+		if (WARN(policy->transition_ongoing,
+				"In middle of another frequency transition\n"))
+			return;
+
+		policy->transition_ongoing = true;
+
 		/* detect if the driver reported a value as "old frequency"
 		 * which is not equal to what the cpufreq core thinks is
 		 * "old frequency".
@@ -283,6 +289,12 @@ void __cpufreq_notify_transition(struct
cpufreq_policy *policy,
 		break;

 	case CPUFREQ_POSTCHANGE:
+		if (WARN(!policy->transition_ongoing,
+				"No frequency transition in progress\n"))
+			return;
+
+		policy->transition_ongoing = false;
+
 		adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
 		pr_debug("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
 			(unsigned long)freqs->cpu);
@@ -1458,6 +1470,8 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,

 	if (cpufreq_disabled())
 		return -ENODEV;
+	if (policy->transition_ongoing)
+		return -EBUSY;

 	/* Make sure that target_freq is within supported range */
 	if (target_freq > policy->max)
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 037d36a..8c13a45 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -115,6 +115,7 @@ struct cpufreq_policy {

 	struct kobject		kobj;
 	struct completion	kobj_unregister;
+	bool			transition_ongoing; /* Tracks transition status */
 };

 #define CPUFREQ_ADJUST			(0)

--047d7b4728b4b9478104e01b957c
Content-Type: application/octet-stream; 
	name="0001-cpufreq-make-sure-frequency-transitions-are-serializ.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-make-sure-frequency-transitions-are-serializ.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hifhb3nx0

RnJvbSBmMDU3MzU3MGM4NWIwZmQxNGRiMTEzMGVlNDg4NWE1MGVkN2JkYjk0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZjA1NzM1NzBjODViMGZkMTRkYjExMzBlZTQ4ODVh
NTBlZDdiZGI5NC4xMzcyMzA4ODkyLmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
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
a3VtYXJAbGluYXJvLm9yZz4KLS0tCiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIHwgMTQgKysr
KysrKysrKysrKysKIGluY2x1ZGUvbGludXgvY3B1ZnJlcS5oICAgfCAgMSArCiAyIGZpbGVzIGNo
YW5nZWQsIDE1IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvY3B1
ZnJlcS5jIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwppbmRleCAyZDUzZjQ3Li43NTcxNWYx
IDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jCisrKyBiL2RyaXZlcnMvY3B1
ZnJlcS9jcHVmcmVxLmMKQEAgLTI2NCw2ICsyNjQsMTIgQEAgdm9pZCBfX2NwdWZyZXFfbm90aWZ5
X3RyYW5zaXRpb24oc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksCiAJc3dpdGNoIChzdGF0
ZSkgewogCiAJY2FzZSBDUFVGUkVRX1BSRUNIQU5HRToKKwkJaWYgKFdBUk4ocG9saWN5LT50cmFu
c2l0aW9uX29uZ29pbmcsCisJCQkJIkluIG1pZGRsZSBvZiBhbm90aGVyIGZyZXF1ZW5jeSB0cmFu
c2l0aW9uXG4iKSkKKwkJCXJldHVybjsKKworCQlwb2xpY3ktPnRyYW5zaXRpb25fb25nb2luZyA9
IHRydWU7CisKIAkJLyogZGV0ZWN0IGlmIHRoZSBkcml2ZXIgcmVwb3J0ZWQgYSB2YWx1ZSBhcyAi
b2xkIGZyZXF1ZW5jeSIKIAkJICogd2hpY2ggaXMgbm90IGVxdWFsIHRvIHdoYXQgdGhlIGNwdWZy
ZXEgY29yZSB0aGlua3MgaXMKIAkJICogIm9sZCBmcmVxdWVuY3kiLgpAQCAtMjgzLDYgKzI4OSwx
MiBAQCB2b2lkIF9fY3B1ZnJlcV9ub3RpZnlfdHJhbnNpdGlvbihzdHJ1Y3QgY3B1ZnJlcV9wb2xp
Y3kgKnBvbGljeSwKIAkJYnJlYWs7CiAKIAljYXNlIENQVUZSRVFfUE9TVENIQU5HRToKKwkJaWYg
KFdBUk4oIXBvbGljeS0+dHJhbnNpdGlvbl9vbmdvaW5nLAorCQkJCSJObyBmcmVxdWVuY3kgdHJh
bnNpdGlvbiBpbiBwcm9ncmVzc1xuIikpCisJCQlyZXR1cm47CisKKwkJcG9saWN5LT50cmFuc2l0
aW9uX29uZ29pbmcgPSBmYWxzZTsKKwogCQlhZGp1c3RfamlmZmllcyhDUFVGUkVRX1BPU1RDSEFO
R0UsIGZyZXFzKTsKIAkJcHJfZGVidWcoIkZSRVE6ICVsdSAtIENQVTogJWx1IiwgKHVuc2lnbmVk
IGxvbmcpZnJlcXMtPm5ldywKIAkJCSh1bnNpZ25lZCBsb25nKWZyZXFzLT5jcHUpOwpAQCAtMTQ1
OCw2ICsxNDcwLDggQEAgaW50IF9fY3B1ZnJlcV9kcml2ZXJfdGFyZ2V0KHN0cnVjdCBjcHVmcmVx
X3BvbGljeSAqcG9saWN5LAogCiAJaWYgKGNwdWZyZXFfZGlzYWJsZWQoKSkKIAkJcmV0dXJuIC1F
Tk9ERVY7CisJaWYgKHBvbGljeS0+dHJhbnNpdGlvbl9vbmdvaW5nKQorCQlyZXR1cm4gLUVCVVNZ
OwogCiAJLyogTWFrZSBzdXJlIHRoYXQgdGFyZ2V0X2ZyZXEgaXMgd2l0aGluIHN1cHBvcnRlZCBy
YW5nZSAqLwogCWlmICh0YXJnZXRfZnJlcSA+IHBvbGljeS0+bWF4KQpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9saW51eC9jcHVmcmVxLmggYi9pbmNsdWRlL2xpbnV4L2NwdWZyZXEuaAppbmRleCAwMzdk
MzZhLi44YzEzYTQ1IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2NwdWZyZXEuaAorKysgYi9p
bmNsdWRlL2xpbnV4L2NwdWZyZXEuaApAQCAtMTE1LDYgKzExNSw3IEBAIHN0cnVjdCBjcHVmcmVx
X3BvbGljeSB7CiAKIAlzdHJ1Y3Qga29iamVjdAkJa29iajsKIAlzdHJ1Y3QgY29tcGxldGlvbglr
b2JqX3VucmVnaXN0ZXI7CisJYm9vbAkJCXRyYW5zaXRpb25fb25nb2luZzsgLyogVHJhY2tzIHRy
YW5zaXRpb24gc3RhdHVzICovCiB9OwogCiAjZGVmaW5lIENQVUZSRVFfQURKVVNUCQkJKDApCi0t
IAoxLjcuMTIucmMyLjE4Lmc2MWI0NzJlCgo=
--047d7b4728b4b9478104e01b957c--
