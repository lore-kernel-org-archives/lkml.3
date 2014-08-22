Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbaHVHmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:42:31 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59383 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbaHVHma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:42:30 -0400
Date: Fri, 22 Aug 2014 09:42:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jason Wang <jasowang@redhat.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process is
 runnable
Message-ID: <20140822074224.GB7372@gmail.com>
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com>
 <1408608310-13579-2-git-send-email-jasowang@redhat.com>
 <1408683665.5648.69.camel@marge.simpson.net>
 <53F6F14B.1030609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F6F14B.1030609@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Wang <jasowang@redhat.com> wrote:

> Polling could be done by either rx busy loop in process 
> context or NAPI in softirq. [...]

Note that this shows another reason why it's a bad idea to 
query nr_running directly: depending on the softirq processing 
method, a softirq might run:

 - directly in process context
 - in an idle thread's context
 - or in a ksoftirqd context. 

'nr_running' will have different values in these cases, causing 
assymetries in busy-poll handling!

Another class of assymetry is when there are other softirq bits 
pending, beyond NET_RX (or NET_TX): a nr_running check misses 
them.

The solution I outlined in the previous mail (using a 
sched_expected_runtime() method) would be able to avoid most of 
these artifacts.

Thanks,

	Ingo
