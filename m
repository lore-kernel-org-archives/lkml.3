Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175Ab3CMTKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:10:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55232 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526Ab3CMTKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:10:36 -0400
Date: Wed, 13 Mar 2013 19:10:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: s390: mm: Use PTR_RET function
Message-ID: <20130313191034.GM21522@ZenIV.linux.org.uk>
References: <1363201557-17715-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363201557-17715-1-git-send-email-gheorghiuandru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 09:05:57PM +0200, Alexandru Gheorghiu wrote:
> Used PTR_RET function instead of IS_ERR and PTR_ERR.
> Patch found using coccinelle.
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  arch/s390/mm/cmm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
> index 479e942..5cf867f 100644
> --- a/arch/s390/mm/cmm.c
> +++ b/arch/s390/mm/cmm.c
> @@ -458,7 +458,7 @@ static int __init cmm_init(void)
>  	if (rc)
>  		goto out_pm;
>  	cmm_thread_ptr = kthread_run(cmm_thread, NULL, "cmmthread");
> -	rc = IS_ERR(cmm_thread_ptr) ? PTR_ERR(cmm_thread_ptr) : 0;
> +	rc = PTR_RET(cmm_thread_ptr);
>  	if (rc)
>  		goto out_kthread;
>  	return 0;

Egads...  How about
	if (!IS_ERR(cmm_thread_ptr))
		return 0;
	rc = PTR_ERR(cmm_thread_ptr);
instead of the entire thing?  out_kthread: is just past that return 0
and there's nothing else leading to it, so with that change the label
itself can go as well.
