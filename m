Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaKVAC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 19:02:59 -0500
Received: from smtp.outflux.net ([198.145.64.163]:53405 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbaKVAC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 19:02:57 -0500
Date: Fri, 21 Nov 2014 16:02:53 -0800
From: Kees Cook <keescook@chromium.org>
To: Dmitry Chernenkov <dmitryc@google.com>
Cc: tyhicks@canonical.com, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: PROBLEM: apparent out-of-bounds memory write in
 fs/ecryptfs/crypto.c
Message-ID: <20141122000253.GE18807@outflux.net>
References: <CAA6XgkE7vDmYn+QCMVkr39D_3V_bcF66P9G0v5=na-aOYq8RcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA6XgkE7vDmYn+QCMVkr39D_3V_bcF66P9G0v5=na-aOYq8RcA@mail.gmail.com>
Organization: Chromium
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Fri, Nov 21, 2014 at 04:44:02PM +0400, Dmitry Chernenkov wrote:
> Hi!
> 
> The following issue was discovered using Kernel Address Sanitizer
> we're developing
> (https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel,
> https://github.com/google/kasan/blob/kasan/Documentation/kasan.txt)
> 
> The apparent problem is here (fs/ecryptfs/crypto.c:1866 ..  I tested
> on kernel 3.14, but looks like the issue is still there upstream):
> 
> static size_t ecryptfs_max_decoded_size(size_t encoded_size)
> {
> /* Not exact; conservatively long. Every block of 4
> * encoded characters decodes into a block of 3
> * decoded characters. This segment of code provides
> * the caller with the maximum amount of allocated
> * space that @dst will need to point to in a
> * subsequent call. */
> return ((encoded_size + 1) * 3) / 4;
> }
> 
> /**
>  * ecryptfs_decode_from_filename
>  * @dst: If NULL, this function only sets @dst_size and returns. If
>  *       non-NULL, this function decodes the encoded octets in @src
>  *       into the memory that @dst points to.
>  * @dst_size: Set to the size of the decoded string.
>  * @src: The encoded set of octets to decode.
>  * @src_size: The size of the encoded set of octets to decode.
>  */
> static void
> ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
>      const unsigned char *src, size_t src_size)
> {
> u8 current_bit_offset = 0;
> size_t src_byte_offset = 0;
> size_t dst_byte_offset = 0;
> 
> if (dst == NULL) {
> (*dst_size) = ecryptfs_max_decoded_size(src_size);
> goto out;
> }
> while (src_byte_offset < src_size) {
> unsigned char src_byte =
> filename_rev_map[(int)src[src_byte_offset]];
> 
> switch (current_bit_offset) {
> case 0:
> dst[dst_byte_offset] = (src_byte << 2);
> current_bit_offset = 6;
> break;
> case 6:
> dst[dst_byte_offset++] |= (src_byte >> 4);
> dst[dst_byte_offset] = ((src_byte & 0xF)
> << 4);
> current_bit_offset = 4;
> break;
> case 4:
> dst[dst_byte_offset++] |= (src_byte >> 2);
> dst[dst_byte_offset] = (src_byte << 6);
> current_bit_offset = 2;
> break;
> case 2:
> dst[dst_byte_offset++] |= (src_byte);
> dst[dst_byte_offset] = 0;
> current_bit_offset = 0;
> break;
> }
> src_byte_offset++;
> }
> (*dst_size) = dst_byte_offset;
> out:
> return;
> }
> For src_size multiple of 4 (which I assume is usually the case), the
> line "dst[dst_byte_offset] = 0;" writes  at dst[dst_size] reported in
> the ecryptfs_max_decoded_size. The caller mallocs exactly dst_size
> bytes for dst, so the write is outside the allocated space. Depending
> on allocator, this can be exploited to overwrite the next object's
> first byte. I didn't exactly understand whether dst should be a
> 0-terminated string, so we either need to skip writing the trailing
> zero or allocate 1 more byte.

Thanks for reporting this!

Based on a quick read, it looks like the only consumer of the decoded
memory is ecryptfs_parse_tag_70_packet, and it uses the passed size for
its parsing. It seems like dropping this line from
ecryptfs_decode_from_filename() would solve the issue:

    dst[dst_byte_offset] = 0;

The state machine goes from case 2 back to case 0. If we're at the end,
dst_byte_offset is the correct value, and the rest of the buffer is
untouched. If we have more to go, case 0 will strictly initialize the
contents of dst[dst_byte_offset] since it uses "=" not "|=".

Thoughts?

-Kees

-- 
Kees Cook
Chrome OS Security
