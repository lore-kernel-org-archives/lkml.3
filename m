Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3CSK3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:29:46 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:41700 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab3CSK3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:29:43 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130319013805.GG21522@ZenIV.linux.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
	<1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<1944.1363525619@warthog.procyon.org.uk>
	<20130318153936.GB28508@quack.suse.cz>
	<20130318215333.GE21522@ZenIV.linux.org.uk>
	<20130318230103.GF21522@ZenIV.linux.org.uk>
	<20130319013805.GG21522@ZenIV.linux.org.uk>
Date: Tue, 19 Mar 2013 11:29:41 +0100
Message-ID: <CAJfpegt8Zi3f5VxWc0kGRFcra3x_rze8j6dKCCTb4t+ViMCVYA@mail.gmail.com>
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 2:38 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Mar 18, 2013 at 11:01:03PM +0000, Al Viro wrote:
>
>> I'm looking at the existing callers and I really wonder if we ought to
>> push sb_start_write() from ->splice_write()/->aio_write()/etc. into the
>> callers.
>>
>> Something like file_start_write()/file_end_write(), with check for file
>> being regular one might be a good starting point.  As it is, copyup is
>> really fucked both in unionmount and overlayfs...
>
> BTW, I wonder what's the right locking for that sucker; overlayfs is probably
> too heavy - we are talking about copying a file from one fs to another, which
> can obviously take quite a while, so holding ->i_mutex on _parent_ all along
> is asking for very serious contention.

Copy up is a once-in-a-lifetime event for an object.  Optimizing it is
way down in the list of things to do.  I'd drop splice in a jiffy if
it's in the way.

Much more interesting question:  what happens if we crash during a
rename?  Whiteout implemented in the filesystem won't save us.  And
the results are interesting: old versions of files become visible and
similar fun.  Far from likely to happen, but ...

Add a rename-with-whiteout primitive on filesystems?  That one is not
going to be as simple as plain whiteout.  Or?

Thanks,
Miklos
