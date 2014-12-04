Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbaLDO6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:58:15 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10409 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932285AbaLDO6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:58:14 -0500
Date: Thu, 4 Dec 2014 09:57:29 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: frequent lockups in 3.18rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <1417705049.21214.3@mail.thefacebook.com>
In-Reply-To: <CA+55aFz-QhQOQuFPKbxBDAOjJ+fR02m3-unA4iD9kLwhWS38cA@mail.gmail.com>
References: <20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141203190045.GB32005@redhat.com>
	<CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>
	<CANcMJZA1NXUMLEveA2k5njFnWc1pCSwSeAOQH7VQCOR-QtiR8g@mail.gmail.com>
	<alpine.DEB.2.11.1412032137210.16275@nanos>
	<20141204031553.GA20193@ret.masoncoding.com>
	<CA+55aFz-QhQOQuFPKbxBDAOjJ+fR02m3-unA4iD9kLwhWS38cA@mail.gmail.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-04_06:2014-12-04,2014-12-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=42.9673870319736
 compositescore=0.182402046397986 urlsuspect_oldscore=0.182402046397986
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.182402046397986 spamscore=0
 recipient_to_sender_domain_totalscore=29 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412040140
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, Dec 4, 2014 at 12:49 AM, Linus Torvalds 
<torvalds@linux-foundation.org> wrote:
> On Wed, Dec 3, 2014 at 7:15 PM, Chris Mason <clm@fb.com> wrote:
>> 
>>  One guess is that trinity is generating a huge number of tlb
>>  invalidations over sparse and horrible ranges.  Perhaps the old 
>> code was
>>  falling back to full tlb flushes before Dave Hansen's string of 
>> fixes?
> 
> Hmm. I agree that we've had some of the backtraces look like TLB
> flushing might be involved. Not all, though. And I'm not seeing where
> a loop over up to 33 pages should matter over doing a full TLB flush.
> 
> What *might* matter is if we somehow get that number wrong, and the 
> loops like
> 
>                         addr = f->flush_start;
>                         while (addr < f->flush_end) {
>                                 __flush_tlb_single(addr);
>                                 addr += PAGE_SIZE;
>                         }
> 
> ends up looping a *lot* due to some bug, and then the IPI itself would
> take so long that the watchdog could trigger.
> 
> But I do not see how that could actually happen. As far as I can tell,
> either the number of pages is limited to less than 33, or we have that
>  TLB_FLUSH_ALL case.
> 
> Do  you see something I don't?

Sadly not.  Looking harder, I'm pretty sure all of the flushes coming 
through from this path are single page flushes anyway.  So the most 
likely explanation is that we're waiting on the remote CPU, who is 
stuck somewhere secret.

-chris



