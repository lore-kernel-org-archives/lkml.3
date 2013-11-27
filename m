Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab3K0T1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:27:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3K0T1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:27:00 -0500
Date: Wed, 27 Nov 2013 11:26:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
Subject: Re: [PATCH 3/6] GenWQE Utility functions
Message-ID: <20131127192659.GD28409@kroah.com>
References: <1383741943-14609-1-git-send-email-haver@linux.vnet.ibm.com>
 <1383741943-14609-4-git-send-email-haver@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383741943-14609-4-git-send-email-haver@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 01:45:40PM +0100, Frank Haverkamp wrote:
> +/**
> + * init_crc32() - Prepare a lookup table for fast crc32 calculations
> + *
> + * Existing kernel functions seem to use a different polynom,
> + * therefore we could not use them here.
> + *
> + * Genwqe's Polynomial = 0x20044009
> + */
> +#define CRC32_POLYNOMIAL	0x20044009
> +static u32 crc32_tab[256];	/* crc32 lookup table */
> +
> +void init_crc32(void)

That's a _very_ generic function name to now be global in the whole
kernel.

And why not just add new polynomial functionality to the existing crc32
in-kernel code instead of rolling your own here?

> +static void genwqe_dump_sgl(struct genwqe_dev *cd, struct sg_entry *sgl,
> +		    size_t sgl_size)
> +{
> +	unsigned int i, j;
> +	struct pci_dev *pci_dev = cd->pci_dev;
> +
> +	for (j = 0, i = 0; i < sgl_size/sizeof(struct sg_entry); i++, j++) {
> +		if (j == 8) {
> +			dev_info(&pci_dev->dev, "  --\n");
> +			j = 0;
> +		}
> +		dev_info(&pci_dev->dev, "  %016llx %08x %08x %s\n",
> +			 be64_to_cpu(sgl[i].target_addr),
> +			 be32_to_cpu(sgl[i].len),
> +			 be32_to_cpu(sgl[i].flags),
> +			 (be32_to_cpu(sgl[i].len) > PAGE_SIZE) ? "C" : "");
> +
> +		if (be32_to_cpu(sgl[i].flags) == SG_END_LIST)
> +			break;
> +	}
> +}

That's a lot of kernel log mess, why?

> +/**
> + * free_user_pages() - Give pinned pages back
> + *
> + * Documentation of get_user_pages is in mm/memory.c:
> + *
> + * If the page is written to, set_page_dirty (or set_page_dirty_lock,
> + * as appropriate) must be called after the page is finished with, and
> + * before put_page is called.
> + */
> +static int free_user_pages(struct page **page_list, unsigned int nr_pages,
> +			   int dirty)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		if (page_list[i] != NULL) {
> +			if (dirty)
> +				set_page_dirty_lock(page_list[i]);
> +			put_page(page_list[i]);
> +		}
> +	}
> +	return 0;
> +}
> +
> +/**
> + * user_vmap() - Map user-space memory to virtual kernel memory
> + * @cd:         pointer to genwqe device
> + * @m:          mapping params
> + * @uaddr:      user virtual address
> + * @size:       size of memory to be mapped
> + *
> + * We need to think about how we could speed this up. Of course it is
> + * not a good idea to do this over and over again, like we are
> + * currently doing it. Nevertheless, I am curious where on the path
> + * the performance is spend. Most probably within the memory
> + * allocation functions, but maybe also in the DMA mapping code.
> + *
> + * Restrictions: The maximum size of the possible mapping currently depends
> + *               on the amount of memory we can get using kzalloc() for the
> + *               page_list and pci_alloc_coherent for the sg_list.
> + *               The sg_list is currently itself not scattered, which could
> + *               be fixed with some effort. The page_list must be split into
> + *               PAGE_SIZE chunks too. All that will make the complicated
> + *               code more complicated.
> + *
> + * Return: 0 if success
> + */
> +int user_vmap(struct genwqe_dev *cd, struct dma_mapping *m, void *uaddr,
> +	      unsigned long size, struct ddcb_requ *req)

Again, _very_ generic global symbol name.  Please audit all of these.

And shouldn't this just be a core mm function?  Why is this in a driver?

> +/**
> + * user_vunmap() - Undo mapping of user-space memory to virtual kernel memory
> + * @cd:         pointer to genwqe device
> + * @m:          mapping params
> + */
> +int user_vunmap(struct genwqe_dev *cd, struct dma_mapping *m,
> +		struct ddcb_requ *req)

Same as above.

thanks,

greg k-h
