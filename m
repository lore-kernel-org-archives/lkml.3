Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbaIOTwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:52:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbaIOTwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:52:14 -0400
Date: Mon, 15 Sep 2014 16:52:01 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: linux-kernel@vger.kernel.org, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Borislav Petkov <bp@suse.de>, Jiri Olsa <jolsa@kernel.org>,
        Cody P Schafer <dev@codyps.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH] perf tools: fix type mismatch - long vs __statfs_word
Message-ID: <20140915195201.GF2259@redhat.com>
References: <1407949429-25421-1-git-send-email-abrodkin@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407949429-25421-1-git-send-email-abrodkin@synopsys.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 13, 2014 at 09:03:49PM +0400, Alexey Brodkin escreveu:
> >From "include/uapi/asm-generic/statfs.h" it is seen that "statfs.f_type" is of
> type "__statfs_word" which in its turn is "__u32" (unsigned int) for 32-bit
> systems.
> 
> So in case of compilation with "-Werror" following breakage happens:
> --->---
> fs.c: In function ‘fs__valid_mount’:
> fs.c:76:24: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
>   else if (st_fs.f_type != magic)
>                         ^
> cc1: all warnings being treated as errors
> --->---
> 
> Note that now when fs.c is in "lib/api/fs" and in "tools/lib/api/Makefile"
> CFLAGS has hard-coded "-Werror" this is inevitable even if one builds "perf"
> with "WERROR=0".

So we have one more case of comparision involving f_type:

[acme@zoo linux]$ find tools/ -type f | xargs grep -w f_type
tools/lib/api/fs/fs.c:	else if (st_fs.f_type != magic)
tools/lib/api/fs/debugfs.c:	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
[acme@zoo linux]$

Do we have to apply the same fix to that other case as well?
Interestingly it does it on a different way, that by your description
above would make it fail on 32-bit systems, no?

- Arnaldo
 
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> 
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Cody P Schafer <dev@codyps.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/lib/api/fs/fs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
> index c1b49c3..4b2fa7b 100644
> --- a/tools/lib/api/fs/fs.c
> +++ b/tools/lib/api/fs/fs.c
> @@ -75,7 +75,7 @@ static int fs__valid_mount(const char *fs, long magic)
>  
>  	if (statfs(fs, &st_fs) < 0)
>  		return -ENOENT;
> -	else if (st_fs.f_type != magic)
> +	else if ((long)st_fs.f_type != magic)
>  		return -ENOENT;
>  
>  	return 0;
> -- 
> 1.9.3
