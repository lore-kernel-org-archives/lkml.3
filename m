Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaLDPbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:31:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37919 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753982AbaLDPbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:31:37 -0500
Date: Thu, 4 Dec 2014 10:30:38 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: frequent lockups in 3.18rc4
To: Dave Hansen <dave.hansen@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Dave Jones <davej@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <1417707038.21214.4@mail.thefacebook.com>
In-Reply-To: <54807C31.7060709@intel.com>
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
	<54807C31.7060709@intel.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-04_06:2014-12-04,2014-12-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=56.7588500254951
 compositescore=0.140620555742602 urlsuspect_oldscore=0.140620555742602
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.140620555742602 spamscore=0
 recipient_to_sender_domain_totalscore=38 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412040143
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 10:22 AM, Dave Hansen <dave.hansen@intel.com> 
wrote:
> On 12/03/2014 09:49 PM, Linus Torvalds wrote:
>>  On Wed, Dec 3, 2014 at 7:15 PM, Chris Mason <clm@fb.com> wrote:
>>> 
>>>  One guess is that trinity is generating a huge number of tlb
>>>  invalidations over sparse and horrible ranges.  Perhaps the old 
>>> code was
>>>  falling back to full tlb flushes before Dave Hansen's string of 
>>> fixes?
>> 
>>  Hmm. I agree that we've had some of the backtraces look like TLB
>>  flushing might be involved. Not all, though. And I'm not seeing 
>> where
>>  a loop over up to 33 pages should matter over doing a full TLB 
>> flush.
>> 
>>  What *might* matter is if we somehow get that number wrong, and the 
>> loops like
>> 
>>                          addr = f->flush_start;
>>                          while (addr < f->flush_end) {
>>                                  __flush_tlb_single(addr);
>>                                  addr += PAGE_SIZE;
>>                          }
>> 
>>  ends up looping a *lot* due to some bug, and then the IPI itself 
>> would
>>  take so long that the watchdog could trigger.
>> 
>>  But I do not see how that could actually happen. As far as I can 
>> tell,
>>  either the number of pages is limited to less than 33, or we have 
>> that
>>   TLB_FLUSH_ALL case.
>> 
>>  Do  you see something I don't?
> 
> The one thing I _do_ see now is a missed TLB flush is we're flushing 
> one
> page at the end of the address space.  We'd overflow flush_end back so
> flush_end=0:
> 
>         if (!f->flush_end)
>                 f->flush_end = f->flush_start + PAGE_SIZE; <-- 
> overflow
> 
> and we'll never enter the while loop where we actually do the flush:
> 
>                         while (addr < f->flush_end) {
>                                 __flush_tlb_single(addr);
>                                 addr += PAGE_SIZE;
>                         }
> 
> But we have a hole up there on x86_64, so this will never happen in
> practice there.  It might theoretically apply to 32-bit, but this 
> still
> doesn't help with the bug.
> 
> Oh, and the tracepoint is spitting out bogus numbers because we need
> some parenthesis around the 'nr_pages' calculation.

Yeah, I didn't see any problems with your changes, but I was hoping 
that even a small change like doing 33 flushes at a time was pushing 
Dave's box just over the line.

-chris



