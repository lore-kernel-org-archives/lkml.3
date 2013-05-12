Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab3ELVrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 17:47:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41671 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3ELVrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 17:47:22 -0400
Date: Sun, 12 May 2013 22:47:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] next cycle fun: ->release() API change
Message-ID: <20130512214720.GA8202@ZenIV.linux.org.uk>
References: <20130509050343.GD25399@ZenIV.linux.org.uk>
 <CA+55aFzNuEx8705x3NckigLdRMrEWehyEmgLcJ3kF=BPDZo+Bg@mail.gmail.com>
 <20130511172242.GP25399@ZenIV.linux.org.uk>
 <CA+55aFzsgr6ZHWxNRvM3VZu=bWn75TfGb0EAXO1wdFnBFTCz-Q@mail.gmail.com>
 <20130511210641.GQ25399@ZenIV.linux.org.uk>
 <CA+55aFy8Y9w0OBHLTqHxjLLXZXOSf+d5YJ-huNaMOs3V5DycCA@mail.gmail.com>
 <20130512000616.GR25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130512000616.GR25399@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 01:06:16AM +0100, Al Viro wrote:
> media_file_operations
> v4l2_file_operations
> snd_hwdep_ops
> sound_info_entry_ops
> proto_ops
> auth_ops

> BTW, a lot of those guys are returning void, but there are some that return
> int and I think we ought to review those as well.  And that's probably
> worth doing *before* we start merging file_operations ->release() change,
> whether it's just int->void variant or anything more ambitious.

Having looked through some of those:
	* cftype->release() is non-NULL only in two instances *and* the
only caller of that method is never called for those instances.  WTF does
it exist, in the first place?  NB: the set of cftype methods is unspeakably
ugly; check it and puke.
	* hsi_port->release(): AFAICS, return value is ignored by the sole
caller.  No non-trivial instances in the tree (again, AFAICS) - the only one
is "do nothing and return 0".
	* loop_func_table->release(): return value is ignored by most of that
callers; the only in-tree instance returns non-zero only if it sees an obvious
result of memory corruption.
	* posix_clock_operations->release(): NULL in the only in-tree instance
of struct posix_clock_operations.  The only caller is posix_clock_release()
and return value is passed to its caller, which drops it on the floor.
	* uio_info->release(): AFAICS, there are only 3 instances in the
tree.  All are always returning 0; incidentally, none of them ever looks
at the second argument of that method (it's int (*release)(struct uio_info *,
struct inode *)).  The only caller is uio_release(), which passes the
return value to its caller, which drops it on the floor.
