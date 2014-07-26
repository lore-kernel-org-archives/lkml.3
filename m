Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919AbaGZF1a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 01:27:30 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40725 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaGZF12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 01:27:28 -0400
References: <1406309851-10628-1-git-send-email-adas@redhat.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1406309851-10628-1-git-send-email-adas@redhat.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <CA2BF8AB-6F61-4856-8B0E-9D954BDEB243@dilger.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>
X-Mailer: iPhone Mail (11D257)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH 0/2] dirreadahead system call
Date: Fri, 25 Jul 2014 23:27:19 -0600
To: Abhi Das <adas@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a time when this doesn't get called to prefetch entries in
readdir() order?  It isn't clear to me what benefit there is of returning
the entries to userspace instead of just doing the statahead implicitly
in the kernel?

The Lustre client has had what we call "statahead" for a while,
and similar to regular file readahead it detects the sequential access
pattern for readdir() + stat() in readdir() order (taking into account if ".*"
entries are being processed or not) and starts fetching the inode
attributes asynchronously with a worker thread.

This syscall might be more useful if userspace called readdir() to get
the dirents and then passed the kernel the list of inode numbers
to prefetch before starting on the stat() calls. That way, userspace
could generate an arbitrary list of inodes (e.g. names matching a
regexp) and the kernel doesn't need to guess if every inode is needed. 

As it stands, this syscall doesn't help in anything other than readdir
order (or of the directory is small enough to be handled in one
syscall), which could be handled by the kernel internally already,
and it may fetch a considerable number of extra inodes from
disk if not every inode needs to be touched. 

Cheers, Andreas

> On Jul 25, 2014, at 11:37, Abhi Das <adas@redhat.com> wrote:
> 
> This system call takes 3 arguments:
> fd      - file descriptor of the directory being readahead
> *offset - offset in dir from which to resume. This is updated
>          as we move along in the directory
> count   - The max number of entries to readahead
> 
> The syscall is supposed to read upto 'count' entries starting at
> '*offset' and cache the inodes corresponding to those entries. It
> returns a negative error code or a positive number indicating
> the number of inodes it has issued readaheads for. It also
> updates the '*offset' value so that repeated calls to dirreadahead
> can resume at the right location. Returns 0 when there are no more
> entries left.
> 
> Abhi Das (2):
>  fs: Add dirreadahead syscall and VFS hooks
>  gfs2: GFS2's implementation of the dir_readahead file operation
> 
> arch/x86/syscalls/syscall_32.tbl |   1 +
> arch/x86/syscalls/syscall_64.tbl |   1 +
> fs/gfs2/Makefile                 |   3 +-
> fs/gfs2/dir.c                    |  49 ++++++---
> fs/gfs2/dir.h                    |  15 +++
> fs/gfs2/dir_readahead.c          | 209 +++++++++++++++++++++++++++++++++++++++
> fs/gfs2/file.c                   |   2 +
> fs/gfs2/main.c                   |  10 +-
> fs/gfs2/super.c                  |   1 +
> fs/readdir.c                     |  49 +++++++++
> include/linux/fs.h               |   3 +
> 11 files changed, 328 insertions(+), 15 deletions(-)
> create mode 100644 fs/gfs2/dir_readahead.c
> 
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
