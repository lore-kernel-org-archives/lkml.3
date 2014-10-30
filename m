Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbaJ3Cft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:35:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30895 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117AbaJ3Cfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:35:46 -0400
Message-ID: <5451A3F5.9020903@fb.com>
Date: Wed, 29 Oct 2014 20:35:33 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Jason B. Akers" <jason.b.akers@intel.com>
CC: <linux-ide@vger.kernel.org>, <dan.j.williams@intel.com>,
        <kapil.karkra@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox> <yq1k33il3b3.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1k33il3b3.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-30_01:2014-10-29,2014-10-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410300026
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-29 20:05, Martin K. Petersen wrote:
>>>>>> "Jason" == Jason B Akers <jason.b.akers@intel.com> writes:
>
> Jason> The following series enables the use of Solid State hybrid drives
> Jason> ATA standard 3.2 defines the hybrid information feature, which
> Jason> provides a means for the host driver to provide hints to the
> Jason> SSHDs to guide what to place on the SSD/NAND portion and what to
> Jason> place on the magnetic media.
>
> I have been ripping my hair out in this department for a while.
>
> A colleague and I presented our findings at SNIA SDC a few weeks
> ago. I'm trying to find out if there's an embargo on the slides or if I
> can post them.
>
> First of all I completely agree with Dave's comments about hooking into
> fadvise()/madvise().

The problem with xadvise() is that it handles only one part of this - it 
handles the case of tying some sort of IO related priority information 
to an inode. It does not handle the case of different parts of the file, 
at least not without adding specific extra tracking for this on the 
kernel side.

I think we've needed a proper API for passing in appropriate hints on a 
per-io basis for a LONG time.

> My challenge with hints has been trying to bridge all the various
> existing approaches with the new stuff that's coming down the pipe in
> T10/T13 (LBMD hints) and NFS v4.2 ditto. That turned into a huge mapping
> table as well as a few amendments to what's currently being worked on in
> the standards bodies.

That is the big challenge. We've tried (and failed) in the past to 
define a set of hints that make sense. It'd be a shame to add something 
that's specific to a given transport/technology. That said, this set of 
hints do seem pretty basic and would not necessarily be a bad place to 
start. But they are still very specific to this use case. And who knows 
what will happen on the device side. I might assume that WILLNEED is the 
same as HOT, and that DONTNEED is the same as cold. And then 
applications get upset when vendor X and Y treat them somewhat 
differently, because that's how it fit into their architecture.

This is the primary reason that hints never happened previously.

-- 
Jens Axboe

