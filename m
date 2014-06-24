Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaFXTUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:20:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbaFXTUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:20:05 -0400
Date: Tue, 24 Jun 2014 21:18:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        linux-api@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v7 4/9] seccomp: move no_new_privs into seccomp
Message-ID: <20140624191815.GA3623@redhat.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org> <1403560693-21809-5-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403560693-21809-5-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Kees Cook wrote:
>
> --- a/include/linux/seccomp.h
> +++ b/include/linux/seccomp.h
> @@ -3,6 +3,8 @@
>
>  #include <uapi/linux/seccomp.h>
>
> +#define SECCOMP_FLAG_NO_NEW_PRIVS	0	/* task may not gain privs */
> +
>  #ifdef CONFIG_SECCOMP
>
>  #include <linux/thread_info.h>
> @@ -16,6 +18,7 @@ struct seccomp_filter;
>   *         system calls available to a process.
>   * @filter: must always point to a valid seccomp-filter or NULL as it is
>   *          accessed without locking during system call entry.
> + * @flags: flags under task->sighand->siglock lock
>   *
>   *          @filter must only be accessed from the context of current as there
>   *          is no read locking.
> @@ -23,6 +26,7 @@ struct seccomp_filter;
>  struct seccomp {
>  	int mode;
>  	struct seccomp_filter *filter;
> +	unsigned long flags;
>  };
>
>  extern int __secure_computing(int);
> @@ -51,7 +55,9 @@ static inline int seccomp_mode(struct seccomp *s)
>
>  #include <linux/errno.h>
>
> -struct seccomp { };
> +struct seccomp {
> +	unsigned long flags;
> +};

A bit messy ;)

I am wondering if we can simply do

	static inline bool current_no_new_privs(void)
	{
		if (current->no_new_privs)
			return true;

	#ifdef CONFIG_SECCOMP
		if (test_thread_flag(TIF_SECCOMP))
			return true;
	#endif

		return false;

	     return test_bit(SECCOMP_FLAG_NO_NEW_PRIVS, &p->seccomp.flags);
	}

instead ?

Oleg.

