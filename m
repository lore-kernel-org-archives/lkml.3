Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaKGOt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:49:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbaKGOtZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:49:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <545BB3DD.1010607@schaufler-ca.com>
References: <545BB3DD.1010607@schaufler-ca.com> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154228.2555.55814.stgit@warthog.procyon.org.uk>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Security: Provide copy-up security hooks for unioned files
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29643.1415371754.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Fri, 07 Nov 2014 14:49:14 +0000
Message-ID: <29644.1415371754@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> > + * @inode_copy_up:
> > + *	Generate the secid associated with the destination inode when a unioned
> 
> NAK.
> 
> You can't just deal with the access label, nor can you assume that there
> is exactly one. Don't use secids. ...

Okay, I've changed the documentation to:

 * @inode_copy_up:
 *	Appropriately label the destination inode when a unioned file is copied
 *	up from a lower layer to the union/overlay layer.
 *	@src indicates the file that is being copied up.
 *	@dst indicates the file that has being created by the copy up.
 *	Returns 0 on success or a negative error code on error.

> > + * @inode_copy_up_xattr:
> > + *	Filter/modify the xattrs being copied up when a unioned file is copied
> > + *	up from a lower layer to the union/overlay layer.
> > + *	@src indicates the file that is being copied up.
> > + *	@dst indicates the file that has being created by the copy up.
> > + *	@name indicates the name of the xattr.
> > + *	@value, *@size indicate the payload of the xattr.
> > + *	Returns 0 to accept the xattr, 1 to discard the xattr or a negative
> > + *	error code to abort the copy up.  The xattr buffer must be at least
> > + *	XATTR_SIZE_MAX in capacity and the contents may be modified and *@size
> > + *	changed appropriately.
>
> Who is going to call this?

Anyone that copies up a file from the lower layer in a union to an upper
layer.  Overlayfs for example.  Unionmount for another.

> How are is the caller going to know all the xattr names that matter?

The caller has no idea.  That's why it presents them all here.

> > +static int cap_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
> > +				   const char *name, void *value, size_t *size)
> > +{
> > +	return 0;
> > +}
> > +
> 
> Does this mean that without LSM help no xattrs ever get copied?

No.  This is merely a filter.  The caller reads the xattr, presents them to
this hook and then, if not asked to discard, writes the xattr.  I've added a
bit to the end of the comment to this effect.

David
