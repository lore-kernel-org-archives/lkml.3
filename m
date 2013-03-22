Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab3CVFmC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 01:42:02 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:54599 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab3CVFl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 01:41:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130322015712.GQ17758@dastard>
References: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com>
	<20130129014000.GA7003@thunk.org>
	<CAEsagEhZkkr+G0gFr6rnsyjFmCckNMkOnTVcUMvaj8EHD-qGQw@mail.gmail.com>
	<201303200000.33356.Martin@lichtvoll.de>
	<1363762493.15703.46@driftwood>
	<CAEsagEjgDJr7stTu3iCzR4JxB3A856a7u12WcovY=746M2p0jw@mail.gmail.com>
	<20130322015712.GQ17758@dastard>
Date: Thu, 21 Mar 2013 22:41:57 -0700
Message-ID: <CAEsagEjaBc9b_Mgb-HF27eTceKHDjsROH0+k=qW6McxP4otPYQ@mail.gmail.com>
Subject: Re: Tux3 Report: Initial fsck has landed
From: Daniel Phillips <daniel.raymond.phillips@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Rob Landley <rob@landley.net>, Martin Steigerwald <Martin@lichtvoll.de>,
        tux3@phunq.net, "Theodore Ts'o" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        David Lang <david@lang.hm>, linux-kernel@vger.kernel.org,
        tux3@tux3.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Thank you for your insightful post. The answer to the riddle is that
the PHTree scheme as described in the link you cited has already
become "last gen" and that, after roughly ten years of searching, I am
cautiously optimistic that I have discovered a satisfactory next gen
indexing scheme with the properties I was seeking. This is what
Hirofumi and I have busy prototyping and testing for the last few
weeks. More below...

On Thu, Mar 21, 2013 at 6:57 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Mar 20, 2013 at 06:49:49PM -0700, Daniel Phillips wrote:
>> At the moment we're being pretty quiet because of being in the middle
>> of developing the next-gen directory index. Not such a small task, as
>> you might imagine.
>
> The "next-gen directory index" comment made me curious. I wanted to
> know if there's anything I could learn from what you are doing and
> whether anything of your new algorithms could be applied to, say,
> the XFS directory structure to improve it.
>
> I went looking for design docs and found this:
>
> http://phunq.net/pipermail/tux3/2013-January/001938.html
>
> In a word: Disappointment.

Me too. While I convinced myself that the PHTree scheme would scale
significantly better than HTree while being only modestly slower than
HTree in the smaller range (millions of files) even the new scheme
began hitting significant difficulties in the form of write
multiplication in the larger range (billions of files). Most probably,
you discovered the same thing. The problem is not so much about
randomly thrashing the index, because these days even a cheap desktop
can cache the entire index, but rather getting the index onto disk
with proper atomic update at reasonable intervals. We can't accept a
situation where crashing on the 999,999,999th file create requires the
entire index to be rebuilt, or even a significant portion of it. That
means we need ACID commit at normal intervals all the way through the
heavy create load, and unfortunately, that's where the write
multiplication issue rears its ugly head. It turned out that most of
the PHTree index blocks would end up being written to disk hundreds of
times each, effectively stretching out what should be a 10 minute test
to hours.

To solve this, I eventually came up with a secondary indexing scheme
that would kick in under heavy file create load, to take care of
committing enough state to disk at regular intervals that remounting
after a crash would only lose a few seconds of work. With this, PHTree
would satisfy all the performance goals we set out for it, which can
be summarized as: scale smoothly all the way from one file per
directory to one billion files per directory.

The only really distasteful element remaining was the little matter of
having two different directory indexes, the PHTree and the temporary
secondary index. That seems like one index too many. Then the big aha
landed out of the blue: we can actually throw away the primary BTree
and the secondary index will work fine all on its own. So the
secondary index was suddenly promoted to a "next gen" primary index.
This new index (which does not yet have a name) is based on hashing
and sharding and has nothing whatsoever to do with BTrees. It
currently exists in prototype with enough implementation in place to
get some early benchmarks, but we are not quite ready to provide those
details yet. You are completely welcome to call me a tease or be
sceptical, which is just what I would do coming from the other side,
but just now we're in the thick of the heavy work, and the key as we
see it is to keep on concentrating until the time is right. After all,
this amounts to the end of a ten year search that began around the
time HTree went into service in Ext3. Another couple of weeks hardly
seems worth worrying about.

> Compared to the XFS directory structure, the most striking
> architectural similarity that I see is this:
>
>         "the file bteee[sic] effectively is a second directory index
>         that imposes a stable ordering on directory blocks".
>
> That was the key architectural innovation in the XFS directory
> structure that allowed it to provide the correct seekdir/telldir/NFS
> readdir semantics and still scale. i.e. virtually mapped directory
> entries. I explained this layout recently here:
>
> http://marc.info/?l=linux-ext4&m=136081996316453&w=2
> http://marc.info/?l=linux-ext4&m=136082221117399&w=2
> http://marc.info/?l=linux-ext4&m=136089526928538&w=2
>
> We could swap the relevant portions of your PHTree design doc with
> my comments (and vice versa) and both sets of references would still
> make perfect sense. :P
>
> Further, the PHTree description of tag based freespace tracking is
> rather close to how XFS uses tags to track free space regions,
> including the fact that XFS can be lazy at updating global free
> space indexes.  The global freespace tree indexing is slightly
> different to the XFS method - it's closer to the original V1 dir
> code in XFS (that didn't scale at all well) than the current code.
> However, that's really a fine detail compared to all the major
> structural and algorithmic similarities.
>
> Hence it appears to me that at a fundamental level PHTree is just a
> re-implementation of the XFS directory architecture. It's definitely
> a *major* step forward from HTree, but it can hardly be considered
> revolutionary or "next-gen". It's not even state of the art. Hence:
> disappointment.

Insightful indeed, and right on the money. I had no idea we were
reinventing XFS to that extent and would love to spend some time later
dwelling on the details. But at this point, I am willing to cautiously
characterize all that as history, based on the performance numbers we
are seeing from the next gen prototype. We plan to publish details
fairly soon. I will apologize again for the lag. I can only plead that
this kind of work just seems to take more time than it reasonably
should.

Regards,

Daniel
