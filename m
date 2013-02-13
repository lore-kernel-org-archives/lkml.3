Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939Ab3BMQCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:02:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759412Ab3BMQCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:02:34 -0500
Message-ID: <511BB902.3080302@redhat.com>
Date: Wed, 13 Feb 2013 17:02:10 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alex Bligh <alex@alex.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        nbd-general@lists.sf.net, Paul Clements <Paul.Clements@steeleye.com>
Subject: Re: [PATCH 1/3] nbd: support FLUSH requests
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com> <1360685171-3792-2-git-send-email-pbonzini@redhat.com> <115932E2-48BE-406E-9E75-61D12EB5937A@alex.org.uk> <511A8491.5030407@redhat.com> <20130212133207.ef6b24f5.akpm@linux-foundation.org> <FF1216D8-C4B3-405E-A4F6-82196A796A94@alex.org.uk> <511B8E65.5020507@redhat.com> <3EDEF735-9A67-439E-BA65-089C6AAFD1BF@alex.org.uk>
In-Reply-To: <3EDEF735-9A67-439E-BA65-089C6AAFD1BF@alex.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/02/2013 16:55, Alex Bligh ha scritto:
>> > But as far as I can test with free servers, the FUA bits have no
>> > advantage over flush.  Also, I wasn't sure if SEND_FUA without
>> > SEND_FLUSH is valid, and if so how to handle this combination (treat it
>> > as writethrough and add FUA to all requests? warn and do nothing?).
> On the main opensource nbd client, the following applies:
> 
> What REQ_FUA does is an fdatasync() after the write. Code extract and
> comments below from Christoph Hellwig.
> 
> What REQ_FLUSH does is to do an fsync().
> 
> The way I read Christoph's comment, provided the linux block layer always
> issues a REQ_FLUSH before a REQ_FUA, there is not performance problem.
> 
> However, a REQ_FUA is going to do a f(data)?sync AFTER the write, whereas
> the preceding REQ_FLUSH is going to an fsync() BEFORE the write. It seems
> to me that either the FUA and FLUSH semantics are therefore different
> (and we need FUA), or that Christoph's comment is wrong and that you
> are guaranteed a REQ_FLUSH *after* the write with REQ_FUA.

REQ_FLUSH is indeed a flush before the write.  fdatasync is fine there too.

If you do not have REQ_FUA, as is the case with this patch, the block
layer converts it to a REQ_FLUSH *after* the write.

See block/blk-flush.c:

 * REQ_{FLUSH|FUA} requests are decomposed to sequences consisted of three
 * optional steps - PREFLUSH, DATA and POSTFLUSH - according to the request
 * properties and hardware capability.
 *
 * If the device doesn't have writeback cache, FLUSH and FUA don't make any
 * difference.  The requests are either completed immediately if there's no
 * data or executed as normal requests otherwise.
 *
 * If the device has writeback cache and supports FUA, REQ_FLUSH is
 * translated to PREFLUSH but REQ_FUA is passed down directly with DATA.
 *
 * If the device has writeback cache and doesn't support FUA, REQ_FLUSH is
 * translated to PREFLUSH and REQ_FUA to POSTFLUSH.

Paolo
