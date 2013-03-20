Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3CTRuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:50:11 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:32969 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab3CTRuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:50:06 -0400
Message-ID: <1363801796.4280.24.camel@thor.lan>
Subject: Re: [PATCH 03/18] tty: Simplify tty buffer/ldisc interface with
 helper function
From: Peter Hurley <peter@hurleysoftware.com>
To: Ilya Zykov <linux@izyk.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Min Zhang <mzhang@mvista.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 13:49:56 -0400
In-Reply-To: <5149AFD0.8020604@izyk.ru>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
	  <1363724513-15604-4-git-send-email-peter@hurleysoftware.com>
	  <5148E9D2.4030305@izyk.ru> <1363737036.3413.49.camel@thor.lan>
	 <5149AFD0.8020604@izyk.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 16:47 +0400, Ilya Zykov wrote:
> >> I have little question about flush_to_ldisc().
> >> Does can it be multithreaded?
> >>
> >> I think yes, because on SMP schedule_work() can work on different CPU paralleled.
> > 
> > Yes, the same work item can now run in parallel on SMP since Tejun Heo
> > re-did the workqueue implementation on 2.6.36 [Stefan Richter, the
> > firewire maintainer, recently explained this history to me].
> 
> About multi threaded delayed works:
> 
> In many cases tty layer needs single threaded delayed work for each tty instance.
> I propose discussion about create for this purpose (tty layer)'s workqueue with WQ_NON_REENTRANT flag.
> And use it instead common schedule_work()'s workqueue - system_wq.
> I don't know how expensive(for system resource and CPU) it can be,
> but for tty layer, it can be very useful.

Ok. I agree it makes sense to explore the possible benefit.

There is another potential drawback to using non-reentrant workqueues.

The motivation for changing the workqueue api to allow parallel work
items on SMP was to fix a class of deadlocks where forward progress
could not be made due to subtle dependencies between work items
(actually that potential still exists with self-modifying work-items,
ie., work items that change their function).

The tty layer would need a detailed and thorough analysis of potential
dependencies to avoid creating problems. The drivers that use work items
might need examination as well.

Regards,
Peter Hurley


