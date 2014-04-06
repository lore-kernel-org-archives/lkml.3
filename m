Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaDFQyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 12:54:45 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:15456 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbaDFQym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 12:54:42 -0400
Message-ID: <1396803278.2461.12.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc,shm: disable shmmax and shmall by default
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Greg Thelen <gthelen@google.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Sun, 06 Apr 2014 09:54:38 -0700
In-Reply-To: <5340F73A.6090600@colorfullife.com>
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=rLLBDr5ptLMvFD-M+TPQSnK3EP=7R+27K8or84rY-KLA@mail.gmail.com>
	 <1396386062.25314.24.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=rhXrBQSmDBJJ-vPxBbhjJ91Fh2iWe1cf_UQd-tCfpb2w@mail.gmail.com>
	 <20140401142947.927642a408d84df27d581e36@linux-foundation.org>
	 <CAHGf_=p70rLOYwP2OgtK+2b+41=GwMA9R=rZYBqRr1w_O5UnKA@mail.gmail.com>
	 <20140401144801.603c288674ab8f417b42a043@linux-foundation.org>
	 <CAHGf_=r5AUu6yvJgOzwYDghBo6iT2q+nNumpvqwer+igcfChrA@mail.gmail.com>
	 <1396394931.25314.34.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=rH+vfFzRrh35TETxjFU2HM0xnDQFweQ+Bfw20Pm2nL3g@mail.gmail.com>
	 <1396484447.2953.1.camel@buesod1.americas.hpqcorp.net>
	 <533DB03D.7010308@colorfullife.com>
	 <1396554637.2550.11.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=rT7WswD0LOxVeDDpae-Ahaz4wEcpE8HLmDwOBw598z8g@mail.gmail.com>
	 <1396587632.2499.5.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=pvN96SgLYdR3jPn8VaEfAjq-LX=r=PQRvPGqi6xFJoxQ@mail.gmail.com>
	 <5340F73A.6090600@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-06 at 08:42 +0200, Manfred Spraul wrote:
> Hi,
> 
> On 04/05/2014 08:24 PM, KOSAKI Motohiro wrote:
> > On Fri, Apr 4, 2014 at 1:00 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >> I don't think it makes much sense to set unlimited for both 0 and
> >> ULONG_MAX, that would probably just create even more confusion.
> I agree.
> Unlimited was INT_MAX since 0.99.10 and ULONG_MAX since 2.3.39 (with 
> proper backward compatibility for user space).
> 
> Adding a second value for unlimited just creates confusion.
> >> But then again, we shouldn't even care about breaking things with shmmax
> >> or shmall with 0 value, it just makes no sense from a user PoV. shmmax
> >> cannot be 0 unless there's an overflow, which voids any valid cases, and
> >> thus shmall cannot be 0 either as it would go against any values set for
> >> shmmax. I think it's safe to ignore this.
> > Agreed.
> > IMHO, until you find out any incompatibility issue of this, we don't
> > need the switch
> > because we can't make good workaround for that. I'd suggest to merge your patch
> > and see what happen.
> I disagree:
> - "shmctl(,IPC_INFO,&buf); if (my_memory_size > buf.shmmax) 
> perror("change shmmax");" worked correctly since 0.99.10. I don't think 
> that merging the patch and seeing what happens is the right approach.

I agree, we *must* get this right the first time. So no rushing into
things that might later come and bite us in the future.

That said, if users are doing that kind of check, then they must also
check against shmmin, which has _always_ been 1. So shmmax == 0 is a no
no. Otherwise it's not the kernel's fault that they're misusing the API,
which IMO is pretty straightforward for such things. And if shmmax
cannot be 0, shmall cannot be 0.

> - setting shmmax by default to ULONG_MAX is the perfect workaround.
> 
> What reasons are there against the one-line patch?

There's really nothing wrong with it, it's just that 0 is a much nicer
value to have for 'unlimited'. And if we can get away with it, then
lets, otherwise yes, we should go with this path.



