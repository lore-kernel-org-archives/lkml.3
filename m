Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbbAHNEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 08:04:41 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:36531 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbbAHNEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:04:40 -0500
Date: Thu, 8 Jan 2015 13:03:25 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Pavel Machek <pavel@ucw.cz>,
        Mark Seaborn <mseaborn@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRAM unreliable under specific access patern
Message-ID: <20150108130325.0592b18b@lxorguk.ukuu.org.uk>
In-Reply-To: <CALCETrXpJ7CPAKeh9nLA=PoCBT8w8NfhZg5cgUyG9BUtp2Jv+w@mail.gmail.com>
References: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
	<20141224220818.GA17655@amd>
	<20150105192329.5f32c155@lxorguk.ukuu.org.uk>
	<CALCETrXby82sgbGTcSZFj54t=resYcwtPbcFRNh6Ksbr+Ow8HQ@mail.gmail.com>
	<20150106014718.GA23775@node.dhcp.inet.fi>
	<CALCETrV1O1MFJeY6WacF+QHdBGG7HoHdVQy=n951=Y+=g+h7mQ@mail.gmail.com>
	<20150106021836.GA24121@node.dhcp.inet.fi>
	<CALCETrXpJ7CPAKeh9nLA=PoCBT8w8NfhZg5cgUyG9BUtp2Jv+w@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2015 18:26:07 -0800
Andy Lutomirski <luto@amacapital.net> wrote:

> On Mon, Jan 5, 2015 at 6:18 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> > On Mon, Jan 05, 2015 at 05:57:24PM -0800, Andy Lutomirski wrote:
> >> On Mon, Jan 5, 2015 at 5:47 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> >> > On Mon, Jan 05, 2015 at 11:50:04AM -0800, Andy Lutomirski wrote:
> >> >> On Mon, Jan 5, 2015 at 11:23 AM, One Thousand Gnomes
> >> >> <gnomes@lxorguk.ukuu.org.uk> wrote:
> >> >> >> In the meantime, I created test that actually uses physical memory,
> >> >> >> 8MB apart, as described in some footnote. It is attached. It should
> >> >> >> work, but it needs boot with specific config options and specific
> >> >> >> kernel parameters.
> >> >> >
> >> >> > Why not just use hugepages. You know the alignment guarantees for 1GB
> >> >> > pages and that means you don't even need to be root
> >> >> >
> >> >> > In fact - should we be disabling 1GB huge page support by default at this
> >> >> > point, at least on non ECC boxes ?
> >> >>
> >> >> Can you actually damage anyone else's data using a 1 GB hugepage?
> >> >
> >> > hugetlbfs is a filesystem: the answer is yes. Although I don't see the
> >> > issue as a big attach vector.
> >>
> >> What I mean is: if I map a 1 GB hugepage and rowhammer it, is it
> >> likely that the corruption will be confined to the same 1 GB?
> >
> > I don't know for sure, but it looks likely to me according to claim in the
> > paper (8MB). But it still can be sombody else's data: 644 file on
> > hugetlbfs mmap()ed r/o by anyone.

Thats less of a concern I think. As far as I can tell it would depend how
the memory is wired what actually gets hit. I'm not clear if its within
the range or not.

> > When I read the paper I thought that vdso would be interesting target for
> > the attack, but having all these constrains in place, it's hard aim the
> > attack anything widely used.
> >
> 
> The vdso and the vvar page are both at probably-well-known physical
> addresses, so you can at least target the kernel a little bit.  I
> *think* that kASLR helps a little bit here.

SMEP likewise if you were able to use 1GB to corrupt matching lines
elsewhere in RAM (eg the syscall table), but that would I think depend
how the RAM is physically configured.

Thats why the large TLB case worries me. With 4K pages and to an extent
with 2MB pages its actually quite hard to line up an attack if you know
something about the target. With 1GB hugepages you control the lower bits
of the physical address precisely. The question is whether that merely
enables you to decide where to shoot yourself or it goes beyond that ?

(Outside HPC anyway: for HPC cases it bites both ways I suspect - you've
got the ability to ensure you don't hit those access patterns while using
1GB pages, but also nothing to randomise stuff to make them unlikely if
you happen to have worst case aligned data).

