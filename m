Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbbALLF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:05:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbbALLF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:05:56 -0500
Date: Mon, 12 Jan 2015 12:05:22 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: acme@redhat.com, namhyung@kernel.org, peterz@infradead.org,
        jolsa@kernel.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
        Alexey.Brodkin@synopsys.com, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <dev@codyps.com>
Subject: Re: [PATCH v2 1/5] perf tools: [uclibc] fix statfs.f_type data type
 mismatch build error
Message-ID: <20150112110522.GC26229@krava.redhat.com>
References: <1420888254-17504-1-git-send-email-vgupta@synopsys.com>
 <1420888254-17504-2-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420888254-17504-2-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 04:40:50PM +0530, Vineet Gupta wrote:
> From: Alexey Brodkin <abrodkin@synopsys.com>
> 
> ARC Linux uses the no legacy syscalls abi and corresponding uClibc headers
> statfs defines f_type to be U32 which causes perf build breakage
> 
> http://git.uclibc.org/uClibc/tree/libc/sysdeps/linux/common-generic/bits/statfs.h
> 
> ----------->8---------------
>   CC       fs/fs.o
> fs/fs.c: In function 'fs__valid_mount':
> fs/fs.c:82:24: error: comparison between signed and unsigned integer
> expressions [-Werror=sign-compare]
>   else if (st_fs.f_type != magic)
>                         ^
> cc1: all warnings being treated as errors
> ----------->8---------------
> 
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Cody P Schafer <dev@codyps.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: linux-perf-users@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

> 
> ---
> v3: Changes since v2 [2]
>  * Made Changelog a bit more concise, no code changes [vgupta]
> 
> v2: Changes since v1 [1]
>  * Added type cast to DEBUGFS_MAGIC in "debugfs.c" [Arnaldo]
>  * Added verbose explanation of root cause
> 
> [2] https://lkml.org/lkml/2014/9/16/296
> [1] https://lkml.org/lkml/2014/8/13/529
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> ---
>  tools/lib/api/fs/debugfs.c | 2 +-
>  tools/lib/api/fs/fs.c      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
> index a74fba6d7743..93aa4cd2416f 100644
> --- a/tools/lib/api/fs/debugfs.c
> +++ b/tools/lib/api/fs/debugfs.c
> @@ -67,7 +67,7 @@ int debugfs_valid_mountpoint(const char *debugfs)
>  
>  	if (statfs(debugfs, &st_fs) < 0)
>  		return -ENOENT;
> -	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
> +	else if ((long) st_fs.f_type != (long) DEBUGFS_MAGIC)
>  		return -ENOENT;
>  
>  	return 0;
> diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
> index 65d9be3f9887..15e64921ea84 100644
> --- a/tools/lib/api/fs/fs.c
> +++ b/tools/lib/api/fs/fs.c
> @@ -79,7 +79,7 @@ static int fs__valid_mount(const char *fs, long magic)
>  
>  	if (statfs(fs, &st_fs) < 0)
>  		return -ENOENT;
> -	else if (st_fs.f_type != magic)
> +	else if ((long) st_fs.f_type != magic)
>  		return -ENOENT;
>  
>  	return 0;
> -- 
> 1.9.1
> 
