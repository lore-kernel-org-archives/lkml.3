Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936415Ab3DIVCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:02:09 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:53432 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936281Ab3DIVCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:02:07 -0400
Date: Tue, 9 Apr 2013 14:02:01 -0700
From: Tejun Heo <tj@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>
Subject: Re: dm-crypt parallelization patches
Message-ID: <20130409210201.GM6186@mtj.dyndns.org>
References: <20130328194443.GG14088@htj.dyndns.org>
 <20130328203808.GC15969@redhat.com>
 <20130328204522.GA25501@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091242350.10025@file.rdu.redhat.com>
 <20130409175753.GA6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
 <20130409181031.GC6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
 <20130409195259.GL6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Apr 09, 2013 at 04:32:28PM -0400, Mikulas Patocka wrote:
> > and we probably need to change that to bio_associate_task().
> 
> Generally, we shouldn't associate bios with "current" task in device 
> mapper targets. For example suppose that we have two stacked dm-crypt 
> targets:

It only follows the first association so it doesn't matter how many
layers it goes through.  That said, yeah, there could be situations
where @task is availalbe but the bio's already in the hand of a
different task.  If that's the case, change it to
associate_task(@task).

> It doesn't work because device mapper on the underlying layers ignores 
> bi_ioc and bi_css.
> 
> If I make device mapper forward bi_ioc and bi_css to outgoing bios, it 
> improves performance (from 2:30 to 1:30), but it is still far from 
> perfect.

For testing, copying bi_ioc and bi_css directly is fine but please add
another interface to copy those for the actual code.  Say,
bio_copy_association(@to_bio, @from_bio) or whatever.

As for the performance loss, I'm somewhat confident in saying the
remaining difference would be from ignoring plugging boundaries.

Thanks.

-- 
tejun
