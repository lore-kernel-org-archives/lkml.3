Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3BRPkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:40:43 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:43342 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab3BRPkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:40:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAKfTPtC3c50yo8AcQ7K9m73gP95dEsetjbhNXDN4RiR-nZ8UqA@mail.gmail.com>
References: <1359455940-1710-1-git-send-email-vincent.guittot@linaro.org>
	<1359455940-1710-2-git-send-email-vincent.guittot@linaro.org>
	<CAFTL4hzboD8Mv_-pRDHc+39QwXGWiT3MGtL8gJ=_ajnHdDCBcA@mail.gmail.com>
	<CAKfTPtD2jRke2CUXiJdmaYYki_Voi4eTqJKgsyTnRpna7p8mJg@mail.gmail.com>
	<CAFTL4hzriJm1mK1A_9U5kX9Z0RCMGpxy8M3gKuzFtt9Bky5htQ@mail.gmail.com>
	<CAKfTPtCWudftS2XSM1OC2sR050mYvcAU6Fkt0vjV=C2V+w84Ew@mail.gmail.com>
	<CAFTL4hzu-7uAXLqP+J48DaqLUYQWTESMNwPMYiiwrU2ZoOsgqw@mail.gmail.com>
	<CAFTL4hyR=_ftCxycyvCBR0xwj6aOix9op40ps7htogpkkqVz+A@mail.gmail.com>
	<CAKfTPtC3c50yo8AcQ7K9m73gP95dEsetjbhNXDN4RiR-nZ8UqA@mail.gmail.com>
Date: Mon, 18 Feb 2013 16:40:40 +0100
Message-ID: <CAFTL4hxxWBfi5Ad+X27ouFDFBM-LttRJiEn3f83T1Q2z=v1k7g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] sched: fix init NOHZ_IDLE flag
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, Mike Galbraith <efault@gmx.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/18 Vincent Guittot <vincent.guittot@linaro.org>:
> On 18 February 2013 15:38, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> I pasted the original at: http://pastebin.com/DMm5U8J8
>
> We can clear the idle flag only in the nohz_kick_needed which will not
> be called if the sched_domain is NULL so the sequence will be
>
> = CPU 0 =                                            = CPU 1=
>
> detach_and_destroy_domain {
>             rcu_assign_pointer(cpu1_dom, NULL);
> }
>
> dom = new_domain(...) {
>              nr_cpus_busy = 0;
>              set_idle(CPU 1);
> }
>                                                     dom =
> rcu_dereference(cpu1_dom)
>                                                     //dom == NULL, return
>
> rcu_assign_pointer(cpu1_dom, dom);
>
>                                                     dom =
> rcu_dereference(cpu1_dom)
>                                                     //dom != NULL,
>                                                     nohz_kick_needed {
>
> set_idle(CPU 1)
>                                                                    dom
> = rcu_dereference(cpu1_dom)
>
> //dec nr_cpus_busy,
>                                                     }
>
> Vincent

Ok but CPU 0 can assign NULL to the domain of cpu1 while CPU 1 is
already in the middle of nohz_kick_needed().
