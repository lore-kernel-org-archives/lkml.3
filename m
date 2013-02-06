Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3BFQHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:07:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27268 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab3BFQHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:07:22 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_Bp3_fu7e2UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wIfm1DkAj9kA:10 a=uYVGJH5IAAAA:8 a=dprfMjs3EWEHZhD5L78A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360166840.2621.45.camel@gandalf.local.home>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Date: Wed, 06 Feb 2013 11:07:20 -0500
In-Reply-To: <51127D15.7080503@candelatech.com>
References: <5111AD8D.1080005@candelatech.com>
	    <20130206015430.GA9161@home.goodmis.org>
	   <5111BF51.5010607@candelatech.com>
	   <1360119124.2621.37.camel@gandalf.local.home>
	   <5111CE60.4080403@candelatech.com>
	  <1360125419.2621.39.camel@gandalf.local.home>
	  <5111F6F6.7010402@candelatech.com>
	 <1360156888.2621.42.camel@gandalf.local.home>
	 <51127D15.7080503@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-06 at 07:56 -0800, Ben Greear wrote:

> > I'm 99% sure that the bug is in your modifications.
> 
> I'm sorry, I tried to make that clear.

You said it was an out of tree module, I didn't realize it had changes
to the core Linux as well.


> My tree is here, minus a few debugging patches related to this bug:
> 
> http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.7.dev.y/.git;a=summary

Here's your bug:

3319         list_for_each_entry_rcu(ptype, &ptype_all, list) {
3320                 if (!ptype->dev || ptype->dev == skb->dev) {
3321                         if (pt_prev) {
3322                                 ret = deliver_skb(skb, pt_prev, orig_dev);
3323                                 if (ret == NET_RX_CONSUMED) {
3324                                         kfree_skb(skb); /* we made a copy in deliver_skb */
3325                                         goto out;
3326                                 }
3327                         }

One of many. All those "goto out;"s skip the rcu_read_unlock().

-- Steve


