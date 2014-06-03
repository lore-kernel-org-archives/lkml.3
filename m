Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaFCTW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:22:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24562 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbaFCTW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:22:26 -0400
Message-ID: <538E206A.10400@oracle.com>
Date: Tue, 03 Jun 2014 14:22:18 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>, Dave <shaggy@kernel.org>
Subject: Re: [PATCH 1/1] fs/jfs/super.c: convert simple_str to kstr
References: <20140521202929.00437eb6cf5290b51102bb18@skynet.be>
In-Reply-To: <20140521202929.00437eb6cf5290b51102bb18@skynet.be>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabian,
I finally got to pushing this and your previous jfs cleanups to
git://github.com/kleikamp/linux-shaggy.git jfs-next

I'll give them a day or two in the next tree, then push them to Linus.

I modified this patch slightly, but the others are unchanged.

Thanks,
Dave

On 05/21/2014 01:29 PM, Fabian Frederick wrote:
> This patch replaces obsolete simple_str functions by kstr
> 
> use kstrtouint for
> -uid_t ( __kernel_uid32_t )
> -gid_t ( __kernel_gid32_t )
> -jfs_sb_info->umask
> -jfs_sb_info->minblks_trim
> (all unsigned int)
> 
> newLVSize is s64 -> use kstrtol
> 
> Current parse_options behaviour stays the same ie it doesn't return kstr
> rc but just 0 if function failed (parse_options callsites
> return -EINVAL when there's anything wrong).
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> ---
>  fs/jfs/super.c | 29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index 97f7fda..fe09e5d 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -273,7 +273,10 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
>  		case Opt_resize:
>  		{
>  			char *resize = args[0].from;
> -			*newLVSize = simple_strtoull(resize, &resize, 0);
> +			int rc = kstrtoll(resize, 0, newLVSize);
> +
> +			if (rc)
> +				return 0;

Should goto cleanup here, or it's possible to leak a newly allocated
nls_map.

>  			break;
>  		}
>  		case Opt_resize_nosize:
> @@ -327,7 +330,11 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
>  		case Opt_uid:
>  		{
>  			char *uid = args[0].from;
> -			uid_t val = simple_strtoul(uid, &uid, 0);
> +			uid_t val;
> +			int rc = kstrtouint(uid, 0, &val);
> +
> +			if (rc)
> +				return 0;

same here

>  			sbi->uid = make_kuid(current_user_ns(), val);
>  			if (!uid_valid(sbi->uid))
>  				goto cleanup;
> @@ -337,7 +344,11 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
>  		case Opt_gid:
>  		{
>  			char *gid = args[0].from;
> -			gid_t val = simple_strtoul(gid, &gid, 0);
> +			gid_t val;
> +			int rc = kstrtouint(gid, 0, &val);
> +
> +			if (rc)
> +				return 0;

same here

>  			sbi->gid = make_kgid(current_user_ns(), val);
>  			if (!gid_valid(sbi->gid))
>  				goto cleanup;
> @@ -347,7 +358,10 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
>  		case Opt_umask:
>  		{
>  			char *umask = args[0].from;
> -			sbi->umask = simple_strtoul(umask, &umask, 8);
> +			int rc = kstrtouint(umask, 8, &sbi->umask);
> +
> +			if (rc)
> +				return 0;

same here

>  			if (sbi->umask & ~0777) {
>  				pr_err("JFS: Invalid value of umask\n");
>  				goto cleanup;
> @@ -380,10 +394,13 @@ static int parse_options(char *options, struct super_block *sb, s64 *newLVSize,
>  		{
>  			struct request_queue *q = bdev_get_queue(sb->s_bdev);
>  			char *minblks_trim = args[0].from;
> +			int rc;
>  			if (blk_queue_discard(q)) {
>  				*flag |= JFS_DISCARD;
> -				sbi->minblks_trim = simple_strtoull(
> -					minblks_trim, &minblks_trim, 0);
> +				rc = kstrtouint(minblks_trim, 0,
> +					       &sbi->minblks_trim);
> +				if (rc)
> +					return 0;

and here too

>  			} else {
>  				pr_err("JFS: discard option " \
>  					"not supported on device\n");
> 
