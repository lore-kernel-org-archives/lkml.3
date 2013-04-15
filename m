Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3DOHfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:35:05 -0400
Received: from ozlabs.org ([203.10.76.45]:54160 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab3DOHfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:35:04 -0400
Date: Mon, 15 Apr 2013 17:35:02 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, jkenisto@linux.vnet.ibm.com,
        mahesh@linux.vnet.ibm.com, anton@samba.org
Subject: Re: [PATCH 3/8] Introduce generic read function to read
 nvram-partitions
Message-ID: <20130415073501.GC30156@concordia>
References: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420>
 <20130410072125.20150.97063.stgit@aruna-ThinkPad-T420>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410072125.20150.97063.stgit@aruna-ThinkPad-T420>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:51:25PM +0530, Aruna Balakrishnaiah wrote:
> Introduce generic read function to read nvram partitions other than rtas.
> nvram_read_error_log will be retained which is used to read rtas partition
> from rtasd. nvram_read_partition is the generic read function to read from
> any nvram partition.
> 
> Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
> Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/nvram.c |   34 +++++++++++++++++++++++---------
>  1 file changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
> index 742735a..6701b71 100644
> --- a/arch/powerpc/platforms/pseries/nvram.c
> +++ b/arch/powerpc/platforms/pseries/nvram.c
> @@ -293,34 +293,37 @@ int nvram_write_error_log(char * buff, int length,
>  	return rc;
>  }
>  
> -/* nvram_read_error_log
> +/* nvram_read_partition
>   *
> - * Reads nvram for error log for at most 'length'
> + * Reads nvram partition for at most 'length'
>   */
> -int nvram_read_error_log(char * buff, int length,
> -                         unsigned int * err_type, unsigned int * error_log_cnt)
> +int nvram_read_partition(struct nvram_os_partition *part, char *buff,
> +			int length, unsigned int *err_type,
> +			unsigned int *error_log_cnt)
>  {
>  	int rc;
>  	loff_t tmp_index;
>  	struct err_log_info info;
>  	
> -	if (rtas_log_partition.index == -1)
> +	if (part->index == -1)
>  		return -1;
>  
> -	if (length > rtas_log_partition.size)
> -		length = rtas_log_partition.size;
> +	if (length > part->size)
> +		length = part->size;
>  
> -	tmp_index = rtas_log_partition.index;
> +	tmp_index = part->index;
>  
>  	rc = ppc_md.nvram_read((char *)&info, sizeof(struct err_log_info), &tmp_index);
>  	if (rc <= 0) {
> -		printk(KERN_ERR "nvram_read_error_log: Failed nvram_read (%d)\n", rc);
> +		printk(KERN_ERR "nvram_read_partition: "
> +				"Failed nvram_read (%d)\n", rc);

Should be:
	pr_err("%s: Failed ..\n", __FUNCTION__, ..)

cheers
