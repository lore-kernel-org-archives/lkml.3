Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab3KFKW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:22:59 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:7910 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159Ab3KFKW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:22:57 -0500
X-IronPort-AV: E=Sophos;i="4.93,645,1378857600"; 
   d="scan'208";a="68533754"
Message-ID: <1383733369.26213.45.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] grant-table: don't set m2p override if
 kmap_ops is not set
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Matt Wilson <msw@linux.com>,
        Roger Pau =?ISO-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, David Vrabel <david.vrabel@citrix.com>,
        Matt Wilson <msw@amazon.com>, <xen-devel@lists.xen.org>
Date: Wed, 6 Nov 2013 10:22:49 +0000
In-Reply-To: <878ux2vade.fsf@codemonkey.ws>
References: <1383650649-13971-1-git-send-email-roger.pau@citrix.com>
	 <5278E64C.40200@citrix.com> <527904EC.9090402@citrix.com>
	 <20131105145607.GB25836@phenom.dumpdata.com> <5279085E.7070703@citrix.com>
	 <1383664090.13961.88.camel@kazak.uk.xensource.com>
	 <527916EE.6060104@citrix.com>
	 <20131105200616.GA23362@u109add4315675089e695.ant.amazon.com>
	 <878ux2vade.fsf@codemonkey.ws>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-05 at 12:53 -0800, Anthony Liguori wrote:
> >> Yes, you are completely right, then I have to figure out why blkback
> >> works fine with this patch applied (or at least it seems to work fine).
> >
> > blkback also works for me when testing a similar patch. I'm still
> > confused. One thing with your proposed patch: I'm not sure that you're
> > putting back the correct mfn.

As long as it is unique and owned by the local domain I guess it doesn't
matter which mfn goes back? It's going to get given back to the generic
allocator so the content is irrelevant? (all speculation without looking
at blkback)

> It's perfectly fine to store a foreign pfn in the m2p table.

No, it's not. The m2p is host global and maps mfns to the pfns in the
owning domain. A domain which grant maps a foreign mfn into its address
space doesn't get to update the m2p for that mfn. Perhaps you were
thinking of the p2m?

Depending on how an OS mapping the foreign MFN does things it may well
be accurate to say that having a foreign pfn in the m2p table is
harmless, in as much as it will never try and use the m2p for foreign
pages for anything real, but it depends on the implementation of the
particular OS.

>   The m2p
> override table is used by the grant device to allow a reverse lookup of
> the real mfn to a pfn even if it's foreign.

Classic Xen used an array of struct page * overrides in the struct vma
for this sort of use case (e.g. in blktap). That obviously cannot fly
for pvops...

Ian.

