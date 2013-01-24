Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161015Ab3AXWki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:40:38 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:41106 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3AXWka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:40:30 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Hack to use mkdir/rmdir in debugfs
In-Reply-To: Your message of "Tue, 22 Jan 2013 23:44:09 -0500."
             <1358916249.21576.105.camel@gandalf.local.home>
From: Valdis.Kletnieks@vt.edu
References: <1358910114.21576.86.camel@gandalf.local.home> <20130123040846.GA2638@kroah.com> <1358915495.21576.102.camel@gandalf.local.home>
            <1358916249.21576.105.camel@gandalf.local.home>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1359067162_1950P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Jan 2013 17:39:22 -0500
Message-ID: <28808.1359067162@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.5101B81E.0096,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1359067162_1950P
Content-Type: text/plain; charset=us-ascii

On Tue, 22 Jan 2013 23:44:09 -0500, Steven Rostedt said:

> Again, I want to stress that this doesn't touch the debugfs code. Here's
> the real change that I've been testing. It includes the code for the
> "new" and "free" files but those are not created because of an early
> 'return' I added. Notice that it's all contained in
> kernel/trace/trace.c.

So I was looking through here, and something caught my eye....

> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 253cb51..851eb4a 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c


> +static int instance_mkdir (struct inode *inode, struct dentry *dentry, umode
_t mode)
> +{
> +	struct dentry *parent;
> +	int ret;
> +
> +	/* Paranoid: Make sure the parent is the "instances" directory */
> +	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_alias);
> +	if (WARN_ON_ONCE(parent != trace_instance_dir))
> +		return -ENOENT;
> +
> +	/*
> +	 * The inode mutex is locked, but debugfs_create_dir() will also
> +	 * take the mutex. As the instances directory can not be destroyed
> +	 * or changed in any other way, it is safe to unlock it, and
> +	 * let the dentry try. If two users try to make the same dir at
> +	 * the same time, then the new_instance_create() will determine the
> +	 * winner.
> +	 */
> +	mutex_unlock(&inode->i_mutex);
> +
> +	ret = new_instance_create(dentry->d_iname);
> +
> +	mutex_lock(&inode->i_mutex);
> +
> +	return ret;
> +}
> +
> +static int instance_rmdir(struct inode *inode, struct dentry *dentry)
> +{
> +	struct dentry *parent;
> +	int ret;
> +
> +	/* Paranoid: Make sure the parent is the "instances" directory */
> +	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_alias);
> +	if (WARN_ON_ONCE(parent != trace_instance_dir))
> +		return -ENOENT;
> +
> +	/* The caller did a dget() on dentry */
> +	mutex_unlock(&dentry->d_inode->i_mutex);
> +
> +	/*
> +	 * The inode mutex is locked, but debugfs_create_dir() will also
> +	 * take the mutex. As the instances directory can not be destroyed
> +	 * or changed in any other way, it is safe to unlock it, and
> +	 * let the dentry try. If two users try to make the same dir at
> +	 * the same time, then the instance_delete() will determine the
> +	 * winner.
> +	 */
> +	mutex_unlock(&inode->i_mutex);

Looks like the rmdir comment was slice-n-miced from the mkdir one?

What exactly *are* the race condition rules here, especially for mkdir
racing against an rmdir?

--==_Exmh_1359067162_1950P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUQG4GgdmEQWDXROgAQI2yxAAkii3N6rrvZuLqPX02J0IEj5m7j6jweLb
G3xmljJbUM14u4IlMUoHTzGI1rumsD183Ap1fHlDSB7H6+zEu4Np5gi5Fs+KDjRG
h9Z8OCQtBnZXpugN8S6zWmFk1WXqMwiR2oBAM+ueTGX83q0KHiUlor1z+7g45nym
ReTFmFEGVhSUf0qTxkkL886UOo9DgwmJW4R7tfcLNYlumhWlG2KkjHkRPDIddOeA
hDZVQmLAxNnNryz7m1IL70fF9iaqW2Mdu+sxZSVLgBEF1P+EODvWfBOXxHOz8JXZ
uitqOBCjrFYRRpvuAwtTpHBJcI4lTcp2jLq6PltCexfNASbWeFZL/Xpr6MHBtBan
6aPZ2Q3izu3EjVx7VbCvdsMjkAGEpb6Qu06+o0nXBZYvV+d+P4YKOJchhWw38H2Y
cr64bN3tzZU1zwk/gkob5faZ0dM5XHeDYCQOZidv39KrC1WTTsBlluKsDE+sM1Lj
7vdcZtLU45EJm25NQr7HmJgHjF8KalZgZhi64t0jt1qp9aFFyNqG/s/aHyxNQb+j
9QJDL2vNnZy77mREGJsdFYgpiGjC08COKhotn+hMhN6fW7XvstZyJTRRrCLEZL6G
PtQYvwcGzjVJ4WpgUhJT2d5nEuXHhZ7BLRo3OmlCd09uBLMOVVakv0H32llzgobW
X4b5oCguX7A=
=UDq3
-----END PGP SIGNATURE-----

--==_Exmh_1359067162_1950P--

