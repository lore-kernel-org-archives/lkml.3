Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab3HAR7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:59:43 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50824 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab3HAR7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:59:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH] cpufreq: Do not hold driver module references for additional policy CPUs
Date: Thu, 01 Aug 2013 20:09:54 +0200
Message-ID: <32010862.oheqlHkN6u@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpokdZ=JE8riYxJd+abfaDo6RfqnOjNpbFkb+ph_E-O6L_A@mail.gmail.com>
References: <2362640.pUofnXyzOi@vostro.rjw.lan> <51FA7DCB.5090201@linux.vnet.ibm.com> <CAKohpokdZ=JE8riYxJd+abfaDo6RfqnOjNpbFkb+ph_E-O6L_A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 01, 2013 10:54:08 PM Viresh Kumar wrote:
> On 1 August 2013 20:54, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> > Well, I now agree that we don't have to keep the module refcount
> > non-zero as long as CPUs are being managed (that was just my
> > misunderstanding, sorry for the noise). However, I think the _get()
> > and _put() used in the existing code is for synchronization: that
> > is, to avoid races between trying to unload the cpufreq driver
> > module and running a hotplug notifier (and calling the driver module's
> > ->init() or ->exit() function).
> >
> > With that being the case, I think we can retain the module refcounts
> > and use them only for synchronization. And naturally the refcount
> > should drop to zero after the critical section; no point keeping
> > it incremented until the CPU is taken offline.
> >
> > Or, am I confused again?
> 
> No, you aren't.
> 
> But, for synchronization we need some blocking stuff, so that when
> user tries to rmmod the module, it should wait until other critical
> sections are over and then unload the module. But here, we are
> simply returning from rmmod, saying that we are busy :)
> 
> So, for that kind of synchronization we better use locks available
> inside cpufreq core of if required another variable which can be
> used for refcount. But now this.

I suppose you wanted to say "But not this"?

I agree.  That said the situation now is that for acpi-cpufreq the module
usage count is 0 (as of linux-next from today), so you can actually rmmod it.

I don't see why it should be different in the case when there are multiple
CPUs for the same policy and hence my patch.  [I don't see the problem with
it as I said to my reply to Srivatsa, so care to explain it to me?.]

Now it seems to me that the code *is* racy (I haven't verified that, though),
so I agree that we should use some other synchronization framework to be able
to rmmod and modprobe cpufreq drivers safely.  Using the driver module usage
counter for that is not quite correct in my view.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
