Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab3C1Up2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 16:45:28 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:57662 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3C1Up1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:45:27 -0400
Date: Thu, 28 Mar 2013 13:45:22 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
        Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: dm-crypt performance
Message-ID: <20130328204522.GA25501@mtj.dyndns.org>
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
 <20130326122713.GC27610@agk-dp.fab.redhat.com>
 <5151FF82.6090405@gmail.com>
 <20130326202837.GA5599@redhat.com>
 <20130328185327.GF14088@htj.dyndns.org>
 <20130328193343.GA15969@redhat.com>
 <20130328194443.GG14088@htj.dyndns.org>
 <20130328203808.GC15969@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130328203808.GC15969@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 28, 2013 at 04:38:08PM -0400, Vivek Goyal wrote:
> If timing of unordered IO is an issue, then dm-crypt can try
> to batch IO submission using blk_start_plug()/blk_finish_plug(). That way
> dm-crypt can batch bio and control submission and there should not
> be a need to put specific ordering logic in dm-crypt. 

Yes, it has to preserve and propagate the plugging boundaries and if
you think about the implementation, maintaining issue order don't
really need to be "sorted" per-se.  Just keep the list of bios
received but still going through encryption in the received order with
a counter of in-progress bios in the plugging boundary.  Link the
outputs to the source bios somehow and when the counter hits zero,
issue them in the same order.  While keeping the specific order itself
might not be essential, it's not gonna add any significant complexity
or runtime overhead and I think it generally is a good idea for
stacking drivers to preserve as much information and context as
possible in general.

Thanks.

-- 
tejun
