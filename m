Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbaGWNw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:52:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:58539 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995AbaGWNwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:52:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,717,1400050800"; 
   d="c'?scan'208";a="577586273"
Date: Wed, 23 Jul 2014 09:52:22 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 05/22] Add vm_replace_mixed()
Message-ID: <20140723135221.GA6754@linux.intel.com>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <b1052af08b49965fd0e6b87b6733b89294c8cc1e.1406058387.git.matthew.r.wilcox@intel.com>
 <20140723114540.GD10317@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20140723114540.GD10317@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 23, 2014 at 02:45:40PM +0300, Kirill A. Shutemov wrote:
> On Tue, Jul 22, 2014 at 03:47:53PM -0400, Matthew Wilcox wrote:
> > From: Matthew Wilcox <willy@linux.intel.com>
> > 
> > vm_insert_mixed() will fail if there is already a valid PTE at that
> > location.  The DAX code would rather replace the previous value with
> > the new PTE.

> > @@ -1492,8 +1492,12 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
> >  	if (!pte)
> >  		goto out;
> >  	retval = -EBUSY;
> > -	if (!pte_none(*pte))
> > -		goto out_unlock;
> > +	if (!pte_none(*pte)) {
> > +		if (!replace)
> > +			goto out_unlock;
> > +		VM_BUG_ON(!mutex_is_locked(&vma->vm_file->f_mapping->i_mmap_mutex));
> > +		zap_page_range_single(vma, addr, PAGE_SIZE, NULL);
> 
> zap_page_range_single() takes ptl by itself in zap_pte_range(). It's not
> going to work.

I have a test program that exercises this path ... it seems to work!
Following the code, I don't understand why it does.  Maybe it's not
exercising this path after all?  I've attached the program (so that I
have an "oh, duh" moment about 5 seconds after sending the email).

> And zap_page_range*() is pretty heavy weapon to shoot down one pte, which
> we already have pointer to. Why?

I'd love to use a lighter-weight weapon!  What would you recommend using,
zap_pte_range()?


--/04w6evG8XlLl3ft
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="dax-mmap-write-hole.c"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

int
main(int argc, char *argv[])
{
	int fd;
	void *addr;
	char buf[4096];

	if (argc != 2) {
		fprintf(stderr, "usage: %s filename\n", argv[0]);
		exit(1);
	}

	if ((fd = open(argv[1], O_CREAT|O_RDWR, 0666)) < 0) {
		perror(argv[1]);
		exit(1);
	}

	if (ftruncate(fd, 4096) < 0) {
		perror("ftruncate");
		exit(1);
	}

	if ((addr = mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED,
					fd, 0)) == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}

	close(fd);

	/* first read */
	memcpy(buf, addr, 4096);

	/* now write a bit */
	memcpy(addr, buf, 8);

	printf("%s: test passed.\n", argv[0]);
	exit(0);
}

--/04w6evG8XlLl3ft--
