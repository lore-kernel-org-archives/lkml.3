Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3DOHz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:55:59 -0400
Received: from ozlabs.org ([203.10.76.45]:49737 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab3DOHz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:55:58 -0400
Date: Mon, 15 Apr 2013 17:55:55 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, jkenisto@linux.vnet.ibm.com,
        mahesh@linux.vnet.ibm.com, anton@samba.org
Subject: Re: [PATCH 4/8] Read/Write oops nvram partition via pstore
Message-ID: <20130415075555.GE30156@concordia>
References: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420>
 <20130410072303.20150.61382.stgit@aruna-ThinkPad-T420>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410072303.20150.61382.stgit@aruna-ThinkPad-T420>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:53:03PM +0530, Aruna Balakrishnaiah wrote:
> This patch exploits pstore infrastructure in power systems.
> IBM's system p machines provide persistent storage for LPARs

In the kernel we use "pseries" instead of "system p".

> through NVRAM. NVRAM's lnx,oops-log partition is used to log
> oops messages. In case pstore registration fails it will
> fall back to kmsg_dump mechanism.

What are the implications of falling back to kmsg_dump()?


Is there any reason we would not want to enable CONFIG_PSTORE ? ie.
should the pseries platform just select it?

> diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
> index 6701b71..82d32a2 100644
> --- a/arch/powerpc/platforms/pseries/nvram.c
> +++ b/arch/powerpc/platforms/pseries/nvram.c
> @@ -18,6 +18,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/slab.h>
>  #include <linux/kmsg_dump.h>
> +#include <linux/pstore.h>
>  #include <linux/ctype.h>
>  #include <linux/zlib.h>
>  #include <asm/uaccess.h>
> @@ -87,6 +88,25 @@ static struct kmsg_dumper nvram_kmsg_dumper = {
>  	.dump = oops_to_nvram
>  };
>  
> +static int nvram_pstore_open(struct pstore_info *psi);
> +
> +static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
> +				int *count, struct timespec *time, char **buf,
> +				struct pstore_info *psi);
> +
> +static int nvram_pstore_write(enum pstore_type_id type,
> +				enum kmsg_dump_reason reason, u64 *id,
> +				unsigned int part, int count, size_t size,
> +				struct pstore_info *psi);

I think you should be able to rearrange this so that you don't need the
forward declarations.

> +
> +static struct pstore_info nvram_pstore_info = {
> +	.owner = THIS_MODULE,
> +	.name = "nvram",
> +	.open = nvram_pstore_open,
> +	.read = nvram_pstore_read,
> +	.write = nvram_pstore_write,
> +};
> +
>  /* See clobbering_unread_rtas_event() */
>  #define NVRAM_RTAS_READ_TIMEOUT 5		/* seconds */
>  static unsigned long last_unread_rtas_event;	/* timestamp */
> @@ -121,6 +141,13 @@ static char *big_oops_buf, *oops_buf;
>  static char *oops_data;
>  static size_t oops_data_sz;
>  
> +#ifdef CONFIG_PSTORE

If we are going to have CONFIG_PSTORE #ifdefs in this file, I don't see
why there can't be just a single block of code that is #ifdef'ed, rather
than several like you have.

> +static enum pstore_type_id nvram_type_ids[] = {
> +	PSTORE_TYPE_DMESG,
> +	-1
> +};
> +static int read_type;

I don't understand what you're doing with read_type. It looks fishy.

> +#endif
>  /* Compression parameters */
>  #define COMPR_LEVEL 6
>  #define WINDOW_BITS 12
> @@ -455,6 +482,23 @@ static void __init nvram_init_oops_partition(int rtas_partition_exists)
>  	oops_data = oops_buf + sizeof(struct oops_log_info);
>  	oops_data_sz = oops_log_partition.size - sizeof(struct oops_log_info);
>  
> +	nvram_pstore_info.buf = oops_data;
> +	nvram_pstore_info.bufsize = oops_data_sz;
> +
> +	rc = pstore_register(&nvram_pstore_info);
> +
> +	if (rc != 0) {
> +		pr_err("nvram: pstore_register() failed, defaults to "
> +				"kmsg_dump; returned %d\n", rc);
> +		goto kmsg_dump;

You don't need the goto.

> +	} else {
> +		/*TODO: Support compression when pstore is configured */

What is the issue here?

> +		pr_info("nvram: Compression of oops text supported only when "
> +				"pstore is not configured");
> +		return;
> +	}
> +
> +kmsg_dump:
>  	/*
>  	 * Figure compression (preceded by elimination of each line's <n>
>  	 * severity prefix) will reduce the oops/panic report to at most
> @@ -663,3 +707,104 @@ static void oops_to_nvram(struct kmsg_dumper *dumper,
>  
>  	spin_unlock_irqrestore(&lock, flags);
>  }
> +
> +#ifdef CONFIG_PSTORE

Same comment about too many ifdefs.

> +static int nvram_pstore_open(struct pstore_info *psi)
> +{
> +	read_type = -1;

Locking?

> +	return 0;
> +}
> +
> +/*

Make it a kernel-doc style comment.

> + * Called by pstore_dump() when an oops or panic report is logged to the printk
> + * buffer. @size bytes have been written to oops_buf, starting after the
> + * oops_log_info header.

"@size bytes have", or "@size bytes should be written"?

> + */
> +static int nvram_pstore_write(enum pstore_type_id type,
> +				enum kmsg_dump_reason reason,
> +				u64 *id, unsigned int part, int count,
> +				size_t size, struct pstore_info *psi)
> +{
> +	struct oops_log_info *oops_hdr = (struct oops_log_info *) oops_buf;
> +
> +	/* part 1 has the recent messages from printk buffer */
> +	if (part > 1 || clobbering_unread_rtas_event())
> +		return -1;
> +
> +	BUG_ON(type != PSTORE_TYPE_DMESG);
> +	BUG_ON(sizeof(*oops_hdr) + size > oops_log_partition.size);

Why would we be called with the wrong type? Would it be better to just
return an error, rather than causing another oops while we're trying to
write the oops?

And couldn't we just clamp the size, rather than BUG'ing.

> +	oops_hdr->version = OOPS_HDR_VERSION;
> +	oops_hdr->report_length = (u16) size;
> +	oops_hdr->timestamp = get_seconds();
> +	(void) nvram_write_os_partition(&oops_log_partition, oops_buf,
> +		(int) (sizeof(*oops_hdr) + size), ERR_TYPE_KERNEL_PANIC,
> +		count);

You definitely don't need the (void). But more to the point why aren't
you checking the return value?

> +	*id = part;

What is this? Part of the API?

> +	return 0;
> +}
> +
> +/*
> + * Reads the oops/panic report.
> + * Returns the length of the data we read from each partition.
> + * Returns 0 if we've been called before.
> + */
> +static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
> +				int *count, struct timespec *time, char **buf,
> +				struct pstore_info *psi)
> +{
> +	struct oops_log_info *oops_hdr;
> +	unsigned int err_type, id_no;
> +	struct nvram_os_partition *part = NULL;
> +	char *buff = NULL;
> +
> +	read_type++;
> +
> +	switch (nvram_type_ids[read_type]) {
> +	case PSTORE_TYPE_DMESG:
> +		part = &oops_log_partition;
> +		*type = PSTORE_TYPE_DMESG;
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	buff = kmalloc(part->size, GFP_KERNEL);
> +
> +	if (!buff)
> +		return -ENOMEM;
> +
> +	if (nvram_read_partition(part, buff, part->size, &err_type, &id_no)) {
> +		kfree(buff);
> +		return 0;
> +	}
> +
> +	*count = 0;
> +	*id = id_no;

Can't you just cast in the call to nvram_read_partition() ?

> +	oops_hdr = (struct oops_log_info *)buff;
> +	*buf = buff + sizeof(*oops_hdr);
> +	time->tv_sec = oops_hdr->timestamp;
> +	time->tv_nsec = 0;
> +	return oops_hdr->report_length;
> +}
> +#else
> +static int nvram_pstore_open(struct pstore_info *psi)
> +{
> +	return 0;
> +}
> +
> +static int nvram_pstore_write(enum pstore_type_id type,
> +				enum kmsg_dump_reason reason, u64 *id,
> +				unsigned int part, int count, size_t size,
> +				struct pstore_info *psi)
> +{
> +	return 0;
> +}
> +
> +static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
> +				int *count, struct timespec *time, char **buf,
> +				struct pstore_info *psi)
> +{
> +	return 0;
> +}
> +#endif

I don't understand why we have empty versions of these. If CONFIG_PSTORE
is disabled we should just not register with pstore at all.

cheers
