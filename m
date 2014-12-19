Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaLSOb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:31:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9867 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751963AbaLSOb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:31:27 -0500
Date: Fri, 19 Dec 2014 09:30:37 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: frequent lockups in 3.18rc4
To: Dave Jones <davej@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Message-ID: <1418999437.13012.1@mail.thefacebook.com>
In-Reply-To: <20141219035859.GA20022@redhat.com>
References: <CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
	<CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
	<20141215055707.GA26225@redhat.com>
	<CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
	<CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
	<20141218051327.GA31988@redhat.com>
	<1418918059.17358.6@mail.thefacebook.com>
	<20141218161230.GA6042@redhat.com> <20141219024549.GB1671@redhat.com>
	<CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
	<20141219035859.GA20022@redhat.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-19_04:2014-12-19,2014-12-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=145.191669734525
 compositescore=0.160988131301636 urlsuspect_oldscore=0.160988131301636
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.160988131301636 spamscore=0
 recipient_to_sender_domain_totalscore=7 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412190144
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, Dec 18, 2014 at 10:58 PM, Dave Jones <davej@redhat.com> wrote:
> On Thu, Dec 18, 2014 at 07:49:41PM -0800, Linus Torvalds wrote:
> 
>  > And when spinlocks start getting  contention, *nested* spinlocks
>  > really really hurt. And you've got all the spinlock debugging on 
> etc,
>  > don't you?
> 
> Yeah, though remember this seems to have for some reason gotten worse
> in more recent builds. I've been running kitchen-sink debug kernels
> for my trinity runs for the last three years, and it's only this
> last few months that this has got to be enough of a problem that I'm
> not seeing the more interesting bugs. (Or perhaps we're just getting
> better at fixing them in -next now, so my runs are lasting longer..)

I think we're also adding more and more debugging.  It's definitely a 
good thing, but I think a lot of them are expected to stay off until 
you're trying to track down a specific problem.  I do always run with 
CONFIG_DEBUG_PAGEALLOC here and lock debugging/lockdep, and aside from 
being slow haven't hit trouble.

I know it's 3.16 instead of 3.17, but 16K stacks are probably 
increasing the pressure on everything in these runs.  It's my favorite 
kernel feature this year, but it's likely to make trinity hurt more on 
memory constrained boxes.

Your trace with hrtimer debugging yesterday made some sense, but it 
still should have been survivable.  I mean you should have kept seeing 
lockups from that one poor task being starved out of filling up his 
pool.  I know you have traces with a ton more output, but I'm still 
wondering if usb-serial and printk from NMI really get along well.  I'd 
try with debugging back on and serial consoles off.  We carry patches 
to make oom print less, just because the time spent on our slow 
emulated serial console is enough to back the box up into a death 
spiral.

The fairness of spinlock debugging is a really great point too, 
definitely worth trying with that off (and fixing, I love spinlock 
debugging).

-chris



