Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab3IAQAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 12:00:52 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64274 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab3IAQAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 12:00:50 -0400
MIME-Version: 1.0
In-Reply-To: <11222156.oKTjYXFZjG@vostro.rjw.lan>
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org>
	<80c4bd8c577e5da0aa63342671773be5cdc26a9a.1378012620.git.viresh.kumar@linaro.org>
	<11222156.oKTjYXFZjG@vostro.rjw.lan>
Date: Sun, 1 Sep 2013 21:30:49 +0530
Message-ID: <CAKohpon1VsoUnw=t0c9wQ2Zfva5nnXoKjNNNxLXV7Frto1BFug@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11c309e83fe48804e5548ff3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c309e83fe48804e5548ff3
Content-Type: text/plain; charset=ISO-8859-1

On 1 September 2013 18:58, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, September 01, 2013 10:56:02 AM Viresh Kumar wrote:
>> We can't take a big lock around __cpufreq_governor() as this causes recursive
>> locking for some cases. But calls to this routine must be serialized for every
>> policy.
>
> Care to explain here why it must be serialized?

Yes, added that to the attached patches (Added reported-by too):

commit dc51771506b113b998c49c3be2db0fb88bb92153
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Sat Aug 31 17:48:23 2013 +0530

    cpufreq: serialize calls to __cpufreq_governor()

    We can't take a big lock around __cpufreq_governor() as this
causes recursive
    locking for some cases. But calls to this routine must be
serialized for every
    policy. Otherwise we can see some unpredictable events.

    For example, consider following scenario:

    __cpufreq_remove_dev()
     __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
       policy->governor->governor(policy, CPUFREQ_GOV_STOP);
        cpufreq_governor_dbs()
         case CPUFREQ_GOV_STOP:
          mutex_destroy(&cpu_cdbs->timer_mutex)
          cpu_cdbs->cur_policy = NULL;
      <PREEMPT>
    store()
     __cpufreq_set_policy()
      __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
        policy->governor->governor(policy, CPUFREQ_GOV_LIMITS);
         case CPUFREQ_GOV_LIMITS:
          mutex_lock(&cpu_cdbs->timer_mutex); <-- Warning (destroyed mutex)
           if (policy->max < cpu_cdbs->cur_policy->cur) <- cur_policy == NULL

    And so store() will eventually result in a crash cur_policy is already NULL;

    Lets introduce another variable which would guarantee serialization here.

   Reported-by: Stephen Boyd <sboyd@codeaurora.org>
   Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

>> Lets introduce another variable which would guarantee serialization here.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  drivers/cpufreq/cpufreq.c | 7 ++++++-
>>  include/linux/cpufreq.h   | 1 +
>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index f320a20..4d5723db 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1692,13 +1692,15 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>>                                               policy->cpu, event);
>>
>>       mutex_lock(&cpufreq_governor_lock);
>> -     if ((policy->governor_enabled && (event == CPUFREQ_GOV_START)) ||
>> +     if (policy->governor_busy ||
>> +             (policy->governor_enabled && (event == CPUFREQ_GOV_START)) ||
>
> Again, broken white space, but I can fix it up.

Sorry, what exactly.. Sorry couldn't understand it :(

--001a11c309e83fe48804e5548ff3
Content-Type: application/octet-stream; 
	name="0001-cpufreq-don-t-allow-governor-limits-to-be-changed-wh.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-don-t-allow-governor-limits-to-be-changed-wh.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hl2g4nxw0

RnJvbSAwODUwMTNmNGU1ODRlM2ZlZjk3MTg3YmNiMzQ5YzNmYTc2OTQyZTE5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8MDg1MDEzZjRlNTg0ZTNmZWY5NzE4N2JjYjM0OWMz
ZmE3Njk0MmUxOS4xMzc4MDUxMDE2LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogU2F0LCAzMSBBdWcg
MjAxMyAxNzo1Mzo0MCArMDUzMApTdWJqZWN0OiBbUEFUQ0ggMS8yXSBjcHVmcmVxOiBkb24ndCBh
bGxvdyBnb3Zlcm5vciBsaW1pdHMgdG8gYmUgY2hhbmdlZCB3aGVuCiBpdCBpcyBkaXNhYmxlZAoK
X19jcHVmcmVxX2dvdmVybm9yKCkgcmV0dXJucyB3aXRoIC1FQlVTWSB3aGVuIGdvdmVybm9yIGlz
IGFscmVhZHkgc3RvcHBlZCBhbmQgd2UKdHJ5IHRvIHN0b3AgaXQgYWdhaW4sIGJ1dCB3aGVuIGl0
IGlzIHN0b3BwZWQgd2UgbXVzdCBub3QgYWxsb3cgY2FsbHMgdG8KQ1BVRlJFUV9HT1ZfTElNSVRT
IGV2ZW50IGFzIHdlbGwuCgpUaGlzIHBhdGNoIGFkZHMgdGhpcyBjaGVjayBpbiBfX2NwdWZyZXFf
Z292ZXJub3IoKS4KClJlcG9ydGVkLWJ5OiBTdGVwaGVuIEJveWQgPHNib3lkQGNvZGVhdXJvcmEu
b3JnPgpTaWduZWQtb2ZmLWJ5OiBWaXJlc2ggS3VtYXIgPHZpcmVzaC5rdW1hckBsaW5hcm8ub3Jn
PgotLS0KIGRyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMgfCA1ICsrKy0tCiAxIGZpbGUgY2hhbmdl
ZCwgMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
Y3B1ZnJlcS9jcHVmcmVxLmMgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jCmluZGV4IDVjNzVl
MzEuLmYzMjBhMjAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMKKysrIGIv
ZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwpAQCAtMTY5Miw4ICsxNjkyLDkgQEAgc3RhdGljIGlu
dCBfX2NwdWZyZXFfZ292ZXJub3Ioc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksCiAJCQkJ
CQlwb2xpY3ktPmNwdSwgZXZlbnQpOwogCiAJbXV0ZXhfbG9jaygmY3B1ZnJlcV9nb3Zlcm5vcl9s
b2NrKTsKLQlpZiAoKCFwb2xpY3ktPmdvdmVybm9yX2VuYWJsZWQgJiYgKGV2ZW50ID09IENQVUZS
RVFfR09WX1NUT1ApKSB8fAotCSAgICAocG9saWN5LT5nb3Zlcm5vcl9lbmFibGVkICYmIChldmVu
dCA9PSBDUFVGUkVRX0dPVl9TVEFSVCkpKSB7CisJaWYgKChwb2xpY3ktPmdvdmVybm9yX2VuYWJs
ZWQgJiYgKGV2ZW50ID09IENQVUZSRVFfR09WX1NUQVJUKSkgfHwKKwkJKCFwb2xpY3ktPmdvdmVy
bm9yX2VuYWJsZWQgJiYgKChldmVudCA9PSBDUFVGUkVRX0dPVl9MSU1JVFMpIHx8CisJCQkJCSAg
ICAgICAoZXZlbnQgPT0gQ1BVRlJFUV9HT1ZfU1RPUCkpKSkgewogCQltdXRleF91bmxvY2soJmNw
dWZyZXFfZ292ZXJub3JfbG9jayk7CiAJCXJldHVybiAtRUJVU1k7CiAJfQotLSAKMS43LjEyLnJj
Mi4xOC5nNjFiNDcyZQoK
--001a11c309e83fe48804e5548ff3
Content-Type: application/octet-stream; 
	name="0002-cpufreq-serialize-calls-to-__cpufreq_governor.patch"
Content-Disposition: attachment; 
	filename="0002-cpufreq-serialize-calls-to-__cpufreq_governor.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hl2g4o301

RnJvbSBkYzUxNzcxNTA2YjExM2I5OThjNDljM2JlMmRiMGZiODhiYjkyMTUzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZGM1MTc3MTUwNmIxMTNiOTk4YzQ5YzNiZTJkYjBm
Yjg4YmI5MjE1My4xMzc4MDUxMDE2LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KSW4tUmVw
bHktVG86IDwwODUwMTNmNGU1ODRlM2ZlZjk3MTg3YmNiMzQ5YzNmYTc2OTQyZTE5LjEzNzgwNTEw
MTYuZ2l0LnZpcmVzaC5rdW1hckBsaW5hcm8ub3JnPgpSZWZlcmVuY2VzOiA8MDg1MDEzZjRlNTg0
ZTNmZWY5NzE4N2JjYjM0OWMzZmE3Njk0MmUxOS4xMzc4MDUxMDE2LmdpdC52aXJlc2gua3VtYXJA
bGluYXJvLm9yZz4KRnJvbTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4K
RGF0ZTogU2F0LCAzMSBBdWcgMjAxMyAxNzo0ODoyMyArMDUzMApTdWJqZWN0OiBbUEFUQ0ggMi8y
XSBjcHVmcmVxOiBzZXJpYWxpemUgY2FsbHMgdG8gX19jcHVmcmVxX2dvdmVybm9yKCkKCldlIGNh
bid0IHRha2UgYSBiaWcgbG9jayBhcm91bmQgX19jcHVmcmVxX2dvdmVybm9yKCkgYXMgdGhpcyBj
YXVzZXMgcmVjdXJzaXZlCmxvY2tpbmcgZm9yIHNvbWUgY2FzZXMuIEJ1dCBjYWxscyB0byB0aGlz
IHJvdXRpbmUgbXVzdCBiZSBzZXJpYWxpemVkIGZvciBldmVyeQpwb2xpY3kuIE90aGVyd2lzZSB3
ZSBjYW4gc2VlIHNvbWUgdW5wcmVkaWN0YWJsZSBldmVudHMuCgpGb3IgZXhhbXBsZSwgY29uc2lk
ZXIgZm9sbG93aW5nIHNjZW5hcmlvOgoKX19jcHVmcmVxX3JlbW92ZV9kZXYoKQogX19jcHVmcmVx
X2dvdmVybm9yKHBvbGljeSwgQ1BVRlJFUV9HT1ZfU1RPUCk7CiAgIHBvbGljeS0+Z292ZXJub3It
PmdvdmVybm9yKHBvbGljeSwgQ1BVRlJFUV9HT1ZfU1RPUCk7CiAgICBjcHVmcmVxX2dvdmVybm9y
X2RicygpCiAgICAgY2FzZSBDUFVGUkVRX0dPVl9TVE9QOgogICAgICBtdXRleF9kZXN0cm95KCZj
cHVfY2Ricy0+dGltZXJfbXV0ZXgpCiAgICAgIGNwdV9jZGJzLT5jdXJfcG9saWN5ID0gTlVMTDsK
ICA8UFJFRU1QVD4Kc3RvcmUoKQogX19jcHVmcmVxX3NldF9wb2xpY3koKQogIF9fY3B1ZnJlcV9n
b3Zlcm5vcihwb2xpY3ksIENQVUZSRVFfR09WX0xJTUlUUyk7CiAgICBwb2xpY3ktPmdvdmVybm9y
LT5nb3Zlcm5vcihwb2xpY3ksIENQVUZSRVFfR09WX0xJTUlUUyk7CiAgICAgY2FzZSBDUFVGUkVR
X0dPVl9MSU1JVFM6CiAgICAgIG11dGV4X2xvY2soJmNwdV9jZGJzLT50aW1lcl9tdXRleCk7IDwt
LSBXYXJuaW5nIChkZXN0cm95ZWQgbXV0ZXgpCiAgICAgICBpZiAocG9saWN5LT5tYXggPCBjcHVf
Y2Ricy0+Y3VyX3BvbGljeS0+Y3VyKSA8LSBjdXJfcG9saWN5ID09IE5VTEwKCkFuZCBzbyBzdG9y
ZSgpIHdpbGwgZXZlbnR1YWxseSByZXN1bHQgaW4gYSBjcmFzaCBjdXJfcG9saWN5IGlzIGFscmVh
ZHkgTlVMTDsKCkxldHMgaW50cm9kdWNlIGFub3RoZXIgdmFyaWFibGUgd2hpY2ggd291bGQgZ3Vh
cmFudGVlIHNlcmlhbGl6YXRpb24gaGVyZS4KClJlcG9ydGVkLWJ5OiBTdGVwaGVuIEJveWQgPHNi
b3lkQGNvZGVhdXJvcmEub3JnPgpTaWduZWQtb2ZmLWJ5OiBWaXJlc2ggS3VtYXIgPHZpcmVzaC5r
dW1hckBsaW5hcm8ub3JnPgotLS0KIGRyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMgfCA3ICsrKysr
Ky0KIGluY2x1ZGUvbGludXgvY3B1ZnJlcS5oICAgfCAxICsKIDIgZmlsZXMgY2hhbmdlZCwgNyBp
bnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVmcmVx
L2NwdWZyZXEuYyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMKaW5kZXggZjMyMGEyMC4uNGQ1
NzIzZGIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMKKysrIGIvZHJpdmVy
cy9jcHVmcmVxL2NwdWZyZXEuYwpAQCAtMTY5MiwxMyArMTY5MiwxNSBAQCBzdGF0aWMgaW50IF9f
Y3B1ZnJlcV9nb3Zlcm5vcihzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKIAkJCQkJCXBv
bGljeS0+Y3B1LCBldmVudCk7CiAKIAltdXRleF9sb2NrKCZjcHVmcmVxX2dvdmVybm9yX2xvY2sp
OwotCWlmICgocG9saWN5LT5nb3Zlcm5vcl9lbmFibGVkICYmIChldmVudCA9PSBDUFVGUkVRX0dP
Vl9TVEFSVCkpIHx8CisJaWYgKHBvbGljeS0+Z292ZXJub3JfYnVzeSB8fAorCQkocG9saWN5LT5n
b3Zlcm5vcl9lbmFibGVkICYmIChldmVudCA9PSBDUFVGUkVRX0dPVl9TVEFSVCkpIHx8CiAJCSgh
cG9saWN5LT5nb3Zlcm5vcl9lbmFibGVkICYmICgoZXZlbnQgPT0gQ1BVRlJFUV9HT1ZfTElNSVRT
KSB8fAogCQkJCQkgICAgICAgKGV2ZW50ID09IENQVUZSRVFfR09WX1NUT1ApKSkpIHsKIAkJbXV0
ZXhfdW5sb2NrKCZjcHVmcmVxX2dvdmVybm9yX2xvY2spOwogCQlyZXR1cm4gLUVCVVNZOwogCX0K
IAorCXBvbGljeS0+Z292ZXJub3JfYnVzeSA9IHRydWU7CiAJaWYgKGV2ZW50ID09IENQVUZSRVFf
R09WX1NUT1ApCiAJCXBvbGljeS0+Z292ZXJub3JfZW5hYmxlZCA9IGZhbHNlOwogCWVsc2UgaWYg
KGV2ZW50ID09IENQVUZSRVFfR09WX1NUQVJUKQpAQCAtMTcyNyw2ICsxNzI5LDkgQEAgc3RhdGlj
IGludCBfX2NwdWZyZXFfZ292ZXJub3Ioc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksCiAJ
CQkoKGV2ZW50ID09IENQVUZSRVFfR09WX1BPTElDWV9FWElUKSAmJiAhcmV0KSkKIAkJbW9kdWxl
X3B1dChwb2xpY3ktPmdvdmVybm9yLT5vd25lcik7CiAKKwltdXRleF9sb2NrKCZjcHVmcmVxX2dv
dmVybm9yX2xvY2spOworCXBvbGljeS0+Z292ZXJub3JfYnVzeSA9IGZhbHNlOworCW11dGV4X3Vu
bG9jaygmY3B1ZnJlcV9nb3Zlcm5vcl9sb2NrKTsKIAlyZXR1cm4gcmV0OwogfQogCmRpZmYgLS1n
aXQgYS9pbmNsdWRlL2xpbnV4L2NwdWZyZXEuaCBiL2luY2x1ZGUvbGludXgvY3B1ZnJlcS5oCmlu
ZGV4IGQ1NjhmMzkuLmNjYTg4NWQgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvY3B1ZnJlcS5o
CisrKyBiL2luY2x1ZGUvbGludXgvY3B1ZnJlcS5oCkBAIC03Niw2ICs3Niw3IEBAIHN0cnVjdCBj
cHVmcmVxX3BvbGljeSB7CiAJc3RydWN0IGNwdWZyZXFfZ292ZXJub3IJKmdvdmVybm9yOyAvKiBz
ZWUgYmVsb3cgKi8KIAl2b2lkCQkJKmdvdmVybm9yX2RhdGE7CiAJYm9vbAkJCWdvdmVybm9yX2Vu
YWJsZWQ7IC8qIGdvdmVybm9yIHN0YXJ0L3N0b3AgZmxhZyAqLworCWJvb2wJCQlnb3Zlcm5vcl9i
dXN5OwogCiAJc3RydWN0IHdvcmtfc3RydWN0CXVwZGF0ZTsgLyogaWYgdXBkYXRlX3BvbGljeSgp
IG5lZWRzIHRvIGJlCiAJCQkJCSAqIGNhbGxlZCwgYnV0IHlvdSdyZSBpbiBJUlEgY29udGV4dCAq
LwotLSAKMS43LjEyLnJjMi4xOC5nNjFiNDcyZQoK
--001a11c309e83fe48804e5548ff3--
