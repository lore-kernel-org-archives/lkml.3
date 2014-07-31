Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaGaLTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:19:51 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36617 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaGaLTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:19:49 -0400
References: <1406309851-10628-1-git-send-email-adas@redhat.com> <CA2BF8AB-6F61-4856-8B0E-9D954BDEB243@dilger.ca> <193414027.14151264.1406551934098.JavaMail.zimbra@redhat.com> <7EBB0CF1-6564-4C63-8006-7DEEE8800A19@dilger.ca> <20140731044909.GR26465@dastard>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20140731044909.GR26465@dastard>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <351B218B-259B-4066-8E78-0B0EA05D087E@dilger.ca>
Cc: Abhijith Das <adas@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>
X-Mailer: iPhone Mail (11D257)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH 0/2] dirreadahead system call
Date: Thu, 31 Jul 2014 13:19:45 +0200
To: Dave Chinner <david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 31, 2014, at 6:49, Dave Chinner <david@fromorbit.com> wrote:
> 
>> On Mon, Jul 28, 2014 at 03:19:31PM -0600, Andreas Dilger wrote:
>>> On Jul 28, 2014, at 6:52 AM, Abhijith Das <adas@redhat.com> wrote:
>>> OnJuly 26, 2014 12:27:19 AM "Andreas Dilger" <adilger@dilger.ca> wrote:
>>>> Is there a time when this doesn't get called to prefetch entries in
>>>> readdir() order?  It isn't clear to me what benefit there is of returning
>>>> the entries to userspace instead of just doing the statahead implicitly
>>>> in the kernel?
>>>> 
>>>> The Lustre client has had what we call "statahead" for a while,
>>>> and similar to regular file readahead it detects the sequential access
>>>> pattern for readdir() + stat() in readdir() order (taking into account if
>>>> ".*"
>>>> entries are being processed or not) and starts fetching the inode
>>>> attributes asynchronously with a worker thread.
>>> 
>>> Does this heuristic work well in practice? In the use case we were trying to
>>> address, a Samba server is aware beforehand if it is going to stat all the
>>> inodes in a directory.
>> 
>> Typically this works well for us, because this is done by the Lustre
>> client, so the statahead is hiding the network latency of the RPCs to
>> fetch attributes from the server.  I imagine the same could be seen with
>> GFS2. I don't know if this approach would help very much for local
>> filesystems because the latency is low.
>> 
>>>> This syscall might be more useful if userspace called readdir() to get
>>>> the dirents and then passed the kernel the list of inode numbers
>>>> to prefetch before starting on the stat() calls. That way, userspace
>>>> could generate an arbitrary list of inodes (e.g. names matching a
>>>> regexp) and the kernel doesn't need to guess if every inode is needed.
>>> 
>>> Were you thinking arbitrary inodes across the filesystem or just a subset
>>> from a directory? Arbitrary inodes may potentially throw up locking issues.
>> 
>> I was thinking about inodes returned from readdir(), but the syscall
>> would be much more useful if it could handle arbitrary inodes.
> 
> I'm not sure we can do that. The only way to safely identify a
> specific inode in the filesystem from userspace is via a filehandle.
> Plain inode numbers are susceptible to TOCTOU race conditions that
> the kernel cannot resolve. Also, lookup by inode number bypasses
> directory access permissions, so is not something we would expose
> to arbitrary unprivileged users.

None of these issues are relevant in the API that I'm thinking about. 
The syscall just passes the list of inode numbers to be prefetched
into kernel memory, and then stat() is used to actually get the data into
userspace (or whatever other operation is to be done on them),
so there is no danger if the wrong inode is prefetched.  If the inode
number is bad the filesystem can just ignore it. 

>> There are always going to be race conditions even if limited to a
>> single directory (e.g. another client modifies the inode after calling
>> dirreadahead(), but before calling stat()) that need to be handled.
> 
> Unlink/realloc to a different directory with different access
> permissions is the big issue.
> 
>> I think there are a lot of benefits that could be had by the generic
>> syscall, possibly similar to what XFS is doing with the "bulkstat"
>> interfaces that Dave always mentions.  This would be much more so for
>> cases were you don't want to stat all of the entries in a directory.
> 
> Bulkstat is not really suited to this - it gets it's speed
> specifically by avoiding directory traversal to find inodes. Hence
> it is a root-only operation because it bypasses directory based
> access restrictions and hence is really only useful for
> full-filesystem traversal operations like backups, defragmentation,
> etc.

Maybe it was a mistake to mention bulkstat in this discussion. The
stat() information would not actually be returned to memory in my
proposal, just the inodes would be loaded into memory in bulk so
that the later stat() (or unlink() or whatever) can go quickly.

Cheers, Andreas

> Bulkstat output also contains enough information to construct a
> valid file handle in userspace and so access to inodes found via
> bulkstat can be gained via the XFS open-by-handle interfaces. Again,
> this bypasses permissions checking and hence is a root-only
> operation. It does, however, avoid TOCTOU races because the open-by-handle
> will fail if the inode is unlinked and reallocated between the
> bulkstat call and the open-by-handle as the generation number in the
> handle will no longer match that of the inode.
> 
> Cheers,
> 
> Dave.
> 
> 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
