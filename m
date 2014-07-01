Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbaGAAeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:34:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950AbaGAAet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:34:49 -0400
Date: Mon, 30 Jun 2014 17:34:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm/next] mm: memcontrol: rewrite charge API: fix
 shmem_unuse
Message-Id: <20140630173428.5ebeed18.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.11.1406301658430.4898@eggly.anvils>
References: <alpine.LSU.2.11.1406301541420.4349@eggly.anvils>
	<20140630160212.46caf9c3d41445b61fece666@linux-foundation.org>
	<alpine.LSU.2.11.1406301658430.4898@eggly.anvils>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 17:10:54 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> On Mon, 30 Jun 2014, Andrew Morton wrote:
> > On Mon, 30 Jun 2014 15:48:39 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> > > -		return 0;
> > > +		return -EAGAIN;
> > 
> > Maybe it's time to document the shmem_unuse_inode() return values.
> 
> Oh dear.  I had hoped they would look after themselves.  This one is a
> private matter between shmem_unuse_inode and its one caller, just below.

Well, readers of shmem_unuse_inode() won't know that unless we tell them.


> > > +	if (error) {
> > > +		if (error != -ENOMEM)
> > > +			error = 0;
> > >  		mem_cgroup_cancel_charge(page, memcg);
> > >  	} else
> > >  		mem_cgroup_commit_charge(page, memcg, true);
> > 
> > If I'm reading this correctly, shmem_unuse() can now return -EAGAIN and
> > that can get all the way back to userspace.  `man 2 swapoff' doesn't
> > know this...
> 
> if (error) {
> 	if (error != -ENOMEM)
> 		error = 0;
> ...
> 	return error;
> 
> So the only values returned from shmem_unuse_inode() to its caller
> try_to_unuse() are 0 and -ENOMEM.  Those may get passed back to the
> user, but -EAGAIN was just an internal shmem.c detail.

OK.
