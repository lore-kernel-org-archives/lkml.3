Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbaIDIFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 04:05:40 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:37548 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbaIDIFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 04:05:33 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20140903193058.2bc891a7.akpm@linux-foundation.org>
Date: Thu, 4 Sep 2014 09:05:23 +0100
Cc: Junxiao Bi <junxiao.bi@oracle.com>, david@fromorbit.com,
        xuejiufei@huawei.com, ming.lei@canonical.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <540555BE-7985-4468-BC03-45CDA7E2EB83@cam.ac.uk>
References: <1409723694-16047-1-git-send-email-junxiao.bi@oracle.com> <20140903161000.f383fa4c1a4086de054cb6a0@linux-foundation.org> <5407C989.50605@oracle.com> <20140903193058.2bc891a7.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 Sep 2014, at 03:30, Andrew Morton <akpm@linux-foundation.org> wrote:
> __GFP_FS and __GFP_IO are (or were) for communicating to vmscan: don't
> enter the fs for writepage, don't write back swapcache.
> 
> I guess those concepts have grown over time without a ton of thought
> going into it.  Yes, I suppose that if a filesystem's writepage is
> called (for example) it expects that it will be able to perform
> writeback and it won't check (or even be passed) the __GFP_IO setting.
> 
> So I guess we could say that !__GFP_FS && GFP_IO is not implemented and
> shouldn't occur.
> 
> That being said, it still seems quite bad to disable VFS cache
> shrinking for PF_MEMALLOC_NOIO allocation attempts.

I think what it really boils down to is that file systems cannot allow recursion into _that_ file system so if VFS/VM shrinking could skip over all inodes/dentries/pages that are associated with the superblock of the volume for which the allocation is being done then that would be just fine.

An alternative would be that the file systems would need to be passed in a flag that will tell them that it is not safe to take locks and then file systems that need to take a lock could return with -EDEADLOCK and the VM can then skip over those entries and reclaim others.  Though I think it would be more efficient for the VFS/VM to simply not call into the file system that is doing the allocation as above...

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

