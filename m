Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3FLFL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 01:11:27 -0400
Received: from smtp104.biz.mail.gq1.yahoo.com ([98.137.12.179]:48705 "HELO
	smtp104.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751341Ab3FLFLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 01:11:24 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: NnQ0n4UVM1lHleBe4XGzsSYO59hcdhs7.rjP_42Rz7d0BIm
 sEGtEHxZjL70jOetSBjTcF2n0RKvcWwMEEDEgpotajG6jylRaxENj.2ZA.T4
 IUX4O1N8FGxuYhXBDXp9JTD1zvnX.5RxqIB2FZBV5HZRpuWnlQluMhP6myE7
 JY1E2_19hSpmgMKKRTx5NvmkjKW2fuHTZf_qDFGahBbmD4A113g9uRqkOZP1
 tHdFGroOI9h_uUf1fqqInbOA62wqYXYOWbROrFGUEDLeugw5bbVVzLUGHta3
 BqZ81YJg72y.ND49mveFRO3zd4IOA7DQTt6h_EoTeCf3neRbhJz5kMdITW0K
 S2FMFH8ofLhZjxtKfzUfjvx6SfHltFtMEOdj0Gygit2aG99hsTOuiNPKL6M3
 ckLAHOWRF7VCGg67SFc5qmzdPq83Ud2lXokCv8XRKos7csvamRDeudeIpNco
 RXC8GeNbJKOQyZOuBo.N5bbh1MJia8GOdIqxnByVnqq69ugoTYkpiM2a.7ov
 5npJK
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.10.13] (casey@82.204.39.68 with plain)
        by smtp104.biz.mail.gq1.yahoo.com with SMTP; 11 Jun 2013 22:11:23 -0700 PDT
Message-ID: <51B802EF.2080403@schaufler-ca.com>
Date: Tue, 11 Jun 2013 22:11:11 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFCv2] security: smack: add a hash table to quicken smk_find_entry()
References: <1370955313-3605-1-git-send-email-t.stanislaws@samsung.com> <1370955313-3605-2-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1370955313-3605-2-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/2013 5:55 AM, Tomasz Stanislawski wrote:
> This patch adds a hash table to quicken searching of a smack label by its name.
>
> Basically, the patch improves performance of SMACK initialization.  Parsing of
> rules involves translation from a string to a smack_known (aka label) entity
> which is done in smk_find_entry().

There is one place where this is done, and that is in smk_import_entry().

There is another place where labels are looked up, and that is in
smack_from_secattr(). Can you apply this enhancement there, too?

>
> The current implementation of the function iterates over a global list of
> smack_known resulting in O(N) complexity for smk_find_entry().  The total
> complexity of SMACK initialization becomes O(rules * labels).  Therefore it
> scales quadratically with a complexity of a system.
>
> Applying the patch reduced the complexity of smk_find_entry() to O(1) as long
> as number of label is in hundreds. If the number of labels is increased please
> update SMACK_HASH_SLOTS constant defined in security/smack/smack.h. Introducing
> the configuration of this constant with Kconfig or cmdline might be a good
> idea.
>
> The size of the hash table was adjusted experimentally.  The rule set used by
> TIZEN contains circa 17K rules for 500 labels.  The table above contains
> results of SMACK initialization using 'time smackctl apply' bash command.
> The 'Ref' is a kernel without this patch applied. The consecutive values
> refers to value of SMACK_HASH_SLOTS.  Every measurement was repeated three
> times to reduce noise.
>
>      |  Ref  |   1   |   2   |   4   |   8   |   16  |   32  |   64  |  128  |  256  |  512
> --------------------------------------------------------------------------------------------
> Run1 | 1.156 | 1.096 | 0.883 | 0.764 | 0.692 | 0.667 | 0.649 | 0.633 | 0.634 | 0.629 | 0.620
> Run2 | 1.156 | 1.111 | 0.885 | 0.764 | 0.694 | 0.661 | 0.649 | 0.651 | 0.634 | 0.638 | 0.623
> Run3 | 1.160 | 1.107 | 0.886 | 0.764 | 0.694 | 0.671 | 0.661 | 0.638 | 0.631 | 0.624 | 0.638
> AVG  | 1.157 | 1.105 | 0.885 | 0.764 | 0.693 | 0.666 | 0.653 | 0.641 | 0.633 | 0.630 | 0.627

                 4%      20%     14%     9%      4%      2%      2%      1%      <1%


You get 4% by going to the hlist. The improvement is trivial after 16 slots.
If you have 500 labels and 128 slots that's an average of 4 labels per slot.
That's an awfully big hash table for so few labels and so little performance
gain over what you get with 16 slots. Plus, 500 labels is a huge number of
labels. Most Smack systems should be using far fewer than that. 

>
> Surprisingly, a single hlist is slightly faster than a double-linked list.
> The speed-up saturates near 64 slots.  Therefore I chose value 128 to provide
> some margin if more labels were used.
> It looks that IO becomes a new bottleneck.
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>  security/smack/smack.h        |    5 +++++
>  security/smack/smack_access.c |   30 +++++++++++++++++++++++++++---
>  security/smack/smack_lsm.c    |   12 ++++++------
>  3 files changed, 38 insertions(+), 9 deletions(-)
>
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 339614c..b1d9441 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -53,6 +53,7 @@
>   */
>  struct smack_known {
>  	struct list_head		list;
> +	struct hlist_node		smk_hashed;
>  	char				*smk_known;
>  	u32				smk_secid;
>  	struct netlbl_lsm_secattr	smk_netlabel;	/* on wire labels */
> @@ -222,6 +223,7 @@ char *smk_parse_smack(const char *string, int len);
>  int smk_netlbl_mls(int, char *, struct netlbl_lsm_secattr *, int);
>  char *smk_import(const char *, int);
>  struct smack_known *smk_import_entry(const char *, int);
> +void smk_insert_entry(struct smack_known *skp);
>  struct smack_known *smk_find_entry(const char *);
>  u32 smack_to_secid(const char *);
>  
> @@ -247,6 +249,9 @@ extern struct list_head smk_netlbladdr_list;
>  
>  extern struct security_operations smack_ops;
>  
> +#define SMACK_HASH_SLOTS 128

As outlined above, make this 16.

> +extern struct hlist_head smack_known_hash[SMACK_HASH_SLOTS];
> +
>  /*
>   * Is the directory transmuting?
>   */
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index 6a0377f..b598c32 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -325,6 +325,25 @@ void smack_log(char *subject_label, char *object_label, int request,
>  
>  DEFINE_MUTEX(smack_known_lock);
>  
> +struct hlist_head smack_known_hash[SMACK_HASH_SLOTS];
> +
> +/**
> + * smk_insert_entry - insert a smack label into a hash map,
> + *
> + * this function must be called under smack_known_lock
> + */
> +void smk_insert_entry(struct smack_known *skp)
> +{
> +	unsigned int hash;
> +	struct hlist_head *head;
> +
> +	hash = full_name_hash(skp->smk_known, strlen(skp->smk_known));
> +	head = &smack_known_hash[hash & (SMACK_HASH_SLOTS - 1)];
> +
> +	hlist_add_head_rcu(&skp->smk_hashed, head);
> +	list_add_rcu(&skp->list, &smack_known_list);
> +}
> +
>  /**
>   * smk_find_entry - find a label on the list, return the list entry
>   * @string: a text string that might be a Smack label
> @@ -334,12 +353,17 @@ DEFINE_MUTEX(smack_known_lock);
>   */
>  struct smack_known *smk_find_entry(const char *string)
>  {
> +	unsigned int hash;
> +	struct hlist_head *head;
> +	struct hlist_node *cursor;
>  	struct smack_known *skp;
>  
> -	list_for_each_entry_rcu(skp, &smack_known_list, list) {
> +	hash = full_name_hash(string, strlen(string));
> +	head = &smack_known_hash[hash & (SMACK_HASH_SLOTS - 1)];
> +
> +	hlist_for_each_entry_rcu(skp, cursor, head, smk_hashed)
>  		if (strcmp(skp->smk_known, string) == 0)
>  			return skp;
> -	}
>  
>  	return NULL;
>  }
> @@ -475,7 +499,7 @@ struct smack_known *smk_import_entry(const char *string, int len)
>  		 * Make sure that the entry is actually
>  		 * filled before putting it on the list.
>  		 */
> -		list_add_rcu(&skp->list, &smack_known_list);
> +		smk_insert_entry(skp);
>  		goto unlockout;
>  	}
>  	/*
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 6a08330..6cabca6 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -3868,12 +3868,12 @@ static __init void init_smack_known_list(void)
>  	/*
>  	 * Create the known labels list
>  	 */
> -	list_add(&smack_known_huh.list, &smack_known_list);
> -	list_add(&smack_known_hat.list, &smack_known_list);
> -	list_add(&smack_known_star.list, &smack_known_list);
> -	list_add(&smack_known_floor.list, &smack_known_list);
> -	list_add(&smack_known_invalid.list, &smack_known_list);
> -	list_add(&smack_known_web.list, &smack_known_list);
> +	smk_insert_entry(&smack_known_huh);
> +	smk_insert_entry(&smack_known_hat);
> +	smk_insert_entry(&smack_known_star);
> +	smk_insert_entry(&smack_known_floor);
> +	smk_insert_entry(&smack_known_invalid);
> +	smk_insert_entry(&smack_known_web);
>  }
>  
>  /**

