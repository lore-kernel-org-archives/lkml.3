Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3BVHKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:10:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:29791 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab3BVHKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:10:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,713,1355126400"; 
   d="scan'208";a="289150807"
Message-ID: <1361517037.2734.145.camel@sauron.fi.intel.com>
Subject: Re: [PATCH RFC 4/5] UBIFS: Add security.* XATTR support for the
 UBIFS
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Subodh Nijsure <snijsure@grid-net.com>
Date: Fri, 22 Feb 2013 09:10:37 +0200
In-Reply-To: <1360750998-15191-5-git-send-email-mkl@pengutronix.de>
References: <1360750998-15191-1-git-send-email-mkl@pengutronix.de>
	 <1360750998-15191-5-git-send-email-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, the lockdep warnings clearly tell the reason:

        CPU0                    CPU1
        ----                    ----
   lock(&ui->ui_mutex);
                                lock(&sb->s_type->i_mutex_key#10);
                                lock(&ui->ui_mutex);
   lock(&sb->s_type->i_mutex_key#10);

And then there are 2 tracebacks which are useful and show that you
unnecessarily initialize the inode security contenxt whil holding the
parent inode lock. I think you do not need to hold that lock. Move the
initialization out of the protected section.

See below my suggestions.

On Wed, 2013-02-13 at 11:23 +0100, Marc Kleine-Budde wrote:
> @@ -280,6 +280,10 @@ static int ubifs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
>  	err = ubifs_jnl_update(c, dir, &dentry->d_name, inode, 0, 0);
>  	if (err)
>  		goto out_cancel;
> +
> +	err = ubifs_init_security(dir, inode, &dentry->d_name);
> +	if (err)
> +		goto out_cancel;
>  	mutex_unlock(&dir_ui->ui_mutex);

Can you move ubifs_init_security() up to before
'mutex_lock(&dir_ui->ui_mutex)'

> @@ -742,6 +746,10 @@ static int ubifs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
...
> +	err = ubifs_init_security(dir, inode, &dentry->d_name);
> +	if (err)
> +		goto out_cancel;
>  	mutex_unlock(&dir_ui->ui_mutex);

Ditto.

> @@ -818,6 +826,10 @@ static int ubifs_mknod(struct inode *dir, struct dentry *dentry,
...
> +	err = ubifs_init_security(dir, inode, &dentry->d_name);
> +	if (err)
> +		goto out_cancel;
>  	mutex_unlock(&dir_ui->ui_mutex);

Ditto.

> @@ -894,6 +906,10 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
...
> +	err = ubifs_init_security(dir, inode, &dentry->d_name);
> +	if (err)
> +		goto out_cancel;
>  	mutex_unlock(&dir_ui->ui_mutex);

Ditto.

> +int ubifs_init_security(struct inode *dentry, struct inode *inode,
> +			const struct qstr *qstr)
> +{
> +	int err;
> +
> +	mutex_lock(&inode->i_mutex);
> +	err = security_inode_init_security(inode, dentry, qstr,
> +					   &ubifs_initxattrs, 0);
> +	mutex_unlock(&inode->i_mutex);

I did not verify, but I doubt that you need i_mutex here, because you
only call this function when you create an inode, before it becomes
visible to VFS. Please, double-check this.

Thanks!

-- 
Best Regards,
Artem Bityutskiy

