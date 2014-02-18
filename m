Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaBSGmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:42:40 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:1059 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbaBSGmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:42:39 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0hALZRBFNbskPZ/2dsb2JhbABZKIJeOKkUmAYCAoEVF3SCJQEBBAEnExwjBQsIAw4KLjkeBhOHfQwBzScXjmQHhDgBA4lGhHqJbwGBMpBygzov
Date: Wed, 19 Feb 2014 06:43:46 +0800
From: Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] fs: xattr: Don't display attributes without read
 access
Message-Id: <20140219064346.368926eb15e42d461720817c@skynet.be>
In-Reply-To: <20140218151650.02fb2d6034deb2d3d11ccc7a@linux-foundation.org>
References: <20140216203101.bf432a8b7b40703197a91462@skynet.be>
	<20140218151650.02fb2d6034deb2d3d11ccc7a@linux-foundation.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014 15:16:50 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 16 Feb 2014 20:31:01 +0800 Fabian Frederick <fabf@skynet.be> wrote:
> 
> > Any user can display extented attribute names without read
> > access.
> > 
> > eg: attr -l <filename>
> > 
> > This patch checks inode_permission in listxattr common
> > function before executing vfs_listxattr.
> > 
> > ...
> >
> > --- a/fs/xattr.c
> > +++ b/fs/xattr.c
> > @@ -543,6 +543,10 @@ listxattr(struct dentry *d, char __user *list, size_t size)
> >  	char *klist = NULL;
> >  	char *vlist = NULL;	/* If non-NULL, we used vmalloc() */
> >  
> > +	error = inode_permission(d->d_inode, MAY_READ);
> > +	if (error)
> > +		return error;
> > +
> >  	if (size) {
> >  		if (size > XATTR_LIST_MAX)
> >  			size = XATTR_LIST_MAX;
> 
> erk.  Doesn't this mean that if existing userspace is relying on the
> current behaviour, this patch will cause breakage?
> 
IMHO userspace applications already receive weird results in that case.

Without read permission, attr -l receives attribute names which means
it tries lgetxattr on those attributes where result is EACCESS :
"Attribute <attribute name> has -1 byte" !!!

Besides, is it semantically correct for a user to have access to
 a part of "file content" without read access ?
 
With that patch, attr -l <filename> displays

attr_list: Permission denied
Could not list "(null)" for <filename>

On the other hand, when stracing that situation, 
I do see attr making more noise than usual ie it's opening all attr.mo 
twice so I guess I should return something else than "permission denied" to avoid problems in userspace ...

Fabian

