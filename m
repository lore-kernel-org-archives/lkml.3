Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250Ab3IDBDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:03:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55232 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934081Ab3IDBDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:03:05 -0400
Date: Wed, 4 Sep 2013 02:03:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, rui.xiang@huawei.com,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] autofs4 - fix device ioctl mount lookup
Message-ID: <20130904010301.GE13318@ZenIV.linux.org.uk>
References: <20130904005456.5025.94309.stgit@perseus.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904005456.5025.94309.stgit@perseus.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 08:54:57AM +0800, Ian Kent wrote:
> +static int kern_path_top(const char *pathname,
> +			 unsigned int flags, struct path *path)
> +{
> +	struct dentry *dentry;
> +	struct qstr name;
> +	const char *tmp;
> +	unsigned int len;
> +	int err;
> +
> +	len = strlen(pathname);
> +	if (len <= 1)
> +		return -EINVAL;
> +
> +	tmp = pathname + len - 1;
> +	len = 0;
> +	if (*tmp == '/')
> +		tmp--;
> +	do {
> +		if (*tmp == '/')
> +			break;
> +		len++;
> +	} while (--tmp >= pathname);
> +	tmp++;
> +
> +	err = kern_path(pathname, flags | LOOKUP_PARENT, path);
> +	if (err)
> +		return err;
> +
> +	name.name = tmp;
> +	name.len = len;
> +	name.hash = full_name_hash(tmp, len);
> +
> +	dentry = d_lookup(path->dentry, &name);
> +	if (!dentry) {
> +		path_put(path);
> +		return -ENOENT;
> +	}
> +	dput(path->dentry);
> +	path->dentry = dentry;
> +
> +	while (follow_down_one(path))
> +		;
> +
> +	return 0;
> +}

Ewwww...   NAK in that form.  Just what will happen if the last component
given to that sucker will be . or .., for starters?  Or a symlink, with
'/' added to it to force following the damn thing?
