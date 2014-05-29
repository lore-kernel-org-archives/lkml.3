Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaE2WV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:21:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaE2WVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:21:55 -0400
Date: Thu, 29 May 2014 15:21:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Petr Vandrovec <petr@vandrovec.name>
Subject: Re: [PATCH 1/1] fs/ncpfs/getopt.c: replace simple_strtoul by
 kstrtoul
Message-Id: <20140529152153.5387970fd21c7add9837cfe3@linux-foundation.org>
In-Reply-To: <20140523222611.862216f7570633a5bf0f0e89@skynet.be>
References: <20140523222611.862216f7570633a5bf0f0e89@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2014 22:26:11 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> Remove obsolete simple_strtoul in ncp_getopt

Looks good to me.

> 
> --- a/fs/ncpfs/getopt.c
> +++ b/fs/ncpfs/getopt.c
> @@ -53,15 +53,14 @@ int ncp_getopt(const char *caller, char **options, const struct ncp_option *opts
>  				return -EINVAL;
>  			}
>  			if (opts->has_arg & OPT_INT) {
> -				char* v;
> +				int rc = kstrtoul(val, 0, value);
>  
> -				*value = simple_strtoul(val, &v, 0);
> -				if (!*v) {
> -					return opts->val;
> +				if (rc) {
> +					pr_info("%s: invalid numeric value in %s=%s\n",
> +						caller, token, val);
> +					return rc;

Because kstrtoul("42foo", ...) returns -EINVAL rather than 42.  This
behaviour isn't obvious - I had to dive into the implementation to work
it out.  We forgot to document what kstrtoul() considers a "parsing
error".


>  				}
> -				pr_info("%s: invalid numeric value in %s=%s\n",
> -					caller, token, val);
> -				return -EDOM;
> +				return opts->val;
>  			}
>  			if (opts->has_arg & OPT_STRING) {
>  				return opts->val;
> -- 
> 1.9.1
