Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbaKUNBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:01:14 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9343 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaKUNBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:01:12 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-79-546f3795e991
Message-id: <546F3742.9010702@samsung.com>
Date: Fri, 21 Nov 2014 14:59:46 +0200
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: David Howells <dhowells@redhat.com>, mmarek@suse.cz, rusty@rustcorp.com.au,
        vgoyal@redhat.com
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] MODSIGN: Use PKCS#7 for module signatures
References: <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
In-reply-to: <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t/xK7pTzfNDDGb1ilu8a/rNYjF710MW
	i8u75rBZfOh5xGbRsu8Ck8XNaRdYLK7d2sdm8WnFJGYHDo9pJ5axeDw4tJnF4/2+q2weKzac
	YPY4s+AIu8fnTXIBbFFcNimpOZllqUX6dglcGfNa17MV9MhUTHg/jbGB8bFIFyMnh4SAicTb
	Jz8ZIWwxiQv31rN1MXJxCAksZZSY13KfHSQhJNDIJPGnJxjCnsUocXWfGojNK6Al8XzXdiYQ
	m0VAVeLbzuNsIDabgJ7EhuYfYL2iAhESV9bMYYSoF5T4MfkeC4gtIpAssfP+TrA4s0C1xM0l
	f8DiwgJOEscXbYba6yIxc2on2HxOAVeJ9uNnmLsYOYDq1SWmTMmFaJWX2LzmLTNEuapE99q1
	bBC/KEqcnnyOeQKj8Cwkm2chdM9C0r2AkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkj0
	fN3BuPSY1SFGAQ5GJR7eC7NyQ4RYE8uKK3MPMUpwMCuJ8JYL54cI8aYkVlalFuXHF5XmpBYf
	YmTi4JRqYLxl43dzvsAOJkHhU2/PLwp4N0tm2/3rlxcvvJR+KXjp363tNQ6HOxLvL383t2nX
	b7tvmUxxQVofHhXqKCqeKNaU7s0zPFhYaXM/bcGzYsa+U4+uL7GZYekpy7v+7Y7X5wocns7i
	Ov19Y5SG2FY7Va6wLXysK1cYzf9T8O2S8a2o0jz3U3HrS7qUWIozEg21mIuKEwG/2upDfAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Before I go into reviewing the patches just want to let you know that
Integrity stuff seems to work fine with these changes.

Thanks,
Dmitry

On 20/11/14 18:53, David Howells wrote:
> Here's a set of patches that does the following:
>
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
>  crypto/asymmetric_keys/Makefile           |    8 -
>  crypto/asymmetric_keys/pkcs7_trust.c      |   10 -
>  crypto/asymmetric_keys/pkcs7_verify.c     |   81 ++++--
>  crypto/asymmetric_keys/x509_akid.asn1     |   35 ++
>  crypto/asymmetric_keys/x509_cert_parser.c |  142 ++++++----
>  crypto/asymmetric_keys/x509_parser.h      |    3 
>  crypto/asymmetric_keys/x509_public_key.c  |   85 ++++--
>  include/crypto/pkcs7.h                    |    3 
>  include/crypto/public_key.h               |    4 
>  init/Kconfig                              |    1 
>  kernel/module_signing.c                   |  220 +++------------
>  scripts/Makefile                          |    2 
>  scripts/sign-file                         |  421 -----------------------------
>  scripts/sign-file.c                       |  189 +++++++++++++
>  14 files changed, 505 insertions(+), 699 deletions(-)
>  create mode 100644 crypto/asymmetric_keys/x509_akid.asn1
>  delete mode 100755 scripts/sign-file
>  create mode 100755 scripts/sign-file.c
>
>

