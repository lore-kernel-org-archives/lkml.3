Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbaBLShl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:37:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaBLShk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:37:40 -0500
Date: Wed, 12 Feb 2014 10:38:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/13] drm: provide device-refcount
Message-ID: <20140212183856.GB27840@kroah.com>
References: <1391004120-687-1-git-send-email-dh.herrmann@gmail.com>
 <1391004120-687-6-git-send-email-dh.herrmann@gmail.com>
 <20140212132541.GU17001@phenom.ffwll.local>
 <CANq1E4RACz+bZmBGFtVGNKZhcJtC6iQtCpsCTTjEXrGUDP6C+A@mail.gmail.com>
 <CAKMK7uEbHUL5=CiRqcCh7nBRAirOB4tdSwiz6YPHNiThVujA8A@mail.gmail.com>
 <20140212164055.GB22377@kroah.com>
 <CANq1E4TJbZv1e=OSshR740k3UkwdRwWo+zY-hrVKuUh31SqKrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4TJbZv1e=OSshR740k3UkwdRwWo+zY-hrVKuUh31SqKrg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 06:48:50PM +0100, David Herrmann wrote:
> Hi
> 
> On Wed, Feb 12, 2014 at 5:40 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Feb 12, 2014 at 05:26:57PM +0100, Daniel Vetter wrote:
> >> On Wed, Feb 12, 2014 at 3:44 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> >> >>> +/**
> >> >>> + * drm_dev_ref - Take reference of a DRM device
> >> >>> + * @dev: device to take reference of or NULL
> >> >>> + *
> >> >>> + * This increases the ref-count of @dev by one. You *must* already own a
> >> >>> + * reference when calling this. Use drm_dev_unref() to drop this reference
> >> >>> + * again.
> >> >>> + *
> >> >>> + * This function never fails. However, this function does not provide *any*
> >> >>> + * guarantee whether the device is alive or running. It only provides a
> >> >>> + * reference to the object and the memory associated with it.
> >> >>> + */
> >> >>> +void drm_dev_ref(struct drm_device *dev)
> >> >>> +{
> >> >>> +     if (dev)
> >> >>
> >> >> This check here (and below in the unref code) look funny. What's the
> >> >> reason for it? Trying to grab/drop a ref on a NULL pointer sounds like a
> >> >> pretty serious bug to me. This is in contrast to kfree(NULL) which imo
> >> >> makes sense - freeing nothing is a legitimate operation imo.
> >> >
> >> > I added it mainly to simplify cleanup-code paths. You can then just
> >> > call unref() and set it to NULL regardless whether you actually hold a
> >> > reference or not. For ref() I don't really care but I think the
> >> > NULL-test doesn't hurt either.
> >> >
> >> > I copied this behavior from get_device() and put_device(), btw.
> >> > Similar to these functions, I think a lot more will go wrong if the
> >> > NULL pointer is not intentional. Imo, ref-counting on a NULL object
> >> > just means "no object", so it shouldn't do anything.
> >>
> >> My fear with this kind of magic is that someone accidentally exchanges
> >> the pointer clearing to NULL (or assignement when grabbing a ref) with
> >> the unref/ref call and then we have a very subtle bug at hand. If we
> >> don't accept NULL objects the failure will be much more obvious.
> >>
> >> The entire kernel kobject stuff is very consistent about this, but I
> >> couldn't find a reason for it - all the NULL checks predate git
> >> history. Greg can you please shed some lights on best practice here
> >> and whether my fears are justified given your experience with shoddy
> >> drivers in general?
> >
> > Yes, the driver core does test for NULL here, as sometimes you are
> > passing in a "parent" pointer, and don't really care if it is NULL or
> > not, so just treating it as if you really do have a reference is usually
> > fine.
> >
> > But, for a subsystem where you "know" you will not be doing anything as
> > foolish as that, I'd not allow that :)
> >
> > So I'd recommend taking those checks out of the drm code.
> 
> Ok, for _ref() I'm fine dropping it, but for _unref() I really don't
> understand the concerns. I like to follow the principle of making
> teardown-functions work with partially initialized objects. A caller
> shouldn't be required to reverse all it's setup functions if one last
> step of object-initialization fails. It's much easier if they can just
> call the destructor which figures itself out which parts are
> initialized. Obviously, this isn't always possible, but checking for
> NULL in _unref() or _put() paths simplifies this a lot and avoids
> non-sense if(obj) unref(obj);
> 
> For instance for drm_minor objects we only initialize the minors that
> are enabled by the specific driver. However, it's enough to test for
> the flags during device-initialization. device-registration,
> -deregistration and -teardown just call _free/unref on all possible
> minors. Allowing NULL avoids testing for these flags in every path but
> the initialization.

I have no objection to that justification for it.

greg k-h
