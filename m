Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786Ab3CZOmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:42:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35480
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933490Ab3CZOmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:42:18 -0400
Message-ID: <1364308932.5053.46.camel@laptop>
Subject: Re: [RFC PATCH v3 5/6] sched: pack the idle load balance
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        morten.rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net
Date: Tue, 26 Mar 2013 15:42:12 +0100
In-Reply-To: <CAKfTPtD=_oS5gJeynUG=ft-Y1zEdxZEMhUPH9hSXx+H2pi4xgA@mail.gmail.com>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	 <1363955155-18382-6-git-send-email-vincent.guittot@linaro.org>
	 <1364302359.5053.21.camel@laptop>
	 <CAKfTPtD=_oS5gJeynUG=ft-Y1zEdxZEMhUPH9hSXx+H2pi4xgA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 15:03 +0100, Vincent Guittot wrote:
> > But ha! here's your NO_HZ link.. but does the above DTRT and ensure
> > that the ILB is a little core when possible?
> 
> The loop looks for an idle CPU as close as possible to the buddy CPU
> and the buddy CPU is the 1st CPU has been chosen. So if your buddy is
> a little and there is an idle little, the ILB will be this idle
> little.

Earlier you wrote:

>       | Cluster 0   | Cluster 1   |
>       | CPU0 | CPU1 | CPU2 | CPU3 |
> -----------------------------------
> buddy | CPU0 | CPU0 | CPU0 | CPU2 |

So extrapolating that to a 4+4 big-little you'd get something like:

      |   little  A9  ||   big A15     |
      | 0 | 1 | 2 | 3 || 4 | 5 | 6 | 7 |
------+---+---+---+---++---+---+---+---+
buddy | 0 | 0 | 0 | 0 || 0 | 4 | 4 | 4 |

Right?

So supposing the current ILB is 6, we'll only check 4, not 0-3, even
though there might be a perfectly idle cpu in there.

Also, your scheme fails to pack when cpus 0,4 are filled, even when
there's idle cores around.

If we'd use the ILB as packing cpu, we would simply select a next pack
target once the old one fills up.

