Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3LCNWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:22:32 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:46131 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3LCNW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:22:27 -0500
Subject: Re: [PATCH 3/6] GenWQE Utility functions
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <20131127192659.GD28409@kroah.com>
References: <1383741943-14609-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383741943-14609-4-git-send-email-haver@linux.vnet.ibm.com>
	 <20131127192659.GD28409@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 03 Dec 2013 14:21:46 +0100
Message-ID: <1386076906.839.32.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120313-4966-0000-0000-000007B3488C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Mittwoch, den 27.11.2013, 11:26 -0800 schrieb Greg KH:
> On Wed, Nov 06, 2013 at 01:45:40PM +0100, Frank Haverkamp wrote:
> > +/**
> > + * init_crc32() - Prepare a lookup table for fast crc32 calculations
> > + *
> > + * Existing kernel functions seem to use a different polynom,
> > + * therefore we could not use them here.
> > + *
> > + * Genwqe's Polynomial = 0x20044009
> > + */
> > +#define CRC32_POLYNOMIAL	0x20044009
> > +static u32 crc32_tab[256];	/* crc32 lookup table */
> > +
> > +void init_crc32(void)
> 
> That's a _very_ generic function name to now be global in the whole
> kernel.
> 
> And why not just add new polynomial functionality to the existing crc32
> in-kernel code instead of rolling your own here?
> 

The name is indeed to generic. I fixed that. It is for sure a candidate
to be covered by the in-kernel crc support. I had a look and found that
 
   static void crc32init_be(void)

is unfortunately defined static and that the polynomial is missing.
Maybe:

   void crc32init_be_generic(const uint32_t polynomial,
                             uint32_t (*tab)[256])

   inline u32 __pure crc32_be_generic(u32 crc, unsigned char const *p,
                                     size_t len, const u32 (*tab)[256],
                                     u32 polynomial)

would be good to have. Adding my own "crc32table_genwqe_be[]" to the
generic code might be waste memory. None except of us are using that
particular polynomial, as far as I saw. So enhancing the table
generation function and exporting that and the crc32_be_generic might be
a good idea.

In my latest version of the patchset I did not include such a proposal
(yet).

> > +static void genwqe_dump_sgl(struct genwqe_dev *cd, struct sg_entry *sgl,
> > +		    size_t sgl_size)
> > +{
> > +	unsigned int i, j;
> > +	struct pci_dev *pci_dev = cd->pci_dev;
> > +
> > +	for (j = 0, i = 0; i < sgl_size/sizeof(struct sg_entry); i++, j++) {
> > +		if (j == 8) {
> > +			dev_info(&pci_dev->dev, "  --\n");
> > +			j = 0;
> > +		}
> > +		dev_info(&pci_dev->dev, "  %016llx %08x %08x %s\n",
> > +			 be64_to_cpu(sgl[i].target_addr),
> > +			 be32_to_cpu(sgl[i].len),
> > +			 be32_to_cpu(sgl[i].flags),
> > +			 (be32_to_cpu(sgl[i].len) > PAGE_SIZE) ? "C" : "");
> > +
> > +		if (be32_to_cpu(sgl[i].flags) == SG_END_LIST)
> > +			break;
> > +	}
> > +}
> 
> That's a lot of kernel log mess, why?

I removed it. It was for debugging the scatter gather lists our hardware
uses. Since it works now, I can get rid of the printing.

> > +/**
> > + * free_user_pages() - Give pinned pages back
> > + *
> > + * Documentation of get_user_pages is in mm/memory.c:
> > + *
> > + * If the page is written to, set_page_dirty (or set_page_dirty_lock,
> > + * as appropriate) must be called after the page is finished with, and
> > + * before put_page is called.
> > + */
> > +static int free_user_pages(struct page **page_list, unsigned int nr_pages,
> > +			   int dirty)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < nr_pages; i++) {
> > +		if (page_list[i] != NULL) {
> > +			if (dirty)
> > +				set_page_dirty_lock(page_list[i]);
> > +			put_page(page_list[i]);
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> > +/**
> > + * user_vmap() - Map user-space memory to virtual kernel memory
> > + * @cd:         pointer to genwqe device
> > + * @m:          mapping params
> > + * @uaddr:      user virtual address
> > + * @size:       size of memory to be mapped
> > + *
> > + * We need to think about how we could speed this up. Of course it is
> > + * not a good idea to do this over and over again, like we are
> > + * currently doing it. Nevertheless, I am curious where on the path
> > + * the performance is spend. Most probably within the memory
> > + * allocation functions, but maybe also in the DMA mapping code.
> > + *
> > + * Restrictions: The maximum size of the possible mapping currently depends
> > + *               on the amount of memory we can get using kzalloc() for the
> > + *               page_list and pci_alloc_coherent for the sg_list.
> > + *               The sg_list is currently itself not scattered, which could
> > + *               be fixed with some effort. The page_list must be split into
> > + *               PAGE_SIZE chunks too. All that will make the complicated
> > + *               code more complicated.
> > + *
> > + * Return: 0 if success
> > + */
> > +int user_vmap(struct genwqe_dev *cd, struct dma_mapping *m, void *uaddr,
> > +	      unsigned long size, struct ddcb_requ *req)
> 
> Again, _very_ generic global symbol name.  Please audit all of these.

I prefixed those and found some others too. I hope that I have found all
similar cases in our code.

> And shouldn't this just be a core mm function?  Why is this in a driver?

The current implementation is at the moment not generic enough to be
useful for others. But you are right, something alike might be useful if
there is a 2nd or 3rd user with same/similar needs.

> > +/**
> > + * user_vunmap() - Undo mapping of user-space memory to virtual kernel memory
> > + * @cd:         pointer to genwqe device
> > + * @m:          mapping params
> > + */
> > +int user_vunmap(struct genwqe_dev *cd, struct dma_mapping *m,
> > +		struct ddcb_requ *req)
> 
> Same as above.
> 
> thanks,
> 
> greg k-h
> 

Regards

Frank

