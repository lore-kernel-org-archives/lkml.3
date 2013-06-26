Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3FZUFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 16:05:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:46655 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab3FZUFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 16:05:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,946,1363158000"; 
   d="scan'208";a="360080853"
Date: Wed, 26 Jun 2013 13:05:07 -0700
From: Jon Mason <jon.mason@intel.com>
To: Jubin Mehta <jubin.mehta@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Dan Williams <djbw@fb.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v2] dmatest: masking tests for channel capabilities
Message-ID: <20130626200506.GF3344@jonmason-lab>
References: <20130621234647.GA3763@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621234647.GA3763@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 04:46:59PM -0700, Jubin Mehta wrote:
> The current dmatest module tests all the hardware capabilities (MEMCPY, XOR
> and PQ) supported by a particular DMA channel and these tests are performed
> concurrently by default. This patch allows the user to enable or disable the
> test performed for any particular capability. The mask bits for enabling the
> tests are set using the debugfs.
> 
> Signed-off-by: Jubin Mehta <jubin.mehta@intel.com>
> ---
>  Documentation/dmatest.txt |   33 ++++++++++++++++
>  drivers/dma/dmatest.c     |   92 +++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 122 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/dmatest.txt b/Documentation/dmatest.txt
> index 279ac0a..d092646 100644
> --- a/Documentation/dmatest.txt
> +++ b/Documentation/dmatest.txt
> @@ -79,3 +79,36 @@ Comparison between buffers is stored to the dedicated structure.
>  
>  Note that the verify result is now accessible only via file 'results' in the
>  debugfs.
> +
> +	Part 5 - Masking tests for channel capabilities
> +
> +By default, the dmatest module concurrently tests all the hardware capabilities
> +(MEMCPY, XOR and PQ) supported by a particular DMA channel. In order to disable
> +any capability/capabilities from being tested, the user needs to modify the
> +file 'cap_mask' in debugfs.
> +
> +Method to enable the capabilities:
> +
> +PATH = /sys/kernel/debug/dmatest/cap_mask
> +echo copy,xor,pq > $PATH	# Enables all the capability tests (DEFAULT)
> +echo xor > $PATH		# Enables XOR capability test
> +
> +Note: 	No whitespaces between the capabilities.
> +	Only COMMA (,) to be used for separation.
> +
> +Example to perform only MEMCPY and PQ mode tests:
> +
> +	% modprobe dmatest
> +	% echo dma0chan0 > /sys/kernel/debug/dmatest/channel
> +	% echo copy,pq > /sys/kernel/debug/dmatest/cap_mask
> +	% echo 1 > /sys/kernel/debug/dmatest/iterations
> +	% echo 1 > /sys/kernel/debug/dmatest/run
> +
> +	Output:
> +	% cat /sys/kernel/debug/dmatest/results
> +
> +	dma0chan0-copy0: #1: No errors with src_off=0xXX dst_off=0xXX len=0xXX
> +	dma0chan0-pq0: #1: No errors with src_off=0xXX dst_off=0xXX len=0xXX
> +
> +Note: 	The result is available only for the enabled capabilities of
> +	particular channel.
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> index d8ce4ec..c152755 100644
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -23,6 +23,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/uaccess.h>
>  #include <linux/seq_file.h>
> +#include <linux/string.h>
>  
>  static unsigned int test_buf_size = 16384;
>  module_param(test_buf_size, uint, S_IRUGO);
> @@ -66,6 +67,11 @@ module_param(timeout, uint, S_IRUGO);
>  MODULE_PARM_DESC(timeout, "Transfer Timeout in msec (default: 3000), "
>  		 "Pass -1 for infinite timeout");
>  
> +static char test_cap_mask[20] = "copy,xor,pq";
> +module_param_string(cap_mask, test_cap_mask, sizeof(test_cap_mask), S_IRUGO);
> +MODULE_PARM_DESC(cap_mask, "Mask bits for different capability test "
> +		 "(default: copy,xor,pq)");
> +
>  /* Maximum amount of mismatched bytes in buffer to print */
>  #define MAX_ERROR_COUNT		32
>  
> @@ -164,6 +170,7 @@ struct dmatest_chan {
>   * @xor_sources:	number of xor source buffers
>   * @pq_sources:		number of p+q source buffers
>   * @timeout:		transfer timeout in msec, -1 for infinite timeout
> + * @cap_mask:		mask for different hardware capabilities tests
>   */
>  struct dmatest_params {
>  	unsigned int	buf_size;
> @@ -175,6 +182,7 @@ struct dmatest_params {
>  	unsigned int	xor_sources;
>  	unsigned int	pq_sources;
>  	int		timeout;
> +	char		cap_mask[128];
>  };
>  
>  /**
> @@ -883,11 +891,44 @@ static int dmatest_add_threads(struct dmatest_info *info,
>  	return i;
>  }
>  
> +static int dmatest_cap_check(struct dmatest_info *info,
> +		dma_cap_mask_t *test_cap_mask)
> +{
> +	struct dmatest_params	*params;
> +	char			*cap;
> +	unsigned char c;
> +	int i;
> +
> +	params = &info->params;
> +	cap = (params->cap_mask);
> +
> +	for (i = 0; i < 3; i++) {
> +		if (!strncmp(cap, "copy", 4)) {
> +			dma_cap_set(DMA_MEMCPY, *test_cap_mask);

It might be a bit nit picky, but "memcpy" instead of "copy" would
better match the docs and what users think.

The rest looks fine to me.

Thanks,
Jon

> +			cap += 4;
> +		} else if (!strncmp(cap, "xor", 3)) {
> +			dma_cap_set(DMA_XOR, *test_cap_mask);
> +			cap += 3;
> +		} else if (!strncmp(cap, "pq", 2)) {
> +			dma_cap_set(DMA_PQ, *test_cap_mask);
> +			cap += 2;
> +		} else {
> +			return -1;
> +		}
> +		c = *cap++;
> +		if (c != ',')
> +			break;
> +	}
> +	return 0;
> +}
> +
>  static int dmatest_add_channel(struct dmatest_info *info,
>  		struct dma_chan *chan)
>  {
>  	struct dmatest_chan	*dtc;
>  	struct dma_device	*dma_dev = chan->device;
> +	struct dmatest_params	*params;
> +	dma_cap_mask_t		test_cap_mask;
>  	unsigned int		thread_count = 0;
>  	int cnt;
>  
> @@ -900,15 +941,28 @@ static int dmatest_add_channel(struct dmatest_info *info,
>  	dtc->chan = chan;
>  	INIT_LIST_HEAD(&dtc->threads);
>  
> -	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
> +	params = &info->params;
> +
> +	dma_cap_zero(test_cap_mask);
> +	cnt = dmatest_cap_check(info, &test_cap_mask);
> +	if (cnt) {
> +		pr_warn("dmatest: Invalid Capability Mask Paramters\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Run dmatest threads for the supported and enabled capabilities */
> +	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)
> +	    && dma_has_cap(DMA_MEMCPY, test_cap_mask)) {
>  		cnt = dmatest_add_threads(info, dtc, DMA_MEMCPY);
>  		thread_count += cnt > 0 ? cnt : 0;
>  	}
> -	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
> +	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)
> +	    && dma_has_cap(DMA_XOR, test_cap_mask)) {
>  		cnt = dmatest_add_threads(info, dtc, DMA_XOR);
>  		thread_count += cnt > 0 ? cnt : 0;
>  	}
> -	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
> +	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)
> +	    && dma_has_cap(DMA_PQ, test_cap_mask)) {
>  		cnt = dmatest_add_threads(info, dtc, DMA_PQ);
>  		thread_count += cnt > 0 ? cnt : 0;
>  	}
> @@ -1183,6 +1237,31 @@ static const struct file_operations dtf_results_fops = {
>  	.release	= single_release,
>  };
>  
> +static ssize_t dtf_read_cap_mask(struct file *file, char __user *buf,
> +		size_t count, loff_t *ppos)
> +{
> +	struct dmatest_info *info = file->private_data;
> +	return simple_read_from_buffer(buf, count, ppos,
> +			info->dbgfs_params.cap_mask,
> +			strlen(info->dbgfs_params.cap_mask));
> +}
> +
> +static ssize_t dtf_write_cap_mask(struct file *file, const char __user *buf,
> +		size_t size, loff_t *ppos)
> +{
> +	struct dmatest_info *info = file->private_data;
> +	return dtf_write_string(info->dbgfs_params.cap_mask,
> +				sizeof(info->dbgfs_params.cap_mask),
> +				ppos, buf, size);
> +}
> +
> +static const struct file_operations dtf_cap_mask_fops = {
> +	.read   = dtf_read_cap_mask,
> +	.write  = dtf_write_cap_mask,
> +	.open   = simple_open,
> +	.llseek = default_llseek,
> +};
> +
>  static int dmatest_register_dbgfs(struct dmatest_info *info)
>  {
>  	struct dentry *d;
> @@ -1247,6 +1326,12 @@ static int dmatest_register_dbgfs(struct dmatest_info *info)
>  	if (IS_ERR_OR_NULL(d))
>  		goto err_node;
>  
> +	/* Mask bits for hardware capabilities tests */
> +	d = debugfs_create_file("cap_mask", S_IRUGO | S_IWUSR, info->root,
> +				info, &dtf_cap_mask_fops);
> +	if (IS_ERR_OR_NULL(d))
> +		goto err_node;
> +
>  	/* Run or stop threaded test */
>  	d = debugfs_create_file("run", S_IWUSR | S_IRUGO, info->root,
>  				info, &dtf_run_fops);
> @@ -1292,6 +1377,7 @@ static int __init dmatest_init(void)
>  	params->xor_sources = xor_sources;
>  	params->pq_sources = pq_sources;
>  	params->timeout = timeout;
> +	strlcpy(params->cap_mask, test_cap_mask, sizeof(params->cap_mask));
>  
>  	ret = dmatest_register_dbgfs(info);
>  	if (ret)
> -- 
> 1.7.9.5
> 
