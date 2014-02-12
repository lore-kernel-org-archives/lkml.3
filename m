Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaBLQXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:23:19 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:33527 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaBLQXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:23:17 -0500
Date: Wed, 12 Feb 2014 11:23:11 -0500
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-edac@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac, poll timeout cannot be zero
Message-ID: <20140212162311.GB26809@htj.dyndns.org>
References: <1391457913-881-1-git-send-email-prarit@redhat.com>
 <20140212150748.GE5121@pd.tnic>
 <20140212151657.GL24490@htj.dyndns.org>
 <20140212155752.GF5121@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212155752.GF5121@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 12, 2014 at 04:57:53PM +0100, Borislav Petkov wrote:
> Ha, so this sounds like the issue because the splat happens
> when updating /sys/.../edac_mc_poll_msec and it goes and calls
> edac_mc_workq_setup()...
> 
> And this code is pretty old and edac_mc_workq_setup() is used both
> when one inits an edac driver and also when one wants to change the
> polling period (edac_mc_reset_delay_period) and thus needs to mod the
> workqueue's timeout.
> 
> So I'm guessing a simple fix would be to differentiate between the two
> paths, something like the diff below.
> 
> Or is there a reliable way to check whether a workqueue has been
> initialized already, say, something like
> 
> 	if (work->func)

Hah... can't you just do it on object initialization?  It's a bit
nasty and fragile to game initialization state.

> or so... I.e., what PREPARE_WORK() does?

It allows you to change the callback without breaking the
synchronization.  Of course, if there's a pending work item, it may or
may not execute the newly assigned function.  It's also a bit nasty
and has only few users in the whole kernel and I think we might wanna
get rid of them.

Thanks.

-- 
tejun
