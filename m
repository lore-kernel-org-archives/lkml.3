Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3BUVyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:54:14 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58122 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab3BUVyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:54:10 -0500
Date: Thu, 21 Feb 2013 13:54:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH 2/2] ima: add policy support for file system uuid
In-Reply-To: <1360070895-29895-2-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1302211352270.28115@chino.kir.corp.google.com>
References: <1360070895-29895-1-git-send-email-zohar@linux.vnet.ibm.com> <1360070895-29895-2-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, Mimi Zohar wrote:

> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 4adcd0f..23f49e3 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -16,6 +16,7 @@
>  #include <linux/magic.h>
>  #include <linux/parser.h>
>  #include <linux/slab.h>
> +#include <linux/genhd.h>
>  
>  #include "ima.h"
>  
> @@ -25,6 +26,7 @@
>  #define IMA_FSMAGIC	0x0004
>  #define IMA_UID		0x0008
>  #define IMA_FOWNER	0x0010
> +#define IMA_FSUUID	0x0020
>  
>  #define UNKNOWN		0
>  #define MEASURE		0x0001	/* same as IMA_MEASURE */
> @@ -45,6 +47,7 @@ struct ima_rule_entry {
>  	enum ima_hooks func;
>  	int mask;
>  	unsigned long fsmagic;
> +	u8 fsuuid[16];
>  	kuid_t uid;
>  	kuid_t fowner;
>  	struct {
> @@ -172,6 +175,9 @@ static bool ima_match_rules(struct ima_rule_entry *rule,
>  	if ((rule->flags & IMA_FSMAGIC)
>  	    && rule->fsmagic != inode->i_sb->s_magic)
>  		return false;
> +	if ((rule->flags & IMA_FSUUID) &&
> +		memcmp(rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
> +		return false;
>  	if ((rule->flags & IMA_UID) && !uid_eq(rule->uid, cred->uid))
>  		return false;
>  	if ((rule->flags & IMA_FOWNER) && !uid_eq(rule->fowner, inode->i_uid))
> @@ -346,7 +352,7 @@ enum {
>  	Opt_obj_user, Opt_obj_role, Opt_obj_type,
>  	Opt_subj_user, Opt_subj_role, Opt_subj_type,
>  	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid, Opt_fowner,
> -	Opt_appraise_type
> +	Opt_appraise_type, Opt_fsuuid
>  };
>  
>  static match_table_t policy_tokens = {
> @@ -364,6 +370,7 @@ static match_table_t policy_tokens = {
>  	{Opt_func, "func=%s"},
>  	{Opt_mask, "mask=%s"},
>  	{Opt_fsmagic, "fsmagic=%s"},
> +	{Opt_fsuuid, "fsuuid=%s"},
>  	{Opt_uid, "uid=%s"},
>  	{Opt_fowner, "fowner=%s"},
>  	{Opt_appraise_type, "appraise_type=%s"},
> @@ -519,6 +526,19 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  			if (!result)
>  				entry->flags |= IMA_FSMAGIC;
>  			break;
> +		case Opt_fsuuid:
> +			ima_log_string(ab, "fsuuid", args[0].from);
> +
> +			if (memchr_inv(entry->fsuuid, 0x00,
> +			    sizeof(entry->fsuuid))) {
> +				result = -EINVAL;
> +				break;
> +			}
> +
> +			part_pack_uuid(args[0].from, entry->fsuuid);
> +			entry->flags |= IMA_FSUUID;
> +			result = 0;
> +			break;
>  		case Opt_uid:
>  			ima_log_string(ab, "uid", args[0].from);
>  

We don't have part_pack_uuid() without CONFIG_BLOCK, so should this return 
-ENOTSUPP if that option is not enabled?
