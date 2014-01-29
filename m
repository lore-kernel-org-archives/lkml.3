Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbaA2D0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 22:26:47 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:43794 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbaA2D0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 22:26:09 -0500
MIME-Version: 1.0
In-Reply-To: <20140127142520.GD10323@ZenIV.linux.org.uk>
References: <20140127142520.GD10323@ZenIV.linux.org.uk>
Date: Tue, 28 Jan 2014 19:26:08 -0800
X-Google-Sender-Auth: jHz_jq2Fm0LbvCN66i6GIGFxIR8
Message-ID: <CA+55aFyuC11WPBh0bWu_K3+CooAVAUbSTfk2aw5sks8eJRAhDQ@mail.gmail.com>
Subject: Re: [git pull] vfs pile 1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 6:25 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>         Assorted stuff; the biggest pile here is Christoph's ACL series.
> Plus assorted cleanups and fixes all over the place...  There will be
> another pile later this week.

The posix_acl_chmod() code looks wrong.

Not that it looked right before either, but whatever. The code
basically looks like some variation of this in most setattr()
implementations:

        if (ia_valid & ATTR_MODE)
                rc = posix_acl_chmod(inode, inode->i_mode);

but the mode we're changing to (and what ATTR_MODE guards) is actually
attr->ia_mode, not inode->i_mode. And quite frankly, passing in
inode->i_mode looks stupid, since we're already passing in the inode
pointer, so that's just redundant and pointless information.

Anyway, I noticed this after doing the (untested, and still un-acked -
hint, hint) ceph conversion. In that, I made ceph use attr->ia_mode.
Maybe that was wrong, but at least it's not insane and stupid like the
other filesystem implementations are.

Comments?

              Linus
