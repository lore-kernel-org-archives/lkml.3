Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaLHSOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:14:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59196 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaLHSOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:14:08 -0500
Date: Mon, 8 Dec 2014 18:14:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [RFC][PATCHES] iov_iter.c rewrite
Message-ID: <20141208181401.GD22149@ZenIV.linux.org.uk>
References: <20141204202011.GO29748@ZenIV.linux.org.uk>
 <20141208164650.GB29028@node.dhcp.inet.fi>
 <CA+55aFz6izpVGxkziynRXg7zbHzteQyPJH1Kg91ZO3fzqn3LaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz6izpVGxkziynRXg7zbHzteQyPJH1Kg91ZO3fzqn3LaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 10:07:55AM -0800, Linus Torvalds wrote:

> Which is in the vmalloc address space. So somebody used a vmalloc'ed
> address and tried to convert it to a physical address in order to look
> up the page.
> 
> Which is not a valid operation, and the BUG_ON() is definitely proper.
> 
> Now *why* something tried to do a virt_to_page() on a vmalloc'ed
> address, that I leave to others.

iov_iter_get_pages() in ITER_KVEC case, trying to avoid get_user_pages_fast()
and getting it wrong.  FWIW, the reproducer is finit_module(fd, ....)
where fd has been opened with O_DIRECT.  In that case we get kernel_read()
on O_DIRECT and the buffer has just been vmalloc'ed.

What's the sane way to grab struct page * for a vmalloc'ed address?
