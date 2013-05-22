Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3EVQHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:07:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab3EVQHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:07:41 -0400
Date: Wed, 22 May 2013 18:03:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: viro@zeniv.linux.org.uk, serge.hallyn@canonical.com, jlayton@redhat.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, bfields@fieldses.org,
        ebiederm@xmission.com, bharrosh@panasas.com,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        devel@openvz.org
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
Message-ID: <20130522160353.GB16571@redhat.com>
References: <20130522072840.27720.85023.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522072840.27720.85023.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22, Stanislav Kinsbursky wrote:
>
> +static int umh_set_fs_root(struct subprocess_info *info, struct cred *new)
> +{
> +	set_fs_root(current->fs, info->data);
> +	return 0;
> +}
> +
> +/*
> + * Call a usermode helper with a specific fs root.
> + *
> + * The caller must hold extra reference to it otherwise, because it will be
> + * put on usermodehelper thread exit.
> + */
> +int call_usermodehelper_root(char *path, char **argv, char **envp,
> +			     struct path *root, int wait)
> +{
> +	struct subprocess_info *info;
> +	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
> +
> +	info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
> +					      umh_set_fs_root, NULL, root);
> +	if (info == NULL)
> +		return -ENOMEM;
> +
> +	return call_usermodehelper_exec(info, wait);
> +}
> +EXPORT_SYMBOL(call_usermodehelper_root);

Of course, I can't ack the placement (and yes, it was me who argued
that kmod.c is probably not the best place), but the patch looks fine.

I am not sure the new helper actually needs "int wait" but this matches
call_usermodehelper().

For what it's worth:

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

