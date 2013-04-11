Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab3DKP4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:56:12 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:64666 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3DKP4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:56:09 -0400
Date: Thu, 11 Apr 2013 08:56:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
Message-ID: <20130411155606.GA14042@kroah.com>
References: <20130406165600.GA29660@kroah.com>
 <87y5cpvhaz.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5cpvhaz.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 09:10:12PM -0700, Eric W. Biederman wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
> 
> > From: Kay Sievers <kay@vrfy.org>
> >
> > Some drivers want to tell userspace what uid and gid should be used for
> > their device nodes, so allow that information to percolate through the
> > driver core to userspace in order to make this happen.  This means that
> > some systems (i.e.  Android and friends) will not need to even run a
> > udev-like daemon for their device node manager and can just rely in
> > devtmpfs fully, reducing their footprint even more.
> 
> This patch is really badly broken in it's uid and gid handling.
> Nearly every line of this patch is wrong.
> 
> uids and gids in the kernel need to be stored in kuid_t's and kgid_t's.

Stored, yes, but defined that way as well?

> > -static char *block_devnode(struct device *dev, umode_t *mode)
> > +static char *block_devnode(struct device *dev, umode_t *mode,
> > +			   uid_t *uid, gid_t *gid)
> This needs be kuid_t and kgid_t.
> 
> >  {
> >  	struct gendisk *disk = dev_to_disk(dev);
> >  
> > --- a/drivers/base/core.c
> > +++ b/drivers/base/core.c
> > @@ -283,15 +283,21 @@ static int dev_uevent(struct kset *kset,
> >  		const char *tmp;
> >  		const char *name;
> >  		umode_t mode = 0;
> > +		uid_t uid = 0;
> > +		gid_t gid = 0;
> This needs to be:
> 		kuid_t uid = GLOBAL_ROOT_UID;
> 		kgid_t gid = GLOBAL_ROOT_GID;

Ok, I'll fix this up and send a follow-on patch, thanks for the review.

> 
> >  		add_uevent_var(env, "MAJOR=%u", MAJOR(dev->devt));
> >  		add_uevent_var(env, "MINOR=%u", MINOR(dev->devt));
> > -		name = device_get_devnode(dev, &mode, &tmp);
> > +		name = device_get_devnode(dev, &mode, &uid, &gid, &tmp);
> >  		if (name) {
> >  			add_uevent_var(env, "DEVNAME=%s", name);
> > -			kfree(tmp);
> >  			if (mode)
> >  				add_uevent_var(env, "DEVMODE=%#o", mode & 0777);
> > +			if (uid)
> > +				add_uevent_var(env, "DEVUID=%u", uid);
> > +			if (gid)
> > +				add_uevent_var(env, "DEVGID=%u", gid);
> 
> Which user namespace are your users in?
> At the very least this should be:
> +			if (!uid_eq(uid, GLOBAL_ROOT_UID)
> +				add_uevent_var(env, "DEVUID=%u", from_kuid(&init_user_ns, uid));
> +			if (!gid_eq(gid, GLOBAL_ROOT_GID))
> +				add_uevent_var(env, "DEVGID=%u", from_kgid(&init_user_ns, gid));
> 
> I suppose you can assume your users are in the initial user namespace,
> as mknod won't work in any other user namespace.

Yes.

> Still it approaches being twisted to have files like
> /sys/class/net/eth0/uevent that anyone can read that will only return
> values in the initial user namespace.

As the nodes are only valid in the initial namespace, why would this
matter?

> > +		newattrs.ia_uid = uid;
> > +		newattrs.ia_gid = gid;
> This doesn't even compile because the types are wrong.

Yes, this has been fixed.  But note, it only fails the build if
namespaces are enabled, and given that no one seems to have reported
this build error in either the 0-day tester, or linux-next, or the
distro developers that tested this patch on their systems, it seems that
no one enables namespaces on their systems :(

Again, thanks for the review, I'll go enable namespaces in my test
kernel and fix up the fallout.

greg k-h
