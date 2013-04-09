Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935139Ab3DIP0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:26:44 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54518 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761865Ab3DIP0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:26:43 -0400
Date: Tue, 9 Apr 2013 08:26:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Joe Perches <joe@perches.com>, Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH v3 1/1] Introduce Intel RAPL cooling device driver
Message-ID: <20130409152638.GA3033@kroah.com>
References: <1365511578-30453-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1365511578-30453-2-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365511578-30453-2-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 05:46:18AM -0700, Jacob Pan wrote:
> +config INTEL_RAPL
> +	tristate "Intel RAPL Support"
> +	depends on THERMAL
> +	default y

Unless you can not boot your machine without this, you should never
default to y.  Just delete this line.

> +#define DEBUG

Why?  I think you need to remove this line :)

> +static int rapl_read_data_raw(struct rapl_domain *domain,
> +			struct rapl_primitive_info *rp, bool xlate, u64 *data)
> +{
> +	u32 msr_l, msr_h;
> +	u64 value, final;
> +	u32 msr;
> +	u32 mask_h, mask_l;
> +
> +	BUG_ON(!domain || !rp);

How nice, you just crashed a machine, rendering it useless to get the
bug report out of.  Never do that in a driver.  This is a static
function, that you control the values being sent to it, you should never
have to do such strict parameter checking with this line, or all of the
other lines you have in this function.  You _know_ that they will never
be hit, so don't even check for them.

> +	if (NULL == rp->name || rp->flag & RAPL_PRIMITIVE_DUMMY)

In Linux we do (rp->name == NULL), or even better yet (!rp->name),
please fix that up here and elsewhere in the driver.

> +static int rapl_check_unit(void)
> +{
> +	u64 output;
> +	u32 value;
> +
> +	if (rdmsrl_safe(MSR_RAPL_POWER_UNIT, &output)) {
> +		pr_err("Failed to read power unit MSR 0x%x, exit.\n",
> +			MSR_RAPL_POWER_UNIT);

dev_err() instead?  Same with the other pr_* calls, almost all of them
can be dev_*.

> +static int intel_rapl_probe(struct platform_device *pdev)
> +{
> +	int i;
> +	int ret = 0;
> +	struct thermal_cooling_device *cdev;
> +	struct rapl_domain *rd;
> +
> +	/* read the initial data */
> +	rapl_update_domain_data();
> +
> +	for (i = 0; i < rg_data.nr_domains; i++) {
> +		rd = &rapl_domains[i];
> +		cdev = thermal_cooling_device_register(DRIVER_NAME,
> +						&rapl_domains[i],
> +						&rapl_cdev_ops);
> +		if (IS_ERR(cdev)) {
> +			ret = PTR_ERR(cdev);
> +			goto err_cleanup;
> +		}
> +
> +		rd->cool_dev = cdev;
> +		pr_info("registered RAPL domain %d %s as cooling device\n", i,
> +			rd->name);

No one cares.  If a driver is working properly, it should NEVER print
anything out, even the "I'm now loaded, look at ME!" lines.

> +static void intel_rapl_dev_release(struct device *dev)
> +{
> +	return;
> +}

You didn't just do this...

{sign}

As per the documentation in the kernel tree, I get to publicly mock you
and this code, in which you feel you are somehow smarter than the kernel
by having to 'trick' it by providing an empty release function, thereby
shutting the message it used to give you up.

Do you really think I just put that error message in there for fun?  You
need to think that it was trying to tell you something, and providing an
empty function is NOT what it is trying to tell you, that would be flat
out stupid of it to do.

Surely this didn't pass any internal Intel review, did it?

Fix this now, it's totally unacceptable.

> +MODULE_VERSION("0.1");

No one cares about the module version, just delete it.

> +#define DRIVER_NAME "intel_rapl"

Not needed, use MODULE_BUILD_NAME or some such thing.

> +#define POWER_LIMIT2_ENABLE     (0x1ULL<<47)
> +#define POWER_LIMIT2_CLAMP      (0x1ULL<<48)
> +#define POWER_PKG_LOCK          (0x1ULL<<63)
> +#define POWER_PP_LOCK           (0x1<<31)

We have BIT definitions, why not use them?

The only thing in this platform data .h file, should be platform data,
not structures and definitions and enums, they should all be within the
.c file as no one else cares about them.

> +struct rapl_primitive_info {
> +	const char *name;
> +	u64 mask;
> +	int shift;
> +	enum rapl_domain_msr_id id;
> +	enum unit_type unit;
> +	enum rapl_primitives pm_id;
> +	u32 flag;
> +};
> +
> +#define PRIMITIVE_INFO_INIT(p, m, s, i, u, f) {#p, m, s, i, u, p, f}

C has named initializers, use them please.

greg k-h
