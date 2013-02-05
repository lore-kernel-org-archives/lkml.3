Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3BEUxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:53:09 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:64866 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab3BEUxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:53:05 -0500
Date: Wed, 6 Feb 2013 06:52:55 +1000
From: Ben Skeggs <skeggsb@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>, nouveau@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Daniel J Blueman <daniel@quora.org>,
        Ben Skeggs <bskeggs@redhat.com>, Arend van Spriel <arend@broadcom.com>
Subject: Re: [PATCH] drm/nouveau: add lockdep annotations
Message-ID: <20130205205255.GA10051@localhost.bne.redhat.com>
References: <CAMVG2svkJruzveuozb8RFK_j1BxqDOwBco=Aida9S680_toNiQ@mail.gmail.com>
 <20130204213041.GA3433@joi.lan>
 <51102F40.2090008@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51102F40.2090008@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 10:59:28PM +0100, Maarten Lankhorst wrote:
> Op 04-02-13 22:30, Marcin Slusarz schreef:
> > 1) Lockdep thinks all nouveau subdevs belong to the same class and can be
> > locked in arbitrary order, which is not true (at least in general case).
> > Tell it to distinguish subdevs by (o)class type.
> Apart from this specific case, is there any other reason why we require being able to nest 2 subdev locks?
I think I tend to prefer Marcin's fix for this actually.  The subdev's
are completely separate classes of objects and as interaction between
them increases (PM will be very much like this), we may very well
require holding multiple subdev mutexes at once.

Ben.

> 
> Add a NVOBJ_FLAG_CREATE_EXCLUSIVE flag to nouveau_engctx_create and return -EBUSY if there is any existing object. Problem solved, and lockdep is still generic.
> 
> > 2) DRM client can be locked under user client lock - tell lockdep to put DRM
> > client lock in a separate class.
> Can you copy paste a typical lockdep splat for this? Also this should be a separate patch. :-)
> 
> 
> > Reported-by: Arend van Spriel <arend@broadcom.com>
> > Reported-by: Peter Hurley <peter@hurleysoftware.com>
> > Reported-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> > Reported-by: Daniel J Blueman <daniel@quora.org>
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Cc: stable@vger.kernel.org [3.7, but needs s/const ofuncs/ofuncs/ to build]
> > ---
> > Lightly tested, only on NV4B and NVC1.
> > ---
> >  drivers/gpu/drm/nouveau/core/core/subdev.c         | 2 +-
> >  drivers/gpu/drm/nouveau/core/include/core/object.h | 7 +++++--
> >  drivers/gpu/drm/nouveau/nouveau_drm.c              | 3 +++
> >  3 files changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/nouveau/core/core/subdev.c b/drivers/gpu/drm/nouveau/core/core/subdev.c
> > index f74c30a..48f0637 100644
> > --- a/drivers/gpu/drm/nouveau/core/core/subdev.c
> > +++ b/drivers/gpu/drm/nouveau/core/core/subdev.c
> > @@ -99,7 +99,7 @@ nouveau_subdev_create_(struct nouveau_object *parent,
> >  	if (ret)
> >  		return ret;
> >  
> > -	mutex_init(&subdev->mutex);
> > +	__mutex_init(&subdev->mutex, subname, &oclass->lock_class_key);
> >  	subdev->name = subname;
> >  
> >  	if (parent) {
> > diff --git a/drivers/gpu/drm/nouveau/core/include/core/object.h b/drivers/gpu/drm/nouveau/core/include/core/object.h
> > index 6a90267..62e68ba 100644
> > --- a/drivers/gpu/drm/nouveau/core/include/core/object.h
> > +++ b/drivers/gpu/drm/nouveau/core/include/core/object.h
> > @@ -50,10 +50,13 @@ int  nouveau_object_fini(struct nouveau_object *, bool suspend);
> >  
> >  extern struct nouveau_ofuncs nouveau_object_ofuncs;
> >  
> > +/* Don't allocate dynamically, because lockdep needs lock_class_keys to be in
> > + * ".data". */
> >  struct nouveau_oclass {
> >  	u32 handle;
> > -	struct nouveau_ofuncs *ofuncs;
> > -	struct nouveau_omthds *omthds;
> > +	struct nouveau_ofuncs * const ofuncs;
> > +	struct nouveau_omthds * const omthds;
> > +	struct lock_class_key lock_class_key;
> >  };
> >  
> >  #define nv_oclass(o)    nv_object(o)->oclass
> > diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
> > index ef1ad21..bc00587 100644
> > --- a/drivers/gpu/drm/nouveau/nouveau_drm.c
> > +++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
> > @@ -245,6 +245,8 @@ static int nouveau_drm_probe(struct pci_dev *pdev,
> >  	return 0;
> >  }
> >  
> > +static struct lock_class_key drm_client_lock_class_key;
> > +
> >  static int
> >  nouveau_drm_load(struct drm_device *dev, unsigned long flags)
> >  {
> > @@ -256,6 +258,7 @@ nouveau_drm_load(struct drm_device *dev, unsigned long flags)
> >  	ret = nouveau_cli_create(pdev, "DRM", sizeof(*drm), (void**)&drm);
> >  	if (ret)
> >  		return ret;
> > +	lockdep_set_class(&drm->client.mutex, &drm_client_lock_class_key);
> >  
> >  	dev->dev_private = drm;
> >  	drm->dev = dev;
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
