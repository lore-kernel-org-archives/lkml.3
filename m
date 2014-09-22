Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbaIVO01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:26:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47808 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbaIVOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:25:22 -0400
Date: Mon, 22 Sep 2014 07:25:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Milosz Tanski <milosz@adfin.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v2 0/5] Non-blockling buffered fs read (page cache only)
Message-ID: <20140922142519.GA27920@infradead.org>
References: <cover.1410810247.git.milosz@adfin.com>
 <cover.1410983998.git.milosz@adfin.com>
 <20140919104204.3b0bb762@lwn.net>
 <CANP1eJEhHyA93kDUCz_=0vDjdPXz7g0x1SmW+q060fntQAbrYA@mail.gmail.com>
 <20140922101221.4bf46809@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922101221.4bf46809@lwn.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 10:12:21AM -0400, Jonathan Corbet wrote:
> So I'm not contesting this, but I am genuinely curious: do you think
> there are applications out there requesting non-blocking behavior on
> regular files that will then break if they actually get non-blocking
> behavior?  I don't suppose you have an example?

You only have to look as far as Samba, but Jeff quoted an old lkml
post earlier that had other examples.

source3/smbd/open.c:


	if (first_open_attempt && lp_kernel_oplocks(SNUM(conn))) {
		/*
		 * With kernel oplocks the open breaking an oplock
		 * blocks until the oplock holder has given up the
		 * oplock or closed the file. We prevent this by first
		 * trying to open the file with O_NONBLOCK (see "man
		 * fcntl" on Linux). For the second try, triggered by
		 * an oplock break response, we do not need this
		 * anymore.
		 *
		 * This is true under the assumption that only Samba
		 * requests kernel oplocks. Once someone else like
		 * NFSv4 starts to use that API, we will have to
		 * modify this by communicating with the NFSv4 server.
		 */
		flags2 |= O_NONBLOCK;
	}
