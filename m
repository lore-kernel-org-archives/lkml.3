Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaKJDlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 22:41:31 -0500
Received: from mx5-phx2.redhat.com ([209.132.183.37]:58648 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaKJDla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 22:41:30 -0500
Date: Sun, 9 Nov 2014 22:41:17 -0500 (EST)
From: Abhijith Das <adas@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andreas Dilger <adilger@dilger.ca>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Message-ID: <1672873802.9686431.1415590877143.JavaMail.zimbra@redhat.com>
In-Reply-To: <1218263590.8113472.1413868891802.JavaMail.zimbra@redhat.com>
References: <1406309851-10628-1-git-send-email-adas@redhat.com> <CA2BF8AB-6F61-4856-8B0E-9D954BDEB243@dilger.ca> <193414027.14151264.1406551934098.JavaMail.zimbra@redhat.com> <7EBB0CF1-6564-4C63-8006-7DEEE8800A19@dilger.ca> <20140731044909.GR26465@dastard> <351B218B-259B-4066-8E78-0B0EA05D087E@dilger.ca> <20140731235306.GR20518@dastard> <1218263590.8113472.1413868891802.JavaMail.zimbra@redhat.com>
Subject: Re: [RFC PATCH 0/2] dirreadahead system call
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC38 (Linux)/8.0.6_GA_5922)
Thread-Topic: dirreadahead system call
Thread-Index: ZnPIK03wD/2Bg1F6sZmdL0cWnc8Ucn2BYQ56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > 
> 
> Hi Dave/all,
> 
> I finally got around to playing with the multithreaded userspace readahead
> idea and the results are quite promising. I tried to mimic what my kernel
> readahead patch did with this userspace program (userspace_ra.c)
> Source code here:
> https://www.dropbox.com/s/am9q26ndoiw1cdr/userspace_ra.c?dl=0
> 
> Each thread has an associated buffer into which a chunk of directory
> entries are read in using getdents(). Each thread then sorts the entries in
> inode number order (for GFS2, this is also their disk block order) and
> proceeds
> to cache in the inodes in that order by issuing open(2) syscalls against
> them.
> In my tests, I backgrounded this program and issued an 'ls -l' on the dir
> in question. I did the same following the kernel dirreadahead syscall as
> well.
> 
> I did not manage to test out too many parameter combinations for both
> userspace_ra and SYS_dirreadahead because the test matrix got pretty big and
> time consuming. However, I did notice that without sorting, userspace_ra did
> not perform as well in some of my tests. I haven't investigated that yet,
> so the numbers shown here are all with sorting enabled.
> 
> For a directory with 100000 files,
> a) simple 'ls -l' took 14m11s
> b) SYS_dirreadahead + 'ls -l' took 3m9s, and
> c) userspace_ra (1M buffer/thread, 32 threads) took 1m42s
> 
> https://www.dropbox.com/s/85na3hmo3qrtib1/ra_vs_u_ra_vs_ls.jpg?dl=0 is a
> graph
> that contains a few more data points. In the graph, along with data for 'ls
> -l'
> and SYS_dirreadahead, there are six data series for userspace_ra for each
> directory size (10K, 100K and 200K files). i.e. u_ra:XXX,YYY, where XXX is
> one
> of (64K, 1M) buffer size and YYY is one of (4, 16, 32) threads.
> 

Hi,

Here are some more numbers for larger directories and it seems like userspace
readahead scales well and is still a good option.

I've chosen the best-performing runs for kernel readahead and userspace readahead. I
have data for runs with different parameters (buffer size, number of threads, etc)
that I can provide, if anybody's interested.

The numbers here are total elapsed times for the readahead plus 'ls -l' operations
to complete.

							#files in testdir
						50k	100k	200k	500k	1m
------------------------------------------------------------------------------------
Readdir 'ls -l'					11	849	1873	5024	10365
Kernel readahead + 'ls -l' (best case)		7	214	814	2330	4900
Userspace MT readahead + 'ls -l' (best case)	12	99	239	1351	4761

Cheers!
--Abhi
