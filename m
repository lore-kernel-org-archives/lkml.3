Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbbACDob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 22:44:31 -0500
Received: from out114-136.biz.mail.alibaba.com ([205.204.114.136]:60307 "EHLO
	out21.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750839AbbACDoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 22:44:30 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.06422378|-1;FP=0|0|0|0|0|-1|-1|-1;HT=r41g03014;MF=gang.chen@sunrus.com.cn;PH=DS;RN=6;RT=6;SR=0;
Message-ID: <54A76584.6020700@sunrus.com.cn>
Date: Sat, 03 Jan 2015 11:44:04 +0800
From: Chen Gang <gang.chen@sunrus.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: schwidefsky@de.ibm.com, linux390@de.ibm.com, holzheu@linux.vnet.ibm.com,
        linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] s390: include: timex: Use macro CLOCK_STORE_SIZE instead
 of hard code number
References: <54A55954.6000002@sunrus.com.cn> <20150102094625.GA4059@osiris>
In-Reply-To: <20150102094625.GA4059@osiris>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you for your work.

In honest, originally, I was not sure whether it would cause bug (do not
know gcc would generic incorrect code for it). :-)

Thanks.

On 01/02/2015 05:46 PM, Heiko Carstens wrote:
> On Thu, Jan 01, 2015 at 10:27:32PM +0800, Chen Gang wrote:
>> For C language, it treats array parameter as a pointer, so sizeof for an
>> array parameter is equal to sizeof for a pointer, which causes compiler
>> warning (with allmodconfig by gcc 5):
>>
>>     CC      arch/s390/kernel/asm-offsets.s
>>   In file included from include/linux/timex.h:65:0,
>>                    from include/linux/sched.h:19,
>>                    from include/linux/kvm_host.h:15,
>>                    from arch/s390/kernel/asm-offsets.c:10:
>>   ./arch/s390/include/asm/timex.h: In function 'get_tod_clock_ext':
>>   ./arch/s390/include/asm/timex.h:76:32: warning: 'sizeof' on array function parameter 'clk' will return size of 'char *' [-Wsizeof-array-argument]
>>     typedef struct { char _[sizeof(clk)]; } addrtype;
>>                                   ^
>>
>> Can use macro CLOCK_STORE_SIZE instead of all related hard code numbers,
>> which also can avoid this warning. And also add a tab to CLOCK_TICK_RATE
>> definition to match coding styles.
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> 
> Thanks. I applied the slightly changed version below.
> 
>>From 77e1e6fd8f5ce0d96c035056f9e963ca7d9198b2 Mon Sep 17 00:00:00 2001
> From: Chen Gang <gang.chen@sunrus.com.cn>
> Date: Thu, 1 Jan 2015 22:27:32 +0800
> Subject: [PATCH] s390/timex: fix get_tod_clock_ext() inline assembly
> 
> For C language, it treats array parameter as a pointer, so sizeof for an
> array parameter is equal to sizeof for a pointer, which causes compiler
> warning (with allmodconfig by gcc 5):
> 
>   ./arch/s390/include/asm/timex.h: In function 'get_tod_clock_ext':
>   ./arch/s390/include/asm/timex.h:76:32: warning: 'sizeof' on array function parameter 'clk' will return size of 'char *' [-Wsizeof-array-argument]
>     typedef struct { char _[sizeof(clk)]; } addrtype;
>                                   ^
> Can use macro CLOCK_STORE_SIZE instead of all related hard code numbers,
> which also can avoid this warning. And also add a tab to CLOCK_TICK_RATE
> definition to match coding styles.
> 
> [heiko.carstens@de.ibm.com]:
> Chen's patch actually fixes a bug within the get_tod_clock_ext() inline assembly
> where we incorrectly tell the compiler that only 8 bytes of memory get changed
> instead of 16 bytes.
> This would allow gcc to generate incorrect code. Right now this doesn't seem to
> be the case.
> Also slightly changed the patch a bit.
> - renamed CLOCK_STORE_SIZE to STORE_CLOCK_SIZE
> - changed get_tod_clock_ext() to receive a char pointer parameter
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  arch/s390/hypfs/hypfs_vm.c    |  2 +-
>  arch/s390/include/asm/timex.h | 10 ++++++----
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/hypfs/hypfs_vm.c b/arch/s390/hypfs/hypfs_vm.c
> index 32040ace00ea..99a3e6b395ab 100644
> --- a/arch/s390/hypfs/hypfs_vm.c
> +++ b/arch/s390/hypfs/hypfs_vm.c
> @@ -231,7 +231,7 @@ failed:
>  struct dbfs_d2fc_hdr {
>  	u64	len;		/* Length of d2fc buffer without header */
>  	u16	version;	/* Version of header */
> -	char	tod_ext[16];	/* TOD clock for d2fc */
> +	char	tod_ext[STORE_CLOCK_SIZE]; /* TOD clock for d2fc */
>  	u64	count;		/* Number of VM guests in d2fc buffer */
>  	char	reserved[30];
>  } __attribute__ ((packed));
> diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
> index 8beee1cceba4..582be106ab4a 100644
> --- a/arch/s390/include/asm/timex.h
> +++ b/arch/s390/include/asm/timex.h
> @@ -67,20 +67,22 @@ static inline void local_tick_enable(unsigned long long comp)
>  	set_clock_comparator(S390_lowcore.clock_comparator);
>  }
>  
> -#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
> +#define CLOCK_TICK_RATE		1193180 /* Underlying HZ */
> +#define STORE_CLOCK_SIZE	16	/* number of bytes store clock writes */
>  
>  typedef unsigned long long cycles_t;
>  
> -static inline void get_tod_clock_ext(char clk[16])
> +static inline void get_tod_clock_ext(char *clk)
>  {
> -	typedef struct { char _[sizeof(clk)]; } addrtype;
> +	typedef struct { char _[STORE_CLOCK_SIZE]; } addrtype;
>  
>  	asm volatile("stcke %0" : "=Q" (*(addrtype *) clk) : : "cc");
>  }
>  
>  static inline unsigned long long get_tod_clock(void)
>  {
> -	unsigned char clk[16];
> +	unsigned char clk[STORE_CLOCK_SIZE];
> +
>  	get_tod_clock_ext(clk);
>  	return *((unsigned long long *)&clk[1]);
>  }
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
