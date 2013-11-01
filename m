Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3KARTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 13:19:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab3KARTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 13:19:46 -0400
Subject: rcu: Throttle rcu_try_advance_all_cbs() execution causes visible
 slowdown in ftrace switching
From: Petr Mladek <pmladek@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Tibor Billes <tbilles@gmx.com>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-PdYSd8K5wQia66Pmk0Yr"
Date: Fri, 01 Nov 2013 18:19:44 +0100
Message-ID: <1383326384.6788.49.camel@pathway.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PdYSd8K5wQia66Pmk0Yr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi,

I am doing some clean up in x86 ftrace code. I check the performance by
switching between different tracers and by enabling and disabling them.

The operation has started to be much slower after rebasing on the
kernel tip tree. Bisecting has shown that the difference was caused by
the commit c229828ca6bc62d6c654 (rcu: Throttle
rcu_try_advance_all_cbs() execution)

The following times are from Intel 2xCore i7-3770 CPU @ 3.40GHz when
calling the attached test script (time ./test-ftrace). It 100x switches
between "function" and "nop" tracer. It also enables and disables the
tracer each time.

Results with the commit c229828ca6bc62d6c654:

real    0m49.393s     0m49.632s     0m49.359s
user    0m0.004s      0m0.000s      0m0.004s
sys     0m0.996s      0m0.880s      0m0.892s


Results after reverting the commit c229828ca6bc62d6c654:

real    0m35.320s     0m35.687s     0m35.920s
user    0m0.004s      0m0.004s      0m0.000s
sys     0m1.140s      0m1.208s      0m1.152s


I might do some more debugging on Monday. I wonder if you have any
hints or ideas.

Best Regards,
Petr

--=-PdYSd8K5wQia66Pmk0Yr
Content-Type: application/x-shellscript; name="test-ftrace"
Content-Disposition: attachment; filename="test-ftrace"
Content-Transfer-Encoding: 7bit

#!/bin/bash

echo "Testing ftrace - begin"

cd /sys/kernel/debug/tracing

count=0
while test $count -lt 100 ; do
    for tracer in function nop ; do
        echo $tracer >current_tracer
        echo 1 >tracing_on
        echo 0 >tracing_on
    done
    count=$(($count + 1))
done

cd -

echo "Testing ftrace - end"




--=-PdYSd8K5wQia66Pmk0Yr--

