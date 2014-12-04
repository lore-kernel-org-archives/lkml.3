Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948AbaLDS4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:56:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230AbaLDS43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:56:29 -0500
Date: Thu, 4 Dec 2014 13:56:13 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, mmarek@suse.cz, keyrings@linux-nfs.org,
        d.kasatkin@samsung.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: Re: [PATCH 0/5] MODSIGN: Use PKCS#7 for module signatures [ver #2]
Message-ID: <20141204185613.GA16986@redhat.com>
References: <20141126141709.3944.66589.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126141709.3944.66589.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 02:17:09PM +0000, David Howells wrote:
> 
> Here's a set of patches that does the following:
> 

I compiled the kernel with these patches and booted into this kernel
without any issues.

FWIW,

Tested-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

>  (1) Extracts both parts of an X.509 AuthorityKeyIdentifier (AKID) extension.
>      We already extract the bit that can match the subjectKeyIdentifier (SKID)
>      of the parent X.509 cert, but we currently ignore the bits that can match
>      the issuer and serialNumber.
> 
>      Looks up an X.509 cert by issuer and serialNumber if those are provided in
>      the AKID.  If the keyIdentifier is also provided, checks that the
>      subjectKeyIdentifier of the cert found matches that also.
> 
>      If no issuer and serialNumber are provided in the AKID, looks up an X.509
>      cert by SKID using the AKID keyIdentifier.
> 
>      This allows module signing to be done with certificates that don't have an
>      SKID by which they can be looked up.
> 
>  (2) Makes use of the PKCS#7 facility to provide module signatures.
> 
>      sign-file is replaced with a program that generates a PKCS#7 message that
>      has no X.509 certs embedded and that has detached data (the module
>      content) and adds it onto the message with magic string and descriptor.
> 
>  (3) The PKCS#7 message (and matching X.509 cert) supply all the information
>      that is needed to select the X.509 cert to be used to verify the signature
>      by standard means (including selection of digest algorithm and public key
>      algorithm).  No kernel-specific magic values are required.
> 
> Note that the revised sign-file program no longer supports the "-s <signature>"
> option as I'm not sure what the best way to deal with this is.  Do we generate
> a PKCS#7 cert from the signature given, or do we get given a PKCS#7 cert?  I
> lean towards the latter.
> 
> They can be found here also:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=modsign-pkcs7
> 
> These patches are based on the security tree's next branch.
> 
> Changes:
> 
>  (*) Fixed a comment on x509_certificate::id to show the order of construction
>      correctly [thanks to Vivek Goyal].
> 
>  (*) The 'id' argument to x509_request_asymmetric_key() can be NULL so needs to
>      be checked [thanks to Mimi Zohar].
> 
>  (*) pkcs7_supply_detached_data() doesn't need exporting [thanks to Mimi
>      Zohar].
> 
>  (*) Fixed "make install_modules" to not try to run sign-file under perl
>      [thanks to Dmitry Kasatkin].
> 
>  (*) Fixed sign-file to handle binary X.509 certs as well as PEM-encoded X.509
>      certs.
> 
> David
> ---
> David Howells (5):
>       X.509: Extract both parts of the AuthorityKeyIdentifier
>       X.509: Support X.509 lookup by Issuer+Serial form AuthorityKeyIdentifier
>       PKCS#7: Allow detached data to be supplied for signature checking purposes
>       MODSIGN: Provide a utility to append a PKCS#7 signature to a module
>       MODSIGN: Use PKCS#7 messages as module signatures
> 
> 
>  Makefile                                  |    2 
>  crypto/asymmetric_keys/Makefile           |    8 -
>  crypto/asymmetric_keys/pkcs7_trust.c      |   10 -
>  crypto/asymmetric_keys/pkcs7_verify.c     |   80 ++++--
>  crypto/asymmetric_keys/x509_akid.asn1     |   35 ++
>  crypto/asymmetric_keys/x509_cert_parser.c |  142 ++++++----
>  crypto/asymmetric_keys/x509_parser.h      |    5 
>  crypto/asymmetric_keys/x509_public_key.c  |   86 ++++--
>  include/crypto/pkcs7.h                    |    3 
>  include/crypto/public_key.h               |    4 
>  init/Kconfig                              |    1 
>  kernel/module_signing.c                   |  220 +++------------
>  scripts/Makefile                          |    2 
>  scripts/sign-file                         |  421 -----------------------------
>  scripts/sign-file.c                       |  206 ++++++++++++++
>  15 files changed, 524 insertions(+), 701 deletions(-)
>  create mode 100644 crypto/asymmetric_keys/x509_akid.asn1
>  delete mode 100755 scripts/sign-file
>  create mode 100755 scripts/sign-file.c
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
