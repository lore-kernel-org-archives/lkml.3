Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaCCWjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:39:39 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:60984 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaCCWji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:39:38 -0500
Date: Mon, 3 Mar 2014 17:39:33 -0500
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs: possible deadlock between of->mutex and mmap_sem
Message-ID: <20140303223933.GC26523@mtj.dyndns.org>
References: <53113485.2090407@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53113485.2090407@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 08:14:45PM -0500, Sasha Levin wrote:
> Hi all,
> 
> I've stumbled on the following while fuzzing with trinity inside a
> KVM tools running the latest -next kernel.
> 
> We deal with files that have an mmap op by giving them a different
> locking class than the files which don't due to mmap_sem nesting
> being different for those files.
> 
> We assume that for mmap supporting files, of->mutex will be nested
> inside mm->mmap_sem. However, this is not always the case. Consider
> the following:
> 
> 	kernfs_fop_write()
> 		copy_from_user()
> 			might_fault()
> 
> might_fault() suggests that we may lock mm->mmap_sem, which causes a
> reverse lock nesting of mm->mmap_sem inside of of->mutex.
> 
> I'll send a patch to fix it some time next week unless someone beats me to it :)

How are you planning to fix it?  Prolly the right thing to do would be
caching atomic_write_len in open_file and copy data before grabbing
any locks.

Thanks.

-- 
tejun
