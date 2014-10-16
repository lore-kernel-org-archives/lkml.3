Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaJPHTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:19:18 -0400
Received: from mail.eperm.de ([89.247.134.16]:54068 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaJPHTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:19:14 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel crypto API interface specification
Date: Thu, 16 Oct 2014 09:19:08 +0200
Message-ID: <3251314.QkilbvNUO7@myon.chronox.de>
User-Agent: KMail/4.14.1 (Linux/3.16.4-200.fc20.x86_64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <20141015175800.GH17447@titan.lakedaemon.net>
References: <7502136.9BkWHTZ0th@myon.chronox.de> <20141015175800.GH17447@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 15. Oktober 2014, 13:58:00 schrieb Jason Cooper:

Hi Jason,

> Stephan,
> 
> Wow.  This is very thorough.  Herbert and others will be making the
> final call on this, but if I may make a suggestion:

Thanks.
> 
> On Tue, Oct 14, 2014 at 09:46:50PM +0200, Stephan Mueller wrote:
> > The update adds a complete interface documentation of the kernel crypto
> > API. All cipher types supported by the kernel crypto API are documented.
> > 
> > In addition, kernel and user space example code is provided. The sample
> > code covers synchronous and asynchronous cipher operation, random
> > number generation and performing hashing as well as encryption and
> > decryption in user space.
> 
> This really needs to be split into at least two pieces.  The kernel and
> the userspace API.  I'd venture to say the userspace API portion of this
> document is almost ready.  But I'm not certain that the kernel
> interfaces are best described in a specification.

Good idea, I will split it.
> 
> APIs within the kernel are intentionally not nailed down and are very
> fluid.  Any attempt to spell them out in a document would mean either a)
> the document would be out of date quickly, or b) the maintainer now has
> to ask for changes to the docs every time a patch with a kernel API
> change comes in.  Neither scenario is good. :-(

Right, but on the other hand having no documentation at all is also bad. I 
know first hand how non-straight-forward it is to use the kernel crypto API as 
I programmed a test kernel module that invokes all cipher types available. 
Even with the examples in testmgr.c, I had a number of trial and errors. For 
crypto, this is not good.

Note, the mistakes you make are not easily seen, which is a problem if you 
want to protect data :-)

The key problem is that the kernel crypto API makes some assumptions on the 
memory layout and the concept of asymmetric requests. Furthermore, the AEAD 
definitions require different data types than offered by the API. That means 
the calling code must first massage the AEAD input data (see CCM IV vs nonce 
or the CCM/GCM tag handling).

Yet, I also see that a separate documentation may easily deviate from the real 
code (I know that first hand as I have to document parts of the kernel for 
some projects :-) ). Therefore I also suggested to take the API call 
documentation out and put it into the header files where the API calls are 
specified.
> 
> We certainly don't want to lose all of the effort you've put into
> grokking the API, so we need to find a maintainable place to add it.  I
> personally think adding comments above the respective function
> blocks would work well.

Right, as I also suggested in my follow-up email. Yet, I would like to hear an 
ok from the maintainers that I can touch these files.
> 
> The examples (kernel API) are another matter entirely.  Examples that
> aren't up-to-date and usable as a template aren't helpful to anyone.
> Some would even say detrimental.  And since example code isn't actually
> *used* in the real world, it would be an extra burden keeping it up to
> date.  I think these could best be used as a reference to compare all of
> the current users to.  Anything not up to par would generate a patch.
> The best examples should be the current users in the kernel.

Yes, that is what I also fear. Yet, using the asynchronous API may not be 
straight forward. Especially AEAD has some non-obvious requirements that may 
be documented best with an example. Yet, the example may be stripped down 
drastically to focus on the key aspects.
> 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > ---
> > 
> >  Documentation/crypto/crypto-API-spec.txt | 2110
> >  ++++++++++++++++++++++++++++++ 1 file changed, 2110 insertions(+)
> >  create mode 100644 Documentation/crypto/crypto-API-spec.txt
> > 
> > diff --git a/Documentation/crypto/crypto-API-spec.txt
> > b/Documentation/crypto/crypto-API-spec.txt new file mode 100644
> > index 0000000..027fd4f
> > --- /dev/null
> > +++ b/Documentation/crypto/crypto-API-spec.txt
> > @@ -0,0 +1,2110 @@
> 
> [snip detailed explanation of current kernel API]
> 
> > +User space API
> > +==============
> > +
> > +The kernel crypto API is accessible from user space. Currently, the
> > following +ciphers are accessible:
> > +
> > +	* Message digest including keyed message digest
> > +
> > +	* Symmetric ciphers
> > +
> > +The interface is provided via Netlink using the type AF_ALG. In addition,
> > the +setsockopt option type is SOL_ALG. In case the user space header
> > files do not +export these flags yet, use the following macros:
> > +
> > +#ifndef AF_ALG
> > +#define AF_ALG 38
> > +#endif
> > +#ifndef SOL_ALG
> > +#define SOL_ALG 279
> > +#endif
> > +
> > +A cipher is accessed with the same name as done for the in-kernel API
> > calls.
> Perhaps a reference here to the final location of the kernel API
> explanations?

As I have now split out the user space API documentation from the rest. That 
document now refers back to the initial kernel-related API document.

That said, I added a precise reference to the cipher name documentation.
> 
> > +
> > +To interact with the kernel crypto API, a Netlink socket must be created
> > by +the user space application. User space invokes the cipher operation
> > with the +send/write system call family. The result of the cipher
> > operation is obtained +with the read/recv system call family.
> > +
> > +The following API calls assume that the Netlink socket descriptor is
> > already +opened by the user space application and discusses only the
> > kernel crypto API +specific invocations.
> > +
> > +Message digest API
> > +------------------
> > +
> > +The message digest type to be used for the cipher operation is selected
> > when +invoking the bind syscall. bind requires the caller to provide a
> > filled +struct sockaddr data structure. This data structure must be
> > filled as follows: +
> > +struct sockaddr_alg sa = {
> > +	.salg_family = AF_ALG,
> > +	.salg_type = "hash", /* this selects the hash logic in the kernel */
> > +	.salg_nmae = "sha1" /* this is the cipher name */
> > +};
> > +
> > +Using the send() system call, the application provides the data that
> > should be +processed with the message digest. The send system call allows
> > the following +flags to be specified:
> > +
> > +	* MSG_MORE: If this flag is set, the send system call acts like a
> > +		    message digest update function where the final hash is not
> > +		    yet calculated. If the flag is not set, the send system 
call
> > +		    calculates the final message digest immediately.
> > +
> > +With the read() system call, the application can read the message digest
> > from +the kernel crypto API. If the buffer is too small for the message
> > digest, the +flag MSG_TRUNC is set by the kernel.
> > +
> > +In order to set a message digest key, the calling application must use
> > the
> > +setsockopt() option of ALG_SET_KEY.
> 
> What happens if this is omitted?

Added:

"If the key is not set the HMAC operation is performed without the initial 
HMAC state change caused by the key."
> 
> > +
> > +
> > +Symmetric cipher API
> > +--------------------
> > +
> > +The operation is very similar to the message digest discussion. During
> > +initialization, the struct sockaddr data structure must be filled as
> > follows: +
> > +struct sockaddr_alg sa = {
> > +	.salg_family = AF_ALG,
> > +	.salg_type = "skcipher", /* this selects the symmetric cipher */
> > +	.salg_name = "cbc(aes)" /* this is the cipher name */
> > +};
> > +
> > +Using the sendmsg() system call, the application provides the data that
> > should +be processed for encryption or decryption. In addition, the IV is
> > specified +with the data structure provided by the sendmsg() system call.
> > +
> > +The sendmsg system call parameter of struct msghdr is embedded into the
> > +struct cmsghdr data structure. See recv(2) and cmsg(3) for more
> > information +on how the cmsghdr data structure is used together with the
> > send/recv system +call family. That cmsghdr data structure holds the
> > following information +specified with a separate header instances:
> > +
> > +	* specification of the cipher operation type with one of these flags:
> > +		ALG_OP_ENCRYPT - encryption of data
> > +		ALG_OP_DECRYPT - decryption of data
> > +
> > +	* specification of the IV information marked with the flag ALG_SET_IV
> > +
> > +The send system call family allows the following flag to be specified:
> > +
> > +	* MSG_MORE: If this flag is set, the send system call acts like a
> > +		    cipher update function where more input data is expected
> > +		    with a subsequent invocation of the send system call.
> > +
> > +Note: The kernel reports -EINVAL for any unexpected data. The caller must
> > +make sure that all data matches the constraints given in /proc/crypto for
> > the +selected cipher.
> > +
> > +With the read() system call, the application can read the result of the
> > +cipher operation from the kernel crypto API. The output buffer must be at
> > least +as large as to hold all blocks of the encrypted or decrypted data.
> > If the output +data size is smaller, only the as many blocks are returned
> > that fit into that
> ...only as many blocks...

Fixed
> 
> > +output buffer size.
> > +
> > +User space API example
> > +----------------------
> > +
> > +Compile the following code with the gcc flags of "-Wextra -Wall
> > -pedantic". +
> > +/*
> > + * Code from cryptsetup version 1.6.4 used as a basis
> > + */
> 
> Could you specify the git commit and file from cryptsetup?  This way, if
> the this example becomes out of date, users could easily jump to the
> newest version of working code used in the real world.

I have not added the git commit as I think the version number is precise. Yet 
I added the files containing the implementation.

I would think that the user space API would not change as much as the kernel 
API could considering the standard approach by the kernel developers with user 
space APIs in general.
> 
> > +
> > +#include <stdio.h>
> > +
> > +#include <unistd.h>
> > +#include <sys/socket.h>
> > +#include <sys/types.h>
> > +#include <linux/if_alg.h>
> > +#include <stdint.h>
> > +#include <errno.h>
> > +#include <string.h>
> > +#include <stdlib.h>
> > +
> > +#ifndef AF_ALG
> > +#define AF_ALG 38
> > +#endif
> > +#ifndef SOL_ALG
> > +#define SOL_ALG 279
> > +#endif
> > +
> > +/************************************************************
> > + * Application interfaces
> > + ************************************************************/
> > +
> > +/* Cipher handle */
> > +struct kcapi_handle {
> > +	int tfmfd;
> > +	int opfd;
> > +};
> > +
> > +/************************************************************
> > + * Internal logic
> > + ************************************************************/
> > +
> > +/* The in/out should be aligned to page boundary */
> > +static int _kcapi_cipher_crypt(struct kcapi_handle *handle,
> > +			       const unsigned char *in, size_t inlen,
> > +			       unsigned char *out, size_t outlen,
> > +			       const unsigned char *iv, size_t ivlen,
> > +			       uint32_t enc)
> > +{
> > +	int r = 0;
> > +	ssize_t ret;
> > +	struct af_alg_iv *alg_iv;
> > +	struct cmsghdr *header;
> > +	uint32_t *type;
> > +	struct iovec iov;
> > +	int iv_msg_size = iv ? CMSG_SPACE(sizeof(*alg_iv) + ivlen) : 0;
> > +	char *buffer = NULL;
> > +	unsigned int bufferlen = CMSG_SPACE(sizeof(*type)) + iv_msg_size;
> > +	struct msghdr msg;
> > +
> > +	if (!in || !out || !inlen || !outlen)
> > +		return -EINVAL;
> > +
> > +	if ((!iv && ivlen) || (iv && !ivlen))
> > +		return -EINVAL;
> > +
> > +	buffer = calloc(1, bufferlen);
> > +	if (!buffer)
> > +		return -ENOMEM;
> > +
> > +	iov.iov_base = (void*)(uintptr_t)in;
> > +	iov.iov_len = inlen;
> > +	msg.msg_control = buffer;
> > +	msg.msg_controllen = bufferlen;
> > +	msg.msg_iov = &iov;
> > +	msg.msg_iovlen = 1;
> > +
> > +	/* encrypt/decrypt operation */
> > +	header = CMSG_FIRSTHDR(&msg);
> > +	header->cmsg_level = SOL_ALG;
> > +	header->cmsg_type = ALG_SET_OP;
> > +	header->cmsg_len = CMSG_LEN(sizeof(*type));
> > +	type = (void*)CMSG_DATA(header);
> > +	*type = enc;
> > +
> > +	/* set IV */
> > +	if (iv) {
> > +		header = CMSG_NXTHDR(&msg, header);
> > +		header->cmsg_level = SOL_ALG;
> > +		header->cmsg_type = ALG_SET_IV;
> > +		header->cmsg_len = iv_msg_size;
> > +		alg_iv = (void*)CMSG_DATA(header);
> > +		alg_iv->ivlen = ivlen;
> > +		memcpy(alg_iv->iv, iv, ivlen);
> > +	}
> > +
> > +	ret = sendmsg(handle->opfd, &msg, 0);
> > +	if (ret != (ssize_t)inlen) {
> > +		r = -EIO;
> > +		goto bad;
> > +	}
> > +
> > +	ret = read(handle->opfd, out, outlen);
> > +	if (ret != (ssize_t)outlen)
> > +		r = -EIO;
> > +bad:
> > +	memset(buffer, 0, bufferlen);
> 
> Not related to this patch, but you should take a look at:
> 
>   http://www.daemonology.net/blog/2014-09-04-how-to-zero-a-buffer.html
>  
> http://www.daemonology.net/blog/2014-09-06-zeroing-buffers-is-insufficient.
> html

Absolutely. Thanks for hinting to that. I added a memchr after the memset:

	memset(buffer, 0, bufferlen);
	_buffer = memchr(buffer, 1, bufferlen);
	if (_buffer)
		_buffer = '\0';
> > +	free(buffer);
> > +	return r;
> > +}
> > +
> > +
> > +/************************************************************
> > + * API to application
> > + ************************************************************/
> > +
> > +/*
> > + * Initialization of a cipher handle and establishing the connection to
> > + * the kernel
> > + *
> > + * @handle cipher handle filled during the call - output
> > + * @type cipher type, one of the following - input:
> > + *	 "hash" for message digests (including keyed message digests)
> > + *	 "skcipher" for symmetric ciphers
> > + * @ciphername kernel crypto API cipher name as specified in
> > + *	       /proc/crypto - input
> > + *
> > + * return: 0 upon success
> > + *	   < 0 in case of error
> > + *		ENOENT - algorithm not available
> > + *		ENOTSUP - AF_ALG family not available
> > + *		EINVAL - accept syscall failed
> > + */
> > +int kcapi_cipher_init(struct kcapi_handle *handle,
> > +		      const char *type, const char *ciphername)
> > +{
> > +	struct sockaddr_alg sa;
> > +
> > +	memset(&sa, 0, sizeof(sa));
> > +	sa.salg_family = AF_ALG;
> > +	snprintf((char *)sa.salg_type, sizeof(sa.salg_type),"%s", type);
> > +	snprintf((char *)sa.salg_name, sizeof(sa.salg_name),"%s", ciphername);
> > +
> > +	handle->tfmfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
> > +	if (handle->tfmfd == -1)
> > +		return -ENOTSUP;
> > +
> > +	if (bind(handle->tfmfd, (struct sockaddr *)&sa, sizeof(sa)) == -1) {
> > +		close(handle->tfmfd);
> > +		handle->tfmfd = -1;
> > +		return -ENOENT;
> > +	}
> > +
> > +	handle->opfd = accept(handle->tfmfd, NULL, 0);
> > +	if (handle->opfd == -1) {
> > +		close(handle->tfmfd);
> > +		handle->tfmfd = -1;
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Close the cipher handle and release resources
> > + *
> > + * @handle cipher handle to release - input
> > + *
> > + * return: 0 upon success
> > + */
> > +int kcapi_cipher_destory(struct kcapi_handle *handle)
> > +{
> > +	if (handle->tfmfd != -1)
> > +		close(handle->tfmfd);
> > +	if (handle->opfd != -1)
> > +		close(handle->opfd);
> > +	return 0;
> > +}
> > +
> > +
> > +/*
> > + * Set the key for the cipher handle
> > + *
> > + * This call is applicable for keyed message digests and symmetric
> > ciphers. + *
> > + * @handle cipher handle - input
> > + * @key key buffer - input
> > + * @keylen length of key buffer - input
> > + *
> > + * return: 0 upon success
> > + *	   < 0 in case of error
> > + */
> > +int kcapi_cipher_setkey(struct kcapi_handle *handle,
> > +			const unsigned char *key, size_t keylen)
> > +{
> > +	if (setsockopt(handle->tfmfd, SOL_ALG, ALG_SET_KEY,
> > +		       key, keylen) == -1)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Message digest update function
> > + *
> > + * @handle cipher handle - input
> > + * @buffer holding the data to add to the message digest - input
> > + * @len buffer length - input
> > + *
> > + * return: 0 upon success
> > + *	   < 0 in case of error
> > + */
> > +int kcapi_md_update(struct kcapi_handle *handle,
> > +		    const unsigned char *buffer, size_t len)
> > +{
> > +	ssize_t r;
> > +
> > +	r = send(handle->opfd, buffer, len, MSG_MORE);
> > +	if (r < 0 || (size_t)r < len)
> > +		return -EIO;
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Message digest finalization function
> > + *
> > + * @handle cipher handle - input
> > + * @buffer filled with the message digest - output
> > + * @len buffer length - input
> > + *
> > + * return: 0 upon success
> > + *	   < 0 in case of error
> > + *		EIO - data cannot be obtained
> > + *		ENOMEM - buffer is too small for the complete message digest,
> > + *			 the buffer is filled with the truncated message 
digest
> > + */
> > +
> > +int kcapi_md_final(struct kcapi_handle *handle,
> > +		   unsigned char *buffer, size_t len)
> > +{
> > +	ssize_t r;
> > +	struct iovec iov;
> > +	struct msghdr msg;
> > +
> > +	iov.iov_base = (void*)(uintptr_t)buffer;
> > +	iov.iov_len = len;
> > +	msg.msg_name = NULL;
> > +	msg.msg_namelen = 0;
> > +	msg.msg_iov = &iov;
> > +	msg.msg_iovlen = 1;
> > +	msg.msg_control = NULL;
> > +	msg.msg_controllen = 0;
> > +
> > +	r = recvmsg(handle->opfd, &msg, 0);
> > +	if (r < 0)
> > +		return -EIO;
> > +	if (msg.msg_flags & MSG_TRUNC)
> > +		return -ENOMEM;
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Encrypt data
> > + *
> > + * @handle cipher handle - input
> > + * @in plaintext data buffer - input
> > + * @inlen length of in buffer - input
> > + * @out ciphertext data buffer - output
> > + * @outlen length of out buffer - input
> > + * @iv buffer holding the IV (may be NULL if IV is not needed) - input
> > + * @ivlen length of iv (should be zero if iv is NULL) - input
> > + *
> > + * return: 0 upon success
> > + *	   < 0 in case of error
> > + */
> > +int kcapi_cipher_encrypt(struct kcapi_handle *handle,
> > +			 const unsigned char *in, size_t inlen,
> > +			 unsigned char *out, size_t outlen,
> > +			 const unsigned char *iv, size_t ivlen)
> > +{
> > +	return _kcapi_cipher_crypt(handle, in, inlen, out, outlen,
> > +				   iv, ivlen, ALG_OP_ENCRYPT);
> > +}
> > +
> > +/*
> > + * Decrypt data
> > + *
> > + * @handle cipher handle - input
> > + * @in ciphertext data buffer - input
> > + * @inlen length of in buffer - input
> > + * @out plaintext data buffer - output
> > + * @outlen length of out buffer - input
> > + * @iv buffer holding the IV (may be NULL if IV is not needed) - input
> > + * @ivlen length of iv (should be zero if iv is NULL) - input
> > + *
> > + * return: 0 upon success
> > + *	   < 0 in case of error
> > + */
> > +int kcapi_cipher_decrypt(struct kcapi_handle *handle,
> > +			 const unsigned char *in, size_t inlen,
> > +			 unsigned char *out, size_t outlen,
> > +			 const unsigned char *iv, size_t ivlen)
> > +{
> > +	return _kcapi_cipher_crypt(handle, in, inlen, out, outlen,
> > +				   iv, ivlen, ALG_OP_DECRYPT);
> > +}
> > +
> > +/************************************************************
> > + * Application requiring cryptographic services
> > + ************************************************************/
> > +
> > +static char hex_char_map_l[] = { '0', '1', '2', '3', '4', '5', '6', '7',
> > +				 '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
> > +static char hex_char_map_u[] = { '0', '1', '2', '3', '4', '5', '6', '7',
> > +				 '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
> > +static char hex_char(unsigned int bin, int u)
> > +{
> > +	if (bin < sizeof(hex_char_map_l))
> > +		return (u) ? hex_char_map_u[bin] : hex_char_map_l[bin];
> > +	return 'X';
> > +}
> > +
> > +/*
> > + * Convert binary string into hex representation
> > + * @bin input buffer with binary data
> > + * @binlen length of bin
> > + * @hex output buffer to store hex data
> > + * @hexlen length of already allocated hex buffer (should be at least
> > + *	   twice binlen -- if not, only a fraction of binlen is converted)
> > + * @u case of hex characters (0=>lower case, 1=>upper case)
> > + */
> > +static void bin2hex(const unsigned char *bin, size_t binlen,
> > +		    char *hex, size_t hexlen, int u)
> > +{
> > +	size_t i = 0;
> > +	size_t chars = (binlen > (hexlen / 2)) ? (hexlen / 2) : binlen;
> > +
> > +	for (i = 0; i < chars; i++) {
> > +		hex[(i*2)] = hex_char((bin[i] >> 4), u);
> > +		hex[((i*2)+1)] = hex_char((bin[i] & 0x0f), u);
> > +	}
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +	struct kcapi_handle handle;
> > +#define BUFLEN 32
> > +	unsigned char inbuf[BUFLEN];
> > +#define IVLEN 16
> > +	unsigned char ivbuf[IVLEN];
> > +	unsigned char outbuf[BUFLEN];
> > +	unsigned char outbuf2[BUFLEN];
> > +	char hexbuf[BUFLEN * 2 + 1];
> > +
> > +	(void)argc;
> > +	(void)argv;
> > +
> > +	/*
> > +	 * Calculate a message digest
> > +	 */
> > +	if (kcapi_cipher_init(&handle, "hash", "sha256")) {
> > +		printf("Allocation of hash failed\n");
> > +		return(1);
> > +	}
> > +	memcpy(inbuf, "\x00\x01\x02\x03\x04\x05\x06\x07"
> > +		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
> > +		      "\x00\x01\x02\x03\x04\x05\x06\x07"
> > +		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f", BUFLEN);
> > +	if (kcapi_md_update(&handle, inbuf, BUFLEN)) {
> > +		printf("Hash update of buffer failed\n");
> > +		return(1);
> > +	}
> > +	if (kcapi_md_final(&handle, outbuf, BUFLEN)) {
> > +		printf("Hash final failed\n");
> > +		return(1);
> > +	}
> > +	kcapi_cipher_destory(&handle);
> > +	memset(hexbuf, 0, BUFLEN * 2 + 1);
> > +	bin2hex(outbuf, BUFLEN, hexbuf, BUFLEN * 2 + 1, 0);
> > +	printf("Calculated hash %s\n", hexbuf);
> > +
> > +	/*
> > +	 * Calculate a keyed message digest
> > +	 */
> > +	if (kcapi_cipher_init(&handle, "hash", "hmac(sha256)")) {
> > +		printf("Allocation of HMAC failed\n");
> > +		return(1);
> > +	}
> > +	memcpy(inbuf, "\x00\x01\x02\x03\x04\x05\x06\x07"
> > +		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
> > +		      "\x00\x01\x02\x03\x04\x05\x06\x07"
> > +		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f", BUFLEN);
> > +	if (kcapi_cipher_setkey(&handle, inbuf, BUFLEN)) {
> > +		printf("HMAC setkey failed\n");
> > +		return(1);
> > +	}
> > +	if (kcapi_md_update(&handle, inbuf, BUFLEN)) {
> > +		printf("HMAC update of buffer failed\n");
> > +		return(1);
> > +	}
> > +	if (kcapi_md_final(&handle, outbuf, BUFLEN)) {
> > +		printf("HMAC final failed\n");
> > +		return(1);
> > +	}
> > +	kcapi_cipher_destory(&handle);
> 
> Did you test building this?

Yes, I did and it worked flawlessly. Just copy out the code and compile as 
stated in the comments. What are your concerns?

See the following code where I call kcapi_cipher_init again.
> 
> > +	memset(hexbuf, 0, BUFLEN * 2 + 1);
> > +	bin2hex(outbuf, BUFLEN, hexbuf, BUFLEN * 2 + 1, 0);
> > +	printf("Calculated hmac %s\n", hexbuf);
> > +
> > +	/*
> > +	 * Encrypt data
> > +	 */
> > +	if (kcapi_cipher_init(&handle, "skcipher", "cbc(aes)")) {
> > +		printf("Allocation of cipher failed\n");
> > +		return(1);
> > +	}
> > +	memcpy(inbuf, "\x00\x01\x02\x03\x04\x05\x06\x07"
> > +		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
> > +		      "\x00\x01\x02\x03\x04\x05\x06\x07"
> > +		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f", BUFLEN);
> > +	if (kcapi_cipher_setkey(&handle, inbuf, BUFLEN)) {
> > +		printf("AES setkey failed\n");
> > +		return(1);
> > +	}
> > +	memcpy(ivbuf, "\x00\x01\x02\x03\x04\x05\x06\x07"
> > +		      "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f", IVLEN);
> > +	if (kcapi_cipher_encrypt(&handle, inbuf, BUFLEN,
> > +				 outbuf, BUFLEN, ivbuf, IVLEN)) {
> > +		printf("Encryption buffer failed\n");
> > +		return(1);
> > +	}
> > +	memset(hexbuf, 0, BUFLEN * 2 + 1);
> > +	bin2hex(outbuf, BUFLEN, hexbuf, BUFLEN * 2 + 1, 0);
> > +	printf("Encrypted data %s\n", hexbuf);
> > +
> > +	/*
> > +	 * Decrypt previously encrypted data
> > +	 */
> > +	if (kcapi_cipher_decrypt(&handle, outbuf, BUFLEN,
> > +				 outbuf2, BUFLEN, ivbuf, IVLEN)) {
> > +		printf("Decryption buffer failed\n");
> > +		return(1);
> > +	}
> > +	kcapi_cipher_destory(&handle);
> > +	memset(hexbuf, 0, BUFLEN * 2 + 1);
> > +	bin2hex(outbuf2, BUFLEN, hexbuf, BUFLEN * 2 + 1, 0);
> > +	printf("Decrypted data %s\n", hexbuf);
> > +	if (!memcmp(inbuf, outbuf2, BUFLEN))
> > +		printf("Decrypted data match original plaintext as 
expected\n");
> > +	else
> > +		printf("FAILURE: Decrypted data does not match original 
plaintext\n");
> > +
> > +	return 0;
> > +}
> > +
> > +License of code
> > +===============
> > +/*
> > + * Copyright (C) 2014, Stephan Mueller <smueller@chronox.de>
> > + *
> > + * Redistribution and use in source and binary forms, with or without
> > + * modification, are permitted provided that the following conditions
> > + * are met:
> > + * 1. Redistributions of source code must retain the above copyright
> > + *    notice, and the entire permission notice in its entirety,
> > + *    including the disclaimer of warranties.
> > + * 2. Redistributions in binary form must reproduce the above copyright
> > + *    notice, this list of conditions and the following disclaimer in the
> > + *    documentation and/or other materials provided with the
> > distribution.
> > + * 3. The name of the author may not be used to endorse or promote
> > + *    products derived from this software without specific prior
> > + *    written permission.
> > + *
> > + * ALTERNATIVELY, this product may be distributed under the terms of
> > + * the GNU General Public License, in which case the provisions of the
> > GPL2 are + * required INSTEAD OF the above restrictions.  (This clause is
> > + * necessary due to a potential bad interaction between the GPL and
> > + * the restrictions contained in a BSD-style copyright.)
> > + *
> > + * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
> > + * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
> > + * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
> > + * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
> > + * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> > + * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
> > + * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
> > + * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
> > + * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> > + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
> > + * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
> > + * DAMAGE.
> > + */
> 
> Perhaps the userspace API example should be a separate file with this
> text at the top?  Seems odd having it at the end.  Also, if you copied
> it from cryptsetup, is the copyright info correct?

I did not copy it from cryptsetup. I only used it as a basis, especially with 
the data structure handling in _kcapi_cipher_crypt. But you are right, I 
changed the license for the user space by taking the cryptsetup license.

Thanks

-- 
Ciao
Stephan
