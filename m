Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3B1N2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 08:28:51 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:59174 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3B1N2u (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 28 Feb 2013 08:28:50 -0500
Message-Id: <512F69A002000078000C2020@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 28 Feb 2013 13:28:48 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "=?UTF-8?Q?Roger=20Pau=20Monn=C3=A9?=" <roger.pau@citrix.com>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 12/12] xen-block: implement
 indirect descriptors
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <1362047335-26402-13-git-send-email-roger.pau@citrix.com>
 <512F4B4402000078000C1E5B@nat28.tlf.novell.com>
 <512F46F5.5040105@citrix.com>
In-Reply-To: <512F46F5.5040105@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.02.13 at 13:00, Roger Pau Monné<roger.pau@citrix.com> wrote:
> On 28/02/13 12:19, Jan Beulich wrote:
>>>>> On 28.02.13 at 11:28, Roger Pau Monne <roger.pau@citrix.com> wrote:
>>> @@ -109,6 +111,16 @@ typedef uint64_t blkif_sector_t;
>>>   */
>>>  #define BLKIF_MAX_SEGMENTS_PER_REQUEST 11
>>>  
>>> +#define BLKIF_MAX_INDIRECT_GREFS_PER_REQUEST 8
>>> +
>>> +struct blkif_request_segment_aligned {
>>> +	grant_ref_t gref;        /* reference to I/O buffer frame        */
>>> +	/* @first_sect: first sector in frame to transfer (inclusive).   */
>>> +	/* @last_sect: last sector in frame to transfer (inclusive).     */
>>> +	uint8_t     first_sect, last_sect;
>>> +	uint16_t    _pad; /* padding to make it 8 bytes, so it's cache-aligned */
>>> +} __attribute__((__packed__));
>> 
>> What's the __packed__ for here?
> 
> Yes, that's not needed.
> 
>> 
>>> +
>>>  struct blkif_request_rw {
>>>  	uint8_t        nr_segments;  /* number of segments                   */
>>>  	blkif_vdev_t   handle;       /* only for read/write requests         */
>>> @@ -138,11 +150,24 @@ struct blkif_request_discard {
>>>  	uint8_t        _pad3;
>>>  } __attribute__((__packed__));
>>>  
>>> +struct blkif_request_indirect {
>>> +	uint8_t        indirect_op;
>>> +	uint16_t       nr_segments;
>>> +#ifdef CONFIG_X86_64
>>> +	uint32_t       _pad1;        /* offsetof(blkif_...,u.indirect.id) == 8 */
>>> +#endif
>> 
>> Either you want the structure be packed tightly (and you don't care
>> about misaligned fields), in which case you shouldn't need a padding
>> field. That's even more so as there's no padding between indirect_op
>> and nr_segments, so everything is misaligned anyway, and the
>> comment above is wrong too (offsetof() really ought to yield 7 in
>> that case).
> 
> This padding is because we want to have the "id" field at the same
> position as blkif_request_rw, so we need to add the padding for it to
> match 32 & 64 bit blkif_request_rw structures, this prevents adding some
> "if (req.op == BLKIF_OP_INDIRECT)..." if we only need to get the id of
> the request.

Oh, right, that's desirable of course.

> The comment is indeed wrong, I've copied it from blkif_request_discard
> and forgot to change the offset

But the offset stated there then is right after all - I forgot that
there is a 1-byte field outside the union (the way this is being done
in the upstream Linux header is really ugly imo, but I guess Jeremy
and/or Konrad liked it that way). That's also why the packed
attribute is needed here.

But you will probably want to switch sector_number and handle, so
that sector_number becomes aligned, and add another 16-bit
padding field between handle and indirect_grefs[].

I also wonder whether "indirect_op" wouldn't better be named
"actual_op" or just "op".

Jan
