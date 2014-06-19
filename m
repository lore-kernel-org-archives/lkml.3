Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaFSEwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 00:52:30 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63016 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaFSEw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 00:52:29 -0400
Message-ID: <1403153545.1225.8.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Christoph Lameter <cl@linux.com>
Date: Wed, 18 Jun 2014 21:52:25 -0700
In-Reply-To: <20140619033816.GQ8178@tassilo.jf.intel.com>
References: <20140613224519.GV4581@linux.vnet.ibm.com>
	 <53A0CAE5.9000702@intel.com> <20140618001836.GV4669@linux.vnet.ibm.com>
	 <53A132D4.60408@intel.com> <20140618125831.GB4669@linux.vnet.ibm.com>
	 <53A1CE19.7040103@intel.com> <20140618203052.GT4669@linux.vnet.ibm.com>
	 <20140618235131.GA25946@linux.vnet.ibm.com>
	 <20140619014200.GO8178@tassilo.jf.intel.com>
	 <20140619021337.GA4669@linux.vnet.ibm.com>
	 <20140619033816.GQ8178@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 20:38 -0700, Andi Kleen wrote:
> On Wed, Jun 18, 2014 at 07:13:37PM -0700, Paul E. McKenney wrote:
> > On Wed, Jun 18, 2014 at 06:42:00PM -0700, Andi Kleen wrote:
> > > 
> > > I still think it's totally the wrong direction to pollute so 
> > > many fast paths with this obscure debugging check workaround
> > > unconditionally.
> > 
> > OOM prevention should count for something, I would hope.
> 
> OOM in what scenario? This is getting bizarre.
> 
> If something keeps looping forever in the kernel creating 
> RCU callbacks without any real quiescent states it's simply broken.

Typical problem we faced in the past is in exit() path when multi
thousands of files/sockets are rcu-freed, and qhimark is hit.

Huge latency alerts, as freeing 10000+ items takes a while (about 70 ns
per item...)

Maybe close_files() should use a
cond_resched_and_keep_rcu_queues_small_please() ;)



