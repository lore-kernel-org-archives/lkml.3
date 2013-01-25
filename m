Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3AYAQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:16:54 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:42173 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3AYAQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:16:46 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201301250015.r0P0FR3t003475@como.maths.usyd.edu.au>
Date: Fri, 25 Jan 2013 11:15:27 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201301250015.r0P0FR3t003475@como.maths.usyd.edu.au>
To: fengguang.wu@intel.com, jack@suse.cz
Subject: Re: [PATCH] Negative (setpoint-dirty) in bdi_position_ratio()
Cc: 695182@bugs.debian.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20130124151603.GD21818@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jan,

> I think he found the culprit of the problem being min_free_kbytes was not
> properly reflected in the dirty throttling. ... Paul please correct me
> if I'm wrong.

Sorry but have to correct you.

I noticed and patched/corrected two problems, one with (setpoint-dirty)
in bdi_position_ratio(), another with min_free_kbytes not subtracted
from dirtyable memory. Fixing those problems, singly or in combination,
did not help in avoiding OOM: running
  n=0; while [ $n -lt 99 ]; do dd bs=1M count=1024 if=/dev/zero of=x$n; ((n=$n+1)); done
still produces an OOM after a few files written (on a PAE machine with
over 32GB RAM).

Also, a quite similar OOM may be produced on any PAE machine with
  n=0; while [ $n -lt 33000 ]; do sleep 600 & ((n=n+1)); done
This was tested on machines with as low as just 3GB RAM ... and
curiously the same machine with "plain" (not PAE but HIGHMEM4G)
kernel handles the same "sleep test" without any problems.

(Thus I now think that the remaining bug is not with writeback.)

Cheers, Paul

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia
