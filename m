Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaKJWrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:47:46 -0500
Received: from mx5-phx2.redhat.com ([209.132.183.37]:53336 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaKJWro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:47:44 -0500
Date: Mon, 10 Nov 2014 17:47:39 -0500 (EST)
From: Abhijith Das <adas@redhat.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Message-ID: <319424891.10545379.1415659659968.JavaMail.zimbra@redhat.com>
In-Reply-To: <A56008A1-6C4D-44A4-BE02-DA28C2FC6DF2@dilger.ca>
References: <1406309851-10628-1-git-send-email-adas@redhat.com> <7EBB0CF1-6564-4C63-8006-7DEEE8800A19@dilger.ca> <20140731044909.GR26465@dastard> <351B218B-259B-4066-8E78-0B0EA05D087E@dilger.ca> <20140731235306.GR20518@dastard> <1218263590.8113472.1413868891802.JavaMail.zimbra@redhat.com> <1672873802.9686431.1415590877143.JavaMail.zimbra@redhat.com> <A56008A1-6C4D-44A4-BE02-DA28C2FC6DF2@dilger.ca>
Subject: Re: [RFC PATCH 0/2] dirreadahead system call
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC38 (Linux)/8.0.6_GA_5922)
Thread-Topic: dirreadahead system call
Thread-Index: O2vjyr/iJHeCvkQWctns2xLB42RzEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Andreas Dilger" <adilger@dilger.ca>
> To: "Abhijith Das" <adas@redhat.com>
> Cc: "Dave Chinner" <david@fromorbit.com>, "LKML" <linux-kernel@vger.kernel.org>, "linux-fsdevel"
> <linux-fsdevel@vger.kernel.org>, cluster-devel@redhat.com, "Steven Whitehouse" <swhiteho@redhat.com>
> Sent: Monday, November 10, 2014 4:23:25 PM
> Subject: Re: [RFC PATCH 0/2] dirreadahead system call
> 
> On Nov 9, 2014, at 8:41 PM, Abhijith Das <adas@redhat.com> wrote:
> >> Hi Dave/all,
> >> 
> >> I finally got around to playing with the multithreaded userspace readahead
> >> idea and the results are quite promising. I tried to mimic what my kernel
> >> readahead patch did with this userspace program (userspace_ra.c)
> >> Source code here:
> >> https://www.dropbox.com/s/am9q26ndoiw1cdr/userspace_ra.c?dl=0
> >> 
> >> Each thread has an associated buffer into which a chunk of directory
> >> entries are read in using getdents(). Each thread then sorts the
> >> entries in inode number order (for GFS2, this is also their disk
> >> block order) and proceeds to cache in the inodes in that order by
> >> issuing open(2) syscalls against them.  In my tests, I backgrounded
> >> this program and issued an 'ls -l' on the dir in question. I did the
> >> same following the kernel dirreadahead syscall as well.
> >> 
> >> I did not manage to test out too many parameter combinations for both
> >> userspace_ra and SYS_dirreadahead because the test matrix got pretty
> >> big and time consuming. However, I did notice that without sorting,
> >> userspace_ra did not perform as well in some of my tests. I haven't
> >> investigated that, so numbers shown here are all with sorting enabled.
> 
> One concern is for filesystems where inode order does not necessarily
> match the on-disk order.  I believe that filesystems like ext4 and XFS
> have matching inode/disk order, but tree-based COW filesystems like
> Btrfs do not necessarily preserve this order, so sorting in userspace
> will not help and may in fact hurt readahead compared to readdir order.

Yes. I have seen in my tests that the multi-threaded user program performs
better than plain readdir + 'ls -l' with the sorting turned off, but not
as well as the kernel readahead. I'd imagine that if this ends up in glibc
or something, the sorting can be turned on and off based on whether the
filesystem's inode numbers and disk block order match.

> 
> What filesystem(s) have you tested this besides GFS?

I did some brief runs on ext4, in addition to GFS2 with similar results,
but I had to repurpose my machines, so I haven't had a chance to try out
other fses. Hopefully, I'll get around to it soon.

> 
> Cheers, Andreas
> 

Cheers!
--Abhi
