Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab3GIQiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:38:03 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:57284 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3GIQiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:38:01 -0400
X-IronPort-AV: E=Sophos;i="4.87,1029,1363132800"; 
   d="scan'208";a="6506812"
Message-ID: <51DC3C66.2030606@citrix.com>
Date: Tue, 9 Jul 2013 18:37:58 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 4/4] xen-block: introduce a new request type to unmap
 grants
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com> <1373288607-1876-5-git-send-email-roger.pau@citrix.com> <20130708194152.GJ4927@phenom.dumpdata.com>
In-Reply-To: <20130708194152.GJ4927@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/13 21:41, Konrad Rzeszutek Wilk wrote:
> On Mon, Jul 08, 2013 at 03:03:27PM +0200, Roger Pau Monne wrote:
>> Right now blkfront has no way to unmap grant refs, if using persistent
>> grants once a grant is used blkfront cannot assure if blkback will
>> have this grant mapped or not. To solve this problem, a new request
>> type (BLKIF_OP_UNMAP) that allows requesting blkback to unmap certain
>> grants is introduced.
> 
> I don't think this is the right way of doing it. It is a new operation
> (BLKIF_OP_UNMAP) that has nothing to do with READ/WRITE. All it is
> is just some way for the frontend to say: unmap this grant if you can.
> 
> As such I would think a better mechanism would be to have a new
> grant mechanism that can say: 'I am done with this grant you can
> remove it' - that is called to the hypervisor. The hypervisor
> can then figure out whether it is free or not and lazily delete it.
> (And the guest would be notified when it is freed).

I would prefer not to involve the hypervisor in persistent grants, this
is something between the frontends and the backends. The hypervisor
already provides the basic operations (map/unmap), IMHO there's no need
to add more logic to the hypervisor itself.

I agree that it would be better to have a generic way to request a
backend to unmap certain grants, but so far this seems like the best
solution.

> 
> I would presume that this problem would also exist with netback/netfront
> if it started using persisten grants, right?

I'm not sure of that, it depends on the number of persistent grants
netfront/netback use, in the block case we need this operation because
of indirect descriptors, but netfront/netback might not suffer from this
problem if the maximum number of grants they use is relatively small.

