Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab3FEFHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 01:07:32 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:36355 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3FEFHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 01:07:30 -0400
MIME-Version: 1.0
In-Reply-To: <51AEC1C3.1040804@linux.vnet.ibm.com>
References: <d226c91fed3dfa2dca644d14c88b1d1ff9d2e722.1370344689.git.viresh.kumar@linaro.org>
	<51AEC1C3.1040804@linux.vnet.ibm.com>
Date: Wed, 5 Jun 2013 10:37:29 +0530
Message-ID: <CAKohpokGrgFOtOT6Y3e4MOJBUQWT4FG4Mk-F6_M0V-pEEf3KYw@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: Optimize build_sched_domains() for saving
 first SD node for a cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: mingo@redhat.com, peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Content-Type: multipart/mixed; boundary=089e016350c4aa44ea04de612c49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e016350c4aa44ea04de612c49
Content-Type: text/plain; charset=ISO-8859-1

On 5 June 2013 10:12, Michael Wang <wangyun@linux.vnet.ibm.com> wrote:
> Hi, Viresh
>
> On 06/04/2013 07:20 PM, Viresh Kumar wrote:
> [snip]
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 58453b8..638f6cb 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -6533,16 +6533,13 @@ static int build_sched_domains(const struct cpumask *cpu_map,
>>               sd = NULL;
>>               for (tl = sched_domain_topology; tl->init; tl++) {
>>                       sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
>> +                     if (!*per_cpu_ptr(d.sd, i))
>
> What about:
>                         if (tl == sched_domain_topology)
>
> It cost less than per_cpu_ptr(), isn't it?

How can I miss it.. Obviously its better :)

See if below one looks better (Attached too in case gmail screws up
my mail)..

--------x-------------x------------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Tue, 4 Jun 2013 15:41:15 +0530
Subject: [PATCH] sched: Optimize build_sched_domains() for saving first SD
 node for a cpu

We are saving first scheduling domain for a cpu in build_sched_domains() by
iterating over the nested sd->child list. We don't actually need to do it this
way.

tl will be equal to sched_domain_topology for the first iteration and so we can
set *per_cpu_ptr(d.sd, i) based on that.  So, save pointer to first SD while
running the iteration loop over tl's.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/sched/core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58453b8..08a27be 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6533,16 +6533,13 @@ static int build_sched_domains(const struct
cpumask *cpu_map,
 		sd = NULL;
 		for (tl = sched_domain_topology; tl->init; tl++) {
 			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
+			if (tl == sched_domain_topology)
+				*per_cpu_ptr(d.sd, i) = sd;
 			if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
 				sd->flags |= SD_OVERLAP;
 			if (cpumask_equal(cpu_map, sched_domain_span(sd)))
 				break;
 		}
-
-		while (sd->child)
-			sd = sd->child;
-
-		*per_cpu_ptr(d.sd, i) = sd;
 	}

 	/* Build the groups for the domains */

--089e016350c4aa44ea04de612c49
Content-Type: application/octet-stream; 
	name="0001-sched-Optimize-build_sched_domains-for-saving-first-.patch"
Content-Disposition: attachment; 
	filename="0001-sched-Optimize-build_sched_domains-for-saving-first-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hhk20pdf0

RnJvbSA0NjBkYmVhYWVhNzdhOTM5ZTQyYjVhNTFjYjI3NTc4ZjdiY2I4ZjRkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8NDYwZGJlYWFlYTc3YTkzOWU0MmI1YTUxY2IyNzU3
OGY3YmNiOGY0ZC4xMzcwNDA4Nzg3LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogVHVlLCA0IEp1biAy
MDEzIDE1OjQxOjE1ICswNTMwClN1YmplY3Q6IFtQQVRDSF0gc2NoZWQ6IE9wdGltaXplIGJ1aWxk
X3NjaGVkX2RvbWFpbnMoKSBmb3Igc2F2aW5nIGZpcnN0IFNECiBub2RlIGZvciBhIGNwdQoKV2Ug
YXJlIHNhdmluZyBmaXJzdCBzY2hlZHVsaW5nIGRvbWFpbiBmb3IgYSBjcHUgaW4gYnVpbGRfc2No
ZWRfZG9tYWlucygpIGJ5Cml0ZXJhdGluZyBvdmVyIHRoZSBuZXN0ZWQgc2QtPmNoaWxkIGxpc3Qu
IFdlIGRvbid0IGFjdHVhbGx5IG5lZWQgdG8gZG8gaXQgdGhpcwp3YXkuCgp0bCB3aWxsIGJlIGVx
dWFsIHRvIHNjaGVkX2RvbWFpbl90b3BvbG9neSBmb3IgdGhlIGZpcnN0IGl0ZXJhdGlvbiBhbmQg
c28gd2UgY2FuCnNldCAqcGVyX2NwdV9wdHIoZC5zZCwgaSkgYmFzZWQgb24gdGhhdC4gIFNvLCBz
YXZlIHBvaW50ZXIgdG8gZmlyc3QgU0Qgd2hpbGUKcnVubmluZyB0aGUgaXRlcmF0aW9uIGxvb3Ag
b3ZlciB0bCdzLgoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGlu
YXJvLm9yZz4KLS0tCiBrZXJuZWwvc2NoZWQvY29yZS5jIHwgNyArKy0tLS0tCiAxIGZpbGUgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2tlcm5l
bC9zY2hlZC9jb3JlLmMgYi9rZXJuZWwvc2NoZWQvY29yZS5jCmluZGV4IDU4NDUzYjguLjA4YTI3
YmUgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9zY2hlZC9jb3JlLmMKKysrIGIva2VybmVsL3NjaGVkL2Nv
cmUuYwpAQCAtNjUzMywxNiArNjUzMywxMyBAQCBzdGF0aWMgaW50IGJ1aWxkX3NjaGVkX2RvbWFp
bnMoY29uc3Qgc3RydWN0IGNwdW1hc2sgKmNwdV9tYXAsCiAJCXNkID0gTlVMTDsKIAkJZm9yICh0
bCA9IHNjaGVkX2RvbWFpbl90b3BvbG9neTsgdGwtPmluaXQ7IHRsKyspIHsKIAkJCXNkID0gYnVp
bGRfc2NoZWRfZG9tYWluKHRsLCAmZCwgY3B1X21hcCwgYXR0ciwgc2QsIGkpOworCQkJaWYgKHRs
ID09IHNjaGVkX2RvbWFpbl90b3BvbG9neSkKKwkJCQkqcGVyX2NwdV9wdHIoZC5zZCwgaSkgPSBz
ZDsKIAkJCWlmICh0bC0+ZmxhZ3MgJiBTRFRMX09WRVJMQVAgfHwgc2NoZWRfZmVhdChGT1JDRV9T
RF9PVkVSTEFQKSkKIAkJCQlzZC0+ZmxhZ3MgfD0gU0RfT1ZFUkxBUDsKIAkJCWlmIChjcHVtYXNr
X2VxdWFsKGNwdV9tYXAsIHNjaGVkX2RvbWFpbl9zcGFuKHNkKSkpCiAJCQkJYnJlYWs7CiAJCX0K
LQotCQl3aGlsZSAoc2QtPmNoaWxkKQotCQkJc2QgPSBzZC0+Y2hpbGQ7Ci0KLQkJKnBlcl9jcHVf
cHRyKGQuc2QsIGkpID0gc2Q7CiAJfQogCiAJLyogQnVpbGQgdGhlIGdyb3VwcyBmb3IgdGhlIGRv
bWFpbnMgKi8KLS0gCjEuNy4xMi5yYzIuMTguZzYxYjQ3MmUKCg==
--089e016350c4aa44ea04de612c49--
