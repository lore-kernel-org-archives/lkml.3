Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3BHFJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 00:09:16 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:65170 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3BHFJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 00:09:14 -0500
MIME-Version: 1.0
In-Reply-To: <1947746.IyFppZQEx8@vostro.rjw.lan>
References: <cover.1360232293.git.viresh.kumar@linaro.org>
	<2158181.aoVXdpLJe2@vostro.rjw.lan>
	<CAKohponLrVG+ubf5Ok+7AvoWKRF16YLqUEWAU6hH7-H_R=r0Ow@mail.gmail.com>
	<1947746.IyFppZQEx8@vostro.rjw.lan>
Date: Fri, 8 Feb 2013 10:39:13 +0530
Message-ID: <CAKohpony25Ct94QyCOEmoNVS6Xc5O8=0Cnc6NxLxTP5Y-E1XJg@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq Fixes for 3.9
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: valdis.kletnieks@vt.edu, artem.savkov@gmail.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com, dirk.brandewie@gmail.com
Content-Type: multipart/mixed; boundary=e89a8f923d0a70b79c04d52f8f0b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f923d0a70b79c04d52f8f0b
Content-Type: text/plain; charset=ISO-8859-1

On 8 February 2013 04:37, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> BTW, there still are locking problems in linux-next.  Why do we need
> to take cpufreq_driver_lock() around driver->init() in cpufreq_add_dev(),
> in particular?

I thought a bit more and realized there is no such limitation on
cpufreq_driver->ops about calling routines which can sleep. And thus
we shoudln't
have locks around any of these. I have got a patch for it, that i
would fold-back into
the original patch that introduced locking fixes (attached too for testing):

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Fri, 8 Feb 2013 10:35:31 +0530
Subject: [PATCH] cpufreq: Remove unnecessary locking

I have placed some locks intentionally around calls to driver->ops (init/exit),
which look to be wrong as these calls can call routines that potentially sleep.

Lets remove these locks.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5d8a422..04aab05 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -795,10 +795,8 @@ static int cpufreq_add_dev_interface(unsigned int cpu,

 	if (ret) {
 		pr_debug("setting policy failed\n");
-		spin_lock_irqsave(&cpufreq_driver_lock, flags);
 		if (driver->exit)
 			driver->exit(policy);
-		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 	}
 	return ret;

@@ -920,17 +918,14 @@ static int cpufreq_add_dev(struct device *dev,
struct subsys_interface *sif)
 	init_completion(&policy->kobj_unregister);
 	INIT_WORK(&policy->update, handle_update);

-	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	/* call driver. From then on the cpufreq must be able
 	 * to accept all calls to ->verify and ->setpolicy for this CPU
 	 */
 	ret = driver->init(policy);
 	if (ret) {
 		pr_debug("initialization failed\n");
-		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		goto err_set_policy_cpu;
 	}
-	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);

 	/* related cpus should atleast have policy->cpus */
 	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
@@ -1100,10 +1095,8 @@ static int __cpufreq_remove_dev(struct device
*dev, struct subsys_interface *sif
 		wait_for_completion(cmp);
 		pr_debug("wait complete\n");

-		spin_lock_irqsave(&cpufreq_driver_lock, flags);
 		if (driver->exit)
 			driver->exit(data);
-		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);

 		free_cpumask_var(data->related_cpus);
 		free_cpumask_var(data->cpus);

--e89a8f923d0a70b79c04d52f8f0b
Content-Type: application/octet-stream; 
	name="0001-cpufreq-Remove-unnecessary-locking.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-Remove-unnecessary-locking.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcwvl4im0

RnJvbSA1NjRkZjM3YjVkYjUxMTgyZTVlNmU3ODk2OWY0MGEyYTcxMTU5YjljIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8NTY0ZGYzN2I1ZGI1MTE4MmU1ZTZlNzg5NjlmNDBh
MmE3MTE1OWI5Yy4xMzYwMzAwMTI2LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogRnJpLCA4IEZlYiAy
MDEzIDEwOjM1OjMxICswNTMwClN1YmplY3Q6IFtQQVRDSF0gY3B1ZnJlcTogUmVtb3ZlIHVubmVj
ZXNzYXJ5IGxvY2tpbmcKCkkgaGF2ZSBwbGFjZWQgc29tZSBsb2NrcyBpbnRlbnRpb25hbGx5IGFy
b3VuZCBjYWxscyB0byBkcml2ZXItPm9wcyAoaW5pdC9leGl0KSwKd2hpY2ggbG9vayB0byBiZSB3
cm9uZyBhcyB0aGVzZSBjYWxscyBjYW4gY2FsbCByb3V0aW5lcyB0aGF0IHBvdGVudGlhbGx5IHNs
ZWVwLgoKTGV0cyByZW1vdmUgdGhlc2UgbG9ja3MuCgpTaWduZWQtb2ZmLWJ5OiBWaXJlc2ggS3Vt
YXIgPHZpcmVzaC5rdW1hckBsaW5hcm8ub3JnPgotLS0KIGRyaXZlcnMvY3B1ZnJlcS9jcHVmcmVx
LmMgfCA3IC0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5j
CmluZGV4IDVkOGE0MjIuLjA0YWFiMDUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVm
cmVxLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwpAQCAtNzk1LDEwICs3OTUsOCBA
QCBzdGF0aWMgaW50IGNwdWZyZXFfYWRkX2Rldl9pbnRlcmZhY2UodW5zaWduZWQgaW50IGNwdSwK
IAogCWlmIChyZXQpIHsKIAkJcHJfZGVidWcoInNldHRpbmcgcG9saWN5IGZhaWxlZFxuIik7Ci0J
CXNwaW5fbG9ja19pcnFzYXZlKCZjcHVmcmVxX2RyaXZlcl9sb2NrLCBmbGFncyk7CiAJCWlmIChk
cml2ZXItPmV4aXQpCiAJCQlkcml2ZXItPmV4aXQocG9saWN5KTsKLQkJc3Bpbl91bmxvY2tfaXJx
cmVzdG9yZSgmY3B1ZnJlcV9kcml2ZXJfbG9jaywgZmxhZ3MpOwogCX0KIAlyZXR1cm4gcmV0Owog
CkBAIC05MjAsMTcgKzkxOCwxNCBAQCBzdGF0aWMgaW50IGNwdWZyZXFfYWRkX2RldihzdHJ1Y3Qg
ZGV2aWNlICpkZXYsIHN0cnVjdCBzdWJzeXNfaW50ZXJmYWNlICpzaWYpCiAJaW5pdF9jb21wbGV0
aW9uKCZwb2xpY3ktPmtvYmpfdW5yZWdpc3Rlcik7CiAJSU5JVF9XT1JLKCZwb2xpY3ktPnVwZGF0
ZSwgaGFuZGxlX3VwZGF0ZSk7CiAKLQlzcGluX2xvY2tfaXJxc2F2ZSgmY3B1ZnJlcV9kcml2ZXJf
bG9jaywgZmxhZ3MpOwogCS8qIGNhbGwgZHJpdmVyLiBGcm9tIHRoZW4gb24gdGhlIGNwdWZyZXEg
bXVzdCBiZSBhYmxlCiAJICogdG8gYWNjZXB0IGFsbCBjYWxscyB0byAtPnZlcmlmeSBhbmQgLT5z
ZXRwb2xpY3kgZm9yIHRoaXMgQ1BVCiAJICovCiAJcmV0ID0gZHJpdmVyLT5pbml0KHBvbGljeSk7
CiAJaWYgKHJldCkgewogCQlwcl9kZWJ1ZygiaW5pdGlhbGl6YXRpb24gZmFpbGVkXG4iKTsKLQkJ
c3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY3B1ZnJlcV9kcml2ZXJfbG9jaywgZmxhZ3MpOwogCQln
b3RvIGVycl9zZXRfcG9saWN5X2NwdTsKIAl9Ci0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY3B1
ZnJlcV9kcml2ZXJfbG9jaywgZmxhZ3MpOwogCiAJLyogcmVsYXRlZCBjcHVzIHNob3VsZCBhdGxl
YXN0IGhhdmUgcG9saWN5LT5jcHVzICovCiAJY3B1bWFza19vcihwb2xpY3ktPnJlbGF0ZWRfY3B1
cywgcG9saWN5LT5yZWxhdGVkX2NwdXMsIHBvbGljeS0+Y3B1cyk7CkBAIC0xMTAwLDEwICsxMDk1
LDggQEAgc3RhdGljIGludCBfX2NwdWZyZXFfcmVtb3ZlX2RldihzdHJ1Y3QgZGV2aWNlICpkZXYs
IHN0cnVjdCBzdWJzeXNfaW50ZXJmYWNlICpzaWYKIAkJd2FpdF9mb3JfY29tcGxldGlvbihjbXAp
OwogCQlwcl9kZWJ1Zygid2FpdCBjb21wbGV0ZVxuIik7CiAKLQkJc3Bpbl9sb2NrX2lycXNhdmUo
JmNwdWZyZXFfZHJpdmVyX2xvY2ssIGZsYWdzKTsKIAkJaWYgKGRyaXZlci0+ZXhpdCkKIAkJCWRy
aXZlci0+ZXhpdChkYXRhKTsKLQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY3B1ZnJlcV9kcml2
ZXJfbG9jaywgZmxhZ3MpOwogCiAJCWZyZWVfY3B1bWFza192YXIoZGF0YS0+cmVsYXRlZF9jcHVz
KTsKIAkJZnJlZV9jcHVtYXNrX3ZhcihkYXRhLT5jcHVzKTsKLS0gCjEuNy4xMi5yYzIuMTguZzYx
YjQ3MmUKCg==
--e89a8f923d0a70b79c04d52f8f0b--
