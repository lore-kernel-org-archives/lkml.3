Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaLQC0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 21:26:36 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56089 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027AbaLQC0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 21:26:34 -0500
Date: Tue, 16 Dec 2014 18:26:03 -0800
From: Calvin Owens <calvinowens@fb.com>
To: <bp@alien8.de>
CC: <linux-edac@vger.kernel.org>, <tony.luck@intel.com>,
        <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <calvinowens@fb.com>
Subject: Re: [PATCH -v3 0/4] RAS: Correctable Errors Collector thing
Message-ID: <20141217022603.GB7152@mail.thefacebook.com>
References: <1404242623-10094-1-git-send-email-bp@alien8.de>
 <CAMY-HrCRS0RcBO0sMtwOKwYmS_+q89Kpr5Y0WyhpfQdapaQzLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CAMY-HrCRS0RcBO0sMtwOKwYmS_+q89Kpr5Y0WyhpfQdapaQzLA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-17_01:2014-12-17,2014-12-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=82.7090292742459
 compositescore=0.985663588404874 urlsuspect_oldscore=0.985663588404874
 suspectscore=1 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.985663588404874 spamscore=0
 recipient_to_sender_domain_totalscore=10 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412170024
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 12:23 PM, Borislav Petkov <bp@alien8.de> wrote:
> Ok,
>
> the next version.
>
> Main changes from the last one are that we have a ce_ring now to which
> MCEs get logged in atomic context first and then, in process context,
> put into the CEC, just like this is done with the mce_ring.
>
> Also, the decay of the elements in the CEC happens not after CLEAN_ELEMS
> insertions of new elements only but the incrementation of an already
> inserted element counts too. We want to do that because otherwise we're
> not fair in aging the elements.
>
> Constructive feedback is, as always, appreciated.
>
> Thanks.
>
> Changelog:
>
> so here's v2 with the feedback from last time addressed (... hopefully).
> This is ontop of Gong's extlog stuff which is currently a moving target
> but I've based this stuff on it as we're starting slowly to relocate
> generic RAS stuff into drivers/ras/.
>
> A couple of points I was thinking about which we should talk about:
>
> * This version automatically removes the oldest element from the array
> when it gets full. With 512 PFNs max size, I think we should be ok.
>
> * If CEC (let's call this thing that) can perform all RAS actions
> needed/required, we should not forward correctable errors to userspace
> because it simply doesn't need to. Unless there is something more we
> want to do in userspace... we could make it configurable, dunno.

Hmm. I can definitely imagine that in a scenario where you're testing
hardware you would want to know about all the corrected errors in
userspace. You could just tail dmesg watching for the message below, but
that's somewhat crappy.

Also, figuring out what physical DIMM on the motherboard a given
physical address is on is rather messy as I understand it, since it
varies between manufacturers. I'm not sure supporting that inside the
kernel is a good idea, so people who care about this would still need
some way to get the errors in userspace too.

> This version simply collects the errors and does the soft offlining,
> thus issuing to dmesg something like this:
>
> [  520.872376] RAS: Soft-offlining pfn: 0xdead
> [  520.874384] soft offline: 0xdead page already poisoned
>
> I'm not sure what we want to do with this info - we need to think about
> it more but we're flexible there so... :-)

Somehow exposing the array tracking the errors could be interesting,
although I'm not sure how useful that would actually be in practice.
That would also get more complicated as this starts to handle things
like corrected cache and bus errors.

> My main reasoning behind not forwarding each single correctable error
> is that we don't want to upset the user unnecessarily and cause those
> expensive support calls.
>
> * Concerning policy and at which error count we should soft-offline a
> page and whether we should make it configurable or not and what the
> interface would be: we still don't know and we probably need to talk
> about it too. Right now, using 10 bits for that count feels right. The
> count gets decayed anyway.

This should definitely be configurable IMO: different people will want
to manage this in different ways. We're very aggressive about offlining
pages with corrected errors, for example.

> But, do we need to run it on lotsa live systems and hear feedback?
> Definitely.

I'll keep an eye out for buggy machines to test on ;)

> * As to why we're putting this in the kernel and enabling it by default:
> a userspace daemon is much more fragile than doing this in the kernel.
> And regardless of distro, everyone gets this.

I very much agree.

Thanks,
Calvin

> Borislav Petkov (4):
>   x86, MCE: Make the mce_ring explicit
>   RAS: Add a Corrected Errors Collector
>   MCE, CE: Wire in the CE collector
>   MCE, CE: Add debugging glue
>
>  arch/x86/kernel/cpu/mcheck/mce.c | 132 +++++++++++++---
>  drivers/ras/Kconfig              |  11 ++
>  drivers/ras/Makefile             |   3 +-
>  drivers/ras/ce.c                 | 322 +++++++++++++++++++++++++++++++++++++++
>  include/linux/ras.h              |   3 +
>  5 files changed, 450 insertions(+), 21 deletions(-)
>  create mode 100644 drivers/ras/ce.c
>
> --
> 2.0.0
