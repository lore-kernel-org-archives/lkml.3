Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab3DWSP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:15:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735Ab3DWSPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:15:25 -0400
Date: Tue, 23 Apr 2013 14:14:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Pan, Zhenjie" <zhenjie.pan@intel.com>,
        Stephane Eranian <eranian@google.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] NMI: fix NMI period is not correct when cpu frequency
 changes issue.
Message-ID: <20130423181423.GC79013@redhat.com>
References: <F98D4B5C3D86834DB612ABF854C98B7FB5D7FE@SHSMSX101.ccr.corp.intel.com>
 <1366285369.19383.19.camel@laptop>
 <CABPqkBTpzSBEezx4ScwYYX6L8ir4GLBG9MMYJuAb6YA0QbiurQ@mail.gmail.com>
 <20130418133927.GJ79013@redhat.com>
 <F98D4B5C3D86834DB612ABF854C98B7FB5FACF@SHSMSX101.ccr.corp.intel.com>
 <1366663056.8337.7.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366663056.8337.7.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 10:37:36PM +0200, Peter Zijlstra wrote:
> On Mon, 2013-04-22 at 00:50 +0000, Pan, Zhenjie wrote:
> > This make watchdog reset happen before hard lockup detect.
> 
> Doesn't your watchdog trigger an NMI you can use to print the panic?
> 
> ISTR some people (hi Don!) spending quite a lot of time to make this
> work for some other platforms.
> 
> IIRC those things would fire an NMI at some point and then hard-reset
> the machine not much later.. the difficulty was detecting this
> 'unclaimed' nmi and allowing drivers to register for it.
> 
> NMI_UNKNOWN and unknown_nmi_panic are the result of that.

I think you are confusing the hard lockup detector watchdog (which uses
the perf counters) with a physical hardware watchdog (which just resets
the cpu if not kicked frequently; ie
drivers/watchdog/intel_scu_watchdog.c).

I believe what Zhenjie's problem is the hard lockup detector (ie
nmi_watchdog) becomes useless because sometimes it can correctly fire
before the hardware watchdog expires, other times it may not.

In order for the hard lockup detector to be useful, it should be reliable.
Today it isn't because it period inversely varies with cpu frequency.

I don't have a real issue with his patch.  I was just concerned about the
frequency of the changes (10-15 times a second seems like a lot).

Cheers,
Don
