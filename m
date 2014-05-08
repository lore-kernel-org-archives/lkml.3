Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbaEHTAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:00:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:45362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbaEHTAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:00:09 -0400
Date: Thu, 8 May 2014 21:00:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 07/19] qspinlock: Use a simple write to grab the
 lock, if applicable
Message-ID: <20140508190004.GO2844@laptop.programming.kicks-ass.net>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-8-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1399474907-22206-8-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 11:01:35AM -0400, Waiman Long wrote:
> @@ -94,23 +94,29 @@ static inline struct mcs_spinlock *decode_tail(u32 tail)
>   * can allow better optimization of the lock acquisition for the pending
>   * bit holder.
>   */
> -#if _Q_PENDING_BITS == 8
> -
>  struct __qspinlock {
>  	union {
>  		atomic_t val;
> -		struct {
>  #ifdef __LITTLE_ENDIAN
> +		u8	 locked;
> +		struct {
>  			u16	locked_pending;
>  			u16	tail;
> +		};
>  #else
> +		struct {
>  			u16	tail;
>  			u16	locked_pending;
> -#endif
>  		};
> +		struct {
> +			u8	reserved[3];
> +			u8	locked;
> +		};
> +#endif
>  	};
>  };
>  
> +#if _Q_PENDING_BITS == 8

That doesn't make sense, that struct __qspinlock only makes sense when
_Q_PENDING_BITS == 8.
