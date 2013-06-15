Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3FOUAD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 16:00:03 -0400
Received: from nm8-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.191]:47142
	"EHLO nm8-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754502Ab3FOUAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 16:00:00 -0400
X-Yahoo-Newman-Id: 626199.93247.bm@smtp103.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XM4su1EVM1miGpVTCuD74k9nuCylOQ3H.HyzELWdvXbe3N0
 HCCZ.9nLAHBnMFH0TbOt7pYNw_rXUoX4BYoU2fyD_Y0P3PIO8QBIDPoz8mKs
 5_GLyfIvfy1d6_FsjFD7h1cR55x2S_Bir7ibRfmMImdQ_1syhBYvTJ7Thf5G
 I2c.WEjaF4a2pSGlutRwKXR11ejyPJ6LPJeXBQrAYwRDQlOl4bTHYQZDGWty
 QkGrPUV23t4aI.FoyCb8F3YT9CtEdK5AqzhjNGrtg49Kpx.F53DfX6ytl0aO
 05w099TahzFHMLPwCyLMImJATuQAju1YKvR2ksD7Tx4M59gpeptQHWJIZVWy
 GUh7Hsjd.15Q6QbmKSe8BEhuxyRx8hZxp52Ho_nEX08X7Xq0xyOjZFWqPstv
 Y3IXBw596YuIPytjA3MzzmfZEqBcl_Wy5x2qzJ8Uv24OyCe4O0gjeGjCJZW5
 VBHDN60dJEQ_rT9nYd.4XT9JPxdAgE4Svucf.n4.JrKh1
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp103.biz.mail.bf1.yahoo.com with SMTP; 15 Jun 2013 12:59:59 -0700 PDT
Message-ID: <51BCC7CB.8060005@schaufler-ca.com>
Date: Sat, 15 Jun 2013 13:00:11 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-security-module@vger.kernel.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC 4/5] security: smack: add kmem_cache for smack_rule allocations
References: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com> <1371137352-31273-5-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1371137352-31273-5-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/2013 8:29 AM, Tomasz Stanislawski wrote:
> On ARM, sizeof(struct smack_rule)==20. Allocation by kmalloc() uses a
> 32-byte-long chunk to allocate 20 bytes. Just ask ksize().  It means that 40%
> of memory is simply wasted for padding bytes.
>
> The problem is fixed in this patch by using kmem_cache. The cache allocates
> struct smack_rule using 24-byte-long chunks according to ksize(). This reduces
> amount of used memory by 25%.

I'm not opposed to this change, but could I see some performance
numbers to justify it? In particular, I'm concerned about the rules
load impact.

> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>  security/smack/smack.h     |    3 +++
>  security/smack/smack_lsm.c |   11 ++++++++++-
>  security/smack/smackfs.c   |    2 +-
>  3 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 8ad3095..38ba673 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -233,6 +233,9 @@ extern struct mutex	smack_known_lock;
>  extern struct list_head smack_known_list;
>  extern struct list_head smk_netlbladdr_list;
>  
> +/* Cache for fast and thrifty allocations */
> +extern struct kmem_cache *smack_rule_cache;
> +
>  extern struct security_operations smack_ops;
>  
>  /*
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index d52c780..7aa696a 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -3564,6 +3564,9 @@ static __init void init_smack_known_list(void)
>  	list_add(&smack_known_web.list, &smack_known_list);
>  }
>  
> +/* KMEM caches for fast and thrifty allocations */
> +struct kmem_cache *smack_rule_cache;
> +
>  /**
>   * smack_init - initialize the smack system
>   *
> @@ -3577,10 +3580,16 @@ static __init int smack_init(void)
>  	if (!security_module_enable(&smack_ops))
>  		return 0;
>  
> +	smack_rule_cache = KMEM_CACHE(smack_rule, 0);
> +	if (!smack_rule_cache)
> +		return -ENOMEM;
> +
>  	tsp = new_task_smack(smack_known_floor.smk_known,
>  				smack_known_floor.smk_known, GFP_KERNEL);
> -	if (tsp == NULL)
> +	if (tsp == NULL) {
> +		kmem_cache_destroy(smack_rule_cache);
>  		return -ENOMEM;
> +	}
>  
>  	printk(KERN_INFO "Smack:  Initializing.\n");
>  
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index e8c57f3..c08b1ec 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -217,7 +217,7 @@ static int smk_set_access(struct smack_parsed_rule *srp,
>  	}
>  
>  	if (found == 0) {
> -		sp = kzalloc(sizeof(*sp), GFP_KERNEL);
> +		sp = kmem_cache_zalloc(smack_rule_cache, GFP_KERNEL);
>  		if (sp == NULL) {
>  			rc = -ENOMEM;
>  			goto out;

