Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822Ab3GWSAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:00:18 -0400
Received: from smtp.citrix.com ([66.165.176.89]:49519 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933598Ab3GWSAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:00:14 -0400
X-IronPort-AV: E=Sophos;i="4.89,729,1367971200"; 
   d="scan'208";a="38784470"
Message-ID: <1374602409.6623.138.camel@hastur.hellion.org.uk>
Subject: Re: [PATCH v3 1/2] xen/balloon: set a mapping for ballooned out
 pages
From: Ian Campbell <ian.campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <alex@alex.org.uk>, <dcrisan@flexiant.com>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 23 Jul 2013 19:00:09 +0100
In-Reply-To: <1374600466-3229-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1307231820570.4893@kaball.uk.xensource.com>
	 <1374600466-3229-1-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 18:27 +0100, Stefano Stabellini wrote:
> +static int __cpuinit balloon_cpu_notify(struct notifier_block *self,
> +				    unsigned long action, void *hcpu)
> +{
> +	int cpu = (long)hcpu;
> +	switch (action) {
> +	case CPU_UP_PREPARE:
> +		if (per_cpu(balloon_scratch_page, cpu) != NULL)
> +			break;

Thinking about this a bit more -- do we know what happens to the per-cpu
area for a CPU which is unplugged and then reintroduced? Is it preserved
or is it reset?

If it is reset then this gets more complicated :-( We might be able to
use the core mm page reference count, so that when the last reference is
removed the page is automatically reclaimed. We can obviously take a
reference whenever we add a mapping of the trade page, but I'm not sure
we are always on the path which removes such mappings... Even then you
could waste pages for some potentially large amount of time each time
you replug a VCPU.

Urg, I really hope the per-cpu area is preserved!

Ian.

