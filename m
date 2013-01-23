Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3AWItj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:49:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58262 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab3AWIti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:49:38 -0500
Message-ID: <1358930968.5752.123.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Wed, 23 Jan 2013 09:49:28 +0100
In-Reply-To: <50FF9F92.60202@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <1358155290.5631.19.camel@marge.simpson.net>
	 <50F79256.1010900@linux.vnet.ibm.com>
	 <1358654997.5743.17.camel@marge.simpson.net>
	 <50FCACE3.5000706@linux.vnet.ibm.com>
	 <1358743128.4994.33.camel@marge.simpson.net>
	 <50FCCCF5.30504@linux.vnet.ibm.com>
	 <1358750523.4994.55.camel@marge.simpson.net>
	 <1358752180.4994.65.camel@marge.simpson.net>
	 <50FCF212.3010504@linux.vnet.ibm.com>
	 <1358759355.4994.108.camel@marge.simpson.net>
	 <50FD08E1.8000302@linux.vnet.ibm.com>
	 <1358761496.4994.118.camel@marge.simpson.net>
	 <50FE0ADC.6060701@linux.vnet.ibm.com>
	 <1358841795.5782.255.camel@marge.simpson.net>
	 <50FE5433.1070801@linux.vnet.ibm.com>
	 <1358865692.5782.420.camel@marge.simpson.net>
	 <50FF4EA0.1070000@linux.vnet.ibm.com>
	 <1358915494.5752.46.camel@marge.simpson.net>
	 <50FF7086.4020509@linux.vnet.ibm.com>
	 <1358922520.5752.91.camel@marge.simpson.net>
	 <50FF8CD8.4060105@linux.vnet.ibm.com>
	 <1358929257.5752.109.camel@marge.simp! son.net>
	 <50FF9F92.60202@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:KM8++ejBkDyEzZzvl+EpxlALwMRnZ18dPWtv9z0jiR0
 BWznywBnQn6Kfw2X2VEaYRjB/HJC9kP51rrVGmZ2cghh7uD5Ex
 E126PytzH74HcHGtjyYE9azLzR3Ujt6xnjogxKY6rWOx6lpBUK
 7XNtJsi5zBefitpqTqi5PS55AscUz+S9Ki+FMJjTUSwFuckGf6
 ScLeNkaZ33fTi150uivYCxvGYd0c4ozHcwsVxBliz1V1uuH/7W
 U9ZXIkf+lWWuGNQQIh/ZhT2FoTmqqVeL0ShdJZ565mdt8L8xeL
 ZB5LGGKHgKnjC2N0rj5Sw/rzJ/JdV8pPeEdMqVxd2BaZL2CxRc
 f2nU5x/eTFJr4xNs4LDaDl7O6gdGHEK4+igqmSG5B12XMQ+0iE
 Fz/UmOURx7Lkw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 16:30 +0800, Michael Wang wrote: 
> On 01/23/2013 04:20 PM, Mike Galbraith wrote:
> > On Wed, 2013-01-23 at 15:10 +0800, Michael Wang wrote: 
> >> On 01/23/2013 02:28 PM, Mike Galbraith wrote:
> > 
> >>> Abbreviated test run:
> >>> Tasks    jobs/min  jti  jobs/min/task      real       cpu
> >>>   640   158044.01   81       246.9438     24.54    577.66   Wed Jan 23 07:14:33 2013
> >>>  1280    50434.33   39        39.4018    153.80   5737.57   Wed Jan 23 07:17:07 2013
> >>>  2560    47214.07   34        18.4430    328.58  12715.56   Wed Jan 23 07:22:36 2013
> >>
> >> So still not works... and not going to balance path while waking up will
> >> fix it, looks like that's the only choice if no error on balance path
> >> could be found...benchmark wins again, I'm feeling bad...
> >>
> >> I will conclude the info we collected and make a v3 later.
> > 
> > FWIW, I hacked virgin to do full balance if an idle CPU was not found,
> > leaving the preference to wake cache affine intact though, turned on
> > WAKE_BALANCE in all domains, and it did not collapse.  In fact, the high
> > load end, where the idle search will frequently be a waste of cycles,
> > actually improved a bit.  Things that make ya go hmmm.
> 
> Oh, does that means the old balance path is good while the new is really
> broken, I mean, compared this with the previously results, could we say
> that all the collapse was just caused by the change of balance path?

That's a good supposition.  I'll see if it holds.

Next, I'm going to try ripping select_idle_sibling() to tiny shreds,
twiddle the balance path a little to see if I can get rid of the bad
stuff for tbench, maybe make some good stuff for pgbench and ilk, ilk
_maybe_ including heavy duty remote network type loads.

There's gonna be some violent axe swinging here shortly.

-Mike

