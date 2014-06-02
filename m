Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbaFBPDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:03:13 -0400
Received: from imap.thunk.org ([74.207.234.97]:45652 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432AbaFBPDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:03:09 -0400
Date: Mon, 2 Jun 2014 11:02:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>,
        "'Dave Chinner'" <david@fromorbit.com>,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
Subject: Re: [PATCH v2 0/10] fs: Introduce FALLOC_FL_INSERT_RANGE for
 fallocate
Message-ID: <20140602150258.GG30598@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	'Dave Chinner' <david@fromorbit.com>,
	'linux-ext4' <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	'Ashish Sangwan' <a.sangwan@samsung.com>
References: <003601cf6aa7$883103b0$98930b10$@samsung.com>
 <alpine.LFD.2.00.1405301238190.2009@localhost.localdomain>
 <000d01cf7ca3$98335c50$c89a14f0$@samsung.com>
 <alpine.LFD.2.00.1406021204540.2231@localhost.localdomain>
 <002201cf7e59$2e684c10$8b38e430$@samsung.com>
 <alpine.LFD.2.00.1406021450541.2231@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1406021450541.2231@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 03:06:13PM +0200, Lukáš Czerner wrote:
> > > So what will happen when there is not enough space when "inserting a
> > > range" ? And how should user proceed from there ?
> > If insert range fails with an ENOSPC error, user could use collapse
> > range on the same range to remove the hole.
> > And after freeing more space, he can again try inserting range.
> > Ofcourse, this type of guidance should be properly documented in
> > manpage. When updating fallocate(2) manpage, I will keep  in mind to
> > describe ENOSPC handling.
> 
> Why collapse ? The hole is already there right ? Why not just use
> fallocate to allocate the space for the hole. And that's my point
> actually. Why not do it this way in the first place, because this is
> really counterintuitive.

It's worse than that.  It's possible that the reason why you got the
ENOSPC warning was because the operation to move the extents down
required allocating a block, and it was *that* block allocation which
failed.  So it's not deterministic whether or not the file's extent
mappings were modified after a ENOSPC error, and so it's not clear
whether or not a collapse_range function will undo the range that had
been inserted --- or whether it ends up deleting existing data blocks.

In generally, you really want system calls to have all-or-nothing
effects, where if the system call returns an error, the state of the
file has not been changed.  And for that reason, I agree with Lukáš
that it is really a good idea to decouple moving the blocks down, and
allocating space --- and to make sure that if there is any failure
while inserting the range, the state of the file is not modified at all.

Cheers,

					- Ted
