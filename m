Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3EMHqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:46:45 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:65031 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab3EMHqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:46:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAJFUiJjLUvpO5t+LT32hmaER1QX06wpK8a+Rr4GSB-Xikh=O7w@mail.gmail.com>
References: <CAJFUiJiMMAgLGF3tiG1V59dx+KOpTBCEL3ctHUosjMDkBagbJg@mail.gmail.com>
 <518A324A.8000000@linaro.org> <CAJFUiJio8jHtGwGo=-FSm6_E9LATSkyUx_iWsuFddmA9+PXCJA@mail.gmail.com>
 <518C3502.2040306@linaro.org> <CAJFUiJjLUvpO5t+LT32hmaER1QX06wpK8a+Rr4GSB-Xikh=O7w@mail.gmail.com>
From: Lianwei Wang <lianwei.wang@gmail.com>
Date: Mon, 13 May 2013 15:46:22 +0800
Message-ID: <CAJFUiJh+=AuR_9OUfiRbEKrnDDgRc=Twv=+uMu6B0CRUYmqV-A@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH] cpuidle: don't wakeup processor when set a
 longer latency
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Content-Type: multipart/mixed; boundary=089e01161b48be6dab04dc94b77e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01161b48be6dab04dc94b77e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

smp_call_function_single may not good for quad or more cores because
it just send one interrupt one time and wait there...
Update the patch to wakeup the cpus at the same time by calling
smp_call_function_many.

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 2f0083a..e1f618f 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -18,6 +18,7 @@
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
 #include <linux/module.h>
+#include <linux/tick.h>
 #include <trace/events/power.h>

 #include "cpuidle.h"
@@ -462,11 +463,34 @@ static void smp_callback(void *v)
  * requirement.  This means we need to get all processors out of their C-s=
tate,
  * and then recalculate a new suitable C-state. Just do a cross-cpu IPI; t=
hat
  * wakes them all right up.
+ * l - > latency in us
  */
 static int cpuidle_latency_notify(struct notifier_block *b,
                unsigned long l, void *v)
 {
-       smp_call_function(smp_callback, NULL, 1);
+       cpumask_var_t cpus;
+
+       if (!alloc_cpumask_var(&cpus, GFP_ATOMIC))
+               smp_call_function(smp_callback, NULL, 1);
+       else {
+               int cpu, rcpu =3D smp_processor_id();
+               s64 s; /* sleep_length in us */
+               struct tick_device *td;
+
+               for_each_online_cpu(cpu) {
+                       if (cpu =3D=3D rcpu)
+                               continue;
+                       td =3D tick_get_device(cpu);
+                       s =3D ktime_us_delta(td->evtdev->next_event, ktime_=
get());
+                       if ((long)l < (long)s)
+                               cpumask_set_cpu(cpu, cpus);
+               }
+               preempt_disable();
+               smp_call_function_many(cpus, smp_callback, NULL, 1);
+               preempt_enable();
+               free_cpumask_var(cpus);
+       }
+
        return NOTIFY_OK;
 }

2013/5/13 Lianwei Wang <lianwei.wang@gmail.com>:
> Thank you. Patch is updated.
>
> From 2d0b4afb5461847dcdf08a87b02015d061b12e85 Mon Sep 17 00:00:00 2001
> From: Lianwei Wang <lianwei.wang@gmail.com>
> Date: Fri, 26 Apr 2013 10:59:24 +0800
> Subject: [PATCH] cpuidle: wakeup processor on a smaller latency
>
> Checking the PM-Qos latency and cpu idle sleep latency, and only
> wakeup the cpu if the requested PM-Qos latency is smaller than its
> idle sleep latency. This can reduce at least 50% cpu wakeup count
> on PM-Qos updated.
>
> The PM-Qos is not updated most of time, especially for home idle
> case. But for some specific case, the PM-Qos may be updated too
> frequently. (E.g. my measurement show that it is changed frequently
> between 2us/3us/200us/200s for bootup and usb case.)
>
> The battery current drain is measured from PMIC or battery eliminator.
> Although this is just a little saving, it is still reasonable to
> improve it.
>
> Change-Id: If564fd0d9c53cf100bd85247bfd509dfeaf54c13
> Signed-off-by: Lianwei Wang <lianwei.wang@gmail.com>
> ---
>  drivers/cpuidle/cpuidle.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 2f0083a..a0829ad 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -18,6 +18,7 @@
>  #include <linux/ktime.h>
>  #include <linux/hrtimer.h>
>  #include <linux/module.h>
> +#include <linux/tick.h>
>  #include <trace/events/power.h>
>
>  #include "cpuidle.h"
> @@ -462,11 +463,25 @@ static void smp_callback(void *v)
>   * requirement.  This means we need to get all processors out of their C=
-state,
>   * and then recalculate a new suitable C-state. Just do a cross-cpu IPI;=
 that
>   * wakes them all right up.
> + * l - > latency in us
>   */
>  static int cpuidle_latency_notify(struct notifier_block *b,
>                 unsigned long l, void *v)
>  {
> -       smp_call_function(smp_callback, NULL, 1);
> +       int cpu, rcpu =3D smp_processor_id();
> +       s64 s; /* sleep_length in us */
> +       struct tick_device *td;
> +
> +       for_each_online_cpu(cpu) {
> +               if (cpu =3D=3D rcpu)
> +                       continue;
> +               td =3D tick_get_device(cpu);
> +               s =3D ktime_us_delta(td->evtdev->next_event, ktime_get())=
;
> +               if ((long)l < (long)s) {
> +                       smp_call_function_single(cpu, smp_callback, NULL,=
 1);
> +               }
> +       }
> +
>         return NOTIFY_OK;
>  }
>
> --
> 1.7.4.1
>
> 2013/5/10 Daniel Lezcano <daniel.lezcano@linaro.org>:
>> On 05/09/2013 09:14 AM, Lianwei Wang wrote:
>>> Thank you very much. I have a quick updated patch based on your comment=
s.
>>>
>>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>>> index 2f0083a..cd1af4b 100644
>>> --- a/drivers/cpuidle/cpuidle.c
>>> +++ b/drivers/cpuidle/cpuidle.c
>>> @@ -18,6 +18,7 @@
>>>  #include <linux/ktime.h>
>>>  #include <linux/hrtimer.h>
>>>  #include <linux/module.h>
>>> +#include <linux/tick.h>
>>>  #include <trace/events/power.h>
>>>
>>>  #include "cpuidle.h"
>>> @@ -466,7 +467,20 @@ static void smp_callback(void *v)
>>>  static int cpuidle_latency_notify(struct notifier_block *b,
>>>                 unsigned long l, void *v)
>>>  {
>>> -       smp_call_function(smp_callback, NULL, 1);
>>> +       int cpu, rcpu =3D smp_processor_id();
>>> +       s64 s;
>>> +       struct tick_device *td;
>>> +
>>> +       for_each_online_cpu(cpu) {
>>> +               if (cpu =3D=3D rcpu)
>>> +                       continue;
>>> +               td =3D tick_get_device(cpu);
>>> +               s =3D ktime_us_delta(td->evtdev->next_event, ktime_get(=
));
>>> +               if ((long)l < (long)s) {
>>> +                       smp_call_function_single(cpu, smp_callback, NUL=
L, 1);
>>> +               }
>>> +       }
>>> +
>>>         return NOTIFY_OK;
>>>  }
>>
>> The patch sounds reasonable. A comment and explicit names for the
>> variables would be nice.
>>
>> eg.
>> l =3D> latency
>> s =3D> sleep
>>
>>> Thanks,
>>> Lianwei
>>>
>>> 2013/5/8 Daniel Lezcano <daniel.lezcano@linaro.org>:
>>>> On 05/08/2013 04:44 AM, Lianwei Wang wrote:
>>>>> When a PM-Qos is updated, the cpuidle driver will wakeup all the CPUs
>>>>> no matter what a latency is set. But actually it only need to wakeup
>>>>> the CPUs when a shorter latency is set. In this way we can reduce the
>>>>> cpu wakeup count and save battery.
>>>>
>>>> I am curious, how many times could the pm_qos be changed in a system
>>>> live cycle to measure an improvement with this patch ?
>>>>
>>>> Do you have a scenario where you measured a noticeable power saving ?
>>>>
>>> The PM-Qos is not updated most of time, especially for home idle case.
>>>  But for some specific case, the PM-Qos may update too frequently.
>>> (E.g. my measurement show that it is changed frequently between
>>> 2us/3us/200us/200s for bootup and usb case.) The battery current drain
>>> is measured from PMIC or battery eliminator. Although this is just a
>>> little saving, it is still reasonable to improve it.
>>
>> Thanks for the information. Can you add this information in the changelo=
g ?
>>
>>>>> So we can pass the prev_value to the notifier callback and check the
>>>>> latency curr_value and prev_value in the cpuidle latency notifier
>>>>> callback. It modify a common interface(dummy --> prev_value) but shal=
l
>>>>> be safe since no one use the dummy parameter currently.
>>>>>
>>>>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>>>>> index e1f6860..1e1758c 100644
>>>>> --- a/drivers/cpuidle/cpuidle.c
>>>>> +++ b/drivers/cpuidle/cpuidle.c
>>>>> @@ -498,7 +498,11 @@ static void smp_callback(void *v)
>>>>>  static int cpuidle_latency_notify(struct notifier_block *b,
>>>>>                 unsigned long l, void *v)
>>>>>  {
>>>>> -       smp_call_function(smp_callback, NULL, 1);
>>>>> +       unsigned long prev_value =3D (unsigned long) v;
>>>>> +
>>>>> +       /* Dont't waktup processor when set a longer latency */
>>>>
>>>>                     ^^^^^^
>>>>                     wakeup
>>>>
>>>> Instead of passing prev and curr, using the dummy variable, why don't
>>>> you pass the result of (curr - prev) ?
>>>>
>>>> A negative value means, the latency is smaller and positive is bigger.
>>>>
>>>> Also, may be the optimization could be more improved: if the latency i=
s
>>>> bigger than the next wakeup event, it is not necessary to wakeup the c=
pus.
>>>>
>>> This is good idea. So it need to check the next_event on each CPU and
>>> wakeup the cpu if the requested latency is smaller than it. A quick
>>> patch is attached.
>>
>> Yes, it sounds good.
>>
>>>>> +       if (l < prev_value)
>>>>> +               smp_call_function(smp_callback, NULL, 1);
>>>>>         return NOTIFY_OK;
>>>>>  }
>>>>>
>>>>> diff --git a/kernel/power/qos.c b/kernel/power/qos.c
>>>>> index 9322ff7..533b8bc 100644
>>>>> --- a/kernel/power/qos.c
>>>>> +++ b/kernel/power/qos.c
>>>>> @@ -205,7 +205,7 @@ int pm_qos_update_target(struct pm_qos_constraint=
s
>>>>> *c, struct plist_node *node,
>>>>>         if (prev_value !=3D curr_value) {
>>>>>                 blocking_notifier_call_chain(c->notifiers,
>>>>>                                              (unsigned long)curr_valu=
e,
>>>>> -                                            NULL);
>>>>> +                                            (void *)prev_value);
>>>>>                 return 1;
>>>>>         } else {
>>>>>                 return 0;
>>>>>
>>>>
>>>>
>>>> --
>>>>  <http://www.linaro.org/> Linaro.org =E2=94=82 Open source software fo=
r ARM SoCs
>>>>
>>>> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
>>>> <http://twitter.com/#!/linaroorg> Twitter |
>>>> <http://www.linaro.org/linaro-blog/> Blog
>>>>
>>
>>
>> --
>>  <http://www.linaro.org/> Linaro.org =E2=94=82 Open source software for =
ARM SoCs
>>
>> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
>> <http://twitter.com/#!/linaroorg> Twitter |
>> <http://www.linaro.org/linaro-blog/> Blog
>>

--089e01161b48be6dab04dc94b77e
Content-Type: application/octet-stream; 
	name="0001-cpuidle-wakeup-processor-on-a-smaller-latency.patch"
Content-Disposition: attachment; 
	filename="0001-cpuidle-wakeup-processor-on-a-smaller-latency.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hgnc88gb1

RnJvbSAzMGMyNjM5MzQ2YTNmYWIyZGYzZWFjN2RlZDM3NDA0ZDgxODgwMmU0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaWFud2VpIFdhbmcgPGxpYW53ZWkud2FuZ0BnbWFpbC5jb20+
CkRhdGU6IEZyaSwgMjYgQXByIDIwMTMgMTA6NTk6MjQgKzA4MDAKU3ViamVjdDogW1BBVENIXSBj
cHVpZGxlOiB3YWtldXAgcHJvY2Vzc29yIG9uIGEgc21hbGxlciBsYXRlbmN5CgpDaGVja2luZyB0
aGUgUE0tUW9zIGxhdGVuY3kgYW5kIGNwdSBpZGxlIHNsZWVwIGxhdGVuY3ksIGFuZCBvbmx5Cndh
a2V1cCB0aGUgY3B1IGlmIHRoZSByZXF1ZXN0ZWQgUE0tUW9zIGxhdGVuY3kgaXMgc21hbGxlciB0
aGFuIGl0cwppZGxlIHNsZWVwIGxhdGVuY3kuIFRoaXMgY2FuIHJlZHVjZSBhdCBsZWFzdCA1MCUg
Y3B1IHdha2V1cCBjb3VudApvbiBQTS1Rb3MgdXBkYXRlZC4KClRoZSBQTS1Rb3MgaXMgbm90IHVw
ZGF0ZWQgbW9zdCBvZiB0aW1lLCBlc3BlY2lhbGx5IGZvciBob21lIGlkbGUKY2FzZS4gQnV0IGZv
ciBzb21lIHNwZWNpZmljIGNhc2UsIHRoZSBQTS1Rb3MgbWF5IGJlIHVwZGF0ZWQgdG9vCmZyZXF1
ZW50bHkuIChFLmcuIG15IG1lYXN1cmVtZW50IHNob3cgdGhhdCBpdCBpcyBjaGFuZ2VkIGZyZXF1
ZW50bHkKYmV0d2VlbiAydXMvM3VzLzIwMHVzLzIwMHMgZm9yIGJvb3R1cCBhbmQgdXNiIGNhc2Uu
KQoKVGhlIGJhdHRlcnkgY3VycmVudCBkcmFpbiBpcyBtZWFzdXJlZCBmcm9tIFBNSUMgb3IgYmF0
dGVyeSBlbGltaW5hdG9yLgpBbHRob3VnaCB0aGlzIGlzIGp1c3QgYSBsaXR0bGUgc2F2aW5nLCBp
dCBpcyBzdGlsbCByZWFzb25hYmxlIHRvCmltcHJvdmUgaXQuCgpDaGFuZ2UtSWQ6IElmNTY0ZmQw
ZDljNTNjZjEwMGJkODUyNDdiZmQ1MDlkZmVhZjU0YzEzClNpZ25lZC1vZmYtYnk6IExpYW53ZWkg
V2FuZyA8bGlhbndlaS53YW5nQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL2NwdWlkbGUvY3B1aWRs
ZS5jIHwgICAyNiArKysrKysrKysrKysrKysrKysrKysrKysrLQogMSBmaWxlcyBjaGFuZ2VkLCAy
NSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1
aWRsZS9jcHVpZGxlLmMgYi9kcml2ZXJzL2NwdWlkbGUvY3B1aWRsZS5jCmluZGV4IDJmMDA4M2Eu
LmUxZjYxOGYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1aWRsZS9jcHVpZGxlLmMKKysrIGIvZHJp
dmVycy9jcHVpZGxlL2NwdWlkbGUuYwpAQCAtMTgsNiArMTgsNyBAQAogI2luY2x1ZGUgPGxpbnV4
L2t0aW1lLmg+CiAjaW5jbHVkZSA8bGludXgvaHJ0aW1lci5oPgogI2luY2x1ZGUgPGxpbnV4L21v
ZHVsZS5oPgorI2luY2x1ZGUgPGxpbnV4L3RpY2suaD4KICNpbmNsdWRlIDx0cmFjZS9ldmVudHMv
cG93ZXIuaD4KIAogI2luY2x1ZGUgImNwdWlkbGUuaCIKQEAgLTQ2MiwxMSArNDYzLDM0IEBAIHN0
YXRpYyB2b2lkIHNtcF9jYWxsYmFjayh2b2lkICp2KQogICogcmVxdWlyZW1lbnQuICBUaGlzIG1l
YW5zIHdlIG5lZWQgdG8gZ2V0IGFsbCBwcm9jZXNzb3JzIG91dCBvZiB0aGVpciBDLXN0YXRlLAog
ICogYW5kIHRoZW4gcmVjYWxjdWxhdGUgYSBuZXcgc3VpdGFibGUgQy1zdGF0ZS4gSnVzdCBkbyBh
IGNyb3NzLWNwdSBJUEk7IHRoYXQKICAqIHdha2VzIHRoZW0gYWxsIHJpZ2h0IHVwLgorICogbCAt
ID4gbGF0ZW5jeSBpbiB1cwogICovCiBzdGF0aWMgaW50IGNwdWlkbGVfbGF0ZW5jeV9ub3RpZnko
c3RydWN0IG5vdGlmaWVyX2Jsb2NrICpiLAogCQl1bnNpZ25lZCBsb25nIGwsIHZvaWQgKnYpCiB7
Ci0Jc21wX2NhbGxfZnVuY3Rpb24oc21wX2NhbGxiYWNrLCBOVUxMLCAxKTsKKwljcHVtYXNrX3Zh
cl90IGNwdXM7CisKKwlpZiAoIWFsbG9jX2NwdW1hc2tfdmFyKCZjcHVzLCBHRlBfQVRPTUlDKSkK
KwkJc21wX2NhbGxfZnVuY3Rpb24oc21wX2NhbGxiYWNrLCBOVUxMLCAxKTsKKwllbHNlIHsKKwkJ
aW50IGNwdSwgcmNwdSA9IHNtcF9wcm9jZXNzb3JfaWQoKTsKKwkJczY0IHM7IC8qIHNsZWVwX2xl
bmd0aCBpbiB1cyAqLworCQlzdHJ1Y3QgdGlja19kZXZpY2UgKnRkOworCisJCWZvcl9lYWNoX29u
bGluZV9jcHUoY3B1KSB7CisJCQlpZiAoY3B1ID09IHJjcHUpCisJCQkJY29udGludWU7CisJCQl0
ZCA9IHRpY2tfZ2V0X2RldmljZShjcHUpOworCQkJcyA9IGt0aW1lX3VzX2RlbHRhKHRkLT5ldnRk
ZXYtPm5leHRfZXZlbnQsIGt0aW1lX2dldCgpKTsKKwkJCWlmICgobG9uZylsIDwgKGxvbmcpcykK
KwkJCQljcHVtYXNrX3NldF9jcHUoY3B1LCBjcHVzKTsKKwkJfQorCQlwcmVlbXB0X2Rpc2FibGUo
KTsKKwkJc21wX2NhbGxfZnVuY3Rpb25fbWFueShjcHVzLCBzbXBfY2FsbGJhY2ssIE5VTEwsIDEp
OworCQlwcmVlbXB0X2VuYWJsZSgpOworCQlmcmVlX2NwdW1hc2tfdmFyKGNwdXMpOworCX0KKwog
CXJldHVybiBOT1RJRllfT0s7CiB9CiAKLS0gCjEuNy40LjEKCg==
--089e01161b48be6dab04dc94b77e--
