Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab3EMI3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:29:36 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:43976 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3EMI3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:29:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130426191118.GD1433@mtj.dyndns.org>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
	<480f5d6da920e2f2b868f311228c81635727799e.1366803121.git.viresh.kumar@linaro.org>
	<CAP245DWtwguSp8ubid_KJnLSOqvCbmTXN+0Bg_MtDrUhBqve-Q@mail.gmail.com>
	<CAKohpokN_o-RUX6MDwqqfzu4NKRysG-hSzmB=MHV7Y0aDbztuA@mail.gmail.com>
	<20130424161208.GA16991@mtj.dyndns.org>
	<CAP245DUGuaSQbP4026N8kgn6-NqXFJWR3zKoYud=HQ_b+v5+Xw@mail.gmail.com>
	<CAKohpo=U5OqN7SM7XyOWv-WoUHOoJvGc6wcGH61+uikPK3novg@mail.gmail.com>
	<20130426191118.GD1433@mtj.dyndns.org>
Date: Mon, 13 May 2013 13:59:33 +0530
Message-ID: <CAKohpo=5eTz2Kfded_D988wTeiQbKv35C36cPC9N1NXwnW4mzQ@mail.gmail.com>
Subject: Re: [PATCH V5 1/5] workqueues: Introduce new flag WQ_POWER_EFFICIENT
 for power oriented workqueues
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, davem@davemloft.net,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robin Randhawa <robin.randhawa@arm.com>,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>,
        Steve Bannister <Steve.Bannister@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Patch Tracking <patches@linaro.org>, airlied@redhat.com,
        mingo@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: multipart/mixed; boundary=001a11c1f5f0f44a1604dc9550c9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c1f5f0f44a1604dc9550c9
Content-Type: text/plain; charset=ISO-8859-1

On 27 April 2013 00:41, Tejun Heo <tj@kernel.org> wrote:
>
> It's already too late for the upcoming merge window, but things
> generally look good to me and I'll apply the patchset once wq/for-3.11
> opens.  One nitpick tho.
>
> On Thu, Apr 25, 2013 at 09:13:44AM +0530, Viresh Kumar wrote:
>> +     workqueue.power_efficient
>> +                     Workqueues can be performance or power-oriented.
>> +                     Currently, most workqueues are bound to the CPU they
>                                    ^^^^
>                                    per-cpu would be better
>
>> +                     were created on. This gives good performance (due to
>> +                     cache effects) at the cost of potentially waking up
>> +                     otherwise idle cores just to process some work. To save
>> +                     power, we can allow the work to be rescheduled on a core
>> +                     that is already awake.
>
> The above description is confusing to me.  As have been discussed
> multiple times before, per-cpu workqueue in itself doesn't wake up the
> CPU physically.  The timer may but per-cpu workqueue doesn't.  It was
> confusing when this patchset was first posted and the above phrasing
> is still confusing.  What the patchset tries to do is preventing the
> scheduler from perceiving the CPU as active due to the activated
> worker thread pinned to that CPU, right?  The knob doesn't really do
> anything about waking up the processor in itself.  It just avoids
> feeding the scheduler with noisy activation events and allows it to
> allocate work item execution according to the scheduler's view of CPU
> active/idleness.  As the scheduler has longer / larger scope of
> overall CPU activities and means to regulate them, this leads to more
> power-efficient allocation of work item executions, right?  It'd be
> really great if the descriptions and the comment above the flag makes
> this abundantly clear because it's not something too apparent.

Sorry for the long delay for such a small change. I went on long leaves..

I have added following to make things more clear at places:
(Idle from scheduler's perspective. Which may or may not be physically idle)..

Let me know if it is still unclear..

And this is the new patch: (Attached it too for applying cleanly)

---------x---------------x-------------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Mon, 8 Apr 2013 16:45:40 +0530
Subject: [PATCH V5 resent 1/5] workqueues: Introduce new flag
WQ_POWER_EFFICIENT for power oriented workqueues

Workqueues can be performance or power-oriented. Currently, most workqueues are
bound to the CPU they were created on. This gives good performance (due to cache
effects) at the cost of potentially waking up otherwise idle cores (Idle from
scheduler's perspective. Which may or may not be physically idle) just to
process some work. To save power, we can allow the work to be rescheduled on a
core that is already awake.

Workqueues created with the WQ_UNBOUND flag will allow some power savings.
However, we don't change the default behaviour of the system.  To enable
power-saving behaviour, a new config option CONFIG_WQ_POWER_EFFICIENT needs to
be turned on. This option can also be overridden by the
workqueue.power_efficient boot parameter.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
---
 Documentation/kernel-parameters.txt | 18 ++++++++++++++++++
 include/linux/workqueue.h           |  3 +++
 kernel/power/Kconfig                | 21 +++++++++++++++++++++
 kernel/workqueue.c                  | 11 +++++++++++
 4 files changed, 53 insertions(+)

diff --git a/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt
index c3bfacb..9a991b6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3320,6 +3320,24 @@ bytes respectively. Such letter suffixes can
also be entirely omitted.
 			that this also can be controlled per-workqueue for
 			workqueues visible under /sys/bus/workqueue/.

+	workqueue.power_efficient
+			Workqueues can be performance or power-oriented.
+			Currently, most workqueues are bound to the CPU they
+			were created on. This gives good performance (due to
+			cache effects) at the cost of potentially waking up
+			otherwise idle cores (Idle from scheduler's perspective.
+			Which may or may not be physically idle) just to process
+			some work. To save power, we can allow the work to be
+			rescheduled on a core that is already awake.
+
+			Workqueues created with the WQ_UNBOUND flag will allow
+			some power savings.  However, we don't change the
+			default behaviour of the system.  To enable power-saving
+			behaviour, a new config option CONFIG_WQ_POWER_EFFICIENT
+			needs to be turned on. This option can also be
+			overridden by the workqueue.power_efficient boot
+			parameter.
+
 	x2apic_phys	[X86-64,APIC] Use x2apic physical mode instead of
 			default x2apic cluster mode on platforms
 			supporting x2apic.
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 623488f..83fa570 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -302,6 +302,9 @@ enum {
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
 	WQ_SYSFS		= 1 << 6, /* visible in sysfs, see wq_sysfs_register() */
+	WQ_POWER_EFFICIENT	= 1 << 7, /* WQ_UNBOUND, for power
+					   * saving, if wq_power_efficient is
+					   * enabled. Unused otherwise. */

 	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
 	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 5dfdc9e..e8c2b77 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -263,6 +263,27 @@ config PM_GENERIC_DOMAINS
 	bool
 	depends on PM

+config WQ_POWER_EFFICIENT
+	bool "Workqueue allocated as UNBOUND (by default) for power efficiency"
+	depends on PM
+	default n
+	help
+	  Workqueues can be performance or power-oriented. Currently, most
+	  workqueues are bound to the CPU they were created on. This gives good
+	  performance (due to cache effects) at the cost of potentially waking
+	  up otherwise idle cores (Idle from scheduler's perspective. Which may
+	  or may not be physically idle) just to process some work. To save
+	  power, we can allow the work to be rescheduled on a core that is
+	  already awake.
+
+	  Workqueues created with the WQ_UNBOUND flag will allow some power
+	  savings.  However, we don't change the default behaviour of the
+	  system.  To enable power-saving behaviour, a new config option
+	  CONFIG_WQ_POWER_EFFICIENT needs to be turned on. This option can also
+	  be overridden by the workqueue.power_efficient boot parameter.
+
+	  If in doubt, say N.
+
 config PM_GENERIC_DOMAINS_SLEEP
 	def_bool y
 	depends on PM_SLEEP && PM_GENERIC_DOMAINS
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1ae6028..9d8753e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -272,6 +272,14 @@ static cpumask_var_t *wq_numa_possible_cpumask;
 static bool wq_disable_numa;
 module_param_named(disable_numa, wq_disable_numa, bool, 0444);

+#ifdef CONFIG_WQ_POWER_EFFICIENT
+static bool wq_power_efficient = true;
+#else
+static bool wq_power_efficient;
+#endif
+
+module_param_named(power_efficient, wq_power_efficient, bool, 0444);
+
 static bool wq_numa_enabled;		/* unbound NUMA affinity enabled */

 /* buf for wq_update_unbound_numa_attrs(), protected by CPU hotplug
exclusion */
@@ -4085,6 +4093,9 @@ struct workqueue_struct
*__alloc_workqueue_key(const char *fmt,
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;

+	if ((flags & WQ_POWER_EFFICIENT) && wq_power_efficient)
+		flags |= WQ_UNBOUND;
+
 	/* allocate wq and format name */
 	if (flags & WQ_UNBOUND)
 		tbl_size = wq_numa_tbl_len * sizeof(wq->numa_pwq_tbl[0]);

--001a11c1f5f0f44a1604dc9550c9
Content-Type: application/octet-stream; 
	name="0001-workqueues-Introduce-new-flag-WQ_POWER_EFFICIENT-for.patch"
Content-Disposition: attachment; 
	filename="0001-workqueues-Introduce-new-flag-WQ_POWER_EFFICIENT-for.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hgne4bfn0

RnJvbSA4YjA1MWE3M2VjNjgyMzU1ODk1NzFhNzEwMTMwZGRmNDM0NzUyN2ZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8OGIwNTFhNzNlYzY4MjM1NTg5NTcxYTcxMDEzMGRk
ZjQzNDc1MjdmYy4xMzY4NDMzNjk1LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogTW9uLCA4IEFwciAy
MDEzIDE2OjQ1OjQwICswNTMwClN1YmplY3Q6IFtQQVRDSCBWNSByZXNlbnQgMS81XSB3b3JrcXVl
dWVzOiBJbnRyb2R1Y2UgbmV3IGZsYWcKIFdRX1BPV0VSX0VGRklDSUVOVCBmb3IgcG93ZXIgb3Jp
ZW50ZWQKIHdvcmtxdWV1ZXMKCldvcmtxdWV1ZXMgY2FuIGJlIHBlcmZvcm1hbmNlIG9yIHBvd2Vy
LW9yaWVudGVkLiBDdXJyZW50bHksIG1vc3Qgd29ya3F1ZXVlcyBhcmUKYm91bmQgdG8gdGhlIENQ
VSB0aGV5IHdlcmUgY3JlYXRlZCBvbi4gVGhpcyBnaXZlcyBnb29kIHBlcmZvcm1hbmNlIChkdWUg
dG8gY2FjaGUKZWZmZWN0cykgYXQgdGhlIGNvc3Qgb2YgcG90ZW50aWFsbHkgd2FraW5nIHVwIG90
aGVyd2lzZSBpZGxlIGNvcmVzIChJZGxlIGZyb20Kc2NoZWR1bGVyJ3MgcGVyc3BlY3RpdmUuIFdo
aWNoIG1heSBvciBtYXkgbm90IGJlIHBoeXNpY2FsbHkgaWRsZSkganVzdCB0bwpwcm9jZXNzIHNv
bWUgd29yay4gVG8gc2F2ZSBwb3dlciwgd2UgY2FuIGFsbG93IHRoZSB3b3JrIHRvIGJlIHJlc2No
ZWR1bGVkIG9uIGEKY29yZSB0aGF0IGlzIGFscmVhZHkgYXdha2UuCgpXb3JrcXVldWVzIGNyZWF0
ZWQgd2l0aCB0aGUgV1FfVU5CT1VORCBmbGFnIHdpbGwgYWxsb3cgc29tZSBwb3dlciBzYXZpbmdz
LgpIb3dldmVyLCB3ZSBkb24ndCBjaGFuZ2UgdGhlIGRlZmF1bHQgYmVoYXZpb3VyIG9mIHRoZSBz
eXN0ZW0uICBUbyBlbmFibGUKcG93ZXItc2F2aW5nIGJlaGF2aW91ciwgYSBuZXcgY29uZmlnIG9w
dGlvbiBDT05GSUdfV1FfUE9XRVJfRUZGSUNJRU5UIG5lZWRzIHRvCmJlIHR1cm5lZCBvbi4gVGhp
cyBvcHRpb24gY2FuIGFsc28gYmUgb3ZlcnJpZGRlbiBieSB0aGUKd29ya3F1ZXVlLnBvd2VyX2Vm
ZmljaWVudCBib290IHBhcmFtZXRlci4KClNpZ25lZC1vZmYtYnk6IFZpcmVzaCBLdW1hciA8dmly
ZXNoLmt1bWFyQGxpbmFyby5vcmc+ClJldmlld2VkLWJ5OiBBbWl0IEt1Y2hlcmlhIDxhbWl0Lmt1
Y2hlcmlhQGxpbmFyby5vcmc+Ci0tLQogRG9jdW1lbnRhdGlvbi9rZXJuZWwtcGFyYW1ldGVycy50
eHQgfCAxOCArKysrKysrKysrKysrKysrKysKIGluY2x1ZGUvbGludXgvd29ya3F1ZXVlLmggICAg
ICAgICAgIHwgIDMgKysrCiBrZXJuZWwvcG93ZXIvS2NvbmZpZyAgICAgICAgICAgICAgICB8IDIx
ICsrKysrKysrKysrKysrKysrKysrKwoga2VybmVsL3dvcmtxdWV1ZS5jICAgICAgICAgICAgICAg
ICAgfCAxMSArKysrKysrKysrKwogNCBmaWxlcyBjaGFuZ2VkLCA1MyBpbnNlcnRpb25zKCspCgpk
aWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9rZXJuZWwtcGFyYW1ldGVycy50eHQgYi9Eb2N1bWVu
dGF0aW9uL2tlcm5lbC1wYXJhbWV0ZXJzLnR4dAppbmRleCBjM2JmYWNiLi45YTk5MWI2IDEwMDY0
NAotLS0gYS9Eb2N1bWVudGF0aW9uL2tlcm5lbC1wYXJhbWV0ZXJzLnR4dAorKysgYi9Eb2N1bWVu
dGF0aW9uL2tlcm5lbC1wYXJhbWV0ZXJzLnR4dApAQCAtMzMyMCw2ICszMzIwLDI0IEBAIGJ5dGVz
IHJlc3BlY3RpdmVseS4gU3VjaCBsZXR0ZXIgc3VmZml4ZXMgY2FuIGFsc28gYmUgZW50aXJlbHkg
b21pdHRlZC4KIAkJCXRoYXQgdGhpcyBhbHNvIGNhbiBiZSBjb250cm9sbGVkIHBlci13b3JrcXVl
dWUgZm9yCiAJCQl3b3JrcXVldWVzIHZpc2libGUgdW5kZXIgL3N5cy9idXMvd29ya3F1ZXVlLy4K
IAorCXdvcmtxdWV1ZS5wb3dlcl9lZmZpY2llbnQKKwkJCVdvcmtxdWV1ZXMgY2FuIGJlIHBlcmZv
cm1hbmNlIG9yIHBvd2VyLW9yaWVudGVkLgorCQkJQ3VycmVudGx5LCBtb3N0IHdvcmtxdWV1ZXMg
YXJlIGJvdW5kIHRvIHRoZSBDUFUgdGhleQorCQkJd2VyZSBjcmVhdGVkIG9uLiBUaGlzIGdpdmVz
IGdvb2QgcGVyZm9ybWFuY2UgKGR1ZSB0bworCQkJY2FjaGUgZWZmZWN0cykgYXQgdGhlIGNvc3Qg
b2YgcG90ZW50aWFsbHkgd2FraW5nIHVwCisJCQlvdGhlcndpc2UgaWRsZSBjb3JlcyAoSWRsZSBm
cm9tIHNjaGVkdWxlcidzIHBlcnNwZWN0aXZlLgorCQkJV2hpY2ggbWF5IG9yIG1heSBub3QgYmUg
cGh5c2ljYWxseSBpZGxlKSBqdXN0IHRvIHByb2Nlc3MKKwkJCXNvbWUgd29yay4gVG8gc2F2ZSBw
b3dlciwgd2UgY2FuIGFsbG93IHRoZSB3b3JrIHRvIGJlCisJCQlyZXNjaGVkdWxlZCBvbiBhIGNv
cmUgdGhhdCBpcyBhbHJlYWR5IGF3YWtlLgorCisJCQlXb3JrcXVldWVzIGNyZWF0ZWQgd2l0aCB0
aGUgV1FfVU5CT1VORCBmbGFnIHdpbGwgYWxsb3cKKwkJCXNvbWUgcG93ZXIgc2F2aW5ncy4gIEhv
d2V2ZXIsIHdlIGRvbid0IGNoYW5nZSB0aGUKKwkJCWRlZmF1bHQgYmVoYXZpb3VyIG9mIHRoZSBz
eXN0ZW0uICBUbyBlbmFibGUgcG93ZXItc2F2aW5nCisJCQliZWhhdmlvdXIsIGEgbmV3IGNvbmZp
ZyBvcHRpb24gQ09ORklHX1dRX1BPV0VSX0VGRklDSUVOVAorCQkJbmVlZHMgdG8gYmUgdHVybmVk
IG9uLiBUaGlzIG9wdGlvbiBjYW4gYWxzbyBiZQorCQkJb3ZlcnJpZGRlbiBieSB0aGUgd29ya3F1
ZXVlLnBvd2VyX2VmZmljaWVudCBib290CisJCQlwYXJhbWV0ZXIuCisKIAl4MmFwaWNfcGh5cwlb
WDg2LTY0LEFQSUNdIFVzZSB4MmFwaWMgcGh5c2ljYWwgbW9kZSBpbnN0ZWFkIG9mCiAJCQlkZWZh
dWx0IHgyYXBpYyBjbHVzdGVyIG1vZGUgb24gcGxhdGZvcm1zCiAJCQlzdXBwb3J0aW5nIHgyYXBp
Yy4KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvd29ya3F1ZXVlLmggYi9pbmNsdWRlL2xpbnV4
L3dvcmtxdWV1ZS5oCmluZGV4IDYyMzQ4OGYuLjgzZmE1NzAgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUv
bGludXgvd29ya3F1ZXVlLmgKKysrIGIvaW5jbHVkZS9saW51eC93b3JrcXVldWUuaApAQCAtMzAy
LDYgKzMwMiw5IEBAIGVudW0gewogCVdRX0hJR0hQUkkJCT0gMSA8PCA0LCAvKiBoaWdoIHByaW9y
aXR5ICovCiAJV1FfQ1BVX0lOVEVOU0lWRQk9IDEgPDwgNSwgLyogY3B1IGluc3RlbnNpdmUgd29y
a3F1ZXVlICovCiAJV1FfU1lTRlMJCT0gMSA8PCA2LCAvKiB2aXNpYmxlIGluIHN5c2ZzLCBzZWUg
d3Ffc3lzZnNfcmVnaXN0ZXIoKSAqLworCVdRX1BPV0VSX0VGRklDSUVOVAk9IDEgPDwgNywgLyog
V1FfVU5CT1VORCwgZm9yIHBvd2VyCisJCQkJCSAgICogc2F2aW5nLCBpZiB3cV9wb3dlcl9lZmZp
Y2llbnQgaXMKKwkJCQkJICAgKiBlbmFibGVkLiBVbnVzZWQgb3RoZXJ3aXNlLiAqLwogCiAJX19X
UV9EUkFJTklORwkJPSAxIDw8IDE2LCAvKiBpbnRlcm5hbDogd29ya3F1ZXVlIGlzIGRyYWluaW5n
ICovCiAJX19XUV9PUkRFUkVECQk9IDEgPDwgMTcsIC8qIGludGVybmFsOiB3b3JrcXVldWUgaXMg
b3JkZXJlZCAqLwpkaWZmIC0tZ2l0IGEva2VybmVsL3Bvd2VyL0tjb25maWcgYi9rZXJuZWwvcG93
ZXIvS2NvbmZpZwppbmRleCA1ZGZkYzllLi5lOGMyYjc3IDEwMDY0NAotLS0gYS9rZXJuZWwvcG93
ZXIvS2NvbmZpZworKysgYi9rZXJuZWwvcG93ZXIvS2NvbmZpZwpAQCAtMjYzLDYgKzI2MywyNyBA
QCBjb25maWcgUE1fR0VORVJJQ19ET01BSU5TCiAJYm9vbAogCWRlcGVuZHMgb24gUE0KIAorY29u
ZmlnIFdRX1BPV0VSX0VGRklDSUVOVAorCWJvb2wgIldvcmtxdWV1ZSBhbGxvY2F0ZWQgYXMgVU5C
T1VORCAoYnkgZGVmYXVsdCkgZm9yIHBvd2VyIGVmZmljaWVuY3kiCisJZGVwZW5kcyBvbiBQTQor
CWRlZmF1bHQgbgorCWhlbHAKKwkgIFdvcmtxdWV1ZXMgY2FuIGJlIHBlcmZvcm1hbmNlIG9yIHBv
d2VyLW9yaWVudGVkLiBDdXJyZW50bHksIG1vc3QKKwkgIHdvcmtxdWV1ZXMgYXJlIGJvdW5kIHRv
IHRoZSBDUFUgdGhleSB3ZXJlIGNyZWF0ZWQgb24uIFRoaXMgZ2l2ZXMgZ29vZAorCSAgcGVyZm9y
bWFuY2UgKGR1ZSB0byBjYWNoZSBlZmZlY3RzKSBhdCB0aGUgY29zdCBvZiBwb3RlbnRpYWxseSB3
YWtpbmcKKwkgIHVwIG90aGVyd2lzZSBpZGxlIGNvcmVzIChJZGxlIGZyb20gc2NoZWR1bGVyJ3Mg
cGVyc3BlY3RpdmUuIFdoaWNoIG1heQorCSAgb3IgbWF5IG5vdCBiZSBwaHlzaWNhbGx5IGlkbGUp
IGp1c3QgdG8gcHJvY2VzcyBzb21lIHdvcmsuIFRvIHNhdmUKKwkgIHBvd2VyLCB3ZSBjYW4gYWxs
b3cgdGhlIHdvcmsgdG8gYmUgcmVzY2hlZHVsZWQgb24gYSBjb3JlIHRoYXQgaXMKKwkgIGFscmVh
ZHkgYXdha2UuCisKKwkgIFdvcmtxdWV1ZXMgY3JlYXRlZCB3aXRoIHRoZSBXUV9VTkJPVU5EIGZs
YWcgd2lsbCBhbGxvdyBzb21lIHBvd2VyCisJICBzYXZpbmdzLiAgSG93ZXZlciwgd2UgZG9uJ3Qg
Y2hhbmdlIHRoZSBkZWZhdWx0IGJlaGF2aW91ciBvZiB0aGUKKwkgIHN5c3RlbS4gIFRvIGVuYWJs
ZSBwb3dlci1zYXZpbmcgYmVoYXZpb3VyLCBhIG5ldyBjb25maWcgb3B0aW9uCisJICBDT05GSUdf
V1FfUE9XRVJfRUZGSUNJRU5UIG5lZWRzIHRvIGJlIHR1cm5lZCBvbi4gVGhpcyBvcHRpb24gY2Fu
IGFsc28KKwkgIGJlIG92ZXJyaWRkZW4gYnkgdGhlIHdvcmtxdWV1ZS5wb3dlcl9lZmZpY2llbnQg
Ym9vdCBwYXJhbWV0ZXIuCisKKwkgIElmIGluIGRvdWJ0LCBzYXkgTi4KKwogY29uZmlnIFBNX0dF
TkVSSUNfRE9NQUlOU19TTEVFUAogCWRlZl9ib29sIHkKIAlkZXBlbmRzIG9uIFBNX1NMRUVQICYm
IFBNX0dFTkVSSUNfRE9NQUlOUwpkaWZmIC0tZ2l0IGEva2VybmVsL3dvcmtxdWV1ZS5jIGIva2Vy
bmVsL3dvcmtxdWV1ZS5jCmluZGV4IDFhZTYwMjguLjlkODc1M2UgMTAwNjQ0Ci0tLSBhL2tlcm5l
bC93b3JrcXVldWUuYworKysgYi9rZXJuZWwvd29ya3F1ZXVlLmMKQEAgLTI3Miw2ICsyNzIsMTQg
QEAgc3RhdGljIGNwdW1hc2tfdmFyX3QgKndxX251bWFfcG9zc2libGVfY3B1bWFzazsKIHN0YXRp
YyBib29sIHdxX2Rpc2FibGVfbnVtYTsKIG1vZHVsZV9wYXJhbV9uYW1lZChkaXNhYmxlX251bWEs
IHdxX2Rpc2FibGVfbnVtYSwgYm9vbCwgMDQ0NCk7CiAKKyNpZmRlZiBDT05GSUdfV1FfUE9XRVJf
RUZGSUNJRU5UCitzdGF0aWMgYm9vbCB3cV9wb3dlcl9lZmZpY2llbnQgPSB0cnVlOworI2Vsc2UK
K3N0YXRpYyBib29sIHdxX3Bvd2VyX2VmZmljaWVudDsKKyNlbmRpZgorCittb2R1bGVfcGFyYW1f
bmFtZWQocG93ZXJfZWZmaWNpZW50LCB3cV9wb3dlcl9lZmZpY2llbnQsIGJvb2wsIDA0NDQpOwor
CiBzdGF0aWMgYm9vbCB3cV9udW1hX2VuYWJsZWQ7CQkvKiB1bmJvdW5kIE5VTUEgYWZmaW5pdHkg
ZW5hYmxlZCAqLwogCiAvKiBidWYgZm9yIHdxX3VwZGF0ZV91bmJvdW5kX251bWFfYXR0cnMoKSwg
cHJvdGVjdGVkIGJ5IENQVSBob3RwbHVnIGV4Y2x1c2lvbiAqLwpAQCAtNDA4NSw2ICs0MDkzLDkg
QEAgc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QgKl9fYWxsb2Nfd29ya3F1ZXVlX2tleShjb25zdCBj
aGFyICpmbXQsCiAJc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QgKndxOwogCXN0cnVjdCBwb29sX3dv
cmtxdWV1ZSAqcHdxOwogCisJaWYgKChmbGFncyAmIFdRX1BPV0VSX0VGRklDSUVOVCkgJiYgd3Ff
cG93ZXJfZWZmaWNpZW50KQorCQlmbGFncyB8PSBXUV9VTkJPVU5EOworCiAJLyogYWxsb2NhdGUg
d3EgYW5kIGZvcm1hdCBuYW1lICovCiAJaWYgKGZsYWdzICYgV1FfVU5CT1VORCkKIAkJdGJsX3Np
emUgPSB3cV9udW1hX3RibF9sZW4gKiBzaXplb2Yod3EtPm51bWFfcHdxX3RibFswXSk7Ci0tIAox
LjcuMTIucmMyLjE4Lmc2MWI0NzJlCgo=
--001a11c1f5f0f44a1604dc9550c9--
