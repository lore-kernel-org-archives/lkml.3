Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3FJUsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:48:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28074 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3FJUsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:48:02 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wskK765KtKEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=GqmPQ3klG2UA:10 a=xeeicz_pqYIpKvZC-tAA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370897278.9844.115.camel@gandalf.local.home>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, torvalds@linux-foundation.org
Date: Mon, 10 Jun 2013 16:47:58 -0400
In-Reply-To: <20130609193657.GA13392@linux.vnet.ibm.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-09 at 12:36 -0700, Paul E. McKenney wrote:

> --- a/arch/x86/include/asm/spinlock_types.h
> +++ b/arch/x86/include/asm/spinlock_types.h
> @@ -7,12 +7,18 @@
>  
>  #include <linux/types.h>
>  
> -#if (CONFIG_NR_CPUS < 256)
> +#if (CONFIG_NR_CPUS < 128)
>  typedef u8  __ticket_t;
>  typedef u16 __ticketpair_t;
> -#else
> +#define TICKET_T_CMP_GE(a, b) (UCHAR_MAX / 2 >= (unsigned char)((a) - (b)))
> +#elif (CONFIG_NR_CPUS < 32768)
>  typedef u16 __ticket_t;
>  typedef u32 __ticketpair_t;
> +#define TICKET_T_CMP_GE(a, b) (USHRT_MAX / 2 >= (unsigned short)((a) - (b)))
> +#else
> +typedef u32 __ticket_t;
> +typedef u64 __ticketpair_t;
> +#define TICKET_T_CMP_GE(a, b) (UINT_MAX / 2 >= (unsigned int)((a) - (b)))
>  #endif
>  
>  #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
> @@ -21,7 +27,11 @@ typedef struct arch_spinlock {
>  	union {
>  		__ticketpair_t head_tail;
>  		struct __raw_tickets {
> +#ifdef __BIG_ENDIAN__

Is there such a thing as a BIG_ENDIAN x86 box? This is in
arch/x86/include/asm/spinlock_types.h

-- Steve

> +			__ticket_t tail, head;
> +#else /* #ifdef __BIG_ENDIAN__ */
>  			__ticket_t head, tail;
> +#endif /* #else #ifdef __BIG_ENDIAN__ */
>  		} tickets;
>  	};
>  } arch_spinlock_t;


