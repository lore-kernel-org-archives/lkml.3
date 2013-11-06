Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3KFSqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:46:49 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:48069 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3KFSqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:46:48 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Matt Wilson <msw@linux.com>,
        Roger Pau =?utf-8?Q?Monn=C3=A9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>,
        Matt Wilson <msw@amazon.com>, xen-devel@lists.xen.org
Subject: Re: [Xen-devel] [PATCH] grant-table: don't set m2p override if kmap_ops is not set
In-Reply-To: <1383733369.26213.45.camel@kazak.uk.xensource.com>
References: <1383650649-13971-1-git-send-email-roger.pau@citrix.com> <5278E64C.40200@citrix.com> <527904EC.9090402@citrix.com> <20131105145607.GB25836@phenom.dumpdata.com> <5279085E.7070703@citrix.com> <1383664090.13961.88.camel@kazak.uk.xensource.com> <527916EE.6060104@citrix.com> <20131105200616.GA23362@u109add4315675089e695.ant.amazon.com> <878ux2vade.fsf@codemonkey.ws> <1383733369.26213.45.camel@kazak.uk.xensource.com>
User-Agent: Notmuch/0.15.2+202~g0c4b8aa (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 06 Nov 2013 10:46:34 -0800
Message-ID: <87a9hhweph.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell <Ian.Campbell@citrix.com> writes:

> On Tue, 2013-11-05 at 12:53 -0800, Anthony Liguori wrote:
>> >> Yes, you are completely right, then I have to figure out why blkback
>> >> works fine with this patch applied (or at least it seems to work fine).
>> >
>> > blkback also works for me when testing a similar patch. I'm still
>> > confused. One thing with your proposed patch: I'm not sure that you're
>> > putting back the correct mfn.
>
> As long as it is unique and owned by the local domain I guess it doesn't
> matter which mfn goes back? It's going to get given back to the generic
> allocator so the content is irrelevant? (all speculation without looking
> at blkback)


Hrm, so m2p_add_override already does set_phys_to_machine(pfn,
FOREIGN_FRAME(mfn)) so this patch doesn't add anything that isn't
already there.  It's just removing the additional to the m2p override
table.

So what happens when the MFN isn't in the m2p override table?  It's
treated as a foreign PFN and m2p lookups fail.  But why is this a
problem for blkback?

>> It's perfectly fine to store a foreign pfn in the m2p table.
>
> No, it's not. The m2p is host global and maps mfns to the pfns in the
> owning domain. A domain which grant maps a foreign mfn into its address
> space doesn't get to update the m2p for that mfn. Perhaps you were
> thinking of the p2m?

Yes, I typoed that bit.

> Depending on how an OS mapping the foreign MFN does things it may well
> be accurate to say that having a foreign pfn in the m2p table is
> harmless, in as much as it will never try and use the m2p for foreign
> pages for anything real, but it depends on the implementation of the
> particular OS.

Note that this patch isn't doing anything to the m2p table.

>>   The m2p
>> override table is used by the grant device to allow a reverse lookup of
>> the real mfn to a pfn even if it's foreign.
>
> Classic Xen used an array of struct page * overrides in the struct vma
> for this sort of use case (e.g. in blktap). That obviously cannot fly
> for pvops...

I don't think the usage from blkback precludes using the gntdev either.
It just so happens that the m2p_add_override does extra work but I don't
think it actually benefits blkback in any way.

Am I missing something?

Regards,

Anthony Liguori

>
> Ian.
