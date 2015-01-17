Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbbAQWJQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 17:09:16 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:65331 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbAQWJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 17:09:14 -0500
Date: Sat, 17 Jan 2015 17:09:11 -0500 (EST)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Message-ID: <526250410.74266.1421532551922.JavaMail.root@mail>
In-Reply-To: <20150117141234.GC26191@kroah.com>
Subject: Re: [PATCH] sysfs: group: allow is_visible to drop permissions
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter, Greg,

> >>> This commit uses all the UGO bits returned by is_visible instead
> >>> of OR'ing them with the default attribute mode.
> >>>
> >>> Concretely, this allows a driver to use macros like DEVICE_ATTR_RW
> >>> to set the attribute show and store functions and remove the
> >>> S_IWUSR permission in is_visible if the implementation doesn't
> >>> provide a setter.
> >>
> >> What bus wants to do this?
>
> Every driver which has an attribute which is not always writable.  The
> scsi code fragment I copied below would be another example.
>
> > Some high level frameworks such as DSA. My motivation behind this
> > was to clarify how modes are set for temperature attributes in DSA.
> > Optional functions can be provided by switch drivers to get
> > temperatures or set limits. I hope the following patch helps
> > clarifying this point:
> > https://gist.github.com/vivien/72734ba0673ad0b79a6b
> >
> > (I Cc: Guenter as he is the author of NET_DSA_HWMON, see 51579c3).

BTW Guenter, does this patch make sense to you?

> >>>   			if (grp->is_visible) {
> >>> -				mode = grp->is_visible(kobj, *attr, i);
> >>> -				if (!mode)
> >>> +				umode_t ugo = grp->is_visible(kobj, *attr, i);
> >>> +
> >>> +				if (!(ugo & S_IRWXUGO))
> >>>   					continue;
> >>> +
> >>> +				mode = (mode & ~S_IRWXUGO) | (ugo & S_IRWXUGO);
> >>
> >> Please document what you are doing here in the code, it's not
> >> obvious at first glance.

Sorry Greg this wasn't clear, I kinda group the reply below. Here it is:

"I kept the eventual extra bits from the attribute mode and OR them with
only the UGO bits from the return of is_visible, similar to what
sysfs_chmod_file() does."

> >> Any chance this is going to break existing code that isn't
> >> expecting this type of change in functionality?
> >
> > Usually, drivers return 0 to hide the attribute, or the attr->mode
> > to show it. This change should not break this expectation.
> >
> 
> I am a bit concerned with 'Usually' and 'should not'. While you are
> correct, the only way to know for sure would be to go through all
> is_visible functions and make sure. And we don't really know why the
> original commit (0f4238958d) chose to use "(*attr)->mode | mode"
> instead of just mode.

I said "usually" because I gave a look at some is_visible functions in
drivers/ (but not all) and noted this usage. And "should not" because
I'm not 100% sure since I didn't go through all is_visible functions as
you said.

> In this context, it is interesting that the scsi code, for which
> is_visible was changed to return umode_t, appears to use it in a way
> that doesn't work.  The following code fragment is from
> drivers/scsi/scsi_sysfs.c.
> 
> static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR,
> sdev_show_queue_depth,
>                     sdev_store_queue_depth);
> ...
>          if (attr == &dev_attr_queue_depth.attr &&
>              !sdev->host->hostt->change_queue_depth)
>                  return S_IRUGO;
> 
> Oops ...
> 
> Given that, one could argue that the change to just use the return
> value of is_visible may cause some trouble with lost permissions here
> or there, but that it is already used in a wrong way and therefore
> _should_ be changed.

This is exactly my point. this code expects to remove the write
permission since change_queue_depth is not provided, but this will never
happen.

> > In the meantime, as the returned value is OR'ed with the actual
> > mode, I'm wondering if a driver can break anything by returning,
> > let's say ~0?
> >
> > That's why I kept the eventual extra bits from the attribute mode
> > and OR them with only the UGO bits from the return of is_visible,
> > similar to what sysfs_chmod_file() does.
> >
> Are there mode flags which have bits other than S_IRWXUGO set, or is
> that another assumption ? If there are, why would or should is_visible
> be limited to the S_IRWXUGO bits ?

Yes, there are other bits like S_ISUID, S_ISGID, S_ISVTX (see
include/linux/stat.h) and some internal usage bits like SYSFS_PREALLOC
(see include/linux/sysfs.h).

My assumption here was that the attribute group is_visible function
should just be able to adjust the UGO bits. Am I correct?

I'm not even sure about the execute permission though. Only one driver
uses it for an attribute and it seems wrong, in drivers/hid/hid-lg4ff.c:

static DEVICE_ATTR(range, S_IRWXU | S_IRWXG | S_IROTH, lg4ff_range_show, lg4ff_range_store);

> So ultimately you have two semantic changes: One to limit the scope of
> is_valid to S_IRWXUGO, and one to only use the bits from is_visible
> within that scope, but keep using the other bits from the original
> mode.

Indeed, this can be 2 patches here.

> Plus, returning ~S_IRWXUGO from asn in_visible function now results in
> the file not being visible at all. Wonder if that should be more than
> one patch, and if the changes should be discussed separately.

If you return ~S_IRWXUGO now, the file is visible, with the default
attribute mode. If you return ~S_IRWXUGO with this patch, the file is
not visible.

The actual behavior seems wrong to me. Again, what happens is you return
SYSFS_PREALLOC, that the underlying sysfs_add_file_mode_ns() function is
actually checking?

IMHO, if we want an attribute group to only be able to "hide or show" an
attribute, then is_visible (as the name suggests) should return a
boolean. If we want it be able to adjust permissions (as it seems
correct, given the examples), we should identify which permissions are
OK to change, deprecate is_visible function (to avoid code break) in
favor of a new one which limits the bits to that scope.

Thanks,
-v
