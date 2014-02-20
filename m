Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbaBTSXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:23:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42363 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbaBTSXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:23:08 -0500
Date: Thu, 20 Feb 2014 19:23:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: x86_pmu_start WARN_ON.
Message-ID: <20140220182300.GN9987@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
 <20140217152859.GF15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
 <20140219101949.GG15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
 <20140220100830.GN6835@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402201302150.24360@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402201302150.24360@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 01:03:16PM -0500, Vince Weaver wrote:
> attached, it's not very big.

This is I think the relevant bit:

   pec_1076_warn-2804  [000] d...   147.926153: x86_pmu_disable: x86_pmu_disable
   pec_1076_warn-2804  [000] d...   147.926153: x86_pmu_state: Events: {
   pec_1076_warn-2804  [000] d...   147.926156: x86_pmu_state:   0: state: .R config: ffffffffffffffff (          (null))
   pec_1076_warn-2804  [000] d...   147.926158: x86_pmu_state:   33: state: AR config: 0 (ffff88011ac99800)
   pec_1076_warn-2804  [000] d...   147.926159: x86_pmu_state: }
   pec_1076_warn-2804  [000] d...   147.926160: x86_pmu_state: n_events: 1, n_added: 0, n_txn: 1
   pec_1076_warn-2804  [000] d...   147.926161: x86_pmu_state: Assignment: {
   pec_1076_warn-2804  [000] d...   147.926162: x86_pmu_state:   0->33 tag: 1 config: 0 (ffff88011ac99800)
   pec_1076_warn-2804  [000] d...   147.926163: x86_pmu_state: }
   pec_1076_warn-2804  [000] d...   147.926166: collect_events: Adding event: 1 (ffff880119ec8800)
   pec_1076_warn-2804  [000] d...   147.926170: collect_events: Adding event: 0 (ffff8800c9e01800)
   pec_1076_warn-2804  [000] d...   147.926172: collect_events: Adding event: 4 (ffff8800cbab2c00)
   pec_1076_warn-2804  [000] d...   147.926177: x86_pmu_enable: x86_pmu_enable
   pec_1076_warn-2804  [000] d...   147.926177: x86_pmu_state: Events: {
   pec_1076_warn-2804  [000] d...   147.926179: x86_pmu_state:   0: state: .R config: ffffffffffffffff (          (null))
   pec_1076_warn-2804  [000] d...   147.926181: x86_pmu_state:   33: state: AR config: 0 (ffff88011ac99800)
   pec_1076_warn-2804  [000] d...   147.926182: x86_pmu_state: }
   pec_1076_warn-2804  [000] d...   147.926184: x86_pmu_state: n_events: 2, n_added: 2, n_txn: 2
   pec_1076_warn-2804  [000] d...   147.926184: x86_pmu_state: Assignment: {
   pec_1076_warn-2804  [000] d...   147.926186: x86_pmu_state:   0->33 tag: 1 config: 0 (ffff88011ac99800)
   pec_1076_warn-2804  [000] d...   147.926188: x86_pmu_state:   1->0 tag: 1 config: 1 (ffff880119ec8800)
   pec_1076_warn-2804  [000] d...   147.926188: x86_pmu_state: }
   pec_1076_warn-2804  [000] d...   147.926190: x86_pmu_enable: S0: hwc->idx: 33, hwc->last_cpu: 0, hwc->last_tag: 1 hwc->state: 0
   pec_1076_warn-2804  [000] d...   147.926191: x86_pmu_enable: starting: 0

so it does indeed look like n_added got scrambled; we started out with 1
event on disable; we've got 2 events on enable, but n_added is also 2,
which would suggest we had 0 on disable.

That makes us want to (re)start the NMI counter alright.

I've got to go run errands for a bit; hopefully I can find a bit of time
later tonight to look this over.
