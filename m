Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab3KLGEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 01:04:11 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:60245 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3KLGEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 01:04:01 -0500
MIME-Version: 1.0
In-Reply-To: <1382638087-32054-1-git-send-email-nm@ti.com>
References: <1382638087-32054-1-git-send-email-nm@ti.com>
Date: Tue, 12 Nov 2013 11:33:59 +0530
Message-ID: <CAKohponJOOfGX4BHn76LTBDTm58+2QxPf_rv1i4avVfrWhfkRg@mail.gmail.com>
Subject: Re: [RFC PATCH] cpufreq: cpufreq-cpu0: do not allow transitions with
 regulators suspended
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: multipart/mixed; boundary=e89a8ff1c01c5d64de04eaf49d30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8ff1c01c5d64de04eaf49d30
Content-Type: text/plain; charset=ISO-8859-1

Cc'ing Shawn as well.

Sorry for being really late.. I just forgot about it :(

On 24 October 2013 23:38, Nishanth Menon <nm@ti.com> wrote:
> For platforms where regulators are used, regulator access tends to be
> disabled as part of the suspend path. In SMP systems such as OMAP,
> CPU1 is disabled as post suspend_noirq. This results in the following
> tail end sequence of actions:
> cpufreq_cpu_callback gets called with CPU_POST_DEAD
>         __cpufreq_remove_dev_finish is invoked as a result
>                 __cpufreq_governor(policy, CPUFREQ_GOV_START) is
>                 triggered
>
> At this point, with ondemand governor, if the cpu entered suspend path
> at a lower OPP, this triggers a transition request. However, since
> irqs are disabled, typically, regulator control using I2C operations
> are not possible either, regulator operations will naturally fail
> (even though clk_set_rate might succeed depending on the platform).
>
> Unfortunately, cpufreq_driver->suspend|resume is too late as well, since
> they are invoked as part of syscore_ops (after CPU1 is hotplugged out).
>
> The proposal here is to use pm notifier suspend to disable any
> requests to target, as we may very well expect this to fail at a later
> suspend sequence.

Yes the problem looks real but there are issues with this patch.
- It doesn't solve your problem completely, because you returned -EBUSY,
your suspend operation failed and we resumed immediately.
- We can't make this solution true for everybody using cpu0 driver, it should
be platform specific.
- Its not a problem of cpu0 driver but all drivers. So, probably a better idea
would be not calling ->target() at all when drivers have marked them unusable
in suspend path..

But I think the problem can/should be solved some other way.. Looking closely,
we got to the problem because we called

__cpufreq_governor(policy, CPUFREQ_GOV_START)

at the first place. This happened because the policy structure had more than
one cpu to take care of and after stopping goveronr for CPU1 it has to start it
again for CPU0... But this is really not required as anyway we are going to
suspend.

Can you try attached patch? I will then repost it formally...

commit 2aecab9be85ceafdbab5f824eec5d1f81f3fa803
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Tue Nov 12 11:26:36 2013 +0530

    cpufreq: don't start governor in suspend path

    When we suspend our system, we remove all non-boot CPUs one by one. At this
    point we actually STOP/START governor for each non-boot cpu, which
is a total
    waste of time as we aren't going to use governor until the time we are back.

    Also, this is causing problems for some platforms (like OMAP),
where governor
    tries to change freq of core in suspend path which requires programming
    regulators via I2C which isn't possible then.

    So, to make it better for everybody don't start the governor again
in suspend
    path.

    Reported-by: Nishanth Menon <nm@ti.com>
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 02d534d..bec58cf 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1174,7 +1174,7 @@ static int __cpufreq_remove_dev_prepare(struct
device *dev,
                return -EINVAL;
        }

-       if (has_target()) {
+       if (has_target() && (!frozen || policy->governor_enabled)) {
                ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
                if (ret) {
                        pr_err("%s: Failed to stop governor\n", __func__);
@@ -1282,7 +1282,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
                if (!frozen)
                        cpufreq_policy_free(policy);
        } else {
-               if (has_target()) {
+               if (has_target() && !frozen) {
                        if ((ret = __cpufreq_governor(policy,
CPUFREQ_GOV_START)) ||
                                        (ret =
__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
                                pr_err("%s: Failed to start governor\n",


--
viresh

> Reported-by: J Keerthy <j-keerthy@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> based on: v3.12-rc6
> Tested on v3.12-rc6 vendor forked tree which supports suspend
> Platform: OMAP5uEVM
>
> Sample of the stack with i2c failure: http://pastebin.com/m5KxnB7a
> With i2c failure fixed: http://pastebin.com/8AfX4e7r
>
> I am open to alternative proposals if any - one option might be to
> introduce a similar behavior at cpufreq level as allowing cpufreq
> transitions in suspend path is probably not necessary.
>
> If folks think that respinning this patch such that there is no
> dependency on regulator to set is_suspended, it is fine with me as
> well.
>
>  drivers/cpufreq/cpufreq-cpu0.c |   47 +++++++++++++++++++++++++++++++++++++---
>  1 file changed, 44 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
> index c522a95..401d975 100644
> --- a/drivers/cpufreq/cpufreq-cpu0.c
> +++ b/drivers/cpufreq/cpufreq-cpu0.c
> @@ -21,6 +21,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
> +#include <linux/suspend.h>
>
>  static unsigned int transition_latency;
>  static unsigned int voltage_tolerance; /* in percentage */
> @@ -29,6 +30,8 @@ static struct device *cpu_dev;
>  static struct clk *cpu_clk;
>  static struct regulator *cpu_reg;
>  static struct cpufreq_frequency_table *freq_table;
> +static DEFINE_MUTEX(cpu_lock);
> +static bool is_suspended;
>
>  static int cpu0_verify_speed(struct cpufreq_policy *policy)
>  {
> @@ -50,12 +53,19 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
>         unsigned int index;
>         int ret;
>
> +       mutex_lock(&cpu_lock);
> +
> +       if (is_suspended) {
> +               ret = -EBUSY;
> +               goto out;
> +       }
> +
>         ret = cpufreq_frequency_table_target(policy, freq_table, target_freq,
>                                              relation, &index);
>         if (ret) {
>                 pr_err("failed to match target freqency %d: %d\n",
>                        target_freq, ret);
> -               return ret;
> +               goto out;
>         }
>
>         freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
> @@ -65,8 +75,10 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
>         freqs.new = freq_Hz / 1000;
>         freqs.old = clk_get_rate(cpu_clk) / 1000;
>
> -       if (freqs.old == freqs.new)
> -               return 0;
> +       if (freqs.old == freqs.new) {
> +               ret = 0;
> +               goto out;
> +       }
>
>         cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
>
> @@ -122,9 +134,32 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
>  post_notify:
>         cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
>
> +out:
> +       mutex_unlock(&cpu_lock);
>         return ret;
>  }
>
> +static int cpu0_pm_notify(struct notifier_block *nb, unsigned long event,
> +       void *dummy)
> +{
> +       mutex_lock(&cpu_lock);
> +       switch (event) {
> +       case PM_SUSPEND_PREPARE:
> +               is_suspended = true;
> +               break;
> +       case PM_POST_SUSPEND:
> +               is_suspended = false;
> +               break;
> +       }
> +       mutex_unlock(&cpu_lock);
> +
> +       return NOTIFY_OK;
> +}
> +
> +static struct notifier_block cpu_pm_notifier = {
> +       .notifier_call = cpu0_pm_notify,
> +};
> +
>  static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
>  {
>         int ret;
> @@ -147,11 +182,17 @@ static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
>
>         cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
>
> +       if (!IS_ERR(cpu_reg))
> +               register_pm_notifier(&cpu_pm_notifier);
> +
>         return 0;
>  }
>
>  static int cpu0_cpufreq_exit(struct cpufreq_policy *policy)
>  {
> +       if (!IS_ERR(cpu_reg))
> +               unregister_pm_notifier(&cpu_pm_notifier);
> +
>         cpufreq_frequency_table_put_attr(policy->cpu);
>
>         return 0;
> --
> 1.7.9.5
>

--e89a8ff1c01c5d64de04eaf49d30
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-cpufreq-don-t-start-governor-in-suspend-path.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-don-t-start-governor-in-suspend-path.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hnwqhmgc0

RnJvbSAyYWVjYWI5YmU4NWNlYWZkYmFiNWY4MjRlZWM1ZDFmODFmM2ZhODAzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8MmFlY2FiOWJlODVjZWFmZGJhYjVmODI0ZWVjNWQx
ZjgxZjNmYTgwMy4xMzg0MjM2MDk3LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogVHVlLCAxMiBOb3Yg
MjAxMyAxMToyNjozNiArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IGRvbid0IHN0YXJ0
IGdvdmVybm9yIGluIHN1c3BlbmQgcGF0aAoKV2hlbiB3ZSBzdXNwZW5kIG91ciBzeXN0ZW0sIHdl
IHJlbW92ZSBhbGwgbm9uLWJvb3QgQ1BVcyBvbmUgYnkgb25lLiBBdCB0aGlzCnBvaW50IHdlIGFj
dHVhbGx5IFNUT1AvU1RBUlQgZ292ZXJub3IgZm9yIGVhY2ggbm9uLWJvb3QgY3B1LCB3aGljaCBp
cyBhIHRvdGFsCndhc3RlIG9mIHRpbWUgYXMgd2UgYXJlbid0IGdvaW5nIHRvIHVzZSBnb3Zlcm5v
ciB1bnRpbCB0aGUgdGltZSB3ZSBhcmUgYmFjay4KCkFsc28sIHRoaXMgaXMgY2F1c2luZyBwcm9i
bGVtcyBmb3Igc29tZSBwbGF0Zm9ybXMgKGxpa2UgT01BUCksIHdoZXJlIGdvdmVybm9yCnRyaWVz
IHRvIGNoYW5nZSBmcmVxIG9mIGNvcmUgaW4gc3VzcGVuZCBwYXRoIHdoaWNoIHJlcXVpcmVzIHBy
b2dyYW1taW5nCnJlZ3VsYXRvcnMgdmlhIEkyQyB3aGljaCBpc24ndCBwb3NzaWJsZSB0aGVuLgoK
U28sIHRvIG1ha2UgaXQgYmV0dGVyIGZvciBldmVyeWJvZHkgZG9uJ3Qgc3RhcnQgdGhlIGdvdmVy
bm9yIGFnYWluIGluIHN1c3BlbmQKcGF0aC4KClJlcG9ydGVkLWJ5OiBOaXNoYW50aCBNZW5vbiA8
bm1AdGkuY29tPgpTaWduZWQtb2ZmLWJ5OiBWaXJlc2ggS3VtYXIgPHZpcmVzaC5rdW1hckBsaW5h
cm8ub3JnPgotLS0KIGRyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMgfCA0ICsrLS0KIDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9jcHVmcmVxL2NwdWZyZXEuYyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMKaW5kZXgg
MDJkNTM0ZC4uYmVjNThjZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwor
KysgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jCkBAIC0xMTc0LDcgKzExNzQsNyBAQCBzdGF0
aWMgaW50IF9fY3B1ZnJlcV9yZW1vdmVfZGV2X3ByZXBhcmUoc3RydWN0IGRldmljZSAqZGV2LAog
CQlyZXR1cm4gLUVJTlZBTDsKIAl9CiAKLQlpZiAoaGFzX3RhcmdldCgpKSB7CisJaWYgKGhhc190
YXJnZXQoKSAmJiAoIWZyb3plbiB8fCBwb2xpY3ktPmdvdmVybm9yX2VuYWJsZWQpKSB7CiAJCXJl
dCA9IF9fY3B1ZnJlcV9nb3Zlcm5vcihwb2xpY3ksIENQVUZSRVFfR09WX1NUT1ApOwogCQlpZiAo
cmV0KSB7CiAJCQlwcl9lcnIoIiVzOiBGYWlsZWQgdG8gc3RvcCBnb3Zlcm5vclxuIiwgX19mdW5j
X18pOwpAQCAtMTI4Miw3ICsxMjgyLDcgQEAgc3RhdGljIGludCBfX2NwdWZyZXFfcmVtb3ZlX2Rl
dl9maW5pc2goc3RydWN0IGRldmljZSAqZGV2LAogCQlpZiAoIWZyb3plbikKIAkJCWNwdWZyZXFf
cG9saWN5X2ZyZWUocG9saWN5KTsKIAl9IGVsc2UgewotCQlpZiAoaGFzX3RhcmdldCgpKSB7CisJ
CWlmIChoYXNfdGFyZ2V0KCkgJiYgIWZyb3plbikgewogCQkJaWYgKChyZXQgPSBfX2NwdWZyZXFf
Z292ZXJub3IocG9saWN5LCBDUFVGUkVRX0dPVl9TVEFSVCkpIHx8CiAJCQkJCShyZXQgPSBfX2Nw
dWZyZXFfZ292ZXJub3IocG9saWN5LCBDUFVGUkVRX0dPVl9MSU1JVFMpKSkgewogCQkJCXByX2Vy
cigiJXM6IEZhaWxlZCB0byBzdGFydCBnb3Zlcm5vclxuIiwKLS0gCjEuNy4xMi5yYzIuMTguZzYx
YjQ3MmUKCg==
--e89a8ff1c01c5d64de04eaf49d30--
