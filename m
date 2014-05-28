Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaE1FJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 01:09:58 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40676 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaE1FJ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 01:09:57 -0400
References: <cover.1400607328.git.tony.luck@intel.com> <eb791998a8ada97b204dddf2719a359149e9ae31.1400607328.git.tony.luck@intel.com> <20140523033438.GC16945@gchen.bj.intel.com> <CA+8MBb+Una+Z5Q-Pn0OoMYaaSx9sPJ3fdriMRMgN=CE1Jdp7Cg@mail.gmail.com> <20140527161613.GC4108@mcs.anl.gov> <5384d07e.4504e00a.2680.ffff8c31SMTPIN_ADDED_BROKEN@mx.google.com> <CA+8MBbKuBo4c2v-Y0TOk-LUJuyJsGG=twqQyAPG5WOa8Aj4GyA@mail.gmail.com> <53852abb.867ce00a.3cef.3c7eSMTPIN_ADDED_BROKEN@mx.google.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <53852abb.867ce00a.3cef.3c7eSMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <FDBACF11-D9F6-4DE5-A0D4-800903A243B7@gmail.com>
Cc: "iskra@mcs.anl.gov" <iskra@mcs.anl.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@suse.de>,
        "gong.chen@linux.jf.intel.com" <gong.chen@linux.jf.intel.com>
X-Mailer: iPhone Mail (11D201)
From: Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH 1/2] memory-failure: Send right signal code to correct thread
Date: Tue, 27 May 2014 22:09:54 -0700
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm exploring options to see what writers of threaded applications might want/need. I'm very doubtful that they would really want "broadcast to all threads". What if there are hundreds or thousands of threads? We send the signals from the context of the thread that hit the error. But that might take a while. Meanwhile any of those threads that were already scheduled on other CPUs are back running again. So there are big races even if we broadcast.

Sent from my iPhone

> On May 27, 2014, at 17:15, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> 
> On Tue, May 27, 2014 at 03:53:55PM -0700, Tony Luck wrote:
>>> - make sure that every thread in a recovery aware application should have
>>>   a SIGBUS handler, inside which
>>>   * code for SIGBUS(BUS_MCEERR_AR) is enabled for every thread
>>>   * code for SIGBUS(BUS_MCEERR_AO) is enabled only for a dedicated thread
>> 
>> But how does the kernel know which is the special thread that
>> should see the "AO" signal?  Broadcasting the signal to all
>> threads seems to be just as likely to cause problems to
>> an application as the h/w broadcasting MCE to all processors.
> 
> I thought that kernel doesn't have to know about which thread is the
> special one if the AO signal is broadcasted to all threads, because
> in such case the special thread always gets the AO signal.
> 
> The reported problem happens only the application sets PF_MCE_EARLY flag,
> and such application is surely recovery aware, so we can assume that the
> coders must implement SIGBUS handler for all threads. Then all other threads
> but the special one can intentionally ignore AO signal. This is to avoid the
> default behavior for SIGBUS ("kill all threads" as Kamil said in the previous
> email.)
> 
> And I hope that downside of signal broadcasting is smaller than MCE
> broadcasting because the range of broadcasting is limited to a process group,
> not to the whole system.
> 
> # I don't intend to rule out other possibilities like adding another prctl
> # flag, so if you have a patch, that's would be great.
> 
> Thanks,
> Naoya Horiguchi
