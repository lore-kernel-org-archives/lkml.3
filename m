Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3FOUIJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 16:08:09 -0400
Received: from smtp107.biz.mail.ne1.yahoo.com ([98.138.207.14]:47156 "HELO
	smtp107.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754414Ab3FOUIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 16:08:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: gRsYKjQVM1koKUyMgWYs4wkVirXTPWZ_gtafJ3QTjuOyDnz
 JmSvj9H.dF1ADhMvhB1TwIe5ibAbnYJ5YqSyZsEaEEUADPRQwRrs.050CN3p
 m9QXN7s827VwtjIngqe8Ge_IVy5zqwLllbXyjVdfRdVjgUNcLobaVEdTYWpk
 m4JiXWxMzG.BsSUGAhgGU_thtKwmzu3aBde4YnUOhhtfVqCnF0xFMx99LKEB
 BaJSxXyhd9A9aug1VJAWfw9PWoCdiAkBryhyiz3_2JS1x8ZLqDJ7ACazn433
 g5Kf2mDqF5Iy.73itAcTL.G7FCCRSA0kxcHHyMf7X5BGRzGU.6eoEQnaRs0W
 JRKXmap5sbJkhhV8a.sli2W.3rkuSLd1G4HKvaerJLV3nFkTnqVHx50fG9FN
 UFh9FpDZ862efSLTcYPOhj7..Z72YeeYw7Dsc0YNYbbZ4hyXIojUNwpAExZ.
 N7u7bUUgtR2KM5EV.eWvb9S9_CDZdcrMzHha6Vl9H74M-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp107.biz.mail.ne1.yahoo.com with SMTP; 15 Jun 2013 13:08:05 -0700 PDT
Message-ID: <51BCC9B1.7050601@schaufler-ca.com>
Date: Sat, 15 Jun 2013 13:08:17 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC 5/5] security: smack: add kmem_cache for smack_master_list
 allocations
References: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com> <1371137352-31273-6-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1371137352-31273-6-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/2013 8:29 AM, Tomasz Stanislawski wrote:
> On ARM, sizeof(struct smack_master_list) == 12. Allocation by kmalloc() uses a
> 32-byte-long chunk to allocate 12 bytes. Just ask ksize().  It means that 63%
> of memory is simply wasted for padding bytes.
>
> The problem is fixed in this patch by using kmem_cache. The cache allocates
> struct smack_master_list using 16-byte-long chunks according to ksize(). This
> reduces amount of used memory by 50%.

As with patch 4, I need to see performance numbers. Saving 50%
is good, but if there are 20,000 rules you're only saving 320K
of memory.

>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>  security/smack/smack.h     |    7 +++++++
>  security/smack/smack_lsm.c |    8 ++++++++
>  security/smack/smackfs.c   |    8 ++------
>  3 files changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 38ba673..463f818 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -194,6 +194,12 @@ struct smk_audit_info {
>  	struct smack_audit_data sad;
>  #endif
>  };
> +
> +struct smack_master_list {
> +	struct list_head	list;
> +	struct smack_rule	*smk_rule;
> +};
> +
>  /*
>   * These functions are in smack_lsm.c
>   */
> @@ -235,6 +241,7 @@ extern struct list_head smk_netlbladdr_list;
>  
>  /* Cache for fast and thrifty allocations */
>  extern struct kmem_cache *smack_rule_cache;
> +extern struct kmem_cache *smack_master_list_cache;
>  
>  extern struct security_operations smack_ops;
>  
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 7aa696a..1d4a1b0 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -3566,6 +3566,7 @@ static __init void init_smack_known_list(void)
>  
>  /* KMEM caches for fast and thrifty allocations */
>  struct kmem_cache *smack_rule_cache;
> +struct kmem_cache *smack_master_list_cache;
>  
>  /**
>   * smack_init - initialize the smack system
> @@ -3584,9 +3585,16 @@ static __init int smack_init(void)
>  	if (!smack_rule_cache)
>  		return -ENOMEM;
>  
> +	smack_master_list_cache = KMEM_CACHE(smack_master_list, 0);
> +	if (!smack_master_list_cache) {
> +		kmem_cache_destroy(smack_rule_cache);
> +		return -ENOMEM;
> +	}
> +
>  	tsp = new_task_smack(smack_known_floor.smk_known,
>  				smack_known_floor.smk_known, GFP_KERNEL);
>  	if (tsp == NULL) {
> +		kmem_cache_destroy(smack_master_list_cache);
>  		kmem_cache_destroy(smack_rule_cache);
>  		return -ENOMEM;
>  	}
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index c08b1ec..c7a1b0d 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -104,11 +104,6 @@ LIST_HEAD(smk_netlbladdr_list);
>   * Rule lists are maintained for each label.
>   * This master list is just for reading /smack/load and /smack/load2.
>   */
> -struct smack_master_list {
> -	struct list_head	list;
> -	struct smack_rule	*smk_rule;
> -};
> -
>  LIST_HEAD(smack_rule_list);
>  
>  struct smack_parsed_rule {
> @@ -233,7 +228,8 @@ static int smk_set_access(struct smack_parsed_rule *srp,
>  		 * it needs to get added for reporting.
>  		 */
>  		if (global) {
> -			smlp = kzalloc(sizeof(*smlp), GFP_KERNEL);
> +			smlp = kmem_cache_zalloc(smack_master_list_cache,
> +							GFP_KERNEL);
>  			if (smlp != NULL) {
>  				smlp->smk_rule = sp;
>  				list_add_rcu(&smlp->list, &smack_rule_list);

