Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbaKUPzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:55:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38978 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758565AbaKUPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:55:49 -0500
Message-ID: <546F606D.40407@oracle.com>
Date: Fri, 21 Nov 2014 10:55:25 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de,
        ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no,
        jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: kdbus: add node and filesystem implementation
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org> <1416546149-24799-7-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1416546149-24799-7-git-send-email-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2014 12:02 AM, Greg Kroah-Hartman wrote:
> +static struct dentry *fs_dir_iop_lookup(struct inode *dir,
> +					struct dentry *dentry,
> +					unsigned int flags)
> +{
> +	struct dentry *dnew = NULL;
> +	struct kdbus_node *parent;
> +	struct kdbus_node *node;
> +	struct inode *inode;
> +
> +	parent = kdbus_node_from_dentry(dentry->d_parent);
> +	if (!kdbus_node_acquire(parent))
> +		return NULL;
> +
> +	/* returns reference to _acquired_ child node */
> +	node = kdbus_node_find_child(parent, dentry->d_name.name);
> +	if (node) {
> +		dentry->d_fsdata = node;
> +		inode = fs_inode_get(dir->i_sb, node);
> +		if (IS_ERR(inode))
> +			dnew = ERR_CAST(inode);
> +		else
> +			dnew = d_materialise_unique(dentry, inode);

d_materialise_unique() is gone in Al's fs tree:

[mandatory]
        d_materialise_unique() is gone; d_splice_alias() does everything you
        need now.  Remember that they have opposite orders of arguments ;-/

Maybe it's worth basing your git tree on top of Al's rather than a random
-rc, since it's now a filesystem?


Thanks,
Sasha
