Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaE1XAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:00:32 -0400
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:54962 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751128AbaE1XA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:00:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:560:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:7576:7652:7904:8603:9036:10004:10400:10471:10848:11026:11232:11658:11914:12043:12438:12517:12519:12663:12740:13069:13101:13138:13161:13229:13231:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: board15_3f1737297204
X-Filterd-Recvd-Size: 3056
Message-ID: <1401318025.19335.15.camel@joe-AO725>
Subject: Re: [PATCH 11/16] byteorder: provide a linux/byteorder.h with {be,
 le}_to_cpu() and cpu_to_{be, le}() macros
From: Joe Perches <joe@perches.com>
To: Cody P Schafer <dev@codyps.com>
Cc: David Laight <David.Laight@aculab.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 28 May 2014 16:00:25 -0700
In-Reply-To: <CAPoQQ-11vW3Q0=LcS-myNZ6hXeYBeu==_prwHJXHvLfkUSmZHQ@mail.gmail.com>
References: <1401236684-10579-1-git-send-email-dev@codyps.com>
	 <1401236684-10579-12-git-send-email-dev@codyps.com>
	 <063D6719AE5E284EB5DD2968C1650D6D1724EEAF@AcuExch.aculab.com>
	 <CAPoQQ-17OHotfbczJvEoq=vAzu_+6-sV3M1ZAhDaQ45wB3NB4A@mail.gmail.com>
	 <CAPoQQ-11vW3Q0=LcS-myNZ6hXeYBeu==_prwHJXHvLfkUSmZHQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 17:11 -0500, Cody P Schafer wrote:
> On Wed, May 28, 2014 at 5:05 PM, Cody P Schafer <dev@codyps.com> wrote:
> > On Wed, May 28, 2014 at 3:45 AM, David Laight <David.Laight@aculab.com> wrote:
> >> From: Cody P Schafer
> >>> Rather manually specifying the size of the integer to be converted, key
> >>> off of the type size. Reduces duplicate size info and the occurance of
> >>> certain types of bugs (using the wrong sized conversion).
> >> ...
> >>> +#define be_to_cpu(v) \
> >>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint8_t) , v, \
> >>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint16_t), be16_to_cpu(v), \
> >>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint32_t), be32_to_cpu(v), \
> >>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint64_t), be64_to_cpu(v), \
> >>> +             (void)0))))
> >> ...
> >>
> >> I'm not at all sure that using the 'size' of the constant will reduce
> >> the number of bugs - it just introduces a whole new category of bugs.
> >
> > Certainly, if you mis-size the argument (and thus have missized one of
> > the variables containing the be value, probably a bug anyhow), there
> > will be problems.
> >
> > I put this interface together because of an actual bug I wrote into
> > the initial code of the hv_24x7 driver (resized a struct member
> > without adjusting the be*_to_cpu() sizing).
> > Having this "auto sizing" macro means I can avoid encoding the size of
> > a struct field in multiple places.
> 
> To clarify, the point I'm making here is that this simply cuts out 1
> more place we can screw up endianness conversion sizing.

It does screw up other types when you do things like:

	u8 foo = some_function();

	cpu_to_be(foo + 1);

the return value is sizeof(int) not u8


