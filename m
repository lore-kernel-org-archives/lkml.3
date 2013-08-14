Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab3HNSVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:21:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759978Ab3HNSVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:21:47 -0400
Date: Wed, 14 Aug 2013 20:16:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zach Levis <zach@zachsthings.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dan.carpenter@oracle.com, keescook@chromium.org,
        cody@linux.vnet.ibm.com, zml@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] fs/binfmts: Better handling of binfmt loops
Message-ID: <20130814181604.GA5463@redhat.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com> <1376497898-18619-3-git-send-email-zach@zachsthings.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376497898-18619-3-git-send-email-zach@zachsthings.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14, Zach Levis wrote:
>
> +static void bprm_close_file(struct linux_binprm *bprm)
> +{
> +	if (bprm->mm) {
> +		acct_arg_size(bprm, 0);
> +		mmput(bprm->mm);
> +	}
> +
> +	if (bprm->file) {
> +		allow_write_access(bprm->file);
> +		fput(bprm->file);
> +	}
> +}

btw this doesn't look right too. This can be called multiple times
during the error handling.

Just suppose that search_binary_handler() does this at depth == 0
when it detects -ELOOP and then open_exec() fails. After that
we return to do_execve_common() which goes to "out:".

Oleg.

