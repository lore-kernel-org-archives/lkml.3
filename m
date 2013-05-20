Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3ETEjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 00:39:33 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:42121 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3ETEja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 00:39:30 -0400
MIME-Version: 1.0
In-Reply-To: <51991D53.7020806@gmail.com>
References: <8bf03cb4a42864802800188fde78adf9b498455f.1368789952.git.viresh.kumar@linaro.org>
	<1b08f7e4657818e4a00ea7ebb137998223834dd5.1368789952.git.viresh.kumar@linaro.org>
	<51991D53.7020806@gmail.com>
Date: Mon, 20 May 2013 10:09:29 +0530
Message-ID: <CAKohpokDV_7RGxxbry9eTT92ehOjuc34O11VZFjKW=5CMS1dcg@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: Don't create empty /sys/devices/system/cpu/cpufreq
 directory
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: rjw@sisk.pl, robin.randhawa@arm.com, linux-pm@vger.kernel.org,
        patches@linaro.org, Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Steve.Bannister@arm.com, arvind.chauhan@arm.com,
        charles.garcia-tobin@arm.com
Content-Type: multipart/mixed; boundary=f46d0447878d1b53fe04dd1eeb58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0447878d1b53fe04dd1eeb58
Content-Type: text/plain; charset=ISO-8859-1

On 20 May 2013 00:13, Francesco Lavra <francescolavra.fl@gmail.com> wrote:
> On 05/17/2013 01:26 PM, Viresh Kumar wrote:
>> +EXPORT_SYMBOL(get_cpufreq_global_kobject);
>> +EXPORT_SYMBOL(put_cpufreq_global_kobject);
>
> Global symbol names should begin with a sensible prefix; in this case,
> it looks like cpufreq_get_global_kobject and cpufreq_put_global_kobject
> would be more appropriate names.

Please see if V2 looks fine. Attached too for applying.

------------x--------------------x------------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Fri, 17 May 2013 16:09:09 +0530
Subject: [PATCH V2] cpufreq: Don't create empty /sys/devices/system/cpu/cpufreq
 directory

When we don't have any file in cpu/cpufreq directory we shouldn't create it.
Specially with the introduction of per-policy governor instance patchset, even
governors are moved to cpu/cpu*/cpufreq/governor-name directory and so this
directory is just not required.

Lets have it only when required.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1->V2: Replace: {get|put}_cpufreq_global_kobject with
cpufreq_{get|put}_global_kobject.

 drivers/cpufreq/acpi-cpufreq.c     |  4 ++--
 drivers/cpufreq/cpufreq.c          | 48 ++++++++++++++++++++++++++++++++++----
 drivers/cpufreq/cpufreq_governor.c |  6 +++++
 include/linux/cpufreq.h            |  4 ++++
 4 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index ce28c34..ae0918d 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -947,7 +947,7 @@ static void __init acpi_cpufreq_boost_init(void)
 	/* We create the boost file in any case, though for systems without
 	 * hardware support it will be read-only and hardwired to return 0.
 	 */
-	if (sysfs_create_file(cpufreq_global_kobject, &(global_boost.attr)))
+	if (cpufreq_sysfs_create_file(&(global_boost.attr)))
 		pr_warn(PFX "could not register global boost sysfs file\n");
 	else
 		pr_debug("registered global boost sysfs file\n");
@@ -955,7 +955,7 @@ static void __init acpi_cpufreq_boost_init(void)

 static void __exit acpi_cpufreq_boost_exit(void)
 {
-	sysfs_remove_file(cpufreq_global_kobject, &(global_boost.attr));
+	cpufreq_sysfs_remove_file(&(global_boost.attr));

 	if (msrs) {
 		unregister_cpu_notifier(&boost_nb);
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index e3d7112..74a1a60 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -678,9 +678,6 @@ static struct attribute *default_attrs[] = {
 	NULL
 };

-struct kobject *cpufreq_global_kobject;
-EXPORT_SYMBOL(cpufreq_global_kobject);
-
 #define to_policy(k) container_of(k, struct cpufreq_policy, kobj)
 #define to_attr(a) container_of(a, struct freq_attr, attr)

@@ -751,6 +748,49 @@ static struct kobj_type ktype_cpufreq = {
 	.release	= cpufreq_sysfs_release,
 };

+struct kobject *cpufreq_global_kobject;
+EXPORT_SYMBOL(cpufreq_global_kobject);
+
+static int cpufreq_global_kobject_usage;
+
+int cpufreq_get_global_kobject(void)
+{
+	if (!cpufreq_global_kobject_usage++)
+		return kobject_add(cpufreq_global_kobject,
+				&cpu_subsys.dev_root->kobj, "%s", "cpufreq");
+
+	return 0;
+}
+EXPORT_SYMBOL(cpufreq_get_global_kobject);
+
+void cpufreq_put_global_kobject(void)
+{
+	if (!--cpufreq_global_kobject_usage)
+		kobject_del(cpufreq_global_kobject);
+}
+EXPORT_SYMBOL(cpufreq_put_global_kobject);
+
+int cpufreq_sysfs_create_file(const struct attribute *attr)
+{
+	int ret = cpufreq_get_global_kobject();
+
+	if (!ret) {
+		ret = sysfs_create_file(cpufreq_global_kobject, attr);
+		if (ret)
+			cpufreq_put_global_kobject();
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(cpufreq_sysfs_create_file);
+
+void cpufreq_sysfs_remove_file(const struct attribute *attr)
+{
+	sysfs_remove_file(cpufreq_global_kobject, attr);
+	cpufreq_put_global_kobject();
+}
+EXPORT_SYMBOL(cpufreq_sysfs_remove_file);
+
 /* symlink affected CPUs */
 static int cpufreq_add_dev_symlink(unsigned int cpu,
 				   struct cpufreq_policy *policy)
@@ -2022,7 +2062,7 @@ static int __init cpufreq_core_init(void)
 		init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
 	}

-	cpufreq_global_kobject = kobject_create_and_add("cpufreq",
&cpu_subsys.dev_root->kobj);
+	cpufreq_global_kobject = kobject_create();
 	BUG_ON(!cpufreq_global_kobject);
 	register_syscore_ops(&cpufreq_syscore_ops);

diff --git a/drivers/cpufreq/cpufreq_governor.c
b/drivers/cpufreq/cpufreq_governor.c
index b6cfd55..7532570 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -231,6 +231,9 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			return rc;
 		}

+		if (!have_governor_per_policy())
+			WARN_ON(cpufreq_get_global_kobject());
+
 		rc = sysfs_create_group(get_governor_parent_kobj(policy),
 				get_sysfs_attr(dbs_data));
 		if (rc) {
@@ -269,6 +272,9 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			sysfs_remove_group(get_governor_parent_kobj(policy),
 					get_sysfs_attr(dbs_data));

+			if (!have_governor_per_policy())
+				cpufreq_put_global_kobject();
+
 			if ((dbs_data->cdata->governor == GOV_CONSERVATIVE) &&
 				(policy->governor->initialized == 1)) {
 				struct cs_ops *cs_ops = dbs_data->cdata->gov_ops;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index cbdf5a4..b97d99b 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -71,6 +71,10 @@ struct cpufreq_governor;

 /* /sys/devices/system/cpu/cpufreq: entry point for global variables */
 extern struct kobject *cpufreq_global_kobject;
+int cpufreq_get_global_kobject(void);
+void cpufreq_put_global_kobject(void);
+int cpufreq_sysfs_create_file(const struct attribute *attr);
+void cpufreq_sysfs_remove_file(const struct attribute *attr);

 #define CPUFREQ_ETERNAL			(-1)
 struct cpufreq_cpuinfo {

--f46d0447878d1b53fe04dd1eeb58
Content-Type: application/octet-stream; 
	name="0001-cpufreq-Don-t-create-empty-sys-devices-system-cpu-cp.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-Don-t-create-empty-sys-devices-system-cpu-cp.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hgx5za7h0

RnJvbSAzZTRjNzRjYTQ0NDFhYmUyYjkzNzA3OTkxMDcxZTIzOWU0MTNmYTdkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8M2U0Yzc0Y2E0NDQxYWJlMmI5MzcwNzk5MTA3MWUy
MzllNDEzZmE3ZC4xMzY5MDI0NjM3LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogRnJpLCAxNyBNYXkg
MjAxMyAxNjowOTowOSArMDUzMApTdWJqZWN0OiBbUEFUQ0ggVjJdIGNwdWZyZXE6IERvbid0IGNy
ZWF0ZSBlbXB0eSAvc3lzL2RldmljZXMvc3lzdGVtL2NwdS9jcHVmcmVxCiBkaXJlY3RvcnkKCldo
ZW4gd2UgZG9uJ3QgaGF2ZSBhbnkgZmlsZSBpbiBjcHUvY3B1ZnJlcSBkaXJlY3Rvcnkgd2Ugc2hv
dWxkbid0IGNyZWF0ZSBpdC4KU3BlY2lhbGx5IHdpdGggdGhlIGludHJvZHVjdGlvbiBvZiBwZXIt
cG9saWN5IGdvdmVybm9yIGluc3RhbmNlIHBhdGNoc2V0LCBldmVuCmdvdmVybm9ycyBhcmUgbW92
ZWQgdG8gY3B1L2NwdSovY3B1ZnJlcS9nb3Zlcm5vci1uYW1lIGRpcmVjdG9yeSBhbmQgc28gdGhp
cwpkaXJlY3RvcnkgaXMganVzdCBub3QgcmVxdWlyZWQuCgpMZXRzIGhhdmUgaXQgb25seSB3aGVu
IHJlcXVpcmVkLgoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGlu
YXJvLm9yZz4KLS0tClYxLT5WMjogUmVwbGFjZToge2dldHxwdXR9X2NwdWZyZXFfZ2xvYmFsX2tv
YmplY3Qgd2l0aCBjcHVmcmVxX3tnZXR8cHV0fV9nbG9iYWxfa29iamVjdC4KCiBkcml2ZXJzL2Nw
dWZyZXEvYWNwaS1jcHVmcmVxLmMgICAgIHwgIDQgKystLQogZHJpdmVycy9jcHVmcmVxL2NwdWZy
ZXEuYyAgICAgICAgICB8IDQ4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0t
CiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9nb3Zlcm5vci5jIHwgIDYgKysrKysKIGluY2x1ZGUv
bGludXgvY3B1ZnJlcS5oICAgICAgICAgICAgfCAgNCArKysrCiA0IGZpbGVzIGNoYW5nZWQsIDU2
IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVm
cmVxL2FjcGktY3B1ZnJlcS5jIGIvZHJpdmVycy9jcHVmcmVxL2FjcGktY3B1ZnJlcS5jCmluZGV4
IGNlMjhjMzQuLmFlMDkxOGQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS9hY3BpLWNwdWZy
ZXEuYworKysgYi9kcml2ZXJzL2NwdWZyZXEvYWNwaS1jcHVmcmVxLmMKQEAgLTk0Nyw3ICs5NDcs
NyBAQCBzdGF0aWMgdm9pZCBfX2luaXQgYWNwaV9jcHVmcmVxX2Jvb3N0X2luaXQodm9pZCkKIAkv
KiBXZSBjcmVhdGUgdGhlIGJvb3N0IGZpbGUgaW4gYW55IGNhc2UsIHRob3VnaCBmb3Igc3lzdGVt
cyB3aXRob3V0CiAJICogaGFyZHdhcmUgc3VwcG9ydCBpdCB3aWxsIGJlIHJlYWQtb25seSBhbmQg
aGFyZHdpcmVkIHRvIHJldHVybiAwLgogCSAqLwotCWlmIChzeXNmc19jcmVhdGVfZmlsZShjcHVm
cmVxX2dsb2JhbF9rb2JqZWN0LCAmKGdsb2JhbF9ib29zdC5hdHRyKSkpCisJaWYgKGNwdWZyZXFf
c3lzZnNfY3JlYXRlX2ZpbGUoJihnbG9iYWxfYm9vc3QuYXR0cikpKQogCQlwcl93YXJuKFBGWCAi
Y291bGQgbm90IHJlZ2lzdGVyIGdsb2JhbCBib29zdCBzeXNmcyBmaWxlXG4iKTsKIAllbHNlCiAJ
CXByX2RlYnVnKCJyZWdpc3RlcmVkIGdsb2JhbCBib29zdCBzeXNmcyBmaWxlXG4iKTsKQEAgLTk1
NSw3ICs5NTUsNyBAQCBzdGF0aWMgdm9pZCBfX2luaXQgYWNwaV9jcHVmcmVxX2Jvb3N0X2luaXQo
dm9pZCkKIAogc3RhdGljIHZvaWQgX19leGl0IGFjcGlfY3B1ZnJlcV9ib29zdF9leGl0KHZvaWQp
CiB7Ci0Jc3lzZnNfcmVtb3ZlX2ZpbGUoY3B1ZnJlcV9nbG9iYWxfa29iamVjdCwgJihnbG9iYWxf
Ym9vc3QuYXR0cikpOworCWNwdWZyZXFfc3lzZnNfcmVtb3ZlX2ZpbGUoJihnbG9iYWxfYm9vc3Qu
YXR0cikpOwogCiAJaWYgKG1zcnMpIHsKIAkJdW5yZWdpc3Rlcl9jcHVfbm90aWZpZXIoJmJvb3N0
X25iKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMgYi9kcml2ZXJzL2Nw
dWZyZXEvY3B1ZnJlcS5jCmluZGV4IGUzZDcxMTIuLjc0YTFhNjAgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvY3B1ZnJlcS9jcHVmcmVxLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwpAQCAt
Njc4LDkgKzY3OCw2IEBAIHN0YXRpYyBzdHJ1Y3QgYXR0cmlidXRlICpkZWZhdWx0X2F0dHJzW10g
PSB7CiAJTlVMTAogfTsKIAotc3RydWN0IGtvYmplY3QgKmNwdWZyZXFfZ2xvYmFsX2tvYmplY3Q7
Ci1FWFBPUlRfU1lNQk9MKGNwdWZyZXFfZ2xvYmFsX2tvYmplY3QpOwotCiAjZGVmaW5lIHRvX3Bv
bGljeShrKSBjb250YWluZXJfb2Yoaywgc3RydWN0IGNwdWZyZXFfcG9saWN5LCBrb2JqKQogI2Rl
ZmluZSB0b19hdHRyKGEpIGNvbnRhaW5lcl9vZihhLCBzdHJ1Y3QgZnJlcV9hdHRyLCBhdHRyKQog
CkBAIC03NTEsNiArNzQ4LDQ5IEBAIHN0YXRpYyBzdHJ1Y3Qga29ial90eXBlIGt0eXBlX2NwdWZy
ZXEgPSB7CiAJLnJlbGVhc2UJPSBjcHVmcmVxX3N5c2ZzX3JlbGVhc2UsCiB9OwogCitzdHJ1Y3Qg
a29iamVjdCAqY3B1ZnJlcV9nbG9iYWxfa29iamVjdDsKK0VYUE9SVF9TWU1CT0woY3B1ZnJlcV9n
bG9iYWxfa29iamVjdCk7CisKK3N0YXRpYyBpbnQgY3B1ZnJlcV9nbG9iYWxfa29iamVjdF91c2Fn
ZTsKKworaW50IGNwdWZyZXFfZ2V0X2dsb2JhbF9rb2JqZWN0KHZvaWQpCit7CisJaWYgKCFjcHVm
cmVxX2dsb2JhbF9rb2JqZWN0X3VzYWdlKyspCisJCXJldHVybiBrb2JqZWN0X2FkZChjcHVmcmVx
X2dsb2JhbF9rb2JqZWN0LAorCQkJCSZjcHVfc3Vic3lzLmRldl9yb290LT5rb2JqLCAiJXMiLCAi
Y3B1ZnJlcSIpOworCisJcmV0dXJuIDA7Cit9CitFWFBPUlRfU1lNQk9MKGNwdWZyZXFfZ2V0X2ds
b2JhbF9rb2JqZWN0KTsKKwordm9pZCBjcHVmcmVxX3B1dF9nbG9iYWxfa29iamVjdCh2b2lkKQor
eworCWlmICghLS1jcHVmcmVxX2dsb2JhbF9rb2JqZWN0X3VzYWdlKQorCQlrb2JqZWN0X2RlbChj
cHVmcmVxX2dsb2JhbF9rb2JqZWN0KTsKK30KK0VYUE9SVF9TWU1CT0woY3B1ZnJlcV9wdXRfZ2xv
YmFsX2tvYmplY3QpOworCitpbnQgY3B1ZnJlcV9zeXNmc19jcmVhdGVfZmlsZShjb25zdCBzdHJ1
Y3QgYXR0cmlidXRlICphdHRyKQoreworCWludCByZXQgPSBjcHVmcmVxX2dldF9nbG9iYWxfa29i
amVjdCgpOworCisJaWYgKCFyZXQpIHsKKwkJcmV0ID0gc3lzZnNfY3JlYXRlX2ZpbGUoY3B1ZnJl
cV9nbG9iYWxfa29iamVjdCwgYXR0cik7CisJCWlmIChyZXQpCisJCQljcHVmcmVxX3B1dF9nbG9i
YWxfa29iamVjdCgpOworCX0KKworCXJldHVybiByZXQ7Cit9CitFWFBPUlRfU1lNQk9MKGNwdWZy
ZXFfc3lzZnNfY3JlYXRlX2ZpbGUpOworCit2b2lkIGNwdWZyZXFfc3lzZnNfcmVtb3ZlX2ZpbGUo
Y29uc3Qgc3RydWN0IGF0dHJpYnV0ZSAqYXR0cikKK3sKKwlzeXNmc19yZW1vdmVfZmlsZShjcHVm
cmVxX2dsb2JhbF9rb2JqZWN0LCBhdHRyKTsKKwljcHVmcmVxX3B1dF9nbG9iYWxfa29iamVjdCgp
OworfQorRVhQT1JUX1NZTUJPTChjcHVmcmVxX3N5c2ZzX3JlbW92ZV9maWxlKTsKKwogLyogc3lt
bGluayBhZmZlY3RlZCBDUFVzICovCiBzdGF0aWMgaW50IGNwdWZyZXFfYWRkX2Rldl9zeW1saW5r
KHVuc2lnbmVkIGludCBjcHUsCiAJCQkJICAgc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3kp
CkBAIC0yMDIyLDcgKzIwNjIsNyBAQCBzdGF0aWMgaW50IF9faW5pdCBjcHVmcmVxX2NvcmVfaW5p
dCh2b2lkKQogCQlpbml0X3J3c2VtKCZwZXJfY3B1KGNwdV9wb2xpY3lfcndzZW0sIGNwdSkpOwog
CX0KIAotCWNwdWZyZXFfZ2xvYmFsX2tvYmplY3QgPSBrb2JqZWN0X2NyZWF0ZV9hbmRfYWRkKCJj
cHVmcmVxIiwgJmNwdV9zdWJzeXMuZGV2X3Jvb3QtPmtvYmopOworCWNwdWZyZXFfZ2xvYmFsX2tv
YmplY3QgPSBrb2JqZWN0X2NyZWF0ZSgpOwogCUJVR19PTighY3B1ZnJlcV9nbG9iYWxfa29iamVj
dCk7CiAJcmVnaXN0ZXJfc3lzY29yZV9vcHMoJmNwdWZyZXFfc3lzY29yZV9vcHMpOwogCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9nb3Zlcm5vci5jIGIvZHJpdmVycy9jcHVm
cmVxL2NwdWZyZXFfZ292ZXJub3IuYwppbmRleCBiNmNmZDU1Li43NTMyNTcwIDEwMDY0NAotLS0g
YS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9nb3Zlcm5vci5jCisrKyBiL2RyaXZlcnMvY3B1ZnJl
cS9jcHVmcmVxX2dvdmVybm9yLmMKQEAgLTIzMSw2ICsyMzEsOSBAQCBpbnQgY3B1ZnJlcV9nb3Zl
cm5vcl9kYnMoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksCiAJCQlyZXR1cm4gcmM7CiAJ
CX0KIAorCQlpZiAoIWhhdmVfZ292ZXJub3JfcGVyX3BvbGljeSgpKQorCQkJV0FSTl9PTihjcHVm
cmVxX2dldF9nbG9iYWxfa29iamVjdCgpKTsKKwogCQlyYyA9IHN5c2ZzX2NyZWF0ZV9ncm91cChn
ZXRfZ292ZXJub3JfcGFyZW50X2tvYmoocG9saWN5KSwKIAkJCQlnZXRfc3lzZnNfYXR0cihkYnNf
ZGF0YSkpOwogCQlpZiAocmMpIHsKQEAgLTI2OSw2ICsyNzIsOSBAQCBpbnQgY3B1ZnJlcV9nb3Zl
cm5vcl9kYnMoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksCiAJCQlzeXNmc19yZW1vdmVf
Z3JvdXAoZ2V0X2dvdmVybm9yX3BhcmVudF9rb2JqKHBvbGljeSksCiAJCQkJCWdldF9zeXNmc19h
dHRyKGRic19kYXRhKSk7CiAKKwkJCWlmICghaGF2ZV9nb3Zlcm5vcl9wZXJfcG9saWN5KCkpCisJ
CQkJY3B1ZnJlcV9wdXRfZ2xvYmFsX2tvYmplY3QoKTsKKwogCQkJaWYgKChkYnNfZGF0YS0+Y2Rh
dGEtPmdvdmVybm9yID09IEdPVl9DT05TRVJWQVRJVkUpICYmCiAJCQkJKHBvbGljeS0+Z292ZXJu
b3ItPmluaXRpYWxpemVkID09IDEpKSB7CiAJCQkJc3RydWN0IGNzX29wcyAqY3Nfb3BzID0gZGJz
X2RhdGEtPmNkYXRhLT5nb3Zfb3BzOwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9jcHVmcmVx
LmggYi9pbmNsdWRlL2xpbnV4L2NwdWZyZXEuaAppbmRleCBjYmRmNWE0Li5iOTdkOTliIDEwMDY0
NAotLS0gYS9pbmNsdWRlL2xpbnV4L2NwdWZyZXEuaAorKysgYi9pbmNsdWRlL2xpbnV4L2NwdWZy
ZXEuaApAQCAtNzEsNiArNzEsMTAgQEAgc3RydWN0IGNwdWZyZXFfZ292ZXJub3I7CiAKIC8qIC9z
eXMvZGV2aWNlcy9zeXN0ZW0vY3B1L2NwdWZyZXE6IGVudHJ5IHBvaW50IGZvciBnbG9iYWwgdmFy
aWFibGVzICovCiBleHRlcm4gc3RydWN0IGtvYmplY3QgKmNwdWZyZXFfZ2xvYmFsX2tvYmplY3Q7
CitpbnQgY3B1ZnJlcV9nZXRfZ2xvYmFsX2tvYmplY3Qodm9pZCk7Cit2b2lkIGNwdWZyZXFfcHV0
X2dsb2JhbF9rb2JqZWN0KHZvaWQpOworaW50IGNwdWZyZXFfc3lzZnNfY3JlYXRlX2ZpbGUoY29u
c3Qgc3RydWN0IGF0dHJpYnV0ZSAqYXR0cik7Cit2b2lkIGNwdWZyZXFfc3lzZnNfcmVtb3ZlX2Zp
bGUoY29uc3Qgc3RydWN0IGF0dHJpYnV0ZSAqYXR0cik7CiAKICNkZWZpbmUgQ1BVRlJFUV9FVEVS
TkFMCQkJKC0xKQogc3RydWN0IGNwdWZyZXFfY3B1aW5mbyB7Ci0tIAoxLjcuMTIucmMyLjE4Lmc2
MWI0NzJlCgo=
--f46d0447878d1b53fe04dd1eeb58--
