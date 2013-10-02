Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3JBBSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:18:36 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61968 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3JBBSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:18:34 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-66-524b7468af0c
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Separate lbfd check out of NO_DEMANGLE condition
References: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
	<1380292332-6518-1-git-send-email-jolsa@redhat.com>
	<1380437526.1727.10.camel@leonhard>
Date: Wed, 02 Oct 2013 10:18:32 +0900
In-Reply-To: <1380437526.1727.10.camel@leonhard> (Namhyung Kim's message of
	"Sun, 29 Sep 2013 15:52:06 +0900")
Message-ID: <87d2noo4gn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sun, 29 Sep 2013 15:52:06 +0900, Namhyung Kim wrote:
> Hi Jiri,
>
> 2013-09-27 (금), 16:32 +0200, Jiri Olsa:
>> We fail build with NO_DEMANGLE with missing -lbfd externals error.
>> The reason is that we now use bfd code in srcline object:
>>   perf tools: Implement addr2line directly using libbfd
>> 
>> So we need to check/add -lbfd always now.
>> 
>> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
>> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>> Cc: David Ahern <dsahern@gmail.com>
>> ---
>>  tools/perf/config/Makefile | 17 ++++++++---------
>>  1 file changed, 8 insertions(+), 9 deletions(-)
>> 
>> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
>> index 8b49a00..40a41c6 100644
>> --- a/tools/perf/config/Makefile
>> +++ b/tools/perf/config/Makefile
>> @@ -360,6 +360,13 @@ else
>>    endif
>>  endif
>>  
>> +FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
>> +has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
>> +ifeq ($(has_bfd),y)
>> +  EXTLIBS += -lbfd
>> +  CFLAGS += -DLIBBFD_SUPPORT
>> +endif
>> +
>>  ifdef NO_DEMANGLE
>>    CFLAGS += -DNO_DEMANGLE
>>  else
>> @@ -367,11 +374,7 @@ else
>>      EXTLIBS += -liberty
>>      CFLAGS += -DHAVE_CPLUS_DEMANGLE
>>    else
>> -    FLAGS_BFD=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
>> -    has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
>> -    ifeq ($(has_bfd),y)
>> -      EXTLIBS += -lbfd
>> -    else
>> +    ifneq ($(has_bfd),y)
>>        FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
>>        has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
>>        ifeq ($(has_bfd_iberty),y)
>> @@ -397,10 +400,6 @@ else
>>    endif
>>  endif
>>  
>> -ifndef ($(filter -lbfd,$(EXTLIBS)),)
>> -  CFLAGS += -DLIBBFD_SUPPORT
>> -endif
>> -
>>  ifndef NO_STRLCPY
>>    ifeq ($(call try-cc,$(SOURCE_STRLCPY),,-DHAVE_STRLCPY),y)
>>      CFLAGS += -DHAVE_STRLCPY
>
> Is it enough to check on -lbfd only?  I guess libbfd can have additional
> dependencies to libiberty and libz.  If so, this patch can fail to set
> -DLIBBFD_SUPPORT, right?

I tested this on my system.  At first I guessed (without testing) it
cannot build SOURCE_BFD with -lbfd only due to additional -liberty and
-lz dependency, but it's not.  Actually the libfd.so is a plain text
file which contains linker script like this:

  $ file /lib64/libbfd.so
  /lib64/libbfd.so: ASCII text

  $ cat /lib64/libbfd.so
  /* GNU ld script */
  
  /* Ensure this .so library will not be used by a link for a different format
     on a multi-architecture system.  */
  OUTPUT_FORMAT(elf64-x86-64)
  
  /* The libz dependency is unexpected by legacy build scripts.  */
  INPUT ( /usr/lib64/libbfd.a -liberty -lz )


So it should handle external dependencies.  But it doesn't.

  $ cat bfd.c
  #include <bfd.h>
  
  int main(void)
  {
  	bfd_demangle(0, 0, 0);
  	return 0;
  }

  namhyung@sejong:tmp$ gcc bfd.c -lbfd
  /usr/lib64/libbfd.a(plugin.o): In function `try_load_plugin':
  (.text+0x1ab): undefined reference to `dlopen'
  /usr/lib64/libbfd.a(plugin.o): In function `try_load_plugin':
  (.text+0x1ca): undefined reference to `dlsym'
  /usr/lib64/libbfd.a(plugin.o): In function `try_load_plugin':
  (.text+0x263): undefined reference to `dlerror'
  collect2: error: ld returned 1 exit status


It seems that it needs libdl for loading plugins.  Adding -ldl makes
above build successfully.  So we need to add -ldl for EXTLIBS IMHO.
Without it, make NO_GTK2=1 NO_LIBPERL=1 NO_LIBPYTHON=1 will fail to
check libbfd correctly (FYI, libperl and libpython add -ldl to the
dependency list).

Thanks,
Namhyung
