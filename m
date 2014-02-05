Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaBEJZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:25:19 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:38016 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaBEJZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:25:16 -0500
Date: Wed, 5 Feb 2014 04:25:12 -0500
From: Tejun Heo <tj@kernel.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Shaibal Dutta <shaibal.dutta@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH] net: wireless: move regulatory timeout work to power
 efficient workqueue
Message-ID: <20140205092512.GB32349@htj.dyndns.org>
References: <1391123310-6425-1-git-send-email-zoran.markovic@linaro.org>
 <1391160084.4141.1.camel@jlt4.sipsolutions.net>
 <20140131093531.GA25559@mtj.dyndns.org>
 <20140205091742.GA1978@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205091742.GA1978@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 05, 2014 at 10:17:42AM +0100, Stanislaw Gruszka wrote:
> What are selection criteria when choosing between system_wq or
> system_power_efficient_wq on drivers ? IOW if I would be writing
> a new driver which workqueue should I use and when ?

Yeah, it's a bit ad-hoc at the moment.  The original intention was
just marking the ones which can be shown to have noticeable power
impacts which weren't expected to be too many but we may now have an
self-feeding feedback loop growing new usages, likely somewhat
overzealously and be better off making things more generic.

> I think that should be driver independent, at least for most of drivers.
> If system have to run in low power mode, system_power_efficient_wq
> should be chosen automatically by schedule_work(), otherwise when high
> performance is more important schedule_work() should use system_wq.

The problem there is that system_wq has traditionally guaranteed
per-cpu execution.  It can't automatically be switched to unbound
behavior.  The best long term solution would be isolating the users
which depend on per-cpu behavior and mark them specially rather than
the other way around that we're doing now, making per-cpu guarantee
the special case rather than the norm.  That's gonna take a lot of
auditing tho.

Thanks.

-- 
tejun
