Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaK0Qgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:36:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:29421 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaK0Qge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:36:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,470,1413270000"; 
   d="scan'208";a="644627298"
Message-ID: <1417106151.5858.122.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/6] UBI: Fastmap: Ensure that only one fastmap work is
 scheduled
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 27 Nov 2014 18:35:51 +0200
In-Reply-To: <54774DB7.5090200@nod.at>
References: <1416835236-25185-1-git-send-email-richard@nod.at>
		 <1416835236-25185-3-git-send-email-richard@nod.at>
	 <1417102042.5858.102.camel@sauron.fi.intel.com> <54774DB7.5090200@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 17:13 +0100, Richard Weinberger wrote:
> Am 27.11.2014 um 16:27 schrieb Artem Bityutskiy:
> > On Mon, 2014-11-24 at 14:20 +0100, Richard Weinberger wrote:
> >> If the WL pool runs out of PEBs we schedule a fastmap write
> >> to refill it as soon as possible.
> >> Ensure that only one at a time is scheduled otherwise we might end in
> >> a fastmap write storm because writing the fastmap can schedule another
> >> write if bitflips are detected.
> > 
> > Could you please provide some more details about the "write storm". Does
> > it happen when there are 2 fastmap works in the queue? Or if they run
> > simultaneously? Why the storm happens and white kind of "writes" it
> > consists of?
> 
> If UBI needs to write a new fastmap while wear leveling (by using get_peb_for_wl())
> a fastmap work is scheduled.
> We cannot write a fastmap in this context because we're in atomic context.
> At this point one fastmap write is scheduled. If now get_peb_for_wl() is executed
> a second time it will schedule another fastmap work because the pools are still not refilled.

Sounds like just you do not need any works and any queues at all. All
you need is a "please, fastmap me!" flag.

Then this flag should be checked every time we enter the background
thread or the fastmap code, and be acted upon.

So the background thread would first check this flag, and if it is set -
call the fastmap stuff. The go do the WL works.

Just off-the top of my head, take with grain of salt.

