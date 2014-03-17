Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaCQUeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:34:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:40021 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaCQUd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:33:59 -0400
Message-ID: <1395088410.15098.175.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the driver-core tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Mar 2014 07:33:30 +1100
In-Reply-To: <20140317183333.GE10565@kroah.com>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
	 <20140312015021.GC10106@kroah.com>
	 <20140317101611.d043a90e1cb72dcfb8bc767a@canb.auug.org.au>
	 <20140317183333.GE10565@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-17 at 11:33 -0700, Greg KH wrote:

> There were only 3 (or 4), users of this api, and no new ones had been
> added in _years_, it's a very obscure thing, and odds are, it wouldn't
> ever be added again, especially as it was just removed entirely not
> being needed anymore.  And I'd argue, it's something that you shouldn't
> have even been doing in the first place, so why a new user of it was
> added now is quite strange to me.

Actually that's a good question. Is there a better way for us than to
use this API ? Essentially we use that because it's our understanding
that it is what is needed for a sysfs file that can remove its parent
directory from within a write() op.

We followed the driver "remove" implementation as an example.

The reason the opal elog and dump patches use it is that those two
patches add sysfs interface that represent the error logs (and platform
dumps but you can treat the latter as some kind of special case of error
logs) from the service processor in sysfs.

So for each log we create a dir (kobject) which we populate with a few
things like the log unique ID, raw data, etc.... and a file that can be
used to "ack" the log with the service processor.

The latter has the effect of removing it. This is done by the collection
daemon after it has confirmed that the error log has been stored to disk
and properly flushed.

Is there a better interface ? Can we implement for example unlink() on
the kobject itself ? IE. Do the ack by essentially having userspace rm
the directory ? :-)

Now regarding the practicals of sorting out our trees, Stephen suggested
that rather than doing anything on my side (heh, I like that !), you
should revert the last patch of the series, the one removing the old
API, in your tree.

It can then be re-applied later around rc1.

Cheers,
Ben.

