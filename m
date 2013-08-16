Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3HPSDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:03:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:48248 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab3HPSDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:03:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,896,1367996400"; 
   d="scan'208";a="363788060"
Message-ID: <520E6951.2040909@intel.com>
Date: Fri, 16 Aug 2013 11:02:57 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alex Thorlton <athorlton@sgi.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH 5/8] mm: make clear_huge_page cache clear only around
 the fault address
References: <87wqo050fc.fsf@tassilo.jf.intel.com> <1376663644-153546-1-git-send-email-athorlton@sgi.com> <1376663644-153546-6-git-send-email-athorlton@sgi.com>
In-Reply-To: <1376663644-153546-6-git-send-email-athorlton@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 07:34 AM, Alex Thorlton wrote:
> +#if ARCH_HAS_USER_NOCACHE == 0
> +#define clear_user_highpage_nocache clear_user_highpage
> +#endif
...
>  		cond_resched();
> -		clear_user_highpage(p, addr + i * PAGE_SIZE);
> +		vaddr = haddr + i*PAGE_SIZE;
> +		if (!ARCH_HAS_USER_NOCACHE  || i == target)
> +			clear_user_highpage(p, vaddr);
> +		else
> +			clear_user_highpage_nocache(p, vaddr);
>  	}
>  }

Is the check for !ARCH_HAS_USER_NOCACHE in there really necessary?  That
logic seems like it would be taken care of by that #define.

Plus, if you don't check 'ARCH_HAS_USER_NOCACHE' like this, you don't
need to define a value for it, and you can axe the:

+#ifndef ARCH_HAS_USER_NOCACHE
+#define ARCH_HAS_USER_NOCACHE 0
+#endif
