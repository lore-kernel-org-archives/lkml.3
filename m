Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbaEORXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:23:03 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49856 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaEORXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:23:01 -0400
Date: Thu, 15 May 2014 10:22:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jean Delvare <jdelvare@suse.de>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: Document hwmon kernel API
Message-ID: <20140515172249.GB18562@roeck-us.net>
References: <1400122954-1742-1-git-send-email-linux@roeck-us.net>
 <5374F253.4030004@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5374F253.4030004@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 09:58:59AM -0700, Randy Dunlap wrote:
> On 05/14/2014 08:02 PM, Guenter Roeck wrote:
> > The hwmon subsystem has been around for a while. Time to document
> > its kernel API.
> > 
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  Documentation/hwmon/hwmon-kernel-api.txt | 107 +++++++++++++++++++++++++++++++
> >  1 file changed, 107 insertions(+)
> >  create mode 100644 Documentation/hwmon/hwmon-kernel-api.txt
> > 
> > diff --git a/Documentation/hwmon/hwmon-kernel-api.txt b/Documentation/hwmon/hwmon-kernel-api.txt
> > new file mode 100644
> > index 0000000..70889de
> > --- /dev/null
> > +++ b/Documentation/hwmon/hwmon-kernel-api.txt
> > @@ -0,0 +1,107 @@
> > +The Linux Hardware Monitoring kernel API.
> > +=========================================
> > +
> > +Guenter Roeck
> > +
> > +Introduction
> > +------------
> > +
> > +This document describes the API that can be used by hardware monitoring
> > +drivers that want to use the hardware monitoring framework.
> > +
> > +This document does not describe what a hardware monitoring (hwmon) Driver or
> > +Device is. It also does not describe the API which can be used by user space
> > +to communicate with a hardware monitoring device. If you want to know this
> > +then please read the following file: Documentation/hwmon/sysfs-interface.
> > +
> > +For additional guidelines on how to write and improve hwmon drivers, please
> > +also read Documentation/hwmon/submitting-patches.
> > +
> > +The API
> > +-------
> > +Each hardware monitoring driver must #include <linux/hwmon.h> and, in most
> > +cases, <linux/hwmon-sysfs.h>. linux/hwmon.h declares the following
> > +register/unregister functions:
> > +
> > +struct device *hwmon_device_register(struct device *dev);
> > +struct device *
> > +hwmon_device_register_with_groups(struct device *dev, const char *name,
> > +				  void *drvdata,
> > +				  const struct attribute_group **groups);
> > +
> > +struct device *
> > +devm_hwmon_device_register_with_groups(struct device *dev,
> > +				       const char *name, void *drvdata,
> > +				       const struct attribute_group **groups);
> > +
> > +void hwmon_device_unregister(struct device *dev);
> > +void devm_hwmon_device_unregister(struct device *dev);
> > +
> > +hwmon_device_register registers a hardware monitoring device. The parameter
> > +of this function is a pointer to the parent device.
> > +This function returns a pointer to the newly created hardware monitoring device
> > +or PTR_ERR for failure. If this registration function is used, hardware
> > +monitoring sysfs attributes are expected to have been created and attached to
> > +the parent device prior to calling hwmon_device_register. A name attribute must
> > +have been created by the caller.
> > +
> > +hwmon_device_register_with_groups is similar to hwmon_device_register. However,
> > +it has additional parameters. The name parameter is a pointer to the hwmon
> > +device name. The registration function wil create a name sysfs attribute
> > +pointing to this name. The drvdata parameter is the pointer to the local
> > +driver data.  hwmon_device_register_with_groups will attach this pointer
> > +to the newly allocated hwmon device. The pointer can be retrieved by the driver
> > +using dev_get_drvdata() on the hwmon device pointer. The groups parameter is
> > +a pointer to a list of sysfs attribute groups. The list must be NULL terminated.
> > +hwmon_device_register_with_groups creates the hwmon device with name attribute
> > +as well as all sysfs attributes attached to the hwmon device.
> > +
> > +devm_hwmon_device_register_with_groups is similar to
> > +hwmon_device_register_with_groups. However, it is device managed, meaning the
> > +hwmon device does not have to be removed explicitly by the removal function.
> > +
> > +hwmon_device_unregister deregisters a registered hardware monitoring device.
> > +The parameter of this function is the pointer to the registered hardware
> > +monitoring device structure. This function must be called from the driver
> > +remove function if the hardware monitoring device was registered with
> > +hwmon_device_register or with hwmon_device_register_with_groups.
> > +
> > +devm_hwmon_device_unregister does not normally have to be called. It is only
> > +needed for error handling, and only needed if the driver probe fails after
> > +the call to devm_hwmon_device_register_with_groups.
> > +
> > +The include file linux/hwmon-sysfs.h provides a number of useful macros to
> 
>        header file
> 
> > +declare and use hardware monitoring sysfs attributes.
> > +
> > +In many cases, you can use the exsting define DEVICE_ATTR to declare such
> > +attributes. This is feasible if an attribute has no additional context. However,
> > +in many cases there will be additional information such as a sensor index which
> > +will need to be passed to the sysfs attribute handling function.
> > +
> > +SENSOR_DEVICE_ATTR and SENSOR_DEVICE_ATTR_2 can be used to define attributes
> > +which need such additional context information. SENSOR_DEVICE_ATTR requires
> > +one additional argument, SENSOR_DEVICE_ATTR_2 requires two.
> > +
> > +SENSOR_DEVICE_ATTR defines a struct sensor_device_attribute variable.
> > +This structure has the following fields.
> > +
> > +struct sensor_device_attribute {
> > +	struct device_attribute dev_attr;
> > +	int index;
> > +};
> > +
> > +You can use to_sensor_dev_attr to get the pointer to this structure from the
> > +attribute read or write function. Parameter is the device to which the attribute
> 
>                                      Its parameter is
> 
> > +is attached.
> > +
> > +SENSOR_DEVICE_ATTR_2 defines a struct sensor_device_attribute_2 variable,
> > +which is defined as follows.
> > +
> > +struct sensor_device_attribute_2 {
> > +	struct device_attribute dev_attr;
> > +	u8 index;
> > +	u8 nr;
> > +};
> > +
> > +Use to_sensor_dev_attr_2 to get the pointer to this structure. Parameter is the
> 
>                                                                   Its parameter is
> 
> > +device to which the attribute is attached.
> > 
> 
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Please merge thru the hwmon tree.
> 
Updated, and will do. Thanks a lot for the review!

Guenter
