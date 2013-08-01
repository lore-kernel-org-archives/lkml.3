Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3HAUBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:01:52 -0400
Received: from smtp102.biz.mail.bf1.yahoo.com ([98.139.221.61]:48684 "HELO
	smtp102.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751989Ab3HAUBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:01:49 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5YDO69cVM1kBJBjtuS_BgIlHvYmdStOASx6Vkc.V5AKsspg
 ha9.XZs5KkDPomZzh9Hz6d.riWgUUAXYleXiFwV0dy_x.Eb7MusSsWIEcfwn
 cZErTs4t9inlcUImVewi8enSSy.Lc_j5V3LmubZozWj9bcXSpAra5reX08bV
 DA4QXr1NcjcAJzAl8mvY_Wd10jGVnqax47GYi3JrlEcMvrf1fPOom90yZC4L
 LnAHQjVoGD43k12hFUJZyb56quuHpKv5k3m46fW3RBNFswr9NMLXJok.0ifi
 ds5VRSmSW2CSH2Xg6faCtecg39n_i6e6Ydyzp.Xmf0S8ckDv6s3Tyqocrjuj
 UHNO9W5Bnw1xaaO2UNtZhoJI8xeaQXU.xh8r8lEhqxnX9lFrJfnf3MBn5rtD
 hUD_4NC5DECcPrepe5YEY6749pB_NyVDsfOnXI581D3V2lNZfcirEzJaZVsT
 n.fsrG60FNXQtVji4LqnF7sQ3PAjH3lj32R11XqTrmCktJmeSd5s2b2tjY6S
 5qQH_PyOHBm80dtDMc4W4Mj_v7geLt0_GiLepQQ4U9vKEVAYMPknxm8BARg3
 kSMPFGr7qRPvByNWENUxxxA1AYKSltIkR0Rmuq8MR4lweeVXmUzWXAHO8Z29
 4X4vY6vQsLB7fPd_FfrkbGkFb_blb
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp102.biz.mail.bf1.yahoo.com with SMTP; 01 Aug 2013 13:01:48 -0700 PDT
Message-ID: <51FABEAB.3080600@schaufler-ca.com>
Date: Thu, 01 Aug 2013 13:01:47 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] security: smack: fix memleak in smk_write_rules_list()
References: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com> <51C1BB6C.8010105@samsung.com>
In-Reply-To: <51C1BB6C.8010105@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/2013 7:08 AM, Tomasz Stanislawski wrote:
> >From 8497987bedf8821db3dce47a6205dfce2b0895c5 Mon Sep 17 00:00:00 2001
> From: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Date: Thu, 6 Jun 2013 09:30:50 +0200
> Subject: [PATCH] security: smack: fix memleak in smk_write_rules_list()
>
> The smack_parsed_rule structure is allocated.  If a rule is successfully
> installed then the last reference to the object is lost.  This patch fixes this
> leak. Moreover smack_parsed_rule is allocated on stack because it no longer
> needed ofter smk_write_rules_list() is finished.
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>


Applied to git://git.gitorious.org/smack-next/kernel.git#smack-for-3.12

Rebasing was required. The change has been tested.

> ---
>  security/smack/smackfs.c |   30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)
>
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 53a08b8..08aebc2 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -446,7 +446,7 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>  					struct mutex *rule_lock, int format)
>  {
>  	struct smack_known *skp;
> -	struct smack_parsed_rule *rule;
> +	struct smack_parsed_rule rule;
>  	char *data;
>  	int datalen;
>  	int rc = -EINVAL;
> @@ -478,49 +478,39 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
>  		goto out;
>  	}
>
> -	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
> -	if (rule == NULL) {
> -		rc = -ENOMEM;
> -		goto out;
> -	}
> -
>  	if (format == SMK_LONG_FMT) {
>  		/*
>  		 * Be sure the data string is terminated.
>  		 */
>  		data[count] = '\0';
> -		if (smk_parse_long_rule(data, rule, 1, 0))
> -			goto out_free_rule;
> +		if (smk_parse_long_rule(data, &rule, 1, 0))
> +			goto out;
>  	} else if (format == SMK_CHANGE_FMT) {
>  		data[count] = '\0';
> -		if (smk_parse_long_rule(data, rule, 1, 1))
> -			goto out_free_rule;
> +		if (smk_parse_long_rule(data, &rule, 1, 1))
> +			goto out;
>  	} else {
>  		/*
>  		 * More on the minor hack for backward compatibility
>  		 */
>  		if (count == (SMK_OLOADLEN))
>  			data[SMK_OLOADLEN] = '-';
> -		if (smk_parse_rule(data, rule, 1))
> -			goto out_free_rule;
> +		if (smk_parse_rule(data, &rule, 1))
> +			goto out;
>  	}
>
>
>  	if (rule_list == NULL) {
>  		load = 1;
> -		skp = smk_find_entry(rule->smk_subject);
> +		skp = smk_find_entry(rule.smk_subject);
>  		rule_list = &skp->smk_rules;
>  		rule_lock = &skp->smk_rules_lock;
>  	}
>
> -	rc = smk_set_access(rule, rule_list, rule_lock, load);
> -	if (rc == 0) {
> +	rc = smk_set_access(&rule, rule_list, rule_lock, load);
> +	if (rc == 0)
>  		rc = count;
> -		goto out;
> -	}
>
> -out_free_rule:
> -	kfree(rule);
>  out:
>  	kfree(data);
>  	return rc;

