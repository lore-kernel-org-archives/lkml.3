Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3B1MA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 07:00:57 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:33707 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab3B1MAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 07:00:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,755,1355097600"; 
   d="scan'208";a="2020738"
Message-ID: <512F46F5.5040105@citrix.com>
Date: Thu, 28 Feb 2013 13:00:53 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 12/12] xen-block: implement indirect descriptors
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com> <1362047335-26402-13-git-send-email-roger.pau@citrix.com> <512F4B4402000078000C1E5B@nat28.tlf.novell.com>
In-Reply-To: <512F4B4402000078000C1E5B@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/13 12:19, Jan Beulich wrote:
>>>> On 28.02.13 at 11:28, Roger Pau Monne <roger.pau@citrix.com> wrote:
>> @@ -109,6 +111,16 @@ typedef uint64_t blkif_sector_t;
>>   */
>>  #define BLKIF_MAX_SEGMENTS_PER_REQUEST 11
>>  
>> +#define BLKIF_MAX_INDIRECT_GREFS_PER_REQUEST 8
>> +
>> +struct blkif_request_segment_aligned {
>> +	grant_ref_t gref;        /* reference to I/O buffer frame        */
>> +	/* @first_sect: first sector in frame to transfer (inclusive).   */
>> +	/* @last_sect: last sector in frame to transfer (inclusive).     */
>> +	uint8_t     first_sect, last_sect;
>> +	uint16_t    _pad; /* padding to make it 8 bytes, so it's cache-aligned */
>> +} __attribute__((__packed__));
> 
> What's the __packed__ for here?

Yes, that's not needed.

> 
>> +
>>  struct blkif_request_rw {
>>  	uint8_t        nr_segments;  /* number of segments                   */
>>  	blkif_vdev_t   handle;       /* only for read/write requests         */
>> @@ -138,11 +150,24 @@ struct blkif_request_discard {
>>  	uint8_t        _pad3;
>>  } __attribute__((__packed__));
>>  
>> +struct blkif_request_indirect {
>> +	uint8_t        indirect_op;
>> +	uint16_t       nr_segments;
>> +#ifdef CONFIG_X86_64
>> +	uint32_t       _pad1;        /* offsetof(blkif_...,u.indirect.id) == 8 */
>> +#endif
> 
> Either you want the structure be packed tightly (and you don't care
> about misaligned fields), in which case you shouldn't need a padding
> field. That's even more so as there's no padding between indirect_op
> and nr_segments, so everything is misaligned anyway, and the
> comment above is wrong too (offsetof() really ought to yield 7 in
> that case).

This padding is because we want to have the "id" field at the same
position as blkif_request_rw, so we need to add the padding for it to
match 32 & 64 bit blkif_request_rw structures, this prevents adding some
"if (req.op == BLKIF_OP_INDIRECT)..." if we only need to get the id of
the request.

The comment is indeed wrong, I've copied it from blkif_request_discard
and forgot to change the offset

> 
> Or you want the structure fields aligned, in which case you again
> ought to drop the use of the __packed__ attribute and introduce
> _all_ necessary padding fields.
> 
>> +	uint64_t       id;
>> +	blkif_vdev_t   handle;
>> +	blkif_sector_t sector_number;
>> +	grant_ref_t    indirect_grefs[BLKIF_MAX_INDIRECT_GREFS_PER_REQUEST];
>> +} __attribute__((__packed__));
> 
> And then it would be quite nice for new features to no longer
> require translation between a 32- and a 64-bit layout at all.

The translation is caused by the id issue described above.

> Plus, rather than introducing uninitialized padding fields, I'd
> suggest using fields that are required to be zero initialized, to
> allow giving them a meaning later.



