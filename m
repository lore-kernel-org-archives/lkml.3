Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaFZVhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 17:37:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaFZVhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 17:37:05 -0400
Date: Thu, 26 Jun 2014 14:37:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastien Buisson <sebastien.buisson@bull.net>
Cc: <rob@landley.net>, <viro@zeniv.linux.org.uk>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Allow increasing the buffer-head per-CPU LRU size
Message-Id: <20140626143703.e3db0974db994fd16cd8c317@linux-foundation.org>
In-Reply-To: <53AC078C.4090005@bull.net>
References: <53A99EA0.3010800@bull.net>
	<20140625151638.00b7c2aa29f79f63dce7ae56@linux-foundation.org>
	<53AC078C.4090005@bull.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 13:44:12 +0200 Sebastien Buisson <sebastien.buisson@bull.net> wrote:

> 
> Le 26/06/2014 00:16, Andrew Morton a __crit :
> > On Tue, 24 Jun 2014 17:52:00 +0200 Sebastien Buisson <sebastien.buisson@bull.net> wrote:
> >
> >> Allow increasing the buffer-head per-CPU LRU size to allow efficient
> >> filesystem operations that access many blocks for each transaction.
> >> For example, creating a file in a large ext4 directory with quota
> >> enabled will accesses multiple buffer heads and will overflow the LRU
> >> at the default 8-block LRU size:
> >>
> >> * parent directory inode table block (ctime, nlinks for subdirs)
> >> * new inode bitmap
> >> * inode table block
> >> * 2 quota blocks
> >> * directory leaf block (not reused, but pollutes one cache entry)
> >> * 2 levels htree blocks (only one is reused, other pollutes cache)
> >> * 2 levels indirect/index blocks (only one is reused)
> >>
> >> Make this tuning be a kernel parameter 'bh_lru_size'.
> >
> > I don't think it's a great idea to make this a boot-time tunable.  It's
> > going to take a ton of work by each and every kernel
> > user/installer/distributor to work out what is the best setting for
> > them.  And the differences will be pretty small anyway.  And we didn't
> > provide them with any documentation to help them even get started with
> > the project.
> >
> 
> I am sorry, I meant to leave the default bh_lru_size as is, ie set to 8 
> (instead of 16 in my proposed patch). That way, kernel users and 
> integrators of all kind would not have to bother about the new boot-time 
> tunable, and could change nothing and stay with the same value as they 
> did before.
> 
> At the same time, advanced users like those playing with Lustre would 
> have the ability to tune the buffer-head per-CPU LRU size without the 
> need to recompile the kernel.
> 
> Does it sound better?

Mutter.  Maybe.  But is there any downside to increasing BH_LRU_SIZE to
8?  Or, more accurately, does that downside outweight the upside?

That "8" was pulled out of a hat 12 years ago and I don't think anyone
has before done any serious investigation into tuning it.  Maybe 16 is
just a better setting?
