Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964775AbaGITd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:33:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:22830 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbaGITdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:33:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,632,1400050800"; 
   d="scan'208";a="570761711"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Thread-Topic: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Thread-Index: AQHPmw42PYiPusxucki+Ie3j6NurFZuXRIqAgACHbiD//4Q0gIAAh8MA//+VMACAAIvOEA==
Date: Wed, 9 Jul 2014 19:32:09 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077014D361B@SHSMSX103.ccr.corp.intel.com>
References: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
 <20140709141631.GE9918@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077014D2005@SHSMSX103.ccr.corp.intel.com>
 <20140709145809.GG9918@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077014D2729@SHSMSX103.ccr.corp.intel.com>
 <20140709164146.GH9918@twins.programming.kicks-ass.net>
In-Reply-To: <20140709164146.GH9918@twins.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > >
> > > On Wed, Jul 09, 2014 at 02:32:28PM +0000, Liang, Kan wrote:
> > > >
> > > >
> > > > > On Tue, Jul 08, 2014 at 09:49:40AM -0700, kan.liang@intel.com wrote:
> > > > > > +/*
> > > > > > + * Under certain circumstances, access certain MSR may cause #GP.
> > > > > > + * The function tests if the input MSR can be safely accessed.
> > > > > > + */
> > > > > > +static inline bool check_msr(unsigned long msr) {
> > > > > > +	u64 value;
> > > > > > +
> > > > > > +	if (rdmsrl_safe(msr, &value) < 0)
> > > > > > +		return false;
> > > > > > +	if (wrmsrl_safe(msr, value) < 0)
> > > > > > +		return false;
> > > > > > +	return true;
> > > > > > +}
> > > > >
> > > > > What does this thing return after patch 2? does the write still
> > > > > fault or will KVM silently take writes too?
> > > >
> > > > If applying patch 2, the function will return true. The KVM just
> > > > simply ignore
> > > the reads/writes.
> > >
> > > OK, then that's broken too. We want a function to return false for
> > > any malfunctioning MSR, ignoring writes and returning 0s is not
> > > proper functioning.
> >
> > The patch 2 is to handle the case that the administrator can only
> > patch the host. Don't need to force user to upgrade their guest to fix
> > the crash.  And ignore the annoying "unhandled...." KVM messages
> 
> Sure; but what I meant was, check_msr() is broken when ran on such a
> kernel. You need to fix check_msr() to return failure on these 'ignored'
> MSRs, after all they don't function as expected, they're effectively broken.

The function is designed to check if the MSRs can be safely accessed (no #GP). It cannot guarantee the correctness of the MSRs.
If KVM applied patch 2 and guest applied patch 1, from the guest's perspective, the MSRs can be accessed (no #GP triggered). So return true is expected. It should not be a broken.
The only unexpected thing for guest is that the counting/sampling result for LBR/extra reg is always 0. But the patch is a short term fix to stop things from crashing. I think it should be acceptable.


