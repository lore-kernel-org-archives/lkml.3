Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab3DBWgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:36:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38955 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932322Ab3DBWfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:35:17 -0400
Message-ID: <1364942115.2085.10.camel@joe-AO722>
Subject: Re: [PATCH 1/1] Introduce Intel RAPL cooling device driver
From: Joe Perches <joe@perches.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 02 Apr 2013 15:35:15 -0700
In-Reply-To: <1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com>
	 <1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 15:15 -0700, Jacob Pan wrote:
> RAPL(Running Average Power Limit) interface provides platform software
> with the ability to monitor, control, and get notifications on SOC
> power consumptions. Since its first appearance on Sandy Bridge, more
> features have being added to extend its usage. In RAPL, platforms are
> divided into domains for fine grained control. These domains include
> package, DRAM controller, CPU core (Power Plane 0), graphics uncore
> (power plane 1), etc.

trivia only:

> diff --git a/drivers/platform/x86/intel_rapl.c b/drivers/platform/x86/intel_rapl.c
[]
> +static char *rapl_domain_names[] = {
> +	"package",
> +	"power_plane_0",
> +	"power_plane_1",
> +	"dram",
> +};

const

> +static void rapl_init_domains(void)
> +{
> +	int i, j = 0;


I think this below is unpleasant to read.
Maybe add a temporary pointer and get rid of j?

	typeof rapl_domains *t = rapl_domains;

(not typeof, but the actual type)

> +
> +	for (i = 0; i < RAPL_DOMAIN_MAX; i++) {
> +		unsigned int mask = rg_data.domain_map & (1 << i);
> +
> +		switch (mask) {
> +		case 1 << RAPL_DOMAIN_PKG:
> +			rapl_domains[j].name =
> +				rapl_domain_names[RAPL_DOMAIN_PKG];

			t->name = rapl_domain_names[RAPL_DOMAIN_PKG];
			etc...
[]
> +		if (mask)
> +			j++;

			t++;

> +/* in the order of enum rapl_primitives */
> +static struct rapl_primitive_info rpi[] = {

const?

> +	/* name, mask, shift, msr index, unit divisor*/
> +	PRIMITIVE_INFO_INIT(energy, ENERGY_STATUS_MASK, 0,
> +			RAPL_DOMAIN_MSR_STATUS, ENERGY_UNIT,
> +			RAPL_PRIMITIVE_EVENT_CAP),

[]
> +static int rapl_read_data_raw(struct rapl_domain *domain,
> +			struct rapl_primitive_info *rp, bool xlate, u64 *data)
> +{
[]
> +	/* specical-case pkg lock bit since pkg domain uses a different bit */

special-case

[]
> +static ssize_t store_event_control(struct rapl_domain *rd, const char *buf,
> +				size_t size)
> +{
> +	unsigned int efd, cfd, new_threshold;
> +	struct file *efile = NULL;
> +	struct file *cfile = NULL;
> +	int ret = 0;
> +	int prim;
> +	struct rapl_event *ep;
> +	u64 val;
> +
> +	if (sscanf(buf, "%u %u %u", &efd, &cfd, &new_threshold) != 3)
> +		return -EINVAL;
> +
> +	efile = eventfd_fget(efd);
> +	if (IS_ERR(efile)) {
> +		ret = PTR_ERR(efile);
> +		pr_err("failed to get eventfd file %d\n", efd);
> +		goto done;
> +	}
> +	cfile = fget(cfd);
> +	if (!cfile) {
> +		ret = -EBADF;
> +		fput(efile);
> +		goto done;
> +	}
> +	/* check if the cfile belongs to the same rapl domain */
> +	if (strcmp(rd->kobj.sd->s_name,
> +			cfile->f_dentry->d_parent->d_name.name)) {
> +		pr_debug("cfile does not belong to domain %s\n",
> +			rd->kobj.sd->s_name);
> +		ret = -EINVAL;
> +		goto exit_cleanup_fds;
> +	}
> +	prim = primitive_name_to_entry(
> +		(const char *)cfile->f_dentry->d_name.name);
> +	if (prim < 0) {
> +		pr_err("failed lookup primitive id for control file %s\n",
> +			cfile->f_dentry->d_name.name);
> +		ret = -EINVAL;
> +		goto exit_cleanup_fds;
> +	}
> +	if (!(rpi[prim].flag & RAPL_PRIMITIVE_EVENT_CAP)) {
> +		pr_info("Invalid control file %d\n", prim);
> +		ret = -EINVAL;
> +		goto exit_cleanup_fds;
> +	}

Perhaps all these pr_<levels> should be pr_err as they
all lead to a failure path.


[]

> +static int stop_periodic_polling(void)
> +{
> +	if (true == polling_started) {

You don't need a comparison,
	if (polling_started) {
is perhaps better.

[]
> +static int rapl_detect_domains(void)
> +{
[]
> +	pr_info("Found %d vaild RAPL domains\n", rg_data.nr_domains);

valid

> +	rapl_domains = kzalloc(sizeof(struct rapl_domain) * rg_data.nr_domains,
> +			GFP_KERNEL);

kcalloc

> +	if (NULL == rapl_domains) {
> +		pr_err("Failed to allocate memory for rapl domain\n");

You don't need OOM messages as the memory
subsystem already does a dump_stack on OOM.

[]

> +static int __init intel_rapl_init(void)
> +{

> +	rd_data = kzalloc(sizeof(struct rapl_domain_data) * rg_data.nr_domains,
> +			GFP_KERNEL);

kcalloc again.

> +	if (NULL == rd_data) {
> +		pr_err("Failed to allocate memory for rapl domain data\n");

OOM too.


