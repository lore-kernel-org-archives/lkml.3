Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbbAFLLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:11:41 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53447 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbbAFLLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:11:38 -0500
Message-ID: <54ABC2CB.6@linaro.org>
Date: Tue, 06 Jan 2015 19:11:07 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "Kangkang.Shen@huawei.com" <Kangkang.Shen@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH v5 18/18] Documentation: ACPI for ARM64
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <1413553034-20956-19-git-send-email-hanjun.guo@linaro.org> <20141224171815.GD13399@e104818-lin.cambridge.arm.com> <54A90A4C.60908@linaro.org> <20150105110533.GA14967@e104818-lin.cambridge.arm.com>
In-Reply-To: <20150105110533.GA14967@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015年01月05日 19:05, Catalin Marinas wrote:
> On Sun, Jan 04, 2015 at 09:39:24AM +0000, Hanjun Guo wrote:
>> On 2014年12月25日 01:18, Catalin Marinas wrote:
>> [...]
>>>
>>> In addition to the above and _DSD requirements/banning, I would also add
>>> some clear statements around:
>>>
>>> _OSC: only global/published capabilities are allowed. For
>>> device-specific _OSC we need a process or maybe we can ban them entirely
>>> and rely on _DSD once we clarify the process.
>>>
>>> _OSI: firmware must not check for certain _OSI strings. Here I'm not
>>> sure what we would have to do for ARM Linux. Reporting "Windows" does
>>> not make any sense but not reporting anything can, as Matthew Garrett
>>> pointed out, can be interpreted by firmware as "Linux". In addition to
>>> any statements in this document, I suggest you patch
>>> drivers/acpi/acpica/utosi.c accordingly, maybe report "Linux" for ARM
>>> and print a kernel warning so that we notice earlier.
>>>
>>> ACPI_OS_NAME: this is globally defined as "Microsoft Windows NT". It
>>> doesn't make much sense in the ARM context. Could we change it to
>>> "Linux" when CONFIG_ARM64?

I think we can introduce a Kconfig such as CONFIG_ACPI_OS_NAME_LINUX,
selected by ARM64 and change ACPI_OS_NAME to "Linux" when
CONFIG_ACPI_OS_NAME_LINUX defined. (we can not add CONFIG_ARM64 in
ACPICA code directly since it will be used by windows too)

some code like below:

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b1f9a20..de567a3 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1,5 +1,6 @@
  config ARM64
         def_bool y
+       select ACPI_OS_NAME_LINUX if ACPI
         select ARCH_BINFMT_ELF_RANDOMIZE_PIE
         select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
         select ARCH_HAS_GCOV_PROFILE_ALL
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 8951cef..11a10ac 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -369,6 +369,10 @@ config ACPI_REDUCED_HARDWARE_ONLY

           If you are unsure what to do, do not enable this option.

+config ACPI_OS_NAME_LINUX
+       bool "Using Linux for _OS method" if EXPERT
+       def_bool n
+
  source "drivers/acpi/apei/Kconfig"

  config ACPI_EXTLOG
diff --git a/include/acpi/acconfig.h b/include/acpi/acconfig.h
index 5a0a3e5..db5e13e 100644
--- a/include/acpi/acconfig.h
+++ b/include/acpi/acconfig.h
@@ -69,7 +69,11 @@
   * code that will not execute the _OSI method unless _OS matches the 
string
   * below.  Therefore, change this string at your own risk.
   */
+#ifndef ACPI_OS_NAME_USING_LINUX
  #define ACPI_OS_NAME                    "Microsoft Windows NT"
+#else
+#define ACPI_OS_NAME                    "Linux"
+#endif

  /* Maximum objects in the various object caches */

diff --git a/include/acpi/platform/aclinux.h 
b/include/acpi/platform/aclinux.h
index 1ba7c19..45d51d2 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -69,6 +69,10 @@
  #define ACPI_REDUCED_HARDWARE 1
  #endif

+#ifdef CONFIG_ACPI_OS_NAME_LINUX
+#define ACPI_OS_NAME_USING_LINUX 1
+#endif
+
  #include <linux/string.h>
  #include <linux/kernel.h>
  #include <linux/ctype.h>

>>
>> We will work on this both on ASWG and linux ACPI driver side, as Dong
>> and Charles pointed out, _OSI things can be solved in ACPI spec, when
>> that is done, we can modify the kernel driver to fix the problems above.
>
> Which driver?

the ACPICA core driver as you suggested, sorry for the confusion.

>
> What about ACPI_OS_NAME? Would you suggest it is fine to report
> "Microsoft Windows NT" on an ARM system? That _OS_ not _OSI.

No, not at all. I prefer "Linux"
In include/acpi/acconfig.h, when ACPI_OS_NAME defined, it says:
"OS name, used for the _OS object.  The _OS object is essentially
obsolete,..."
for some legacy reasons, we needed  "Microsoft Windows NT", but ACPI
for ARM64 on linux is totally new, I think we can change it to
"Linux" when CONFIG_ARM64 as you suggested.

Thanks
Hanjun
