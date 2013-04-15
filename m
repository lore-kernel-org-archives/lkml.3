Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab3DORWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:22:33 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:50650 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab3DORWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:22:30 -0400
MIME-Version: 1.0
In-Reply-To: <516C25AE.4050503@intel.com>
References: <CA+icZUU_K9PiFMqMsOEk1+c2DX8LrUojZptPiRVarv4dcB2qFA@mail.gmail.com>
	<CA+icZUUsAqJ3kyCZivYeTpY7n=EDMv1UcC2VNwQro4h7NHDWag@mail.gmail.com>
	<CA+icZUW+TB3q58bL+d=A355S4vtRhwMq8AV+tqjv6MgDtHRCaA@mail.gmail.com>
	<1923819.6Nb81T2TR8@vostro.rjw.lan>
	<CA+icZUXUGOjGUAFxgQk0780pcBB-YjiujDLXF+gJFegi+pd+dA@mail.gmail.com>
	<516C25AE.4050503@intel.com>
Date: Mon, 15 Apr 2013 22:52:28 +0530
Message-ID: <CAKohpo=OOPBYCD_K6RLw2YrJxhMokwrOww4QM2t2T4SnGObyQQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 9 [cpufreq: NULL pointer deref]
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: sedat.dilek@gmail.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Nathan Zimmer <nzimmer@sgi.com>
Content-Type: multipart/mixed; boundary=f46d04479f774bc27d04da697fc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d04479f774bc27d04da697fc2
Content-Type: text/plain; charset=ISO-8859-1

On 15 April 2013 21:37, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> If the intel_pstate driver is being used __cpufreq_governor() should NOT be
> called intel_pstate does not implement the target() callback.
>
> Nathan's commit 5800043b2 changed the fence around the call to
> __cpufreq_governor() in __cpufreq_remove_dev() here is the relevant hunk.

No it isn't.

> +       if (has_target)
>                 __cpufreq_governor(data, CPUFREQ_GOV_STOP);

As it has taken care of this limitation.

BUT some of my earlier patches haven't. :(
Here is the fix (Sedat please try this and give your tested-by, use the attached
patch as gmail might break what i am copying in mail)..

Sorry for being late in fixing this issue, i am still down with Tonsil infection
and fever.. Today only i got some power to fix it after seeing Dirk's mail.

Your tested-by may help me to recover quickly :)

@Rafael: I will probably be down for one more week and so not doing any
reviews for now... I do check important mails sent directly to me though.

------------x----------------------x------------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Mon, 15 Apr 2013 22:43:57 +0530
Subject: [PATCH] cpufreq: Don't call __cpufreq_governor() for drivers without
 target()

Some cpufreq drivers implement their own governor and so don't need us to call
generic governors interface via __cpufreq_governor(). Few recent commits haven't
obeyed this law well and we saw some regressions.

This patch tries to fix this issue.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 3564947..a6f6595 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -858,13 +858,18 @@ static int cpufreq_add_policy_cpu(unsigned int
cpu, unsigned int sibling,
 				  struct device *dev)
 {
 	struct cpufreq_policy *policy;
-	int ret = 0;
+	int ret = 0, has_target = 0;
 	unsigned long flags;

 	policy = cpufreq_cpu_get(sibling);
 	WARN_ON(!policy);

-	__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
+	rcu_read_lock();
+	has_target = !!rcu_dereference(cpufreq_driver)->target;
+	rcu_read_unlock();
+
+	if (has_target)
+		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);

 	lock_policy_rwsem_write(sibling);

@@ -877,8 +882,10 @@ static int cpufreq_add_policy_cpu(unsigned int
cpu, unsigned int sibling,

 	unlock_policy_rwsem_write(sibling);

-	__cpufreq_governor(policy, CPUFREQ_GOV_START);
-	__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
+	if (has_target) {
+		__cpufreq_governor(policy, CPUFREQ_GOV_START);
+		__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
+	}

 	ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
 	if (ret) {
@@ -1146,7 +1153,8 @@ static int __cpufreq_remove_dev(struct device
*dev, struct subsys_interface *sif

 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
-		__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
+		if (has_target)
+			__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);

 		lock_policy_rwsem_read(cpu);
 		kobj = &data->kobj;

--f46d04479f774bc27d04da697fc2
Content-Type: application/octet-stream; 
	name="0001-cpufreq-Don-t-call-__cpufreq_governor-for-drivers-wi.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-Don-t-call-__cpufreq_governor-for-drivers-wi.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfjwtdd80

RnJvbSA3MzUyYTNkZDYwYWNkMzg5Y2VmYzQwZmFjMTI4MzdkMzJjOGE2ZjI2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8NzM1MmEzZGQ2MGFjZDM4OWNlZmM0MGZhYzEyODM3
ZDMyYzhhNmYyNi4xMzY2MDQ2MjAyLmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogTW9uLCAxNSBBcHIg
MjAxMyAyMjo0Mzo1NyArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IERvbid0IGNhbGwg
X19jcHVmcmVxX2dvdmVybm9yKCkgZm9yIGRyaXZlcnMgd2l0aG91dAogdGFyZ2V0KCkKClNvbWUg
Y3B1ZnJlcSBkcml2ZXJzIGltcGxlbWVudCB0aGVpciBvd24gZ292ZXJub3IgYW5kIHNvIGRvbid0
IG5lZWQgdXMgdG8gY2FsbApnZW5lcmljIGdvdmVybm9ycyBpbnRlcmZhY2UgdmlhIF9fY3B1ZnJl
cV9nb3Zlcm5vcigpLiBGZXcgcmVjZW50IGNvbW1pdHMgaGF2ZW4ndApvYmV5ZWQgdGhpcyBsYXcg
d2VsbCBhbmQgd2Ugc2F3IHNvbWUgcmVncmVzc2lvbnMuCgpUaGlzIHBhdGNoIHRyaWVzIHRvIGZp
eCB0aGlzIGlzc3VlLgoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJA
bGluYXJvLm9yZz4KLS0tCiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIHwgMTggKysrKysrKysr
KysrKy0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIGIvZHJpdmVycy9jcHVm
cmVxL2NwdWZyZXEuYwppbmRleCAzNTY0OTQ3Li5hNmY2NTk1IDEwMDY0NAotLS0gYS9kcml2ZXJz
L2NwdWZyZXEvY3B1ZnJlcS5jCisrKyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMKQEAgLTg1
OCwxMyArODU4LDE4IEBAIHN0YXRpYyBpbnQgY3B1ZnJlcV9hZGRfcG9saWN5X2NwdSh1bnNpZ25l
ZCBpbnQgY3B1LCB1bnNpZ25lZCBpbnQgc2libGluZywKIAkJCQkgIHN0cnVjdCBkZXZpY2UgKmRl
dikKIHsKIAlzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeTsKLQlpbnQgcmV0ID0gMDsKKwlp
bnQgcmV0ID0gMCwgaGFzX3RhcmdldCA9IDA7CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKIAogCXBv
bGljeSA9IGNwdWZyZXFfY3B1X2dldChzaWJsaW5nKTsKIAlXQVJOX09OKCFwb2xpY3kpOwogCi0J
X19jcHVmcmVxX2dvdmVybm9yKHBvbGljeSwgQ1BVRlJFUV9HT1ZfU1RPUCk7CisJcmN1X3JlYWRf
bG9jaygpOworCWhhc190YXJnZXQgPSAhIXJjdV9kZXJlZmVyZW5jZShjcHVmcmVxX2RyaXZlcikt
PnRhcmdldDsKKwlyY3VfcmVhZF91bmxvY2soKTsKKworCWlmIChoYXNfdGFyZ2V0KQorCQlfX2Nw
dWZyZXFfZ292ZXJub3IocG9saWN5LCBDUFVGUkVRX0dPVl9TVE9QKTsKIAogCWxvY2tfcG9saWN5
X3J3c2VtX3dyaXRlKHNpYmxpbmcpOwogCkBAIC04NzcsOCArODgyLDEwIEBAIHN0YXRpYyBpbnQg
Y3B1ZnJlcV9hZGRfcG9saWN5X2NwdSh1bnNpZ25lZCBpbnQgY3B1LCB1bnNpZ25lZCBpbnQgc2li
bGluZywKIAogCXVubG9ja19wb2xpY3lfcndzZW1fd3JpdGUoc2libGluZyk7CiAKLQlfX2NwdWZy
ZXFfZ292ZXJub3IocG9saWN5LCBDUFVGUkVRX0dPVl9TVEFSVCk7Ci0JX19jcHVmcmVxX2dvdmVy
bm9yKHBvbGljeSwgQ1BVRlJFUV9HT1ZfTElNSVRTKTsKKwlpZiAoaGFzX3RhcmdldCkgeworCQlf
X2NwdWZyZXFfZ292ZXJub3IocG9saWN5LCBDUFVGUkVRX0dPVl9TVEFSVCk7CisJCV9fY3B1ZnJl
cV9nb3Zlcm5vcihwb2xpY3ksIENQVUZSRVFfR09WX0xJTUlUUyk7CisJfQogCiAJcmV0ID0gc3lz
ZnNfY3JlYXRlX2xpbmsoJmRldi0+a29iaiwgJnBvbGljeS0+a29iaiwgImNwdWZyZXEiKTsKIAlp
ZiAocmV0KSB7CkBAIC0xMTQ2LDcgKzExNTMsOCBAQCBzdGF0aWMgaW50IF9fY3B1ZnJlcV9yZW1v
dmVfZGV2KHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IHN1YnN5c19pbnRlcmZhY2UgKnNpZgog
CiAJLyogSWYgY3B1IGlzIGxhc3QgdXNlciBvZiBwb2xpY3ksIGZyZWUgcG9saWN5ICovCiAJaWYg
KGNwdXMgPT0gMSkgewotCQlfX2NwdWZyZXFfZ292ZXJub3IoZGF0YSwgQ1BVRlJFUV9HT1ZfUE9M
SUNZX0VYSVQpOworCQlpZiAoaGFzX3RhcmdldCkKKwkJCV9fY3B1ZnJlcV9nb3Zlcm5vcihkYXRh
LCBDUFVGUkVRX0dPVl9QT0xJQ1lfRVhJVCk7CiAKIAkJbG9ja19wb2xpY3lfcndzZW1fcmVhZChj
cHUpOwogCQlrb2JqID0gJmRhdGEtPmtvYmo7Ci0tIAoxLjcuMTIucmMyLjE4Lmc2MWI0NzJlCgo=
--f46d04479f774bc27d04da697fc2--
