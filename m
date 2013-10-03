Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3JCUlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:41:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43888 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3JCUln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:41:43 -0400
Date: Thu, 3 Oct 2013 21:41:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
Message-ID: <20131003204142.GL13318@ZenIV.linux.org.uk>
References: <E1VRcGm-0008Er-EO@ZenIV.linux.org.uk>
 <CA+55aFzeDP6J4ekdn4-85yoXzX3xmEp_qc3npvqepJM+MFn=6Q@mail.gmail.com>
 <20131003105130.GE13318@ZenIV.linux.org.uk>
 <CA+55aFzh+n_2fs=aWcT_5gnLC_pWSHqQPJeQ+fg=+Xw7ib9=dQ@mail.gmail.com>
 <20131003174439.GG13318@ZenIV.linux.org.uk>
 <CA+55aFy5kA7ubyetouWsB0OnB5mMRAoyQ-4kbQsCVWARFaf9MA@mail.gmail.com>
 <20131003194351.GK13318@ZenIV.linux.org.uk>
 <CA+55aFw-Yp7xEG3cnU1hcVXAHNGkCoomm0NsUt_Adf=mrauSHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw-Yp7xEG3cnU1hcVXAHNGkCoomm0NsUt_Adf=mrauSHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 01:19:16PM -0700, Linus Torvalds wrote:

> Hmm. The CPU2 mntput can only happen under RCU readlock, right? After
> the RCU grace period _and_ if the umount is going ahead, nothing
> should have a mnt pointer, right?

umount -l doesn't care.

> So I'm wondering if you couldn't just have a synchronize_rcu() in that
> umount path, after clearing mnt_ns. At that point you _know_ you're
> the only one that should have access to the mnt.

We have it there.  See namespace_unlock().  And you are right about the
locking rules for umount_tree(), except that caller is responsible
for dropping those.  With (potentially final) mntput() happening after
both (well, as part of namespace_unlock(), done after synchronize_rcu()).

The problem is this:
A = 1, B = 1
CPU1:
A = 0
<full barrier>
synchronize_rcu()
read B

CPU2:
rcu_read_lock()
B = 0
read A

Are we guaranteed that we won't get both of them seeing ones, in situation
when that rcu_read_lock() comes too late to be noticed by synchronize_rcu()?
