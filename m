Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab3BTQuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:50:24 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:44882 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab3BTQuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:50:23 -0500
MIME-Version: 1.0
In-Reply-To: <51248E59.2010907@intel.com>
References: <1360377937-16297-1-git-send-email-walken@google.com>
	<511B9B4F.3060404@intel.com>
	<20130213144932.GA14260@gmail.com>
	<CANN689FJcUZq1wcVZXO+jLOHOeCPnOf5kfYgYVykG6-YLSjj7g@mail.gmail.com>
	<51248E59.2010907@intel.com>
Date: Thu, 21 Feb 2013 00:50:22 +0800
Message-ID: <CANN689HrFcBurM03XxjHTS14pAMu40mY50nKvzCb__ASQ+NM2w@mail.gmail.com>
Subject: Re: [PATCH 0/4] rwsem: Implement writer lock-stealing
From: Michel Lespinasse <walken@google.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        anton@samba.org, hpa@zytor.com, arjan@linux.intel.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        yuanhan.liu@linux.intel.com, dhowells@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 4:50 PM, Alex Shi <alex.shi@intel.com> wrote:
> I did a quick review on the patchset and tested the patches 1~3, and 1~3
> plus 4th, my patch plus 4th.
>
> The patch looks much complicated, and also goes writing slow path to
> steal locking. My patch looks quite straight and simple.
>
> This 1~3 patch has very very similar performance effect with mine.
>
> The highlight patch is the 4th, seems it can provide about ~2% aim7
> performance gain(base on both of mine or patches 1~3) on my 4S NHM EX
> machine.

Thanks for doing these measurements.

I think we can keep patches 1-2 out of this discussion as they don't
have much complexity and don't have much to do with write stealing
either.

Patch 4 is where fast path write stealing is implemented; however
there are some parts of patch 3 that I think are required - the one I
have in mind right now is when waking readers, the existing code
assumes that writers can't get the lock while it counts how many
reader locks need to be granted. There are several solutions to that -
for example you could grant the first reader lock before counting how
many more you need, but that would result in longer code than in my
proposal. Either way, I believe if you go into fixing lib/rwsem.c to
account for the possibility of fast path lock stealing you'll end up
with something very similar to my proposed patch 3...

(This is kinda how I proceeded with this series, I wrote the fastpath
lock stealing first, then I thought about what's required to support
it in the slow path)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
