Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaEMPYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:24:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:35652 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaEMPYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:24:08 -0400
Date: Tue, 13 May 2014 17:24:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: vmstat: On demand vmstat workers V5
In-Reply-To: <alpine.DEB.2.10.1405121317270.29911@gentwo.org>
Message-ID: <alpine.DEB.2.02.1405131651120.6261@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1405121317270.29911@gentwo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014, Christoph Lameter wrote:

> 
> V4->V5:
> - Shepherd thread on a specific cpu (HOUSEKEEPING_CPU).

That's going to fail for the NOHZ_IDLE case, e.g. for the little/big
cluster support on ARM. They need to be able to move it from the
housekeeper on the big to the housekeeper on the little cluster.

So as I said before: This wants to be on a dedicated housekeeper
workqueue. Where the thread is placed is decided by the core depending
on system configuration and state.

 	  nohz = off	    CPU0
	  nohz = idle	    core decision depending on state
	  nohz = full	    CPU0

Your solution solves only the off and full case and will fail when in
the idle case CPU0 should be sent into deep idle sleep until the user
decides to do some work which requires CPU0 to come back.

Thanks,

	tglx
