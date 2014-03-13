Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaCMO6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:58:08 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:40080 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaCMO6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:58:06 -0400
Message-ID: <5321C776.30208@linaro.org>
Date: Thu, 13 Mar 2014 23:57:58 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 3/7] ftrace: Add arm64 support to recordmcount
References: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org> <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org> <1394705630-12384-4-git-send-email-takahiro.akashi@linaro.org> <20140313123819.GF12331@mudshark.cambridge.arm.com>
In-Reply-To: <20140313123819.GF12331@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 09:38 PM, Will Deacon wrote:
> On Thu, Mar 13, 2014 at 10:13:46AM +0000, AKASHI Takahiro wrote:
>> Recordmcount utility under scripts is run, after compiling each object,
>> to find out all the locations of calling _mcount() and put them into
>> specific seciton named __mcount_loc.
>> Then linker collects all such information into a table in the kernel image
>> (between __start_mcount_loc and __stop_mcount_loc) for later use by ftrace.
>>
>> This patch adds arm64 specific definitions to identify such locations.
>> There are two types of implementation, C and Perl. On arm64, only C version
>> is used to build the kernel now that CONFIG_HAVE_C_RECORDMCOUNT is on.
>> But Perl version is also maintained.
>>
>> This patch also contains a workaround just in case where a header file,
>> elf.h, on host machine doesn't have definitions of EM_AARCH64 nor
>> R_AARCH64_ABS64. Without them, compiling C version of recordmcount will
>> fail.
>
> [...]
>
>> diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
>> index 9c22317..047c8cd 100644
>> --- a/scripts/recordmcount.c
>> +++ b/scripts/recordmcount.c
>> @@ -40,6 +40,11 @@
>>   #define R_METAG_NONE                     3
>>   #endif
>>
>> +#ifndef EM_AARCH64
>> +#define EM_AARCH64	183
>> +#define R_AARCH64_ABS64	257
>> +#endif
>> +
>>   static int fd_map;	/* File descriptor for file being modified. */
>>   static int mmap_failed; /* Boolean flag. */
>>   static void *ehdr_curr; /* current ElfXX_Ehdr *  for resource cleanup */
>> @@ -347,6 +352,10 @@ do_file(char const *const fname)
>>   	case EM_ARM:	 reltype = R_ARM_ABS32;
>>   			 altmcount = "__gnu_mcount_nc";
>>   			 break;
>> +	case EM_AARCH64:
>> +			 reltype = R_AARCH64_ABS64;
>> +			 altmcount = "_mcount";
>
> Shouldn't you be setting gpfx = '_' instead of overriding altmcount like
> this?

Yep. Fix it.

>> +			 break;
>>   	case EM_IA_64:	 reltype = R_IA64_IMM64;   gpfx = '_'; break;
>>   	case EM_METAG:	 reltype = R_METAG_ADDR32;
>>   			 altmcount = "_mcount_wrapper";
>> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
>> index 91280b8..397b6b8 100755
>> --- a/scripts/recordmcount.pl
>> +++ b/scripts/recordmcount.pl
>> @@ -279,6 +279,11 @@ if ($arch eq "x86_64") {
>>       $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_ARM_(CALL|PC24|THM_CALL)" .
>>   			"\\s+(__gnu_mcount_nc|mcount)\$";
>>
>> +} elsif ($arch eq "arm64") {
>> +    $alignment = 3;
>> +    $section_type = '%progbits';
>> +    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_AARCH64_CALL26\\s+_mcount\$";
>
> What about "mcount" (i.e. no underscore)?

I don't think it works since such regex doesn't match to "CALL26   _mcount".

Thanks,
-Takahiro AKASHI

> Will
>
