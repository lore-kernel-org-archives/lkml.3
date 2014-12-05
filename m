Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaLEI4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:56:46 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17739 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaLEI4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:56:44 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-16-548173495ab0
Message-id: <548172DE.9090007@samsung.com>
Date: Fri, 05 Dec 2014 10:54:54 +0200
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: David Howells <dhowells@redhat.com>, rusty@rustcorp.com.au
Cc: mmarek@suse.cz, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: Re: [PATCH 4/5] MODSIGN: Provide a utility to append a PKCS#7
 signature to a module [ver #2]
References: <20141126141709.3944.66589.stgit@warthog.procyon.org.uk>
 <20141126141753.3944.22213.stgit@warthog.procyon.org.uk>
In-reply-to: <20141126141753.3944.22213.stgit@warthog.procyon.org.uk>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t/xa7qexY0hBre6mSzeNf1msZi96yGL
	xeVdc9gsPvQ8YrNo2XeByeLmtAssFp9WTGJ2YPeYdmIZi8eDQ5tZPN7vu8rmsWLDCWaPMwuO
	sHt83iQXwBbFZZOSmpNZllqkb5fAlTHrYkDBXveKXy9esjYwzrboYuTkkBAwkZj6cQk7hC0m
	ceHeejYQW0hgKaPEs8lKXYxcQHYjk8Sn18tZIJxZjBJ71/wC6+AV0JI48+05C4jNIqAqcbhx
	N1g3m4CexIbmH2A1ogIREh9WfWWDqBeU+DH5Hli9iICdxMadF1lBhjILdDNKbHx7E6iBg0NY
	IF3ixRwFiCvqJe693MUIYnMKuEp0zv/AClLCLKAuMWVKLkiYWUBeYvOat8wQ5aoS3WvXskE8
	oyhxevI55gmMwrOQbJ6F0D0LSfcCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCEx82UH
	4+JjVocYBTgYlXh4L1g3hgixJpYVV+YeYpTgYFYS4S1UBArxpiRWVqUW5ccXleakFh9iZOLg
	lGpgzOeu6IqdVryz/2RC8nQ9BpVbP417Phl8aIyc+NikNqpPe0HXouo4dpPCh/cvXaiYmdoq
	X5qyozBLZbWe0Ixn/yVfBlcW5ZdqLdH6kH3746OFs7S7vK091R9vcI56btCse3PXoZjDX5J3
	7mTZe+ndqwttIr+vzm2XuGvR7OawW3KmwFT1+TtYlFiKMxINtZiLihMBXeWTc3cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

sign-file.c produce lots of annoying noise.

scripts/sign-file.c:153:2: warning: format not a string literal and no
format arguments [-Wformat-security]
  ERR(!bd, dest_name);
  ^
scripts/sign-file.c:179:3: warning: format not a string literal and no
format arguments [-Wformat-security]
   ERR(!b, pkcs7_name);
   ^
scripts/sign-file.c:180:3: warning: format not a string literal and no
format arguments [-Wformat-security]
   ERR(i2d_PKCS7_bio_stream(b, pkcs7, NULL, 0) < 0, pkcs7_name);
   ^
scripts/sign-file.c:185:2: warning: format not a string literal and no
format arguments [-Wformat-security]
  ERR(BIO_reset(bm) < 0, module_name);
  ^


Would be great to fix it.

Thanks,
Dmitry


On 26/11/14 16:17, David Howells wrote:
> Provide a utility that:
>
>  (1) Digests a module using the specified hash algorithm (typically sha256).
>
>      [The digest can be dumped into a file by passing the '-d' flag]
>
>  (2) Generates a PKCS#7 message that:
>
>      (a) Has detached data (ie. the module content).
>
>      (b) Is signed with the specified private key.
>
>      (c) Refers to the specified X.509 certificate.
>
>      (d) Has an empty X.509 certificate list.
>
>      [The PKCS#7 message can be dumped into a file by passing the '-p' flag]
>
>  (3) Generates a signed module by concatenating the old module, the PKCS#7
>      message, a descriptor and a magic string.  The descriptor contains the
>      size of the PKCS#7 message and indicates the id_type as PKEY_ID_PKCS7.
>
>  (4) Either writes the signed module to the specified destination or renames
>      it over the source module.
>
> This allows module signing to reuse the PKCS#7 handling code that was added
> for PE file parsing for signed kexec.
>
> Note that the utility is written in C and must be linked against the OpenSSL
> crypto library.
>
> Note further that I have temporarily dropped support for handling externally
> created signatures until we can work out the best way to do those.  Hopefully,
> whoever creates the signature can give me a PKCS#7 certificate.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  include/crypto/public_key.h |    1 
>  scripts/sign-file.c         |  189 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 190 insertions(+)
>  create mode 100755 scripts/sign-file.c
>
> diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
> index b6f27a240856..fda097e079a4 100644
> --- a/include/crypto/public_key.h
> +++ b/include/crypto/public_key.h
> @@ -33,6 +33,7 @@ extern const struct public_key_algorithm *pkey_algo[PKEY_ALGO__LAST];
>  enum pkey_id_type {
>  	PKEY_ID_PGP,		/* OpenPGP generated key ID */
>  	PKEY_ID_X509,		/* X.509 arbitrary subjectKeyIdentifier */
> +	PKEY_ID_PKCS7,		/* Signature in PKCS#7 message */
>  	PKEY_ID_TYPE__LAST
>  };
>  
> diff --git a/scripts/sign-file.c b/scripts/sign-file.c
> new file mode 100755
> index 000000000000..3f9bedbd185f
> --- /dev/null
> +++ b/scripts/sign-file.c
> @@ -0,0 +1,189 @@
> +/* Sign a module file using the given key.
> + *
> + * Copyright (C) 2014 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +#define _GNU_SOURCE
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdint.h>
> +#include <stdbool.h>
> +#include <string.h>
> +#include <getopt.h>
> +#include <err.h>
> +#include <arpa/inet.h>
> +#include <openssl/bio.h>
> +#include <openssl/evp.h>
> +#include <openssl/pem.h>
> +#include <openssl/pkcs7.h>
> +#include <openssl/err.h>
> +
> +struct module_signature {
> +	uint8_t		algo;		/* Public-key crypto algorithm [0] */
> +	uint8_t		hash;		/* Digest algorithm [0] */
> +	uint8_t		id_type;	/* Key identifier type [PKEY_ID_PKCS7] */
> +	uint8_t		signer_len;	/* Length of signer's name [0] */
> +	uint8_t		key_id_len;	/* Length of key identifier [0] */
> +	uint8_t		__pad[3];
> +	uint32_t	sig_len;	/* Length of signature data */
> +};
> +
> +#define PKEY_ID_PKCS7 2
> +
> +static char magic_number[] = "~Module signature appended~\n";
> +
> +static __attribute__((noreturn))
> +void format(void)
> +{
> +	fprintf(stderr,
> +		"Usage: scripts/sign-file [-dp] <hash algo> <key> <x509> <module> [<dest>]\n");
> +	exit(2);
> +}
> +
> +static void display_openssl_errors(int l)
> +{
> +	const char *file;
> +	char buf[120];
> +	int e, line;
> +
> +	if (ERR_peek_error() == 0)
> +		return;
> +	fprintf(stderr, "At main.c:%d:\n", l);
> +
> +	while ((e = ERR_get_error_line(&file, &line))) {
> +		ERR_error_string(e, buf);
> +		fprintf(stderr, "- SSL %s: %s:%d\n", buf, file, line);
> +	}
> +}
> +
> +
> +#define ERR(cond, ...)				  \
> +	do {					  \
> +		bool __cond = (cond);		  \
> +		display_openssl_errors(__LINE__); \
> +		if (__cond) {			  \
> +			err(1, ## __VA_ARGS__);	  \
> +		}				  \
> +	} while(0)
> +
> +int main(int argc, char **argv)
> +{
> +	struct module_signature sig_info = { .id_type = PKEY_ID_PKCS7 };
> +	char *hash_algo = NULL;
> +	char *private_key_name, *x509_name, *module_name, *dest_name;
> +	bool save_pkcs7 = false, replace_orig;
> +	unsigned char buf[4096];
> +	unsigned long module_size, pkcs7_size;
> +	const EVP_MD *digest_algo;
> +	EVP_PKEY *private_key;
> +	PKCS7 *pkcs7;
> +	X509 *x509;
> +	BIO *b, *bd, *bm;
> +	int opt, n;
> +
> +	do {
> +		opt = getopt(argc, argv, "dp");
> +		switch (opt) {
> +		case 'p': save_pkcs7 = true; break;
> +		case -1: break;
> +		default: format();
> +		}
> +	} while (opt != -1);
> +
> +	argc -= optind;
> +	argv += optind;
> +	if (argc < 4 || argc > 5)
> +		format();
> +
> +	hash_algo = argv[0];
> +	private_key_name = argv[1];
> +	x509_name = argv[2];
> +	module_name = argv[3];
> +	if (argc == 5) {
> +		dest_name = argv[4];
> +		replace_orig = false;
> +	} else {
> +		ERR(asprintf(&dest_name, "%s.~signed~", module_name) < 0,
> +		    "asprintf");
> +		replace_orig = true;
> +	}
> +
> +	ERR_load_crypto_strings();
> +	ERR_clear_error();
> +
> +	/* Read the private key and the X.509 cert the PKCS#7 message
> +	 * will point to.
> +	 */
> +	b = BIO_new_file(private_key_name, "rb");
> +	ERR(!b, "%s", private_key_name);
> +        private_key = PEM_read_bio_PrivateKey(b, NULL, NULL, NULL);
> +	BIO_free(b);
> +
> +	b = BIO_new_file(x509_name, "rb");
> +	ERR(!b, "%s", x509_name);
> +        x509 = PEM_read_bio_X509(b, NULL, NULL, NULL);
> +	BIO_free(b);
> +
> +	/* Open the destination file now so that we can shovel the module data
> +	 * across as we read it.
> +	 */
> +	bd = BIO_new_file(dest_name, "wb");
> +	ERR(!bd, dest_name);
> +
> +	/* Digest the module data. */
> +	OpenSSL_add_all_digests();
> +	display_openssl_errors(__LINE__);
> +	digest_algo = EVP_get_digestbyname(hash_algo);
> +	ERR(!digest_algo, "EVP_get_digestbyname");
> +
> +	bm = BIO_new_file(module_name, "rb");
> +	ERR(!bm, "%s", module_name);
> +
> +	/* Load the PKCS#7 message from the digest buffer. */
> +	pkcs7 = PKCS7_sign(NULL, NULL, NULL, NULL,
> +			   PKCS7_NOCERTS | PKCS7_PARTIAL | PKCS7_BINARY | PKCS7_DETACHED | PKCS7_STREAM);
> +	ERR(!pkcs7, "PKCS7_sign");
> +
> +	ERR(PKCS7_sign_add_signer(pkcs7, x509, private_key, digest_algo, PKCS7_NOCERTS | PKCS7_BINARY) < 0,
> +	    "PKCS7_sign_add_signer");
> +	ERR(PKCS7_final(pkcs7, bm, PKCS7_NOCERTS | PKCS7_BINARY) < 0,
> +	    "PKCS7_final");
> +
> +	if (save_pkcs7) {
> +		char *pkcs7_name;
> +
> +		ERR(asprintf(&pkcs7_name, "%s.pkcs7", module_name) < 0, "asprintf");
> +		b = BIO_new_file(pkcs7_name, "wb");
> +		ERR(!b, pkcs7_name);
> +		ERR(i2d_PKCS7_bio_stream(b, pkcs7, NULL, 0) < 0, pkcs7_name);
> +		BIO_free(b);
> +	}
> +
> +	/* Append the marker and the PKCS#7 message to the destination file */
> +	ERR(BIO_reset(bm) < 0, module_name);
> +	while ((n = BIO_read(bm, buf, sizeof(buf))),
> +	       n > 0) {
> +		ERR(BIO_write(bd, buf, n) < 0, dest_name);
> +	}
> +	ERR(n < 0, module_name);
> +	module_size = BIO_number_written(bd);
> +
> +	ERR(i2d_PKCS7_bio_stream(bd, pkcs7, NULL, 0) < 0, dest_name);
> +	pkcs7_size = BIO_number_written(bd) - module_size;
> +	sig_info.sig_len = htonl(pkcs7_size);
> +	ERR(BIO_write(bd, &sig_info, sizeof(sig_info)) < 0, dest_name);
> +	ERR(BIO_write(bd, magic_number, sizeof(magic_number) - 1) < 0, dest_name);
> +
> +	ERR(BIO_free(bd) < 0, dest_name);
> +
> +	/* Finally, if we're signing in place, replace the original. */
> +	if (replace_orig)
> +		ERR(rename(dest_name, module_name) < 0, dest_name);
> +
> +	return 0;
> +}
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

