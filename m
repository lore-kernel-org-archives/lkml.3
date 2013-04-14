Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3DNQRm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:17:42 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:53104 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3DNQRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:17:40 -0400
Message-ID: <516AD6A0.2060804@gmail.com>
Date: Sun, 14 Apr 2013 18:17:36 +0200
From: Milan Broz <gmazyland@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: linux-crypto@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] algif_skcipher: Avoid crash if buffer is not multiple
 of cipher block size
References: <1365955952-12381-1-git-send-email-gmazyland@gmail.com>
In-Reply-To: <1365955952-12381-1-git-send-email-gmazyland@gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2013 06:12 PM, Milan Broz wrote:
> When user requests encryption (or decryption) of block which
> is not aligned to cipher block size through userspace crypto
> interface, an OOps like this can happen

And this is a reproducer for the problem above...

Milan

/* 
 * Check for unaligned buffer to block cipher size in kernel crypto API
 * fixed by patch: http://article.gmane.org/gmane.linux.kernel.cryptoapi/7980
 * 
 * Compile with gcc test.c -o tst
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#include <errno.h>
#include <unistd.h>
#include <sys/socket.h>
#include <linux/if_alg.h>

#ifndef AF_ALG
#define AF_ALG 38
#endif
#ifndef SOL_ALG
#define SOL_ALG 279
#endif

static int kernel_crypt(int opfd, const char *in, char *out, size_t length,
			 const char *iv, size_t iv_length, uint32_t direction)
{
	int r = 0;
	ssize_t len;
	struct af_alg_iv *alg_iv;
	struct cmsghdr *header;
	uint32_t *type;
	struct iovec iov = {
		.iov_base = (void*)(uintptr_t)in,
		.iov_len = length,
	};
	int iv_msg_size = iv ? CMSG_SPACE(sizeof(*alg_iv) + iv_length) : 0;
	char buffer[CMSG_SPACE(sizeof(type)) + iv_msg_size];
	struct msghdr msg = {
		.msg_control = buffer,
		.msg_controllen = sizeof(buffer),
		.msg_iov = &iov,
		.msg_iovlen = 1,
	};

	if (!in || !out || !length)
		return -EINVAL;

	if ((!iv && iv_length) || (iv && !iv_length))
		return -EINVAL;

	memset(buffer, 0, sizeof(buffer));

	/* Set encrypt/decrypt operation */
	header = CMSG_FIRSTHDR(&msg);
	header->cmsg_level = SOL_ALG;
	header->cmsg_type = ALG_SET_OP;
	header->cmsg_len = CMSG_LEN(sizeof(type));
	type = (void*)CMSG_DATA(header);
	*type = direction;

	/* Set IV */
	if (iv) {
		header = CMSG_NXTHDR(&msg, header);
		header->cmsg_level = SOL_ALG;
		header->cmsg_type = ALG_SET_IV;
		header->cmsg_len = iv_msg_size;
		alg_iv = (void*)CMSG_DATA(header);
		alg_iv->ivlen = iv_length;
		memcpy(alg_iv->iv, iv, iv_length);
	}

	len = sendmsg(opfd, &msg, 0);
	if (len != (ssize_t)length) {
		r = -EIO;
		goto bad;
	}

	len = read(opfd, out, length);
	if (len != (ssize_t)length)
		r = -EIO;
bad:
	memset(buffer, 0, sizeof(buffer));
	return r;
}

int main (int argc, char *argv[])
{
	const char key[32] = "0123456789abcdef0123456789abcdef";
	const char iv[16] =  "0000000000000001";
	struct sockaddr_alg sa = {
		.salg_family = AF_ALG,
		.salg_type = "skcipher",
		.salg_name = "cbc(aes)"
	};
	int tfmfd, opfd;
	char *data;

	if (posix_memalign((void*)&data, 4096, 32)) {
		printf("Cannot alloc memory.\n");
		return 1;
	}

	tfmfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
	if (tfmfd == -1)
		goto bad;

	if (bind(tfmfd, (struct sockaddr *)&sa, sizeof(sa)) == -1)
		goto bad;

	opfd = accept(tfmfd, NULL, 0);
	if (opfd == -1)
		goto bad;

	if (setsockopt(tfmfd, SOL_ALG, ALG_SET_KEY, key, sizeof(key)) == -1)
		goto bad;

	if (kernel_crypt(opfd, data, data, 1, iv, sizeof(iv), ALG_OP_ENCRYPT) < 0)
		printf("Cannot encrypt data.\n");

	close(tfmfd);
	close(opfd);
	free(data);
	return 0;
bad:
	printf("Cannot initialise cipher.\n");
	return 1;
}
