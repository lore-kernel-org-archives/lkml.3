Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab3HARYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:24:11 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:56605 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3HARYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:24:08 -0400
MIME-Version: 1.0
In-Reply-To: <51FA7DCB.5090201@linux.vnet.ibm.com>
References: <2362640.pUofnXyzOi@vostro.rjw.lan>
	<51FA1818.2050203@linux.vnet.ibm.com>
	<CAKohponkEWs2r5ibR8RTAN6D2LfNfDB7bvy1nqdTN4C3jQHdJA@mail.gmail.com>
	<51FA7DCB.5090201@linux.vnet.ibm.com>
Date: Thu, 1 Aug 2013 22:54:08 +0530
Message-ID: <CAKohpokdZ=JE8riYxJd+abfaDo6RfqnOjNpbFkb+ph_E-O6L_A@mail.gmail.com>
Subject: Re: [RFC][PATCH] cpufreq: Do not hold driver module references for
 additional policy CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 August 2013 20:54, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Well, I now agree that we don't have to keep the module refcount
> non-zero as long as CPUs are being managed (that was just my
> misunderstanding, sorry for the noise). However, I think the _get()
> and _put() used in the existing code is for synchronization: that
> is, to avoid races between trying to unload the cpufreq driver
> module and running a hotplug notifier (and calling the driver module's
> ->init() or ->exit() function).
>
> With that being the case, I think we can retain the module refcounts
> and use them only for synchronization. And naturally the refcount
> should drop to zero after the critical section; no point keeping
> it incremented until the CPU is taken offline.
>
> Or, am I confused again?

No, you aren't.

But, for synchronization we need some blocking stuff, so that when
user tries to rmmod the module, it should wait until other critical
sections are over and then unload the module. But here, we are
simply returning from rmmod, saying that we are busy :)

So, for that kind of synchronization we better use locks available
inside cpufreq core of if required another variable which can be
used for refcount. But now this.
