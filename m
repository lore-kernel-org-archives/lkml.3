Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaBGT6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:58:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbaBGT6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:58:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140207173636.GA8801@fieldses.org>
References: <20140207173636.GA8801@fieldses.org> <1391791751-2533-1-git-send-email-miklos@szeredi.hu> <1391791751-2533-2-git-send-email-miklos@szeredi.hu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: dhowells@redhat.com, Miklos Szeredi <miklos@szeredi.hu>,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 01/13] vfs: add d_is_dir()
Date: Fri, 07 Feb 2014 19:30:57 +0000
Message-ID: <26966.1391801457@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> On Fri, Feb 07, 2014 at 05:48:59PM +0100, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Add d_is_dir(dentry) helper which is analogous to S_ISDIR().
> 
> While trying to get up to speed I notice that these flags were
> introduced by b18825a7c8e37a7cf6abb97a12a6ad71af160de7 "VFS: Put a small
> type field into struct dentry::d_flags" whose changelog tells me "what"
> but not "why".  So out of curiosity: was that some kind of optimization,
> or was there some other reason for it?

The idea is to put into the dentry information about objects that pathwalk
specifically needs to know about, ie. negative dentries, dirs, automount
points and symlinks so that you don't have to look this up in the inode.

We can use this to distinguish lookupable dirs from nonlookupable dirs
(ie. automounts), thereby subsuming the can_lookup query.

However, the real power comes in support for fs unioning.  There are two
additional uses for this field:

 (1) Whiteout dentry type.  An additional type is added for this field which
     causes d_is_negative() to return true, but can be distinguished when
     trying to decide whether to look in a lower layer or not.

 (2) Fallthroughs.  Whilst the dentry may appear negative by virtue of having
     a NULL d_inode pointer, it does in fact correspond to a real object on a
     lower layer.  The type of the lower object is set in this field so that
     pathwalk can immediately know how to deal with it.

David
