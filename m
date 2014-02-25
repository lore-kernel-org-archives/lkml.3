Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaBYDdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:33:33 -0500
Received: from ozlabs.org ([203.10.76.45]:59732 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaBYDda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:33:30 -0500
In-Reply-To: <1392415338-16288-10-git-send-email-cody@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 09/11] powerpc/perf: add support for the hv 24x7 interface
Message-Id: <20140225033329.BBB492C033B@ozlabs.org>
Date: Tue, 25 Feb 2014 14:33:29 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-14-02 at 22:02:13 UTC, Cody P Schafer wrote:
> This provides a basic interface between hv_24x7 and perf. Similar to
> the one provided for gpci, it lacks transaction support and does not
> list any events.
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  arch/powerpc/perf/hv-24x7.c | 491 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 491 insertions(+)
>  create mode 100644 arch/powerpc/perf/hv-24x7.c
> 
> diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
> new file mode 100644
> index 0000000..13de140
> --- /dev/null
> +++ b/arch/powerpc/perf/hv-24x7.c
...
> +
> +/*
> + * read_offset_data - copy data from one buffer to another while treating the
> + *                    source buffer as a small view on the total avaliable
> + *                    source data.
> + *
> + * @dest: buffer to copy into
> + * @dest_len: length of @dest in bytes
> + * @requested_offset: the offset within the source data we want. Must be > 0
> + * @src: buffer to copy data from
> + * @src_len: length of @src in bytes
> + * @source_offset: the offset in the sorce data that (src,src_len) refers to.
> + *                 Must be > 0
> + *
> + * returns the number of bytes copied.
> + *
> + * '.' areas in d are written to.
> + *
> + *                       u
> + *   x         w	 v  z
> + * d           |.........|
> + * s |----------------------|
> + *
> + *                      u
> + *   x         w	z     v
> + * d           |........------|
> + * s |------------------|
> + *
> + *   x         w        u,z,v
> + * d           |........|
> + * s |------------------|
> + *
> + *   x,w                u,v,z
> + * d |------------------|
> + * s |------------------|
> + *
> + *   x        u
> + *   w        v		z
> + * d |........|
> + * s |------------------|
> + *
> + *   x      z   w      v
> + * d            |------|
> + * s |------|
> + *
> + * x = source_offset
> + * w = requested_offset
> + * z = source_offset + src_len
> + * v = requested_offset + dest_len
> + *
> + * w_offset_in_s = w - x = requested_offset - source_offset
> + * z_offset_in_s = z - x = src_len
> + * v_offset_in_s = v - x = request_offset + dest_len - src_len
> + * u_offset_in_s = min(z_offset_in_s, v_offset_in_s)
> + *
> + * copy_len = u_offset_in_s - w_offset_in_s = min(z_offset_in_s, v_offset_in_s)
> + *						- w_offset_in_s

Comments are great, especially for complicated code like this. But at a glance
I don't actually understand what this comment is trying to tell me.

> + */
> +static ssize_t read_offset_data(void *dest, size_t dest_len,
> +				loff_t requested_offset, void *src,
> +				size_t src_len, loff_t source_offset)
> +{
> +	size_t w_offset_in_s = requested_offset - source_offset;
> +	size_t z_offset_in_s = src_len;
> +	size_t v_offset_in_s = requested_offset + dest_len - src_len;
> +	size_t u_offset_in_s = min(z_offset_in_s, v_offset_in_s);
> +	size_t copy_len = u_offset_in_s - w_offset_in_s;
> +
> +	if (requested_offset < 0 || source_offset < 0)
> +		return -EINVAL;
> +
> +	if (z_offset_in_s <= w_offset_in_s)
> +		return 0;
> +
> +	memcpy(dest, src + w_offset_in_s, copy_len);
> +	return copy_len;
> +}
> +
> +static unsigned long h_get_24x7_catalog_page(char page[static 4096],
> +					     u32 version, u32 index)
> +{
> +	WARN_ON(!IS_ALIGNED((unsigned long)page, 4096));
> +	return plpar_hcall_norets(H_GET_24X7_CATALOG_PAGE,
> +			virt_to_phys(page),
> +			version,
> +			index);
> +}
> +
> +static ssize_t catalog_read(struct file *filp, struct kobject *kobj,
> +			    struct bin_attribute *bin_attr, char *buf,
> +			    loff_t offset, size_t count)
> +{
> +	unsigned long hret;
> +	ssize_t ret = 0;
> +	size_t catalog_len = 0, catalog_page_len = 0, page_count = 0;
> +	loff_t page_offset = 0;
> +	uint32_t catalog_version_num = 0;
> +	void *page = kmalloc(4096, GFP_USER);
> +	struct hv_24x7_catalog_page_0 *page_0 = page;
> +	if (!page)
> +		return -ENOMEM;
> +
> +
> +	hret = h_get_24x7_catalog_page(page, 0, 0);
> +	if (hret) {
> +		ret = -EIO;
> +		goto e_free;
> +	}
> +
> +	catalog_version_num = be32_to_cpu(page_0->version);
> +	catalog_page_len = be32_to_cpu(page_0->length);
> +	catalog_len = catalog_page_len * 4096;
> +
> +	page_offset = offset / 4096;
> +	page_count  = count  / 4096;
> +
> +	if (page_offset >= catalog_page_len)
> +		goto e_free;
> +
> +	if (page_offset != 0) {
> +		hret = h_get_24x7_catalog_page(page, catalog_version_num,
> +					       page_offset);
> +		if (hret) {
> +			ret = -EIO;
> +			goto e_free;
> +		}
> +	}
> +
> +	ret = read_offset_data(buf, count, offset,
> +				page, 4096, page_offset * 4096);
> +e_free:
> +	if (hret)
> +		pr_err("h_get_24x7_catalog_page(ver=%d, page=%lld) failed: rc=%ld\n",
> +				catalog_version_num, page_offset, hret);
> +	kfree(page);
> +
> +	pr_devel("catalog_read: offset=%lld(%lld) count=%zu(%zu) catalog_len=%zu(%zu) => %zd\n",
> +			offset, page_offset, count, page_count, catalog_len,
> +			catalog_page_len, ret);
> +
> +	return ret;
> +}
> +
> +#define PAGE_0_ATTR(_name, _fmt, _expr)				\
> +static ssize_t _name##_show(struct device *dev,			\
> +			    struct device_attribute *dev_attr,	\
> +			    char *buf)				\
> +{								\
> +	unsigned long hret;					\
> +	ssize_t ret = 0;					\
> +	void *page = kmalloc(4096, GFP_USER);			\
> +	struct hv_24x7_catalog_page_0 *page_0 = page;		\
> +	if (!page)						\
> +		return -ENOMEM;					\
> +	hret = h_get_24x7_catalog_page(page, 0, 0);		\
> +	if (hret) {						\
> +		ret = -EIO;					\
> +		goto e_free;					\
> +	}							\
> +	ret = sprintf(buf, _fmt, _expr);			\
> +e_free:								\
> +	kfree(page);						\
> +	return ret;						\
> +}								\
> +static DEVICE_ATTR_RO(_name)
> +
> +PAGE_0_ATTR(catalog_version, "%lld\n",
> +		(unsigned long long)be32_to_cpu(page_0->version));
> +PAGE_0_ATTR(catalog_len, "%lld\n",
> +		(unsigned long long)be32_to_cpu(page_0->length) * 4096);
> +static BIN_ATTR_RO(catalog, 0/* real length varies */);

So we're dumping the catalog out as a binary blob.

Why do we want to do that?

It clearly violates the sysfs rule-of-sorts of ASCII and one value per file.
Obviously there can be exceptions, but what's our justification?

> +static struct bin_attribute *if_bin_attrs[] = {
> +	&bin_attr_catalog,
> +	NULL,
> +};
> +
> +static struct attribute *if_attrs[] = {
> +	&dev_attr_catalog_len.attr,
> +	&dev_attr_catalog_version.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group if_group = {
> +	.name = "interface",
> +	.bin_attrs = if_bin_attrs,
> +	.attrs = if_attrs,
> +};

Both pmus have an "interface" directory, but they don't seem to have anything
in common? Its feels a little ad-hoc.

> +static const struct attribute_group *attr_groups[] = {
> +	&format_group,
> +	&if_group,
> +	NULL,
> +};


cheers
