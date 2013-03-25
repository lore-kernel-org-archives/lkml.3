Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab3CYItz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:49:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:59460 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab3CYItx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:49:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,904,1355126400"; 
   d="scan'208,223";a="311459504"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: [PATCH] xen/acpi-stub: Disable it b/c the acpi_processor_add is
 no longer called.
Thread-Topic: [PATCH] xen/acpi-stub: Disable it b/c the acpi_processor_add
 is no longer called.
Thread-Index: AQHOJwmITQJEKdfuhUi+CcWazm/o2Zi2GFWw
Date: Mon, 25 Mar 2013 08:49:47 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923354340D3@SHSMSX101.ccr.corp.intel.com>
References: <1363962480-1366-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1363962480-1366-1-git-send-email-konrad.wilk@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923354340D3SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923354340D3SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Konrad Rzeszutek Wilk wrote:
> With the Xen ACPI stub code (CONFIG_XEN_STUB=3Dy) enabled, the power
> C and P states are no longer uploaded to the hypervisor.
>=20
> The reason is that the Xen CPU hotplug code: xen-acpi-cpuhotplug.c
> and the xen-acpi-stub.c register themselves as the "processor" type
> object.=20
>=20
> That means the generic processor (processor_driver.c) stops
> working and it does not call (acpi_processor_add) which populates the
>=20
>          per_cpu(processors, pr->id) =3D pr;
>=20
> structure. The 'pr' is gathered from the acpi_processor_get_info
> function which does the job of finding the C-states and figuring out
> PBLK address.=20
>=20
> The 'processors->pr' is then later used by xen-acpi-processor.c (the
> one that uploads C and P states to the hypervisor). Since it is NULL,
> we end=20
> skip the gathering of _PSD, _PSS, _PCT, etc and never upload the power
> management data.
>=20
> The end result is that enabling the CONFIG_XEN_STUB in the build
> means that xen-acpi-processor is not working anymore.
>=20
> This temporary patch fixes it by marking the XEN_STUB driver as
> BROKEN until this can be properly fixed.
>=20
> CC: jinsong.liu@intel.com
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index 5a32232..67af155 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -182,7 +182,7 @@ config XEN_PRIVCMD
>=20
>  config XEN_STUB
>  	bool "Xen stub drivers"
> -	depends on XEN && X86_64
> +	depends on XEN && X86_64 && BROKEN
>  	default n
>  	help
>  	  Allow kernel to install stub drivers, to reserve space for Xen
> drivers,=20


Yes, exactly.

With xen-cpu-hotplug logic added, it's not proper to make xen Px/Cx rely on=
 native processor_driver anymore.
Reasonable solution is, hooking Px/Cx logic into xen hotplug path (say, ops=
.add --> acpi_processor_add), like what native side does currently.

So at Xen dom0 side, there are 2 issues need to be solved:
1. currently xen dom0 defaultly set cpu_possible_map equal to cpu_present_m=
ap, we need adjust it so that when cpu hotplug it can handle 'pr' properly;
2. hook Px/Cx parsing logic into cpu hotadd or cpu online logic, like what =
native side did;

Attached is a patch to solve issue 1, basically it generates possible map a=
ccording to MADT entries, not trims according to hypervisor online cpus. Wi=
th it, dom0 cpu possible map reserves space for Xen cpu hotplug and corresp=
onding Px/Cx, and dom0 also get a unified possible map view just like it ru=
ns under native platform.

As for issue 2, it may be fixed later :-)
(BTW, your patch to temporarily disable xen-stub is necessary even with my =
patch, only would be reverted after issue 2 got solved)

Thanks,
Jinsong

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>From bb49caa523de46551c37de91754c49919bee4687 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Mon, 25 Mar 2013 21:31:36 +0800
Subject: [PATCH] Xen/X86: adjust dom0 cpu possible map for sake of Xen Px/C=
x

Currently dom0 cpu possible map defaultly equal to cpu
present map. It works fine if not consider Xen cpu hotplug
and corresponding Px/Cx. However, when cpu hotplug the
possible map should reserve some space, considering it's
static and per-cpu data-structures are allocated at init
time, and do not expect to do this dynamically.

This patch adjusts Xen dom0 cpu possible map.
Basically it generates possible map according to MADT entries,
not trims according to hypervisor online cpus. With it, dom0
cpu possible map reserves space for Xen cpu hotplug and
corresponding Px/Cx, and dom0 also get a unified possible map
view just like it runs under native platform.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 arch/x86/xen/enlighten.c |   13 +++++++++++--
 arch/x86/xen/smp.c       |   30 +++++++-----------------------
 2 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c8e1c7b..f630956 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1089,8 +1089,17 @@ void xen_setup_vcpu_info_placement(void)
 {
 	int cpu;
=20
-	for_each_possible_cpu(cpu)
-		xen_vcpu_setup(cpu);
+	/*
+	 * Dom0 reserved more possible bits than present ones for the sake of
+	 * Xen processor driver and hotplug logic. To avoid clamp_max_cpus,
+	 * setup dom0 vcpus for present ones.
+	 */
+	if (xen_initial_domain())
+		for_each_present_cpu(cpu)
+			xen_vcpu_setup(cpu);
+	else
+		for_each_possible_cpu(cpu)
+			xen_vcpu_setup(cpu);
=20
 	/* xen_vcpu_setup managed to place the vcpu_info within the
 	   percpu area for all cpus, so make use of it */
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 09ea61d..9b334b9 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -192,37 +192,23 @@ static void __init xen_fill_possible_map(void)
 static void __init xen_filter_cpu_maps(void)
 {
 	int i, rc;
-	unsigned int subtract =3D 0;
=20
 	if (!xen_initial_domain())
 		return;
=20
 	num_processors =3D 0;
 	disabled_cpus =3D 0;
+
+	/* all bits have been set possible at prefill_possible_map */
 	for (i =3D 0; i < nr_cpu_ids; i++) {
 		rc =3D HYPERVISOR_vcpu_op(VCPUOP_is_up, i, NULL);
-		if (rc >=3D 0) {
+		if (rc >=3D 0)
 			num_processors++;
-			set_cpu_possible(i, true);
-		} else {
-			set_cpu_possible(i, false);
+		else {
+			disabled_cpus++;
 			set_cpu_present(i, false);
-			subtract++;
 		}
 	}
-#ifdef CONFIG_HOTPLUG_CPU
-	/* This is akin to using 'nr_cpus' on the Linux command line.
-	 * Which is OK as when we use 'dom0_max_vcpus=3DX' we can only
-	 * have up to X, while nr_cpu_ids is greater than X. This
-	 * normally is not a problem, except when CPU hotplugging
-	 * is involved and then there might be more than X CPUs
-	 * in the guest - which will not work as there is no
-	 * hypercall to expand the max number of VCPUs an already
-	 * running guest has. So cap it up to X. */
-	if (subtract)
-		nr_cpu_ids =3D nr_cpu_ids - subtract;
-#endif
-
 }
=20
 static void __init xen_smp_prepare_boot_cpu(void)
@@ -272,15 +258,13 @@ static void __init xen_smp_prepare_cpus(unsigned int =
max_cpus)
=20
 	cpumask_copy(xen_cpu_initialized_map, cpumask_of(0));
=20
-	/* Restrict the possible_map according to max_cpus. */
+	/* Restrict the possible/present_map according to max_cpus. */
 	while ((num_possible_cpus() > 1) && (num_possible_cpus() > max_cpus)) {
 		for (cpu =3D nr_cpu_ids - 1; !cpu_possible(cpu); cpu--)
 			continue;
 		set_cpu_possible(cpu, false);
+		set_cpu_present(cpu, false);
 	}
-
-	for_each_possible_cpu(cpu)
-		set_cpu_present(cpu, true);
 }
=20
 static int __cpuinit
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923354340D3SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Xen-X86-adjust-dom0-cpu-possible-map-for-sake-of-Xen.patch"
Content-Description: 0001-Xen-X86-adjust-dom0-cpu-possible-map-for-sake-of-Xen.patch
Content-Disposition: attachment;
	filename="0001-Xen-X86-adjust-dom0-cpu-possible-map-for-sake-of-Xen.patch";
	size=3805; creation-date="Mon, 25 Mar 2013 08:45:39 GMT";
	modification-date="Mon, 25 Mar 2013 16:33:54 GMT"
Content-Transfer-Encoding: base64

RnJvbSBiYjQ5Y2FhNTIzZGU0NjU1MWMzN2RlOTE3NTRjNDk5MTliZWU0Njg3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBNb24sIDI1IE1hciAyMDEzIDIxOjMxOjM2ICswODAwClN1YmplY3Q6IFtQQVRDSF0gWGVu
L1g4NjogYWRqdXN0IGRvbTAgY3B1IHBvc3NpYmxlIG1hcCBmb3Igc2FrZSBvZiBYZW4gUHgvQ3gK
CkN1cnJlbnRseSBkb20wIGNwdSBwb3NzaWJsZSBtYXAgZGVmYXVsdGx5IGVxdWFsIHRvIGNwdQpw
cmVzZW50IG1hcC4gSXQgd29ya3MgZmluZSBpZiBub3QgY29uc2lkZXIgWGVuIGNwdSBob3RwbHVn
CmFuZCBjb3JyZXNwb25kaW5nIFB4L0N4LiBIb3dldmVyLCB3aGVuIGNwdSBob3RwbHVnIHRoZQpw
b3NzaWJsZSBtYXAgc2hvdWxkIHJlc2VydmUgc29tZSBzcGFjZSwgY29uc2lkZXJpbmcgaXQncwpz
dGF0aWMgYW5kIHBlci1jcHUgZGF0YS1zdHJ1Y3R1cmVzIGFyZSBhbGxvY2F0ZWQgYXQgaW5pdAp0
aW1lLCBhbmQgZG8gbm90IGV4cGVjdCB0byBkbyB0aGlzIGR5bmFtaWNhbGx5LgoKVGhpcyBwYXRj
aCBhZGp1c3RzIFhlbiBkb20wIGNwdSBwb3NzaWJsZSBtYXAuCkJhc2ljYWxseSBpdCBnZW5lcmF0
ZXMgcG9zc2libGUgbWFwIGFjY29yZGluZyB0byBNQURUIGVudHJpZXMsCm5vdCB0cmltcyBhY2Nv
cmRpbmcgdG8gaHlwZXJ2aXNvciBvbmxpbmUgY3B1cy4gV2l0aCBpdCwgZG9tMApjcHUgcG9zc2li
bGUgbWFwIHJlc2VydmVzIHNwYWNlIGZvciBYZW4gY3B1IGhvdHBsdWcgYW5kCmNvcnJlc3BvbmRp
bmcgUHgvQ3gsIGFuZCBkb20wIGFsc28gZ2V0IGEgdW5pZmllZCBwb3NzaWJsZSBtYXAKdmlldyBq
dXN0IGxpa2UgaXQgcnVucyB1bmRlciBuYXRpdmUgcGxhdGZvcm0uCgpTaWduZWQtb2ZmLWJ5OiBM
aXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgotLS0KIGFyY2gveDg2L3hlbi9lbmxp
Z2h0ZW4uYyB8ICAgMTMgKysrKysrKysrKystLQogYXJjaC94ODYveGVuL3NtcC5jICAgICAgIHwg
ICAzMCArKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTgg
aW5zZXJ0aW9ucygrKSwgMjUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYveGVu
L2VubGlnaHRlbi5jIGIvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jCmluZGV4IGM4ZTFjN2IuLmY2
MzA5NTYgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYworKysgYi9hcmNoL3g4
Ni94ZW4vZW5saWdodGVuLmMKQEAgLTEwODksOCArMTA4OSwxNyBAQCB2b2lkIHhlbl9zZXR1cF92
Y3B1X2luZm9fcGxhY2VtZW50KHZvaWQpCiB7CiAJaW50IGNwdTsKIAotCWZvcl9lYWNoX3Bvc3Np
YmxlX2NwdShjcHUpCi0JCXhlbl92Y3B1X3NldHVwKGNwdSk7CisJLyoKKwkgKiBEb20wIHJlc2Vy
dmVkIG1vcmUgcG9zc2libGUgYml0cyB0aGFuIHByZXNlbnQgb25lcyBmb3IgdGhlIHNha2Ugb2YK
KwkgKiBYZW4gcHJvY2Vzc29yIGRyaXZlciBhbmQgaG90cGx1ZyBsb2dpYy4gVG8gYXZvaWQgY2xh
bXBfbWF4X2NwdXMsCisJICogc2V0dXAgZG9tMCB2Y3B1cyBmb3IgcHJlc2VudCBvbmVzLgorCSAq
LworCWlmICh4ZW5faW5pdGlhbF9kb21haW4oKSkKKwkJZm9yX2VhY2hfcHJlc2VudF9jcHUoY3B1
KQorCQkJeGVuX3ZjcHVfc2V0dXAoY3B1KTsKKwllbHNlCisJCWZvcl9lYWNoX3Bvc3NpYmxlX2Nw
dShjcHUpCisJCQl4ZW5fdmNwdV9zZXR1cChjcHUpOwogCiAJLyogeGVuX3ZjcHVfc2V0dXAgbWFu
YWdlZCB0byBwbGFjZSB0aGUgdmNwdV9pbmZvIHdpdGhpbiB0aGUKIAkgICBwZXJjcHUgYXJlYSBm
b3IgYWxsIGNwdXMsIHNvIG1ha2UgdXNlIG9mIGl0ICovCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni94
ZW4vc21wLmMgYi9hcmNoL3g4Ni94ZW4vc21wLmMKaW5kZXggMDllYTYxZC4uOWIzMzRiOSAxMDA2
NDQKLS0tIGEvYXJjaC94ODYveGVuL3NtcC5jCisrKyBiL2FyY2gveDg2L3hlbi9zbXAuYwpAQCAt
MTkyLDM3ICsxOTIsMjMgQEAgc3RhdGljIHZvaWQgX19pbml0IHhlbl9maWxsX3Bvc3NpYmxlX21h
cCh2b2lkKQogc3RhdGljIHZvaWQgX19pbml0IHhlbl9maWx0ZXJfY3B1X21hcHModm9pZCkKIHsK
IAlpbnQgaSwgcmM7Ci0JdW5zaWduZWQgaW50IHN1YnRyYWN0ID0gMDsKIAogCWlmICgheGVuX2lu
aXRpYWxfZG9tYWluKCkpCiAJCXJldHVybjsKIAogCW51bV9wcm9jZXNzb3JzID0gMDsKIAlkaXNh
YmxlZF9jcHVzID0gMDsKKworCS8qIGFsbCBiaXRzIGhhdmUgYmVlbiBzZXQgcG9zc2libGUgYXQg
cHJlZmlsbF9wb3NzaWJsZV9tYXAgKi8KIAlmb3IgKGkgPSAwOyBpIDwgbnJfY3B1X2lkczsgaSsr
KSB7CiAJCXJjID0gSFlQRVJWSVNPUl92Y3B1X29wKFZDUFVPUF9pc191cCwgaSwgTlVMTCk7Ci0J
CWlmIChyYyA+PSAwKSB7CisJCWlmIChyYyA+PSAwKQogCQkJbnVtX3Byb2Nlc3NvcnMrKzsKLQkJ
CXNldF9jcHVfcG9zc2libGUoaSwgdHJ1ZSk7Ci0JCX0gZWxzZSB7Ci0JCQlzZXRfY3B1X3Bvc3Np
YmxlKGksIGZhbHNlKTsKKwkJZWxzZSB7CisJCQlkaXNhYmxlZF9jcHVzKys7CiAJCQlzZXRfY3B1
X3ByZXNlbnQoaSwgZmFsc2UpOwotCQkJc3VidHJhY3QrKzsKIAkJfQogCX0KLSNpZmRlZiBDT05G
SUdfSE9UUExVR19DUFUKLQkvKiBUaGlzIGlzIGFraW4gdG8gdXNpbmcgJ25yX2NwdXMnIG9uIHRo
ZSBMaW51eCBjb21tYW5kIGxpbmUuCi0JICogV2hpY2ggaXMgT0sgYXMgd2hlbiB3ZSB1c2UgJ2Rv
bTBfbWF4X3ZjcHVzPVgnIHdlIGNhbiBvbmx5Ci0JICogaGF2ZSB1cCB0byBYLCB3aGlsZSBucl9j
cHVfaWRzIGlzIGdyZWF0ZXIgdGhhbiBYLiBUaGlzCi0JICogbm9ybWFsbHkgaXMgbm90IGEgcHJv
YmxlbSwgZXhjZXB0IHdoZW4gQ1BVIGhvdHBsdWdnaW5nCi0JICogaXMgaW52b2x2ZWQgYW5kIHRo
ZW4gdGhlcmUgbWlnaHQgYmUgbW9yZSB0aGFuIFggQ1BVcwotCSAqIGluIHRoZSBndWVzdCAtIHdo
aWNoIHdpbGwgbm90IHdvcmsgYXMgdGhlcmUgaXMgbm8KLQkgKiBoeXBlcmNhbGwgdG8gZXhwYW5k
IHRoZSBtYXggbnVtYmVyIG9mIFZDUFVzIGFuIGFscmVhZHkKLQkgKiBydW5uaW5nIGd1ZXN0IGhh
cy4gU28gY2FwIGl0IHVwIHRvIFguICovCi0JaWYgKHN1YnRyYWN0KQotCQlucl9jcHVfaWRzID0g
bnJfY3B1X2lkcyAtIHN1YnRyYWN0OwotI2VuZGlmCi0KIH0KIAogc3RhdGljIHZvaWQgX19pbml0
IHhlbl9zbXBfcHJlcGFyZV9ib290X2NwdSh2b2lkKQpAQCAtMjcyLDE1ICsyNTgsMTMgQEAgc3Rh
dGljIHZvaWQgX19pbml0IHhlbl9zbXBfcHJlcGFyZV9jcHVzKHVuc2lnbmVkIGludCBtYXhfY3B1
cykKIAogCWNwdW1hc2tfY29weSh4ZW5fY3B1X2luaXRpYWxpemVkX21hcCwgY3B1bWFza19vZigw
KSk7CiAKLQkvKiBSZXN0cmljdCB0aGUgcG9zc2libGVfbWFwIGFjY29yZGluZyB0byBtYXhfY3B1
cy4gKi8KKwkvKiBSZXN0cmljdCB0aGUgcG9zc2libGUvcHJlc2VudF9tYXAgYWNjb3JkaW5nIHRv
IG1heF9jcHVzLiAqLwogCXdoaWxlICgobnVtX3Bvc3NpYmxlX2NwdXMoKSA+IDEpICYmIChudW1f
cG9zc2libGVfY3B1cygpID4gbWF4X2NwdXMpKSB7CiAJCWZvciAoY3B1ID0gbnJfY3B1X2lkcyAt
IDE7ICFjcHVfcG9zc2libGUoY3B1KTsgY3B1LS0pCiAJCQljb250aW51ZTsKIAkJc2V0X2NwdV9w
b3NzaWJsZShjcHUsIGZhbHNlKTsKKwkJc2V0X2NwdV9wcmVzZW50KGNwdSwgZmFsc2UpOwogCX0K
LQotCWZvcl9lYWNoX3Bvc3NpYmxlX2NwdShjcHUpCi0JCXNldF9jcHVfcHJlc2VudChjcHUsIHRy
dWUpOwogfQogCiBzdGF0aWMgaW50IF9fY3B1aW5pdAotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC82923354340D3SHSMSX101ccrcorpi_--
