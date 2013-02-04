Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3BDV7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:59:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41800 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab3BDV7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:59:34 -0500
Message-ID: <51102F40.2090008@canonical.com>
Date: Mon, 04 Feb 2013 22:59:28 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, Daniel J Blueman <daniel@quora.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Arend van Spriel <arend@broadcom.com>
Subject: Re: [PATCH] drm/nouveau: add lockdep annotations
References: <CAMVG2svkJruzveuozb8RFK_j1BxqDOwBco=Aida9S680_toNiQ@mail.gmail.com> <20130204213041.GA3433@joi.lan>
In-Reply-To: <20130204213041.GA3433@joi.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 04-02-13 22:30, Marcin Slusarz schreef:
> 1) Lockdep thinks all nouveau subdevs belong to the same class and can be
> locked in arbitrary order, which is not true (at least in general case).
> Tell it to distinguish subdevs by (o)class type.
Apart from this specific case, is there any other reason why we require being able to nest 2 subdev locks?

Add a NVOBJ_FLAG_CREATE_EXCLUSIVE flag to nouveau_engctx_create and return -EBUSY if there is any existing object. Problem solved, and lockdep is still generic.

> 2) DRM client can be locked under user client lock - tell lockdep to put DRM
> client lock in a separate class.
Can you copy paste a typical lockdep splat for this? Also this should be a separate patch. :-)


> Reported-by: Arend van Spriel <arend@broadcom.com>
> Reported-by: Peter Hurley <peter@hurleysoftware.com>
> Reported-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Reported-by: Daniel J Blueman <daniel@quora.org>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: stable@vger.kernel.org [3.7, but needs s/const ofuncs/ofuncs/ to build]
> ---
> Lightly tested, only on NV4B and NVC1.
> ---
>  drivers/gpu/drm/nouveau/core/core/subdev.c         | 2 +-
>  drivers/gpu/drm/nouveau/core/include/core/object.h | 7 +++++--
>  drivers/gpu/drm/nouveau/nouveau_drm.c              | 3 +++
>  3 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/nouveau/core/core/subdev.c b/drivers/gpu/drm/nouveau/core/core/subdev.c
> index f74c30a..48f0637 100644
> --- a/drivers/gpu/drm/nouveau/core/core/subdev.c
> +++ b/drivers/gpu/drm/nouveau/core/core/subdev.c
> @@ -99,7 +99,7 @@ nouveau_subdev_create_(struct nouveau_object *parent,
>  	if (ret)
>  		return ret;
>  
> -	mutex_init(&subdev->mutex);
> +	__mutex_init(&subdev->mutex, subname, &oclass->lock_class_key);
>  	subdev->name = subname;
>  
>  	if (parent) {
> diff --git a/drivers/gpu/drm/nouveau/core/include/core/object.h b/drivers/gpu/drm/nouveau/core/include/core/object.h
> index 6a90267..62e68ba 100644
> --- a/drivers/gpu/drm/nouveau/core/include/core/object.h
> +++ b/drivers/gpu/drm/nouveau/core/include/core/object.h
> @@ -50,10 +50,13 @@ int  nouveau_object_fini(struct nouveau_object *, bool suspend);
>  
>  extern struct nouveau_ofuncs nouveau_object_ofuncs;
>  
> +/* Don't allocate dynamically, because lockdep needs lock_class_keys to be in
> + * ".data". */
>  struct nouveau_oclass {
>  	u32 handle;
> -	struct nouveau_ofuncs *ofuncs;
> -	struct nouveau_omthds *omthds;
> +	struct nouveau_ofuncs * const ofuncs;
> +	struct nouveau_omthds * const omthds;
> +	struct lock_class_key lock_class_key;
>  };
>  
>  #define nv_oclass(o)    nv_object(o)->oclass
> diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
> index ef1ad21..bc00587 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_drm.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
> @@ -245,6 +245,8 @@ static int nouveau_drm_probe(struct pci_dev *pdev,
>  	return 0;
>  }
>  
> +static struct lock_class_key drm_client_lock_class_key;
> +
>  static int
>  nouveau_drm_load(struct drm_device *dev, unsigned long flags)
>  {
> @@ -256,6 +258,7 @@ nouveau_drm_load(struct drm_device *dev, unsigned long flags)
>  	ret = nouveau_cli_create(pdev, "DRM", sizeof(*drm), (void**)&drm);
>  	if (ret)
>  		return ret;
> +	lockdep_set_class(&drm->client.mutex, &drm_client_lock_class_key);
>  
>  	dev->dev_private = drm;
>  	drm->dev = dev;

