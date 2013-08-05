Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3HEAZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 20:25:17 -0400
Received: from intranet.asianux.com ([58.214.24.6]:54783 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab3HEAZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 20:25:15 -0400
X-Spam-Score: -100.8
Message-ID: <51FEF0AC.8040804@asianux.com>
Date: Mon, 05 Aug 2013 08:24:12 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
CC: Joe Perches <joe@perches.com>, "'Jiri Kosina'" <trivial@kernel.org>,
        jaharkes@cs.cmu.edu, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] include/linux/coda.h: remove useless '#else'
References: <51F76B7D.2090602@asianux.com> <1375187380.2075.111.camel@joe-AO722> <51F86C08.3080805@asianux.com> <51F86E1A.60404@asianux.com> <51F8818C.7030703@gmail.com>
In-Reply-To: <51F8818C.7030703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 11:16 AM, Chen Gang F T wrote:
> On 07/31/2013 09:53 AM, Chen Gang wrote:
>> On 07/31/2013 09:44 AM, Chen Gang wrote:
>>> On 07/30/2013 08:29 PM, Joe Perches wrote:
>>>> On Tue, 2013-07-30 at 15:30 +0800, Chen Gang wrote:
>>>>> '#else' is useless, need remove.
>>>>>
>>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>>> ---
>>>>>  include/linux/coda.h |    1 -
>>>>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/coda.h b/include/linux/coda.h
>>>>> index cff544f..d30209b 100644
>>>>> --- a/include/linux/coda.h
>>>>> +++ b/include/linux/coda.h
>>>>> @@ -60,7 +60,6 @@ Mellon the rights to redistribute these changes without encumbrance.
>>>>>  
>>>>>  #if defined(__linux__)
>>>>>  typedef unsigned long long u_quad_t;
>>>>> -#else
>>>>>  #endif
>>>>>  #include <uapi/linux/coda.h>
>>>>>  #endif 
>>>>
>>>> Why have the #if at all?
>>>>

Hmm... if any members have some questions about the fix, commonly it
means the related fix need additional improvement.

Is it better to use BUILD_BUG() for the fix ?  e.g. the diff may like
below (based on the applied patch):

-----------------------------diff begin----------------------------

diff --git a/include/linux/coda.h b/include/linux/coda.h
index d30209b..5f87d5d 100644
--- a/include/linux/coda.h
+++ b/include/linux/coda.h
@@ -60,6 +60,11 @@ Mellon the rights to redistribute these changes without encumbrance.
 
 #if defined(__linux__)
 typedef unsigned long long u_quad_t;
-#endif
+#else
+#include <linux/bug.h>
+BUILD_BUG();
+#endif /* !__linux__ */
+
 #include <uapi/linux/coda.h>
+
 #endif 

-----------------------------diff end------------------------------


Thanks.


>>>>
>>>>
>>>
> 
> OH, sorry, what I said about openrisc cross-compiler is not precise.
> 
> Need a patch for openrisc (just like another architectures have done):
> 
> -------------------------------diff begin-------------------------------
> 
> diff --git a/arch/openrisc/Makefile b/arch/openrisc/Makefile
> index 4739b83..89076a6 100644
> --- a/arch/openrisc/Makefile
> +++ b/arch/openrisc/Makefile
> @@ -24,7 +24,7 @@ OBJCOPYFLAGS    := -O binary -R .note -R .comment -S
>  LDFLAGS_vmlinux :=
>  LIBGCC 		:= $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
>  
> -KBUILD_CFLAGS	+= -pipe -ffixed-r10
> +KBUILD_CFLAGS	+= -pipe -ffixed-r10 -D__linux__
>  
>  ifeq ($(CONFIG_OPENRISC_HAVE_INST_MUL),y)
>  	KBUILD_CFLAGS += $(call cc-option,-mhard-mul)
> 
> -------------------------------diff end---------------------------------
> 
> But for "include/linux/coda.h", I still suggest to check __linux__
> whether defined, at least it can find the building issues.
> 
> And next, I will send the related patch to openrisc mailing list.
> 
> :-)
> 
> Thanks.
> 
>>> Hmm... some old version compilers do not define __linux__ automatically
>>> (e.g. or32-linux-gcc 4.5.1-or32-1.0rc1, which is the latest cross
>>> compiler for openrisc, though).
>>>
>>> If not define __linux__, the compiler will report error (u_quad_t is
>>> not defined).
>>>
>>> When we remove "#if defined(__linux__)" from "include/linux/coda.h",
>>> the compiler will not report error, and 'cdev_t' will be defined as
>>> 'dev_t', not 'u_quad_t' (I guess, it is an implicit bug).
>>>
>>>
>>> In "uapi/include/*", only "coda.h" has "#if defined(__linux__)", maybe
>>> they want multiple OS can share the same "coda.h" file (at least, we
>>> can not say it is a bad idea).
>>>
>>> Neither suitable to define __linux__ in "include/linux/coda.h".
>>>
>>>
>>> All together, I think:
>>>
>>>   the direct cause:
>>>     "uapi/include/coda.h" wants to share itself for multiple OS (so they need check __linux__).
>>>       (in "uapi/include/*", only coda.h need check __linux__)
>>>
>>>   the root cause:
>>>     the compiler for linux should define __linux__ automatically, the latest version of gcc has done, but some of the old version is not.
>>>     most of cross compilers have merged their code into gcc main tree, but still left some (e.g. openrisc).
>>>       (at least, I can not build openrisc from gcc main tree correctly, but most of others can)
>>>     some of latest cross compilers still use old version of gcc, (still not define __linux__ automatically).
>>>
>>
>> Maybe what I said is incorrect (it is just my current understanding).
>>
>> Welcome any other members' suggestions or completions for discussing and
>> checking.
>>
>> Thanks.
>>
>>>
>>> The related code in "uapi/linux/coda.h" is below:
>>>
>>> -------------------------------code begin-------------------------------
>>>
>>>  73 #if defined(DJGPP) || defined(__CYGWIN32__)
>>>  74 #ifdef KERNEL
>>>  75 typedef unsigned long u_long;
>>>  76 typedef unsigned int u_int;
>>>  77 typedef unsigned short u_short;
>>>  78 typedef u_long ino_t;
>>>  79 typedef u_long dev_t;
>>>  80 typedef void * caddr_t;
>>>  81 #ifdef DOS
>>>  82 typedef unsigned __int64 u_quad_t;
>>>  83 #else
>>>  84 typedef unsigned long long u_quad_t;
>>>  85 #endif
>>>  86 
>>>  87 #define inline
>>>  88 
>>>  89 struct timespec {
>>>  90         long       ts_sec;
>>>  91         long       ts_nsec;
>>>  92 };
>>>  93 #else  /* DJGPP but not KERNEL */
>>>  94 #include <sys/time.h>
>>>  95 typedef unsigned long long u_quad_t;
>>>  96 #endif /* !KERNEL */
>>>  97 #endif /* !DJGPP */
>>>  98 
>>>  99 
>>> 100 #if defined(__linux__)
>>> 101 #include <linux/time.h>
>>> 102 #define cdev_t u_quad_t
>>> 103 #ifndef __KERNEL__
>>> 104 #if !defined(_UQUAD_T_) && (!defined(__GLIBC__) || __GLIBC__ < 2)
>>> 105 #define _UQUAD_T_ 1
>>> 106 typedef unsigned long long u_quad_t;
>>> 107 #endif
>>> 108 #endif /* __KERNEL__ */
>>> 109 #else
>>> 110 #define cdev_t dev_t
>>> 111 #endif
>>> 112 
>>>
>>> -------------------------------code end---------------------------------
>>>
>>>
>>> Thanks.
>>>
>>
>>
> 
> 


-- 
Chen Gang
