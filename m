Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbaEIR4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 13:56:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54308 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbaEIR4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 13:56:16 -0400
Date: Fri, 9 May 2014 18:56:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, ebiederm@xmission.com,
        linux-security-module@vger.kernel.org, eparis@redhat.com,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: IMA + O_DIRECT (Re: [PATCH 0/1] fix IMA + Apparmor kernel panic)
Message-ID: <20140509175602.GA18016@ZenIV.linux.org.uk>
References: <cover.1399554584.git.d.kasatkin@samsung.com>
 <29977.1399605003@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29977.1399605003@jrobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 12:10:03PM +0900, J. R. Okajima wrote:
> 
> Dmitry Kasatkin:
> > Following patch replaces IMA usage of kernel_read() with special
> > version which skips security check that triggers kernel panic
> > when Apparmor and IMA appraisal are enabled together.
> 
> I know this is related to exit(2), but this behaviour of IMA is related
> to open(2) too.
> When O_DIRECT is specified, some filesystems (for example, ext2) call
> do_blockdev_direct_IO() which acquires i_mutex. But
> IMA:process_measurement() already acquires i_mutex before kernel_read().
> It causes a deadlock even if you replace kernel_read() by a simpler one.
> How can we stop reading the file from IMA?

Disabling it would be a good start...  And no, I'm not kidding - the mess
you are proposing is such that it's not at all obvious that this stuff
is worth the trouble.

Why the devil is it playing with ->i_mutex?  IMA, that is.  Its use for
data is absolutely fs-dependent.  Again, filesystem is *NOT* required
to take ->i_mutex anywhere on the write path.  At all.
