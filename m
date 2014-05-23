Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaEWBee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 21:34:34 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35250 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaEWBec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 21:34:32 -0400
Message-ID: <1400808739.19982.48.camel@debian>
Subject: Re: [PATCH v2] x86/mce: Distirbute the clear operation of
 mces_seen to Per-CPU rather than only monarch CPU
From: Chen Yucong <slaoub@gmail.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F328115FD@ORSMSX114.amr.corp.intel.com>
References: <1400551885-13828-1-git-send-email-slaoub@gmail.com>
	 <537C040E.3040901@jp.fujitsu.com> <1400637782.14703.32.camel@debian>
	 <537C12BC.6080408@jp.fujitsu.com> <1400642398.14703.42.camel@debian>
	 <537C1F24.8000604@jp.fujitsu.com>
	 <3908561D78D1C84285E8C5FCA982C28F328115FD@ORSMSX114.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 May 2014 09:32:19 +0800
Mime-Version: 1.0
X-Mailer: Evolution 3.4.4-3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-21 at 21:09 +0000, Luck, Tony wrote:

> Please do give us more detail on the scenario that you see that would
> make your new version behave better.
> 
> I'm sure the current code has no races w.r.t. clearing mces_seen. The
> monarch clears them all in mce_reign() before clearing mce_executing
> at the foot of mce_end() and allowing the others to run again.
> 
Right. There are not races for cleaning mces_seen. But, if a timeout
occurs in monarch, mces_seen will be not cleaned. It will affect all
other CPUs.
As Borislav Petkov says, if we reach a timeout, there is very little
chance for recovering. Thought. the probability for this situation to
happen is very slight, it's not impossible. Indeed, it's hard to know
the precise causes for timeout.

As Naoya Horiguchi says, this patch also have a small benefit that it
can reduce the processing time of monarch CPU. 
> Your code has the monarch release all the other cpus from the spinloop
> in mce_end() so they will all rush together through the final lines of
> do_machine_check().  
No. My code just distribute cleaning operation to Per-CPU. And all other
CPUs still have to wait for clearing mce_executing by monarch. 

In fact, mces_seen is just used for system panics as quickly as possible
if there is a truly data corrupting error. So there is not advantage for
cleaning mces_seen in the monarch. 
> Some of them will have work to do if they saw
> errors - they may have to send signals, or log the error. Others can
> fly directly to the end of do_machine_check() and clear MCG_STATUS
> and return to executing whatever code was interrupted.
> 
> So it is possible that some processors will be out doing things that can
> generate another machine check, before others have finished their
> tasks and got to the point to clear mces_seen.(*)
> 
> -Tony
> 
> (*) maybe that doesn't matter because they haven't zeroed MCG_STATUS
> yet - so this second machine check will force those cpus to shutdown. See MCIP
> description in "15.3.1.2 IA32_MCG_STATUS_MSR" section of software
> developer manual.
Right. This I also know. This is the reason why you can find the
following snippet in my code:

       /*
        * Now clear the mces_seen of current CPU -*final - so that it
does not
        * reappear on the next mce.
        */
       memset(final, 0, sizeof(struct mce));
       mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);

---
Thanks very much for your reply.
cyc




