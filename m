Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbaIKMqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:46:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:41738 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429AbaIKMqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:46:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384704906"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Daniel Vetter <daniel@ffwll.ch>, David Herrmann <dh.herrmann@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Bryan Wu <cooloney@gmail.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH RFC 4/4] drm: link connectors to backlight devices
In-Reply-To: <20140911064834.GA15520@phenom.ffwll.local>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com> <1410364463-12692-5-git-send-email-dh.herrmann@gmail.com> <20140911064834.GA15520@phenom.ffwll.local>
User-Agent: Notmuch/0.18.1+85~gcca05ac (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 11 Sep 2014 15:46:01 +0300
Message-ID: <878ulql3zq.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Sep 10, 2014 at 05:54:23PM +0200, David Herrmann wrote:
>> Backlight devices have always been managed independently of display
>> controllers. They're often controlled via different hardware interfaces
>> and their relationship to display-controllers varies vastly between
>> different boards. However, display brightness is obviously a property of
>> a display, and thus of a DRM connector. Therefore, it'd be really
>> appreciated if user-space APIs would highlight this relationship.
>> 
>> The main runtime users of backlight interfaces are user-space compositors.
>> But currently they have to jump through hoops to find the correct
>> backlight device for a given connector. Furthermore, they need root
>> privileges to write to sysfs. sysfs has never been designed as run-time
>> non-root API. It does not provide file-contexts, run-time management or
>> any kind of API control. There is no way to control access to sysfs via
>> different links (in that case: mounts). Char-devs provide all this!
>> 
>> So far, backlight APIs have been fairly trivial, so adding char-devs to
>> backlights is rather heavy-weight. Therefore, this patch introduces a new
>> API interface to modify backlight brightness via DRM: A "BRIGHTNESS"
>> property on DRM connectors.
>> 
>> Instead of adding backlight hardware support to DRM, we rely on the
>> backlight-class and simply add a new API. Each DRM Connector can
>> optionally be linked to a backlight class device. Modifying the connector
>> property will have the same effect as writing into the "brightness" sysfs
>> file of the linked backlight class device. However, we now can manage
>> access to backlight devices via the same interface as access to
>> mode-setting on the underlying display. Furthermore, the connection
>> between displays and their backlight devices are visible in user-space.
>> 
>> Obviously, matching backlights to displays cannot be solved magically
>> with this link. Therefore, we also add a user-space attribute to DRM
>> connectors called 'backlight'. If a DRM driver is incapable of matching
>> existing backlights to a connector, or if a given board has just crappy
>> backlight drivers, udev can write the name of a backlight-device into this
>> attribute and the connector-property will be re-linked to this backlight
>> device. The udev hwdb can be easily employed to track such quirks and
>> fixups for different board+GPU combinations.
>> Note that the name written into the 'backlight' attribute is saved on the
>> connector, so in case the real backlight device is probed after the DRM
>> card, the backlight will still get properly attached once probed.
>> 
>> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>
> Nice you skid around all the pitfalls and trapdoors, I guess we've all
> been rather blind ;-)
>
> Two high-level comments:
> - We also want to forward "bl_power". cros was totally not happy when we
>   stopped treating brightness == 0 as completely off (it upsets some
>   panels terminally, so there's a vbt lower limit). Instead we expose this
>   now through the bl_power knob.

Part of the reason was that their backlight handling userspace only uses
the sysfs interface, not drm, and thus doing dpms to switch the display
off would be more work. (And slow, but that's another matter.) OTOH if
you are already frobbing the connector, it's easy to do dpms, right?

(Side note, another issue with using brightness == 0 for a kind of easy
dpms is that, at least in theory, there are displays that work with
ambient light when the backlight is off. So it doesn't really switch the
display off anyway. Don't know if such displays are common though.)

>   While at it I think we should expose all the other backlight properties
>   too (read-only ofc for actual/max_brightness).

The trouble here, and I think also the reason David chose to use range
0..U16_MAX for the backlight property, is the change that occurs when
the connector-backlight link gets changed. If we expose max, and deal
with the problems, then that doesn't need to be a separate property,
just the max value for the brightness property.

> - How does udev match on the drm connector name? They are not terribly
>   stable atm, and if you reload your drm driver, or much more likely, have
>   two gpus with two drm drivers they change. We probably should change the
>   name allocation scheme to be per device instance instead of global
>   first. Within a driver probe order is hopefully deterministic on a given
>   platform, since even with super dynamic setups (based on dt/acpi) the
>   firmware tables should change really.

Are the backlight sysfs names stable, are acpi_backlightN always
enumerated in the same order?


BR,
Jani.

>
> Cheers, Daniel
>> ---
>>  drivers/gpu/drm/Kconfig             |   1 +
>>  drivers/gpu/drm/Makefile            |   2 +-
>>  drivers/gpu/drm/drm_backlight.c     | 387 ++++++++++++++++++++++++++++++++++++
>>  drivers/gpu/drm/drm_crtc.c          |  45 +++--
>>  drivers/gpu/drm/drm_drv.c           |  11 +
>>  drivers/gpu/drm/drm_sysfs.c         |  53 +++++
>>  drivers/video/backlight/backlight.c |   3 +
>>  include/drm/drm_backlight.h         |  44 ++++
>>  include/drm/drm_crtc.h              |   3 +
>>  include/linux/backlight.h           |   1 +
>>  10 files changed, 530 insertions(+), 20 deletions(-)
>>  create mode 100644 drivers/gpu/drm/drm_backlight.c
>>  create mode 100644 include/drm/drm_backlight.h
>> 
>> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
>> index e3b4b0f..46bca34 100644
>> --- a/drivers/gpu/drm/Kconfig
>> +++ b/drivers/gpu/drm/Kconfig
>> @@ -12,6 +12,7 @@ menuconfig DRM
>>  	select I2C
>>  	select I2C_ALGOBIT
>>  	select DMA_SHARED_BUFFER
>> +	select BACKLIGHT_CLASS_DEVICE
>>  	help
>>  	  Kernel-level support for the Direct Rendering Infrastructure (DRI)
>>  	  introduced in XFree86 4.0. If you say Y here, you need to select
>> diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
>> index 9292a76..224544d 100644
>> --- a/drivers/gpu/drm/Makefile
>> +++ b/drivers/gpu/drm/Makefile
>> @@ -14,7 +14,7 @@ drm-y       :=	drm_auth.o drm_bufs.o drm_cache.o \
>>  		drm_info.o drm_debugfs.o drm_encoder_slave.o \
>>  		drm_trace_points.o drm_global.o drm_prime.o \
>>  		drm_rect.o drm_vma_manager.o drm_flip_work.o \
>> -		drm_modeset_lock.o
>> +		drm_modeset_lock.o drm_backlight.o
>>  
>>  drm-$(CONFIG_COMPAT) += drm_ioc32.o
>>  drm-$(CONFIG_DRM_GEM_CMA_HELPER) += drm_gem_cma_helper.o
>> diff --git a/drivers/gpu/drm/drm_backlight.c b/drivers/gpu/drm/drm_backlight.c
>> new file mode 100644
>> index 0000000..92d231a
>> --- /dev/null
>> +++ b/drivers/gpu/drm/drm_backlight.c
>> @@ -0,0 +1,387 @@
>> +/*
>> + * DRM Backlight Helpers
>> + * Copyright (c) 2014 David Herrmann
>> + */
>> +
>> +#include <linux/backlight.h>
>> +#include <linux/fs.h>
>> +#include <linux/list.h>
>> +#include <linux/math64.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/notifier.h>
>> +#include <linux/slab.h>
>> +#include <linux/spinlock.h>
>> +#include <drm/drmP.h>
>> +#include <drm/drm_backlight.h>
>> +
>> +/**
>> + * DOC: Backlight Devices
>> + *
>> + * Backlight devices have always been managed as a separate subsystem,
>> + * independent of DRM. They are usually controlled via separate hardware
>> + * interfaces than the display controller, so the split works out fine.
>> + * However, backlight brightness is a property of a display, and thus a
>> + * property of a DRM connector. We already manage DPMS states via connector
>> + * properties, so it is natural to keep brightness control at the same place.
>> + *
>> + * This DRM backlight interface implements generic backlight properties on
>> + * connectors. It does not handle any hardware backends but simply forwards
>> + * the requests to an available and linked backlight device. The links between
>> + * connectors and backlight devices have to be established by DRM drivers and
>> + * can be modified by user-space via sysfs (and udev rules). The name of the
>> + * backlight device can be written to a sysfs attribute called 'backlight'.
>> + * The device is looked up and linked to the connector (replacing a possible
>> + * previous backlight device). A 'change' uevent is sent whenever a link is
>> + * modified.
>> + *
>> + * Drivers have to call drm_backlight_alloc() after allocating a connector via
>> + * drm_connector_init(). This will automatically add a backlight device to the
>> + * given connector. No hardware device is linked to the connector by default.
>> + * Drivers can set up a default device via drm_backlight_set_name(), but are
>> + * free to leave it empty. User-space will then have to set up the link.
>> + */
>> +
>> +struct drm_backlight {
>> +	struct list_head list;
>> +	struct drm_connector *connector;
>> +	char *link_name;
>> +	struct backlight_device *link;
>> +	struct work_struct work;
>> +	unsigned int set_value;
>> +	bool changed : 1;
>> +};
>> +
>> +static LIST_HEAD(drm_backlight_list);
>> +static DEFINE_SPINLOCK(drm_backlight_lock);
>> +
>> +/* caller must hold @drm_backlight_lock */
>> +static bool __drm_backlight_is_registered(struct drm_backlight *b)
>> +{
>> +	/* a device is live if it is linked to @drm_backlight_list */
>> +	return !list_empty(&b->list);
>> +}
>> +
>> +/* caller must hold @drm_backlight_lock */
>> +static void __drm_backlight_schedule(struct drm_backlight *b)
>> +{
>> +	if (__drm_backlight_is_registered(b))
>> +		schedule_work(&b->work);
>> +}
>> +
>> +static void __drm_backlight_worker(struct work_struct *w)
>> +{
>> +	struct drm_backlight *b = container_of(w, struct drm_backlight, work);
>> +	static char *ep[] = { "BACKLIGHT=1", NULL };
>> +	struct backlight_device *bd;
>> +	bool send_uevent;
>> +	unsigned int v;
>> +
>> +	spin_lock(&drm_backlight_lock);
>> +	send_uevent = b->changed;
>> +	b->changed = false;
>> +	v = b->set_value;
>> +	bd = b->link;
>> +	backlight_device_ref(bd);
>> +	spin_unlock(&drm_backlight_lock);
>> +
>> +	if (bd) {
>> +		backlight_set_brightness(bd, v, BACKLIGHT_UPDATE_DRM);
>> +		backlight_device_unref(bd);
>> +	}
>> +
>> +	if (send_uevent)
>> +		kobject_uevent_env(&b->connector->kdev->kobj, KOBJ_CHANGE, ep);
>> +}
>> +
>> +/* caller must hold @drm_backlight_lock */
>> +static void __drm_backlight_prop_changed(struct drm_backlight *b, uint64_t v)
>> +{
>> +	uint64_t max;
>> +
>> +	if (!b->link)
>> +		return;
>> +
>> +	max = b->link->props.max_brightness;
>> +	if (v >= U16_MAX)
>> +		b->set_value = max;
>> +	else
>> +		b->set_value = (v * max) >> 16;
>> +	__drm_backlight_schedule(b);
>> +}
>> +
>> +/* caller must hold @drm_backlight_lock */
>> +static void __drm_backlight_real_changed(struct drm_backlight *b, uint64_t v)
>> +{
>> +	struct drm_mode_config *config = &b->connector->dev->mode_config;
>> +	unsigned int max, set;
>> +
>> +	if (!b->link)
>> +		return;
>> +
>> +	set = v;
>> +	max = b->link->props.max_brightness;
>> +	if (max < 1)
>> +		return;
>> +
>> +	if (set >= max)
>> +		set = U16_MAX;
>> +	else if (max <= U16_MAX)
>> +		set = (set << 16) / max;
>> +	else
>> +		set = div_u64(v << 16, max);
>> +
>> +	drm_object_property_set_value(&b->connector->base,
>> +				      config->brightness_property, v);
>> +}
>> +
>> +/* caller must hold @drm_backlight_lock */
>> +static void __drm_backlight_link(struct drm_backlight *b,
>> +				 struct backlight_device *bd)
>> +{
>> +	if (bd != b->link) {
>> +		backlight_device_unref(b->link);
>> +		b->link = bd;
>> +		backlight_device_ref(b->link);
>> +		if (bd)
>> +			__drm_backlight_real_changed(b, bd->props.brightness);
>> +		b->changed = true;
>> +		__drm_backlight_schedule(b);
>> +	}
>> +}
>> +
>> +/* caller must hold @drm_backlight_lock */
>> +static void __drm_backlight_lookup(struct drm_backlight *b)
>> +{
>> +	struct backlight_device *bd;
>> +
>> +	if (b->link_name)
>> +		bd = backlight_device_lookup(b->link_name);
>> +	else
>> +		bd = NULL;
>> +
>> +	__drm_backlight_link(b, bd);
>> +	backlight_device_unref(bd);
>> +}
>> +
>> +/**
>> + * drm_backlight_alloc - add backlight capability to a connector
>> + * @connector: connector to add backlight to
>> + *
>> + * This allocates a new DRM-backlight device and links it to @connector. This
>> + * *must* be called before registering the connector. The backlight device will
>> + * be automatically registered in sync with the connector. It will also get
>> + * removed once the connector is removed.
>> + *
>> + * The connector will not have any hardware backlight linked by default. You
>> + * need to call drm_backlight_set_name() if you want to set a default
>> + * backlight. User-space can overwrite those via sysfs.
>> + *
>> + * Returns: 0 on success, negative error code on failure.
>> + */
>> +int drm_backlight_alloc(struct drm_connector *connector)
>> +{
>> +	struct drm_mode_config *config = &connector->dev->mode_config;
>> +	struct drm_backlight *b;
>> +
>> +	b = kzalloc(sizeof(*b), GFP_KERNEL);
>> +	if (!b)
>> +		return -ENOMEM;
>> +
>> +	INIT_LIST_HEAD(&b->list);
>> +	INIT_WORK(&b->work, __drm_backlight_worker);
>> +	b->connector = connector;
>> +	connector->backlight = b;
>> +
>> +	drm_object_attach_property(&connector->base,
>> +				   config->brightness_property, U16_MAX);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(drm_backlight_alloc);
>> +
>> +void drm_backlight_free(struct drm_connector *connector)
>> +{
>> +	struct drm_backlight *b = connector->backlight;
>> +
>> +	if (b) {
>> +		WARN_ON(__drm_backlight_is_registered(b));
>> +		WARN_ON(b->link);
>> +
>> +		kfree(b->link_name);
>> +		kfree(b);
>> +		connector->backlight = NULL;
>> +	}
>> +}
>> +
>> +void drm_backlight_register(struct drm_backlight *b)
>> +{
>> +	if (!b)
>> +		return;
>> +
>> +	WARN_ON(__drm_backlight_is_registered(b));
>> +
>> +	spin_lock(&drm_backlight_lock);
>> +	list_add(&b->list, &drm_backlight_list);
>> +	__drm_backlight_lookup(b);
>> +	spin_unlock(&drm_backlight_lock);
>> +}
>> +
>> +void drm_backlight_unregister(struct drm_backlight *b)
>> +{
>> +	if (!b)
>> +		return;
>> +
>> +	WARN_ON(!__drm_backlight_is_registered(b));
>> +
>> +	spin_lock(&drm_backlight_lock);
>> +	list_del_init(&b->list);
>> +	__drm_backlight_link(b, NULL);
>> +	spin_unlock(&drm_backlight_lock);
>> +
>> +	cancel_work_sync(&b->work);
>> +}
>> +
>> +/**
>> + * drm_backlight_get_name - retrieve name of linked backlight device
>> + * @b: DRM backlight to retrieve name of
>> + * @buf: target buffer for name
>> + * @max: size of the target buffer
>> + *
>> + * This retrieves the name of the backlight device linked to @b and writes it
>> + * into @buf. If @buf is NULL or @max is 0, no name will be retrieved, but this
>> + * function only tests whether a link is set.
>> + * Otherwise, the name will always be written into @buf and will always be
>> + * zero-terminated (truncated if too long).
>> + *
>> + * If no backlight device is linked to @b, this returns -ENOENT. Otherwise, the
>> + * length of the written name (excluding the terminating 0 character) is
>> + * returned.
>> + * Note that if a device name has been set but the underlying backlight device
>> + * does not exist, this will still return the linked name. -ENOENT is only
>> + * returned if no device name has been set, yet (or has been cleared).
>> + *
>> + * Returns: On success the length of the written name, on failure a negative
>> + *          error code.
>> + */
>> +int drm_backlight_get_name(struct drm_backlight *b, char *buf, size_t max)
>> +{
>> +	int r;
>> +
>> +	spin_lock(&drm_backlight_lock);
>> +
>> +	if (!b->link_name) {
>> +		r = -ENOENT;
>> +		goto unlock;
>> +	}
>> +
>> +	r = 0;
>> +	if (buf && max > 0) {
>> +		r = strlen(b->link_name);
>> +		if (r + 1 > max)
>> +			r = max - 1;
>> +		buf[r] = 0;
>> +		memcpy(buf, b->link_name, r);
>> +	}
>> +
>> +unlock:
>> +	spin_unlock(&drm_backlight_lock);
>> +	return r;
>> +}
>> +EXPORT_SYMBOL(drm_backlight_get_name);
>> +
>> +/**
>> + * drm_backlight_set_name - Change the device link of a DRM backlight
>> + * @b: DRM backlight to modify
>> + * @name: name of backlight device
>> + *
>> + * This changes the backlight device-link on @b to the hardware device with
>> + * name @name. @name is stored on the backlight device, even if no such
>> + * hardware device is registered, yet. If a backlight device appears later on,
>> + * it will be automatically linked to all matching DRM backlight devices. If a
>> + * real hardware backlight device already exists with such a name, it is linked
>> + * with immediate effect.
>> + *
>> + * Whenever a real hardware backlight is linked or unlinked from a DRM connector
>> + * an uevent with "BACKLIGHT=1" is generated on the connector.
>> + *
>> + * Returns: 0 on success, negative error code on failure.
>> + */
>> +int drm_backlight_set_name(struct drm_backlight *b, const char *name)
>> +{
>> +	char *namecopy;
>> +
>> +	if (name && *name) {
>> +		namecopy = kstrdup(name, GFP_KERNEL);
>> +		if (!namecopy)
>> +			return -ENOMEM;
>> +	} else {
>> +		namecopy = NULL;
>> +	}
>> +
>> +	spin_lock(&drm_backlight_lock);
>> +
>> +	kfree(b->link_name);
>> +	b->link_name = namecopy;
>> +	if (__drm_backlight_is_registered(b))
>> +		__drm_backlight_lookup(b);
>> +
>> +	spin_unlock(&drm_backlight_lock);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(drm_backlight_set_name);
>> +
>> +void drm_backlight_set_brightness(struct drm_backlight *b, uint64_t value)
>> +{
>> +	spin_lock(&drm_backlight_lock);
>> +	__drm_backlight_prop_changed(b, value);
>> +	spin_unlock(&drm_backlight_lock);
>> +}
>> +
>> +static int drm_backlight_notify(struct notifier_block *self,
>> +				unsigned long event, void *data)
>> +{
>> +	struct backlight_device *bd = data;
>> +	struct drm_backlight *b;
>> +	const char *name;
>> +
>> +	spin_lock(&drm_backlight_lock);
>> +
>> +	switch (event) {
>> +	case BACKLIGHT_REGISTERED:
>> +		name = dev_name(&bd->dev);
>> +		if (!name)
>> +			break;
>> +
>> +		list_for_each_entry(b, &drm_backlight_list, list)
>> +			if (!b->link && !strcmp(name, b->link_name))
>> +				__drm_backlight_link(b, bd);
>> +
>> +		break;
>> +	case BACKLIGHT_UNREGISTERED:
>> +		list_for_each_entry(b, &drm_backlight_list, list)
>> +			if (b->link == bd)
>> +				__drm_backlight_link(b, NULL);
>> +
>> +		break;
>> +	}
>> +
>> +	spin_unlock(&drm_backlight_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static struct notifier_block drm_backlight_notifier = {
>> +	.notifier_call = drm_backlight_notify,
>> +};
>> +
>> +int drm_backlight_init(void)
>> +{
>> +	return backlight_register_notifier(&drm_backlight_notifier);
>> +}
>> +
>> +void drm_backlight_exit(void)
>> +{
>> +	backlight_unregister_notifier(&drm_backlight_notifier);
>> +}
>> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
>> index 7d7c1fd..1e8caa3 100644
>> --- a/drivers/gpu/drm/drm_crtc.c
>> +++ b/drivers/gpu/drm/drm_crtc.c
>> @@ -34,6 +34,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/export.h>
>>  #include <drm/drmP.h>
>> +#include <drm/drm_backlight.h>
>>  #include <drm/drm_crtc.h>
>>  #include <drm/drm_edid.h>
>>  #include <drm/drm_fourcc.h>
>> @@ -918,6 +919,7 @@ void drm_connector_cleanup(struct drm_connector *connector)
>>  	ida_remove(&drm_connector_enum_list[connector->connector_type].ida,
>>  		   connector->connector_type_id);
>>  
>> +	drm_backlight_free(connector);
>>  	drm_mode_object_put(dev, &connector->base);
>>  	kfree(connector->name);
>>  	connector->name = NULL;
>> @@ -963,6 +965,7 @@ int drm_connector_register(struct drm_connector *connector)
>>  	int ret;
>>  
>>  	drm_mode_object_register(connector->dev, &connector->base);
>> +	drm_backlight_register(connector->backlight);
>>  
>>  	ret = drm_sysfs_connector_add(connector);
>>  	if (ret)
>> @@ -986,6 +989,7 @@ EXPORT_SYMBOL(drm_connector_register);
>>   */
>>  void drm_connector_unregister(struct drm_connector *connector)
>>  {
>> +	drm_backlight_unregister(connector->backlight);
>>  	drm_sysfs_connector_remove(connector);
>>  	drm_debugfs_connector_remove(connector);
>>  }
>> @@ -1309,28 +1313,25 @@ EXPORT_SYMBOL(drm_plane_force_disable);
>>  
>>  static int drm_mode_create_standard_connector_properties(struct drm_device *dev)
>>  {
>> -	struct drm_property *edid;
>> -	struct drm_property *dpms;
>> -	struct drm_property *dev_path;
>> +	struct drm_property *p;
>>  
>>  	/*
>>  	 * Standard properties (apply to all connectors)
>>  	 */
>> -	edid = drm_property_create(dev, DRM_MODE_PROP_BLOB |
>> -				   DRM_MODE_PROP_IMMUTABLE,
>> -				   "EDID", 0);
>> -	dev->mode_config.edid_property = edid;
>> -
>> -	dpms = drm_property_create_enum(dev, 0,
>> -				   "DPMS", drm_dpms_enum_list,
>> -				   ARRAY_SIZE(drm_dpms_enum_list));
>> -	dev->mode_config.dpms_property = dpms;
>> -
>> -	dev_path = drm_property_create(dev,
>> -				       DRM_MODE_PROP_BLOB |
>> -				       DRM_MODE_PROP_IMMUTABLE,
>> -				       "PATH", 0);
>> -	dev->mode_config.path_property = dev_path;
>> +	p = drm_property_create(dev, DRM_MODE_PROP_BLOB |
>> +				DRM_MODE_PROP_IMMUTABLE, "EDID", 0);
>> +	dev->mode_config.edid_property = p;
>> +
>> +	p = drm_property_create_enum(dev, 0, "DPMS", drm_dpms_enum_list,
>> +				     ARRAY_SIZE(drm_dpms_enum_list));
>> +	dev->mode_config.dpms_property = p;
>> +
>> +	p = drm_property_create(dev, DRM_MODE_PROP_BLOB |
>> +				DRM_MODE_PROP_IMMUTABLE, "PATH", 0);
>> +	dev->mode_config.path_property = p;
>> +
>> +	p = drm_property_create_range(dev, 0, "BRIGHTNESS", 0, U16_MAX);
>> +	dev->mode_config.brightness_property = p;
>>  
>>  	return 0;
>>  }
>> @@ -4145,12 +4146,18 @@ static int drm_mode_connector_set_obj_prop(struct drm_mode_object *obj,
>>  {
>>  	int ret = -EINVAL;
>>  	struct drm_connector *connector = obj_to_connector(obj);
>> +	struct drm_mode_config *config = &connector->dev->mode_config;
>>  
>>  	/* Do DPMS ourselves */
>> -	if (property == connector->dev->mode_config.dpms_property) {
>> +	if (property == config->dpms_property) {
>>  		if (connector->funcs->dpms)
>>  			(*connector->funcs->dpms)(connector, (int)value);
>>  		ret = 0;
>> +	} else if (property == config->brightness_property) {
>> +		if (connector->backlight)
>> +			drm_backlight_set_brightness(connector->backlight,
>> +						     value);
>> +		ret = 0;
>>  	} else if (connector->funcs->set_property)
>>  		ret = connector->funcs->set_property(connector, property, value);
>>  
>> diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
>> index 6645669..76c9401 100644
>> --- a/drivers/gpu/drm/drm_drv.c
>> +++ b/drivers/gpu/drm/drm_drv.c
>> @@ -33,6 +33,7 @@
>>  #include <linux/mount.h>
>>  #include <linux/slab.h>
>>  #include <drm/drmP.h>
>> +#include <drm/drm_backlight.h>
>>  #include <drm/drm_core.h>
>>  #include "drm_legacy.h"
>>  
>> @@ -890,9 +891,18 @@ static int __init drm_core_init(void)
>>  		goto err_p3;
>>  	}
>>  
>> +	ret = drm_backlight_init();
>> +	if (ret < 0) {
>> +		DRM_ERROR("Cannot initialize backlight interface\n");
>> +		goto err_p4;
>> +	}
>> +
>>  	DRM_INFO("Initialized %s %d.%d.%d %s\n",
>>  		 CORE_NAME, CORE_MAJOR, CORE_MINOR, CORE_PATCHLEVEL, CORE_DATE);
>>  	return 0;
>> +
>> +err_p4:
>> +	debugfs_remove(drm_debugfs_root);
>>  err_p3:
>>  	drm_sysfs_destroy();
>>  err_p2:
>> @@ -905,6 +915,7 @@ err_p1:
>>  
>>  static void __exit drm_core_exit(void)
>>  {
>> +	drm_backlight_exit();
>>  	debugfs_remove(drm_debugfs_root);
>>  	drm_sysfs_destroy();
>>  
>> diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
>> index ab1a5f6..bc5d7f3 100644
>> --- a/drivers/gpu/drm/drm_sysfs.c
>> +++ b/drivers/gpu/drm/drm_sysfs.c
>> @@ -18,6 +18,7 @@
>>  #include <linux/err.h>
>>  #include <linux/export.h>
>>  
>> +#include <drm/drm_backlight.h>
>>  #include <drm/drm_sysfs.h>
>>  #include <drm/drm_core.h>
>>  #include <drm/drmP.h>
>> @@ -256,6 +257,57 @@ static ssize_t modes_show(struct device *device,
>>  	return written;
>>  }
>>  
>> +static ssize_t backlight_show(struct device *device,
>> +			      struct device_attribute *attr,
>> +			      char *buf)
>> +{
>> +	struct drm_connector *connector = to_drm_connector(device);
>> +	int r;
>> +
>> +	if (!connector->backlight)
>> +		return -ENOTSUPP;
>> +
>> +	r = drm_backlight_get_name(connector->backlight, buf, PAGE_SIZE);
>> +	if (r < 0)
>> +		return r;
>> +
>> +	if (r + 1 < PAGE_SIZE) {
>> +		buf[r++] = '\n';
>> +		buf[r] = 0;
>> +	}
>> +
>> +	return r;
>> +}
>> +
>> +static ssize_t backlight_store(struct device *device,
>> +			       struct device_attribute *attr,
>> +			       const char *buf, size_t size)
>> +{
>> +	struct drm_connector *connector = to_drm_connector(device);
>> +	const char *t;
>> +	char *name;
>> +	size_t len;
>> +	int r;
>> +
>> +	if (!connector->backlight)
>> +		return -ENOTSUPP;
>> +
>> +	t = strchrnul(buf, '\n');
>> +	len = t - buf;
>> +
>> +	name = kstrndup(buf, len, GFP_TEMPORARY);
>> +	if (!name)
>> +		return -ENOMEM;
>> +
>> +	r = drm_backlight_set_name(connector->backlight, name);
>> +	kfree(name);
>> +
>> +	if (r < 0)
>> +		return r;
>> +
>> +	return len;
>> +}
>> +
>>  static ssize_t subconnector_show(struct device *device,
>>  			   struct device_attribute *attr,
>>  			   char *buf)
>> @@ -343,6 +395,7 @@ static struct device_attribute connector_attrs[] = {
>>  	__ATTR_RO(enabled),
>>  	__ATTR_RO(dpms),
>>  	__ATTR_RO(modes),
>> +	__ATTR_RW(backlight),
>>  };
>>  
>>  /* These attributes are for both DVI-I connectors and all types of tv-out. */
>> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
>> index 04f323b..a1bc533 100644
>> --- a/drivers/video/backlight/backlight.c
>> +++ b/drivers/video/backlight/backlight.c
>> @@ -113,6 +113,9 @@ static void backlight_generate_event(struct backlight_device *bd,
>>  	case BACKLIGHT_UPDATE_HOTKEY:
>>  		envp[0] = "SOURCE=hotkey";
>>  		break;
>> +	case BACKLIGHT_UPDATE_DRM:
>> +		envp[0] = "SOURCE=drm";
>> +		break;
>>  	default:
>>  		envp[0] = "SOURCE=unknown";
>>  		break;
>> diff --git a/include/drm/drm_backlight.h b/include/drm/drm_backlight.h
>> new file mode 100644
>> index 0000000..9f0c31b
>> --- /dev/null
>> +++ b/include/drm/drm_backlight.h
>> @@ -0,0 +1,44 @@
>> +#ifndef __DRM_BACKLIGHT_H__
>> +#define __DRM_BACKLIGHT_H__
>> +
>> +/*
>> + * Copyright (c) 2014 David Herrmann <dh.herrmann@gmail.com>
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtaining a
>> + * copy of this software and associated documentation files (the "Software"),
>> + * to deal in the Software without restriction, including without limitation
>> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
>> + * and/or sell copies of the Software, and to permit persons to whom the
>> + * Software is furnished to do so, subject to the following conditions:
>> + *
>> + * The above copyright notice and this permission notice shall be included in
>> + * all copies or substantial portions of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
>> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
>> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
>> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
>> + * OTHER DEALINGS IN THE SOFTWARE.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/types.h>
>> +
>> +struct drm_backlight;
>> +struct drm_connector;
>> +
>> +int drm_backlight_init(void);
>> +void drm_backlight_exit(void);
>> +
>> +int drm_backlight_alloc(struct drm_connector *connector);
>> +void drm_backlight_free(struct drm_connector *connector);
>> +void drm_backlight_register(struct drm_backlight *b);
>> +void drm_backlight_unregister(struct drm_backlight *b);
>> +
>> +int drm_backlight_get_name(struct drm_backlight *b, char *buf, size_t max);
>> +int drm_backlight_set_name(struct drm_backlight *b, const char *name);
>> +void drm_backlight_set_brightness(struct drm_backlight *b, uint64_t value);
>> +
>> +#endif /* __DRM_BACKLIGHT_H__ */
>> diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
>> index c40070a..ce3b2f0 100644
>> --- a/include/drm/drm_crtc.h
>> +++ b/include/drm/drm_crtc.h
>> @@ -542,6 +542,8 @@ struct drm_connector {
>>  
>>  	/* requested DPMS state */
>>  	int dpms;
>> +	/* backlight link */
>> +	struct drm_backlight *backlight;
>>  
>>  	void *helper_private;
>>  
>> @@ -823,6 +825,7 @@ struct drm_mode_config {
>>  	struct list_head property_blob_list;
>>  	struct drm_property *edid_property;
>>  	struct drm_property *dpms_property;
>> +	struct drm_property *brightness_property;
>>  	struct drm_property *path_property;
>>  	struct drm_property *plane_type_property;
>>  	struct drm_property *rotation_property;
>> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
>> index bcc0dec..8615f54 100644
>> --- a/include/linux/backlight.h
>> +++ b/include/linux/backlight.h
>> @@ -31,6 +31,7 @@
>>  enum backlight_update_reason {
>>  	BACKLIGHT_UPDATE_HOTKEY,
>>  	BACKLIGHT_UPDATE_SYSFS,
>> +	BACKLIGHT_UPDATE_DRM,
>>  };
>>  
>>  enum backlight_type {
>> -- 
>> 2.1.0
>> 
>
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Jani Nikula, Intel Open Source Technology Center
