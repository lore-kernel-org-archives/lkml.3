Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760840Ab3BITAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 14:00:45 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:37152 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526Ab3BITAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 14:00:43 -0500
Date: Sat, 9 Feb 2013 11:00:37 -0800
From: Tejun Heo <tj@kernel.org>
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "Marciniszyn, Mike" <mike.marciniszyn@intel.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/6] idr: remove MAX_IDR_MASK and move left MAX_IDR_*
 into idr.c
Message-ID: <20130209190037.GB2875@htj.dyndns.org>
References: <20130208210050.GA26660@mtj.dyndns.org>
 <20130208210149.GB26660@mtj.dyndns.org>
 <1828884A29C6694DAF28B7E6B8A8237357D44677@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237357D44677@ORSMSX101.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 08, 2013 at 10:09:13PM +0000, Hefty, Sean wrote:
> >   Used to wrap cyclic @start.  Can be replaced with max(next, 0).
> >   Note that this type of cyclic allocation using idr is buggy.  These
> >   are prone to spurious -ENOSPC failure after the first wraparound.
> 
> The replacement code looks fine, but can you explain why the use is buggy?

So, if you want a cyclic allocation, the allocation should be tried in
[start, END) and then [0, start); otherwise, after the allocation
wraps for the first time, as the closer the starting point gets to
END, the chance of not finding a vacant slot in [start, END) goes
higher.  When @start equals END - 1 for the second time, if the first
END - 1 allocation is still around, you'll get -ENOSPC.

In practice, I don't think anyone is hitting this.  idr has always
been horribly broken when it reaches higher range (> 1<<30 on 64bit)
so things would have broken even before the first wraparound.  It
still is a theoretical possibility which may trigger if idr is used
for, say, ipc messages or storage commands.

Thanks.

-- 
tejun
