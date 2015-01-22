Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbbAVPx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:53:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbbAVPx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:53:26 -0500
Date: Thu, 22 Jan 2015 10:53:16 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Paul Moore <pmoore@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-audit@redhat.com, sd@queasysnail.net,
        linux-kernel@vger.kernel.org, linux@roeck-us.net,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v2 1/5] fs: rework getname_kernel to handle up to
 PATH_MAX sized filenames
Message-ID: <20150122155316.GH18752@madcap2.tricolour.ca>
References: <20150122045303.1347.98054.stgit@localhost>
 <20150122045956.1347.11508.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122045956.1347.11508.stgit@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/21, Paul Moore wrote:
> In preparation for expanded use in the kernel, make getname_kernel()
> more useful by allowing it to handle any legal filename length.
> 
> Thanks to Guenter Roeck for his suggestion to substitute memcpy() for
> strlcpy().
> 
> CC: linux@roeck-us.net
> CC: viro@zeniv.linux.org.uk
> CC: linux-fsdevel@vger.kernel.org
> Signed-off-by: Paul Moore <pmoore@redhat.com>

Noted memcpy() difference (I assume to avoid races).

Reviewed-by: Richard Guy Briggs <rgb@redhat.com>

> ---
>  fs/namei.c |   34 ++++++++++++++++++++--------------
>  1 file changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 9eb787e..63eaaf6 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -211,32 +211,38 @@ getname(const char __user * filename)
>  	return getname_flags(filename, 0, NULL);
>  }
>  
> -/*
> - * The "getname_kernel()" interface doesn't do pathnames longer
> - * than EMBEDDED_NAME_MAX. Deal with it - you're a kernel user.
> - */
>  struct filename *
>  getname_kernel(const char * filename)
>  {
>  	struct filename *result;
> -	char *kname;
> -	int len;
> -
> -	len = strlen(filename);
> -	if (len >= EMBEDDED_NAME_MAX)
> -		return ERR_PTR(-ENAMETOOLONG);
> +	int len = strlen(filename) + 1;
>  
>  	result = __getname();
>  	if (unlikely(!result))
>  		return ERR_PTR(-ENOMEM);
>  
> -	kname = (char *)result + sizeof(*result);
> -	result->name = kname;
> +	if (len <= EMBEDDED_NAME_MAX) {
> +		result->name = (char *)(result) + sizeof(*result);
> +		result->separate = false;
> +	} else if (len <= PATH_MAX) {
> +		struct filename *tmp;
> +
> +		tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> +		if (unlikely(!tmp)) {
> +			__putname(result);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +		tmp->name = (char *)result;
> +		tmp->separate = true;
> +		result = tmp;
> +	} else {
> +		__putname(result);
> +		return ERR_PTR(-ENAMETOOLONG);
> +	}
> +	memcpy((char *)result->name, filename, len);
>  	result->uptr = NULL;
>  	result->aname = NULL;
> -	result->separate = false;
>  
> -	strlcpy(kname, filename, EMBEDDED_NAME_MAX);
>  	return result;
>  }
>  
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
