Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbaDKVwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:52:53 -0400
Received: from smtp107.biz.mail.ne1.yahoo.com ([98.138.207.14]:27810 "HELO
	smtp107.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755660AbaDKVwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:52:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: gNPRwNEVM1n6r6L2HPnY_6njF86jgGiL4V6NS4Za.frzOmi
 cqvW7x.7PSIz2O9BOivvDdK13zfXD7hUl_5_4i8ilcBLx7pw8Jsg8c.3GzfB
 F7DDnnRPngC_F3BIU0ON7oHcXAP_WsqtTe6LAT5PUlYR9rSmE7UotzEJm.oj
 F8jTY86osMTa8fVdJtKYDq9tHDuKeDG5QxAIcbem5b6B_udfFrO73vW.xBIv
 ZKjSec2to.xrfkx0nH3wpnPxtamos0HnXy5QQAI4q4TlnCCUN7dyfYXt1geG
 Rh6kw_uuOYT1QdKKatR678d7kcuSLQcI8hdVZWobGOb5ennrDSR3InH6yr_g
 uYzORYWxQyI_K.PImRq4sJKNr5j.mX7VItfSBaNo62YeyE6L.Q29JWOUCCfT
 u2SSK.G1JyJxo1Hq_cbaIzSckE2AvlLrw4SCLJ_T8DK9wT.m4CeSVFQBRS9b
 A3i6yjWvwRQ.fHPZdGZgdlFym6Mold5wx..CykF0hHDdfk9mytp9PZGR63CD
 UGbWfkn7stWgi5e4cgMw.ak8KHc5yYzC0DywZq2Gso5vOFsj3c8.80o_C4Rl
 J5Uw53eYJxihTuGhA44svB8Lbxs3zR_1ErE8EiIbGnTMFFebFmLyxwhvKQXY
 9urpqCwlTLg--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.105] (casey@67.180.103.242 with plain [98.138.105.25])
        by smtp107.biz.mail.ne1.yahoo.com with SMTP; 11 Apr 2014 14:46:11 -0700 PDT
Message-ID: <534862BD.8010101@schaufler-ca.com>
Date: Fri, 11 Apr 2014 14:46:37 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?Sm9zw6kgQm9sbG8=?= <jose.bollo@open.eurogiciel.org>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
CC: jobol@nonadev.net
Subject: Re: [PATCH 1/1] SMACK: Fix handling value==NULL in post setxattr
References: <1396525721-17307-1-git-send-email-jose.bollo@open.eurogiciel.org>
In-Reply-To: <1396525721-17307-1-git-send-email-jose.bollo@open.eurogiciel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/3/2014 4:48 AM, José Bollo wrote:
> The function `smack_inode_post_setxattr` is called each
> time that a setxattr is done, for any value of name.
> The kernel allow to put value==NULL when size==0
> to set an empty attribute value. The systematic
> call to smk_import_entry was causing the dereference
> of a NULL pointer hence a KERNEL PANIC!
>
> The problem can be produced easily by issuing the
> command `setfattr -n user.data file` under bash prompt
> when SMACK is active.
>
> Moving the call to smk_import_entry as proposed by this
> patch is correcting the behaviour because the function
> smack_inode_post_setxattr is called for the SMACK's
> attributes only if the function smack_inode_setxattr validated
> the value and its size (what will not be the case when size==0).
>
> It also has a benefical effect to not fill the smack hash
> with garbage values coming from any extended attribute
> write.
>
> Change-Id: Iaf0039c2be9bccb6cee11c24a3b44d209101fe47
> Signed-off-by: José Bollo <jose.bollo@open.eurogiciel.org>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Applied to git://git.gitorious.org/smack-next/kernel.git smack-for-3.16

> ---
>  security/smack/smack_lsm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 3f01cf5..28d482c 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -893,18 +893,20 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
>  		return;
>  	}
>  
> -	skp = smk_import_entry(value, size);
>  	if (strcmp(name, XATTR_NAME_SMACK) == 0) {
> +		skp = smk_import_entry(value, size);
>  		if (skp != NULL)
>  			isp->smk_inode = skp->smk_known;
>  		else
>  			isp->smk_inode = smack_known_invalid.smk_known;
>  	} else if (strcmp(name, XATTR_NAME_SMACKEXEC) == 0) {
> +		skp = smk_import_entry(value, size);
>  		if (skp != NULL)
>  			isp->smk_task = skp;
>  		else
>  			isp->smk_task = &smack_known_invalid;
>  	} else if (strcmp(name, XATTR_NAME_SMACKMMAP) == 0) {
> +		skp = smk_import_entry(value, size);
>  		if (skp != NULL)
>  			isp->smk_mmap = skp;
>  		else

