Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaBZUmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:42:10 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:60602 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaBZUmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:42:08 -0500
Date: Wed, 26 Feb 2014 15:41:32 -0500 (EST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, schwidefsky@de.ibm.com, rientjes@google.com,
        riel@redhat.com, mingo@kernel.org, mgorman@suse.de,
        kirill shutemov <kirill.shutemov@linux.intel.com>,
        heiko carstens <heiko.carstens@de.ibm.com>, hannes@cmpxchg.org,
        gerald schaefer <gerald.schaefer@de.ibm.com>, ebiederm@xmission.com,
        aarcange@redhat.com
Message-ID: <842178473.10219645.1393447292444.JavaMail.zimbra@redhat.com>
In-Reply-To: <20140226180603.GA25644@redhat.com>
References: <530d2ce9.eikv0ULecNwxF4I5%akpm@linux-foundation.org> <530D9F50.1080400@de.ibm.com> <20140226145025.GA12571@redhat.com> <530E0306.7020601@de.ibm.com> <20140226153144.GA15527@redhat.com> <20140226165759.GB22802@laptop.programming.kicks-ass.net> <20140226172253.GQ3041@sgi.com> <20140226180603.GA25644@redhat.com>
Subject: Re: +	mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
 added	to -mm tree
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF26 (Linux)/8.0.6_GA_5922)
Thread-Topic: + mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch added to -mm tree
Thread-Index: OdwMR8xK10m8V/MU274GZX5KJ7E+xg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +#ifdef CONFIG_S390
> +		/*
> +		 * MADV_HUGEPAGE is broken after s390_enable_sie(), qemu
> +		 * blindly does madvise(MADV_HUGEPAGE) for for all kvm pages
> +		 * and expects it must fail on s390. Avoid a possible SIGSEGV
> +		 * until qemu is changed.
> +		 */
> +		if (mm_has_pgste(vma->vm_mm))
> +			return -EINVAL;
> +#endif

The comment is not quite true.  QEMU doesn't expect that the madvise fails.
It simply expects that the madvise doesn't cause SIGSEGVs or later
malfunctioning, because (quoting tha man page) madvise "does not influence
the semantics of the application".

There's nothing to fix in QEMU, in fact I believe this should return 0
rather than -EINVAL.  It's perfectly legal for the kernel to ignore an madvise,
and this is what should happen here.

Paolo
