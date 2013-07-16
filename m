Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732Ab3GPSXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:23:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:7906 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933193Ab3GPSXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:23:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,678,1367996400"; 
   d="c'?scan'208";a="371304649"
Message-ID: <51E59116.2060801@linux.intel.com>
Date: Tue, 16 Jul 2013 11:29:42 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: driver model, duplicate names question
References: <51E57631.2030805@linux.intel.com> <20130716164459.GB17827@kroah.com>
In-Reply-To: <20130716164459.GB17827@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------070603050407020508010600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070603050407020508010600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for the quick response. Here I am creating virtual devices using 
device_register.
I have attached a simple test program, which will give error.

This is my intention:

$> cd /sys/class/test_class
$> ls
power_zone_cpu_package_0
power_zone_cpu_package_1


$> cd power_zone_cpu_package_0
$> ls
power-zone-cpu-0

$> cd ..

$> cd power_zone_cpu_package_1
$> ls
power-zone-cpu-0


The error will be "
Error:
sysfs: cannot create duplicate filename '/class/test_class/power-zone-cpu-0'

I want to avoid a flat model, if there is a server system with many CPU 
packages with multiple cores in each.

Thanks,
Srinivas











On 07/16/2013 09:44 AM, Greg KH wrote:
> On Tue, Jul 16, 2013 at 09:34:57AM -0700, Srinivas Pandruvada wrote:
>> Hi Greg,
>>
>> I would like to create tree like structure using device model (struct
>> device, device_register/device_unregister) using parent/child
>> relationship while creation. I want to be able to create duplicate
>> names, when their parents are different, similar to a directory structure.
>> I see that I can't create devices with duplicate names (device names),
>> even when their parents are different.
> We actually check that?  Nice, I didn't realize that :)
>
>> How can I allow duplicate names when their parents are different devices?
>> I want to avoid flat model as I have parent child relationship and there
>> will be too many devices using flat model.
> Devices on the same bus shouldn't have the same name, but if they are in
> a "tree", it should be ok.  What check is erroring out?
>
>> Why, I need?
>> I am going to publish RFC for a new power cap class driver. We have a
>> multiple controllers under power cap class (they are devices). Under
>> which there are multiple power zones, with parent/child relationships.
>> Currently I have to use  kobject_init_and_add, which I want to avoid and
>> just use device_register. Other places, wherever such relationships are
>> required, kobjects are used like cpufreq.
> Yes, you shouldn't use "raw" kobject calls at all, so we should fix
> this.
>
> thanks,
>
> greg k-h
>


--------------070603050407020508010600
Content-Type: text/x-csrc;
 name="test_dev_create.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test_dev_create.c"

#include <linux/module.h>
#include <linux/device.h>
#include <linux/err.h>
#include <linux/slab.h>

static struct device dev_par_0;
static struct device dev_par_0_child_0;

static struct device dev_par_1;
static struct device dev_par_1_child_0;


static struct class test_class_class = {
	.name = "test_class",
};

static int create_test_devices(void)
{
	int result;

	dev_set_name(&dev_par_0, "power_zone_cpu_package_0");

	dev_par_0.class = &test_class_class;
	result = device_register(&dev_par_0);
	if (result) {
		pr_err("device_register failed for parent_0\n");
		return result;
	}
	
	dev_set_name(&dev_par_1, "power_zone_cpu_package_1");
	dev_par_1.class = &test_class_class;
	result = device_register(&dev_par_1);
	if (result) {
		pr_err("device_register failed for parent_0\n");		
		goto error_par1;
	}
	

	dev_set_name(&dev_par_0_child_0, "power-zone-cpu-0");
	dev_par_0_child_0.class = &test_class_class;
	dev_par_0_child_0.parent = &dev_par_0;
	result = device_register(&dev_par_0_child_0);
	if (result) {
		pr_err("device_register failed for dev_par_0_child_0\n");		
		goto error_par0_child_0;
	}

	dev_set_name(&dev_par_1_child_0, "power-zone-cpu-0");
	dev_par_1_child_0.class = &test_class_class;
	dev_par_1_child_0.parent = &dev_par_1;
	result = device_register(&dev_par_1_child_0);
	if (result) {
		pr_err("device_register failed for dev_par_1_child_0\n");		
		goto error_par0_child_1;
	}

	return 0;

error_par0_child_1:
	device_unregister(&dev_par_0_child_0);
error_par0_child_0:
	device_unregister(&dev_par_1);
error_par1:
	device_unregister(&dev_par_0);

	return result;
}




static int __init dev_create_test_init(void)
{
	int result = 0;

	pr_debug("dev_create_test_init\n");
	result = class_register(&test_class_class);
	if (result)
		return result;

	result = create_test_devices();

	return result;
}

static void dev_create_test_exit(void)
{
	pr_debug("dev_create_test_exit\n");

	device_unregister(&dev_par_0_child_0);
	device_unregister(&dev_par_1_child_0);	
	device_unregister(&dev_par_0);
	device_unregister(&dev_par_1);

	class_unregister(&test_class_class);
}


module_init(dev_create_test_init)
module_exit(dev_create_test_exit)
MODULE_LICENSE("GPL v2");

--------------070603050407020508010600--
