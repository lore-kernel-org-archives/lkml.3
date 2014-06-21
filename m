Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbaFUGhG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 02:37:06 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:11962 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbaFUGhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 02:37:04 -0400
X-IronPort-AV: E=Sophos;i="5.01,519,1400018400"; 
   d="scan'208";a="81264727"
Date: Sat, 21 Jun 2014 08:37:01 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: "Luis R. Rodriguez" <mcgrof@suse.com>
cc: cocci@systeme.lip6.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Cocci] SmPL for automatic request_firmware_nowait()
 conversion
In-Reply-To: <20140621015714.GX4841@wotan.suse.de>
Message-ID: <alpine.DEB.2.02.1406210832510.2074@localhost6.localdomain6>
References: <20140621015714.GX4841@wotan.suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jun 2014, Luis R. Rodriguez wrote:

> I was just porting over an ethernet driver [0] to use request_firmware_nowait()
> since firmware loading seems can take over a minute on one device, while
> at it I noticed no other ethernet drivers yet use this API so figure
> this may be a trend coming if devices are getting as complex as cxgb4.
> The cxgb4 driver happens to even use the firmware API 3 times!
> 
> Obviously I considered writing SmPL for this, but one thing which seemed
> hard was that for after the request_firmware_nowait() we tend to tuck
> away into another new call the rest of the code that was in place in the
> original function after the old request_firmware() call. Is there a way
> to dump all that code into the new routine? I think the hardest thing
> would be to also move the right set of variables over. In the third
> patch in this series for example [1] there was a state variable that
> I moved from beign static over to the ethernet private data structure.
> Its hard for me to think of how I can hint to Coccinelle enough information
> about what stuff it needs to move around. I think one hint would be:
> 
>   "Hey all that code that is static and is used *before* and *after* request_firmware()
>    stuff it into the private data structure"
> 
> We'd have to infer the private data structure but that's easy and I already know
> that's possible. Is this possible? The only other challenge I thought
> might be tough would be to come up with are rasonable call for the
> completion call, but I guess we can use the original routine name
> where request_firmware() was being used and postfix _completion or something.

This kind of thing is possible, but complicated.  Basically you have to 
put { } around what you want to move, then match a statement metavariable 
against the code that is now surrounded by braces, then find all of the 
variables that are read without being initialized in the { } region, or 
that are written by the { } region and used afterwards and arrange to copy 
them back and forth.  I did this in the context of a project where the 
goal was to move critical sections into separate functions, but it was 
around 1000 lines of SmPL code.

If one were doing this in several places onesself, then it would probably 
be better to do the fixed parts using SmPL and do the more variable parts 
by hand.  This is not really something that one would want to publoish for 
others, though.

julia
