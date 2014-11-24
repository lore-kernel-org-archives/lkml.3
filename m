Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbaKXJUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:20:35 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16226 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaKXJUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:20:32 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-e2-5472f85d0e3f
Message-id: <5472F806.8000403@samsung.com>
Date: Mon, 24 Nov 2014 11:19:02 +0200
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
 <546F3742.9010702@samsung.com>
In-reply-to: <546F3742.9010702@samsung.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t/xq7qxP4pCDI5fsrF41/SbxWL2rocs
	Fpd3zWGz+NDziM2iZd8FJoub0y6wWFy7tY/N4tOKScwOHB7TTixj8XhwaDOLx/t9V9k8Vmw4
	wexxZsERdo/Pm+QC2KK4bFJSczLLUov07RK4MrauFit4o1Bx6NtWpgbGRxJdjJwcEgImEotW
	LWSEsMUkLtxbz9bFyMUhJLCUUeL8o4+MEE4jk8SG85uYIJxZjBKHtk9lA2nhFdCSOLe4mRnE
	ZhFQlWg8tJAFxGYT0JPY0PyDHcQWFYiQuLJmDiNEvaDEj8n3wGpEBJIldt7fCRZnFqiWuLnk
	D1hcWMBJ4viizWC9QgKpEmfPf2YFsTkFtCUaOicAxTmA6tUlpkzJhWiVl9i85i0zRLmqRPfa
	tWwQ3yhKnJ58jnkCo/AsJJtnIXTPQtK9gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZI
	/HzZwbj4mNUhRgEORiUe3h89hSFCrIllxZW5hxglOJiVRHjP/gMK8aYkVlalFuXHF5XmpBYf
	YmTi4JRqYIx/1LqRc7qciLuwsjRPbqCOnnBNZ4XY8qB3rO+23Fiq9ORu6/03oguOOHZ1Hes3
	Oba4w763z3Z3u+DkhDsmWksuH5QXKLvruC7eKCvQwaetb2GobKry7v/Tz9QdV+j11rXzMW/T
	2May1M2HO8L9+N1a2zfaH02OiR8v+JN9/1vBlBdR8yIdlViKMxINtZiLihMBe2yZbH0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/11/14 14:59, Dmitry Kasatkin wrote:
> Hi David,
>
> Before I go into reviewing the patches just want to let you know that
> Integrity stuff seems to work fine with these changes.

Actually after cleaning the tree and re-signing the modules, I get following

Unrecognized character \x7F; marked by <-- HERE after <-- HERE near
column 1 at ./scripts/sign-file line 1.
make[1]: *** [arch/x86/crypto/aes-x86_64.ko] Error 255


- Dmitry

> Thanks,
> Dmitry
>
> On 20/11/14 18:53, David Howells wrote:
>> Here's a set of patches that does the following:
>>
>>  (1) Extracts both parts of an X.509 AuthorityKeyIdentifier (AKID) extension.
>>      We already extract the bit that can match the subjectKeyIdentifier (SKID)
>>      of the parent X.509 cert, but we currently ignore the bits that can match
>>      the issuer and serialNumber.
>>
>>      Looks up an X.509 cert by issuer and serialNumber if those are provided in
>>      the AKID.  If the keyIdentifier is also provided, checks that the
>>      subjectKeyIdentifier of the cert found matches that also.
>>
>>      If no issuer and serialNumber are provided in the AKID, looks up an X.509
>>      cert by SKID using the AKID keyIdentifier.
>>
>>      This allows module signing to be done with certificates that don't have an
>>      SKID by which they can be looked up.
>>
>>  (2) Makes use of the PKCS#7 facility to provide module signatures.
>>
>>      sign-file is replaced with a program that generates a PKCS#7 message that
>>      has no X.509 certs embedded and that has detached data (the module
>>      content) and adds it onto the message with magic string and descriptor.
>>
>>  (3) The PKCS#7 message (and matching X.509 cert) supply all the information
>>      that is needed to select the X.509 cert to be used to verify the signature
>>      by standard means (including selection of digest algorithm and public key
>>      algorithm).  No kernel-specific magic values are required.
>>
>> Note that the revised sign-file program no longer supports the "-s <signature>"
>> option as I'm not sure what the best way to deal with this is.  Do we generate
>> a PKCS#7 cert from the signature given, or do we get given a PKCS#7 cert?  I
>> lean towards the latter.
>>
>> They can be found here also:
>>
>> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=modsign-pkcs7
>>
>> These patches are based on the security tree's next branch.
>>
>> David
>> ---
>> David Howells (5):
>>       X.509: Extract both parts of the AuthorityKeyIdentifier
>>       X.509: Support X.509 lookup by Issuer+Serial form AuthorityKeyIdentifier
>>       PKCS#7: Allow detached data to be supplied for signature checking purposes
>>       MODSIGN: Provide a utility to append a PKCS#7 signature to a module
>>       MODSIGN: Use PKCS#7 messages as module signatures
>>
>>
>>  crypto/asymmetric_keys/Makefile           |    8 -
>>  crypto/asymmetric_keys/pkcs7_trust.c      |   10 -
>>  crypto/asymmetric_keys/pkcs7_verify.c     |   81 ++++--
>>  crypto/asymmetric_keys/x509_akid.asn1     |   35 ++
>>  crypto/asymmetric_keys/x509_cert_parser.c |  142 ++++++----
>>  crypto/asymmetric_keys/x509_parser.h      |    3 
>>  crypto/asymmetric_keys/x509_public_key.c  |   85 ++++--
>>  include/crypto/pkcs7.h                    |    3 
>>  include/crypto/public_key.h               |    4 
>>  init/Kconfig                              |    1 
>>  kernel/module_signing.c                   |  220 +++------------
>>  scripts/Makefile                          |    2 
>>  scripts/sign-file                         |  421 -----------------------------
>>  scripts/sign-file.c                       |  189 +++++++++++++
>>  14 files changed, 505 insertions(+), 699 deletions(-)
>>  create mode 100644 crypto/asymmetric_keys/x509_akid.asn1
>>  delete mode 100755 scripts/sign-file
>>  create mode 100755 scripts/sign-file.c
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

