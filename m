Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab3BSJ6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:58:09 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:48233 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213Ab3BSJ6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:58:05 -0500
Message-ID: <51234C23.2030909@linux.vnet.ibm.com>
Date: Tue, 19 Feb 2013 15:25:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        rjw@sisk.pl, sbw@mit.edu, fweisbec@gmail.com, linux@arm.linux.org.uk,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        vincent.guittot@linaro.org
Subject: Re: [PATCH v6 08/46] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
References: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com> <20130218123920.26245.56709.stgit@srivatsabhat.in.ibm.com> <CANN689HhVxDv+3Bn9UAxOMzj0egTvVp_c7oAmQ2nnQ8Xjn_aMA@mail.gmail.com> <51225A36.40600@linux.vnet.ibm.com> <CANN689FJPLfz06MFRJ9T+BuToejAzjYP_yrw_H4iGi1Kb3p2-g@mail.gmail.com> <51227810.6090009@linux.vnet.ibm.com> <CANN689E-98zK69pGeojbm30n3sswQYVBvhk3i3OzqvbeqSrSrg@mail.gmail.com>
In-Reply-To: <CANN689E-98zK69pGeojbm30n3sswQYVBvhk3i3OzqvbeqSrSrg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021909-1618-0000-0000-0000035D7A43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 03:10 PM, Michel Lespinasse wrote:
> On Tue, Feb 19, 2013 at 2:50 AM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> But, the whole intention behind removing the parts depending on the
>> recursive property of rwlocks would be to make it easier to make rwlocks
>> fair (going forward) right? Then, that won't work for CPU hotplug, because,
>> just like we have a legitimate reason to have recursive
>> get_online_cpus_atomic(), we also have a legitimate reason to have
>> unfairness in locking (i.e., for deadlock-safety). So we simply can't
>> afford to make the locking fair - we'll end up in too many deadlock
>> possibilities, as hinted in the changelog of patch 1.
> 
> Grumpf - I hadn't realized that making the underlying rwlock fair
> would break your hotplug use case. But you are right, it would. Oh
> well :/
> 

Yeah :-/

>> So the only long-term solution I can think of is to decouple
>> percpu-rwlocks and rwlock_t (like what Tejun suggested) by implementing
>> our own unfair locking scheme inside. What do you think?
> 
> I have no idea how hard would it be to change get_online_cpus_atomic()
> call sites so that the hotplug rwlock read side has a defined order vs
> other locks (thus making sure the situation you describe in patch 1
> doesn't happen). I agree we shouldn't base our short term plans around
> that, but maybe that's doable in the long term ???
>

I think it should be possible in the longer term. I'm expecting it to be
*much much* harder to audit and convert (requiring a lot of subsystem
knowledge of each subsystem that we are touching), than the simpler
tree-wide conversion that I did in this patchset... but I don't think it
is impossible.
 
> Otherwise, I think we should add some big-fat-warning that percpu
> rwlocks don't have reader/writer fairness, that the hotplug use case
> actually depends on the unfairness / would break if the rwlock was
> made fair, and that any new uses of percpu rwlocks should be very
> carefully considered because of the reader/writer fairness issues.

In fact, when I started out, I actually contained all the new locking code
inside CPU hotplug itself, and didn't even expose it as a generic percpu
rwlock in some of the previous versions of this patchset... :-)

But now that we already have a generic locking scheme exposed, we could
add a warning against using it without due consideration.

> Maybe even give percpu rwlocks a less generic sounding name, given how
> constrained they are by the hotplug use case.
 
I wouldn't go that far... ;-) Unfairness is not a show-stopper right?
IMHO, the warning/documentation should suffice for anybody wanting to
try out this locking scheme for other use-cases.

Regards,
Srivatsa S. Bhat

