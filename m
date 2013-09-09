Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3IIL4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:56:15 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33517 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284Ab3IIL4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:56:09 -0400
X-Sasl-enc: seMmmlw11apNEdZZh1V0P8T4mXfnQkwkhd/g00PO5uFU 1378727767
Message-ID: <1378727764.3212.14.camel@perseus.fritz.box>
Subject: Re: [PATCH 2/2] autofs4 - fix device ioctl mount lookup
From: Ian Kent <raven@themaw.net>
To: Jeff Layton <jlayton@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 09 Sep 2013 19:56:04 +0800
In-Reply-To: <20130909064531.07b8a9de@corrin.poochiereds.net>
References: <20130908084714.14798.32490.stgit@perseus.fritz.box>
	 <20130908084722.14798.24320.stgit@perseus.fritz.box>
	 <20130908073320.6c15d449@tlielax.poochiereds.net>
	 <1378711080.3212.2.camel@perseus.fritz.box>
	 <20130909064531.07b8a9de@corrin.poochiereds.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-09 at 06:45 -0400, Jeff Layton wrote:
> On Mon, 09 Sep 2013 15:18:00 +0800
> Ian Kent <raven@themaw.net> wrote:
> 
> > On Sun, 2013-09-08 at 07:33 -0400, Jeff Layton wrote:
> > > On Sun, 08 Sep 2013 16:47:23 +0800
> > > Ian Kent <raven@themaw.net> wrote:
> > > 
> > > > When reconnecting to automounts at startup an autofs ioctl is used
> > > > to find the device and inode of existing mounts so they can be used
> > > > to open a file descriptor of possibly covered mounts.
> > > > 
> > > > At this time the the caller might not yet "own" the mount so it can
> > > > trigger calling ->d_automount(). This causes automount to hang when
> > > > trying to reconnect to direct or offset mount types.
> > > > 
> > > > Consequently kern_path() can't be used but path_mntpointat() can be.
> > > > 
> > > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > > Cc: Jeff Layton <jlayton@redhat.com>
> > > > Cc: Al Viro <viro@ZenIV.linux.org.uk>
> > > > ---
> > > >  fs/autofs4/dev-ioctl.c |   23 ++++++++++++-----------
> > > >  1 file changed, 12 insertions(+), 11 deletions(-)
> > > > 
> > > > diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
> > > > index 9183821..228866f 100644
> > > > --- a/fs/autofs4/dev-ioctl.c
> > > > +++ b/fs/autofs4/dev-ioctl.c
> > > > @@ -183,13 +183,14 @@ static int autofs_dev_ioctl_protosubver(struct file *fp,
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +/* Find the topmost mount satisfying test() */
> > > >  static int find_autofs_mount(const char *pathname,
> > > >  			     struct path *res,
> > > >  			     int test(struct path *path, void *data),
> > > >  			     void *data)
> > > >  {
> > > >  	struct path path;
> > > > -	int err = kern_path(pathname, 0, &path);
> > > > +	int err = user_path_mntpointat(AT_FDCWD, pathname, 0, &path);
> > > 
> > > This looks wrong. "pathname" is a kernel string, not a __user one. I
> > > think what you need to do here is to turn user_path_mntpointat into a
> > > wrapper around a kern_path_mntpointat equivalent and then call that
> > > here.
> > 
> > In both cases the path comes from a structure passed from user space.
> > So I started thinking it wasn't correct previously.
> > 
> 
> AFAICT, this is a kernel string by the time it gets here.
> 
> _autofs_dev_ioctl calls copy_dev_ioctl, which copies that struct from
> userland to a kernel buffer.

Yeah, right you are, doesn't matter now anyway.
I expect we'll go with what Al has in his for-next branch.

> 
> > > 
> > > >  	if (err)
> > > >  		return err;
> > > >  	err = -ENOENT;
> > > > @@ -197,10 +198,9 @@ static int find_autofs_mount(const char *pathname,
> > > >  		if (path.dentry->d_sb->s_magic == AUTOFS_SUPER_MAGIC) {
> > > >  			if (test(&path, data)) {
> > > >  				path_get(&path);
> > > > -				if (!err) /* already found some */
> > > > -					path_put(res);
> > > >  				*res = path;
> > > >  				err = 0;
> > > > +				break;
> > > >  			}
> > > >  		}
> > > >  		if (!follow_up(&path))
> > > > @@ -498,12 +498,11 @@ static int autofs_dev_ioctl_askumount(struct file *fp,
> > > >   * mount if there is one or 0 if it isn't a mountpoint.
> > > >   *
> > > >   * If we aren't supplied with a file descriptor then we
> > > > - * lookup the nameidata of the path and check if it is the
> > > > - * root of a mount. If a type is given we are looking for
> > > > - * a particular autofs mount and if we don't find a match
> > > > - * we return fail. If the located nameidata path is the
> > > > - * root of a mount we return 1 along with the super magic
> > > > - * of the mount or 0 otherwise.
> > > > + * lookup the path and check if it is the root of a mount.
> > > > + * If a type is given we are looking for a particular autofs
> > > > + * mount and if we don't find a match we return fail. If the
> > > > + * located path is the root of a mount we return 1 along with
> > > > + * the super magic of the mount or 0 otherwise.
> > > >   *
> > > >   * In both cases the the device number (as returned by
> > > >   * new_encode_dev()) is also returned.
> > > > @@ -531,9 +530,11 @@ static int autofs_dev_ioctl_ismountpoint(struct file *fp,
> > > >  
> > > >  	if (!fp || param->ioctlfd == -1) {
> > > >  		if (autofs_type_any(type))
> > > > -			err = kern_path(name, LOOKUP_FOLLOW, &path);
> > > > +			err = user_path_mntpointat(AT_FDCWD,
> > > > +						   name, LOOKUP_FOLLOW, &path);
> > > >  		else
> > > > -			err = find_autofs_mount(name, &path, test_by_type, &type);
> > > > +			err = find_autofs_mount(name, &path,
> > > > +						test_by_type, &type);
> > > 
> > > 
> > > ...ditto in these spots of course...
> > > 
> > > >  		if (err)
> > > >  			goto out;
> > > >  		devid = new_encode_dev(path.dentry->d_sb->s_dev);
> > > > 
> > > 
> > > 
> > 
> > 
> 
> 


