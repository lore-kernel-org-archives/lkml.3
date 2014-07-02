Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaGBHTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 03:19:35 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:22383 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaGBHTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 03:19:34 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ekfyrejs0ialTxoYXnIEza2FTPybMoi18A
X-RZG-CLASS-ID: mo00
Message-ID: <53B3B283.7050800@schoebel-theuer.de>
Date: Wed, 02 Jul 2014 09:19:31 +0200
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Thomas_Sch=F6bel-Theue?= =?ISO-8859-1?Q?r?= 
	<tst@1und1.de>
Subject: Re: [PATCH 49/50] mars: generic pre-patch for mars
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de> <1404251250-22992-50-git-send-email-tst@schoebel-theuer.de> <20140701223644.GA30330@kroah.com>
In-Reply-To: <20140701223644.GA30330@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will prepare a new version ASAP.

Is the asmlinkage one of the reasons?

If so, some additional wrappers like vfs_* or kernel_* would have to be
written. This would also complicate portability between the out-of-tree
and the in-tree version of MARS (which I have to maintain in parallel at
least for some years).

It would be great if I just could make the exports of sys_* explicitly.

Thanks and cheers,

Thomas

On 07/02/2014 12:36 AM, Greg KH wrote:
> On Tue, Jul 01, 2014 at 11:47:29PM +0200, Thomas Schoebel-Theuer wrote:
>> From: Thomas Schoebel-Theuer <schoebel@bell.site>
>>
>> Mostly introduces missing EXPORT_SYMBOL().
>> Should have no impact onto the kernel.
>>
>> This is the generic version which exports all sys_*() system
>> calls. This should not introduce any additional maintenance pain
>> because that interfaces has to be stable anyway due to POSIX etc.
>>
>> Signed-off-by: Thomas Schoebel-Theuer <schoebel@bell.site>
>> ---
>>  fs/open.c                  | 1 -
>>  fs/utimes.c                | 2 ++
>>  include/linux/syscalls.h   | 3 +++
>>  include/uapi/linux/major.h | 1 +
>>  mm/page_alloc.c            | 3 +++
>>  5 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/open.c b/fs/open.c
>> index 36662d0..3b21b76 100644
>> --- a/fs/open.c
>> +++ b/fs/open.c
>> @@ -1064,7 +1064,6 @@ SYSCALL_DEFINE1(close, unsigned int, fd)
>>  
>>  	return retval;
>>  }
>> -EXPORT_SYMBOL(sys_close);
>>  
>>  /*
>>   * This routine simulates a hangup on the tty, to arrange that users
>> diff --git a/fs/utimes.c b/fs/utimes.c
>> index aa138d6..4a1f4a8 100644
>> --- a/fs/utimes.c
>> +++ b/fs/utimes.c
>> @@ -1,3 +1,4 @@
>> +#include <linux/module.h>
>>  #include <linux/compiler.h>
>>  #include <linux/file.h>
>>  #include <linux/fs.h>
>> @@ -181,6 +182,7 @@ retry:
>>  out:
>>  	return error;
>>  }
>> +EXPORT_SYMBOL(do_utimes);
>>  
>>  SYSCALL_DEFINE4(utimensat, int, dfd, const char __user *, filename,
>>  		struct timespec __user *, utimes, int, flags)
>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>> index b0881a0..c674309 100644
>> --- a/include/linux/syscalls.h
>> +++ b/include/linux/syscalls.h
>> @@ -75,6 +75,7 @@ struct sigaltstack;
>>  #include <linux/sem.h>
>>  #include <asm/siginfo.h>
>>  #include <linux/unistd.h>
>> +#include <linux/export.h>
>>  #include <linux/quota.h>
>>  #include <linux/key.h>
>>  #include <trace/syscall.h>
>> @@ -176,6 +177,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>>  
>>  #define SYSCALL_DEFINE0(sname)					\
>>  	SYSCALL_METADATA(_##sname, 0);				\
>> +	EXPORT_SYMBOL(sys_##sname);				\
>>  	asmlinkage long sys_##sname(void)
>>  
>>  #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
>> @@ -202,6 +204,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>>  		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
>>  		return ret;						\
>>  	}								\
>> +	EXPORT_SYMBOL(sys##name);					\
>>  	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
>>  
> Heh, nice try, but no, we aren't going to export all syscalls, that's
> crazy.  And wrong on many levels, sorry.
>
> Be explicit with your exports, and justify _why_ you need them.
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

