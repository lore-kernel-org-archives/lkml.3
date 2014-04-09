Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179AbaDIS2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:28:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58054 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbaDIS2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:28:37 -0400
Date: Wed, 9 Apr 2014 19:28:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [GIT PULL] Detaching mounts on unlink for 3.15-rc1
Message-ID: <20140409182830.GA18016@ZenIV.linux.org.uk>
References: <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87ob28kqks.fsf_-_@xmission.com>
 <874n3n7czm.fsf_-_@xmission.com>
 <87wqezl5df.fsf_-_@x220.int.ebiederm.org>
 <20140409023027.GX18016@ZenIV.linux.org.uk>
 <20140409023947.GY18016@ZenIV.linux.org.uk>
 <87sipmbe8x.fsf@x220.int.ebiederm.org>
 <20140409175322.GZ18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409175322.GZ18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 06:53:23PM +0100, Al Viro wrote:

> For starters, put that ext4 on top of dm-raid or dm-multipath.  That alone
> will very likely push you over the top.
> 
> Keep in mind, BTW, that you do not have full 8K to play with - there's
> struct thread_info that should not be stepped upon.  Not particulary large
> (IIRC, restart_block is the largest piece in amd64 one), but it eats about
> 100 bytes.
> 
> I'd probably use renameat(2) in testing - i.e. trigger the shite when
> resolving a deeply nested symlink in renameat() arguments.  That brings
> extra struct nameidata into the game, i.e. extra 152 bytes chewed off the
> stack.

Come to think of that, some extra nastiness could be had by mixing it with
execve().  You can have up to 4 levels of #! resolution there, each eating
up at least 128 bytes (more, actually).  Compiler _might_ turn that
tail call of search_binary_handler() into a jump, but it's not guaranteed
at all.

FWIW, it probably makes sense to turn load_script() into
static int load_script(struct linux_binprm *bprm)
{
	int err = __load_script(bprm);
	if (err)
		return err;
	return search_binary_handler(bprm);
}

regardless of that issue; we don't need interp[] after the call of
open_exec(), so it makes sense to reduce the footprint in mutual
recursion loop.

For extra pain, consider s/ext4/xfs/, possibly with iscsi thrown under the
bus^Wdm-multipath.

The thing is, we are already too close to stack overflow limit.  Adding
several kilobytes more is not survivable, and since you are taking
somebody in a userns DoSing the system into consideration, you can't
say "it takes malicious root to set up, so it's not serious" - the
DoS you mentioned requires the same thing...

BTW, another thing to test would be this:
	mount nfs on /mnt
	mount a filesystem on /mnt/path that can be invalidated
	cd to /mnt/path/foo
	bind /mnt on /mnt/path/foo/bar
	shoot /mnt/path (on server)
	stat bar/path/foo
That should rip the fs you are in out of the tree; it should work, but
it's definitely a case worth testing.
