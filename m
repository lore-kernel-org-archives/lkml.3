Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaLXSIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 13:08:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbaLXSIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 13:08:35 -0500
Date: Wed, 24 Dec 2014 19:06:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Stijn Volckaert <Stijn.Volckaert@elis.ugent.be>
Cc: Roland McGrath <roland@hack.frob.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] Allow introspection to already attached ptracer in
	__ptrace_may_access
Message-ID: <20141224180654.GA11973@redhat.com>
References: <549ABF87.8060905@elis.ugent.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <549ABF87.8060905@elis.ugent.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24, Stijn Volckaert wrote:
>
> The question now is whether or not it's the security module's
> responsibility to check whether a tracee relationship is already in
> place or if ptrace itself should do it.

Honestly, I have no idea

> --- a/kernel/ptrace.c	2014-12-24 13:53:23.055346526 +0100
> +++ b/kernel/ptrace.c	2014-12-24 14:17:20.617824840 +0100
> @@ -232,6 +232,9 @@ static int __ptrace_may_access(struct ta
>  	/* Don't let security modules deny introspection */
>  	if (same_thread_group(task, current))
>  		return 0;
> +	/* Don't deny introspection to already attached ptracer */
> +	if (!ptrace_check_attach(task, true))
> +	        return 0;

Perhaps this makes sense, probably security checks do not make sense
if the target is traced.

But in this case I'd suggest to simply

	if (ptrace_parent(task) == current)
		return 0;


Oleg.

