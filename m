Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbaDRPhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:37:10 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55997 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaDRPhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:37:07 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <5350EFAA.2030607@colorfullife.com>
References: <1397784345.2556.26.camel@buesod1.americas.hpqcorp.net> <5350EFAA.2030607@colorfullife.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 18 Apr 2014 17:36:46 +0200
Message-ID: <CAKgNAkhY94Y5Nut9+Jj1gcnio81CEmE5sQL_gH_zFnHD-yNx2Q@mail.gmail.com>
Subject: Re: [PATCH v3] ipc,shm: disable shmmax and shmall by default
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 11:26 AM, Manfred Spraul
<manfred@colorfullife.com> wrote:
> Hi Davidlohr,
>
>
> On 04/18/2014 03:25 AM, Davidlohr Bueso wrote:
>>
>> So a value of 0 bytes or pages, for shmmax and shmall, respectively,
>> implies unlimited memory, as opposed to disabling sysv shared memory.
>
> That might be a second risk:
> Right now, a sysadmin can prevent sysv memory allocations with
>
>     # sysctl kernel.shmall=0
>
> After your patch is applied, this line allows unlimited allocations.

Good point. I wonder if some folk may get bitten by this complete
reversal the semantics of shmall==0.

> Obviously my patch has the opposite problem: 64-bit wrap-arounds.

I know you alluded to a case in another thread, but I couldn't quite
work out from the mail you referred to whether this was really the
problem. (And I assume those folks were forced to fix their set-up
scripts anyway.) So, it's not clear to me whether this is a real
problem. (And your patch does not worsen things from the current
situation, right?)

Cheers,

Michael



>> --- a/include/uapi/linux/shm.h
>> +++ b/include/uapi/linux/shm.h
>> @@ -9,14 +9,14 @@
>>     /*
>>    * SHMMAX, SHMMNI and SHMALL are upper limits are defaults which can
>> - * be increased by sysctl
>> + * be modified by sysctl. By default, disable SHMMAX and SHMALL with
>> + * 0 bytes, thus allowing processes to have unlimited shared memory.
>>    */
>> -
>> -#define SHMMAX 0x2000000                /* max shared seg size (bytes) */
>> +#define SHMMAX 0                        /* max shared seg size (bytes) */
>>   #define SHMMIN 1                       /* min shared seg size (bytes) */
>>   #define SHMMNI 4096                    /* max num of segs system wide */
>>   #ifndef __KERNEL__
>> -#define SHMALL (SHMMAX/getpagesize()*(SHMMNI/16))
>> +#define SHMALL 0
>>   #endif
>>   #define SHMSEG SHMMNI                  /* max shared segs per process */
>>
>
> The "#ifndef __KERNEL__" is not required:
> As there is no reference to PAGE_SIZE anymore, one definition for SHMALL is
> sufficient.
>
>
> --
>     Manfred



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
