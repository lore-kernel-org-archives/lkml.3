Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbaGXBhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 21:37:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:62171 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787AbaGXBhE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 21:37:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,721,1400050800"; 
   d="scan'208";a="574529662"
From: "Zhang, Tianfei" <tianfei.zhang@intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Matthew Wilcox <willy@linux.intel.com>
CC: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 05/22] Add vm_replace_mixed()
Thread-Topic: [PATCH v8 05/22] Add vm_replace_mixed()
Thread-Index: AQHPpmug9XRc5HMQEkqxOkS2M+gEOJutJ7MAgAAH8gCAAAHxgIAAGGEAgAEl3yA=
Date: Thu, 24 Jul 2014 01:36:53 +0000
Message-ID: <BA6F50564D52C24884F9840E07E32DEC17D6F8D8@CDSMSX102.ccr.corp.intel.com>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <b1052af08b49965fd0e6b87b6733b89294c8cc1e.1406058387.git.matthew.r.wilcox@intel.com>
 <20140723114540.GD10317@node.dhcp.inet.fi>
 <20140723135221.GA6754@linux.intel.com>
 <20140723142048.GA11963@node.dhcp.inet.fi>
 <20140723142745.GD6754@linux.intel.com>
 <20140723155500.GA12790@node.dhcp.inet.fi>
In-Reply-To: <20140723155500.GA12790@node.dhcp.inet.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.17.6.105]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is double page_table_lock issue, should be free-and-realloc will be simple and readability?

+	if (!pte_none(*pte)) {
+		if (!replace)
+			goto out_unlock;
+		VM_BUG_ON(!mutex_is_locked(&vma->vm_file->f_mapping->i_mmap_mutex));
+      pte_unmap_unlock(pte, ptl);
+		zap_page_range_single(vma, addr, PAGE_SIZE, NULL);
+      pte = get_locked_pte(mm, addr, &ptl);
+	}

Best,
Figo

> -----Original Message-----
> From: owner-linux-mm@kvack.org [mailto:owner-linux-mm@kvack.org] On
> Behalf Of Kirill A. Shutemov
> Sent: Wednesday, July 23, 2014 11:55 PM
> To: Matthew Wilcox
> Cc: Wilcox, Matthew R; linux-fsdevel@vger.kernel.org; linux-mm@kvack.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v8 05/22] Add vm_replace_mixed()
> 
> On Wed, Jul 23, 2014 at 10:27:45AM -0400, Matthew Wilcox wrote:
> > On Wed, Jul 23, 2014 at 05:20:48PM +0300, Kirill A. Shutemov wrote:
> > > On Wed, Jul 23, 2014 at 09:52:22AM -0400, Matthew Wilcox wrote:
> > > > I'd love to use a lighter-weight weapon!  What would you recommend
> > > > using, zap_pte_range()?
> > >
> > > The most straight-forward way: extract body of pte cycle from
> > > zap_pte_range() to separate function -- zap_pte() -- and use it.
> >
> > OK, I can do that.  What about the other parts of zap_page_range(), do
> > I need to call them?
> >
> >         lru_add_drain();
> 
> No, I guess..
> 
> >         tlb_gather_mmu(&tlb, mm, address, end);
> >         tlb_finish_mmu(&tlb, address, end);
> 
> New zap_pte() should tolerate tlb == NULL and does flush_tlb_page() or
> pte_clear_*flush or something.
> 
> >         update_hiwater_rss(mm);
> 
> No: you cannot end up with lower rss after replace, iiuc.
> 
> >         mmu_notifier_invalidate_range_start(mm, address, end);
> >         mmu_notifier_invalidate_range_end(mm, address, end);
> 
> mmu_notifier_invalidate_page() should be enough.
> 
> > > > 	if ((fd = open(argv[1], O_CREAT|O_RDWR, 0666)) < 0) {
> > > > 		perror(argv[1]);
> > > > 		exit(1);
> > > > 	}
> > > >
> > > > 	if (ftruncate(fd, 4096) < 0) {
> > >
> > > Shouldn't this be ftruncate(fd, 0)? Otherwise the memcpy() below
> > > will fault in page from backing storage, not hole and write will not
> > > replace anything.
> >
> > Ah, it was starting with a new file, hence the O_CREAT up above.
> 
> Do you mean you pointed to new file all the time? O_CREAT doesn't truncate
> file if it exists, iirc.
> 
> --
>  Kirill A. Shutemov
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in the body to
> majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
