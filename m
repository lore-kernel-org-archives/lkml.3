Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3FMEYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 00:24:04 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:60340 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3FMEYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 00:24:02 -0400
MIME-Version: 1.0
In-Reply-To: <51B898B6.8070103@wwwdotorg.org>
References: <cover.1371022830.git.viresh.kumar@linaro.org>
	<881257c10f24b5ca8721b561726bac8887dc922e.1371022830.git.viresh.kumar@linaro.org>
	<51B898B6.8070103@wwwdotorg.org>
Date: Thu, 13 Jun 2013 09:54:01 +0530
Message-ID: <CAKohponC5pKABTi=t64ZXrHxi-Y6cbvAXtjY=_aMkka4s-MCiQ@mail.gmail.com>
Subject: Re: [PATCH 10/11] cpufreq: tegra: select CPU_FREQ_TABLE for ARCH_TEGRA
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com, arnd@arndb.de,
        Stephen Warren <swarren@nvidia.com>
Content-Type: multipart/mixed; boundary=089e013a032af0e29504df017fc8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e013a032af0e29504df017fc8
Content-Type: text/plain; charset=ISO-8859-1

On 12 June 2013 21:20, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/12/2013 02:15 AM, Viresh Kumar wrote:
>> ARCH_TEGRA selects ARCH_HAS_CPUFREQ, so CPUFREQ will be enabled for all variants
>> of TEGRA. CPUFreq driver for tegra is enabled if ARCH_TEGRA is selected. Driver
>> uses APIs from freq_table.c and so we must select CPU_FREQ_TABLE for ARCH_TEGRA.
>>
>> This also removes select CPU_FREQ_TABLE from individual tegra variants.
>
> I guess the real issue here is that drivers/cpufreq/tegra-cpufreq.c gets
> built based on ARCH_TEGRA, which doesn't depend on nor select CPU_FREQ
> itself, so:
>
>         select CPU_FREQ_TABLE if CPU_FREQ
>
> ... isn't guaranteed to fire.
>
> The correct solution seems to be:
>
> * Add CONFIG_ARM_TEGRA_CPUFREQ to drivers/cpufreq/Kconfig.arm.
> * Make that Kconfig option selct CPU_FREQ_TABLE.
> * Make that Kconfig option be def_bool ARCH_TEGRA.
> * Modify drivers/cpufreq/Makefile to build tegra-cpufreq.c based on that.
> * Remove all the cpufreq-related stuff from arch/arm/mach-tegra/Kconfig.
>
> That way, tegra-cpufreq.c can't be built if !CPU_FREQ, and Tegra's
> cpufreq works the same way as all the other cpufreq drivers.

Hmmm. check this out (attached too for you to test):

----------x---------------x------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Wed, 12 Jun 2013 12:05:48 +0530
Subject: [PATCH] cpufreq: tegra: create CONFIG_ARM_TEGRA_CPUFREQ

currently Tegra cpufreq driver gets built based on ARCH_TEGRA, which doesn't
depend on nor select CPU_FREQ itself, so:

        select CPU_FREQ_TABLE if CPU_FREQ

... isn't guaranteed to fire.

The correct solution seems to be:

* Add CONFIG_ARM_TEGRA_CPUFREQ to drivers/cpufreq/Kconfig.arm.
* Make that Kconfig option selct CPU_FREQ_TABLE.
* Make that Kconfig option be def_bool ARCH_TEGRA.
* Modify drivers/cpufreq/Makefile to build tegra-cpufreq.c based on that.
* Remove all the cpufreq-related stuff from arch/arm/mach-tegra/Kconfig.

That way, tegra-cpufreq.c can't be built if !CPU_FREQ, and Tegra's
cpufreq works the same way as all the other cpufreq drivers.

This patch does it.

Suggested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mach-tegra/Kconfig | 3 ---
 drivers/cpufreq/Kconfig.arm | 8 ++++++++
 drivers/cpufreq/Makefile    | 2 +-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 84d72fc..5c0db06 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -28,7 +28,6 @@ config ARCH_TEGRA_2x_SOC
 	select ARM_ERRATA_754327 if SMP
 	select ARM_ERRATA_764369 if SMP
 	select ARM_GIC
-	select CPU_FREQ_TABLE if CPU_FREQ
 	select CPU_V7
 	select PINCTRL
 	select PINCTRL_TEGRA20
@@ -46,7 +45,6 @@ config ARCH_TEGRA_3x_SOC
 	select ARM_ERRATA_754322
 	select ARM_ERRATA_764369 if SMP
 	select ARM_GIC
-	select CPU_FREQ_TABLE if CPU_FREQ
 	select CPU_V7
 	select PINCTRL
 	select PINCTRL_TEGRA30
@@ -63,7 +61,6 @@ config ARCH_TEGRA_114_SOC
 	select ARM_ARCH_TIMER
 	select ARM_GIC
 	select ARM_L1_CACHE_SHIFT_6
-	select CPU_FREQ_TABLE if CPU_FREQ
 	select CPU_V7
 	select PINCTRL
 	select PINCTRL_TEGRA114
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index d52261b..5085427 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -154,3 +154,11 @@ config ARM_SPEAR_CPUFREQ
 	default y
 	help
 	  This adds the CPUFreq driver support for SPEAr SOCs.
+
+config ARM_TEGRA_CPUFREQ
+	bool "TEGRA CPUFreq support"
+	depends on ARCH_TEGRA
+	select CPU_FREQ_TABLE
+	default y
+	help
+	  This adds the CPUFreq driver support for TEGRA SOCs.
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 13c3f83..9c873e7 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -71,7 +71,7 @@ obj-$(CONFIG_ARM_S5PV210_CPUFREQ)	+= s5pv210-cpufreq.o
 obj-$(CONFIG_ARM_SA1100_CPUFREQ)	+= sa1100-cpufreq.o
 obj-$(CONFIG_ARM_SA1110_CPUFREQ)	+= sa1110-cpufreq.o
 obj-$(CONFIG_ARM_SPEAR_CPUFREQ)		+= spear-cpufreq.o
-obj-$(CONFIG_ARCH_TEGRA)		+= tegra-cpufreq.o
+obj-$(CONFIG_ARM_TEGRA_CPUFREQ)		+= tegra-cpufreq.o

 ##################################################################################
 # PowerPC platform drivers

--089e013a032af0e29504df017fc8
Content-Type: application/octet-stream; 
	name="0001-cpufreq-tegra-create-CONFIG_ARM_TEGRA_CPUFREQ.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-tegra-create-CONFIG_ARM_TEGRA_CPUFREQ.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hhvg063j0

RnJvbSAzODlkNzY4NzhlYzFkNmViNTM4M2NiNmFjY2Y1OTMzZjM1ZTFiYjFhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8Mzg5ZDc2ODc4ZWMxZDZlYjUzODNjYjZhY2NmNTkz
M2YzNWUxYmIxYS4xMzcxMDk3Mzk2LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogV2VkLCAxMiBKdW4g
MjAxMyAxMjowNTo0OCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IHRlZ3JhOiBjcmVh
dGUgQ09ORklHX0FSTV9URUdSQV9DUFVGUkVRCgpjdXJyZW50bHkgVGVncmEgY3B1ZnJlcSBkcml2
ZXIgZ2V0cyBidWlsdCBiYXNlZCBvbiBBUkNIX1RFR1JBLCB3aGljaCBkb2Vzbid0CmRlcGVuZCBv
biBub3Igc2VsZWN0IENQVV9GUkVRIGl0c2VsZiwgc286CgogICAgICAgIHNlbGVjdCBDUFVfRlJF
UV9UQUJMRSBpZiBDUFVfRlJFUQoKLi4uIGlzbid0IGd1YXJhbnRlZWQgdG8gZmlyZS4KClRoZSBj
b3JyZWN0IHNvbHV0aW9uIHNlZW1zIHRvIGJlOgoKKiBBZGQgQ09ORklHX0FSTV9URUdSQV9DUFVG
UkVRIHRvIGRyaXZlcnMvY3B1ZnJlcS9LY29uZmlnLmFybS4KKiBNYWtlIHRoYXQgS2NvbmZpZyBv
cHRpb24gc2VsY3QgQ1BVX0ZSRVFfVEFCTEUuCiogTWFrZSB0aGF0IEtjb25maWcgb3B0aW9uIGJl
IGRlZl9ib29sIEFSQ0hfVEVHUkEuCiogTW9kaWZ5IGRyaXZlcnMvY3B1ZnJlcS9NYWtlZmlsZSB0
byBidWlsZCB0ZWdyYS1jcHVmcmVxLmMgYmFzZWQgb24gdGhhdC4KKiBSZW1vdmUgYWxsIHRoZSBj
cHVmcmVxLXJlbGF0ZWQgc3R1ZmYgZnJvbSBhcmNoL2FybS9tYWNoLXRlZ3JhL0tjb25maWcuCgpU
aGF0IHdheSwgdGVncmEtY3B1ZnJlcS5jIGNhbid0IGJlIGJ1aWx0IGlmICFDUFVfRlJFUSwgYW5k
IFRlZ3JhJ3MKY3B1ZnJlcSB3b3JrcyB0aGUgc2FtZSB3YXkgYXMgYWxsIHRoZSBvdGhlciBjcHVm
cmVxIGRyaXZlcnMuCgpUaGlzIHBhdGNoIGRvZXMgaXQuCgpTdWdnZXN0ZWQtYnk6IFN0ZXBoZW4g
V2FycmVuIDxzd2FycmVuQG52aWRpYS5jb20+CkFja2VkLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5k
QGFybmRiLmRlPgpTaWduZWQtb2ZmLWJ5OiBWaXJlc2ggS3VtYXIgPHZpcmVzaC5rdW1hckBsaW5h
cm8ub3JnPgotLS0KIGFyY2gvYXJtL21hY2gtdGVncmEvS2NvbmZpZyB8IDMgLS0tCiBkcml2ZXJz
L2NwdWZyZXEvS2NvbmZpZy5hcm0gfCA4ICsrKysrKysrCiBkcml2ZXJzL2NwdWZyZXEvTWFrZWZp
bGUgICAgfCAyICstCiAzIGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2FybS9tYWNoLXRlZ3JhL0tjb25maWcgYi9hcmNoL2Fy
bS9tYWNoLXRlZ3JhL0tjb25maWcKaW5kZXggODRkNzJmYy4uNWMwZGIwNiAxMDA2NDQKLS0tIGEv
YXJjaC9hcm0vbWFjaC10ZWdyYS9LY29uZmlnCisrKyBiL2FyY2gvYXJtL21hY2gtdGVncmEvS2Nv
bmZpZwpAQCAtMjgsNyArMjgsNiBAQCBjb25maWcgQVJDSF9URUdSQV8yeF9TT0MKIAlzZWxlY3Qg
QVJNX0VSUkFUQV83NTQzMjcgaWYgU01QCiAJc2VsZWN0IEFSTV9FUlJBVEFfNzY0MzY5IGlmIFNN
UAogCXNlbGVjdCBBUk1fR0lDCi0Jc2VsZWN0IENQVV9GUkVRX1RBQkxFIGlmIENQVV9GUkVRCiAJ
c2VsZWN0IENQVV9WNwogCXNlbGVjdCBQSU5DVFJMCiAJc2VsZWN0IFBJTkNUUkxfVEVHUkEyMApA
QCAtNDYsNyArNDUsNiBAQCBjb25maWcgQVJDSF9URUdSQV8zeF9TT0MKIAlzZWxlY3QgQVJNX0VS
UkFUQV83NTQzMjIKIAlzZWxlY3QgQVJNX0VSUkFUQV83NjQzNjkgaWYgU01QCiAJc2VsZWN0IEFS
TV9HSUMKLQlzZWxlY3QgQ1BVX0ZSRVFfVEFCTEUgaWYgQ1BVX0ZSRVEKIAlzZWxlY3QgQ1BVX1Y3
CiAJc2VsZWN0IFBJTkNUUkwKIAlzZWxlY3QgUElOQ1RSTF9URUdSQTMwCkBAIC02Myw3ICs2MSw2
IEBAIGNvbmZpZyBBUkNIX1RFR1JBXzExNF9TT0MKIAlzZWxlY3QgQVJNX0FSQ0hfVElNRVIKIAlz
ZWxlY3QgQVJNX0dJQwogCXNlbGVjdCBBUk1fTDFfQ0FDSEVfU0hJRlRfNgotCXNlbGVjdCBDUFVf
RlJFUV9UQUJMRSBpZiBDUFVfRlJFUQogCXNlbGVjdCBDUFVfVjcKIAlzZWxlY3QgUElOQ1RSTAog
CXNlbGVjdCBQSU5DVFJMX1RFR1JBMTE0CmRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvS2Nv
bmZpZy5hcm0gYi9kcml2ZXJzL2NwdWZyZXEvS2NvbmZpZy5hcm0KaW5kZXggZDUyMjYxYi4uNTA4
NTQyNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVxL0tjb25maWcuYXJtCisrKyBiL2RyaXZl
cnMvY3B1ZnJlcS9LY29uZmlnLmFybQpAQCAtMTU0LDMgKzE1NCwxMSBAQCBjb25maWcgQVJNX1NQ
RUFSX0NQVUZSRVEKIAlkZWZhdWx0IHkKIAloZWxwCiAJICBUaGlzIGFkZHMgdGhlIENQVUZyZXEg
ZHJpdmVyIHN1cHBvcnQgZm9yIFNQRUFyIFNPQ3MuCisKK2NvbmZpZyBBUk1fVEVHUkFfQ1BVRlJF
UQorCWJvb2wgIlRFR1JBIENQVUZyZXEgc3VwcG9ydCIKKwlkZXBlbmRzIG9uIEFSQ0hfVEVHUkEK
KwlzZWxlY3QgQ1BVX0ZSRVFfVEFCTEUKKwlkZWZhdWx0IHkKKwloZWxwCisJICBUaGlzIGFkZHMg
dGhlIENQVUZyZXEgZHJpdmVyIHN1cHBvcnQgZm9yIFRFR1JBIFNPQ3MuCmRpZmYgLS1naXQgYS9k
cml2ZXJzL2NwdWZyZXEvTWFrZWZpbGUgYi9kcml2ZXJzL2NwdWZyZXEvTWFrZWZpbGUKaW5kZXgg
MTNjM2Y4My4uOWM4NzNlNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVxL01ha2VmaWxlCisr
KyBiL2RyaXZlcnMvY3B1ZnJlcS9NYWtlZmlsZQpAQCAtNzEsNyArNzEsNyBAQCBvYmotJChDT05G
SUdfQVJNX1M1UFYyMTBfQ1BVRlJFUSkJKz0gczVwdjIxMC1jcHVmcmVxLm8KIG9iai0kKENPTkZJ
R19BUk1fU0ExMTAwX0NQVUZSRVEpCSs9IHNhMTEwMC1jcHVmcmVxLm8KIG9iai0kKENPTkZJR19B
Uk1fU0ExMTEwX0NQVUZSRVEpCSs9IHNhMTExMC1jcHVmcmVxLm8KIG9iai0kKENPTkZJR19BUk1f
U1BFQVJfQ1BVRlJFUSkJCSs9IHNwZWFyLWNwdWZyZXEubwotb2JqLSQoQ09ORklHX0FSQ0hfVEVH
UkEpCQkrPSB0ZWdyYS1jcHVmcmVxLm8KK29iai0kKENPTkZJR19BUk1fVEVHUkFfQ1BVRlJFUSkJ
CSs9IHRlZ3JhLWNwdWZyZXEubwogCiAjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCiAjIFBvd2Vy
UEMgcGxhdGZvcm0gZHJpdmVycwotLSAKMS43LjEyLnJjMi4xOC5nNjFiNDcyZQoK
--089e013a032af0e29504df017fc8--
