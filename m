Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3CSLkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:40:22 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:50633 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3CSLkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:40:20 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <28283.1363691050@warthog.procyon.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
	<1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<1944.1363525619@warthog.procyon.org.uk>
	<20130318153936.GB28508@quack.suse.cz>
	<20130318215333.GE21522@ZenIV.linux.org.uk>
	<20130318230103.GF21522@ZenIV.linux.org.uk>
	<20130319013805.GG21522@ZenIV.linux.org.uk>
	<CAJfpegt8Zi3f5VxWc0kGRFcra3x_rze8j6dKCCTb4t+ViMCVYA@mail.gmail.com>
	<28283.1363691050@warthog.procyon.org.uk>
Date: Tue, 19 Mar 2013 12:40:18 +0100
Message-ID: <CAJfpegvqosGZZkbd=JbtYFWxHe_QugvFO8k+jpdYbKh92SUuDQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 12:04 PM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> > BTW, I wonder what's the right locking for that sucker; overlayfs is
>> > probably too heavy - we are talking about copying a file from one fs to
>> > another, which can obviously take quite a while, so holding ->i_mutex on
>> > _parent_ all along is asking for very serious contention.
>>
>> Copy up is a once-in-a-lifetime event for an object.  Optimizing it is
>> way down in the list of things to do.  I'd drop splice in a jiffy if
>> it's in the way.
>
> Yes, but it could block the parent directory for a long time.  I suspect it's
> fine if you can RCU walk through the parent, but if you have to grab a lock on
> it...

Right.

Lets look at it this way:  users of an overlay accept that an
operation X can take T time, where T is much longer than would be on a
normal filesystem.  Then why would they complain that operation Y
(which happens to bump into the parent lock of X) also takes T?

If copy up of huge files happens more then very very occasionally,
then the overlay will be basically unusable anyway.  It's just not
what it is designed for, so why try to optimize this case?

Thanks,
Miklos
