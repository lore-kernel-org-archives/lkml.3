Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaEUAuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 20:50:10 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:57299 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaEUAuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 20:50:07 -0400
Message-ID: <1400633304.14703.2.camel@debian>
Subject: Re: [PATCH v2] x86/mce: Distirbute the clear operation of mces_seen
 to Per-CPU rather than only monarch CPU
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, ak@linux.intel.com, ying.huang@intel.com,
        seto.hidetoshi@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org
Date: Wed, 21 May 2014 08:48:24 +0800
In-Reply-To: <20140520173308.GE16428@pd.tnic>
References: <1400551885-13828-1-git-send-email-slaoub@gmail.com>
	 <20140520173308.GE16428@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-20 at 19:33 +0200, Borislav Petkov wrote:
> On Tue, May 20, 2014 at 10:11:25AM +0800, Chen Yucong wrote:
> > mces_seen is a Per-CPU variable which should only be accessed by
> > Per-CPU as possible. So the clear operation of mces_seen should also
> > be lcoal to Per-CPU rather than monarch CPU.
> >
> > Meanwhile, there is also a potential risk that mces_seen will not
> > be be cleared if a timeout occors in mce_end for monarch CPU. As a
> > reuslt, the stale value of mces_seen will reappear on the next mce.
> 
> I don't know how many times I have to tell you this already: if we reach
> the timeout, we have a much bigger friggin' problem!

Even if we do not take into account timeout, we should distribute the
clear operation of mces_seen to Per-CPU rather then monarch CPU.
mce_regin, which is only called by monarch CPU, can be used for system
panics as quickly as possible if there is a truly data corrupting error.
But Monarch CPU don't have to help all other CPU to clean mces_clean.
One advantage of Per-CPU is the isolation of errors propagation, being
so, why do not we clean mces_seen by Per-CPU?

You say, "you need to do the cleaning in mce_reign because the monarch
cpu has to run last after all other cpus have scanned their mce banks."
But this is not an adequate explanation.

thx!
cyc

> 
> What you could do instead is make the machine panic in the tolerant==1,
> i.e., the default case, in mce_timed_out().
> 
> Basically, in the case any core is stuck and we reach a timeout, we want
> to panic the whole box immediately. There's a very little chance we can
> recover so panic is the only sane thing left to do.
> 
> Ok?
> 


