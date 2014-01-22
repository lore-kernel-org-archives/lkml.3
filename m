Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaAVShm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:37:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65073 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338AbaAVShh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:37:37 -0500
From: Chris Mason <clm@fb.com>
To: "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org" 
	<lsf-pc@lists.linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Thread-Topic: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Thread-Index: AQHPFx61ZXTlm16UX0ihGnyWT2seDpqRAjIAgABNLACAAAa5AIAABq0AgAAFt4CAAB0+gIAABPgAgAALu4CAAALjgIAABusA
Date: Wed, 22 Jan 2014 18:37:13 +0000
Message-ID: <1390415924.1198.36.camel@ret.masoncoding.com>
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com>
	 <20140122093435.GS4963@suse.de> <52DFD168.8080001@redhat.com>
	 <20140122143452.GW4963@suse.de> <52DFDCA6.1050204@redhat.com>
	 <20140122151913.GY4963@suse.de>
	 <1390410233.1198.7.camel@ret.masoncoding.com>
	 <1390411300.2372.33.camel@dabdike.int.hansenpartnership.com>
	 <1390413819.1198.20.camel@ret.masoncoding.com>
	 <1390414439.2372.53.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1390414439.2372.53.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="utf-7"
Content-ID: <3E76E571D8C3C544B1DE84151ADDE147@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-22_07:2014-01-22,2014-01-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.77635683940025e-15 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997696947966296
 urlsuspect_oldscore=0.997696947966296 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997696947966296 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1401220131
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-22 at 10:13 -0800, James Bottomley wrote:
+AD4- On Wed, 2014-01-22 at 18:02 +-0000, Chris Mason wrote:

+AD4-  
+AD4- +AD4- We're likely to have people mixing 4K drives and +ADw-fill in some other
+AD4- +AD4- size here+AD4- on the same box.  We could just go with the biggest size and
+AD4- +AD4- use the existing bh code for the sub-pagesized blocks, but I really
+AD4- +AD4- hesitate to change VM fundamentals for this.
+AD4- 
+AD4- If the page cache had a variable granularity per device, that would cope
+AD4- with this.  It's the variable granularity that's the VM problem.

Agreed.  But once we go variable granularity we're basically talking the
large order allocation problem.

+AD4- 
+AD4- +AD4- From a pure code point of view, it may be less work to change it once in
+AD4- +AD4- the VM.  But from an overall system impact point of view, it's a big
+AD4- +AD4- change in how the system behaves just for filesystem metadata.
+AD4- 
+AD4- Agreed, but only if we don't do RMW in the buffer cache ... which may be
+AD4- a good reason to keep it.
+AD4- 
+AD4- +AD4- +AD4- The other question is if the drive does RMW between 4k and whatever its
+AD4- +AD4- +AD4- physical sector size, do we need to do anything to take advantage of
+AD4- +AD4- +AD4- it ... as in what would altering the granularity of the page cache buy
+AD4- +AD4- +AD4- us?
+AD4- +AD4- 
+AD4- +AD4- The real benefit is when and how the reads get scheduled.  We're able to
+AD4- +AD4- do a much better job pipelining the reads, controlling our caches and
+AD4- +AD4- reducing write latency by having the reads done up in the OS instead of
+AD4- +AD4- the drive.
+AD4- 
+AD4- I agree with all of that, but my question is still can we do this by
+AD4- propagating alignment and chunk size information (i.e. the physical
+AD4- sector size) like we do today.  If the FS knows the optimal I/O patterns
+AD4- and tries to follow them, the odd cockup won't impact performance
+AD4- dramatically.  The real question is can the FS make use of this layout
+AD4- information +ACo-without+ACo- changing the page cache granularity?  Only if you
+AD4- answer me +ACI-no+ACI- to this do I think we need to worry about changing page
+AD4- cache granularity.

Can it mostly work?  I think the answer is yes.  If not we'd have a lot
of miserable people on top of raid5/6 right now.  We can always make a
generic r/m/w engine in DM that supports larger sectors transparently.

+AD4- 
+AD4- Realistically, if you look at what the I/O schedulers output on a
+AD4- standard (spinning rust) workload, it's mostly large transfers.
+AD4- Obviously these are misalgned at the ends, but we can fix some of that
+AD4- in the scheduler.  Particularly if the FS helps us with layout.  My
+AD4- instinct tells me that we can fix 99+ACU- of this with layout on the FS +- io
+AD4- schedulers ... the remaining 1+ACU- goes to the drive as needing to do RMW
+AD4- in the device, but the net impact to our throughput shouldn't be that
+AD4- great.

There are a few workloads where the VM and the FS would team up to make
this fairly miserable

Small files.  Delayed allocation fixes a lot of this, but the VM doesn't
realize that fileA, fileB, fileC, and fileD all need to be written at
the same time to avoid RMW.  Btrfs and MD have setup plugging callbacks
to accumulate full stripes as much as possible, but it still hurts.

Metadata.  These writes are very latency sensitive and we'll gain a lot
if the FS is explicitly trying to build full sector IOs.

I do agree that its very likely these drives are going to silently rmw
in the background for us.

Circling back to what we might talk about at the conference, Ric do you
have any ideas on when these drives might hit the wild?

-chris

