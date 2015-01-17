Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbbAQAW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 19:22:27 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:62752 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbAQAW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 19:22:26 -0500
Date: Fri, 16 Jan 2015 19:22:25 -0500 (EST)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Message-ID: <1547866090.421966.1421454145360.JavaMail.root@mail>
In-Reply-To: <20150116222139.GB512@kroah.com>
Subject: Re: [PATCH] sysfs: group: allow is_visible to drop permissions
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> On Fri, Jan 16, 2015 at 04:29:10PM -0500, Vivien Didelot wrote:
> > Using the optional is_visible function, it is actually possible to
> > either hide an attribute, or add a new permission, but not remove
> > one.
> 
> What code wants to remove attributes?

Sorry, I meant removing a permission. Actually, drivers hide attributes
(if a feature isn't supported by a device) by returning 0 in is_visible.

E.g, if we consider a read-only attribute, a driver can add the write
permission by returning S_IWUSR, but removing S_IRUGO isn't possible.

> > This commit uses all the UGO bits returned by is_visible instead of
> > OR'ing them with the default attribute mode.
> > 
> > Concretely, this allows a driver to use macros like DEVICE_ATTR_RW
> > to
> > set the attribute show and store functions and remove the S_IWUSR
> > permission in is_visible if the implementation doesn't provide a
> > setter.
> 
> What bus wants to do this?

Some high level frameworks such as DSA. My motivation behind this was to
clarify how modes are set for temperature attributes in DSA. Optional
functions can be provided by switch drivers to get temperatures or set
limits. I hope the following patch helps clarifying this point:
https://gist.github.com/vivien/72734ba0673ad0b79a6b

(I Cc: Guenter as he is the author of NET_DSA_HWMON, see 51579c3).

> > Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > ---
> >  fs/sysfs/group.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
> > index 7d2a860..a8cfe03 100644
> > --- a/fs/sysfs/group.c
> > +++ b/fs/sysfs/group.c
> > @@ -41,7 +41,7 @@ static int create_files(struct kernfs_node
> > *parent, struct kobject *kobj,
> >  
> >  	if (grp->attrs) {
> >  		for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
> > -			umode_t mode = 0;
> > +			umode_t mode = (*attr)->mode;
> >  
> >  			/*
> >  			 * In update mode, we're changing the permissions or
> > @@ -51,13 +51,15 @@ static int create_files(struct kernfs_node
> > *parent, struct kobject *kobj,
> >  			if (update)
> >  				kernfs_remove_by_name(parent, (*attr)->name);
> >  			if (grp->is_visible) {
> > -				mode = grp->is_visible(kobj, *attr, i);
> > -				if (!mode)
> > +				umode_t ugo = grp->is_visible(kobj, *attr, i);
> > +
> > +				if (!(ugo & S_IRWXUGO))
> >  					continue;
> > +
> > +				mode = (mode & ~S_IRWXUGO) | (ugo & S_IRWXUGO);
> 
> Please document what you are doing here in the code, it's not obvious
> at first glance.
> 
> >  			}
> >  			error = sysfs_add_file_mode_ns(parent, *attr, false,
> > -						       (*attr)->mode | mode,
> > -						       NULL);
> > +						       mode, NULL);
> 
> Any chance this is going to break existing code that isn't expecting
> this type of change in functionality?

Usually, drivers return 0 to hide the attribute, or the attr->mode to
show it. This change should not break this expectation.

In the meantime, as the returned value is OR'ed with the actual mode,
I'm wondering if a driver can break anything by returning, let's say ~0?

That's why I kept the eventual extra bits from the attribute mode and OR
them with only the UGO bits from the return of is_visible, similar to
what sysfs_chmod_file() does.

thanks,

-v
