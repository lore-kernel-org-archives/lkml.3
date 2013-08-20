Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab3HTO1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:27:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50960 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3HTO1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:27:13 -0400
Message-ID: <52137CD5.7010201@arm.com>
Date: Tue, 20 Aug 2013 15:27:33 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v3 4/6] ARM64: arch_timer: configure and enable event
 stream
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376414984-14182-5-git-send-email-Sudeep.KarkadaNagesha@arm.com> <20130820132712.GE26129@mudshark.cambridge.arm.com>
In-Reply-To: <20130820132712.GE26129@mudshark.cambridge.arm.com>
X-OriginalArrivalTime: 20 Aug 2013 14:27:10.0303 (UTC) FILETIME=[5B126EF0:01CE9DB1]
X-MC-Unique: 113082015271001701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/08/13 14:27, Will Deacon wrote:
> Hi Sudeep,
> 
> Couple of comments inline...
> 
> On Tue, Aug 13, 2013 at 06:29:42PM +0100, Sudeep KarkadaNagesha wrote:
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> This patch configures the event stream frequency and enables it.
>> It also adds the hwcaps as well as compat-specific definitions to
>> the user to detect this event stream feature.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>> Signed-off-by: Will Deacon <will.deacon@arm.com>
>> [sudeep: moving ARM/ARM64 changes into separate patches]
>> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>> ---
>>  arch/arm64/include/asm/arch_timer.h | 12 ++++++++++--
>>  arch/arm64/include/asm/hwcap.h      |  4 +++-
>>  arch/arm64/include/uapi/asm/hwcap.h |  1 +
>>  arch/arm64/kernel/setup.c           |  1 +
>>  4 files changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
>> index 69f5c8e..43f322a 100644
>> --- a/arch/arm64/include/asm/arch_timer.h
>> +++ b/arch/arm64/include/asm/arch_timer.h
>> @@ -106,14 +106,22 @@ static inline void arch_counter_set_user_access(int divider)
>>  	/* Disable user access to the timers and the physical counter. */
>>  	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
>>  			| ARCH_TIMER_USR_VT_ACCESS_EN
>> +			| ARCH_TIMER_EVT_TRIGGER_MASK
>>  			| ARCH_TIMER_USR_PCT_ACCESS_EN);
>>  
>> -	/* Enable user access to the virtual counter. */
>> -	cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
>> +	/* Enable event stream and user access to the virtual counter */
>> +	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
>> +			| ARCH_TIMER_VIRT_EVT_EN
>> +			| ARCH_TIMER_USR_VCT_ACCESS_EN;
>>  
>>  	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
>>  }
>>  
>> +static inline void arch_timer_set_hwcap_evtstrm(void)
>> +{
>> +	elf_hwcap |= HWCAP_EVTSTRM;
>> +}
>> +
>>  static inline u64 arch_counter_get_cntvct(void)
>>  {
>>  	u64 cval;
>> diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
>> index 6d4482f..effd8f9 100644
>> --- a/arch/arm64/include/asm/hwcap.h
>> +++ b/arch/arm64/include/asm/hwcap.h
>> @@ -30,6 +30,7 @@
>>  #define COMPAT_HWCAP_IDIVA	(1 << 17)
>>  #define COMPAT_HWCAP_IDIVT	(1 << 18)
>>  #define COMPAT_HWCAP_IDIV	(COMPAT_HWCAP_IDIVA|COMPAT_HWCAP_IDIVT)
>> +#define COMPAT_HWCAP_EVTSTRM	(1 << 21)
> 
> Looking at the context, we should also add COMPAT_HWCAP_LPAE as a separate
> patch (not part of this series).
> 
Ok make sense, I can do that. IIUC even this needs at least under some
config option, assuming can't be dynamic ?

>>  #ifndef __ASSEMBLY__
>>  /*
>> @@ -41,7 +42,8 @@
>>  				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
>>  				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_VFP|\
>>  				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
>> -				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV)
>> +				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV|\
>> +				 COMPAT_HWCAP_EVTSTRM)
> 
> So here you're hardcoding COMPAT_HWCAP_EVTSTRM in the COMPAT_ELF_HWCAP, yet
> we only enable the native one from the arch-timer driver. The question then is
> "Can we rely on the event-stream working for AArch64?". If so, we don't need
> the native hwcap at all. If not, then we need to make the compat hwcap
> dynamic.

How about something like this ? I am not sure if
arch/arm64/kernel/setup.c is apt place for compat_elf_hwcap though.

------>8--------

diff --git a/arch/arm64/include/asm/arch_timer.h
b/arch/arm64/include/asm/arch_timer.h
index 43f322a..a7d33a8 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -120,6 +120,9 @@ static inline void arch_counter_set_user_access(int
divider)
 static inline void arch_timer_set_hwcap_evtstrm(void)
 {
 	elf_hwcap |= HWCAP_EVTSTRM;
+#ifdef CONFIG_COMPAT
+	compat_elf_hwcap |= COMPAT_HWCAP_EVTSTRM;
+#endif
 }

 static inline u64 arch_counter_get_cntvct(void)
diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index effd8f9..9633db0 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -32,19 +32,24 @@
 #define COMPAT_HWCAP_IDIV	(COMPAT_HWCAP_IDIVA|COMPAT_HWCAP_IDIVT)
 #define COMPAT_HWCAP_EVTSTRM	(1 << 21)

+#define COMPAT_ELF_HWCAP_DEFAULT	\
+				(COMPAT_HWCAP_HALF|COMPAT_HWCAP_THUMB|\
+				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
+				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_VFP|\
+				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
+				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV)
 #ifndef __ASSEMBLY__
 /*
  * This yields a mask that user programs can use to figure out what
  * instruction set this cpu supports.
  */
 #define ELF_HWCAP		(elf_hwcap)
-#define COMPAT_ELF_HWCAP	(COMPAT_HWCAP_HALF|COMPAT_HWCAP_THUMB|\
-				 COMPAT_HWCAP_FAST_MULT|COMPAT_HWCAP_EDSP|\
-				 COMPAT_HWCAP_TLS|COMPAT_HWCAP_VFP|\
-				 COMPAT_HWCAP_VFPv3|COMPAT_HWCAP_VFPv4|\
-				 COMPAT_HWCAP_NEON|COMPAT_HWCAP_IDIV|\
-				 COMPAT_HWCAP_EVTSTRM)
-
 extern unsigned int elf_hwcap;
+
+#ifdef CONFIG_COMPAT
+#define COMPAT_ELF_HWCAP	(compat_elf_hwcap)
+extern unsigned int compat_elf_hwcap;
+#endif
+
 #endif
 #endif
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 1111833..990fc98 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -60,6 +60,11 @@ EXPORT_SYMBOL(processor_id);
 unsigned int elf_hwcap __read_mostly;
 EXPORT_SYMBOL_GPL(elf_hwcap);

+#ifdef CONFIG_COMPAT
+unsigned int compat_elf_hwcap __read_mostly = COMPAT_ELF_HWCAP_DEFAULT;
+EXPORT_SYMBOL_GPL(compat_elf_hwcap);
+#endif
+
 static const char *cpu_name;
 static const char *machine_name;
 phys_addr_t __fdt_pointer __initdata;



