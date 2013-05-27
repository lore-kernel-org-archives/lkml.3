Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3E0JhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:37:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:44200 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab3E0JhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:37:20 -0400
Message-ID: <1369647373.3557.25.camel@pasglop>
Subject: Re: [PATCH v3-resend 07/11] powerpc: uaccess
 s/might_sleep/might_fault/
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Date: Mon, 27 May 2013 19:36:13 +1000
In-Reply-To: <1369577426-26721-7-git-send-email-mst@redhat.com>
References: <1369575487-26176-1-git-send-email-mst@redhat.com>
	 <1369577426-26721-7-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-05-26 at 17:31 +0300, Michael S. Tsirkin wrote:
> The only reason uaccess routines might sleep
> is if they fault. Make this explicit.
> 
> Arnd Bergmann suggested that the following code
> 	if (!is_kernel_addr((unsigned long)__pu_addr))
> 		might_fault();
> can be further simplified by adding a version of might_fault
> that includes the kernel addr check.
> 
> Will be considered as a further optimization in future.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

As long as Peter is happy with the general semantics of might_fault()
and you have at least build-tested it, then I'm happy.

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
>  arch/powerpc/include/asm/uaccess.h | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
> index 4db4959..9485b43 100644
> --- a/arch/powerpc/include/asm/uaccess.h
> +++ b/arch/powerpc/include/asm/uaccess.h
> @@ -178,7 +178,7 @@ do {								\
>  	long __pu_err;						\
>  	__typeof__(*(ptr)) __user *__pu_addr = (ptr);		\
>  	if (!is_kernel_addr((unsigned long)__pu_addr))		\
> -		might_sleep();					\
> +		might_fault();					\
>  	__chk_user_ptr(ptr);					\
>  	__put_user_size((x), __pu_addr, (size), __pu_err);	\
>  	__pu_err;						\
> @@ -188,7 +188,7 @@ do {								\
>  ({									\
>  	long __pu_err = -EFAULT;					\
>  	__typeof__(*(ptr)) __user *__pu_addr = (ptr);			\
> -	might_sleep();							\
> +	might_fault();							\
>  	if (access_ok(VERIFY_WRITE, __pu_addr, size))			\
>  		__put_user_size((x), __pu_addr, (size), __pu_err);	\
>  	__pu_err;							\
> @@ -268,7 +268,7 @@ do {								\
>  	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);	\
>  	__chk_user_ptr(ptr);					\
>  	if (!is_kernel_addr((unsigned long)__gu_addr))		\
> -		might_sleep();					\
> +		might_fault();					\
>  	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
>  	(x) = (__typeof__(*(ptr)))__gu_val;			\
>  	__gu_err;						\
> @@ -282,7 +282,7 @@ do {								\
>  	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);	\
>  	__chk_user_ptr(ptr);					\
>  	if (!is_kernel_addr((unsigned long)__gu_addr))		\
> -		might_sleep();					\
> +		might_fault();					\
>  	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
>  	(x) = (__typeof__(*(ptr)))__gu_val;			\
>  	__gu_err;						\
> @@ -294,7 +294,7 @@ do {								\
>  	long __gu_err = -EFAULT;					\
>  	unsigned long  __gu_val = 0;					\
>  	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);		\
> -	might_sleep();							\
> +	might_fault();							\
>  	if (access_ok(VERIFY_READ, __gu_addr, (size)))			\
>  		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
>  	(x) = (__typeof__(*(ptr)))__gu_val;				\
> @@ -419,14 +419,14 @@ static inline unsigned long __copy_to_user_inatomic(void __user *to,
>  static inline unsigned long __copy_from_user(void *to,
>  		const void __user *from, unsigned long size)
>  {
> -	might_sleep();
> +	might_fault();
>  	return __copy_from_user_inatomic(to, from, size);
>  }
>  
>  static inline unsigned long __copy_to_user(void __user *to,
>  		const void *from, unsigned long size)
>  {
> -	might_sleep();
> +	might_fault();
>  	return __copy_to_user_inatomic(to, from, size);
>  }
>  
> @@ -434,7 +434,7 @@ extern unsigned long __clear_user(void __user *addr, unsigned long size);
>  
>  static inline unsigned long clear_user(void __user *addr, unsigned long size)
>  {
> -	might_sleep();
> +	might_fault();
>  	if (likely(access_ok(VERIFY_WRITE, addr, size)))
>  		return __clear_user(addr, size);
>  	if ((unsigned long)addr < TASK_SIZE) {


