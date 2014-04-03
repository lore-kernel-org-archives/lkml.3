Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaDCTun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:50:43 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:3294 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbaDCTuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:50:40 -0400
Message-ID: <1396554637.2550.11.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc,shm: disable shmmax and shmall by default
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Greg Thelen <gthelen@google.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 03 Apr 2014 12:50:37 -0700
In-Reply-To: <533DB03D.7010308@colorfullife.com>
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
	 <20140331170546.3b3e72f0.akpm@linux-foundation.org>
	 <1396371699.25314.11.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=qsf6vN5k=-PLraG8Q_uU1pofoBDktjVH1N92o76xPadQ@mail.gmail.com>
	 <1396377083.25314.17.camel@buesod1.americas.hpqcorp.net>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-03 at 21:02 +0200, Manfred Spraul wrote:
> Hi Davidlohr,
> 
> On 04/03/2014 02:20 AM, Davidlohr Bueso wrote:
> > The default size for shmmax is, and always has been, 32Mb.
> > Today, in the XXI century, it seems that this value is rather small,
> > making users have to increase it via sysctl, which can cause
> > unnecessary work and userspace application workarounds[1].
> >
> > Instead of choosing yet another arbitrary value, larger than 32Mb,
> > this patch disables the use of both shmmax and shmall by default,
> > allowing users to create segments of unlimited sizes. Users and
> > applications that already explicitly set these values through sysctl
> > are left untouched, and thus does not change any of the behavior.
> >
> > So a value of 0 bytes or pages, for shmmax and shmall, respectively,
> > implies unlimited memory, as opposed to disabling sysv shared memory.
> > This is safe as 0 cannot possibly be used previously as SHMMIN is
> > hardcoded to 1 and cannot be modified.

> Are we sure that no user space apps uses shmctl(IPC_INFO) and prints a 
> pretty error message if shmall is too small?
> We would break these apps.

Good point. 0 bytes/pages would definitely trigger an unexpected error
message if users did this. But on the other hand I'm not sure this
actually is a _real_ scenario, since upon overflow the value can still
end up being 0, which is totally bogus and would cause the same
breakage.

So I see two possible workarounds:
(i) Use ULONG_MAX for the shmmax default instead. This would make shmall
default to 1152921504606846720 and 268435456, for 64 and 32bit systems,
respectively.

(ii) Keep the 0 bytes, but add a new a "transition" tunable that, if set
(default off), would allow 0 bytes to be unlimited. With time, users
could hopefully update their applications and we could eventually get
rid of it. This _seems_ to be the less aggressive way to go.

Thoughts?

Thanks,
Davidlohr

