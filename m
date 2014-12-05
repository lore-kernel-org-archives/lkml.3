Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaLETEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:04:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37698 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281AbaLETEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:04:50 -0500
Date: Fri, 5 Dec 2014 14:04:07 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: frequent lockups in 3.18rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <1417806247.4845.1@mail.thefacebook.com>
In-Reply-To: <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
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
	<20141205171501.GA1320@redhat.com>
	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-05_08:2014-12-05,2014-12-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=120.659590407225
 compositescore=0.140620555742602 urlsuspect_oldscore=0.140620555742602
 suspectscore=3 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.140620555742602 spamscore=0
 recipient_to_sender_domain_totalscore=8 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412050161
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Dec 5, 2014 at 1:38 PM, Linus Torvalds 
<torvalds@linux-foundation.org> wrote:
> On Fri, Dec 5, 2014 at 9:15 AM, Dave Jones <davej@redhat.com> wrote:
>> 
>>  A bisect later, and I landed on a kernel that ran for a day, before
>>  spewing NMI messages, recovering, and then..
>> 
>>  
>> https://urldefense.proofpoint.com/v1/url?u=http://codemonkey.org.uk/junk/log.txt&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=APfD8%2BRkGVsO9UHnH6Oo05Zuoh90VyaaF71AycsnLbQ%3D%0A&s=de71b34f3a7da1c7b8f12dcd760c271657f9f7e2a93b4d2e296b2c687cee5157
> 
> I have to admit I'm seeing absolutely nothing sensible in there.
> 
> Call it bad, and see if bisection ends up slowly -oh so slowly -
> pointing to some direction. Because I don't think it's the hardware,
> considering that apparently 3.16 is solid. And the spews themselves
> are so incomprehensible that I'm not seeing any pattern what-so-ever.

I went back through all of the traces Dave has posted in this thread.  
This one looks like vm debugging is on:

 http://marc.info/?l=linux-kernel&m=141632237304726&w=2

Another had a function call from CONFIG_DEBUG_PAGEALLOC:

http://marc.info/?l=linux-kernel&m=141701248210949&w=2

So one idea is that our allocation/freeing of pages is dramatically 
more expensive and we're hitting a strange edge condition.  Maybe we're 
even faulting on a readonly page from a horrible place?

[83246.925234] end_request: I/O error, dev sda, sector 0

Ext3/4 shouldn't be doing IO to sector zero.  Something is stomping on 
ram?

-chris

