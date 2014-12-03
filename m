Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaLCUAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:00:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40856 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110AbaLCUAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:00:40 -0500
Date: Wed, 3 Dec 2014 14:59:58 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: frequent lockups in 3.18rc4
To: Dave Jones <davej@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <1417636798.11261.1@mail.thefacebook.com>
In-Reply-To: <20141203190045.GB32005@redhat.com>
References: <547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141203190045.GB32005@redhat.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-03_08:2014-12-03,2014-12-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=120.659590407225
 compositescore=0.140620555742602 urlsuspect_oldscore=0.140620555742602
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.140620555742602 spamscore=0
 recipient_to_sender_domain_totalscore=8 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412030173
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, Dec 3, 2014 at 2:00 PM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Dec 03, 2014 at 10:45:57AM -0800, Linus Torvalds wrote:
>  > On Wed, Dec 3, 2014 at 10:41 AM, Dave Jones <davej@redhat.com> 
> wrote:
>  > >
>  > > I've been stuck on this kernel for a few days now trying to 
> prove it
>  > > good/bad one way or the other, and I'm leaning towards good, 
> given
>  > > that it recovers, even though the traces look similar.
>  >
>  > Ugh. But this does *not* happen with 3.16, right? Even the 
> non-fatal case?
> 
> correct. at least not in any of the runs that I did to date.
> 
>  > If so, I'd be inclined to call it "bad". But there might well be 
> two
>  > bugs: one that makes that NMI watchdog trigger, and another one 
> that
>  > then makes it be a hard lockup. I'd think it would be good to 
> figure
>  > out the "NMI watchdog starts triggering" one first, though.
> 
> I think you're right.
> 
> So right after sending my last mail, I rebooted, and restarted the run
> on the same kernel again.
> 
> As I was writing this mail, this happened.
> 
> [  524.420897] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! 
> [trinity-c178:20182]
> 
> and that's all that made it over the console. I couldn't log in via 
> ssh,
> and thought "ah-ha, so it IS bad".  I walked over to reboot it, and
> found I could actually log in on the console. check out this dmesg..
> 
> [  503.683055] Clocksource tsc unstable (delta = -95946009388 ns)
> [  503.692038] Switched to clocksource hpet
> [  524.420897] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! 
> [trinity-c178:20182]

Neat.  We often see switching to hpet on boxes as they are diving into 
softlockup pain, but it's not usually before the softlockups.

Are you configured for CONFIG_NOHZ_FULL?

I'd love to blame the only commit to kernel/smp.c between 3.16 and 3.17

commit 478850160636c4f0b2558451df0e42f8c5a10939
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Thu May 8 01:37:48 2014 +0200

    irq_work: Implement remote queueing

You've also mentioned a few times where messages stopped hitting the 
console?


commit 5874af2003b1aaaa053128d655710140e3187226
Author: Jan Kara <jack@suse.cz>
Date:   Wed Aug 6 16:09:10 2014 -0700

    printk: enable interrupts before calling 
console_trylock_for_printk()

-chris

