Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaBCVb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:31:27 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:55979 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbaBCVbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:31:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140203211955.GY10323@ZenIV.linux.org.uk>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
	<1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
	<CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
	<20140130075421.GA10050@infradead.org>
	<CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
	<20140203102943.GF11829@infradead.org>
	<CA+55aFytvTPdBsv6BwSomUGWXZ_tKP=BxaeJ7FXBft0JNnjBCQ@mail.gmail.com>
	<20140203211955.GY10323@ZenIV.linux.org.uk>
Date: Mon, 3 Feb 2014 13:31:19 -0800
X-Google-Sender-Auth: x0q4-TlgLv2-JvuI8_ntQ0WZgog
Message-ID: <CA+55aFyfPVgGXn_hSBnnVyzWn4AbZQ40MPk_AoKB_6uC6LJqPg@mail.gmail.com>
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

On Mon, Feb 3, 2014 at 1:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Please, don't do that.  Half of that is pointless (e.g. what you are
> doing with vfs_rmdir() - if anything, we could get rid of the first
> argument completely, it's always victim->d_parent->d_inode and we are
> holding enough locks for that to be stable) and ->permission() is
> just plain wrong.
>
> Result *is* a function of inode alone; the problem with 9P is that we
> are caching FIDs in the wrong place.

No, Al. It's *not* just a function of the inode alone. That's the point.

Some network filesystems pass the *path* to the server. Any operation
that needs to check something on the server needs the *dentry*, not
the inode.

This whole "the inode describes the file" mentality comes from old
broken UNIX semantics. It's fundamentally true for local Unix
filesystems, but that's it. It's not true in general.

Sure, many network filesystems then emulate the local Unix filesystem
behavior, so in practice, you get the unix semantics quite often. But
it really is wrong.

If the protocol is path-based (and it happens, and it's actually the
*correct* thing to do for a network filesystem, rather than the
idiotic "file handle" crap that tries to emulate the unix inode
semantics in the protocol), then the inode is simply not sufficient.

And no, d_find_alias() is not correct or sufficient either. It can
work in practice (and probably does perfectly fine 99.9% of the time),
but it can equally well give the *wrong* dentry: yes, the dentry it
returns would have been a valid dentry for somebody at some time, but
it might be a stale dentry *now*, and it might be the wrong dentry for
the current user (because the current user may not have permissions to
that particular path, even if the user has permissions through his
*own* path).

So I really think you're *fundamentally* incorrect when you say
"result *is* a function of inode alone".

                  Linus
