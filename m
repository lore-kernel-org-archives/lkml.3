Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab3DYDnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 23:43:46 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:54865 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353Ab3DYDno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 23:43:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAP245DUGuaSQbP4026N8kgn6-NqXFJWR3zKoYud=HQ_b+v5+Xw@mail.gmail.com>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
	<480f5d6da920e2f2b868f311228c81635727799e.1366803121.git.viresh.kumar@linaro.org>
	<CAP245DWtwguSp8ubid_KJnLSOqvCbmTXN+0Bg_MtDrUhBqve-Q@mail.gmail.com>
	<CAKohpokN_o-RUX6MDwqqfzu4NKRysG-hSzmB=MHV7Y0aDbztuA@mail.gmail.com>
	<20130424161208.GA16991@mtj.dyndns.org>
	<CAP245DUGuaSQbP4026N8kgn6-NqXFJWR3zKoYud=HQ_b+v5+Xw@mail.gmail.com>
Date: Thu, 25 Apr 2013 09:13:44 +0530
Message-ID: <CAKohpo=U5OqN7SM7XyOWv-WoUHOoJvGc6wcGH61+uikPK3novg@mail.gmail.com>
Subject: Re: [PATCH V5 1/5] workqueues: Introduce new flag WQ_POWER_EFFICIENT
 for power oriented workqueues
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>, Amit Kucheria <amit.kucheria@linaro.org>
Cc: davem@davemloft.net, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robin Randhawa <robin.randhawa@arm.com>,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>,
        Steve Bannister <Steve.Bannister@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Patch Tracking <patches@linaro.org>, airlied@redhat.com,
        mingo@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: multipart/mixed; boundary=089e013d0758a7a91904db2739dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e013d0758a7a91904db2739dd
Content-Type: text/plain; charset=ISO-8859-1

On 25 April 2013 09:00, Amit Kucheria <amit.kucheria@linaro.org> wrote:
> Yes. That was my intention - preventing a prompt on existing defconfigs and
> there by maintaining current behavior.

Hmm... Following is the version after fixing all problems you reported.
@Tejun: I have attached it too as gmail's copy-paste may break it. Please
consider applying this series if it looks fine to you.


---------------x----------------x---------------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Mon, 8 Apr 2013 16:45:40 +0530
Subject: [PATCH V5 1/5] workqueues: Introduce new flag WQ_POWER_EFFICIENT for
 power oriented workqueues

Workqueues can be performance or power-oriented. Currently, most workqueues are
bound to the CPU they were created on. This gives good performance (due to cache
effects) at the cost of potentially waking up otherwise idle cores just to
process some work. To save power, we can allow the work to be rescheduled on a
core that is already awake.

Workqueues created with the WQ_UNBOUND flag will allow some power savings.
However, we don't change the default behaviour of the system.  To enable
power-saving behaviour, a new config option CONFIG_WQ_POWER_EFFICIENT needs to
be turned on. This option can also be overridden by the
workqueue.power_efficient boot parameter.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 Documentation/kernel-parameters.txt | 17 +++++++++++++++++
 include/linux/workqueue.h           |  3 +++
 kernel/power/Kconfig                | 19 +++++++++++++++++++
 kernel/workqueue.c                  | 11 +++++++++++
 4 files changed, 50 insertions(+)

diff --git a/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt
index c4fa000..22edc83 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3312,6 +3312,23 @@ bytes respectively. Such letter suffixes can
also be entirely omitted.
 			that this also can be controlled per-workqueue for
 			workqueues visible under /sys/bus/workqueue/.

+	workqueue.power_efficient
+			Workqueues can be performance or power-oriented.
+			Currently, most workqueues are bound to the CPU they
+			were created on. This gives good performance (due to
+			cache effects) at the cost of potentially waking up
+			otherwise idle cores just to process some work. To save
+			power, we can allow the work to be rescheduled on a core
+			that is already awake.
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
index 5dfdc9e..018f039 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -263,6 +263,25 @@ config PM_GENERIC_DOMAINS
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
+	  up otherwise idle cores just to process some work. To save power, we
+	  can allow the work to be rescheduled on a core that is already awake.
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
index 4aa9f5b..a327027 100644
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

--089e013d0758a7a91904db2739dd
Content-Type: application/octet-stream; 
	name="0001-workqueues-Introduce-new-flag-WQ_POWER_EFFICIENT-for.patch"
Content-Disposition: attachment; 
	filename="0001-workqueues-Introduce-new-flag-WQ_POWER_EFFICIENT-for.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hfxdzqoo0

RnJvbSA2Mjc2MzRmYjg2MDQwM2NiZTFmY2QxOGQ2ZjMyMWVlMmNkOTEwYjkwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8NjI3NjM0ZmI4NjA0MDNjYmUxZmNkMThkNmYzMjFl
ZTJjZDkxMGI5MC4xMzY2ODYxMjM4LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogTW9uLCA4IEFwciAy
MDEzIDE2OjQ1OjQwICswNTMwClN1YmplY3Q6IFtQQVRDSCBWNSAxLzVdIHdvcmtxdWV1ZXM6IElu
dHJvZHVjZSBuZXcgZmxhZyBXUV9QT1dFUl9FRkZJQ0lFTlQgZm9yCiBwb3dlciBvcmllbnRlZCB3
b3JrcXVldWVzCgpXb3JrcXVldWVzIGNhbiBiZSBwZXJmb3JtYW5jZSBvciBwb3dlci1vcmllbnRl
ZC4gQ3VycmVudGx5LCBtb3N0IHdvcmtxdWV1ZXMgYXJlCmJvdW5kIHRvIHRoZSBDUFUgdGhleSB3
ZXJlIGNyZWF0ZWQgb24uIFRoaXMgZ2l2ZXMgZ29vZCBwZXJmb3JtYW5jZSAoZHVlIHRvIGNhY2hl
CmVmZmVjdHMpIGF0IHRoZSBjb3N0IG9mIHBvdGVudGlhbGx5IHdha2luZyB1cCBvdGhlcndpc2Ug
aWRsZSBjb3JlcyBqdXN0IHRvCnByb2Nlc3Mgc29tZSB3b3JrLiBUbyBzYXZlIHBvd2VyLCB3ZSBj
YW4gYWxsb3cgdGhlIHdvcmsgdG8gYmUgcmVzY2hlZHVsZWQgb24gYQpjb3JlIHRoYXQgaXMgYWxy
ZWFkeSBhd2FrZS4KCldvcmtxdWV1ZXMgY3JlYXRlZCB3aXRoIHRoZSBXUV9VTkJPVU5EIGZsYWcg
d2lsbCBhbGxvdyBzb21lIHBvd2VyIHNhdmluZ3MuCkhvd2V2ZXIsIHdlIGRvbid0IGNoYW5nZSB0
aGUgZGVmYXVsdCBiZWhhdmlvdXIgb2YgdGhlIHN5c3RlbS4gIFRvIGVuYWJsZQpwb3dlci1zYXZp
bmcgYmVoYXZpb3VyLCBhIG5ldyBjb25maWcgb3B0aW9uIENPTkZJR19XUV9QT1dFUl9FRkZJQ0lF
TlQgbmVlZHMgdG8KYmUgdHVybmVkIG9uLiBUaGlzIG9wdGlvbiBjYW4gYWxzbyBiZSBvdmVycmlk
ZGVuIGJ5IHRoZQp3b3JrcXVldWUucG93ZXJfZWZmaWNpZW50IGJvb3QgcGFyYW1ldGVyLgoKU2ln
bmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KLS0tCiBE
b2N1bWVudGF0aW9uL2tlcm5lbC1wYXJhbWV0ZXJzLnR4dCB8IDE3ICsrKysrKysrKysrKysrKysr
CiBpbmNsdWRlL2xpbnV4L3dvcmtxdWV1ZS5oICAgICAgICAgICB8ICAzICsrKwoga2VybmVsL3Bv
d2VyL0tjb25maWcgICAgICAgICAgICAgICAgfCAxOSArKysrKysrKysrKysrKysrKysrCiBrZXJu
ZWwvd29ya3F1ZXVlLmMgICAgICAgICAgICAgICAgICB8IDExICsrKysrKysrKysrCiA0IGZpbGVz
IGNoYW5nZWQsIDUwIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2tl
cm5lbC1wYXJhbWV0ZXJzLnR4dCBiL0RvY3VtZW50YXRpb24va2VybmVsLXBhcmFtZXRlcnMudHh0
CmluZGV4IGM0ZmEwMDAuLjIyZWRjODMgMTAwNjQ0Ci0tLSBhL0RvY3VtZW50YXRpb24va2VybmVs
LXBhcmFtZXRlcnMudHh0CisrKyBiL0RvY3VtZW50YXRpb24va2VybmVsLXBhcmFtZXRlcnMudHh0
CkBAIC0zMzEyLDYgKzMzMTIsMjMgQEAgYnl0ZXMgcmVzcGVjdGl2ZWx5LiBTdWNoIGxldHRlciBz
dWZmaXhlcyBjYW4gYWxzbyBiZSBlbnRpcmVseSBvbWl0dGVkLgogCQkJdGhhdCB0aGlzIGFsc28g
Y2FuIGJlIGNvbnRyb2xsZWQgcGVyLXdvcmtxdWV1ZSBmb3IKIAkJCXdvcmtxdWV1ZXMgdmlzaWJs
ZSB1bmRlciAvc3lzL2J1cy93b3JrcXVldWUvLgogCisJd29ya3F1ZXVlLnBvd2VyX2VmZmljaWVu
dAorCQkJV29ya3F1ZXVlcyBjYW4gYmUgcGVyZm9ybWFuY2Ugb3IgcG93ZXItb3JpZW50ZWQuCisJ
CQlDdXJyZW50bHksIG1vc3Qgd29ya3F1ZXVlcyBhcmUgYm91bmQgdG8gdGhlIENQVSB0aGV5CisJ
CQl3ZXJlIGNyZWF0ZWQgb24uIFRoaXMgZ2l2ZXMgZ29vZCBwZXJmb3JtYW5jZSAoZHVlIHRvCisJ
CQljYWNoZSBlZmZlY3RzKSBhdCB0aGUgY29zdCBvZiBwb3RlbnRpYWxseSB3YWtpbmcgdXAKKwkJ
CW90aGVyd2lzZSBpZGxlIGNvcmVzIGp1c3QgdG8gcHJvY2VzcyBzb21lIHdvcmsuIFRvIHNhdmUK
KwkJCXBvd2VyLCB3ZSBjYW4gYWxsb3cgdGhlIHdvcmsgdG8gYmUgcmVzY2hlZHVsZWQgb24gYSBj
b3JlCisJCQl0aGF0IGlzIGFscmVhZHkgYXdha2UuCisKKwkJCVdvcmtxdWV1ZXMgY3JlYXRlZCB3
aXRoIHRoZSBXUV9VTkJPVU5EIGZsYWcgd2lsbCBhbGxvdworCQkJc29tZSBwb3dlciBzYXZpbmdz
LiAgSG93ZXZlciwgd2UgZG9uJ3QgY2hhbmdlIHRoZQorCQkJZGVmYXVsdCBiZWhhdmlvdXIgb2Yg
dGhlIHN5c3RlbS4gIFRvIGVuYWJsZSBwb3dlci1zYXZpbmcKKwkJCWJlaGF2aW91ciwgYSBuZXcg
Y29uZmlnIG9wdGlvbiBDT05GSUdfV1FfUE9XRVJfRUZGSUNJRU5UCisJCQluZWVkcyB0byBiZSB0
dXJuZWQgb24uIFRoaXMgb3B0aW9uIGNhbiBhbHNvIGJlCisJCQlvdmVycmlkZGVuIGJ5IHRoZSB3
b3JrcXVldWUucG93ZXJfZWZmaWNpZW50IGJvb3QKKwkJCXBhcmFtZXRlci4KKwogCXgyYXBpY19w
aHlzCVtYODYtNjQsQVBJQ10gVXNlIHgyYXBpYyBwaHlzaWNhbCBtb2RlIGluc3RlYWQgb2YKIAkJ
CWRlZmF1bHQgeDJhcGljIGNsdXN0ZXIgbW9kZSBvbiBwbGF0Zm9ybXMKIAkJCXN1cHBvcnRpbmcg
eDJhcGljLgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC93b3JrcXVldWUuaCBiL2luY2x1ZGUv
bGludXgvd29ya3F1ZXVlLmgKaW5kZXggNjIzNDg4Zi4uODNmYTU3MCAxMDA2NDQKLS0tIGEvaW5j
bHVkZS9saW51eC93b3JrcXVldWUuaAorKysgYi9pbmNsdWRlL2xpbnV4L3dvcmtxdWV1ZS5oCkBA
IC0zMDIsNiArMzAyLDkgQEAgZW51bSB7CiAJV1FfSElHSFBSSQkJPSAxIDw8IDQsIC8qIGhpZ2gg
cHJpb3JpdHkgKi8KIAlXUV9DUFVfSU5URU5TSVZFCT0gMSA8PCA1LCAvKiBjcHUgaW5zdGVuc2l2
ZSB3b3JrcXVldWUgKi8KIAlXUV9TWVNGUwkJPSAxIDw8IDYsIC8qIHZpc2libGUgaW4gc3lzZnMs
IHNlZSB3cV9zeXNmc19yZWdpc3RlcigpICovCisJV1FfUE9XRVJfRUZGSUNJRU5UCT0gMSA8PCA3
LCAvKiBXUV9VTkJPVU5ELCBmb3IgcG93ZXIKKwkJCQkJICAgKiBzYXZpbmcsIGlmIHdxX3Bvd2Vy
X2VmZmljaWVudCBpcworCQkJCQkgICAqIGVuYWJsZWQuIFVudXNlZCBvdGhlcndpc2UuICovCiAK
IAlfX1dRX0RSQUlOSU5HCQk9IDEgPDwgMTYsIC8qIGludGVybmFsOiB3b3JrcXVldWUgaXMgZHJh
aW5pbmcgKi8KIAlfX1dRX09SREVSRUQJCT0gMSA8PCAxNywgLyogaW50ZXJuYWw6IHdvcmtxdWV1
ZSBpcyBvcmRlcmVkICovCmRpZmYgLS1naXQgYS9rZXJuZWwvcG93ZXIvS2NvbmZpZyBiL2tlcm5l
bC9wb3dlci9LY29uZmlnCmluZGV4IDVkZmRjOWUuLjAxOGYwMzkgMTAwNjQ0Ci0tLSBhL2tlcm5l
bC9wb3dlci9LY29uZmlnCisrKyBiL2tlcm5lbC9wb3dlci9LY29uZmlnCkBAIC0yNjMsNiArMjYz
LDI1IEBAIGNvbmZpZyBQTV9HRU5FUklDX0RPTUFJTlMKIAlib29sCiAJZGVwZW5kcyBvbiBQTQog
Citjb25maWcgV1FfUE9XRVJfRUZGSUNJRU5UCisJYm9vbCAiV29ya3F1ZXVlIGFsbG9jYXRlZCBh
cyBVTkJPVU5EIChieSBkZWZhdWx0KSBmb3IgcG93ZXIgZWZmaWNpZW5jeSIKKwlkZXBlbmRzIG9u
IFBNCisJZGVmYXVsdCBuCisJaGVscAorCSAgV29ya3F1ZXVlcyBjYW4gYmUgcGVyZm9ybWFuY2Ug
b3IgcG93ZXItb3JpZW50ZWQuIEN1cnJlbnRseSwgbW9zdAorCSAgd29ya3F1ZXVlcyBhcmUgYm91
bmQgdG8gdGhlIENQVSB0aGV5IHdlcmUgY3JlYXRlZCBvbi4gVGhpcyBnaXZlcyBnb29kCisJICBw
ZXJmb3JtYW5jZSAoZHVlIHRvIGNhY2hlIGVmZmVjdHMpIGF0IHRoZSBjb3N0IG9mIHBvdGVudGlh
bGx5IHdha2luZworCSAgdXAgb3RoZXJ3aXNlIGlkbGUgY29yZXMganVzdCB0byBwcm9jZXNzIHNv
bWUgd29yay4gVG8gc2F2ZSBwb3dlciwgd2UKKwkgIGNhbiBhbGxvdyB0aGUgd29yayB0byBiZSBy
ZXNjaGVkdWxlZCBvbiBhIGNvcmUgdGhhdCBpcyBhbHJlYWR5IGF3YWtlLgorCisJICBXb3JrcXVl
dWVzIGNyZWF0ZWQgd2l0aCB0aGUgV1FfVU5CT1VORCBmbGFnIHdpbGwgYWxsb3cgc29tZSBwb3dl
cgorCSAgc2F2aW5ncy4gIEhvd2V2ZXIsIHdlIGRvbid0IGNoYW5nZSB0aGUgZGVmYXVsdCBiZWhh
dmlvdXIgb2YgdGhlCisJICBzeXN0ZW0uICBUbyBlbmFibGUgcG93ZXItc2F2aW5nIGJlaGF2aW91
ciwgYSBuZXcgY29uZmlnIG9wdGlvbgorCSAgQ09ORklHX1dRX1BPV0VSX0VGRklDSUVOVCBuZWVk
cyB0byBiZSB0dXJuZWQgb24uIFRoaXMgb3B0aW9uIGNhbiBhbHNvCisJICBiZSBvdmVycmlkZGVu
IGJ5IHRoZSB3b3JrcXVldWUucG93ZXJfZWZmaWNpZW50IGJvb3QgcGFyYW1ldGVyLgorCisJICBJ
ZiBpbiBkb3VidCwgc2F5IE4uCisKIGNvbmZpZyBQTV9HRU5FUklDX0RPTUFJTlNfU0xFRVAKIAlk
ZWZfYm9vbCB5CiAJZGVwZW5kcyBvbiBQTV9TTEVFUCAmJiBQTV9HRU5FUklDX0RPTUFJTlMKZGlm
ZiAtLWdpdCBhL2tlcm5lbC93b3JrcXVldWUuYyBiL2tlcm5lbC93b3JrcXVldWUuYwppbmRleCA0
YWE5ZjViLi5hMzI3MDI3IDEwMDY0NAotLS0gYS9rZXJuZWwvd29ya3F1ZXVlLmMKKysrIGIva2Vy
bmVsL3dvcmtxdWV1ZS5jCkBAIC0yNzIsNiArMjcyLDE0IEBAIHN0YXRpYyBjcHVtYXNrX3Zhcl90
ICp3cV9udW1hX3Bvc3NpYmxlX2NwdW1hc2s7CiBzdGF0aWMgYm9vbCB3cV9kaXNhYmxlX251bWE7
CiBtb2R1bGVfcGFyYW1fbmFtZWQoZGlzYWJsZV9udW1hLCB3cV9kaXNhYmxlX251bWEsIGJvb2ws
IDA0NDQpOwogCisjaWZkZWYgQ09ORklHX1dRX1BPV0VSX0VGRklDSUVOVAorc3RhdGljIGJvb2wg
d3FfcG93ZXJfZWZmaWNpZW50ID0gdHJ1ZTsKKyNlbHNlCitzdGF0aWMgYm9vbCB3cV9wb3dlcl9l
ZmZpY2llbnQ7CisjZW5kaWYKKworbW9kdWxlX3BhcmFtX25hbWVkKHBvd2VyX2VmZmljaWVudCwg
d3FfcG93ZXJfZWZmaWNpZW50LCBib29sLCAwNDQ0KTsKKwogc3RhdGljIGJvb2wgd3FfbnVtYV9l
bmFibGVkOwkJLyogdW5ib3VuZCBOVU1BIGFmZmluaXR5IGVuYWJsZWQgKi8KIAogLyogYnVmIGZv
ciB3cV91cGRhdGVfdW5ib3VuZF9udW1hX2F0dHJzKCksIHByb3RlY3RlZCBieSBDUFUgaG90cGx1
ZyBleGNsdXNpb24gKi8KQEAgLTQwODUsNiArNDA5Myw5IEBAIHN0cnVjdCB3b3JrcXVldWVfc3Ry
dWN0ICpfX2FsbG9jX3dvcmtxdWV1ZV9rZXkoY29uc3QgY2hhciAqZm10LAogCXN0cnVjdCB3b3Jr
cXVldWVfc3RydWN0ICp3cTsKIAlzdHJ1Y3QgcG9vbF93b3JrcXVldWUgKnB3cTsKIAorCWlmICgo
ZmxhZ3MgJiBXUV9QT1dFUl9FRkZJQ0lFTlQpICYmIHdxX3Bvd2VyX2VmZmljaWVudCkKKwkJZmxh
Z3MgfD0gV1FfVU5CT1VORDsKKwogCS8qIGFsbG9jYXRlIHdxIGFuZCBmb3JtYXQgbmFtZSAqLwog
CWlmIChmbGFncyAmIFdRX1VOQk9VTkQpCiAJCXRibF9zaXplID0gd3FfbnVtYV90YmxfbGVuICog
c2l6ZW9mKHdxLT5udW1hX3B3cV90YmxbMF0pOwotLSAKMS43LjEyLnJjMi4xOC5nNjFiNDcyZQoK
--089e013d0758a7a91904db2739dd--
