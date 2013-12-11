Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab3LKRIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:08:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab3LKRIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:08:20 -0500
Date: Wed, 11 Dec 2013 18:08:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131211170844.GA21700@redhat.com>
References: <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com> <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de> <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com> <20131210203559.GA1209@redhat.com> <20131210204925.GB27373@redhat.com> <20131210213431.GA6342@redhat.com> <20131210214143.GG27373@redhat.com> <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com> <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com> <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, Linus Torvalds wrote:
>
> I think what happens is:
>  - get_user_pages_fast(address, 1, 1, &page) fails (because it's read-only)
>  - get_user_pages_fast(address, 1, 0, &page) succeeds and gets a large-page
>  - __get_user_pages_fast(address, 1, 1, &page) fails (because it's read-only).
>
> so what triggers this is likely that Dave now does large-pages, and
> one of them is a read-only mapping.
>
> So I would suggest replacing the second "1" in the
> __get_user_pages_fast() call with a "!ro" instead. So how about this
> second patch instead (the access_ok() move remains).

I know almost nothing about THP, but why we may need write == true in
this case?

IOW,

> -		if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) {
> +		if (likely(__get_user_pages_fast(address, 1, !ro, &page) == 1)) {

can't
		if (likely(__get_user_pages_fast(address, 1, 0, &page) == 1)) {

work?


I have to admit, I do not understand why we can't avoid this altogether.

__get_page_tail() can find the stable ->first_page, why get_futex_key()
can't ?

Oleg.

