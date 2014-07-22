Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbaGVUei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:34:38 -0400
Received: from imap.thunk.org ([74.207.234.97]:50579 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbaGVUeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:34:36 -0400
Date: Tue, 22 Jul 2014 09:59:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        x86@kernel.org, Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        bsd@redhat.com, Andrew Honig <ahonig@google.com>
Subject: Re: [PATCH v4 2/5] random: Add and use arch_get_rng_seed
Message-ID: <20140722135915.GB25291@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andy Lutomirski <luto@amacapital.net>, kvm@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	Kees Cook <keescook@chromium.org>, x86@kernel.org,
	Daniel Borkmann <dborkman@redhat.com>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
	Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	bsd@redhat.com, Andrew Honig <ahonig@google.com>
References: <cover.1405620944.git.luto@amacapital.net>
 <9c2a0549519b4eb5eee2d5d480f8e83a574273df.1405620944.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c2a0549519b4eb5eee2d5d480f8e83a574273df.1405620944.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 11:22:17AM -0700, Andy Lutomirski wrote:
> Currently, init_std_data contains its own logic for using arch
> random sources.  This logic is a bit strange: it reads one long of
> arch random data per byte of internal state.

This isn't true.  Check out the init_std_data() a bit more closely.

	unsigned long rv;

	...

	for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
	    ...

In particular, note the "i -= sizeof(rv)".  We are reading one bit per
bit of internal state beeing seeded.

> Assuming the arch sources are perfect, this is the right thing to
> do.  They're not, though, so the followup patch attempts to
> implement the correct logic on x86.

... and that's not a problem because we aren't giving any entropy
credit --- and this is deliberate, because we don't want to trust
un-auditable hardware.  We are deliberately trying to be conservative
here.

So I don't think either this patch or the next one is needed.  It adds
far more complexity than is warranted.

Regards,

						- Ted
