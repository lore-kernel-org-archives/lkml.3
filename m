Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3ESMeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 08:34:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22274 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3ESMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 08:34:09 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=VaqywNGxpRkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=l0Yg3AS2bs0A:10 a=Yl-b3-1lNjR0Stw38eQA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368966844.6828.111.camel@gandalf.local.home>
Subject: Re: [PATCH v2 10/10] kernel: might_fault does not imply might_sleep
From: Steven Rostedt <rostedt@goodmis.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        microblaze-uclinux@itee.uq.edu.au, linux-am33-list@redhat.com,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, kvm@vger.kernel.org
Date: Sun, 19 May 2013 08:34:04 -0400
In-Reply-To: <20130519093526.GD19883@redhat.com>
References: <cover.1368702323.git.mst@redhat.com>
	 <1f85dc8e6a0149677563a2dfb4cef9a9c7eaa391.1368702323.git.mst@redhat.com>
	 <20130516184041.GP19669@dyad.programming.kicks-ass.net>
	 <20130519093526.GD19883@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-05-19 at 12:35 +0300, Michael S. Tsirkin wrote:

> No, I was not assuming that. What I'm trying to say is that a caller
> that does something like this under a spinlock:
> 	preempt_disable
> 	pagefault_disable
> 	error = copy_to_user
> 	pagefault_enable
> 	preempt_enable_no_resched
> 
> is not doing anything wrong and should not get a warning,
> as long as error is handled correctly later.
> Right?
> 

What I see wrong with the above is the preempt_enable_no_resched(). The
only place that should be ever used is right before a schedule(), as you
don't want to schedule twice (once for the preempt_enable() and then
again for the schedule itself).

Remember, in -rt, a spin lock does not disable preemption.

-- Steve


