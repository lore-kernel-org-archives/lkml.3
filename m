Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab3FMFwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 01:52:09 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:41074 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab3FMFwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 01:52:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAFgnuDeeU5qALyqN4Akpi5SoHRXPWaq_PLYSSmjxkq9V5N=qag@mail.gmail.com>
References: <1371028189-15758-1-git-send-email-chenxg@marvell.com>
	<CAKohponeWuaXPah4s9GjO-fLwQNuyKidUFosN1iE+e7bngDPdQ@mail.gmail.com>
	<CAFgnuDeeU5qALyqN4Akpi5SoHRXPWaq_PLYSSmjxkq9V5N=qag@mail.gmail.com>
Date: Thu, 13 Jun 2013 11:22:04 +0530
Message-ID: <CAKohpom0-Z+s4G+OOhVZJn=HK7NVKHCXS-_0FJd07K+L5DwgHA@mail.gmail.com>
Subject: Re: [PATCH v4] cpufreq: fix governor start/stop race condition
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg.marvell@gmail.com>
Cc: Xiaoguang Chen <chenxg@marvell.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        njiang1@marvell.com, zjwu@marvell.com, ylmao@marvell.com
Content-Type: multipart/mixed; boundary=089e0115f6c6d952a104df02ba2f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0115f6c6d952a104df02ba2f
Content-Type: text/plain; charset=ISO-8859-1

On 13 June 2013 11:10, Xiaoguang Chen <chenxg.marvell@gmail.com> wrote:
> 2013/6/12 Viresh Kumar <viresh.kumar@linaro.org>:
>> On 12 June 2013 14:39, Xiaoguang Chen <chenxg@marvell.com> wrote:
>>
>>>         ret = policy->governor->governor(policy, event);
>>
>> We again reached to the same problem. We shouldn't call
>> this between taking locks, otherwise recursive locks problems
>> would be seen again.
>
> But this is not the same lock as the deadlock case, it is a new lock,
> and only used in this function. no other functions use this lock.
> I don't know how can we get dead lock again?

I believe I have seen the recursive lock issue with different locks but
I am not sure. Anyway, I believe the implementation can be simpler than
that.

Check below patch (attached too):

------------x------------------x----------------

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2d53f47..80b9798 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -46,6 +46,7 @@ static DEFINE_PER_CPU(struct cpufreq_policy *,
cpufreq_cpu_data);
 static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
 static DEFINE_RWLOCK(cpufreq_driver_lock);
+static DEFINE_MUTEX(cpufreq_governor_lock);

 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
@@ -1541,7 +1542,6 @@ static int __cpufreq_governor(struct
cpufreq_policy *policy,
 #else
 	struct cpufreq_governor *gov = NULL;
 #endif
-
 	if (policy->governor->max_transition_latency &&
 	    policy->cpuinfo.transition_latency >
 	    policy->governor->max_transition_latency) {
@@ -1562,6 +1562,21 @@ static int __cpufreq_governor(struct
cpufreq_policy *policy,

 	pr_debug("__cpufreq_governor for CPU %u, event %u\n",
 						policy->cpu, event);
+
+	mutex_lock(&cpufreq_governor_lock);
+	if ((!policy->governor_enabled && (event == CPUFREQ_GOV_STOP)) ||
+	    (policy->governor_enabled && (event == CPUFREQ_GOV_START))) {
+		mutex_unlock(&cpufreq_governor_lock);
+		return -EBUSY;
+	}
+
+	if (event == CPUFREQ_GOV_STOP)
+		policy->governor_enabled = 0;
+	else if (event == CPUFREQ_GOV_START)
+		policy->governor_enabled = 1;
+
+	mutex_unlock(&cpufreq_governor_lock);
+
 	ret = policy->governor->governor(policy, event);

 	if (!ret) {
@@ -1569,6 +1584,14 @@ static int __cpufreq_governor(struct
cpufreq_policy *policy,
 			policy->governor->initialized++;
 		else if (event == CPUFREQ_GOV_POLICY_EXIT)
 			policy->governor->initialized--;
+	} else {
+		/* Restore original values */
+		mutex_lock(&cpufreq_governor_lock);
+		if (event == CPUFREQ_GOV_STOP)
+			policy->governor_enabled = 1;
+		else if (event == CPUFREQ_GOV_START)
+			policy->governor_enabled = 0;
+		mutex_unlock(&cpufreq_governor_lock);
 	}

 	/* we keep one module reference alive for
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 037d36a..c12db73 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -107,6 +107,7 @@ struct cpufreq_policy {
 	unsigned int		policy; /* see above */
 	struct cpufreq_governor	*governor; /* see below */
 	void			*governor_data;
+	int			governor_enabled; /* governor start/stop flag */

 	struct work_struct	update; /* if update_policy() needs to be
 					 * called, but you're in IRQ context */

--089e0115f6c6d952a104df02ba2f
Content-Type: application/octet-stream; 
	name="0001-cpufreq-fix-governor-start-stop-race-condition.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-fix-governor-start-stop-race-condition.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hhvj5a7m0

RnJvbSBiYWRiMzhjZTQ3NDJjNzUyZTU3M2QyODg0MzkwNDY3ZWEyOTg2NmM5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8YmFkYjM4Y2U0NzQyYzc1MmU1NzNkMjg4NDM5MDQ2
N2VhMjk4NjZjOS4xMzcxMTAyNjY5LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
WGlhb2d1YW5nIENoZW4gPGNoZW54Z0BtYXJ2ZWxsLmNvbT4KRGF0ZTogV2VkLCAxMiBKdW4gMjAx
MyAxNzowOTo0OSArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IGZpeCBnb3Zlcm5vciBz
dGFydC9zdG9wIHJhY2UgY29uZGl0aW9uCgpjcHVmcmVxIGdvdmVybm9yIHN0b3AgYW5kIHN0YXJ0
IHNob3VsZCBiZSBrZXB0IGluIHNlcXVlbmNlLgpJZiBub3QsIHRoZXJlIHdpbGwgYmUgdW5leHBl
Y3RlZCBiZWhhdmlvciwgZm9yIGV4YW1wbGU6Cgp3ZSBoYXZlIDQgY3B1cyBhbmQgcG9saWN5LT5j
cHU9Y3B1MCwgY3B1MS8yLzMgYXJlIGxpbmtlZCB0byBjcHUwLgp0aGUgbm9ybWFsIHNlcXVlbmNl
IGlzIGFzIGJlbG93OgoKMSkgQ3VycmVudCBnb3Zlcm5vciBpcyB1c2Vyc3BhY2UsIG9uZSBhcHBs
aWNhdGlvbiB0cmllcyB0byBzZXQKZ292ZXJub3IgdG8gb25kZW1hbmQuIGl0IHdpbGwgY2FsbCBf
X2NwdWZyZXFfc2V0X3BvbGljeSBpbiB3aGljaCBpdAp3aWxsIHN0b3AgdXNlcnNwYWNlIGdvdmVy
bm9yIGFuZCB0aGVuIHN0YXJ0IG9uZGVtYW5kIGdvdmVybm9yLgoKMikgQ3VycmVudCBnb3Zlcm5v
ciBpcyB1c2Vyc3BhY2UsIG5vdyBjcHUwIGhvdHBsdWdzIGluIGNwdTMsIGl0IHdpbGwKY2FsbCBj
cHVmcmVxX2FkZF9wb2xpY3lfY3B1LiBvbiB3aGljaCBpdCBmaXJzdCBzdG9wcyB1c2Vyc3BhY2UK
Z292ZXJub3IsIGFuZCB0aGVuIHN0YXJ0cyB1c2Vyc3BhY2UgZ292ZXJub3IuCgpOb3cgaWYgdGhl
IHNlcXVlbmNlIG9mIGFib3ZlIHR3byBjYXNlcyBpbnRlcmxlYXZlcywgaXQgYmVjYW1lcwpiZWxv
dyBzZXF1ZW5jZToKCjEpIGFwcGxpY2F0aW9uIHN0b3BzIHVzZXJzcGFjZSBnb3Zlcm5vcgoyKSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaG90cGx1ZyBzdG9wcyB1c2Vyc3Bh
Y2UgZ292ZXJub3IKMykgYXBwbGljYXRpb24gc3RhcnRzIG9uZGVtYW5kIGdvdmVybm9yCjQpICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBob3RwbHVnIHN0YXJ0cyBhIGdvdmVy
bm9yCgppbiBzdGVwIDQsIGhvdHBsdWcgaXMgc3VwcG9zZWQgdG8gc3RhcnQgdXNlcnNwYWNlIGdv
dmVybm9yLCBidXQgbm93CnRoZSBnb3Zlcm5vciBoYXMgYmVlbiBjaGFuZ2VkIGJ5IGFwcGxpY2F0
aW9uIHRvIG9uZGVtYW5kLCBzbyBob3RwbHVnCnN0YXJ0cyBvbmRlbWFuZCBnb3Zlcm5vciBhZ2Fp
biAhISEhCgpUaGUgc29sdXRpb24gaXM6IGRvIG5vdCBhbGxvdyBzdG9wIG9uZSBwb2xpY3kncyBn
b3Zlcm5vciBtdWx0aS10aW1lcwpHb3Zlcm5vciBzdG9wIHNob3VsZCBvbmx5IGRvIG9uY2UgZm9y
IG9uZSBwb2xpY3ksIGFmdGVyIGl0IGlzIHN0b3BwZWQsCm5vIG90aGVyIGdvdmVybm9yIHN0b3Ag
c2hvdWxkIGJlIGV4ZWN1dGVkLiBhbHNvIGFkZCBvbmUgbXV0ZXh0IHRvCnByb3RlY3QgX19jcHVm
cmVxX2dvdmVybm9yIHNvIGdvdmVybm9yIG9wZXJhdGlvbiBjYW4gYmUga2VwdCBpbiBzZXF1ZW5j
ZS4KClNpZ25lZC1vZmYtYnk6IFhpYW9ndWFuZyBDaGVuIDxjaGVueGdAbWFydmVsbC5jb20+Ci0t
LQogZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYyB8IDI1ICsrKysrKysrKysrKysrKysrKysrKysr
Ky0KIGluY2x1ZGUvbGludXgvY3B1ZnJlcS5oICAgfCAgMSArCiAyIGZpbGVzIGNoYW5nZWQsIDI1
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWZy
ZXEvY3B1ZnJlcS5jIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwppbmRleCAyZDUzZjQ3Li44
MGI5Nzk4IDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jCisrKyBiL2RyaXZl
cnMvY3B1ZnJlcS9jcHVmcmVxLmMKQEAgLTQ2LDYgKzQ2LDcgQEAgc3RhdGljIERFRklORV9QRVJf
Q1BVKHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqLCBjcHVmcmVxX2NwdV9kYXRhKTsKIHN0YXRpYyBE
RUZJTkVfUEVSX0NQVShjaGFyW0NQVUZSRVFfTkFNRV9MRU5dLCBjcHVmcmVxX2NwdV9nb3Zlcm5v
cik7CiAjZW5kaWYKIHN0YXRpYyBERUZJTkVfUldMT0NLKGNwdWZyZXFfZHJpdmVyX2xvY2spOwor
c3RhdGljIERFRklORV9NVVRFWChjcHVmcmVxX2dvdmVybm9yX2xvY2spOwogCiAvKgogICogY3B1
X3BvbGljeV9yd3NlbSBpcyBhIHBlciBDUFUgcmVhZGVyLXdyaXRlciBzZW1hcGhvcmUgZGVzaWdu
ZWQgdG8gY3VyZQpAQCAtMTU0MSw3ICsxNTQyLDYgQEAgc3RhdGljIGludCBfX2NwdWZyZXFfZ292
ZXJub3Ioc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksCiAjZWxzZQogCXN0cnVjdCBjcHVm
cmVxX2dvdmVybm9yICpnb3YgPSBOVUxMOwogI2VuZGlmCi0KIAlpZiAocG9saWN5LT5nb3Zlcm5v
ci0+bWF4X3RyYW5zaXRpb25fbGF0ZW5jeSAmJgogCSAgICBwb2xpY3ktPmNwdWluZm8udHJhbnNp
dGlvbl9sYXRlbmN5ID4KIAkgICAgcG9saWN5LT5nb3Zlcm5vci0+bWF4X3RyYW5zaXRpb25fbGF0
ZW5jeSkgewpAQCAtMTU2Miw2ICsxNTYyLDIxIEBAIHN0YXRpYyBpbnQgX19jcHVmcmVxX2dvdmVy
bm9yKHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5LAogCiAJcHJfZGVidWcoIl9fY3B1ZnJl
cV9nb3Zlcm5vciBmb3IgQ1BVICV1LCBldmVudCAldVxuIiwKIAkJCQkJCXBvbGljeS0+Y3B1LCBl
dmVudCk7CisKKwltdXRleF9sb2NrKCZjcHVmcmVxX2dvdmVybm9yX2xvY2spOworCWlmICgoIXBv
bGljeS0+Z292ZXJub3JfZW5hYmxlZCAmJiAoZXZlbnQgPT0gQ1BVRlJFUV9HT1ZfU1RPUCkpIHx8
CisJICAgIChwb2xpY3ktPmdvdmVybm9yX2VuYWJsZWQgJiYgKGV2ZW50ID09IENQVUZSRVFfR09W
X1NUQVJUKSkpIHsKKwkJbXV0ZXhfdW5sb2NrKCZjcHVmcmVxX2dvdmVybm9yX2xvY2spOworCQly
ZXR1cm4gLUVCVVNZOworCX0KKworCWlmIChldmVudCA9PSBDUFVGUkVRX0dPVl9TVE9QKQorCQlw
b2xpY3ktPmdvdmVybm9yX2VuYWJsZWQgPSAwOworCWVsc2UgaWYgKGV2ZW50ID09IENQVUZSRVFf
R09WX1NUQVJUKQorCQlwb2xpY3ktPmdvdmVybm9yX2VuYWJsZWQgPSAxOworCisJbXV0ZXhfdW5s
b2NrKCZjcHVmcmVxX2dvdmVybm9yX2xvY2spOworCiAJcmV0ID0gcG9saWN5LT5nb3Zlcm5vci0+
Z292ZXJub3IocG9saWN5LCBldmVudCk7CiAKIAlpZiAoIXJldCkgewpAQCAtMTU2OSw2ICsxNTg0
LDE0IEBAIHN0YXRpYyBpbnQgX19jcHVmcmVxX2dvdmVybm9yKHN0cnVjdCBjcHVmcmVxX3BvbGlj
eSAqcG9saWN5LAogCQkJcG9saWN5LT5nb3Zlcm5vci0+aW5pdGlhbGl6ZWQrKzsKIAkJZWxzZSBp
ZiAoZXZlbnQgPT0gQ1BVRlJFUV9HT1ZfUE9MSUNZX0VYSVQpCiAJCQlwb2xpY3ktPmdvdmVybm9y
LT5pbml0aWFsaXplZC0tOworCX0gZWxzZSB7CisJCS8qIFJlc3RvcmUgb3JpZ2luYWwgdmFsdWVz
ICovCisJCW11dGV4X2xvY2soJmNwdWZyZXFfZ292ZXJub3JfbG9jayk7CisJCWlmIChldmVudCA9
PSBDUFVGUkVRX0dPVl9TVE9QKQorCQkJcG9saWN5LT5nb3Zlcm5vcl9lbmFibGVkID0gMTsKKwkJ
ZWxzZSBpZiAoZXZlbnQgPT0gQ1BVRlJFUV9HT1ZfU1RBUlQpCisJCQlwb2xpY3ktPmdvdmVybm9y
X2VuYWJsZWQgPSAwOworCQltdXRleF91bmxvY2soJmNwdWZyZXFfZ292ZXJub3JfbG9jayk7CiAJ
fQogCiAJLyogd2Uga2VlcCBvbmUgbW9kdWxlIHJlZmVyZW5jZSBhbGl2ZSBmb3IKZGlmZiAtLWdp
dCBhL2luY2x1ZGUvbGludXgvY3B1ZnJlcS5oIGIvaW5jbHVkZS9saW51eC9jcHVmcmVxLmgKaW5k
ZXggMDM3ZDM2YS4uYzEyZGI3MyAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9jcHVmcmVxLmgK
KysrIGIvaW5jbHVkZS9saW51eC9jcHVmcmVxLmgKQEAgLTEwNyw2ICsxMDcsNyBAQCBzdHJ1Y3Qg
Y3B1ZnJlcV9wb2xpY3kgewogCXVuc2lnbmVkIGludAkJcG9saWN5OyAvKiBzZWUgYWJvdmUgKi8K
IAlzdHJ1Y3QgY3B1ZnJlcV9nb3Zlcm5vcgkqZ292ZXJub3I7IC8qIHNlZSBiZWxvdyAqLwogCXZv
aWQJCQkqZ292ZXJub3JfZGF0YTsKKwlpbnQJCQlnb3Zlcm5vcl9lbmFibGVkOyAvKiBnb3Zlcm5v
ciBzdGFydC9zdG9wIGZsYWcgKi8KIAogCXN0cnVjdCB3b3JrX3N0cnVjdAl1cGRhdGU7IC8qIGlm
IHVwZGF0ZV9wb2xpY3koKSBuZWVkcyB0byBiZQogCQkJCQkgKiBjYWxsZWQsIGJ1dCB5b3UncmUg
aW4gSVJRIGNvbnRleHQgKi8KLS0gCjEuNy4xMi5yYzIuMTguZzYxYjQ3MmUKCg==
--089e0115f6c6d952a104df02ba2f--
