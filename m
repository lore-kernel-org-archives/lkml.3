Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaGWEVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 00:21:43 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52757 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaGWEVl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 00:21:41 -0400
MIME-Version: 1.0
In-Reply-To: <53CF31AE.30403@daenzer.net>
References: <53C77BB8.6030804@daenzer.net>
	<20140717075820.GE19379@twins.programming.kicks-ass.net>
	<53C8E90F.1010306@daenzer.net>
	<53CE00EF.70108@daenzer.net>
	<53CF31AE.30403@daenzer.net>
Date: Tue, 22 Jul 2014 21:21:40 -0700
X-Google-Sender-Auth: o1j-Txjd01LXe4aOfk-8kzUVyzw
Message-ID: <CA+55aFwyURgG717kmuAXzKcHddN_63GirtwHZB4ePKH+8qVtJw@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 8:53 PM, Michel Dänzer <michel@daenzer.net> wrote:
>
> Just happened again with the same change on top of 3.16-rc6.

The (maybe) related bugzilla entry is just odd. Bruno Wolff reports
that the BUG_ON() in his added patch triggers:

+               cpumask_clear(sched_group_cpus(sg));
+               sg->sgc->capacity = 0;
+               BUG_ON(!cpumask_empty(sched_group_cpus(sg)));

where it *just* did a cpumask_clear(), and now the BUG_ON() triggers
that it's no longer empty?

That would imply an allocation error, but all the sched groups seem to
be properly allocated with the proper addition of cpumask_size().

And his config file even has NR_CPUS being 32, so it should be a
single word of bitmap, which triggers all the simple code.

Completely insane, in other words.

           Linus
