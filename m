Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaJWVZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:25:20 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46623 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaJWVZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:25:17 -0400
Date: Thu, 23 Oct 2014 16:24:51 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michael j Theall <mtheall@us.ibm.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        fuse-devel@lists.sourceforge.net
Subject: Re: [fuse-devel] [PATCH v4 4/5] fuse: Support privileged xattrs only
 with a mount option
Message-ID: <20141023212451.GA141706@ubuntu-hedt>
Mail-Followup-To: Andy Lutomirski <luto@amacapital.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Michael j Theall <mtheall@us.ibm.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	fuse-devel@lists.sourceforge.net
References: <878ukis9oh.fsf@x220.int.ebiederm.org>
 <20141014205955.GA10908@ubuntu-mba51>
 <877g02pd7f.fsf@x220.int.ebiederm.org>
 <CALCETrU3Gzo-dx9uNH3Wuqa8Brk8xcxQsw7YGgVd74simXK0gw@mail.gmail.com>
 <20141015073951.GB10908@ubuntu-mba51>
 <CALCETrWnHfXN9VK9P-97XiVN6LkWr1nV4CxMpsRPGCOMc1xvvg@mail.gmail.com>
 <20141021212151.GB83801@ubuntu-hedt>
 <CALCETrWrqDAbq5uxPxZ=MjfSDetuZa94pNF2EH3abE6PhJm6=g@mail.gmail.com>
 <20141022045848.GA99023@ubuntu-hedt>
 <CALCETrUTxsH=p8QhK80Z3nS3JHT-14-BC0Q1bmAm29UYBo69tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUTxsH=p8QhK80Z3nS3JHT-14-BC0Q1bmAm29UYBo69tA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 11:32:41AM -0700, Andy Lutomirski wrote:
> On Oct 21, 2014 9:59 PM, "Seth Forshee" <seth.forshee@canonical.com> wrote:
> >
> > On Tue, Oct 21, 2014 at 02:27:13PM -0700, Andy Lutomirski wrote:
> > > On Tue, Oct 21, 2014 at 2:21 PM, Seth Forshee
> > >
> > > >         return s;
> > > >
> > > >  fail:
> > > > diff --git a/fs/xattr.c b/fs/xattr.c
> > > > index 64e83efb742d..383bb9f25555 100644
> > > > --- a/fs/xattr.c
> > > > +++ b/fs/xattr.c
> > > > @@ -40,6 +40,12 @@ xattr_permission(struct inode *inode, const char *name, int mask)
> > > >                         return -EPERM;
> > > >         }
> > > >
> > > > +       /* Restrict security.* and trusted.* to mounts from init_user_ns. */
> > > > +       if (inode->i_sb->s_user_ns != &init_user_ns &&
> > > > +           (!strcmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) ||
> > > > +            !strcmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN)))
> > > > +               return -EPERM;
> > > > +
> > >
> > > trusted.* should be fine already, I think -- it checks global
> > > capabilities.  And I still think that security.* should be left to
> > > LSMs, which IMO really do need to be fixed for user namespaces.
> > >
> > > But how does this help with FUSE at all?   Does FUSE end up calling
> > > xattr_permission?
> >
> > It gets called from vfs_getxattr, and thus for the getxattr syscall for
> > all fs types, so this would block reading any trusted.* xattrs from the
> > fuse userspace process.
> 
> Oh.  It seems weird to me that getxattr would get an error instead of
> FUSE being prevented from setting those attributes.
> 
> I'm still unconvinced that this is the right approach.  And anything
> that tries to use LSMs in a container will eventually want those
> attributes.

I suppose so. I'll have to think about this some more.

Thanks,
Seth
