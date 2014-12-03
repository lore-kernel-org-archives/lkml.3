Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077AbaLCEz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 23:55:59 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:33113 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaLCEz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 23:55:58 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 2 Dec 2014 23:56:03 -0500 (EST)
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: perf: attr backwards compatability issues
Message-ID: <alpine.DEB.2.11.1412022338020.21284@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So PAPI reshuffled the way it used libpfm4 and ended up inadvertently 
setting exclude_guest=1.

This managed to break anyone using the new version of the library (with
a modern verison of the perf_event.h header) on kernels older than 3.2, 
with a helpful EINVAL return.

After a lot of false leads this was tracked to the

        if (attr->__reserved_1)
                return -EINVAL;

line in kernel/events.c (any hope of the better error reporting 
happening?)

Anyway, this is completely useless backwards compatability wise.

Shouldn't that return be E2BIG to be consistent with the way that 
extensions to the ABI are handled elsewhere in the interface
(i.e. report E2BIG if a formerly unused bit is set to 1)?

Though I guess it's too late to change this behavior now.

I looked to see how perf handles this issue, but I guess conveniently
any new bitfield values are designed in such a way that the perf default
behavior matches up with a zero for the new setting.

Vince
