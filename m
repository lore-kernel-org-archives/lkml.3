Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbaFZMhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:37:17 -0400
Received: from mail-wg0-f73.google.com ([74.125.82.73]:41541 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbaFZMhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:37:14 -0400
Date: Thu, 26 Jun 2014 13:37:10 +0100
From: David Drysdale <drysdale@google.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>,
        linux-api@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v7 2/9] seccomp: split filter prep from check and apply
Message-ID: <20140626123710.GA16204@google.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org>
 <1403560693-21809-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403560693-21809-3-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 02:58:06PM -0700, Kees Cook wrote:
> In preparation for adding seccomp locking, move filter creation away
> from where it is checked and applied. This will allow for locking where
> no memory allocation is happening. The validation, filter attachment,
> and seccomp mode setting can all happen under the future locks.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/seccomp.c |   97 +++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 67 insertions(+), 30 deletions(-)
> 
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index afb916c7e890..edc8c79ed16d 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -515,6 +551,7 @@ static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
>  	current->seccomp.mode = seccomp_mode;
>  	set_thread_flag(TIF_SECCOMP);
>  out:
> +	seccomp_filter_free(prepared);
>  	return ret;
>  }

I think this needs to be inside #ifdef CONFIG_SECCOMP_FILTER to match
the definition of seccomp_filter_free:

../kernel/seccomp.c:554:2: error: implicit declaration of function ‘seccomp_filter_free’ [-Werror=implicit-function-declaration]


