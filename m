Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3IHE6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 00:58:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45116 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab3IHE6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 00:58:20 -0400
Date: Sun, 8 Sep 2013 05:58:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>,
        Sage Weil <sage@inktank.com>
Subject: Re: [PATCH v3 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130908045814.GG13318@ZenIV.linux.org.uk>
References: <1378483738-10129-2-git-send-email-Waiman.Long@hp.com>
 <CA+55aFw8UuEmKsSdGZPUmcekZheNimEt4U81i7Bz0LipGzsFmg@mail.gmail.com>
 <20130906210546.GW13318@ZenIV.linux.org.uk>
 <CA+55aFzf-reQNSQt_fhHfUe_tB19n2qEa=Rd=wFEBJEVALmezA@mail.gmail.com>
 <20130907000044.GX13318@ZenIV.linux.org.uk>
 <CA+55aFwy_x65HaLOgKuK7AyQayraU4M6q78L_hnAvLg1NSgTpw@mail.gmail.com>
 <CA+55aFzwederWB135Ch+PjijjrN-kz9UKw+obC4+M_+xq648PA@mail.gmail.com>
 <20130907030110.GY13318@ZenIV.linux.org.uk>
 <20130907173243.GD13318@ZenIV.linux.org.uk>
 <1378613746.2642.8.camel@perseus.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378613746.2642.8.camel@perseus.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 12:15:46PM +0800, Ian Kent wrote:
> > and *name is never modified in it.  Why not simply pass it by value?
> > Moreover, I'm not sure I understand what do we need sbi->fs_lock in
> > there.  Other than that, it's very close to dentry_path() (well, that
> > and different calling conventions).  Ian?
> 
> Yes, it is close to dentry_path() but the path functions used to return
> the full path to the root, although I don't see where dentry_path() get
> the root, mmm ... 

dentry_path(), unlike d_path(), is relative to the root of filesystem
containing dentry in question.  There are 3 of those suckers:
	d_path(): vfsmount/dentry => path to current process' root
	d_absolute_path(): ditto, but ignores chroot jails (goes to
the absolute root of namespace)
	dentry_path(): dentry => path from root of fs containing that
dentry.

IOW, if you have something mounted on /jail/mnt/foo and are chrooted into
/jail, passing vfsmount/dentry of /jail/mnt/foo/bar/baz to d_path() will
yield "/mnt/foo/bar/baz", to d_absolute_path() - "/jail/mnt/foo/bar/baz" and
passing the same dentry to dentry_path() - "/bar/baz".
