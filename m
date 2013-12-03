Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3LCSng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:43:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab3LCSnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:43:35 -0500
Date: Tue, 3 Dec 2013 13:43:24 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: tj@kernel.org, gregkh@linuxfoundation.org
Subject: Re: sysfs: use a separate locking class for open files depending on
 mmap
Message-ID: <20131203184324.GA11320@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	tj@kernel.org, gregkh@linuxfoundation.org
References: <20131128051223.45739660885@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128051223.45739660885@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 05:12:23AM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=027a485d12e089314360d459b8d847104dd28702
 > Commit:     027a485d12e089314360d459b8d847104dd28702
 > Parent:     54d71145a4548330313ca664a4a009772fe8b7dd
 > Author:     Tejun Heo <tj@kernel.org>
 > AuthorDate: Sun Nov 17 11:17:36 2013 +0900
 > Committer:  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 > CommitDate: Sat Nov 23 10:52:13 2013 -0800
 > 
 >     sysfs: use a separate locking class for open files depending on mmap
 >     
 >     The following two commits implemented mmap support in the regular file
 >     path and merged bin file support into the regular path.
 > ...
 > -	mutex_init(&of->mutex);
 > +	/*
 > +	 * The following is done to give a different lockdep key to
 > +	 * @of->mutex for files which implement mmap.  This is a rather
 > +	 * crude way to avoid false positive lockdep warning around
 > +	 * mm->mmap_sem - mmap nests @of->mutex under mm->mmap_sem and
 > +	 * reading /sys/block/sda/trace/act_mask grabs sr_mutex, under
 > +	 * which mm->mmap_sem nests, while holding @of->mutex.  As each
 > +	 * open file has a separate mutex, it's okay as long as those don't
 > +	 * happen on the same file.  At this point, we can't easily give
 > +	 * each file a separate locking class.  Let's differentiate on
 > +	 * whether the file has mmap or not for now.
 > +	 */
 > +	if (has_mmap)
 > +		mutex_init(&of->mutex);
 > +	else
 > +		mutex_init(&of->mutex);
 > +
 
Somehow I just triggered this trace again, even with this commit applied.
The trace is pretty much identical to the old one.

	Dave

