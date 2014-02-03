Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaBCWzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:55:31 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:63350 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaBCWz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:55:28 -0500
MIME-Version: 1.0
In-Reply-To: <20140203224034.GF10323@ZenIV.linux.org.uk>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
	<1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
	<CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
	<20140130075421.GA10050@infradead.org>
	<CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
	<20140203102943.GF11829@infradead.org>
	<CA+55aFytvTPdBsv6BwSomUGWXZ_tKP=BxaeJ7FXBft0JNnjBCQ@mail.gmail.com>
	<20140203215908.GD10323@ZenIV.linux.org.uk>
	<CA+55aFz3PyyCqOLs_SBRS3cbGxWd5ez4Svz2+xK+4KtCez8iGw@mail.gmail.com>
	<20140203224034.GF10323@ZenIV.linux.org.uk>
Date: Mon, 3 Feb 2014 14:55:27 -0800
X-Google-Sender-Auth: d0FjnzK1-mmQzccrwDCJ3pbQo3U
Message-ID: <CA+55aFzQJ6ZWQAov_e_o+gKg4OBPmSba+xSrSMifSq_Yu8OLEg@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 2:40 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Umm...  Point, but that actually means that we get an extra pitfall for
> filesystem writers here.  foo_permission() passes dentry (now that it
> has one) to foo_wank_a_lot(), with the latter using dentry->d_inode at
> some point...

I agree.

The good news, though, is that in the RCU lookup case, we have that
MAY_NOT_BLOCK thing, and most filesystems will have errored out for
any complex operations.

RCU lookup is special, and complicated, and sadly, the permissions
checking is very much part of that. But for the really complex cases,
at least we can punt.

>> Look at gfs2_lookupi() in particular, and check how it is called.
>
> Yeowch...  gfs2_ok_to_move() is particulary nasty...  WTF do we need
> it for and why is it not racy as hell?

I don't know. And I suspect that for things like the journal index
file lookup (which is actually worse - see gfs2_jindex_hold()) we
don't really about the permissions, since this is just done at
init_journal() time.

So I think all of this is quite solvable for gfs2, it just wasn't the
obvious kind of "we already have the dentry" case that every single
other case I looked at was.

                     Linus
