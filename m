Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab3EIHPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 03:15:04 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:43166 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3EIHPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 03:15:02 -0400
MIME-Version: 1.0
In-Reply-To: <518A324A.8000000@linaro.org>
References: <CAJFUiJiMMAgLGF3tiG1V59dx+KOpTBCEL3ctHUosjMDkBagbJg@mail.gmail.com>
 <518A324A.8000000@linaro.org>
From: Lianwei Wang <lianwei.wang@gmail.com>
Date: Thu, 9 May 2013 15:14:41 +0800
Message-ID: <CAJFUiJio8jHtGwGo=-FSm6_E9LATSkyUx_iWsuFddmA9+PXCJA@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH] cpuidle: don't wakeup processor when set a
 longer latency
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Content-Type: multipart/mixed; boundary=089e0149ca961104d704dc43cf41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0149ca961104d704dc43cf41
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thank you very much. I have a quick updated patch based on your comments.

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 2f0083a..cd1af4b 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -18,6 +18,7 @@
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
 #include <linux/module.h>
+#include <linux/tick.h>
 #include <trace/events/power.h>

 #include "cpuidle.h"
@@ -466,7 +467,20 @@ static void smp_callback(void *v)
 static int cpuidle_latency_notify(struct notifier_block *b,
                unsigned long l, void *v)
 {
-       smp_call_function(smp_callback, NULL, 1);
+       int cpu, rcpu =3D smp_processor_id();
+       s64 s;
+       struct tick_device *td;
+
+       for_each_online_cpu(cpu) {
+               if (cpu =3D=3D rcpu)
+                       continue;
+               td =3D tick_get_device(cpu);
+               s =3D ktime_us_delta(td->evtdev->next_event, ktime_get());
+               if ((long)l < (long)s) {
+                       smp_call_function_single(cpu, smp_callback, NULL, 1=
);
+               }
+       }
+
        return NOTIFY_OK;
 }

Thanks,
Lianwei

2013/5/8 Daniel Lezcano <daniel.lezcano@linaro.org>:
> On 05/08/2013 04:44 AM, Lianwei Wang wrote:
>> When a PM-Qos is updated, the cpuidle driver will wakeup all the CPUs
>> no matter what a latency is set. But actually it only need to wakeup
>> the CPUs when a shorter latency is set. In this way we can reduce the
>> cpu wakeup count and save battery.
>
> I am curious, how many times could the pm_qos be changed in a system
> live cycle to measure an improvement with this patch ?
>
> Do you have a scenario where you measured a noticeable power saving ?
>
The PM-Qos is not updated most of time, especially for home idle case.
 But for some specific case, the PM-Qos may update too frequently.
(E.g. my measurement show that it is changed frequently between
2us/3us/200us/200s for bootup and usb case.) The battery current drain
is measured from PMIC or battery eliminator. Although this is just a
little saving, it is still reasonable to improve it.

>> So we can pass the prev_value to the notifier callback and check the
>> latency curr_value and prev_value in the cpuidle latency notifier
>> callback. It modify a common interface(dummy --> prev_value) but shall
>> be safe since no one use the dummy parameter currently.
>>
>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>> index e1f6860..1e1758c 100644
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@ -498,7 +498,11 @@ static void smp_callback(void *v)
>>  static int cpuidle_latency_notify(struct notifier_block *b,
>>                 unsigned long l, void *v)
>>  {
>> -       smp_call_function(smp_callback, NULL, 1);
>> +       unsigned long prev_value =3D (unsigned long) v;
>> +
>> +       /* Dont't waktup processor when set a longer latency */
>
>                     ^^^^^^
>                     wakeup
>
> Instead of passing prev and curr, using the dummy variable, why don't
> you pass the result of (curr - prev) ?
>
> A negative value means, the latency is smaller and positive is bigger.
>
> Also, may be the optimization could be more improved: if the latency is
> bigger than the next wakeup event, it is not necessary to wakeup the cpus=
.
>
This is good idea. So it need to check the next_event on each CPU and
wakeup the cpu if the requested latency is smaller than it. A quick
patch is attached.

>> +       if (l < prev_value)
>> +               smp_call_function(smp_callback, NULL, 1);
>>         return NOTIFY_OK;
>>  }
>>
>> diff --git a/kernel/power/qos.c b/kernel/power/qos.c
>> index 9322ff7..533b8bc 100644
>> --- a/kernel/power/qos.c
>> +++ b/kernel/power/qos.c
>> @@ -205,7 +205,7 @@ int pm_qos_update_target(struct pm_qos_constraints
>> *c, struct plist_node *node,
>>         if (prev_value !=3D curr_value) {
>>                 blocking_notifier_call_chain(c->notifiers,
>>                                              (unsigned long)curr_value,
>> -                                            NULL);
>> +                                            (void *)prev_value);
>>                 return 1;
>>         } else {
>>                 return 0;
>>
>
>
> --
>  <http://www.linaro.org/> Linaro.org =E2=94=82 Open source software for A=
RM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>

--089e0149ca961104d704dc43cf41
Content-Type: application/octet-stream; 
	name="0001-cpuidle-wakeup-processor-on-a-smaller-latency.patch"
Content-Disposition: attachment; 
	filename="0001-cpuidle-wakeup-processor-on-a-smaller-latency.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hghl8w470

RnJvbSAwN2EzZjMyOTM0MDk3NWEzZjNlODMwZDM0M2Y3YTJjNmU4M2E0NDFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaWFud2VpIFdhbmcgPGxpYW53ZWkud2FuZ0BnbWFpbC5jb20+
CkRhdGU6IEZyaSwgMjYgQXByIDIwMTMgMTA6NTk6MjQgKzA4MDAKU3ViamVjdDogW1BBVENIXSBj
cHVpZGxlOiB3YWtldXAgcHJvY2Vzc29yIG9uIGEgc21hbGxlciBsYXRlbmN5CgpDaGVja2luZyB0
aGUgUE0tUW9zIGxhdGVuY3kgYW5kIGNwdSBpZGxlIHNsZWVwIGxhdGVuY3ksIGFuZCBvbmx5Cndh
a2V1cCB0aGUgY3B1IGlmIHRoZSByZXF1ZXN0ZWQgUE0tUW9zIGxhdGVuY3kgaXMgc21hbGxlciB0
aGFuIGl0cwppZGxlIHNsZWVwIGxhdGVuY3kuCgpDaGFuZ2UtSWQ6IElmNTY0ZmQwZDljNTNjZjEw
MGJkODUyNDdiZmQ1MDlkZmVhZjU0YzEzClNpZ25lZC1vZmYtYnk6IExpYW53ZWkgV2FuZyA8bGlh
bndlaS53YW5nQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL2NwdWlkbGUvY3B1aWRsZS5jIHwgICAx
NiArKysrKysrKysrKysrKystCiAxIGZpbGVzIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVpZGxlL2NwdWlkbGUuYyBiL2Ry
aXZlcnMvY3B1aWRsZS9jcHVpZGxlLmMKaW5kZXggMmYwMDgzYS4uY2QxYWY0YiAxMDA2NDQKLS0t
IGEvZHJpdmVycy9jcHVpZGxlL2NwdWlkbGUuYworKysgYi9kcml2ZXJzL2NwdWlkbGUvY3B1aWRs
ZS5jCkBAIC0xOCw2ICsxOCw3IEBACiAjaW5jbHVkZSA8bGludXgva3RpbWUuaD4KICNpbmNsdWRl
IDxsaW51eC9ocnRpbWVyLmg+CiAjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CisjaW5jbHVkZSA8
bGludXgvdGljay5oPgogI2luY2x1ZGUgPHRyYWNlL2V2ZW50cy9wb3dlci5oPgogCiAjaW5jbHVk
ZSAiY3B1aWRsZS5oIgpAQCAtNDY2LDcgKzQ2NywyMCBAQCBzdGF0aWMgdm9pZCBzbXBfY2FsbGJh
Y2sodm9pZCAqdikKIHN0YXRpYyBpbnQgY3B1aWRsZV9sYXRlbmN5X25vdGlmeShzdHJ1Y3Qgbm90
aWZpZXJfYmxvY2sgKmIsCiAJCXVuc2lnbmVkIGxvbmcgbCwgdm9pZCAqdikKIHsKLQlzbXBfY2Fs
bF9mdW5jdGlvbihzbXBfY2FsbGJhY2ssIE5VTEwsIDEpOworCWludCBjcHUsIHJjcHUgPSBzbXBf
cHJvY2Vzc29yX2lkKCk7CisJczY0IHM7CisJc3RydWN0IHRpY2tfZGV2aWNlICp0ZDsKKworCWZv
cl9lYWNoX29ubGluZV9jcHUoY3B1KSB7CisJCWlmIChjcHUgPT0gcmNwdSkKKwkJCWNvbnRpbnVl
OworCQl0ZCA9IHRpY2tfZ2V0X2RldmljZShjcHUpOworCQlzID0ga3RpbWVfdXNfZGVsdGEodGQt
PmV2dGRldi0+bmV4dF9ldmVudCwga3RpbWVfZ2V0KCkpOworCQlpZiAoKGxvbmcpbCA8IChsb25n
KXMpIHsKKwkJCXNtcF9jYWxsX2Z1bmN0aW9uX3NpbmdsZShjcHUsIHNtcF9jYWxsYmFjaywgTlVM
TCwgMSk7CisJCX0KKwl9CisKIAlyZXR1cm4gTk9USUZZX09LOwogfQogCi0tIAoxLjcuNC4xCgo=
--089e0149ca961104d704dc43cf41--
