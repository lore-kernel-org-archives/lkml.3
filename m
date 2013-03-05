Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab3CERIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:08:00 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:53113 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab3CERH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:07:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,787,1355097600"; 
   d="scan'208";a="2199087"
Message-ID: <5136266D.8050707@citrix.com>
Date: Tue, 5 Mar 2013 18:07:57 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH RFC 12/12] xen-block: implement indirect descriptors
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com> <1362047335-26402-13-git-send-email-roger.pau@citrix.com> <20130304204154.GL15386@phenom.dumpdata.com>
In-Reply-To: <20130304204154.GL15386@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/13 21:41, Konrad Rzeszutek Wilk wrote:
> On Thu, Feb 28, 2013 at 11:28:55AM +0100, Roger Pau Monne wrote:
>> Indirect descriptors introduce a new block operation
>> (BLKIF_OP_INDIRECT) that passes grant references instead of segments
>> in the request. This grant references are filled with arrays of
>> blkif_request_segment_aligned, this way we can send more segments in a
>> request.
>>
>> The proposed implementation sets the maximum number of indirect grefs
>> (frames filled with blkif_request_segment_aligned) to 256 in the
>> backend and 64 in the frontend. The value in the frontend has been
>> chosen experimentally, and the backend value has been set to a sane
>> value that allows expanding the maximum number of indirect descriptors
>> in the frontend if needed.
> 
> So we are still using a similar format of the form:
> 
> <gref, first_sec, last_sect, pad>, etc.
> 
> Why not utilize a layout that fits with the bio sg? That way
> we might not even have to do the bio_alloc call and instead can
> setup an bio (and bio-list) with the appropiate offsets/list?
> 
> Meaning that the format of the indirect descriptors is:
> 
> <gref, offset, next_index, pad>
> 
> We already know what the first_sec and last_sect are - they
> are basically: sector_number +  nr_segments * (whatever the sector size is) + offset

This will of course be suitable for Linux, but what about other OSes, I
know they support the traditional first_sec, last_sect (because it's
already implemented), but I don't know how much work will it be for them
to adopt this. If we have to do such a change I will have to check first
that other frontend/backend can handle this easily also, I wouldn't like
to simplify this for Linux by making it more difficult to implement in
other OSes...

