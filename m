Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaBOWvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 17:51:17 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:47210 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaBOWvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 17:51:15 -0500
MIME-Version: 1.0
In-Reply-To: <87bny8kqik.fsf_-_@xmission.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com>
	<87ob28kqks.fsf_-_@xmission.com>
	<87bny8kqik.fsf_-_@xmission.com>
Date: Sat, 15 Feb 2014 14:51:14 -0800
X-Google-Sender-Auth: W9loE_-WFT2tvgl6GGbqhpu8LmQ
Message-ID: <CA+55aFz6feRh9+U7OY6C4CfNe68CqQZARCf_J9deJdsUUG_ryg@mail.gmail.com>
Subject: Re: [PATCH 02/11] vfs: More precise tests in d_invalidate
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 1:36 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> The one difference between d_invalidate and check_submounts_and_drop
> is that d_invalidate must respect it when a d_revalidate method has
> earlier called d_drop so preserve the d_unhashed check in
> d_invalidate.

What?

There's another *huge* difference, namely locking. Your change has
huge detrimental effects wrt d_lock - not only do you drop it for the
local dentry (to then re-take it in check_submounts_and_drop()), but
the whole check_submounts_and_drop thing walks the parent chain and
locks each parent with the renamelock held for writing.

So NAK on this patch, if for no other reason that you are not talking
about the *huge* locking changes at all, and apparently completely
ignored them.

It's possible that you can argue that performance doesn't matter, and
that all the extra huge locking overhead is immaterial because this is
not commonly called, but no way in hell can I accept a patch with a
commit message that basically lies by omission about what it is doing.

This kills the whole series for me. I'm not going to bother trying to
review the rest of the patches when the second patch already makes me
go "Eric is trying to hide things". Because the locking changes aren't
obvious in the patch without knowing what else is going on, and they
certainly aren't mentioned in the commit message.

                Linus
