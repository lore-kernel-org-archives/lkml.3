Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaA0GNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 01:13:43 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41926 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaA0GNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 01:13:41 -0500
Message-ID: <52E5F90C.3000400@linaro.org>
Date: Mon, 27 Jan 2014 15:13:32 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>, Will Deacon <Will.Deacon@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v2 5/6] arm64: audit: Add makefile rule to create unistd_32.h
 for compat syscalls
References: <1389946399-4525-1-git-send-email-takahiro.akashi@linaro.org> <1389946399-4525-6-git-send-email-takahiro.akashi@linaro.org> <20140123145351.GF27520@arm.com>
In-Reply-To: <20140123145351.GF27520@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin,

On 01/23/2014 11:53 PM, Catalin Marinas wrote:
> On Fri, Jan 17, 2014 at 08:13:18AM +0000, AKASHI Takahiro wrote:
>> generic compat sycall audit (lib/compat_audit.c) requires unistd_32.h
>> for __NR_xyx compat syscall numbers. This is a different file from unistd32.h
>> on arm64 and so it must be generated from unistd32.h.
>>
>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> ---
>>   arch/arm64/Makefile                 |    4 ++++
>>   arch/arm64/kernel/syscalls/Makefile |   20 ++++++++++++++++++++
>>   2 files changed, 24 insertions(+)
>>   create mode 100644 arch/arm64/kernel/syscalls/Makefile
>>
>> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
>> index 2fceb71..6d24f92 100644
>> --- a/arch/arm64/Makefile
>> +++ b/arch/arm64/Makefile
>> @@ -72,6 +72,10 @@ PHONY += vdso_install
>>   vdso_install:
>>   	$(Q)$(MAKE) $(build)=arch/arm64/kernel/vdso $@
>>
>> +# Compat syscall header generation
>> +archheaders:
>> +	$(Q)$(MAKE) $(build)=arch/arm64/kernel/syscalls $@
>
> See my other post to the lib/compat_audit.c file. I think that's too
> complex for what you need.

Generation script is getting more complexed than I assumed at first
because some of system call names are a bit inconsistent with native 32-bit
system calls, for example, fchown16 vs. fchown, fchown vs. fchown32.

Now my tentative sed script looks like:
+quiet_cmd_syshdr = SYSHDR $@
+        cmd_syshdr = cat $< | sed -r \
+        -e 's/compat_//' \
+        -e 's/_wrapper//' \
+        -e 's/(sys_[fl]?chown)(\))/\132\)/' \
+        -e 's/(sys_[gs]et)(|e|fs|re|res)(uid\))/\1\2uid32\)/' \
+        -e 's/(sys_[gs]et)(|e|fs|re|res)(gid\))/\1\2gid32\)/' \
+        -e 's/(sys_[gs]etgroups)(\))/\132\)/' \
+        -e 's/(sys_new)(.*)/sys_\2/' \
+        -e 's/sys_mmap_pgoff/sys_mmap2/' \
+        -e 's/(sys_[_a-z]*)16(.*)/\1\2/' \
+        -e 's/^__SYSCALL\((.*),[ ]*sys_([^)].*)\).*/\#define __NR_\2 \1/p;d' \
+        | grep -v __NR_ni_syscall > $@

So, yeah, I agree with you now.

-Takahiro AKASHI
