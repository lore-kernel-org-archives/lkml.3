Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaJWPkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:40:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885AbaJWPkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:40:10 -0400
Date: Thu, 23 Oct 2014 17:40:07 +0200
From: Jan Kara <jack@suse.cz>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        jack@suse.cz, dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 1/2] ima: check xattr value length in ima_inode_setxattr()
Message-ID: <20141023154007.GA21034@quack.suse.cz>
References: <cover.1414071910.git.d.kasatkin@samsung.com>
 <5b1f234e8515c10c96a16868ff4341f29460f38f.1414071910.git.d.kasatkin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b1f234e8515c10c96a16868ff4341f29460f38f.1414071910.git.d.kasatkin@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 23-10-14 16:47:17, Dmitry Kasatkin wrote:
> ima_inode_setxattr() can be called with no value. Function does not
> check the length so that following command can be used to produce
> kernel oops: setfattr -n security.ima FOO. This patch fixes it.
> 
..
> 
> Reported-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  security/integrity/ima/ima_appraise.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index 5b845af..f07aacd 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -378,6 +378,8 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
>  	result = ima_protect_xattr(dentry, xattr_name, xattr_value,
>  				   xattr_value_len);
>  	if (result == 1) {
> +		if (!xattr_value_len)
> +			return -EINVAL;
  Wouldn't it be safer to return EINVAL whenever xattr_value_len !=
sizeof(evm_ima_xattr_data)?

								Honza
>  		ima_reset_appraise_flags(dentry->d_inode,
>  			 (xvalue->type == EVM_IMA_XATTR_DIGSIG) ? 1 : 0);
>  		result = 0;
> -- 
> 1.9.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
