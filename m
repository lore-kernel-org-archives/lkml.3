Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaAOVv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:51:59 -0500
Received: from ozlabs.org ([203.10.76.45]:35024 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbaAOVv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:51:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Lee\, Chun-Yi" <joeyli.kernel@gmail.com>, dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, Chun-Yi Lee <jlee@suse.com>,
        Josh Boyer <jwboyer@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Marek <mmarek@suse.com>
Cc: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] MODSIGN: Fix including certificate twice when the signing_key.x509
In-Reply-To: <1389249983-31265-1-git-send-email-jlee@suse.com>
References: <1389249983-31265-1-git-send-email-jlee@suse.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 15 Jan 2014 15:09:54 +1030
Message-ID: <87eh49x3hh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Punting to David Howells...

Cheers,
Rusty.
"Lee, Chun-Yi" <joeyli.kernel@gmail.com> writes:
> From: Chun-Yi Lee <jlee@suse.com>
>
> This issue was found in devel-pekey branch on linux-modsign.git tree.
> The
> x509_certificate_list includes certificate twice when the
> signing_key.x509
> already exists.
> We can reproduce this issue by making kernel twice, the build log of
> second time looks like this:
>
> ...
>   CHK     kernel/config_data.h
>   CERTS   kernel/x509_certificate_list
>   - Including cert /ramdisk/working/joey/linux-modsign/signing_key.x509
>   - Including cert signing_key.x509
> ...
>
> Actually the build path was the same with the srctree path when building
> kernel. It causes the size of bzImage increased by packaging
> certificates
> twice.
>
> v2:
> Using '$(shell /bin/pwd)' instead of '$(shell pwd)' for more reliable
> between different shells

Hmm, that's not a great test for equality.  How about:

     ifneq ($(realpath .), $(realpath $(srctree)))

That should cover all the cases.

Cheers,
Rusty.

>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Josh Boyer <jwboyer@redhat.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Michal Marek <mmarek@suse.com>
> Signed-off-by: Chun-Yi Lee <jlee@suse.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>  kernel/Makefile |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/Makefile b/kernel/Makefile
> index bc010ee..582fa7a 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -136,7 +136,10 @@ $(obj)/timeconst.h: $(obj)/hz.bc $(src)/timeconst.bc FORCE
>  #
>  ###############################################################################
>  ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
> -X509_CERTIFICATES-y := $(wildcard *.x509) $(wildcard $(srctree)/*.x509)
> +X509_CERTIFICATES-y := $(wildcard *.x509)
> +ifneq ($(shell /bin/pwd), $(srctree))
> +X509_CERTIFICATES-y += $(wildcard $(srctree)/*.x509)
> +endif
>  X509_CERTIFICATES-$(CONFIG_MODULE_SIG) += $(objtree)/signing_key.x509
>  X509_CERTIFICATES-raw := $(sort $(foreach CERT,$(X509_CERTIFICATES-y), \
>  				$(or $(realpath $(CERT)),$(CERT))))
> -- 
> 1.6.4.2
