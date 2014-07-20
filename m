Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbaGTFq2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 01:46:28 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:60557 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaGTFq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 01:46:27 -0400
Message-ID: <1405835183.6512.37.camel@marge.simpson.net>
Subject: Re: [PATCH 0/2 v4] sched: Rewrite per entity runnable load average
 tracking
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        pjt@google.com, bsegall@google.com, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, fengguang.wu@intel.com
Date: Sun, 20 Jul 2014 07:46:23 +0200
In-Reply-To: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 07:26 +0800, Yuyang Du wrote: 
> Thanks to Morten, Ben, and Fengguang.
> 
> v4 changes:
> 
> - Insert memory barrier before writing cfs_rq->load_last_update_copy.
> - Fix typos.

My little desktop box says lovely minus signs have had their usual
effect on the general case (cgroups enabled but not in use). 

pipe-test scheduling cross core - full fastpath
3.0.101-default        3.753363 usecs/loop -- avg 3.770737 530.4 KHz   1.000
3.1.10-default         3.723843 usecs/loop -- avg 3.716058 538.2 KHz   1.014
3.2.51-default         3.728060 usecs/loop -- avg 3.710372 539.0 KHz   1.016
3.3.8-default          3.906174 usecs/loop -- avg 3.900399 512.8 KHz    .966
3.4.97-default         3.864158 usecs/loop -- avg 3.865281 517.4 KHz    .975
3.5.7-default          3.967481 usecs/loop -- avg 3.962757 504.7 KHz    .951
3.6.11-default         3.851186 usecs/loop -- avg 3.845321 520.1 KHz    .980
3.7.10-default         3.777869 usecs/loop -- avg 3.776913 529.5 KHz    .998
3.8.13-default         4.049927 usecs/loop -- avg 4.041905 494.8 KHz    .932
3.9.11-default         3.973046 usecs/loop -- avg 3.974208 503.2 KHz    .948
3.10.27-default        4.189598 usecs/loop -- avg 4.189298 477.4 KHz    .900
3.11.10-default        4.293870 usecs/loop -- avg 4.297979 465.3 KHz    .877
3.12.24-default        4.321570 usecs/loop -- avg 4.321961 462.8 KHz    .872
3.13.11-default        4.137845 usecs/loop -- avg 4.134863 483.7 KHz    .911
3.14.10-default        4.145348 usecs/loop -- avg 4.139987 483.1 KHz    .910            
3.15.4-default         4.355594 usecs/loop -- avg 4.351961 459.6 KHz    .866             
3.16.0-default         4.537279 usecs/loop -- avg 4.543532 440.2 KHz    .829     1.000   
3.16.0-default+v4      4.343542 usecs/loop -- avg 4.318803 463.1 KHz    .873     1.052

Extending max depth to 5, cost of depth++ seemingly did not change
despite repeatable dip at depth = 3 (gremlins at play).

mount -t cgroup o cpu none /cgroups
mkdir -p /cgroups/a/b/c/d/e

cgexec -g cpu:a pipe-test 1
3.16.0-default         5.016373 usecs/loop -- avg 5.021115 398.3 KHz   1.000
3.16.0-default+v4      4.978625 usecs/loop -- avg 4.977381 401.8 KHz   1.008

cgexec -g cpu:a/b pipe-test 1
3.16.0-default         5.543566 usecs/loop -- avg 5.565475 359.4 KHz   1.000
3.16.0-default+v4      5.597399 usecs/loop -- avg 5.570444 359.0 KHz    .998

cgexec -g cpu:a/b/c pipe-test 1
3.16.0-default         6.092256 usecs/loop -- avg 6.094186 328.2 KHz   1.000
3.16.0-default+v4      6.294858 usecs/loop -- avg 6.338453 315.5 KHz    .961

cgexec -g cpu:a/b/c/d pipe-test 1
3.16.0-default         6.719044 usecs/loop -- avg 6.717118 297.7 KHz   1.000
3.16.0-default+v4      6.788559 usecs/loop -- avg 6.710102 298.1 KHz   1.001

cgexec -g cpu:a/b/c/d/e pipe-test 1
3.16.0-default         7.186431 usecs/loop -- avg 7.194884 278.0 KHz   1.000
3.16.0-default+v4      7.368443 usecs/loop -- avg 7.250371 275.8 KHz    .992


