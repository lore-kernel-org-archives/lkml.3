Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab3B1LTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:19:20 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:51862 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3B1LTT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 28 Feb 2013 06:19:19 -0500
Message-Id: <512F4B4402000078000C1E5B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 28 Feb 2013 11:19:16 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Roger Pau Monne" <roger.pau@citrix.com>
Cc: <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 12/12] xen-block: implement
 indirect descriptors
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <1362047335-26402-13-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1362047335-26402-13-git-send-email-roger.pau@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.02.13 at 11:28, Roger Pau Monne <roger.pau@citrix.com> wrote:
> @@ -109,6 +111,16 @@ typedef uint64_t blkif_sector_t;
>   */
>  #define BLKIF_MAX_SEGMENTS_PER_REQUEST 11
>  
> +#define BLKIF_MAX_INDIRECT_GREFS_PER_REQUEST 8
> +
> +struct blkif_request_segment_aligned {
> +	grant_ref_t gref;        /* reference to I/O buffer frame        */
> +	/* @first_sect: first sector in frame to transfer (inclusive).   */
> +	/* @last_sect: last sector in frame to transfer (inclusive).     */
> +	uint8_t     first_sect, last_sect;
> +	uint16_t    _pad; /* padding to make it 8 bytes, so it's cache-aligned */
> +} __attribute__((__packed__));

What's the __packed__ for here?

> +
>  struct blkif_request_rw {
>  	uint8_t        nr_segments;  /* number of segments                   */
>  	blkif_vdev_t   handle;       /* only for read/write requests         */
> @@ -138,11 +150,24 @@ struct blkif_request_discard {
>  	uint8_t        _pad3;
>  } __attribute__((__packed__));
>  
> +struct blkif_request_indirect {
> +	uint8_t        indirect_op;
> +	uint16_t       nr_segments;
> +#ifdef CONFIG_X86_64
> +	uint32_t       _pad1;        /* offsetof(blkif_...,u.indirect.id) == 8 */
> +#endif

Either you want the structure be packed tightly (and you don't care
about misaligned fields), in which case you shouldn't need a padding
field. That's even more so as there's no padding between indirect_op
and nr_segments, so everything is misaligned anyway, and the
comment above is wrong too (offsetof() really ought to yield 7 in
that case).

Or you want the structure fields aligned, in which case you again
ought to drop the use of the __packed__ attribute and introduce
_all_ necessary padding fields.

> +	uint64_t       id;
> +	blkif_vdev_t   handle;
> +	blkif_sector_t sector_number;
> +	grant_ref_t    indirect_grefs[BLKIF_MAX_INDIRECT_GREFS_PER_REQUEST];
> +} __attribute__((__packed__));

And then it would be quite nice for new features to no longer
require translation between a 32- and a 64-bit layout at all.

Plus, rather than introducing uninitialized padding fields, I'd
suggest using fields that are required to be zero initialized, to
allow giving them a meaning later.

Jan

