Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3CUUbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:31:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab3CUUbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:31:04 -0400
Date: Thu, 21 Mar 2013 16:31:01 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: VFS deadlock ?
Message-ID: <20130321203101.GB16406@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20130321190653.GA15479@redhat.com>
 <20130321192146.GX21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321192146.GX21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 07:21:46PM +0000, Al Viro wrote:
 > On Thu, Mar 21, 2013 at 03:06:53PM -0400, Dave Jones wrote:
 > > Al, Linus,
 > 
 > > trinity-child2  D ffff880110b3a7e0  5448  7669      1 0x00000004
 > [sits in rename(), trying to grab ->i_mutex on a parent]
 > 
 > > Showing all locks held in the system:
 > > 4 locks on stack by trinity-child2/7669:
 > >  #0: blocked:  (sb_writers#4){.+.+.+}, instance: ffff8801292d17d8, at: [<ffffffff811df134>] mnt_want_write+0x24/0x50
 > >  #1: held:     (&type->s_vfs_rename_key){+.+.+.}, instance: ffff8801292d1928, at: [<ffffffff811c6f5e>] lock_rename+0x3e/0x120
 > >  #2: held:     (&type->i_mutex_dir_key#2/1){+.+.+.}, instance: ffff880110b3a858, at: [<ffffffff811c701e>] lock_rename+0xfe/0x120
 > >  #3: blocked:  (&type->i_mutex_dir_key#2/2){+.+.+.}, instance: ffff880110b3a858, at: [<ffffffff811c7034>] lock_rename+0x114/0x120
 > 
 > Wait a minute...  How the hell does it manage to sit with *two* blocked locks?
 > Confused...

Same thing happened when I ran into this yesterday..
(bit more confusing, as there were more parallel runs going on, but similar patterns..)


Showing all locks held in the system:
1 lock on stack by trinity-main/784:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff88010c1717c0, at: [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
2 locks on stack by trinity-child3/6674:
 #0: blocked:  (sb_writers#5){.+.+.+}, instance: ffff8801292d17d8, at: [<ffffffff811df134>] mnt_want_write+0x24/0x50
 #1: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff88010c1717c0, at: [<ffffffff811ba1d9>] chmod_common+0x49/0xa0
1 lock on stack by trinity-child3/9678:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff88010c1717c0, at: [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
1 lock on stack by trinity-child0/9845:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff88010c1717c0, at: [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
2 locks on stack by trinity-child1/10147:
 #0: blocked:  (sb_writers#5){.+.+.+}, instance: ffff8801292d17d8, at: [<ffffffff811df134>] mnt_want_write+0x24/0x50
 #1: blocked:  (&type->i_mutex_dir_key#2/1){+.+.+.}, instance: ffff88010c1717c0, at: [<ffffffff811c9ffd>] kern_path_create+0xad/0x190
1 lock on stack by trinity-child2/10793:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff88010c1717c0, at: [<ffffffff811cb5da>] do_last+0x33a/0xf20
1 lock on stack by trinity-child1/11549:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff88010c1717c0, at: [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
4 locks on stack by trinity-child0/11592:
 #0: blocked:  (sb_writers#5){.+.+.+}, instance: ffff8801292d17d8, at: [<ffffffff811df134>] mnt_want_write+0x24/0x50
 #1: held:     (&type->s_vfs_rename_key){+.+.+.}, instance: ffff8801292d1928, at: [<ffffffff811c6f5e>] lock_rename+0x3e/0x120
 #2: held:     (&type->i_mutex_dir_key#2/1){+.+.+.}, instance: ffff88010c1717c0, at: [<ffffffff811c701e>] lock_rename+0xfe/0x120
 #3: blocked:  (&type->i_mutex_dir_key#2/2){+.+.+.}, instance: ffff88010c1717c0, at: [<ffffffff811c7034>] lock_rename+0x114/0x120
1 lock on stack by trinity-child0/11645:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff88010c1717c0, at: [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
2 locks on stack by trinity-child3/11740:
 #0: blocked:  (sb_writers#5){.+.+.+}, instance: ffff8801292d17d8, at: [<ffffffff811df134>] mnt_want_write+0x24/0x50
 #1: blocked:  (&type->i_mutex_dir_key#2/1){+.+.+.}, instance: ffff88010c1717c0, at: [<ffffffff811c9ffd>] kern_path_create+0xad/0x190
1 lock on stack by trinity-child2/11953:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff88010c1717c0, at: [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
1 lock on stack by trinity-child2/12018:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff88010c1717c0, at: [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
2 locks on stack by trinity-child1/12312:
 #0: blocked:  (sb_writers#5){.+.+.+}, instance: ffff8801292d17d8, at: [<ffffffff811df134>] mnt_want_write+0x24/0x50
 #1: blocked:  (&type->i_mutex_dir_key#2/1){+.+.+.}, instance: ffff88010c1717c0, at: [<ffffffff811caaa2>] do_unlinkat+0x112/0x230


