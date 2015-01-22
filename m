Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbbAVQEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:04:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbbAVQEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:04:22 -0500
Date: Thu, 22 Jan 2015 11:04:05 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Paul Moore <pmoore@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-audit@redhat.com, sd@queasysnail.net,
        linux-kernel@vger.kernel.org, linux@roeck-us.net,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v2 4/5] audit: fix filename matching in __audit_inode()
 and __audit_inode_child()
Message-ID: <20150122160405.GJ18752@madcap2.tricolour.ca>
References: <20150122045303.1347.98054.stgit@localhost>
 <20150122050016.1347.17253.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122050016.1347.17253.stgit@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/22, Paul Moore wrote:
> In all likelihood there were some subtle, and perhaps not so subtle,
> bugs with filename matching in audit_inode() and audit_inode_child()
> for some time, however, recent changes to the audit filename code have
> definitely broken the filename matching code.  The breakage could
> result in duplicate filenames in the audit log and other odd audit
> record entries.  This patch fixes the filename matching code and
> restores some sanity to the filename audit records.
> 
> CC: viro@zeniv.linux.org.uk
> CC: linux-fsdevel@vger.kernel.org
> Signed-off-by: Paul Moore <pmoore@redhat.com>

Noted change to use the iterator instead of the reference in the inode check.

Reviewed-by: Richard Guy Briggs <rgb@redhat.com>

> ---
>  kernel/auditsc.c |   34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index c967ffc..c54b5f0 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -1846,6 +1846,7 @@ void __audit_inode(struct filename *name, const struct dentry *dentry,
>  	/* The struct filename _must_ have a populated ->name */
>  	BUG_ON(!name->name);
>  #endif
> +
>  	/*
>  	 * If we have a pointer to an audit_names entry already, then we can
>  	 * just use it directly if the type is correct.
> @@ -1863,7 +1864,17 @@ void __audit_inode(struct filename *name, const struct dentry *dentry,
>  	}
>  
>  	list_for_each_entry_reverse(n, &context->names_list, list) {
> -		if (!n->name || strcmp(n->name->name, name->name))
> +		if (n->ino) {
> +			/* valid inode number, use that for the comparison */
> +			if (n->ino != inode->i_ino ||
> +			    n->dev != inode->i_sb->s_dev)
> +				continue;
> +		} else if (n->name) {
> +			/* inode number has not been set, check the name */
> +			if (strcmp(n->name->name, name->name))
> +				continue;
> +		} else
> +			/* no inode and no name (?!) ... this is odd ... */
>  			continue;
>  
>  		/* match the correct record type */
> @@ -1931,11 +1942,16 @@ void __audit_inode_child(const struct inode *parent,
>  
>  	/* look for a parent entry first */
>  	list_for_each_entry(n, &context->names_list, list) {
> -		if (!n->name || n->type != AUDIT_TYPE_PARENT)
> +		if (!n->name ||
> +		    (n->type != AUDIT_TYPE_PARENT &&
> +		     n->type != AUDIT_TYPE_UNKNOWN))
>  			continue;
>  
> -		if (n->ino == parent->i_ino &&
> -		    !audit_compare_dname_path(dname, n->name->name, n->name_len)) {
> +		if (n->ino == parent->i_ino && n->dev == parent->i_sb->s_dev &&
> +		    !audit_compare_dname_path(dname,
> +					      n->name->name, n->name_len)) {
> +			if (n->type == AUDIT_TYPE_UNKNOWN)
> +				n->type = AUDIT_TYPE_PARENT;
>  			found_parent = n;
>  			break;
>  		}
> @@ -1944,11 +1960,8 @@ void __audit_inode_child(const struct inode *parent,
>  	/* is there a matching child entry? */
>  	list_for_each_entry(n, &context->names_list, list) {
>  		/* can only match entries that have a name */
> -		if (!n->name || n->type != type)
> -			continue;
> -
> -		/* if we found a parent, make sure this one is a child of it */
> -		if (found_parent && (n->name != found_parent->name))
> +		if (!n->name ||
> +		    (n->type != type && n->type != AUDIT_TYPE_UNKNOWN))
>  			continue;
>  
>  		if (!strcmp(dname, n->name->name) ||
> @@ -1956,6 +1969,8 @@ void __audit_inode_child(const struct inode *parent,
>  						found_parent ?
>  						found_parent->name_len :
>  						AUDIT_NAME_FULL)) {
> +			if (n->type == AUDIT_TYPE_UNKNOWN)
> +				n->type = type;
>  			found_child = n;
>  			break;
>  		}
> @@ -1984,6 +1999,7 @@ void __audit_inode_child(const struct inode *parent,
>  			found_child->name_put = false;
>  		}
>  	}
> +
>  	if (inode)
>  		audit_copy_inode(found_child, dentry, inode);
>  	else
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
