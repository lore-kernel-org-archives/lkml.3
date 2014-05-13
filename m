Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaEMR7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:59:52 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:56608 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaEMR7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:59:46 -0400
Date: Tue, 13 May 2014 19:59:41 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] drm: Add device registration documentation
Message-ID: <20140513175941.GT3908@phenom.ffwll.local>
Mail-Followup-To: Thierry Reding <thierry.reding@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
	David Herrmann <dh.herrmann@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
 <1399995050-28435-7-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399995050-28435-7-git-send-email-thierry.reding@gmail.com>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 05:30:49PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Describe how devices are registered using the drm_*_init() functions.
> Adding this to docbook requires a largish set of changes to the comments
> in drm_{pci,usb,platform}.c since they are doxygen-style rather than
> proper kernel-doc and therefore mess with the docbook generation.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  Documentation/DocBook/drm.tmpl |  9 +++++
>  drivers/gpu/drm/drm_pci.c      | 80 ++++++++++++++++++++----------------------
>  drivers/gpu/drm/drm_platform.c | 15 ++++----
>  drivers/gpu/drm/drm_stub.c     | 19 +++++-----
>  drivers/gpu/drm/drm_usb.c      | 20 ++++++++++-
>  5 files changed, 81 insertions(+), 62 deletions(-)
> 
> diff --git a/Documentation/DocBook/drm.tmpl b/Documentation/DocBook/drm.tmpl
> index f4028c3a28a2..f26a8e4fbe47 100644
> --- a/Documentation/DocBook/drm.tmpl
> +++ b/Documentation/DocBook/drm.tmpl
> @@ -282,6 +282,15 @@ char *date;</synopsis>
>        </sect3>
>      </sect2>
>      <sect2>
> +      <title>Device Registration</title>
> +      <para>
> +        A number of functions are provided to help with device registration.
> +        The functions deal with PCI, USB and platform devices, respectively.
> +      </para>
> +!Fdrivers/gpu/drm/drm_pci.c drm_pci_init drm_pci_exit
> +!Fdrivers/gpu/drm/drm_usb.c drm_usb_init drm_usb_exit
> +!Fdrivers/gpu/drm/drm_platform.c drm_platform_init

Generally I prefer to use !E to pull in all exported functions - those are
the ones driver authors care about. And using this has the upside that if
anyone renames them or adds/removes some it will be kept in sync
automatically. Same for the next patch.
-Daniel

> +    <sect2>
>        <title>Driver Load</title>
>        <para>
>          The <methodname>load</methodname> method is the driver and device
> diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
> index d237de36a07a..020cfd934854 100644
> --- a/drivers/gpu/drm/drm_pci.c
> +++ b/drivers/gpu/drm/drm_pci.c
> @@ -1,17 +1,3 @@
> -/* drm_pci.h -- PCI DMA memory management wrappers for DRM -*- linux-c -*- */
> -/**
> - * \file drm_pci.c
> - * \brief Functions and ioctls to manage PCI memory
> - *
> - * \warning These interfaces aren't stable yet.
> - *
> - * \todo Implement the remaining ioctl's for the PCI pools.
> - * \todo The wrappers here are so thin that they would be better off inlined..
> - *
> - * \author José Fonseca <jrfonseca@tungstengraphics.com>
> - * \author Leif Delgass <ldelgass@retinalburn.net>
> - */
> -
>  /*
>   * Copyright 2003 José Fonseca.
>   * Copyright 2003 Leif Delgass.
> @@ -42,12 +28,14 @@
>  #include <linux/export.h>
>  #include <drm/drmP.h>
>  
> -/**********************************************************************/
> -/** \name PCI memory */
> -/*@{*/
> -
>  /**
> - * \brief Allocate a PCI consistent memory block, for DMA.
> + * drm_pci_alloc - Allocate a PCI consistent memory block, for DMA.
> + * @dev: DRM device
> + * @size: size of block to allocate
> + * @align: alignment of block
> + *
> + * Return: A handle to the allocated memory block on success or NULL on
> + * failure.
>   */
>  drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t align)
>  {
> @@ -88,8 +76,8 @@ drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t ali
>  
>  EXPORT_SYMBOL(drm_pci_alloc);
>  
> -/**
> - * \brief Free a PCI consistent memory block without freeing its descriptor.
> +/*
> + * Free a PCI consistent memory block without freeing its descriptor.
>   *
>   * This function is for internal use in the Linux-specific DRM core code.
>   */
> @@ -111,7 +99,9 @@ void __drm_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)
>  }
>  
>  /**
> - * \brief Free a PCI consistent memory block
> + * drm_pci_free - Free a PCI consistent memory block
> + * @dev: DRM device
> + * @dmah: handle to memory block
>   */
>  void drm_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)
>  {
> @@ -226,17 +216,16 @@ static int drm_pci_irq_by_busid(struct drm_device *dev, struct drm_irq_busid *p)
>  }
>  
>  /**
> - * Get interrupt from bus id.
> - *
> - * \param inode device inode.
> - * \param file_priv DRM file private.
> - * \param cmd command.
> - * \param arg user argument, pointing to a drm_irq_busid structure.
> - * \return zero on success or a negative number on failure.
> + * drm_irq_by_busid - Get interrupt from bus ID
> + * @dev: DRM device
> + * @data: IOCTL parameter pointing to a drm_irq_busid structure
> + * @file_priv: DRM file private.
>   *
>   * Finds the PCI device with the specified bus id and gets its IRQ number.
>   * This IOCTL is deprecated, and will now return EINVAL for any busid not equal
>   * to that of the device that this DRM instance attached to.
> + *
> + * Return: 0 on success or a negative error code on failure.
>   */
>  int drm_irq_by_busid(struct drm_device *dev, void *data,
>  		     struct drm_file *file_priv)
> @@ -285,15 +274,16 @@ static struct drm_bus drm_pci_bus = {
>  };
>  
>  /**
> - * Register.
> - *
> - * \param pdev - PCI device structure
> - * \param ent entry from the PCI ID table with device type flags
> - * \return zero on success or a negative number on failure.
> + * drm_get_pci_dev - Register a PCI device with the DRM subsystem
> + * @pdev: PCI device
> + * @ent: entry from the PCI ID table that matches @pdev
> + * @driver: DRM device driver
>   *
>   * Attempt to gets inter module "drm" information. If we are first
>   * then register the character device and inter module information.
>   * Try and register, if we fail to register, backout previous work.
> + *
> + * Return: 0 on success or a negative error code on failure.
>   */
>  int drm_get_pci_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
>  		    struct drm_driver *driver)
> @@ -346,15 +336,14 @@ err_free:
>  EXPORT_SYMBOL(drm_get_pci_dev);
>  
>  /**
> - * PCI device initialization. Called direct from modules at load time.
> + * drm_pci_init - Register matching PCI devices with the DRM subsystem
> + * @driver: DRM device driver
> + * @pdriver: PCI device driver
>   *
> - * \return zero on success or a negative number on failure.
> + * Initializes a drm_device structures, registering the stubs and initializing
> + * the AGP device.
>   *
> - * Initializes a drm_device structures,registering the
> - * stubs and initializing the AGP device.
> - *
> - * Expands the \c DRIVER_PREINIT and \c DRIVER_POST_INIT macros before and
> - * after the initialization for driver customization.
> + * Return: 0 on success or a negative error code on failure.
>   */
>  int drm_pci_init(struct drm_driver *driver, struct pci_driver *pdriver)
>  {
> @@ -458,7 +447,14 @@ int drm_pci_set_unique(struct drm_device *dev,
>  
>  EXPORT_SYMBOL(drm_pci_init);
>  
> -/*@}*/
> +/**
> + * drm_pci_exit - Unregister matching PCI devices from the DRM subsystem
> + * @driver: DRM device driver
> + * @pdriver: PCI device driver
> + *
> + * Unregisters one or more devices matched by a PCI driver from the DRM
> + * subsystem.
> + */
>  void drm_pci_exit(struct drm_driver *driver, struct pci_driver *pdriver)
>  {
>  	struct drm_device *dev, *tmp;
> diff --git a/drivers/gpu/drm/drm_platform.c b/drivers/gpu/drm/drm_platform.c
> index 234e0bc1ae51..d5b76f148c12 100644
> --- a/drivers/gpu/drm/drm_platform.c
> +++ b/drivers/gpu/drm/drm_platform.c
> @@ -106,17 +106,16 @@ static struct drm_bus drm_platform_bus = {
>  };
>  
>  /**
> - * Platform device initialization. Called direct from modules.
> + * drm_platform_init - Register a platform device with the DRM subsystem
> + * @driver: DRM device driver
> + * @platform_device: platform device to register
>   *
> - * \return zero on success or a negative number on failure.
> - *
> - * Initializes a drm_device structures,registering the
> - * stubs
> + * Registers the specified DRM device driver and platform device with the DRM
> + * subsystem, initializing a drm_device structure and calling the driver's
> + * .load() function.
>   *
> - * Expands the \c DRIVER_PREINIT and \c DRIVER_POST_INIT macros before and
> - * after the initialization for driver customization.
> + * Return: 0 on success or a negative error code on failure.
>   */
> -
>  int drm_platform_init(struct drm_driver *driver, struct platform_device *platform_device)
>  {
>  	DRM_DEBUG("\n");
> diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
> index 64cf97dc4ce4..88bada850b71 100644
> --- a/drivers/gpu/drm/drm_stub.c
> +++ b/drivers/gpu/drm/drm_stub.c
> @@ -1,16 +1,11 @@
> -/**
> - * \file drm_stub.h
> - * Stub support
> - *
> - * \author Rickard E. (Rik) Faith <faith@valinux.com>
> - */
> -
>  /*
>   * Created: Fri Jan 19 10:48:35 2001 by faith@acm.org
>   *
>   * Copyright 2001 VA Linux Systems, Inc., Sunnyvale, California.
>   * All Rights Reserved.
>   *
> + * Author Rickard E. (Rik) Faith <faith@valinux.com>
> + *
>   * Permission is hereby granted, free of charge, to any person obtaining a
>   * copy of this software and associated documentation files (the "Software"),
>   * to deal in the Software without restriction, including without limitation
> @@ -424,11 +419,12 @@ void drm_minor_release(struct drm_minor *minor)
>  }
>  
>  /**
> - * Called via drm_exit() at module unload time or when pci device is
> - * unplugged.
> + * drm_put_dev - Unregister and release a DRM device
> + * @dev: DRM device
>   *
> - * Cleans up all DRM device, calling drm_lastclose().
> + * Called at module unload time or when a PCI device is unplugged.
>   *
> + * Cleans up all DRM device, calling drm_lastclose().
>   */
>  void drm_put_dev(struct drm_device *dev)
>  {
> @@ -558,7 +554,7 @@ int drm_set_unique(struct drm_device *dev, const char *fmt, ...)
>  EXPORT_SYMBOL(drm_set_unique);
>  
>  /**
> - * drm_dev_alloc - Allocate new drm device
> + * drm_dev_alloc - Allocate new DRM device
>   * @driver: DRM driver to allocate device for
>   * @parent: Parent device object
>   *
> @@ -712,6 +708,7 @@ EXPORT_SYMBOL(drm_dev_unref);
>  /**
>   * drm_dev_register - Register DRM device
>   * @dev: Device to register
> + * @flags: Flags passed to the driver's .load() function
>   *
>   * Register the DRM device @dev with the system, advertise device to user-space
>   * and start normal device operation. @dev must be allocated via drm_dev_alloc()
> diff --git a/drivers/gpu/drm/drm_usb.c b/drivers/gpu/drm/drm_usb.c
> index c6c7c29ad46f..f2fe94aab901 100644
> --- a/drivers/gpu/drm/drm_usb.c
> +++ b/drivers/gpu/drm/drm_usb.c
> @@ -45,7 +45,17 @@ static int drm_usb_set_busid(struct drm_device *dev,
>  static struct drm_bus drm_usb_bus = {
>  	.set_busid = drm_usb_set_busid,
>  };
> -    
> +
> +/**
> + * drm_usb_init - Register matching USB devices with the DRM subsystem
> + * @driver: DRM device driver
> + * @udriver: USB device driver
> + *
> + * Registers one or more devices matched by a USB driver with the DRM
> + * subsystem.
> + *
> + * Return: 0 on success or a negative error code on failure.
> + */
>  int drm_usb_init(struct drm_driver *driver, struct usb_driver *udriver)
>  {
>  	int res;
> @@ -58,6 +68,14 @@ int drm_usb_init(struct drm_driver *driver, struct usb_driver *udriver)
>  }
>  EXPORT_SYMBOL(drm_usb_init);
>  
> +/**
> + * drm_usb_exit - Unregister matching USB devices from the DRM subsystem
> + * @driver: DRM device driver
> + * @udriver: USB device driver
> + *
> + * Unregisters one or more devices matched by a USB driver from the DRM
> + * subsystem.
> + */
>  void drm_usb_exit(struct drm_driver *driver,
>  		  struct usb_driver *udriver)
>  {
> -- 
> 1.9.2
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
