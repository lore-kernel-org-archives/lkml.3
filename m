Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162784Ab3DEV0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:26:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60291 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1162408Ab3DEV0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:26:37 -0400
Message-ID: <1365197195.2075.23.camel@joe-AO722>
Subject: Re: [PATCH v2] Introduce Intel RAPL cooling device driver
From: Joe Perches <joe@perches.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, Paul Bolle <pebolle@tiscali.nl>
Date: Fri, 05 Apr 2013 14:26:35 -0700
In-Reply-To: <1365195724-8945-2-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1365195724-8945-1-git-send-email-jacob.jun.pan@linux.intel.com>
	 <1365195724-8945-2-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-05 at 14:02 -0700, Jacob Pan wrote:
> RAPL(Running Average Power Limit) interface provides platform software
> with the ability to monitor, control, and get notifications on SOC
> power consumptions. Since its first appearance on Sandy Bridge, more
> features have being added to extend its usage. In RAPL, platforms are
> divided into domains for fine grained control. These domains include
> package, DRAM controller, CPU core (Power Plane 0), graphics uncore
> (power plane 1), etc.

Some more trivia...

> diff --git a/drivers/platform/x86/intel_rapl.c b/drivers/platform/x86/intel_rapl.c
[]
> +/* in the order of enum rapl_primitives */
> +static struct rapl_primitive_info rpi[] = {

const?

> +	/* name, mask, shift, msr index, unit divisor*/
> +	PRIMITIVE_INFO_INIT(energy, ENERGY_STATUS_MASK, 0,
> +			RAPL_DOMAIN_MSR_STATUS, ENERGY_UNIT,
> +			RAPL_PRIMITIVE_EVENT_CAP),

> +static int rapl_set_cur_state(struct thermal_cooling_device *cdev,
> +			unsigned long state)

I think most of this would look nicer if you
adopted the net style of aligning multi-line
statements to the appropriate open parenthesis.

> +static ssize_t store_event_control(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf,
> +				size_t size)
> +{
> +	struct rapl_domain *rd = dev_get_drvdata(dev);
> +	unsigned int efd, new_threshold;
> +	struct file *efile = NULL;
> +	int ret = 0;
> +	int prim;
> +	struct rapl_event *ep;
> +	u64 val;
> +	char cmd[MAX_PRIM_NAME];
> +
> +	if (sscanf(buf, "%u %s %u", &efd, cmd, &new_threshold) != 3)
> +		return -EINVAL;

This sscanf looks fragile.

buf = "1 some_really_long_name_longer_than_MAX_PRIM_NAME 2"

stack overrun.

Where does buf come from?

> +#define primitive_show_fn(n)						\
> +
> +#define primitive_store_fn(n)						\

Can't both of these be consolidated into a 2 functions using
offset_of and/or adding a string argument?

> +static struct attribute *all_attrs[] = {

const?

> +	&dev_attr_energy.attr,


> +static void rapl_update_domain_data(void)
> +{
> +	int i, j;
> +	u64 val;
> +	bool xlate;
> +
> +	for (i = 0; i < rg_data.nr_domains; i++) {
> +		/* exclude non-raw primitives */
> +		for (j = 0; j < NR_RAW_PRIMITIVES; j++)
> +			xlate = !!(rpi[j].unit);

You don't really need the !!.  The compiler does that.

> +/* for global rapl data */
> +static struct class_attribute rapl_class_attrs[] = {

const?

> +	GLOBAL_CLASS_RO_ATTR(energy_unit_divisor),


