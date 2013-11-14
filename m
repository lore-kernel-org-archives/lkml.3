Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab3KNPOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:14:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab3KNPO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:14:28 -0500
Date: Thu, 14 Nov 2013 10:13:59 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Baoquan He <bhe@redhat.com>, WANG Chao <chaowang@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Subject: Re: /proc/vmcore mmap() failure issue
Message-ID: <20131114151359.GA3913@redhat.com>
References: <20131113204130.GD7613@redhat.com>
 <5284A689.70903@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5284A689.70903@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 07:31:37PM +0900, HATAYAMA Daisuke wrote:

[..]
> BTW, I previously found a part of makedumpfile that truncates the first and
> last pages if they are not aligned in page size. Discussing with Kumagai-san,
> the truncation is performed on some ia64 system and he found a valid data in
> the truncated area, and the latest makedumpfile no longer does such
> truncation.

I went through the mail thread link you posted below. Looks like
bootloader had put command line in that area and that would be truncated
if we exclude partial pages from vmcore.

I don't know about IA64, but on x86, I see that we are trimming partial
pages before they are added to memblock. So any memory allocations after
this should not happen in partial page area. Bootloader still might
place some things in those partial pages I guess.

So do we care about that little bootloader data if it happens to be
there. Dump mechanism works only after kdump service has been loaded.
That means first kernel is up and running. That means any relevant
data passed to us from bootloader has already been copied in kernel
memory and kernel did not crash. So to me, we don't have a strong
need to look at exactly how bootloader passed data looked originally.
We can just look at kernel copy of associated data structures (bootparams,
command line etc).

I think being able to mmap() vmcore is much more important. BTW, is
it possible to change makedumpfile so that it uses mmap() for reading
page aligned areas and falls back to read() interface for reading
partial pages? (Though it is beginning to sound already complicatated
to me).

Given the fact that hpa does not like fixing it in kernel. We are left
with option of fixing it in following places.

- Drop partial pages in kexec-tools
- Drop partial pages in makeudmpfile.
- Read partial pages using read() interface in makedumpfile
- Modify /proc/vmcore to copy partial pages in second kernel's memory.

It is not clear to me that partial pages are really useful.  So I want
to avoid modifying /proc/vmcore to deal with partial pages and increase
complexity.

So fixing makedumpfile (either option2 or option 3) seems least risky
to me. In fact I would say let us keep it simple and truncate partial
pages in makedumpfile to keep it simple. And look at option 3 once we
have a strong use case for partial pages.

What do you think?

Thanks
Vivek
