Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbaCCNnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 08:43:49 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:53240 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbaCCNnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 08:43:47 -0500
Message-ID: <1393854222.32410.16.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 1/8] ima: fix erronous removal of security.ima xattr
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org,
        linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com
Date: Mon, 03 Mar 2014 08:43:42 -0500
In-Reply-To: <26fce2ad8be7c65be3bfe972f91c7a1dbe8ae668.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
	 <26fce2ad8be7c65be3bfe972f91c7a1dbe8ae668.1393599538.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030313-0928-0000-0000-000000177C30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 16:59 +0200, Dmitry Kasatkin wrote: 
> ima_inode_post_setattr() calls ima_must_appraise() to check if
> file needs to be appraised. If it is not then it removes security.ima
> xattr. With original policy matching code it might happen that even
> file needs to be appraised with FILE_CHECK hook, it might not be
> for POST_SETATTR hook. 'security.ima' might be erronously removed.
> 
> This patch treats POST_SETATTR as special wildcard function and will
> cause ima_must_appraise() to be true if any of the hooks rules matches.
> security.ima will not be removed if any of the hooks would require
> appraisal.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

Thanks!

Mimi 
> ---
>  security/integrity/ima/ima_policy.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index d7c97a4..947cdbe 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -167,9 +167,11 @@ static bool ima_match_rules(struct ima_rule_entry *rule,
>  	const struct cred *cred = current_cred();
>  	int i;
> 
> -	if ((rule->flags & IMA_FUNC) && rule->func != func)
> +	if ((rule->flags & IMA_FUNC) &&
> +		    (rule->func != func && func != POST_SETATTR))
>  		return false;
> -	if ((rule->flags & IMA_MASK) && rule->mask != mask)
> +	if ((rule->flags & IMA_MASK) &&
> +		    (rule->mask != mask && func != POST_SETATTR))
>  		return false;
>  	if ((rule->flags & IMA_FSMAGIC)
>  	    && rule->fsmagic != inode->i_sb->s_magic)


