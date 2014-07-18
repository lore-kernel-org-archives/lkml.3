Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbaGRKiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:38:21 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:46484 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761352AbaGRKiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:38:17 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Brian Foster'" <bfoster@redhat.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>, xfs@oss.sgi.com,
        "=?utf-8?B?J0x1a8OhxaE=?= Czerner'" <lczerner@redhat.com>
Subject: RE: [PATCH 3/3] ext4: Add support IOC_MOV_DATA ioctl
In-Reply-To: <002901cfa265$636d2e50$2a478af0$@samsung.com>
References: <004001cf9aa4$2670e280$7352a780$@samsung.com> <alpine.LFD.2.00.1407081558280.2180@localhost.localdomain> <87tx6ktiay.fsf@openvz.org> <002901cfa265$636d2e50$2a478af0$@samsung.com>
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Fri, 18 Jul 2014 14:38:12 +0400
Message-ID: <87zjg7ar57.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014 17:50:55 +0900, Namjae Jeon <namjae.jeon@samsung.com> wrote:
> > On Tue, 8 Jul 2014 16:02:28 +0200 (CEST), Lukáš Czerner <lczerner@redhat.com> wrote:
> > Non-text part: MULTIPART/MIXED
> > > On Tue, 8 Jul 2014, Namjae Jeon wrote:
> > >
> > > > Date: Tue, 08 Jul 2014 21:00:02 +0900
> > > > From: Namjae Jeon <namjae.jeon@samsung.com>
> > > > To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
> > > > Cc: linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
> > > >     linux-kernel@vger.kernel.org, Lukáš Czerner <lczerner@redhat.com>,
> > > >     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@infradead.org>,
> > > >     Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com
> > > > Subject: [PATCH 3/3] ext4: Add support IOC_MOV_DATA ioctl
> > > >
> > > > This patch implements fs ioctl's IOC_MOV_DATA for Ext4.
> > >
> > > Hmm isn't this basically what ext4_move_extents() does ? eg.
> > > EXT4_IOC_MOVE_EXT ?
> > >
> > > I guess that the intention here is to do the move, without actually
> > > moving the data right ? But nevertheless maybe some code can be
> > > shared with ext4_move_extents() ?
> > It definitely can be shared, because it has specific case for unwritten
> > data see move_extent_per_page().
> If I understand correctly, mov_extent_per_page calls mext_replace_branches to
> _replace_ extents from 1 inode to other inode. Please correct me if I
> > > am wrong.
You are right.
> ioc_mov_data will not replace extents, but it will actually _move_ extents into
> hole from donor to receiver, leaving a hole at the place from where extents are
> moved.
So we can refer ext4_move_extents as SWAP, and ioc_mov_data as ASSING.
And both tasks looks very similar, except the way how holes are
interpreted. I think it is reasonable to allow ext4_move_extents()
to interpret holes similar to ioc_mov_data. 
> Could you elaborate more how it can be shared for unwritten data case ?
If we found unwritten extent we do not have to copy data, just swap to
extents between inodes.
> 
> > But I think we can observe another way to unify this two things.
> > An idea inspired by the fact that ioc_move_data works only for
> > regular inodes, where orig_offset == donor_offset. 
> Could you elaborate this point?
At this moment offset for both inodes should be equal. This is pure
artificial restriction. At this moment I'm working on patch which
remove this restriction. 
> 
> > This is showstopper
> > for  my utility e4defrag2 ( new version of e4defrag which is able defragment
> > pack small files as described here :
> > http://lists.openwall.net/linux-ext4/2014/04/28/3)
> > 
> > Proposed API is very similar to ext4_ext_migrate:
> > Args:
> >   orig_file: inode which we want to defragment
> >   donor_file: a file which will be used as a donor of blocks
> > 1) fallocate big donor_file
> > 2) a) Create tmp inode wich nlink = 0
> >    b) move extents required extents from  donor to tmp_donor_inode
> >    c) return file descriptor (tmp_fd) to that tmp_donor_inode
> > 4) Mark orig_file's inode with EXT4_STATE_EXT_MIGRATE state
> > 5) Copy data from orig_file to tmp_fd
> > 6) IOC_SWAP_EX: atomically swap  orig_file->i_data and tmp_fd->i_data
> >    if EXT4_STATE_EXT_MIGRATE was not cleared.
> > 
> > This approach can works not only for regular file w/o journaling
> > enabled, but also for journaled ones, and directories.
> > 
> > 
> > 
> > 
> > >
> > > -Lukas
> > >
> 
