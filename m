Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab3KFPL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:11:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58668 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3KFPL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:11:27 -0500
Date: Wed, 6 Nov 2013 16:10:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: mingo@kernel.org, hpa@zytor.com, anton@samba.org,
        mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, fweisbec@gmail.com, VICTORK@il.ibm.com,
        tglx@linutronix.de, oleg@redhat.com, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] tools/perf: Add required memory barriers
Message-ID: <20131106151055.GQ10651@twins.programming.kicks-ass.net>
References: <20131030104246.GH16117@laptop.programming.kicks-ass.net>
 <tip-a94d342b9cb09edfe888ea972af0883b6a8d992b@git.kernel.org>
 <alpine.DEB.2.02.1311060847340.27224@pianoman.cluster.toy>
 <20131106140011.GL10651@twins.programming.kicks-ass.net>
 <20131106142840.GH26785@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1311060938220.27607@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311060938220.27607@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 09:55:17AM -0500, Vince Weaver wrote:
> Having perf in the kernel tree really makes it hard for you guys to keep a
> clean API/ABI it seems.

Lock free buffers are 'fun'.. The ABI can be described as:

  read pc->data_head

  // ensure no other reads get before this point and ->data_head
  // doesn't get re-read hereafter.

  read data; using pc->data_tail, until the read head value.

  // ensure all reads are completed before issuing

  write pc->data_tail

How you want to implement that on your compiler/arch combination is up
to you. Like said, C11 has the __atomic bits you can use to implement
this in proper C; barring that, you'll have to get creative and use
assembly one way or another.

On x86/sparc/s390 which have relatively strong memory models its fairly
easy, on powerpc/arm which have much weaker models its more fun.


This isn't actually something that has changed; its just that we
recently found some implementations thereof were buggy.

We provide an implementation in GNU C, if you want to use something else
you get to deal with that other compiler.
