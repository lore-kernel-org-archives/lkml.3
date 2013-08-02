Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3HBK4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:56:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36092 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab3HBKz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:55:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponru8Z1fod43dVtAODmYuMTGX70+73b8wk4wuGN=Vuh-w@mail.gmail.com>
References: <2362640.pUofnXyzOi@vostro.rjw.lan>
	<51FAC46D.1000703@linux.vnet.ibm.com>
	<1757496.qSuJuAun9Z@vostro.rjw.lan>
	<2298639.F0Qv2QqRnZ@vostro.rjw.lan>
	<CAKohponru8Z1fod43dVtAODmYuMTGX70+73b8wk4wuGN=Vuh-w@mail.gmail.com>
Date: Fri, 2 Aug 2013 16:25:58 +0530
Message-ID: <CAKohpon7jyJWhf+j-M6Nuqy-AaY73YUpBpt-1uh12e_SYRv2bQ@mail.gmail.com>
Subject: Re: [Update][PATCH] cpufreq: Do not hold driver module references for
 additional policy CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: multipart/mixed; boundary=089e0153688ec3226504e2f4cd37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0153688ec3226504e2f4cd37
Content-Type: text/plain; charset=ISO-8859-1

On 2 August 2013 10:07, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> @@ -908,7 +905,8 @@ static int cpufreq_add_policy_cpu(unsign
>>         unsigned long flags;
>>
>>         policy = cpufreq_cpu_get(sibling);
>
> This can be skipped completely at this place. Caller of
> cpufreq_add_policy_cpu() has got the policy pointer with it and so
> can be passed. I haven't done it earlier as the impression was we need
> to call cpufreq_cpu_get()..

And here is the fixup to do this (attached too):

---
 drivers/cpufreq/cpufreq.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 46e70ae..47f2a6e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -889,21 +889,17 @@ static void cpufreq_init_policy(struct
cpufreq_policy *policy)
 }

 #ifdef CONFIG_HOTPLUG_CPU
-static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
-				  struct device *dev, bool frozen)
+static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
+				  unsigned int cpu, struct device *dev,
+				  bool frozen)
 {
-	struct cpufreq_policy *policy;
 	int ret = 0, has_target = !!cpufreq_driver->target;
 	unsigned long flags;

-	policy = cpufreq_cpu_get(sibling);
-	if (WARN_ON_ONCE(!policy))
-		return -ENODATA;
-
 	if (has_target)
 		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);

-	lock_policy_rwsem_write(sibling);
+	lock_policy_rwsem_write(policy->cpu);

 	write_lock_irqsave(&cpufreq_driver_lock, flags);

@@ -912,7 +908,7 @@ static int cpufreq_add_policy_cpu(unsigned int
cpu, unsigned int sibling,
 	per_cpu(cpufreq_cpu_data, cpu) = policy;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);

-	unlock_policy_rwsem_write(sibling);
+	unlock_policy_rwsem_write(policy->cpu);

 	if (has_target) {
 		__cpufreq_governor(policy, CPUFREQ_GOV_START);
@@ -923,7 +919,6 @@ static int cpufreq_add_policy_cpu(unsigned int
cpu, unsigned int sibling,
 	if (!frozen)
 		ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");

-	cpufreq_cpu_put(policy);
 	return ret;
 }
 #endif
@@ -1006,8 +1001,7 @@ static int __cpufreq_add_dev(struct device *dev,
struct subsys_interface *sif,
 		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
 		if (cp && cpumask_test_cpu(cpu, cp->related_cpus)) {
 			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-			return cpufreq_add_policy_cpu(cpu, sibling, dev,
-						      frozen);
+			return cpufreq_add_policy_cpu(cp, cpu, dev, frozen);
 		}
 	}
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);

--089e0153688ec3226504e2f4cd37
Content-Type: application/octet-stream; name="0001-Fix.patch"
Content-Disposition: attachment; filename="0001-Fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjva0xya1

RnJvbSA3Nzk2M2NiY2VhMmUxNDhhMmZlMWI4ODY1MjY2Y2M0ZTJmMTg3MjYyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8Nzc5NjNjYmNlYTJlMTQ4YTJmZTFiODg2NTI2NmNj
NGUyZjE4NzI2Mi4xMzc1NDQwOTA4LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogRnJpLCAyIEF1ZyAy
MDEzIDE2OjE3OjMzICswNTMwClN1YmplY3Q6IFtQQVRDSF0gRml4CgpTaWduZWQtb2ZmLWJ5OiBW
aXJlc2ggS3VtYXIgPHZpcmVzaC5rdW1hckBsaW5hcm8ub3JnPgotLS0KIGRyaXZlcnMvY3B1ZnJl
cS9jcHVmcmVxLmMgfCAxOCArKysrKystLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA2IGlu
c2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1ZnJl
cS9jcHVmcmVxLmMgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jCmluZGV4IDQ2ZTcwYWUuLjQ3
ZjJhNmUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMKKysrIGIvZHJpdmVy
cy9jcHVmcmVxL2NwdWZyZXEuYwpAQCAtODg5LDIxICs4ODksMTcgQEAgc3RhdGljIHZvaWQgY3B1
ZnJlcV9pbml0X3BvbGljeShzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSkKIH0KIAogI2lm
ZGVmIENPTkZJR19IT1RQTFVHX0NQVQotc3RhdGljIGludCBjcHVmcmVxX2FkZF9wb2xpY3lfY3B1
KHVuc2lnbmVkIGludCBjcHUsIHVuc2lnbmVkIGludCBzaWJsaW5nLAotCQkJCSAgc3RydWN0IGRl
dmljZSAqZGV2LCBib29sIGZyb3plbikKK3N0YXRpYyBpbnQgY3B1ZnJlcV9hZGRfcG9saWN5X2Nw
dShzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKKwkJCQkgIHVuc2lnbmVkIGludCBjcHUs
IHN0cnVjdCBkZXZpY2UgKmRldiwKKwkJCQkgIGJvb2wgZnJvemVuKQogewotCXN0cnVjdCBjcHVm
cmVxX3BvbGljeSAqcG9saWN5OwogCWludCByZXQgPSAwLCBoYXNfdGFyZ2V0ID0gISFjcHVmcmVx
X2RyaXZlci0+dGFyZ2V0OwogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAKLQlwb2xpY3kgPSBjcHVm
cmVxX2NwdV9nZXQoc2libGluZyk7Ci0JaWYgKFdBUk5fT05fT05DRSghcG9saWN5KSkKLQkJcmV0
dXJuIC1FTk9EQVRBOwotCiAJaWYgKGhhc190YXJnZXQpCiAJCV9fY3B1ZnJlcV9nb3Zlcm5vcihw
b2xpY3ksIENQVUZSRVFfR09WX1NUT1ApOwogCi0JbG9ja19wb2xpY3lfcndzZW1fd3JpdGUoc2li
bGluZyk7CisJbG9ja19wb2xpY3lfcndzZW1fd3JpdGUocG9saWN5LT5jcHUpOwogCiAJd3JpdGVf
bG9ja19pcnFzYXZlKCZjcHVmcmVxX2RyaXZlcl9sb2NrLCBmbGFncyk7CiAKQEAgLTkxMiw3ICs5
MDgsNyBAQCBzdGF0aWMgaW50IGNwdWZyZXFfYWRkX3BvbGljeV9jcHUodW5zaWduZWQgaW50IGNw
dSwgdW5zaWduZWQgaW50IHNpYmxpbmcsCiAJcGVyX2NwdShjcHVmcmVxX2NwdV9kYXRhLCBjcHUp
ID0gcG9saWN5OwogCXdyaXRlX3VubG9ja19pcnFyZXN0b3JlKCZjcHVmcmVxX2RyaXZlcl9sb2Nr
LCBmbGFncyk7CiAKLQl1bmxvY2tfcG9saWN5X3J3c2VtX3dyaXRlKHNpYmxpbmcpOworCXVubG9j
a19wb2xpY3lfcndzZW1fd3JpdGUocG9saWN5LT5jcHUpOwogCiAJaWYgKGhhc190YXJnZXQpIHsK
IAkJX19jcHVmcmVxX2dvdmVybm9yKHBvbGljeSwgQ1BVRlJFUV9HT1ZfU1RBUlQpOwpAQCAtOTIz
LDcgKzkxOSw2IEBAIHN0YXRpYyBpbnQgY3B1ZnJlcV9hZGRfcG9saWN5X2NwdSh1bnNpZ25lZCBp
bnQgY3B1LCB1bnNpZ25lZCBpbnQgc2libGluZywKIAlpZiAoIWZyb3plbikKIAkJcmV0ID0gc3lz
ZnNfY3JlYXRlX2xpbmsoJmRldi0+a29iaiwgJnBvbGljeS0+a29iaiwgImNwdWZyZXEiKTsKIAot
CWNwdWZyZXFfY3B1X3B1dChwb2xpY3kpOwogCXJldHVybiByZXQ7CiB9CiAjZW5kaWYKQEAgLTEw
MDYsOCArMTAwMSw3IEBAIHN0YXRpYyBpbnQgX19jcHVmcmVxX2FkZF9kZXYoc3RydWN0IGRldmlj
ZSAqZGV2LCBzdHJ1Y3Qgc3Vic3lzX2ludGVyZmFjZSAqc2lmLAogCQlzdHJ1Y3QgY3B1ZnJlcV9w
b2xpY3kgKmNwID0gcGVyX2NwdShjcHVmcmVxX2NwdV9kYXRhLCBzaWJsaW5nKTsKIAkJaWYgKGNw
ICYmIGNwdW1hc2tfdGVzdF9jcHUoY3B1LCBjcC0+cmVsYXRlZF9jcHVzKSkgewogCQkJcmVhZF91
bmxvY2tfaXJxcmVzdG9yZSgmY3B1ZnJlcV9kcml2ZXJfbG9jaywgZmxhZ3MpOwotCQkJcmV0dXJu
IGNwdWZyZXFfYWRkX3BvbGljeV9jcHUoY3B1LCBzaWJsaW5nLCBkZXYsCi0JCQkJCQkgICAgICBm
cm96ZW4pOworCQkJcmV0dXJuIGNwdWZyZXFfYWRkX3BvbGljeV9jcHUoY3AsIGNwdSwgZGV2LCBm
cm96ZW4pOwogCQl9CiAJfQogCXJlYWRfdW5sb2NrX2lycXJlc3RvcmUoJmNwdWZyZXFfZHJpdmVy
X2xvY2ssIGZsYWdzKTsKLS0gCjEuNy4xMi5yYzIuMTguZzYxYjQ3MmUKCg==
--089e0153688ec3226504e2f4cd37--
