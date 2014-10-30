Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbaJ3D2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 23:28:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40145 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbaJ3D2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 23:28:37 -0400
To: Jens Axboe <axboe@fb.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Jason B. Akers" <jason.b.akers@intel.com>,
        <linux-ide@vger.kernel.org>, <dan.j.williams@intel.com>,
        <kapil.karkra@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
	<yq1k33il3b3.fsf@sermon.lab.mkp.net> <5451A3F5.9020903@fb.com>
Date: Wed, 29 Oct 2014 23:28:29 -0400
In-Reply-To: <5451A3F5.9020903@fb.com> (Jens Axboe's message of "Wed, 29 Oct
	2014 20:35:33 -0600")
Message-ID: <yq1bnoukzhe.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jens" == Jens Axboe <axboe@fb.com> writes:

Jens> The problem with xadvise() is that it handles only one part of
Jens> this - it handles the case of tying some sort of IO related
Jens> priority information to an inode. It does not handle the case of
Jens> different parts of the file, at least not without adding specific
Jens> extra tracking for this on the kernel side.

Are there actually people asking for sub-file granularity? I didn't get
any requests for that in the survey I did this summer.

I talked to several application people about what they really needed and
wanted. That turned into a huge twisted mess of a table with ponies of
various sizes.

I condensed all those needs and desires into something like this:

+-----------------+------------+----------+------------+
| I/O Class       | Command    | Desired  | Predicted  |
|                 | Completion | Future   | Future     |
|                 | Urgency    | Access   | Access     |
|                 |            | Latency  | Frequency  |
+-----------------+------------+----------+------------+
| Transaction     | High       | Low      | High       |
+-----------------+------------+----------+------------+
| Metadata        | High       | Low      | Normal     |
+-----------------+------------+----------+------------+
| Paging          | High       | Normal   | Normal     |
+-----------------+------------+----------+------------+
| Streaming       | High       | Normal   | Low        |
+-----------------+------------+----------+------------+
| Data            | Normal     | Normal   | Normal     |
+-----------------+------------+----------+------------+
| Background      | Low        | Normal*  | Low        |
+-----------------+------------+----------+------------+

Command completion urgency is really just the existing I/O priority.
Desired future access latency affects data placement in a tiered
device. Predicted future access frequency is essentially a caching hint.

The names and I/O classes themselves are not really important. It's just
a reduced version of all the things people asked for. Essentially:
Relative priority, data placement and caching.

I had also asked why people wanted to specify any hints. And that boiled
down to the I/O classes in the left column above. People wanted stuff on
a low latency storage tier because it was a transactional or metadata
type of I/O. Or to isolate production I/O from any side effects of a
background scrub or backup run.

Incidentally, the classes data, transaction and background covered
almost all the use cases that people had asked for. The metadata class
mostly came about from good results with REQ_META tagging in a previous
prototype. A few vendors wanted to be able to identify swap to prevent
platter spin-ups. Streaming was requested by a couple of video folks.

The notion of telling the storage *why* you're doing I/O instead of
telling it how to manage its cache and where to put stuff is closely
aligned with our internal experiences with I/O hints over the last
decade. But it's a bit of a departure from where things are going in the
standards bodies. In any case I thought it was interesting that pretty
much every use case that people came up with could be adequately
described by a handful of I/O classes.

The next step was trying to map these hints into what was available in
xadvise(), NFS 4.2 and the recent T10/T13 efforts. That wasn't trivial
and there really isn't a 1:1 mapping that works. So I went to T10 and
tried to nudge things in the same direction as NFS 4.2. Mainly because
that's closer to what we already have in xadvise().

Jens> I think we've needed a proper API for passing in appropriate hints
Jens> on a per-io basis for a LONG time.

Yup.

Jens> That is the big challenge. We've tried (and failed) in the past to
Jens> define a set of hints that make sense. It'd be a shame to add
Jens> something that's specific to a given transport/technology.

Absolutely!

-- 
Martin K. Petersen	Oracle Linux Engineering
