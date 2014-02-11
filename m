Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbaBKU7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:59:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55832 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaBKU72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:59:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH 09/12] hwmon: vexpress: Use devm helper for hwmon device registration
Date: Tue, 11 Feb 2014 21:57:46 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com> <1392138636-29240-10-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1392138636-29240-10-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402112157.46774.arnd@arndb.de>
X-Provags-ID: V02:K0:MrTmH2AfJUZ72HCq7DMSLiVJlP7u+E9P8v/R7SpVOn/
 vXtc/MyrqRDjaLVxCxnn5Sfd7oNpWf0ATHAfYiNUagkU83nmVR
 3O4HjPL9p/RiclfTcGd0uy5ZY0fgAjb9/uKij8rM4WOqflGrsu
 E6AiBMCV8/CX005vPjo9WPfy4JOJaAvA1WEokjaphsMpLHA4mc
 ZrRh5+zvMFxhnnNdS3sYwm/CpyN6iTjmLsbZWpuimgO3+fMHb6
 n8vHLdFy3kbDSYCI5yqxLQ7z3Yk7JvcFKuwzM9jEE9MdUPAYJu
 56TUcHT4/k7yFNcdbkznFYiCvBn5mJVvt4W6hYRZ9o/AaD43Kb
 KJ6sL0P2kkFM3QLPsZ1w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 February 2014, Pawel Moll wrote:
> -#define VEXPRESS_HWMON_ATTRS(_name, _label_attr, _input_attr)  \
> -struct attribute *vexpress_hwmon_attrs_##_name[] = {           \
> -       &dev_attr_name.attr,                                    \
> -       &dev_attr_##_label_attr.attr,                           \
> -       &sensor_dev_attr_##_input_attr.dev_attr.attr,           \
> -       NULL                                                    \
> -}
> +#define VEXPRESS_HWMON_ATTR_GROUPS(_name, _label_attr, _input_attr)    \
> +static struct attribute *vexpress_hwmon_##_name##_attrs[] = {          \
> +       &dev_attr_##_label_attr.attr,                                   \
> +       &sensor_dev_attr_##_input_attr.dev_attr.attr,                   \
> +       NULL                                                            \
> +};                                                                     \
> +ATTRIBUTE_GROUPS(vexpress_hwmon_##_name)
>  
>  #if !defined(CONFIG_REGULATOR_VEXPRESS)
>  static DEVICE_ATTR(in1_label, S_IRUGO, vexpress_hwmon_label_show, NULL);
>  static SENSOR_DEVICE_ATTR(in1_input, S_IRUGO, vexpress_hwmon_u32_show,
>                 NULL, 1000);
> -static VEXPRESS_HWMON_ATTRS(volt, in1_label, in1_input);
> -static struct attribute_group vexpress_hwmon_group_volt = {
> -       .attrs = vexpress_hwmon_attrs_volt,
> -};
> +VEXPRESS_HWMON_ATTR_GROUPS(volt, in1_label, in1_input);

Maybe it would be a good time to get rid of the obfuscation here and just
open-code the attribute groups rather than defining another macro.

I understand you want to save a few source lines, but it really helps
readability if you can search for the attribute groups when they
are referenced later. Just because the common driver model code uses
macros with string concatenation doesn't mean it's a good idea to
do the same in a device driver.

	Arnd
