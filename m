Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaG2Jgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:36:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbaG2Jgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:36:38 -0400
Message-ID: <53D76B1F.7090701@redhat.com>
Date: Tue, 29 Jul 2014 10:36:31 +0100
From: Steven Whitehouse <swhiteho@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andreas Dilger <adilger@dilger.ca>, Abhijith Das <adas@redhat.com>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>, cluster-devel@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Cluster-devel] [RFC PATCH 0/2] dirreadahead system call
References: <1406309851-10628-1-git-send-email-adas@redhat.com>	<CA2BF8AB-6F61-4856-8B0E-9D954BDEB243@dilger.ca>	<193414027.14151264.1406551934098.JavaMail.zimbra@redhat.com> <7EBB0CF1-6564-4C63-8006-7DEEE8800A19@dilger.ca>
In-Reply-To: <7EBB0CF1-6564-4C63-8006-7DEEE8800A19@dilger.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 28/07/14 22:19, Andreas Dilger wrote:
> On Jul 28, 2014, at 6:52 AM, Abhijith Das <adas@redhat.com> wrote:
>> OnJuly 26, 2014 12:27:19 AM "Andreas Dilger" <adilger@dilger.ca> wrote:
>>> Is there a time when this doesn't get called to prefetch entries in
>>> readdir() order?  It isn't clear to me what benefit there is of returning
>>> the entries to userspace instead of just doing the statahead implicitly
>>> in the kernel?
>>>
>>> The Lustre client has had what we call "statahead" for a while,
>>> and similar to regular file readahead it detects the sequential access
>>> pattern for readdir() + stat() in readdir() order (taking into account if
>>> ".*"
>>> entries are being processed or not) and starts fetching the inode
>>> attributes asynchronously with a worker thread.
>> Does this heuristic work well in practice? In the use case we were trying to
>> address, a Samba server is aware beforehand if it is going to stat all the
>> inodes in a directory.
> Typically this works well for us, because this is done by the Lustre
> client, so the statahead is hiding the network latency of the RPCs to
> fetch attributes from the server.  I imagine the same could be seen with
> GFS2. I don't know if this approach would help very much for local
> filesystems because the latency is low.
Well GFS2 is more or less a local fs in the case of no contention. There 
are issues that arise in the contention case, which is why it is very 
important to ensure that there is as close to 100% chance of using the 
inodes which are pre-fetched as possible. Thats why we've not yet tried 
out algorithms that try to guess when the inodes will be required, since 
one wrong guess can be quite costly in terms of lock bouncing between 
nodes. However it does seem that the suggestions made in this thread 
about using ->lookup in the directory as one way to gather information 
may be a good way to go, since it will only be called for uncached 
inodes and in addition it would be equally useful to any possible 
operation which may follow the lookup.

>>> This syscall might be more useful if userspace called readdir() to get
>>> the dirents and then passed the kernel the list of inode numbers
>>> to prefetch before starting on the stat() calls. That way, userspace
>>> could generate an arbitrary list of inodes (e.g. names matching a
>>> regexp) and the kernel doesn't need to guess if every inode is needed.
>> Were you thinking arbitrary inodes across the filesystem or just a subset
>> from a directory? Arbitrary inodes may potentially throw up locking issues.
> I was thinking about inodes returned from readdir(), but the syscall
> would be much more useful if it could handle arbitrary inodes.  For
> example, if directories are small then it may be more efficient to
> aggregate inodes from multiple directories for each prefetch syscall.
> I can't really think of any locking issues that could exist with
> "arbitrary list of inodes" that couldn't be hit by having a directory
> with hard links to the same list of inodes, so this is something that
> needs to be handled by the filesystem anyway.
>
> Since this would be an advisory syscall (i.e. it doesn't really
> return anything and cannot guarantee that all the inodes will be in
> memory), then if the filesystem is having trouble prefetching the
> inodes (e.g. invalid inode number(s) or lock ordering or contention
> issues) it could always bail out and leave it to stat() to actually
> fetch the inodes into memory when accessed.
>
> There is no way it would be sane to keep inodes locked in the kernel
> after prefetch, in case the "stat" never arrives, so the best it can
> do is cache the inodes in memory (on the client for network fs), and
> it is possible cache pressure or lock contention drops them from cache.
>
> There are always going to be race conditions even if limited to a
> single directory (e.g. another client modifies the inode after calling
> dirreadahead(), but before calling stat()) that need to be handled.
>
> I think there are a lot of benefits that could be had by the generic
> syscall, possibly similar to what XFS is doing with the "bulkstat"
> interfaces that Dave always mentions.  This would be much more so for
> cases were you don't want to stat all of the entries in a directory.
>
Yes, it probably would be possible to do a kind of bulk lookup like 
that, although it would also be more complicated locking-wise if we 
allowed arbitrary inode numbers, rather than doing it on a per directory 
basis. I can see arguments for both approaches though,

Steve.

