Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167AbaJ3OyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:54:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34227 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760369AbaJ3OyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:54:01 -0400
Message-ID: <545250FD.8030509@fb.com>
Date: Thu, 30 Oct 2014 08:53:49 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: "Jason B. Akers" <jason.b.akers@intel.com>, <linux-ide@vger.kernel.org>,
        <dan.j.williams@intel.com>, <kapil.karkra@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>	<yq1k33il3b3.fsf@sermon.lab.mkp.net> <5451A3F5.9020903@fb.com> <yq1bnoukzhe.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1bnoukzhe.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-30_06:2014-10-30,2014-10-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=5.55111512312578e-17 kscore.compositescore=0
 circleOfTrustscore=272.604764483896 compositescore=0.986137415400633
 urlsuspect_oldscore=0.986137415400633 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410300137
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-29 21:28, Martin K. Petersen wrote:
>>>>>> "Jens" == Jens Axboe <axboe@fb.com> writes:
>
> Jens> The problem with xadvise() is that it handles only one part of
> Jens> this - it handles the case of tying some sort of IO related
> Jens> priority information to an inode. It does not handle the case of
> Jens> different parts of the file, at least not without adding specific
> Jens> extra tracking for this on the kernel side.
>
> Are there actually people asking for sub-file granularity? I didn't get
> any requests for that in the survey I did this summer.

Yeah, consider the case of using a raw block device for storing a 
database. That one is quite common. Or perhaps a setup with a single 
log, with data being appended to it. Some of that data would be marked 
as hot/willneed, some of it will be marked with cold/wontneed. This 
means that we cannot rely on per-inode hinting.

> I talked to several application people about what they really needed and
> wanted. That turned into a huge twisted mess of a table with ponies of
> various sizes.

Who could have envisioned that :-)

> I condensed all those needs and desires into something like this:
>
> +-----------------+------------+----------+------------+
> | I/O Class       | Command    | Desired  | Predicted  |
> |                 | Completion | Future   | Future     |
> |                 | Urgency    | Access   | Access     |
> |                 |            | Latency  | Frequency  |
> +-----------------+------------+----------+------------+
> | Transaction     | High       | Low      | High       |
> +-----------------+------------+----------+------------+
> | Metadata        | High       | Low      | Normal     |
> +-----------------+------------+----------+------------+
> | Paging          | High       | Normal   | Normal     |
> +-----------------+------------+----------+------------+
> | Streaming       | High       | Normal   | Low        |
> +-----------------+------------+----------+------------+
> | Data            | Normal     | Normal   | Normal     |
> +-----------------+------------+----------+------------+
> | Background      | Low        | Normal*  | Low        |
> +-----------------+------------+----------+------------+
>
> Command completion urgency is really just the existing I/O priority.
> Desired future access latency affects data placement in a tiered
> device. Predicted future access frequency is essentially a caching hint.
>
> The names and I/O classes themselves are not really important. It's just
> a reduced version of all the things people asked for. Essentially:
> Relative priority, data placement and caching.
>
> I had also asked why people wanted to specify any hints. And that boiled
> down to the I/O classes in the left column above. People wanted stuff on
> a low latency storage tier because it was a transactional or metadata
> type of I/O. Or to isolate production I/O from any side effects of a
> background scrub or backup run.
>
> Incidentally, the classes data, transaction and background covered
> almost all the use cases that people had asked for. The metadata class
> mostly came about from good results with REQ_META tagging in a previous
> prototype. A few vendors wanted to be able to identify swap to prevent
> platter spin-ups. Streaming was requested by a couple of video folks.
>
> The notion of telling the storage *why* you're doing I/O instead of
> telling it how to manage its cache and where to put stuff is closely
> aligned with our internal experiences with I/O hints over the last
> decade. But it's a bit of a departure from where things are going in the
> standards bodies. In any case I thought it was interesting that pretty
> much every use case that people came up with could be adequately
> described by a handful of I/O classes.

Definitely agree on this, it's about notifying storage on what type of 
IO this is, or why we are doing it. I'm just still worried that this 
will then end up being unusable by applications, since they can't rely 
on anything. Say one vendor treats WONTNEED in a much colder fashion 
than others, the user/application will then complain about the access 
latencies for the next IO to that location. "Yes it's cold, but I didn't 
expect it to be THAT cold" and then come to the conclusion that they 
can't feasibly use these hints as they don't do exactly what they want.

It'd be nice if we could augment this with a query interface of some 
sort, that could give the application some idea of what happens for each 
of the passed in hints. That would improve the situation from a "lets 
set this hint and hope it does what we think it does" to a more 
predictable and robust environment.


-- 
Jens Axboe

