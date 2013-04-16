Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935798Ab3DPTlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 15:41:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935589Ab3DPTlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 15:41:51 -0400
Date: Tue, 16 Apr 2013 15:41:23 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Tejun Heo <tj@kernel.org>
cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
In-Reply-To: <20130416172418.GB2874@mtj.dyndns.org>
Message-ID: <Pine.LNX.4.64.1304161506580.24453@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
 <20130410192427.GA14911@redhat.com> <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
 <20130410235009.GI17641@mtj.dyndns.org> <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
 <20130411195203.GA11956@mtj.dyndns.org> <20130411200005.GB11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304121340350.3359@file.rdu.redhat.com>
 <20130412182941.GF11956@mtj.dyndns.org> <Pine.LNX.4.64.1304150827480.1859@file.rdu.redhat.com>
 <20130416172418.GB2874@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Apr 2013, Tejun Heo wrote:

> Hey,
> 
> On Mon, Apr 15, 2013 at 09:02:06AM -0400, Mikulas Patocka wrote:
> > The patch is not bug-prone, because we already must make sure that the 
> > cloned bio has shorter lifetime than the master bio - so the patch doesn't 
> > introduce any new possibilities to make bugs.
> 
> The whole world isn't composed of only your code.  As I said
> repeatedly, you're introducing an API which is misleading and can
> easily cause subtle bugs which are very difficult to reproduce.
> 
> Imagine it being used to tag a metatdata or checksum update bio being
> sent down while processing another bio and used to "clone" the context
> of the original bio.  It'll work most of the time even if the original
> bio gets completed first but it'll break when it gets really unlucky -
> e.g. racing with other operations which can put the base css ref, and
> it'll be hellish to reproduce and everyone would have to pay for your
> silly hack.

That's why the comment at the function says: "it is assumed that the 
lifestime of the new bio is shorter than the lifetime of the original bio. 
If the new bio can outlive the old bio, the caller must increment the 
reference counts." - do you think that it is so bad that someone will use 
the function without reading the comment?

Anyway, the situation that you describe could only happen in dm-bufio or 
dm-kcopyd files, so it's easy to control and increment the reference 
counts there. There are no other places in device mapper where we create 
bios that live longer than original one.

Mikulas
