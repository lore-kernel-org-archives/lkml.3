Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaG2Tes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:34:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbaG2Teq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:34:46 -0400
Date: Tue, 29 Jul 2014 21:32:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>, hpa@zytor.com,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v4 2/5] x86,entry: Only call user_exit if TIF_NOHZ
Message-ID: <20140729193232.GA8153@redhat.com>
References: <cover.1406604806.git.luto@amacapital.net> <7123b2489cc5d1d5abb7bcf1364ca729cab3e6ca.1406604806.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7123b2489cc5d1d5abb7bcf1364ca729cab3e6ca.1406604806.git.luto@amacapital.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, Andy Lutomirski wrote:
>
> @@ -1449,7 +1449,12 @@ long syscall_trace_enter(struct pt_regs *regs)
>  {
>  	long ret = 0;
>  
> -	user_exit();
> +	/*
> +	 * If TIF_NOHZ is set, we are required to call user_exit() before
> +	 * doing anything that could touch RCU.
> +	 */
> +	if (test_thread_flag(TIF_NOHZ))
> +		user_exit();

Personally I still think this change just adds more confusion, but I leave
this to you and Frederic.

It is not that "If TIF_NOHZ is set, we are required to call user_exit()", we
need to call user_exit() just because we enter the kernel. TIF_NOHZ is just
the implementation detail which triggers this slow path.

At least it should be correct, unless I am confused even more than I think.

Oleg.

