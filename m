Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaIYUfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 16:35:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:40951 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaIYUf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 16:35:26 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lina Iyer <lina.iyer@linaro.org>, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        daniel.lezcano@linaro.org
Subject: Re: [PATCH v3 3/4] irq: Allow multiple clients to register for irq affinity notification
References: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org>
	<1409170479-29955-4-git-send-email-lina.iyer@linaro.org>
	<alpine.DEB.2.10.1408272239190.3323@nanos>
	<20140902184305.GB91995@ilina-mac.local>
	<alpine.DEB.2.10.1409022109050.3333@nanos>
Date: Thu, 25 Sep 2014 13:35:24 -0700
In-Reply-To: <alpine.DEB.2.10.1409022109050.3333@nanos> (Thomas Gleixner's
	message of "Tue, 2 Sep 2014 22:56:17 +0200 (CEST)")
Message-ID: <7htx3vbfqr.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thomas Gleixner <tglx@linutronix.de> writes:

[...]

> All I can see from your postings so far is:
>
>     1) You want to use the notification for PM QoS
>
>     2) You run into conflicts with the existing notifiers
>
>     3) You want to solve that conflict
>
> What you are not telling is:
>
>     1) In which way is PM QoS going to use that notifier
>
>     2) How does that conflict with the existing users. And we only
>        have two of them:
>
>        - InfiniPath 7322 chip driver
>
>        - cpu_rmap driver, which is used by
>        	- solarflare NIC driver
> 		- mellanox mlx4 driver
>	 	- cisco enic driver
>
> 	So how is that conflicting with your ARM centric PM QoS work?
>
> 	Please provide proper debug info about such a conflict, if it
> 	exists at all.

Ignoring any new users of the affinity notifiers for now, aren't the
existing users you list above conflicting with each other already?

Maybe I'm missing something, or maybe we're just lucky and nobody uses
them together, but irq_set_affinity_notifier() only allows a single
notifier to be registered at any given time.  So if you had a system
with the inifinipath driver and a cpu_rmap user, only the one who's
lucky enough to be the last to call irq_set_affinity_notifier() will
ever be notified.

So I think the main question for Lina is: assuming we need more than one
co-existing driver/subsystem to get IRQ affinity notifiers (and we
already seem to have them, but are lucky they don't currently co-exist),
how should the IRQ core be changed to support that?  Is the list
approach proposed in $SUBJECT path reasonable?

Kevin
