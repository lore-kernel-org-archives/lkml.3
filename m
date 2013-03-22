Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3CVTzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 15:55:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:23637 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071Ab3CVTzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 15:55:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,893,1355126400"; 
   d="scan'208";a="283365234"
Date: Fri, 22 Mar 2013 12:55:51 -0700
From: Andi Kleen <ak@linux.intel.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: racy jump label users
Message-ID: <20130322195551.GQ19692@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

I noticed that a lot of the jump label users are racy,
because they implement something like this

static void sched_feat_disable(int i)
{
        if (static_key_enabled(&sched_feat_keys[i]))
                static_key_slow_dec(&sched_feat_keys[i]);
}

static void sched_feat_enable(int i)
{
        if (!static_key_enabled(&sched_feat_keys[i]))
                static_key_slow_inc(&sched_feat_keys[i]);
}

with no extra locking, controlled by sysfs. If two
CPUs do this in parallel the reference can be set multiple
times, which gives very unexpected semantics for a sysfs boolean.

Most likely you need a static_key_slow_setstate()
that does the check and set inside the jump label lock.

I understand that for inside kernel use reference
counts are the right semantics, but they are not so
good for sysfs interfaces.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
