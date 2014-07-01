Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaGAAMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:12:24 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51353 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaGAAMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:12:23 -0400
Date: Mon, 30 Jun 2014 17:10:54 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm/next] mm: memcontrol: rewrite charge API: fix
 shmem_unuse
In-Reply-To: <20140630160212.46caf9c3d41445b61fece666@linux-foundation.org>
Message-ID: <alpine.LSU.2.11.1406301658430.4898@eggly.anvils>
References: <alpine.LSU.2.11.1406301541420.4349@eggly.anvils> <20140630160212.46caf9c3d41445b61fece666@linux-foundation.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014, Andrew Morton wrote:
> On Mon, 30 Jun 2014 15:48:39 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> > -		return 0;
> > +		return -EAGAIN;
> 
> Maybe it's time to document the shmem_unuse_inode() return values.

Oh dear.  I had hoped they would look after themselves.  This one is a
private matter between shmem_unuse_inode and its one caller, just below.

> > +	if (error) {
> > +		if (error != -ENOMEM)
> > +			error = 0;
> >  		mem_cgroup_cancel_charge(page, memcg);
> >  	} else
> >  		mem_cgroup_commit_charge(page, memcg, true);
> 
> If I'm reading this correctly, shmem_unuse() can now return -EAGAIN and
> that can get all the way back to userspace.  `man 2 swapoff' doesn't
> know this...

if (error) {
	if (error != -ENOMEM)
		error = 0;
...
	return error;

So the only values returned from shmem_unuse_inode() to its caller
try_to_unuse() are 0 and -ENOMEM.  Those may get passed back to the
user, but -EAGAIN was just an internal shmem.c detail.

Hugh
