Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3F1QwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:52:03 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:22027 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab3F1QwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:52:01 -0400
Message-ID: <1372438309.1937.9.camel@bwh-desktop.uk.level5networks.com>
Subject: Using sched_clock() for polling time limit
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        HPA <hpa@zytor.com>, Cody P Schafer <devel-lists@codyps.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Fri, 28 Jun 2013 17:51:49 +0100
In-Reply-To: <20130628125926.14419.89905.stgit@ladj378.jer.intel.com>
References: <20130628125918.14419.36214.stgit@ladj378.jer.intel.com>
	 <20130628125926.14419.89905.stgit@ladj378.jer.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19980.005
X-TM-AS-Result: No--14.532100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 15:59 +0300, Eliezer Tamir wrote:
> Our use of sched_clock is OK because we don't mind the side effects
> of calling it and occasionally waking up on a different CPU.

Sure about that?  Jitter matters too.

> When CONFIG_DEBUG_PREEMPT is on, disable preempt before calling
> sched_clock() so we don't trigger a debug_smp_processor_id() warning.
[...]

I think this is papering over a problem.  The warning is there for a
good reason.

Would functions like these make it possible to use sched_clock() safely
for polling?  (I didn't spend much time thinking about the names.)

struct sched_timestamp {
	int cpu;
	unsigned long long clock;
};

static inline struct sched_timestamp sched_get_timestamp(void)
{
	struct sched_timestamp ret;

	preempt_disable_notrace();
	ret.cpu = smp_processor_id();
	ret.clock = sched_clock();
	preempt_enable_no_resched_notrace();

	return ret;
}

static inline bool sched_timeout_or_moved(struct sched_timestamp start,
					  unsigned long long timeout)
{
	bool ret;

	preempt_disable_notrace();
	ret = start.cpu != smp_processor_id() ||
		(sched_clock() - start.clock) > timeout;
	preempt_enable_no_resched_notrace();

	return ret;
}

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

