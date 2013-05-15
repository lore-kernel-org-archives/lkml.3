Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab3EOMYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:24:19 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:48596 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab3EOMYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:24:18 -0400
Date: Wed, 15 May 2013 08:24:06 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: EUNBONG SONG <eunb.song@samsung.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jack@suse.cz, dmonakhov@openvz.org, gnehzuil.liu@gmail.com
Subject: Re: Question about ext4 excessive stall time
Message-ID: <20130515122406.GA25730@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	EUNBONG SONG <eunb.song@samsung.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	jack@suse.cz, dmonakhov@openvz.org, gnehzuil.liu@gmail.com
References: <26998592.95551368602101253.JavaMail.weblogic@epml08>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26998592.95551368602101253.JavaMail.weblogic@epml08>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 07:15:02AM +0000, EUNBONG SONG wrote:
> I know my kernel version is so old. I just want to know why this
> problem is happened.  Because of my kernel version is old? or
> Because of disk ?,, If anyone knows about this problem, Could you
> help me?

So what's happening is this.  The CFQ I/O scheduler prioritizes reads
over writes, since most reads are synchronous (for example, if the
compiler is waiting for the data block from include/unistd.h, it cant
make forward progress until it receives the data blocks; there is an
exception for readahead blocks, but those are dealt with at a low
priority), and most writes are synchronous (since they are issued by
the writeback daemons, and unless we are doing an fsync, no one is
waiting for them).

The problem comes when a metadata block, usually one which is shared
across multiple files is undergoing writeback, such as an inode table
block or a allocation bitmap block.  The write gets issued as a low
priority I/O operation.  Then during the the next jbd2 transaction,
some userspace operation needs to modify that metadata block, and in
order to do that, it has to call jbd2_journal_get_write_access().  But
if there is heavy read traffic going on, due to some other process
using the disk a lot, the writeback operation may end up getting
starved, and doesn't get acted on for a very long time.

But the moment a process called jbd2_journal_get_write_access(), the
write has effectively become one which is synchronous, in that forward
progress of at least one process is now getting blocked waiting for
this I/O to complete, since the buffer_head is locked for writeback,
possibly for hundreds or thousands of milliseconds, and
jbd2_journal_get_write_access() can not proceed until it can get the
buffer_head lock.

This was discussed at least month's Linux Storage, File System, and MM
worksthop.  The right solution is to for lock_buffer() to notice if
the buffer head has been locked for writeback, and if so, to bump the
write request to the head of the elevator.  Jeff Moyer is looking at
this.

The partial workaround which will be in 3.10 is that we're marking all
metadata writes with REQ_META and REQ_PRIO.  This will cause metadata
writebacks to be prioritized at the same priority level as synchrnous
reads.  If there is heavy read traffic, the metadata writebacks will
still be in competition with the reads, but at least they will
complete.

Once we get priority escalation (or priority inheritance, because what
we're seeing here is really a classic priority inversion problem),
then it would make sense for us to no longer set REQ_PRIO for metadata
writebacks, so the metadata writebacks only get prioritized when they
are blocking some process from making forward progress.  (Doing this
will probably result in a slight performance degradation on some
workloads, but it will improve others with a heavy read traffic and
minimal writeback interference.  We'll want to benchmark what
percentage of metadata writebacks require getting bumped to the head
of the line, but I suspect it will be the right choice.)

If you want to try to backport this workaround to your older kernel,
please see commit 9f203507ed277.

Regards,

					- Ted
