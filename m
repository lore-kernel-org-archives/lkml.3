Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab3CLB1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 21:27:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab3CLB1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 21:27:07 -0400
Date: Mon, 11 Mar 2013 21:27:02 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: pipe_release oops.
Message-ID: <20130312012702.GA7424@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
 <20130307213819.GB19543@redhat.com>
 <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
 <20130307220333.GA31039@redhat.com>
 <20130307223610.GA2494@redhat.com>
 <CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
 <20130308145306.GA24085@redhat.com>
 <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 10:30:01AM -0800, Linus Torvalds wrote:
 > On Fri, Mar 8, 2013 at 6:53 AM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > Yeah, that does the trick.
 > > I changed your other diff a little to use a goto, which reduces a level of indentation..
 > 
 > Hmm. So I've been trying to figure this out, and I really don't see
 > it. Every single pipe open routine *should* make sure that the inode
 > has an inode->i_pipe field. So if the open() has succeeded and you
 > have a valid file descriptor, the inode->i_pipe thing should be there.
 > 
 > I must be missing something, and I wonder if the thing I'm missing is
 > that with OPEN_PATH we may now have open calls that don't actually
 > have FMODE_READ or FMODE_WRITE set at all.
 > 
 > So suddenly we end up with these pipe openers that don't update the
 > counts, and I could imagine that really confusing us...
 > 
 > So I'm wondering if you could apply this patch, and see if that
 > triggers. In fact, please un-apply the other changes to fs/pipe.c too,
 > to see if it also obviates the need for checking i_pipe for NULL. You
 > should get the new warning (once), but you should not get any oopses..
 > 
 > Anyway, this would explain why the actual read/write paths don't need
 > to check for i_pipe - if FMODE_READ/WRITE aren't set, we'll never get
 > that far. But the release() and the fasync functions do get called
 > even for non-readable and non-writable files...
 

finally managed to trigger this now that all the other stuff got fixed.

WARNING: at fs/pipe.c:867 pipe_rdwr_open+0xb8/0xd0()
Hardware name: GA-MA78GM-S2H
Pid: 23339, comm: trinity-child0 Not tainted 3.9.0-rc2+ #91
Call Trace:
 [<ffffffff81045115>] warn_slowpath_common+0x75/0xa0
 [<ffffffff8104515a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff811c4208>] pipe_rdwr_open+0xb8/0xd0
 [<ffffffff811b9c5b>] do_dentry_open+0x25b/0x300
 [<ffffffff811c4150>] ? pipe_unlock+0x30/0x30
 [<ffffffff811b9d49>] finish_open+0x49/0x60
 [<ffffffff811cb119>] do_last+0x6d9/0xf10
 [<ffffffff8107a722>] ? lg_local_unlock+0x42/0x70
 [<ffffffff811de629>] ? mntput_no_expire+0x49/0x130
 [<ffffffff811de736>] ? mntput+0x26/0x40
 [<ffffffff811c5ca2>] ? path_put+0x22/0x30
 [<ffffffff811cbc93>] path_openat+0x343/0x500
 [<ffffffff811cc101>] do_filp_open+0x41/0xa0
 [<ffffffff811bb0a4>] do_sys_open+0xf4/0x1e0
 [<ffffffff811bb1d4>] sys_openat+0x14/0x20
 [<ffffffff816d08c2>] system_call_fastpath+0x16/0x1b
---[ end trace 8290ea887bf97579 ]---

	Dave

