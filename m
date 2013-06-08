Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab3FHUcE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 16:32:04 -0400
Received: from nm21.access.bullet.mail.mud.yahoo.com ([66.94.237.222]:39664
	"EHLO nm21.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694Ab3FHUcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 16:32:01 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Jun 2013 16:32:01 EDT
X-Yahoo-Newman-Id: 40469.83460.bm@smtp101.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5XsPHXAVM1nAZoDqfJJyVBcvil.21K8Vo88iv2DK5rMqiAE
 t12RuUF6KAecCtn_Wj5SQySGpu4rivWusT9VPPGPx6qSOUJsgrfglCbYh1U3
 h2IkqrcqH8gRkZP1tAivgX_XNR3ymnYq.XWhgqJEW3Q_oYs.9zG9Xz5v2EJ6
 7go5mSV0YzYGgvtBNQLXBGmboR0W9jPM_NXFAaFBl3Ps1aE_9bUwOJw0BiHF
 1W.cBxPt.oxcx.kzDvdcIGy2OJva91hUrU4JpKuX_sVUMKq5kH6wZ0uXBKPz
 7c8G_g7WtOzFdJ.Wm8zR0vDviht1VjLACtBCNFZrK3l9KGnPFmOGjoU1dOnj
 .LTLguvYtFp5qxBdINUCHk6uMhGl7L9_uciTYBO1EFuMDDbkmw7H0.YTphft
 2EemBdZeBXhItvimAWfa7D7JrI5ZENFdSJrCeG9mOF2Nw8GY445RaDpHwWEh
 1CPqY_x0jXVUb6gWW5XhSZLbHVF1v7TQfzGD8KUqU56k-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp101.biz.mail.bf1.yahoo.com with SMTP; 08 Jun 2013 13:26:32 -0700 PDT
Message-ID: <51B39375.2040409@schaufler-ca.com>
Date: Sat, 08 Jun 2013 13:26:29 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC] security: smack: add hash table for smack for quick label
 searching
References: <1365669972-21461-1-git-send-email-t.stanislaws@samsung.com> <1365669972-21461-2-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1365669972-21461-2-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/2013 1:46 AM, Tomasz Stanislawski wrote:
> This patch adds a hash table to quicken searching of a smack label by its name.
>
> For a typical idle for TIZEN the CPU wastes circa 5-10% of its cycles for
> processing the smk_find_entry function. This patch adds a hash map that should
> speed up searches by a factor of up to 500 at the cost of additional 4kiB
> memory for the hash table.
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

I had originally NAKed this patch because there were other,
more important changes that needed to be made. Those are in
now, so it's time to revisit this change. I have many comments
throughout. The patch needs to be rebased on the current
smack-next smack-for-3.11 branch.

> ---
>  security/smack/smack.h        |    5 +++++
>  security/smack/smack_access.c |   33 +++++++++++++++++++++++++++++++--
>  security/smack/smack_lsm.c    |   21 +++++++++++++++------
>  3 files changed, 51 insertions(+), 8 deletions(-)
>
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 99b3612..8df667e 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -118,6 +118,7 @@ struct smk_netlbladdr {
>   */
>  struct smack_known {
>  	struct list_head		list;
> +	struct list_head		htab_list;

I would prefer "smk_hashed".

>  	char				*smk_known;
>  	u32				smk_secid;
>  	struct netlbl_lsm_secattr	smk_netlabel;	/* on wire labels */
> @@ -215,6 +216,7 @@ char *smk_parse_smack(const char *string, int len);
>  int smk_netlbl_mls(int, char *, struct netlbl_lsm_secattr *, int);
>  char *smk_import(const char *, int);
>  struct smack_known *smk_import_entry(const char *, int);
> +void __smk_insert_entry(struct smack_known *skp);

Use "smk_insert_entry" instead of "__smk_insert_entry".
This is a really small function. How about a static inline?

>  struct smack_known *smk_find_entry(const char *);
>  u32 smack_to_secid(const char *);
>  
> @@ -238,6 +240,9 @@ extern struct mutex	smack_known_lock;
>  extern struct list_head smack_known_list;
>  extern struct list_head smk_netlbladdr_list;
>  
> +#define SMACK_KNOWN_SIZE 512

I don't think the name is descriptive. SMACK_HASH_SLOTS would be better.

This is *way* too big. Show me performance numbers for 4, 8, ..., 256.

> +extern struct list_head smack_known_htab[SMACK_KNOWN_SIZE];

I'd prefer "smack_known_hash". I like real words where they fit.

> +
>  extern struct security_operations smack_ops;
>  
>  /*
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index db14689..0490c0d 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -48,6 +48,8 @@ struct smack_known smack_known_web = {
>  
>  LIST_HEAD(smack_known_list);
>  
> +struct list_head smack_known_htab[SMACK_KNOWN_SIZE];
> +
>  /*
>   * The initial value needs to be bigger than any of the
>   * known values above.
> @@ -322,6 +324,30 @@ void smack_log(char *subject_label, char *object_label, int request,
>  
>  DEFINE_MUTEX(smack_known_lock);
>  
> +/* simple Dan Bernstein string hashing function */

Please use the usual function description comment format.
Please explain in that comment where the numbers 33 and 5381
come from. If there is any chance they might get changed in
the future #define them. Heck, #define them anyway.

> +static u32 strhash(const char *s)

Please give this more consistent name. Perhaps smk_list_hash().

> +{
> +	u32 hash = 5381;
> +	for (; *s; ++s)
> +		hash = hash * 33 + *s;
> +	return hash;
> +}
> +
> +/**
> + * smk_insert_entry - insert a smack label into a hash map,
> + *
> + * this function must be called under smack_known_lock
> + */
> +void __smk_insert_entry(struct smack_known *skp)
> +{
> +	u32 hash = strhash(skp->smk_known);
> +	struct list_head *head = &smack_known_htab[
> +		hash & (SMACK_KNOWN_SIZE - 1)];

Split this. Initializations in the declaration line should not
be done where it clutters the code.

> +
> +	list_add_rcu(&skp->htab_list, head);
> +	list_add_rcu(&skp->list, &smack_known_list);
> +}
> +
>  /**
>   * smk_find_entry - find a label on the list, return the list entry
>   * @string: a text string that might be a Smack label
> @@ -331,9 +357,12 @@ DEFINE_MUTEX(smack_known_lock);
>   */
>  struct smack_known *smk_find_entry(const char *string)
>  {
> +	u32 hash = strhash(string);
> +	struct list_head *head = &smack_known_htab[
> +		hash & (SMACK_KNOWN_SIZE - 1)];
>  	struct smack_known *skp;
>  
> -	list_for_each_entry_rcu(skp, &smack_known_list, list) {
> +	list_for_each_entry_rcu(skp, head, htab_list) {
>  		if (strcmp(skp->smk_known, string) == 0)
>  			return skp;
>  	}
> @@ -470,7 +499,7 @@ struct smack_known *smk_import_entry(const char *string, int len)
>  		 * Make sure that the entry is actually
>  		 * filled before putting it on the list.
>  		 */
> -		list_add_rcu(&skp->list, &smack_known_list);
> +		__smk_insert_entry(skp);
>  		goto unlockout;
>  	}
>  	/*
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index fa64740..38f5884 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -3535,6 +3535,8 @@ struct security_operations smack_ops = {
>  
>  static __init void init_smack_known_list(void)
>  {
> +	int i;
> +
>  	/*
>  	 * Initialize rule list locks
>  	 */
> @@ -3553,15 +3555,22 @@ static __init void init_smack_known_list(void)
>  	INIT_LIST_HEAD(&smack_known_floor.smk_rules);
>  	INIT_LIST_HEAD(&smack_known_invalid.smk_rules);
>  	INIT_LIST_HEAD(&smack_known_web.smk_rules);
> +
> +	/*
> +	 * Initialize a hash map for a quick search of SMACK labels
> +	 */
> +	for (i = 0; i < SMACK_KNOWN_SIZE; ++i)
> +		INIT_LIST_HEAD(&smack_known_htab[i]);
> +
>  	/*
>  	 * Create the known labels list
>  	 */
> -	list_add(&smack_known_huh.list, &smack_known_list);
> -	list_add(&smack_known_hat.list, &smack_known_list);
> -	list_add(&smack_known_star.list, &smack_known_list);
> -	list_add(&smack_known_floor.list, &smack_known_list);
> -	list_add(&smack_known_invalid.list, &smack_known_list);
> -	list_add(&smack_known_web.list, &smack_known_list);
> +	__smk_insert_entry(&smack_known_huh);
> +	__smk_insert_entry(&smack_known_hat);
> +	__smk_insert_entry(&smack_known_star);
> +	__smk_insert_entry(&smack_known_floor);
> +	__smk_insert_entry(&smack_known_invalid);
> +	__smk_insert_entry(&smack_known_web);
>  }
>  
>  /**

