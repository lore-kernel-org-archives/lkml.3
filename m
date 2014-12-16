Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaLPQim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:38:42 -0500
Received: from smtp105.biz.mail.bf1.yahoo.com ([98.139.221.43]:27685 "EHLO
	smtp105.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbaLPQil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:38:41 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4tGlvf8VM1nT1iM7gK._Rn6k7nl5FhkefFf2_.TQOi6A1WT
 _y1gZIkWxa2ISl._YcZx9YVBYGaV9XYlEm.zqAYsSdkFD9QhrEr_vOM_n.w9
 wnD24aAgvZ5ZALlmXvqS.AcsyykJQoQ1bKw_xsrULcTXkfemIsOovZDQUq_P
 3hBV1aegbHii1QvZ9413SHwD4T0HUV7rd5pmXjkgR4sawiL8bc5535KjsgYJ
 znh9zz8RPaNa31Dthd6WMClCTY7lCKnYMYygmJ_ZDd0zuDXkDe7qbT_.tmZw
 dVxykwH3dBkdZqgBpiq2uQbMuD01D.fyQ29xOL7qdQVnYKsHuIuxblxQz2pO
 lPV6oPYne3Y0pgmWxxosBznP420A.9Qg_3W_UI9wm8U7LqSdKZp4kpf8llUy
 _QdKYAOp6nbrltpocciMfd2ZBfvaaVJ.dCY67hu_pBW_yBZhsTx6jSV3HslA
 nf.41rUU8A9uxxRQcQ.mcg6weDOzl3JkX5N9x20iZK64z1e8x54Fa5BxOEoe
 OJEG_H8xzy5TFo8.w91S9kmI74lbtaQJ13.dZCSWxL65IhurME8yKIZeEC3g
 GlRZ9oxDDZDKXNVBvOdvbBWiXET53B5jgdasLbB1dvG3ZNplcDFaaOxbjZyt
 JPPK_71QiIMw2
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <54906016.7020004@schaufler-ca.com>
Date: Tue, 16 Dec 2014 08:38:46 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?xYF1a2FzeiBTdGVsbWFjaA==?= <l.stelmach@samsung.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Karol Lewandowski <k.lewandowsk@samsung.com>, l.skalski@samsung.com,
        m.wereski@partner.samsung.com, r.krypa@samsung.com,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v2] smack: introduce a special case for tmpfs in smack_d_instantiate()
References: <1418745188-23662-1-git-send-email-l.stelmach@samsung.com>
In-Reply-To: <1418745188-23662-1-git-send-email-l.stelmach@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 7:53 AM, Łukasz Stelmach wrote:
> Files created with __shmem_file_stup() appear to have somewhat fake
> dentries which make them look like root directories and not get
> the label the current process or ("*") star meant for tmpfs files.
>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>

Applied to git://git.gitorious.org/smack-next/kernel.git#smack-for-3.20

> ---
>  security/smack/smack_lsm.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index e8bed86..b774029 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -3036,18 +3036,30 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
>  	 * If that is the case use the root value out
>  	 * of the superblock.
>  	 */
>  	if (opt_dentry->d_parent == opt_dentry) {
> -		if (sbp->s_magic == CGROUP_SUPER_MAGIC) {
> +		switch (sbp->s_magic) {
> +		case CGROUP_SUPER_MAGIC:
>  			/*
>  			 * The cgroup filesystem is never mounted,
>  			 * so there's no opportunity to set the mount
>  			 * options.
>  			 */
>  			sbsp->smk_root = &smack_known_star;
>  			sbsp->smk_default = &smack_known_star;
> +			isp->smk_inode = sbsp->smk_root;
> +			break;
> +		case TMPFS_MAGIC:
> +			/*
> +			 * What about shmem/tmpfs anonymous files with dentry
> +			 * obtained from d_alloc_pseudo()?
> +			 */
> +			isp->smk_inode = smk_of_current();
> +			break;
> +		default:
> +			isp->smk_inode = sbsp->smk_root;
> +			break;
>  		}
> -		isp->smk_inode = sbsp->smk_root;
>  		isp->smk_flags |= SMK_INODE_INSTANT;
>  		goto unlockandout;
>  	}
>  

