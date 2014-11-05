Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbaKEXUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:20:25 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42019 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbaKEXUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:20:23 -0500
Subject: Re: [PATCH v2 02/11] crypto: Documentation - userspace interface
 spec
From: "Joy M. Latten" <jmlatten@linux.vnet.ibm.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
In-Reply-To: <1959144.oe4Wmhi0gN@tachyon.chronox.de>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
	 <1959144.oe4Wmhi0gN@tachyon.chronox.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Nov 2014 17:20:15 -0600
Message-ID: <1415229615.5083.39.camel@oc8377654763.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110523-0025-0000-0000-0000010169F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephan,

On Sun, 2014-11-02 at 21:36 +0100, Stephan Mueller wrote:
> The userspace interface of the kernel crypto API is documented with
>  * a general explanation
>  * a discussion of the memory in-place operation
>  * the description of the message digest API
>  * the description of the symmetric cipher API
> 
> In addition, a fully self contained example that can readily be used as
> a library is added as well.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> CC: Marek Vasut <marex@denx.de>
> ---
>  Documentation/crypto/crypto-API-userspace.txt | 662 ++++++++++++++++++++++++++
>  1 file changed, 662 insertions(+)
>  create mode 100644 Documentation/crypto/crypto-API-userspace.txt
> 
> diff --git a/Documentation/crypto/crypto-API-userspace.txt b/Documentation/crypto/crypto-API-userspace.txt
> new file mode 100644
> index 0000000..30ca6a7
> --- /dev/null
> +++ b/Documentation/crypto/crypto-API-userspace.txt
> @@ -0,0 +1,662 @@
> +Introduction
> +============
> +
> +The concepts of the kernel crypto API visible to kernel space is fully
> +applicable to the user space interface as well. Therefore, the kernel crypto API
> +high level discussion for the in-kernel use cases applies here as well.
> +
> +The major difference, however, is that user space can only act as a consumer
> +and never as a provider of a transformation or cipher algorithm.
> +
> +The following covers the user space interface exported by the kernel crypto
> +API. It provides a fully working sample code at the that can be used as a
"at the" can probably be deleted.
 
> +library for user space applications that require cryptographic services from
> +the kernel.
> +
> +Some details of the in-kernel kernel crypto API aspects do not
> +apply to user space, however. This includes the difference between synchronous
> +and asynchronous invocations. The user space API call is fully synchronous.
> +In addition, only a subset of all cipher types are available as documented
> +below.
> +
> +
> +User space API general remarks
> +==============================
> +
> +The kernel crypto API is accessible from user space. Currently, the following
> +ciphers are accessible:
> +
> +	* Message digest including keyed message digest (HMAC, CMAC)
> +
> +	* Symmetric ciphers
> +
> +Note, AEAD ciphers are currently not supported via the symmetric cipher
> +interface.
> +
> +The interface is provided via Netlink using the type AF_ALG. In addition, the
> +setsockopt option type is SOL_ALG. In case the user space header files do not
> +export these flags yet, use the following macros:
> +
> +#ifndef AF_ALG
> +#define AF_ALG 38
> +#endif
> +#ifndef SOL_ALG
> +#define SOL_ALG 279
> +#endif
> +
> +A cipher is accessed with the same name as done for the in-kernel API calls.
> +This includes the generic vs. unique naming schema for ciphers as well as the
> +enforcement of priorities for generic names.
> +
> +To interact with the kernel crypto API, a Netlink socket must be created by
> +the user space application. User space invokes the cipher operation with the
> +send/write system call family. The result of the cipher operation is obtained
> +with the read/recv system call family.
> +
> +The following API calls assume that the Netlink socket descriptor is already
> +opened by the user space application and discusses only the kernel crypto API
> +specific invocations.
> +
> +In-place cipher operation
> +=========================
> +
> +Just like the in-kernel operation of the kernel crypto API, the user space
> +interface allows the cipher operation in-place. That means that the input buffer
> +used for the send/write system call and the output buffer used by the read/recv
> +system call may be one and the same. This is of particular interest for
> +symmetric cipher operations where a copying of the output data to its final
> +destination can be avoided.
For clarity, it might be helpful to reader if both ways are mentioned.
That you can encrypt in place or have your output place in a separate
destination.

> +
> +Message digest API
> +==================
> +
> +The message digest type to be used for the cipher operation is selected when
> +invoking the bind syscall. bind requires the caller to provide a filled
> +struct sockaddr data structure. This data structure must be filled as follows:
> +
> +struct sockaddr_alg sa = {
> +	.salg_family = AF_ALG,
> +	.salg_type = "hash", /* this selects the hash logic in the kernel */
> +	.salg_name = "sha1" /* this is the cipher name */
> +};
> +
> +The salg_type value "hash" applies to message digests and keyed message digests.
> +Though, a keyed message digest is referenced by the appropriate salg_name and
> +providing a key for the cipher operation.
Picky, but maybe now is the time to mention what you mention 2 or 3
paragraphs below about how to set the message digest key.

> +
> +Using the send() system call, the application provides the data that should be
> +processed with the message digest. The send system call allows the following
> +flags to be specified:
> +
> +	* MSG_MORE: If this flag is set, the send system call acts like a
> +		    message digest update function where the final hash is not
> +		    yet calculated. If the flag is not set, the send system call
> +		    calculates the final message digest immediately.
> +
> +With the recv() system call, the application can read the message digest from
> +the kernel crypto API. If the buffer is too small for the message digest, the
> +flag MSG_TRUNC is set by the kernel.
> +
> +In order to set a message digest key, the calling application must use the
> +setsockopt() option of ALG_SET_KEY. If the key is not set the HMAC operation is
> +performed without the initial HMAC state change caused by the key.
> +
> +
> +Symmetric cipher API
> +====================
> +
> +The operation is very similar to the message digest discussion. During
> +initialization, the struct sockaddr data structure must be filled as follows:
> +
> +struct sockaddr_alg sa = {
> +	.salg_family = AF_ALG,
> +	.salg_type = "skcipher", /* this selects the symmetric cipher */
> +	.salg_name = "cbc(aes)" /* this is the cipher name */
> +};
> +
> +Using the sendmsg() system call, the application provides the data that should
> +be processed for encryption or decryption. In addition, the IV is specified
> +with the data structure provided by the sendmsg() system call.
> +
> +The sendmsg system call parameter of struct msghdr is embedded into the
> +struct cmsghdr data structure. See recv(2) and cmsg(3) for more information
> +on how the cmsghdr data structure is used together with the send/recv system
> +call family. That cmsghdr data structure holds the following information
> +specified with a separate header instances:
> +
> +	* specification of the cipher operation type with one of these flags:
> +		ALG_OP_ENCRYPT - encryption of data
> +		ALG_OP_DECRYPT - decryption of data
> +
> +	* specification of the IV information marked with the flag ALG_SET_IV
> +
> +The send system call family allows the following flag to be specified:
> +
> +	* MSG_MORE: If this flag is set, the send system call acts like a
> +		    cipher update function where more input data is expected
> +		    with a subsequent invocation of the send system call.
> +
> +Note: The kernel reports -EINVAL for any unexpected data. The caller must
> +make sure that all data matches the constraints given in /proc/crypto for the
> +selected cipher.
> +
> +With the recv() system call, the application can read the result of the
> +cipher operation from the kernel crypto API. The output buffer must be at least
> +as large as to hold all blocks of the encrypted or decrypted data. If the output
> +data size is smaller, only as many blocks are returned that fit into that
> +output buffer size.
> +
> +User space API example
> +======================
> +
> +Compile the following code with the gcc flags of "-Wextra -Wall -pedantic".
> +
> +/*
> + * Generic kernel crypto API user space interface library
> + *
> + * Copyright (C) 2014, Stephan Mueller <smueller@chronox.de>
> + *
> + * Derived from cryptsetup 1.6.4:
> + *
> + * Linux kernel user space API crypto backend implementation (skcipher)
> + *
> + * Copyright (C) 2012, Red Hat, Inc. All rights reserved.
> + * Copyright (C) 2012, Milan Broz
> + *
> + * This file is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU Lesser General Public
> + * License as published by the Free Software Foundation; either
> + * version 2.1 of the License, or (at your option) any later version.
> + *
> + * This file is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * Lesser General Public License for more details.
> + *
> + * You should have received a copy of the GNU Lesser General Public
> + * License along with this file; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +
> +/*
> + * Code from cryptsetup version 1.6.4 used as a basis. See files
> + * lib/crypto_backend/crypto_cipher_kernel.c and
> + * lib/crypto_backend/crypto_kernel.c
> + */
> +
> +#include <stdio.h>
> +
> +#include <unistd.h>
> +#include <sys/socket.h>
> +#include <sys/types.h>
> +#include <linux/if_alg.h>
> +#include <stdint.h>
> +#include <errno.h>
> +#include <string.h>
> +#include <stdlib.h>
> +
> +#ifndef AF_ALG
> +#define AF_ALG 38
> +#endif
> +#ifndef SOL_ALG
> +#define SOL_ALG 279
> +#endif
> +
> +/************************************************************
> + * Application interfaces
> + ************************************************************/
> +
> +/* Cipher handle */
> +struct kcapi_handle {
> +	int tfmfd;
> +	int opfd;
> +};
> +
> +/************************************************************
> + * Internal logic
> + ************************************************************/
> +
> +/* The in/out should be aligned to page boundary */
> +static int _kcapi_cipher_crypt(struct kcapi_handle *handle,
> +			       const unsigned char *in, size_t inlen,
> +			       unsigned char *out, size_t outlen,
> +			       const unsigned char *iv, size_t ivlen,
> +			       uint32_t enc)
> +{
> +	int r = 0;
> +	ssize_t ret;
> +	struct af_alg_iv *alg_iv;
> +	struct cmsghdr *header;
> +	uint32_t *type;
> +	struct iovec iov;
> +	int iv_msg_size = iv ? CMSG_SPACE(sizeof(*alg_iv) + ivlen) : 0;
> +	char *buffer = NULL;
> +	volatile void *_buffer = NULL;
> +	unsigned int bufferlen = CMSG_SPACE(sizeof(*type)) + iv_msg_size;
> +	struct msghdr msg;
> +
> +	memset(&msg, 0, sizeof(msg));
> +
> +	if (!in || !out || !inlen || !outlen)
> +		return -EINVAL;
> +
> +	if ((!iv && ivlen) || (iv && !ivlen))
> +		return -EINVAL;
> +
> +	buffer = calloc(1, bufferlen);
> +	if (!buffer)
> +		return -ENOMEM;
> +
> +	iov.iov_base = (void*)(uintptr_t)in;
> +	iov.iov_len = inlen;
> +	msg.msg_control = buffer;
> +	msg.msg_controllen = bufferlen;
> +	msg.msg_iov = &iov;
> +	msg.msg_iovlen = 1;
> +
> +	/* encrypt/decrypt operation */
> +	header = CMSG_FIRSTHDR(&msg);
> +	header->cmsg_level = SOL_ALG;
> +	header->cmsg_type = ALG_SET_OP;
> +	header->cmsg_len = CMSG_LEN(sizeof(*type));
> +	type = (void*)CMSG_DATA(header);
> +	*type = enc;
> +
> +	/* set IV */
> +	if (iv) {
> +		header = CMSG_NXTHDR(&msg, header);
> +		header->cmsg_level = SOL_ALG;
> +		header->cmsg_type = ALG_SET_IV;
> +		header->cmsg_len = iv_msg_size;
> +		alg_iv = (void*)CMSG_DATA(header);
> +		alg_iv->ivlen = ivlen;
> +		memcpy(alg_iv->iv, iv, ivlen);
> +	}
> +
> +	ret = sendmsg(handle->opfd, &msg, 0);
> +	if (ret != (ssize_t)inlen) {
> +		r = -EIO;
> +		goto bad;
> +	}
> +
> +	ret = read(handle->opfd, out, outlen);
> +	if (ret != (ssize_t)outlen)
> +		r = -EIO;
> +bad:
> +	memset(buffer, 0, bufferlen);
> +	_buffer = memchr(buffer, 1, bufferlen);
> +	if (_buffer)
> +		_buffer = '\0';
> +	free(buffer);
> +	return r;
> +}
> +
> +/************************************************************
> + * API to application
> + ************************************************************/
> +
> +/*
> + * Initialization of a cipher handle and establishing the connection to
> + * the kernel
> + *
> + * @handle cipher handle filled during the call - output
> + * @type cipher type, one of the following - input:
> + *	 "hash" for message digests (including keyed message digests)
> + *	 "skcipher" for symmetric ciphers
> + * @ciphername kernel crypto API cipher name as specified in
> + *	       /proc/crypto - input
> + *
> + * return: 0 upon success
> + *	   < 0 in case of error
> + *		ENOENT - algorithm not available
> + *		ENOTSUP - AF_ALG family not available
> + *		EINVAL - accept syscall failed
> + */
> +int kcapi_cipher_init(struct kcapi_handle *handle,
> +		      const char *type, const char *ciphername)
> +{
> +	struct sockaddr_alg sa;
> +
> +	memset(&sa, 0, sizeof(sa));
> +	sa.salg_family = AF_ALG;
> +	snprintf((char *)sa.salg_type, sizeof(sa.salg_type),"%s", type);
> +	snprintf((char *)sa.salg_name, sizeof(sa.salg_name),"%s", ciphername);
> +
> +	handle->tfmfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
> +	if (handle->tfmfd == -1)
> +		return -ENOTSUP;
> +
> +	if (bind(handle->tfmfd, (struct sockaddr *)&sa, sizeof(sa)) == -1) {
> +		close(handle->tfmfd);
> +		handle->tfmfd = -1;
> +		return -ENOENT;
> +	}
> +
> +	handle->opfd = accept(handle->tfmfd, NULL, 0);
> +	if (handle->opfd == -1) {
> +		close(handle->tfmfd);
> +		handle->tfmfd = -1;
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Close the cipher handle and release resources
> + *
> + * @handle cipher handle to release - input
> + *
> + * return: 0 upon success
> + */
> +int kcapi_cipher_destory(struct kcapi_handle *handle)
> +{
> +	if (handle->tfmfd != -1)
> +		close(handle->tfmfd);
> +	if (handle->opfd != -1)
> +		close(handle->opfd);
> +	return 0;
> +}
> +
> +
> +/*
> + * Set the key for the cipher handle
> + *
> + * This call is applicable for keyed message digests and symmetric ciphers.
> + *
> + * @handle cipher handle - input
> + * @key key buffer - input
> + * @keylen length of key buffer - input
> + *
> + * return: 0 upon success
> + *	   < 0 in case of error
> + */
> +int kcapi_cipher_setkey(struct kcapi_handle *handle,
> +			const unsigned char *key, size_t keylen)
> +{
> +	if (setsockopt(handle->tfmfd, SOL_ALG, ALG_SET_KEY,
> +		       key, keylen) == -1)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/*
> + * Message digest update function
> + *
> + * @handle cipher handle - input
> + * @buffer holding the data to add to the message digest - input
> + * @len buffer length - input
> + *
> + * return: 0 upon success
> + *	   < 0 in case of error
> + */
> +int kcapi_md_update(struct kcapi_handle *handle,
> +		    const unsigned char *buffer, size_t len)
> +{
> +	ssize_t r;
> +
> +	r = send(handle->opfd, buffer, len, MSG_MORE);
> +	if (r < 0 || (size_t)r < len)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +/*
> + * Message digest finalization function
> + *
> + * @handle cipher handle - input
> + * @buffer filled with the message digest - output
> + * @len buffer length - input
> + *
> + * return: 0 upon success
> + *	   < 0 in case of error
> + *		EIO - data cannot be obtained
> + *		ENOMEM - buffer is too small for the complete message digest,
> + *			 the buffer is filled with the truncated message digest
> + */
> +
> +int kcapi_md_final(struct kcapi_handle *handle,
> +		   unsigned char *buffer, size_t len)
> +{
> +	ssize_t r;
> +	struct iovec iov;
> +	struct msghdr msg;
> +
> +	iov.iov_base = (void*)(uintptr_t)buffer;
> +	iov.iov_len = len;
> +	msg.msg_name = NULL;
> +	msg.msg_namelen = 0;
> +	msg.msg_iov = &iov;
> +	msg.msg_iovlen = 1;
> +	msg.msg_control = NULL;
> +	msg.msg_controllen = 0;
> +
> +	r = recvmsg(handle->opfd, &msg, 0);
> +	if (r < 0)
> +		return -EIO;
> +	if (msg.msg_flags & MSG_TRUNC)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +/*
> + * Encrypt data
> + *
> + * @handle cipher handle - input
> + * @in plaintext data buffer - input
> + * @inlen length of in buffer - input
> + * @out ciphertext data buffer - output
> + * @outlen length of out buffer - input
> + * @iv buffer holding the IV (may be NULL if IV is not needed) - input
> + * @ivlen length of iv (should be zero if iv is NULL) - input
> + *
> + * return: 0 upon success
> + *	   < 0 in case of error
> + */
> +int kcapi_cipher_encrypt(struct kcapi_handle *handle,
> +			 const unsigned char *in, size_t inlen,
> +			 unsigned char *out, size_t outlen,
> +			 const unsigned char *iv, size_t ivlen)
> +{
> +	return _kcapi_cipher_crypt(handle, in, inlen, out, outlen,
> +				   iv, ivlen, ALG_OP_ENCRYPT);
> +}
> +
> +/*
> + * Decrypt data
> + *
> + * @handle cipher handle - input
> + * @in ciphertext data buffer - input
> + * @inlen length of in buffer - input
> + * @out plaintext data buffer - output
> + * @outlen length of out buffer - input
> + * @iv buffer holding the IV (may be NULL if IV is not needed) - input
> + * @ivlen length of iv (should be zero if iv is NULL) - input
> + *
> + * return: 0 upon success
> + *	   < 0 in case of error
> + */
> +int kcapi_cipher_decrypt(struct kcapi_handle *handle,
> +			 const unsigned char *in, size_t inlen,
> +			 unsigned char *out, size_t outlen,
> +			 const unsigned char *iv, size_t ivlen)
> +{
> +	return _kcapi_cipher_crypt(handle, in, inlen, out, outlen,
> +				   iv, ivlen, ALG_OP_DECRYPT);
> +}
> +
> +/************************************************************
> + * Application requiring cryptographic services
> + ************************************************************/
> +
> +static char hex_char_map_l[] = { '0', '1', '2', '3', '4', '5', '6', '7',
> +				 '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
> +static char hex_char_map_u[] = { '0', '1', '2', '3', '4', '5', '6', '7',
> +				 '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
> +static char hex_char(unsigned int bin, int u)
> +{
> +	if (bin < sizeof(hex_char_map_l))
> +		return (u) ? hex_char_map_u[bin] : hex_char_map_l[bin];
> +	return 'X';
> +}
> +
> +/*
> + * Convert binary string into hex representation
> + * @bin input buffer with binary data
> + * @binlen length of bin
> + * @hex output buffer to store hex data
> + * @hexlen length of already allocated hex buffer (should be at least
> + *	   twice binlen -- if not, only a fraction of binlen is converted)
> + * @u case of hex characters (0=>lower case, 1=>upper case)
> + */
> +static void bin2hex(const unsigned char *bin, size_t binlen,
> +		    char *hex, size_t hexlen, int u)
> +{
> +	size_t i = 0;
> +	size_t chars = (binlen > (hexlen / 2)) ? (hexlen / 2) : binlen;
> +
> +	for (i = 0; i < chars; i++) {
> +		hex[(i*2)] = hex_char((bin[i] >> 4), u);
> +		hex[((i*2)+1)] = hex_char((bin[i] & 0x0f), u);
> +	}
> +}
> +
> +
> +int main(int argc, char *argv[])
> +{
> +	struct kcapi_handle handle;
> +#define BUFLEN 32
> +	unsigned char inbuf[BUFLEN]; /* Plaintext */
> +#define IVLEN 16
> +	unsigned char ivbuf[IVLEN]; /* IV */
> +	unsigned char outbuf[BUFLEN]; /* ciphertext for encryption */
> +	unsigned char outbuf2[BUFLEN]; /* plaintext for decryption */
> +	char hexbuf[BUFLEN * 2 + 1];
> +
> +	(void)argc;
> +	(void)argv;
> +
> +	/*
> +	 * Calculate a message digest
> +	 */
> +	if (kcapi_cipher_init(&handle, "hash", "sha256")) {
> +		printf("Allocation of hash failed\n");
> +		return(1);
> +	}
> +	memcpy(inbuf, "\x00\x01\x02\x03\x04\x05\x06\x07"
> +		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
> +		      "\x00\x01\x02\x03\x04\x05\x06\x07"
> +		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f", BUFLEN);
> +	if (kcapi_md_update(&handle, inbuf, BUFLEN)) {
> +		printf("Hash update of buffer failed\n");
> +		return(1);
> +	}
> +	if (kcapi_md_final(&handle, outbuf, BUFLEN)) {
> +		printf("Hash final failed\n");
> +		return(1);
> +	}
> +	kcapi_cipher_destory(&handle);
> +	memset(hexbuf, 0, BUFLEN * 2 + 1);
> +	bin2hex(outbuf, BUFLEN, hexbuf, BUFLEN * 2 + 1, 0);
> +	printf("Calculated hash %s\n", hexbuf);
> +
> +	/*
> +	 * Calculate a keyed message digest
> +	 */
> +	if (kcapi_cipher_init(&handle, "hash", "hmac(sha256)")) {
> +		printf("Allocation of HMAC failed\n");
> +		return(1);
> +	}
> +	memcpy(inbuf, "\x00\x01\x02\x03\x04\x05\x06\x07"
> +		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
> +		      "\x00\x01\x02\x03\x04\x05\x06\x07"
> +		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f", BUFLEN);
> +	if (kcapi_cipher_setkey(&handle, inbuf, BUFLEN)) {
> +		printf("HMAC setkey failed\n");
> +		return(1);
> +	}
> +	if (kcapi_md_update(&handle, inbuf, BUFLEN)) {
> +		printf("HMAC update of buffer failed\n");
> +		return(1);
> +	}
> +	if (kcapi_md_final(&handle, outbuf, BUFLEN)) {
> +		printf("HMAC final failed\n");
> +		return(1);
> +	}
> +	kcapi_cipher_destory(&handle);
> +	memset(hexbuf, 0, BUFLEN * 2 + 1);
> +	bin2hex(outbuf, BUFLEN, hexbuf, BUFLEN * 2 + 1, 0);
> +	printf("Calculated hmac %s\n", hexbuf);
> +
> +	/*
> +	 * Encrypt data
> +	 */
> +	if (kcapi_cipher_init(&handle, "skcipher", "cbc(aes)")) {
> +		printf("Allocation of cipher failed\n");
> +		return(1);
> +	}
> +
> +	/* Set key */
> +	memcpy(inbuf, "\x00\x01\x02\x03\x04\x05\x06\x07"
> +		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
> +		      "\x00\x01\x02\x03\x04\x05\x06\x07"
> +		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f", BUFLEN);
> +	if (kcapi_cipher_setkey(&handle, inbuf, BUFLEN)) {
> +		printf("AES setkey failed\n");
> +		return(1);
> +	}
> +
> +	/* Prepare IV */
> +	memcpy(ivbuf, "\x00\x01\x02\x03\x04\x05\x06\x07"
> +		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f", IVLEN);
> +
> +	/*
> +	 * Encrypt inbuf -- key and plaintext are the same in this example
> +	 *
> +	 * It is perfectly legal to use inbuf for the plaintext and ciphertext
> +	 * pointers. That would mean that after the encryption operation, the
> +	 * plaintext is overwritten with the cipher text.
> +	 */
> +	if (kcapi_cipher_encrypt(&handle, inbuf, BUFLEN,
> +				 outbuf, BUFLEN, ivbuf, IVLEN)) {
> +		printf("Encryption buffer failed\n");
> +		return(1);
> +	}
> +
> +	/* outbuf now contains the cipher text */
> +	memset(hexbuf, 0, BUFLEN * 2 + 1);
> +	bin2hex(outbuf, BUFLEN, hexbuf, BUFLEN * 2 + 1, 0);
> +	printf("Encrypted data %s\n", hexbuf);
> +
> +	/*
> +	 * Decrypt previously encrypted data
> +	 *
> +	 * Just like for the encryption operation, the ciphertext buffer pointer
> +	 * and the plaintext buffer pointer may point to the same memory
> +	 * location. After completion of this operation, the ciphertext is
> +	 * overwritten with the plaintext.
> +	 */
> +	if (kcapi_cipher_decrypt(&handle, outbuf, BUFLEN,
> +				 outbuf2, BUFLEN, ivbuf, IVLEN)) {
> +		printf("Decryption buffer failed\n");
> +		return(1);
> +	}
> +	kcapi_cipher_destory(&handle);
> +	memset(hexbuf, 0, BUFLEN * 2 + 1);
> +	bin2hex(outbuf2, BUFLEN, hexbuf, BUFLEN * 2 + 1, 0);
> +	printf("Decrypted data %s\n", hexbuf);
> +	if (!memcmp(inbuf, outbuf2, BUFLEN))
> +		printf("Decrypted data match original plaintext as expected\n");
> +	else
> +		printf("FAILURE: Decrypted data does not match original plaintext\n");
> +
> +	return 0;
> +}
> +
> +Author
> +======
> +
> +Stephan Mueller <smueller@chronox.de>

regards,
Joy


