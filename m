Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbbAQOMi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 09:12:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbbAQOMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 09:12:37 -0500
Date: Sat, 17 Jan 2015 06:12:34 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: Re: [PATCH] sysfs: group: allow is_visible to drop permissions
Message-ID: <20150117141234.GC26191@kroah.com>
References: <20150116222139.GB512@kroah.com>
 <1547866090.421966.1421454145360.JavaMail.root@mail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547866090.421966.1421454145360.JavaMail.root@mail>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 07:22:25PM -0500, Vivien Didelot wrote:
> Hi Greg,
> 
> > On Fri, Jan 16, 2015 at 04:29:10PM -0500, Vivien Didelot wrote:
> > > Using the optional is_visible function, it is actually possible to
> > > either hide an attribute, or add a new permission, but not remove
> > > one.
> > 
> > What code wants to remove attributes?
> 
> Sorry, I meant removing a permission. Actually, drivers hide attributes
> (if a feature isn't supported by a device) by returning 0 in is_visible.
> 
> E.g, if we consider a read-only attribute, a driver can add the write
> permission by returning S_IWUSR, but removing S_IRUGO isn't possible.

Sorry, I meant to say, "what code wants to remove permissions".

> > > This commit uses all the UGO bits returned by is_visible instead of
> > > OR'ing them with the default attribute mode.
> > > 
> > > Concretely, this allows a driver to use macros like DEVICE_ATTR_RW
> > > to
> > > set the attribute show and store functions and remove the S_IWUSR
> > > permission in is_visible if the implementation doesn't provide a
> > > setter.
> > 
> > What bus wants to do this?
> 
> Some high level frameworks such as DSA. My motivation behind this was to
> clarify how modes are set for temperature attributes in DSA. Optional
> functions can be provided by switch drivers to get temperatures or set
> limits. I hope the following patch helps clarifying this point:
> https://gist.github.com/vivien/72734ba0673ad0b79a6b
> 
> (I Cc: Guenter as he is the author of NET_DSA_HWMON, see 51579c3).
> 
> > > Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > > ---
> > >  fs/sysfs/group.c | 12 +++++++-----
> > >  1 file changed, 7 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
> > > index 7d2a860..a8cfe03 100644
> > > --- a/fs/sysfs/group.c
> > > +++ b/fs/sysfs/group.c
> > > @@ -41,7 +41,7 @@ static int create_files(struct kernfs_node
> > > *parent, struct kobject *kobj,
> > >  
> > >  	if (grp->attrs) {
> > >  		for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
> > > -			umode_t mode = 0;
> > > +			umode_t mode = (*attr)->mode;
> > >  
> > >  			/*
> > >  			 * In update mode, we're changing the permissions or
> > > @@ -51,13 +51,15 @@ static int create_files(struct kernfs_node
> > > *parent, struct kobject *kobj,
> > >  			if (update)
> > >  				kernfs_remove_by_name(parent, (*attr)->name);
> > >  			if (grp->is_visible) {
> > > -				mode = grp->is_visible(kobj, *attr, i);
> > > -				if (!mode)
> > > +				umode_t ugo = grp->is_visible(kobj, *attr, i);
> > > +
> > > +				if (!(ugo & S_IRWXUGO))
> > >  					continue;
> > > +
> > > +				mode = (mode & ~S_IRWXUGO) | (ugo & S_IRWXUGO);
> > 
> > Please document what you are doing here in the code, it's not obvious
> > at first glance.

You somehow ignored this comment :(

