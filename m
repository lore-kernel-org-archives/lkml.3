Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab3LCPNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:13:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab3LCPNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:13:14 -0500
Date: Tue, 3 Dec 2013 10:12:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: Re: [PATCH] vmcore: call remap_pfn_range() separately for respective
 partial pages
Message-ID: <20131203151247.GD4251@redhat.com>
References: <52970342.8090302@jp.fujitsu.com>
 <20131202152754.GC18642@redhat.com>
 <529D3158.2080603@jp.fujitsu.com>
 <529D6933.9070609@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529D6933.9070609@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 02:16:35PM +0900, HATAYAMA Daisuke wrote:

[..]
> >Even if copying partial pages into the 2nd kernel, we need to use ioremap()
> >once on them, and I think the ioremap() is exactly similar to
> >remap_pfn_range() for a single page. There seems no difference on safeness
> >between them.
> >
> 
> I suspected some kind of pre-fetching could be performed when just page table
> is created. But it's common thing between the two cases above. Then, as you say,
> it would be safer to read less data from non-System-RAM area. Copying seems
> better in our case.

If we map page and just read *only* those bytes as advertized by ELF
headers and fill rest of the bytes with zero, I think that seems like
a right thing to do. We are only accessing what has been exported by
ELF headers and not trying to read outside that range.

> 
> Another concern to reading data from partial pages is a possibility of
> undesirable hardware prefetch to non-System-RAM area. Is it better to disable this?

If it becomes an issue, may be. I think we can fix it when we run into
an actual issue.

> 
> >Also, current /proc/vmcore shows user-land tools a shape with holes not
> >filled with zeros both in case of read() and in case of mmap(). If we adapt
> >copying one without reading data in holes, shape of /proc/vmcore gets
> >changed again.
> >
> 
> So, next patch will change data in holes by filling them with zeros.
> 
> BTW, we have now page cache interface implemented by Michael Holzheu, but
> we have yet to use it on x86 because we've never wanted it so far. It's
> natural to use it to read partial pages on-demand, but I also in part think
> that it's not proper time to start using new mechanism that needs to be tested
> more. How do you think?

Do we gain anything significant by using that interface. To me it looks
like this will just delay creation of mapping for partial pages. Does not
save us any memory in second kernel?

I would think that in first pass, keep it simple. Copy partial pages in
second kernel's memory. Read data as exported by ELF headers. Fill rest
of the page with zeros. Adjust /proc/vmcore ELF headers accordingly and
that should do it.

Thanks
Vivek
