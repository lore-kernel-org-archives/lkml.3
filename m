Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab3IPRIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 13:08:09 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:44063 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3IPRIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:08:07 -0400
MIME-Version: 1.0
In-Reply-To: <1379348823.3422.42.camel@linaro1.home>
References: <075032be4fd288074b8f699d4f4ba0179518df6f.1379344038.git.viresh.kumar@linaro.org>
	<1379348823.3422.42.camel@linaro1.home>
Date: Mon, 16 Sep 2013 22:38:05 +0530
Message-ID: <CAKohpomEQsS-WHQpa=_07NQ1FXDB711inrmMgUguD529BA7g1A@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: unlock correct rwsem while updating policy->cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: multipart/mixed; boundary=089e0149d0ae648b2204e6833f43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0149d0ae648b2204e6833f43
Content-Type: text/plain; charset=ISO-8859-1

On 16 September 2013 21:57, Jon Medhurst (Tixy) <tixy@linaro.org> wrote:
> If I take mainline code and just change the line above to:

You meant this line by above line?

         unlock_policy_rwsem_write(cpu);

>    up_write(&per_cpu(cpu_policy_rwsem, (per_cpu(cpufreq_cpu_data,
> cpu))->last_cpu));
> then the big_little cpufreq driver works for me.

That would be same as: up_write(&per_cpu(cpu_policy_rwsem, policy->last_cpu));

>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 43c24aa..c18bf7b 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -952,9 +952,16 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
>>       if (cpu == policy->cpu)
>>               return;
>>
>> +     /* take direct locks as lock_policy_rwsem_write wouldn't work here */
>> +     down_write(&per_cpu(cpu_policy_rwsem, policy->cpu));
>> +     down_write(&per_cpu(cpu_policy_rwsem, cpu));
>> +
>>       policy->last_cpu = policy->cpu;
>>       policy->cpu = cpu;
>>
>> +     up_write(&per_cpu(cpu_policy_rwsem, cpu));
>> +     up_write(&per_cpu(cpu_policy_rwsem, policy->cpu));
>
> You've just overwritten policy->cpu with cpu.

Stupid enough :)

> I tried using
> policy->last_cpu to fix that, but it still doesn't work for me (giving
> the lockdep warning I mentioned.) If I change the code to just lock the
> original policy->cpu lock only, then all is fine.

Fixed my patch now.. find attached.. It mentions why lock for last cpu is
enough here. Copied that here too..

+ /*
+ * Take direct locks as lock_policy_rwsem_write wouldn't work here.
+ * Also lock for last cpu is enough here as contention will happen only
+ * after policy->cpu is changed and after it is changed, other threads
+ * will try to acquire lock for new cpu. And policy is already updated
+ * by then.
+ */

> Also, this locking is now just happening around policy->cpu update,
> whereas before this change, it was locked for the whole of
> update_policy_cpu, i.e. cpufreq_frequency_table_update_policy_cpu and
> the notifier callbacks. Is that change of lock coverage OK?

Yeah, the rwsem is only required for updating policy's fields and so that
should be okay.

--089e0149d0ae648b2204e6833f43
Content-Type: application/octet-stream; 
	name="0001-cpufreq-unlock-correct-rwsem-while-updating-policy-c.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-unlock-correct-rwsem-while-updating-policy-c.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hlny50mf0

RnJvbSA1MWUzNDU4Zjc4NTNjY2E5OWNmYmRmYTVhYzQxOWRmZGU0NzFjNWZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8NTFlMzQ1OGY3ODUzY2NhOTljZmJkZmE1YWM0MTlk
ZmRlNDcxYzVmYS4xMzc5MzUxMTU4LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogTW9uLCAxNiBTZXAg
MjAxMyAyMDoxNzowOCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IHVubG9jayBjb3Jy
ZWN0IHJ3c2VtIHdoaWxlIHVwZGF0aW5nIHBvbGljeS0+Y3B1CgpDdXJyZW50IGNvZGUgbG9va3Mg
bGlrZSB0aGlzOgoKICAgICAgICBXQVJOX09OKGxvY2tfcG9saWN5X3J3c2VtX3dyaXRlKGNwdSkp
OwogICAgICAgIHVwZGF0ZV9wb2xpY3lfY3B1KHBvbGljeSwgbmV3X2NwdSk7CiAgICAgICAgdW5s
b2NrX3BvbGljeV9yd3NlbV93cml0ZShjcHUpOwoKe2xvY2t8dW5sb2NrfV9wb2xpY3lfcndzZW1f
d3JpdGUoY3B1KSB0YWtlcy9yZWxlYXNlcyBwb2xpY3ktPmNwdSdzIHJ3c2VtLgpCZWNhdXNlIGNw
dSBpcyBjaGFuZ2luZyB3aXRoIHRoZSBjYWxsIHRvIHVwZGF0ZV9wb2xpY3lfY3B1KCksIHRoZQp1
bmxvY2tfcG9saWN5X3J3c2VtX3dyaXRlKCkgd2lsbCByZWxlYXNlIHRoZSBpbmNvcnJlY3QgbG9j
ay4KClRoZSByaWdodCBzb2x1dGlvbiB3b3VsZCBiZSB0byB0YWtlIHJ3c2VtIGxvY2svdW5sb2Nr
IGZvciBib3RoIG9sZCBhbmQgbmV3IGNwdS4KVGhpcyBwYXRjaCBmaXhlcyB0aGlzIGJ1ZyBieSB0
YWtpbmcgYm90aCBsb2NrcyBkaXJlY3RseSBpbnN0ZWFkIG9mIGNhbGxpbmcKbG9ja19wb2xpY3lf
cndzZW1fd3JpdGUoKS4KClJlcG9ydGVkLWJ5OiBKb24gTWVkaHVyc3Q8dGl4eUBsaW5hcm8ub3Jn
PgpTaWduZWQtb2ZmLWJ5OiBWaXJlc2ggS3VtYXIgPHZpcmVzaC5rdW1hckBsaW5hcm8ub3JnPgot
LS0KIGRyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMgfCAxMyArKysrKysrKysrKy0tCiAxIGZpbGUg
Y2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwppbmRl
eCA0M2MyNGFhLi4xNDc5NTIyIDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5j
CisrKyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMKQEAgLTk1Miw5ICs5NTIsMjAgQEAgc3Rh
dGljIHZvaWQgdXBkYXRlX3BvbGljeV9jcHUoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ks
IHVuc2lnbmVkIGludCBjcHUpCiAJaWYgKGNwdSA9PSBwb2xpY3ktPmNwdSkKIAkJcmV0dXJuOwog
CisJLyoKKwkgKiBUYWtlIGRpcmVjdCBsb2NrcyBhcyBsb2NrX3BvbGljeV9yd3NlbV93cml0ZSB3
b3VsZG4ndCB3b3JrIGhlcmUuCisJICogQWxzbyBsb2NrIGZvciBsYXN0IGNwdSBpcyBlbm91Z2gg
aGVyZSBhcyBjb250ZW50aW9uIHdpbGwgaGFwcGVuIG9ubHkKKwkgKiBhZnRlciBwb2xpY3ktPmNw
dSBpcyBjaGFuZ2VkIGFuZCBhZnRlciBpdCBpcyBjaGFuZ2VkLCBvdGhlciB0aHJlYWRzCisJICog
d2lsbCB0cnkgdG8gYWNxdWlyZSBsb2NrIGZvciBuZXcgY3B1LiBBbmQgcG9saWN5IGlzIGFscmVh
ZHkgdXBkYXRlZAorCSAqIGJ5IHRoZW4uCisJICovCisJZG93bl93cml0ZSgmcGVyX2NwdShjcHVf
cG9saWN5X3J3c2VtLCBwb2xpY3ktPmNwdSkpOworCiAJcG9saWN5LT5sYXN0X2NwdSA9IHBvbGlj
eS0+Y3B1OwogCXBvbGljeS0+Y3B1ID0gY3B1OwogCisJdXBfd3JpdGUoJnBlcl9jcHUoY3B1X3Bv
bGljeV9yd3NlbSwgcG9saWN5LT5sYXN0X2NwdSkpOworCiAjaWZkZWYgQ09ORklHX0NQVV9GUkVR
X1RBQkxFCiAJY3B1ZnJlcV9mcmVxdWVuY3lfdGFibGVfdXBkYXRlX3BvbGljeV9jcHUocG9saWN5
KTsKICNlbmRpZgpAQCAtMTIwMyw5ICsxMjE0LDcgQEAgc3RhdGljIGludCBfX2NwdWZyZXFfcmVt
b3ZlX2Rldl9wcmVwYXJlKHN0cnVjdCBkZXZpY2UgKmRldiwKIAogCQluZXdfY3B1ID0gY3B1ZnJl
cV9ub21pbmF0ZV9uZXdfcG9saWN5X2NwdShwb2xpY3ksIGNwdSwgZnJvemVuKTsKIAkJaWYgKG5l
d19jcHUgPj0gMCkgewotCQkJV0FSTl9PTihsb2NrX3BvbGljeV9yd3NlbV93cml0ZShjcHUpKTsK
IAkJCXVwZGF0ZV9wb2xpY3lfY3B1KHBvbGljeSwgbmV3X2NwdSk7Ci0JCQl1bmxvY2tfcG9saWN5
X3J3c2VtX3dyaXRlKGNwdSk7CiAKIAkJCWlmICghZnJvemVuKSB7CiAJCQkJcHJfZGVidWcoIiVz
OiBwb2xpY3kgS29iamVjdCBtb3ZlZCB0byBjcHU6ICVkICIKLS0gCjEuNy4xMi5yYzIuMTguZzYx
YjQ3MmUKCg==
--089e0149d0ae648b2204e6833f43--
