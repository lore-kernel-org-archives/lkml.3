Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985Ab3BXU2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 15:28:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:57829 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab3BXU2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 15:28:07 -0500
Message-ID: <512A77EF.4010100@infradead.org>
Date: Sun, 24 Feb 2013 12:28:31 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: David Rientjes <rientjes@google.com>, James Morris <jmorris@namei.org>,
        axboe <axboe@kernel.dk>, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix part_pack_uuid() build error
References: <1361718944.2908.49.camel@falcor1.watson.ibm.com>
In-Reply-To: <1361718944.2908.49.camel@falcor1.watson.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/13 07:15, Mimi Zohar wrote:
> Fix a build error when CONFIG_BLOCK is not enabled, by defining
> a wrapper called blk_part_pack_uuid().  The wrapper returns
> -EINVAL, when CONFIG_BLOCK is not defined.
> 
> security/integrity/ima/ima_policy.c:538:4: error: implicit declaration
> of function 'part_pack_uuid' [-Werror=implicit-function-declaration]
> 
> Changleog v1:
> - rename ima_part_pack_uuid() to blk_part_pack_uuid()
> - resolve scripts/checkpatch.pl warnings
> Changelog v0:
> - fix UUID scripts/Lindent msgs
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  include/linux/genhd.h               | 10 ++++++++++
>  security/integrity/ima/ima_policy.c | 11 ++++++-----
>  2 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 79b8bba..9f3c275 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -231,6 +231,12 @@ static inline void part_pack_uuid(const u8 *uuid_str, u8 *to)
>  	}
>  }
>  
> +static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
> +{
> +	part_pack_uuid(uuid_str, to);
> +	return 0;
> +}
> +
>  static inline int disk_max_parts(struct gendisk *disk)
>  {
>  	if (disk->flags & GENHD_FL_EXT_DEVT)
> @@ -718,6 +724,10 @@ static inline dev_t blk_lookup_devt(const char *name, int partno)
>  	return devt;
>  }
>  
> +static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
> +{
> +	return -EINVAL;
> +}
>  #endif /* CONFIG_BLOCK */
>  
>  #endif /* _LINUX_GENHD_H */
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index b27535a..399433a 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -176,7 +176,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule,
>  	    && rule->fsmagic != inode->i_sb->s_magic)
>  		return false;
>  	if ((rule->flags & IMA_FSUUID) &&
> -		memcmp(rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
> +	    memcmp(rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
>  		return false;
>  	if ((rule->flags & IMA_UID) && !uid_eq(rule->uid, cred->uid))
>  		return false;
> @@ -530,14 +530,15 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  			ima_log_string(ab, "fsuuid", args[0].from);
>  
>  			if (memchr_inv(entry->fsuuid, 0x00,
> -			    sizeof(entry->fsuuid))) {
> +				       sizeof(entry->fsuuid))) {
>  				result = -EINVAL;
>  				break;
>  			}
>  
> -			part_pack_uuid(args[0].from, entry->fsuuid);
> -			entry->flags |= IMA_FSUUID;
> -			result = 0;
> +			result = blk_part_pack_uuid(args[0].from,
> +						    entry->fsuuid);
> +			if (!result)
> +				entry->flags |= IMA_FSUUID;
>  			break;
>  		case Opt_uid:
>  			ima_log_string(ab, "uid", args[0].from);
> 


-- 
~Randy
