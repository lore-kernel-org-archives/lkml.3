Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbaFUB5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 21:57:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbaFUB5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 21:57:16 -0400
Date: Sat, 21 Jun 2014 03:57:14 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: cocci@systeme.lip6.fr
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: SmPL for automatic request_firmware_nowait() conversion
Message-ID: <20140621015714.GX4841@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was just porting over an ethernet driver [0] to use request_firmware_nowait()
since firmware loading seems can take over a minute on one device, while
at it I noticed no other ethernet drivers yet use this API so figure
this may be a trend coming if devices are getting as complex as cxgb4.
The cxgb4 driver happens to even use the firmware API 3 times!

Obviously I considered writing SmPL for this, but one thing which seemed
hard was that for after the request_firmware_nowait() we tend to tuck
away into another new call the rest of the code that was in place in the
original function after the old request_firmware() call. Is there a way
to dump all that code into the new routine? I think the hardest thing
would be to also move the right set of variables over. In the third
patch in this series for example [1] there was a state variable that
I moved from beign static over to the ethernet private data structure.
Its hard for me to think of how I can hint to Coccinelle enough information
about what stuff it needs to move around. I think one hint would be:

  "Hey all that code that is static and is used *before* and *after* request_firmware()
   stuff it into the private data structure"

We'd have to infer the private data structure but that's easy and I already know
that's possible. Is this possible? The only other challenge I thought
might be tough would be to come up with are rasonable call for the
completion call, but I guess we can use the original routine name
where request_firmware() was being used and postfix _completion or something.

netdev: how worthy is this effort?

[0] https://lkml.org/lkml/2014/6/20/688
[1] https://lkml.org/lkml/2014/6/20/691
 
  Luis
