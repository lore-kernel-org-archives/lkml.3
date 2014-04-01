Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaDATcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 15:32:18 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:47759 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaDATcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 15:32:15 -0400
Message-ID: <533B1439.3010403@gmail.com>
Date: Tue, 01 Apr 2014 21:32:09 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Richard Hansen <rhansen@bbn.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
CC: mtk.manpages@gmail.com, linux-api@vger.kernel.org,
        Greg Troxel <gdt@ir.bbn.com>
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
References: <533B04A9.6090405@bbn.com>
In-Reply-To: <533B04A9.6090405@bbn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard,

On 04/01/2014 08:25 PM, Richard Hansen wrote:
> For the flags parameter, POSIX says "Either MS_ASYNC or MS_SYNC shall
> be specified, but not both." [1]  There was already a test for the
> "both" condition.  Add a test to ensure that the caller specified one
> of the flags; fail with EINVAL if neither are specified.
> 
> Without this change, specifying neither is the same as specifying
> flags=MS_ASYNC because nothing in msync() is conditioned on the
> MS_ASYNC flag.  This has not always been true, 

I am curious (since such things should be documented)--when was
it not true?

> and there's no good
> reason to believe that this behavior would have persisted
> indefinitely.
> 
> The msync(2) man page (as currently written in man-pages.git) is
> silent on the behavior if both flags are unset, so this change should
> not break an application written by somone who carefully reads the
> Linux man pages or the POSIX spec.

Sadly, people do not always carefully read man pages, so there
remains the chance that a change like this will break applications.
Aside from standards conformance, what do you see as the benefit
of the change?

Thanks,

Michael


> [1] http://pubs.opengroup.org/onlinepubs/9699919799/functions/msync.html
> 
> Signed-off-by: Richard Hansen <rhansen@bbn.com>
> Reported-by: Greg Troxel <gdt@ir.bbn.com>
> Reviewed-by: Greg Troxel <gdt@ir.bbn.com>
> ---
> 
> This is a resend of:
> http://article.gmane.org/gmane.linux.kernel/1554416
> I didn't get any feedback from that submission, so I'm resending it
> without changes.
> 
>  mm/msync.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/msync.c b/mm/msync.c
> index 632df45..472ad3e 100644
> --- a/mm/msync.c
> +++ b/mm/msync.c
> @@ -42,6 +42,8 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t,
> len, int, flags)
>  		goto out;
>  	if ((flags & MS_ASYNC) && (flags & MS_SYNC))
>  		goto out;
> +	if (!(flags & (MS_ASYNC | MS_SYNC)))
> +		goto out;
>  	error = -ENOMEM;
>  	len = (len + ~PAGE_MASK) & PAGE_MASK;
>  	end = start + len;
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
