Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3EVL2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:28:31 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55820
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175Ab3EVL21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:28:27 -0400
Date: Wed, 22 May 2013 13:27:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org, microblaze-uclinux@itee.uq.edu.au,
        linux-am33-list@redhat.com, linuxppc-dev@lists.ozlabs.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 00/10] uaccess: better might_sleep/might_fault behavior
Message-ID: <20130522112736.GN18810@twins.programming.kicks-ass.net>
References: <cover.1368702323.git.mst@redhat.com>
 <201305221125.36284.arnd@arndb.de>
 <20130522101916.GM18810@twins.programming.kicks-ass.net>
 <20130522110729.GB5643@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522110729.GB5643@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 02:07:29PM +0300, Michael S. Tsirkin wrote:
> On Wed, May 22, 2013 at 12:19:16PM +0200, Peter Zijlstra wrote:
> > On Wed, May 22, 2013 at 11:25:36AM +0200, Arnd Bergmann wrote:
> > > Calling might_fault() for every __get_user/__put_user is rather expensive
> > > because it turns what should be a single instruction (plus fixup) into an
> > > external function call.
> > 
> > We could hide it all behind CONFIG_DEBUG_ATOMIC_SLEEP just like
> > might_sleep() is. I'm not sure there's a point to might_fault() when
> > might_sleep() is a NOP.
> 
> The patch that you posted gets pretty close.
> E.g. I'm testing this now:
> +#define might_fault() do { \
> +       if (_might_fault()) \
> +               __might_sleep(__FILE__, __LINE__, 0); \
> +       might_resched(); \
> +} while(0)
> 
> So if might_sleep is a NOP, __might_sleep and might_resched are NOPs
> so compiler will optimize this all out.
> 
> However, in a related thread, you pointed out that might_sleep is not a NOP if
> CONFIG_PREEMPT_VOLUNTARY is set, even without CONFIG_DEBUG_ATOMIC_SLEEP.

Oh crud yeah.. and you actually need that _might_fault() stuff for that
too. Bugger.

Yeah, I wouldn't know what the effects of dropping ita (for the copy
functions) would be, VOLUNTARY isn't a preemption mode I ever use (even
though it seems most distros default to it).


