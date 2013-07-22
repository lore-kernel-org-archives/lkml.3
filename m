Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab3GVEgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 00:36:04 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42674 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752954Ab3GVEgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 00:36:01 -0400
Message-ID: <1374467758.2061.14.camel@joe-AO722>
Subject: Re: [PATCH 1/2] Squashfs: add LZ4 compression support
From: Joe Perches <joe@perches.com>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-embedded@vger.kernel.org
Date: Sun, 21 Jul 2013 21:35:58 -0700
In-Reply-To: <1374459663-15363-2-git-send-email-phillip@squashfs.org.uk>
References: <1374459663-15363-1-git-send-email-phillip@squashfs.org.uk>
	 <1374459663-15363-2-git-send-email-phillip@squashfs.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 03:21 +0100, Phillip Lougher wrote:
> Add support for reading file systems compressed with the
> LZ4 compression algorithm.

Some whitespace trivia and a naming comment.

> diff --git a/fs/squashfs/lz4_wrapper.c b/fs/squashfs/lz4_wrapper.c
[]
> +static void *lz4_init(struct squashfs_sb_info *msblk, void *buff, int len)
[]
> +	/* LZ4 compressed filesystems always have compression options */
> +	if(comp_opts == NULL || len < sizeof(*comp_opts)) {

space after ifs please.

> +	if(le32_to_cpu(comp_opts->version) != LZ4_LEGACY) {

> +
> +
> +static void lz4_free(void *strm)

Single blank line between functions

> +static int lz4_uncompress(struct squashfs_sb_info *msblk, void **buffer,
> +	struct buffer_head **bh, int b, int offset, int length, int srclength,
> +	int pages)
> +{
> +	struct squashfs_lz4 *stream = msblk->stream;
> +	void *buff = stream->input;

It's not particularly nice to have both buffer and buff
in the same function.

Maybe void *input though char *input would be better.

> +	int avail, i, bytes = length, res;
> +	size_t dest_len = srclength;
> +
> +	mutex_lock(&msblk->read_data_mutex);
> +
> +	for (i = 0; i < b; i++) {
> +		wait_on_buffer(bh[i]);
> +		if (!buffer_uptodate(bh[i]))
> +			goto block_release;
> +
> +		avail = min(bytes, msblk->devblksize - offset);
> +		memcpy(buff, bh[i]->b_data + offset, avail);
> +		buff += avail;
> +		bytes -= avail;
> +		offset = 0;
> +		put_bh(bh[i]);
> +	}


