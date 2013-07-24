Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3GXXOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 19:14:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:39137 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab3GXXO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 19:14:28 -0400
Message-ID: <1374707624.6142.16.camel@pasglop>
Subject: Re: [PATCH 04/10] powerpc: Prepare to support kernel handling of
 IOMMU map/unmap
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>
Date: Thu, 25 Jul 2013 09:13:44 +1000
In-Reply-To: <20130724154301.2af75867c51870fc0c32819b@linux-foundation.org>
References: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>
	 <1373936045-22653-5-git-send-email-aik@ozlabs.ru>
	 <51EDE903.6010608@ozlabs.ru>
	 <20130724154301.2af75867c51870fc0c32819b@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 15:43 -0700, Andrew Morton wrote:
> For what?  The three lines of comment in page-flags.h?   ack :)
> 
> Manipulating page->_count directly is considered poor form.  Don't
> blame us if we break your code ;)
> 
> Actually, the manipulation in realmode_get_page() duplicates the
> existing get_page_unless_zero() and the one in realmode_put_page()
> could perhaps be placed in mm.h with a suitable name and some
> documentation.  That would improve your form and might protect the code
> from getting broken later on.

Yes, this stuff makes me really nervous :-) If it didn't provide an order
of magnitude performance improvement in KVM I would avoid it but heh...

Alexey, I like having that stuff in generic code.

However the meaning of the words "real mode" can be ambiguous accross
architectures, it might be best to then name it "mmu_off_put_page" to
make things a bit clearer, along with a comment explaining that this is
called in a context where none of the virtual mappings are accessible
(vmalloc, vmemmap, IOs, ...), and that in the case of sparsemem vmemmap
the caller must have taken care of getting the physical address of the
struct page and of ensuring it isn't split accross two vmemmap blocks.

Cheers,
Ben.


