Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbbATWut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 17:50:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40956 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbATWur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 17:50:47 -0500
Date: Tue, 20 Jan 2015 22:50:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sabrina Dubroca <sd@queasysnail.net>, Paul Moore <pmoore@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150120225041.GK29656@ZenIV.linux.org.uk>
References: <20150120185308.53f4af4e@canb.auug.org.au>
 <20150120165655.GA10904@kria>
 <4237741.ePaG0Gba6D@sifl>
 <20150120175135.GA25973@kria>
 <20150120195432.GH29656@ZenIV.linux.org.uk>
 <20150120204504.GA309@kria>
 <20150120210202.GI29656@ZenIV.linux.org.uk>
 <20150120220823.GB18129@kria>
 <20150120221309.GA18589@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120221309.GA18589@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 02:13:09PM -0800, Guenter Roeck wrote:

> > > Nuts...  Is reverting just this (do_path_lookup()) part of commit sufficient
> > > to recover the normal behaviour?
> > 
> > Yes.
> > 
> Same on microblaze.

This is completely insane.
static int filename_lookup(int dfd, struct filename *name,
                                unsigned int flags, struct nameidata *nd)
{
        int retval = path_lookupat(dfd, name->name, flags | LOOKUP_RCU, nd);
        if (unlikely(retval == -ECHILD))
                retval = path_lookupat(dfd, name->name, flags, nd);
        if (unlikely(retval == -ESTALE))
                retval = path_lookupat(dfd, name->name,
                                                flags | LOOKUP_REVAL, nd);

        if (likely(!retval))
                audit_inode(name, nd->path.dentry, flags & LOOKUP_PARENT);
        return retval;
}
doesn't look at _anything_ other than name->name other than for audit_inode().
And name->name is apparently the same.

It looks like something ends up buggering name->name in process, but then
the damn thing appears to be normal after return from filename_lookup()...
