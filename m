Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaHACVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 22:21:18 -0400
Received: from mx6-phx2.redhat.com ([209.132.183.39]:60018 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaHACVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 22:21:16 -0400
Date: Thu, 31 Jul 2014 22:21:14 -0400 (EDT)
From: Abhijith Das <adas@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Message-ID: <801205433.377924.1406859674954.JavaMail.zimbra@redhat.com>
In-Reply-To: <20140731131805.5280c697@notabene.brown>
References: <1406309851-10628-1-git-send-email-adas@redhat.com> <20140731131805.5280c697@notabene.brown>
Subject: Re: [RFC PATCH 0/2] dirreadahead system call
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.6]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC36 (Linux)/8.0.6_GA_5922)
Thread-Topic: dirreadahead system call
Thread-Index: sMeIo9DUQWF/2mDt6wV0W5niYZpO/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "NeilBrown" <neilb@suse.de>
> To: "Abhi Das" <adas@redhat.com>
> Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com
> Sent: Wednesday, July 30, 2014 10:18:05 PM
> Subject: Re: [RFC PATCH 0/2] dirreadahead system call
> 
> On Fri, 25 Jul 2014 12:37:29 -0500 Abhi Das <adas@redhat.com> wrote:
> 
> > This system call takes 3 arguments:
> > fd      - file descriptor of the directory being readahead
> > *offset - offset in dir from which to resume. This is updated
> >           as we move along in the directory
> > count   - The max number of entries to readahead
> > 
> > The syscall is supposed to read upto 'count' entries starting at
> > '*offset' and cache the inodes corresponding to those entries. It
> > returns a negative error code or a positive number indicating
> > the number of inodes it has issued readaheads for. It also
> > updates the '*offset' value so that repeated calls to dirreadahead
> > can resume at the right location. Returns 0 when there are no more
> > entries left.
> 
> Hi Abhi,
> 
>  I like the idea of enhanced read-ahead on a directory.
>  It isn't clear to me why you have included these particular fields in the
>  interface though.
> 
>  - why have an 'offset'?  Why not just use the current offset of the
>    directory 'fd'?

The idea was that we didn't want a syscall like readahead mucking with the
file pointer as the same fd might be used to do getdents().

>  - Why have a count?  How would a program choose what count to give?

If a program knows that it's only going to work on a subset of files at a time,
it can use the count value to only readahead a small number of inodes at once
instead of reading ahead the entire directory.

That said, this interface is not set in stone and we are exploring ways to inform
the kernel of the inodes we are interested in reading ahead.

> 
>  Maybe you imagine using 'getdents' first to get a list of names, then
>  selectively calling 'dirreadahead'  on the offsets of the names you are
>  interested it?  That would be racy as names can be added and removed which
>  might change offsets.  So maybe you have another reason?
> 
>  I would like to suggest an alternate interface (I love playing the API
>  game....).
> 
>  1/ Add a flag to 'fstatat'  AT_EXPECT_MORE.
>     If the pathname does not contain a '/', then the 'dirfd' is marked
>     to indicate that stat information for all names returned by getdents will
>     be wanted.  The filesystem can choose to optimise that however it sees
>     fit.
> 
>  2/ Add a flag to 'fstatat'  AT_NONBLOCK.
>     This tells the filesystem that you want this information, so if it can
>     return it immediately it should, and if not it should start pulling it
>     into cache.  Possibly this should be two flags: AT_NONBLOCK just avoids
>     any IO, and AT_ASYNC instigates IO even if NONBLOCK is set.
> 
>  Then an "ls -l" could use AT_EXPECT_MORE and then just stat each name.
>  An "ls -l *.c", might avoid AT_EXPECT_MORE, but would use AT_NONBLOCK
>  against all names, then try again with all the names that returned
>  EWOULDBLOCK the first time.
> 
> 
>  I would really like to see the 'xstat' syscall too, but there is no point
>  having both "xstat" and "fxstat".  Follow the model of "fstatat" and provide
>  just "fxstatat" which can do both.
>  With fxstatat, AT_EXPECT_MORE would tell the dirfd exactly which attributes
>  would be wanted so it can fetch only that which is desired.
> 
>  I'm not very keen on the xgetdents idea of including name information and
>  stat information into the one syscall - I would prefer getdents and xstat be
>  kept separate.  Of course if a genuine performance cost of the separate can
>  be demonstrated, I could well change my mind.
> 
>  It does, however, have the advantage that the kernel doesn't need to worry
>  about how long read-ahead data needs to be kept, and the application doesn't
>  need to worry about how soon to retry an fstatat which failed with
>  EWOULDBLOCK.
> 
> Thanks for raising this issue again.  I hope it gets fixed one day...
> 
> NeilBrown
> 
