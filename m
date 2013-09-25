Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3IYJCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 05:02:11 -0400
Received: from mx0.eldamar.org.uk ([78.47.157.133]:45209 "EHLO
	mx0.eldamar.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3IYJCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 05:02:08 -0400
Date: Wed, 25 Sep 2013 10:01:50 +0100
From: Alexander Frolkin <avf@eldamar.org.uk>
To: Simon Horman <horms@verge.net.au>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Julian Anastasov <ja@ssi.bg>, lvs-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: improved SH fallback strategy
Message-ID: <20130925090150.GC19768@eldamar.org.uk>
References: <20130923115139.GA15034@eldamar.org.uk>
 <524099BA.5020303@cogentembedded.com>
 <20130924093238.GD18494@eldamar.org.uk>
 <20130925003033.GG26081@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925003033.GG26081@verge.net.au>
X-GPG-Key-Fingerprint: 7820 960F C361 C9CE 401F  D07D 993A 2951 D970 4FA4
X-Operating-System: Linux 3.2.0-41-generic
X-Editor: Vi
X-Uptime: 10:32:43 up 134 days, 19:57, 11 users,  load average: 0.31, 0.43,
 0.45
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> could you add some comments to the code or at least a description of the
> algorithm to the above the function.  The intent of original code may not
> have been obvious to the eye but this version certainly isn't obvious to
> mine.

Sure.  I have a bad habit of assuming that if I understand something,
then others automatically do too. :-)

The original code went through the table, starting at the same place as
the code without fallback and if that returned an unavailable
realserver, it offset the hash by one and repeated the lookup, then added
two, etc., up to IP_VS_SH_TAB_SIZE-1.  So the hash offset was 0,
1, ..., IP_VS_SH_TAB_SIZE-1.

The result is that if a server is down, all traffic destined for it
would fall back onto the next server in the list.

The new code also starts at the same place as the old code (offset 0),
but if that fails, it uses the same fallback strategy as the old code,
but the hash offset is now ihash, ihash + 1, ..., IP_VS_SH_TAB_SIZE-1,
0, 1, ..., ihash - 1, i.e., it starts at ihash instead of 0 and loops
around the table.  ihash could have been a random number, but choosing
it to be something based on the source IP and port (in which case it may
as well be the same hash [offset 0]) means that the behaviour will be
the same on different directors. 

This spreads the load of an unavailable server across the remaining
servers instead of just moving it to the next one in the list.

Hope that makes sense...

I'll submit a patch with a comment shortly.


Alex

