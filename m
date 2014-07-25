Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbaGYOCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:02:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbaGYOCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:02:50 -0400
Message-ID: <53D26355.9020809@redhat.com>
Date: Fri, 25 Jul 2014 16:01:57 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Drysdale <drysdale@google.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH 10/11] capsicum: prctl(2) to force use of O_BENEATH
References: <1406296033-32693-1-git-send-email-drysdale@google.com> <1406296033-32693-11-git-send-email-drysdale@google.com>
In-Reply-To: <1406296033-32693-11-git-send-email-drysdale@google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/07/2014 15:47, David Drysdale ha scritto:
> @@ -1996,6 +2013,17 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  		if (arg2 || arg3 || arg4 || arg5)
>  			return -EINVAL;
>  		return current->no_new_privs ? 1 : 0;
> +	case PR_SET_OPENAT_BENEATH:
> +		if (arg2 != 1 || arg4 || arg5)
> +			return -EINVAL;
> +		if ((arg3 & ~(PR_SET_OPENAT_BENEATH_TSYNC)) != 0)
> +			return -EINVAL;
> +		error = prctl_set_openat_beneath(me, arg3);
> +		break;
> +	case PR_GET_OPENAT_BENEATH:
> +		if (arg2 || arg3 || arg4 || arg5)
> +			return -EINVAL;
> +		return me->openat_beneath;
>  	case PR_GET_THP_DISABLE:
>  		if (arg2 || arg3 || arg4 || arg5)
>  			return -EINVAL;
> 

Why are you always forbidding a change of prctl from 1 to 0?  It should
be safe if current->no_new_privs is clear.

Do new threads inherit from the parent?

Also, I wonder if you need something like this check:

        /*
         * Installing a seccomp filter requires that the task has
         * CAP_SYS_ADMIN in its namespace or be running with no_new_privs.
         * This avoids scenarios where unprivileged tasks can affect the
         * behavior of privileged children.
         */
        if (!current->no_new_privs &&
            security_capable_noaudit(current_cred(), current_user_ns(),
                                     CAP_SYS_ADMIN) != 0)
                return -EACCES;

Paolo
