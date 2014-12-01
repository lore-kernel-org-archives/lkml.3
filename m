Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbaLAXow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:44:52 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35897 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932408AbaLAXov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:44:51 -0500
Date: Mon, 1 Dec 2014 18:44:40 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: frequent lockups in 3.18rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        =?iso-8859-1?q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <1417477480.21136.0@mail.thefacebook.com>
In-Reply-To: <CA+55aFxOKsK-E438QEOd5Tq2dUZjO8sOnQtpTtPmpBKngmgpkg@mail.gmail.com>
References: <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	<20141127225637.GA24019@redhat.com> <m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<CA+55aFxOKsK-E438QEOd5Tq2dUZjO8sOnQtpTtPmpBKngmgpkg@mail.gmail.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-02_01:2014-12-01,2014-12-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=82.9551594286039
 compositescore=0.140620555742602 urlsuspect_oldscore=0.140620555742602
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.140620555742602 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412010223
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, Dec 1, 2014 at 6:25 PM, Linus Torvalds 
<torvalds@linux-foundation.org> wrote:
> On Mon, Dec 1, 2014 at 3:08 PM, Chris Mason <clm@fb.com> wrote:
>>  I'm not sure if this is related, but running trinity here, I 
>> noticed it
>>  was stuck at 100% system time on every CPU.  perf report tells me 
>> we are
>>  spending all of our time in spin_lock under the sync system call.
>> 
>>  I think it's coming from contention in the bdi_queue_work() call 
>> from
>>  inside sync_inodes_sb, which is spin_lock_bh().
> 
> Please do a perf run with -g to get the call chain to make sure..

The call chain goes something like this:

               --- _raw_spin_lock
                   |
                   |--99.72%-- sync_inodes_sb
                   |          sync_inodes_one_sb
                   |          iterate_supers
                   |          sys_sync
                   |          |
                   |          |--79.66%-- system_call_fastpath
                   |          |          syscall
                   |          |
                   |           --20.34%-- ia32_sysret
                   |                     __do_syscall
                    --0.28%-- [...]

(the 64bit call variation is similar)  Adding -v doesn't really help, 
because it isn't giving me the address inside sync_inodes_sb()

I first read this and guessed it must be leaving out the call to 
bdi_queue_work, hoping the spin_lock_bh and lock debugging were teaming 
up to stall the box.

But looking harder it's probably inside wait_sb_inodes:

        spin_lock(&inode_sb_list_lock);

Which is a little harder to blame.  Maaaaaybe with lock debugging, but 
its enough of a stretch that I wouldn't have emailed at all if I hadn't 
fixated on the bdi code.

-chris



