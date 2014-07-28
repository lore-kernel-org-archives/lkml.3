Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaG1MwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:52:17 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:33744 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaG1MwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:52:16 -0400
Date: Mon, 28 Jul 2014 08:52:14 -0400 (EDT)
From: Abhijith Das <adas@redhat.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Message-ID: <193414027.14151264.1406551934098.JavaMail.zimbra@redhat.com>
In-Reply-To: <CA2BF8AB-6F61-4856-8B0E-9D954BDEB243@dilger.ca>
References: <1406309851-10628-1-git-send-email-adas@redhat.com> <CA2BF8AB-6F61-4856-8B0E-9D954BDEB243@dilger.ca>
Subject: Re: [RFC PATCH 0/2] dirreadahead system call
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.7]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC36 (Linux)/8.0.6_GA_5922)
Thread-Topic: dirreadahead system call
Thread-Index: Ru44Ipn4K0anTSe7ZlLl3+jNFa3crA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Andreas Dilger" <adilger@dilger.ca>
> To: "Abhi Das" <adas@redhat.com>
> Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com
> Sent: Saturday, July 26, 2014 12:27:19 AM
> Subject: Re: [RFC PATCH 0/2] dirreadahead system call
> 
> Is there a time when this doesn't get called to prefetch entries in
> readdir() order?  It isn't clear to me what benefit there is of returning
> the entries to userspace instead of just doing the statahead implicitly
> in the kernel?
> 
> The Lustre client has had what we call "statahead" for a while,
> and similar to regular file readahead it detects the sequential access
> pattern for readdir() + stat() in readdir() order (taking into account if
> ".*"
> entries are being processed or not) and starts fetching the inode
> attributes asynchronously with a worker thread.

Does this heuristic work well in practice? In the use case we were trying to
address, a Samba server is aware beforehand if it is going to stat all the
inodes in a directory.

> 
> This syscall might be more useful if userspace called readdir() to get
> the dirents and then passed the kernel the list of inode numbers
> to prefetch before starting on the stat() calls. That way, userspace
> could generate an arbitrary list of inodes (e.g. names matching a
> regexp) and the kernel doesn't need to guess if every inode is needed.

Were you thinking arbitrary inodes across the filesystem or just a subset
from a directory? Arbitrary inodes may potentially throw up locking issues.
But yeah, as Steve mentioned in a previous email,  limiting the inodes
readahead in some fashion other than a range in readdir() order is something
that we are thinking of (list of inodes based on regexps, filenames etc). We
just chose to do an offset range of the directory for a quick, early
implementation.

> 
> As it stands, this syscall doesn't help in anything other than readdir
> order (or of the directory is small enough to be handled in one
> syscall), which could be handled by the kernel internally already,
> and it may fetch a considerable number of extra inodes from
> disk if not every inode needs to be touched.

The need for this syscall came up from a specific use case - Samba. I'm told
that Windows clients like to stat every file in a directory as soon as it is
read in and this has been a slow operation.

Cheers!
--Abhi
