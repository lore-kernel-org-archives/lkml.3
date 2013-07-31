Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab3GaBpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 21:45:43 -0400
Received: from intranet.asianux.com ([58.214.24.6]:63204 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3GaBpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 21:45:42 -0400
X-Spam-Score: -100.8
Message-ID: <51F86C08.3080805@asianux.com>
Date: Wed, 31 Jul 2013 09:44:40 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "'Jiri Kosina'" <trivial@kernel.org>, jaharkes@cs.cmu.edu, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] include/linux/coda.h: remove useless '#else'
References: <51F76B7D.2090602@asianux.com> <1375187380.2075.111.camel@joe-AO722>
In-Reply-To: <1375187380.2075.111.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 08:29 PM, Joe Perches wrote:
> On Tue, 2013-07-30 at 15:30 +0800, Chen Gang wrote:
>> '#else' is useless, need remove.
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  include/linux/coda.h |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/coda.h b/include/linux/coda.h
>> index cff544f..d30209b 100644
>> --- a/include/linux/coda.h
>> +++ b/include/linux/coda.h
>> @@ -60,7 +60,6 @@ Mellon the rights to redistribute these changes without encumbrance.
>>  
>>  #if defined(__linux__)
>>  typedef unsigned long long u_quad_t;
>> -#else
>>  #endif
>>  #include <uapi/linux/coda.h>
>>  #endif 
> 
> Why have the #if at all?
> 
> 
> 

Hmm... some old version compilers do not define __linux__ automatically
(e.g. or32-linux-gcc 4.5.1-or32-1.0rc1, which is the latest cross
compiler for openrisc, though).

If not define __linux__, the compiler will report error (u_quad_t is
not defined).

When we remove "#if defined(__linux__)" from "include/linux/coda.h",
the compiler will not report error, and 'cdev_t' will be defined as
'dev_t', not 'u_quad_t' (I guess, it is an implicit bug).


In "uapi/include/*", only "coda.h" has "#if defined(__linux__)", maybe
they want multiple OS can share the same "coda.h" file (at least, we
can not say it is a bad idea).

Neither suitable to define __linux__ in "include/linux/coda.h".


All together, I think:

  the direct cause:
    "uapi/include/coda.h" wants to share itself for multiple OS (so they need check __linux__).
      (in "uapi/include/*", only coda.h need check __linux__)

  the root cause:
    the compiler for linux should define __linux__ automatically, the latest version of gcc has done, but some of the old version is not.
    most of cross compilers have merged their code into gcc main tree, but still left some (e.g. openrisc).
      (at least, I can not build openrisc from gcc main tree correctly, but most of others can)
    some of latest cross compilers still use old version of gcc, (still not define __linux__ automatically).


The related code in "uapi/linux/coda.h" is below:

-------------------------------code begin-------------------------------

 73 #if defined(DJGPP) || defined(__CYGWIN32__)
 74 #ifdef KERNEL
 75 typedef unsigned long u_long;
 76 typedef unsigned int u_int;
 77 typedef unsigned short u_short;
 78 typedef u_long ino_t;
 79 typedef u_long dev_t;
 80 typedef void * caddr_t;
 81 #ifdef DOS
 82 typedef unsigned __int64 u_quad_t;
 83 #else
 84 typedef unsigned long long u_quad_t;
 85 #endif
 86 
 87 #define inline
 88 
 89 struct timespec {
 90         long       ts_sec;
 91         long       ts_nsec;
 92 };
 93 #else  /* DJGPP but not KERNEL */
 94 #include <sys/time.h>
 95 typedef unsigned long long u_quad_t;
 96 #endif /* !KERNEL */
 97 #endif /* !DJGPP */
 98 
 99 
100 #if defined(__linux__)
101 #include <linux/time.h>
102 #define cdev_t u_quad_t
103 #ifndef __KERNEL__
104 #if !defined(_UQUAD_T_) && (!defined(__GLIBC__) || __GLIBC__ < 2)
105 #define _UQUAD_T_ 1
106 typedef unsigned long long u_quad_t;
107 #endif
108 #endif /* __KERNEL__ */
109 #else
110 #define cdev_t dev_t
111 #endif
112 

-------------------------------code end---------------------------------


Thanks.
-- 
Chen Gang
