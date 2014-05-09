Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbaEIS3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:29:20 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43720 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbaEIS3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:29:19 -0400
Message-ID: <1399660097.2232.29.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: IMA + O_DIRECT (Re: [PATCH 0/1] fix IMA + Apparmor kernel panic)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "J. R. Okajima" <hooanon05g@gmail.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>, ebiederm@xmission.com,
        linux-security-module@vger.kernel.org, eparis@redhat.com,
        dmitry.kasatkin@gmail.com, linux-kernel@vger.kernel.org
Date: Fri, 09 May 2014 14:28:17 -0400
In-Reply-To: <20140509175602.GA18016@ZenIV.linux.org.uk>
References: <cover.1399554584.git.d.kasatkin@samsung.com>
	 <29977.1399605003@jrobl> <20140509175602.GA18016@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050918-6688-0000-0000-000001B38AD8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 18:56 +0100, Al Viro wrote: 
> On Fri, May 09, 2014 at 12:10:03PM +0900, J. R. Okajima wrote:
> > 
> > Dmitry Kasatkin:
> > > Following patch replaces IMA usage of kernel_read() with special
> > > version which skips security check that triggers kernel panic
> > > when Apparmor and IMA appraisal are enabled together.
> > 
> > I know this is related to exit(2), but this behaviour of IMA is related
> > to open(2) too.
> > When O_DIRECT is specified, some filesystems (for example, ext2) call
> > do_blockdev_direct_IO() which acquires i_mutex. But
> > IMA:process_measurement() already acquires i_mutex before kernel_read().
> > It causes a deadlock even if you replace kernel_read() by a simpler one.
> > How can we stop reading the file from IMA?
> 
> Disabling it would be a good start...  And no, I'm not kidding - the mess
> you are proposing is such that it's not at all obvious that this stuff
> is worth the trouble.

Al, perhaps we didn't do a good job describing the different use case
scenarios for the different aspects of the integrity subsystem.  Are you
interested in hearing about them?

> Why the devil is it playing with ->i_mutex?  IMA, that is.  Its use for
> data is absolutely fs-dependent.  Again, filesystem is *NOT* required
> to take ->i_mutex anywhere on the write path.  At all.

Agreed it shouldn't be taking the i_mutex.  However, there was a lock
ordering issue when writing extended attributes, which does take the
i_mutex.

Mimi

