Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab3CRUd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:33:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566Ab3CRUdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:33:24 -0400
Date: Mon, 18 Mar 2013 16:33:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@intel.com,
        akpm@linux-foundation.org, ebiederm@xmission.com
Subject: Re: [PATCH 4/4] binfmt_elf: Elf executable signature verification
Message-ID: <20130318203319.GM20743@redhat.com>
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
 <1363379758-10071-5-git-send-email-vgoyal@redhat.com>
 <CA+5PVA4fxN4EhKQJ5C4dLG__ZRzrYPKFqNnZuDgssXCYAjX2yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4fxN4EhKQJ5C4dLG__ZRzrYPKFqNnZuDgssXCYAjX2yQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 04:23:11PM -0400, Josh Boyer wrote:
> On Fri, Mar 15, 2013 at 4:35 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Do elf executable signature verification (if one is present). If signature
> > is present, it should be valid. Validly signed files are given a capability
> > CAP_SIGNED.
> >
> > If file is unsigned, it can execute but it does not get the capability
> > CAP_SIGNED.
> >
> > This is work in progress. This patch is just an RFC to show how one
> > can go about making use of IMA APIs for executable signature
> > verification.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/Kconfig.binfmt |   12 ++++++++++++
> >  fs/binfmt_elf.c   |   44 ++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 56 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
> > index 0efd152..cbb1d4a 100644
> > --- a/fs/Kconfig.binfmt
> > +++ b/fs/Kconfig.binfmt
> > @@ -23,6 +23,18 @@ config BINFMT_ELF
> >           ld.so (check the file <file:Documentation/Changes> for location and
> >           latest version).
> >
> > +config BINFMT_ELF_SIG
> > +       bool "ELF binary signature verification"
> > +       depends on BINFMT_ELF
> > +       select INTEGRITY
> > +       select INTEGRITY_SIGNATURE
> > +       select INTEGRITY_ASYMMETRIC_KEYS
> > +       select IMA
> > +       select IMA_APPRAISE
> > +       default n
> > +       ---help---
> > +         Check ELF binary signature verfication.
> > +
> 
> I haven't reviewed the whole patch set, but this caught my eye.  There
> are a couple things wrong with it.
> 
> 1) The help text isn't helpful.  It could definitely be more verbose and
> should probably point to something in Documentation/ that describes what
> this whole thing is.

Sure, I will fix that. Actually this posting was more for getting the
IMA interfaces sorted out and just wanted to quickly show how new
interfaces will be used in ELF code.

> 
> 2) The select mechanism is horrible.  I would really like to see this
> option use "depends on" instead of select given that you're selecting in
> a whole subsystem that people probably aren't going to have already
>  enabled.

I like "select" better in this context. If you want this feature, then you
need to select a bunch of other features which feature depends on.
Otherwise it is a configuration nightmare. How does one know what are
different parts which need to be enabled before elf binary signature
verification options becomes visible.

And it is very similar to module signing. It selects bunch of options
when user wants to enable modules signing (instead of depending on these
options).


config MODULE_SIG
        bool "Module signature verification"
        depends on MODULES
        select KEYS
        select CRYPTO
        select ASYMMETRIC_KEY_TYPE
        select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
        select PUBLIC_KEY_ALGO_RSA
        select ASN1
        select OID_REGISTRY
        select X509_CERTIFICATE_PARSER

Thanks
Vivek
